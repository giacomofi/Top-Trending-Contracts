['/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /* Token supply got increased and a new owner received these tokens */\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /* Interface declaration */\n', '  function isToken() public constant returns (bool weAre) {\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   *\n', '   * Fix for the ERC20 short address attack\n', '   *\n', '   * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * Atomic increment of approved spending\n', '   *\n', '   * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   *\n', '   */\n', '  function addApproval(address _spender, uint _addedValue)\n', '  returns (bool success) {\n', '      uint oldValue = allowed[msg.sender][_spender];\n', '      allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);\n', '      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '  }\n', '\n', '  /**\n', '   * Atomic decrement of approved spending.\n', '   *\n', '   * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   */\n', '  function subApproval(address _spender, uint _subtractedValue)\n', '  returns (bool success) {\n', '\n', '      uint oldVal = allowed[msg.sender][_spender];\n', '\n', '      if (_subtractedValue > oldVal) {\n', '          allowed[msg.sender][_spender] = 0;\n', '      } else {\n', '          allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);\n', '      }\n', '      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * Hold tokens for a group investor of investors until the unlock date.\n', ' *\n', ' * After the unlock date the investor can claim their tokens.\n', ' *\n', ' * Steps\n', ' *\n', ' * - Prepare a spreadsheet for token allocation\n', ' * - Deploy this contract, with the sum to tokens to be distributed, from the owner account\n', ' * - Call setInvestor for all investors from the owner account using a local script and CSV input\n', ' * - Move tokensToBeAllocated in this contract using StandardToken.transfer()\n', ' * - Call lock from the owner account\n', ' * - Wait until the freeze period is over\n', ' * - After the freeze time is over investors can call claim() from their address to get their tokens\n', ' *\n', ' */\n', 'contract TokenVault is Ownable {\n', '\n', '  /** How many investors we have now */\n', '  uint public investorCount;\n', '\n', '  /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/\n', '  uint public tokensToBeAllocated;\n', '\n', '  /** How many tokens investors have claimed so far */\n', '  uint public totalClaimed;\n', '\n', '  /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */\n', '  uint public tokensAllocatedTotal;\n', '\n', '  /** How much we have allocated to the investors invested */\n', '  mapping(address => uint) public balances;\n', '\n', '  /** How many tokens investors have claimed */\n', '  mapping(address => uint) public claimed;\n', '\n', '  /** When our claim freeze is over (UNIX timestamp) */\n', '  uint public freezeEndsAt;\n', '\n', '  /** When this vault was locked (UNIX timestamp) */\n', '  uint public lockedAt;\n', '\n', '  /** We can also define our own token, which will override the ICO one ***/\n', '  StandardToken public token;\n', '\n', '  /** What is our current state.\n', '   *\n', '   * Loading: Investor data is being loaded and contract not yet locked\n', '   * Holding: Holding tokens for investors\n', '   * Distributing: Freeze time is over, investors can claim their tokens\n', '   */\n', '  enum State{Unknown, Loading, Holding, Distributing}\n', '\n', '  /** We allocated tokens for investor */\n', '  event Allocated(address investor, uint value);\n', '\n', '  /** We distributed tokens to an investor */\n', '  event Distributed(address investors, uint count);\n', '\n', '  event Locked();\n', '\n', '  /**\n', '   * Create presale contract where lock up period is given days\n', '   *\n', '   * @param _owner Who can load investor data and lock\n', '   * @param _freezeEndsAt UNIX timestamp when the vault unlocks\n', '   * @param _token Token contract address we are distributing\n', '   * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation\n', '   *\n', '   */\n', '  function TokenVault(address _owner, uint _freezeEndsAt, StandardToken _token, uint _tokensToBeAllocated) {\n', '\n', '    owner = _owner;\n', '\n', '    // Invalid owenr\n', '    if(owner == 0) {\n', '      throw;\n', '    }\n', '\n', '    token = _token;\n', '\n', '    // Check the address looks like a token contract\n', '    if(!token.isToken()) {\n', '      throw;\n', '    }\n', '\n', '    // Give argument\n', '    if(_freezeEndsAt == 0) {\n', '      throw;\n', '    }\n', '\n', '    // Sanity check on _tokensToBeAllocated\n', '    if(_tokensToBeAllocated == 0) {\n', '      throw;\n', '    }\n', '\n', '    freezeEndsAt = _freezeEndsAt;\n', '    tokensToBeAllocated = _tokensToBeAllocated;\n', '  }\n', '\n', '  /// @dev Add a presale participating allocation\n', '  function setInvestor(address investor, uint amount) public onlyOwner {\n', '\n', '    if(lockedAt > 0) {\n', '      // Cannot add new investors after the vault is locked\n', '      throw;\n', '    }\n', '\n', '    if(amount == 0) throw; // No empty buys\n', '\n', "    // Don't allow reset\n", '    if(balances[investor] > 0) {\n', '      throw;\n', '    }\n', '\n', '    balances[investor] = amount;\n', '\n', '    investorCount++;\n', '\n', '    tokensAllocatedTotal += amount;\n', '\n', '    Allocated(investor, amount);\n', '  }\n', '\n', '  /// @dev Lock the vault\n', '  ///      - All balances have been loaded in correctly\n', '  ///      - Tokens are transferred on this vault correctly\n', '  ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.\n', '  function lock() onlyOwner {\n', '\n', '    if(lockedAt > 0) {\n', '      throw; // Already locked\n', '    }\n', '\n', '    // Spreadsheet sum does not match to what we have loaded to the investor data\n', '    if(tokensAllocatedTotal != tokensToBeAllocated) {\n', '      throw;\n', '    }\n', '\n', '    // Do not lock the vault if the given tokens are not on this contract\n', '    if(token.balanceOf(address(this)) != tokensAllocatedTotal) {\n', '      throw;\n', '    }\n', '\n', '    lockedAt = now;\n', '\n', '    Locked();\n', '  }\n', '\n', '  /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.\n', '  function recoverFailedLock() onlyOwner {\n', '    if(lockedAt > 0) {\n', '      throw;\n', '    }\n', '\n', '    // Transfer all tokens on this contract back to the owner\n', '    token.transfer(owner, token.balanceOf(address(this)));\n', '  }\n', '\n', '  /// @dev Get the current balance of tokens in the vault\n', '  /// @return uint How many tokens there are currently in vault\n', '  function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {\n', '    return token.balanceOf(address(this));\n', '  }\n', '\n', '  /// @dev Claim N bought tokens to the investor as the msg sender\n', '  function claim() {\n', '\n', '    address investor = msg.sender;\n', '\n', '    if(lockedAt == 0) {\n', '      throw; // We were never locked\n', '    }\n', '\n', '    if(now < freezeEndsAt) {\n', '      throw; // Trying to claim early\n', '    }\n', '\n', '    if(balances[investor] == 0) {\n', '      // Not our investor\n', '      throw;\n', '    }\n', '\n', '    if(claimed[investor] > 0) {\n', '      throw; // Already claimed\n', '    }\n', '\n', '    uint amount = balances[investor];\n', '\n', '    claimed[investor] = amount;\n', '\n', '    totalClaimed += amount;\n', '\n', '    token.transfer(investor, amount);\n', '\n', '    Distributed(investor, amount);\n', '  }\n', '\n', '  /// @dev Resolve the contract umambigious state\n', '  function getState() public constant returns(State) {\n', '    if(lockedAt == 0) {\n', '      return State.Loading;\n', '    } else if(now > freezeEndsAt) {\n', '      return State.Distributing;\n', '    } else {\n', '      return State.Holding;\n', '    }\n', '  }\n', '\n', '}']
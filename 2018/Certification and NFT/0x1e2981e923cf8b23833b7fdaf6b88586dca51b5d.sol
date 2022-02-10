['/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract Recoverable is Ownable {\n', '\n', '  /// @dev Empty constructor (for now)\n', '  function Recoverable() {\n', '  }\n', '\n', '  /// @dev This will be invoked by the owner, when owner wants to rescue tokens\n', '  /// @param token Token which will we rescue to the owner from the contract\n', '  function recoverTokens(ERC20Basic token) onlyOwner public {\n', '    token.transfer(owner, tokensToBeReturned(token));\n', '  }\n', '\n', '  /// @dev Interface function, can be overwritten by the superclass\n', '  /// @param token Token which balance we will check and return\n', '  /// @return The amount of tokens (in smallest denominator) the contract owns\n', '  function tokensToBeReturned(ERC20Basic token) public returns (uint) {\n', '    return token.balanceOf(this);\n', '  }\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '/**\n', ' * Safe unsigned safe math.\n', ' *\n', ' * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli\n', ' *\n', ' * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol\n', ' *\n', ' * Maintained here until merged to mainline zeppelin-solidity.\n', ' *\n', ' */\n', 'library SafeMathLib {\n', '\n', '  function times(uint a, uint b) returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function minus(uint a, uint b) returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function plus(uint a, uint b) returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net\n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard EIP-20 token with an interface marker.\n', ' *\n', ' * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.\n', ' *\n', ' */\n', 'contract StandardTokenExt is StandardToken {\n', '\n', '  /* Interface declaration */\n', '  function isToken() public constant returns (bool weAre) {\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Hold tokens for a group investor of investors until the unlock date.\n', ' *\n', ' * After the unlock date the investor can claim their tokens.\n', ' *\n', ' * Steps\n', ' *\n', ' * - Prepare a spreadsheet for token allocation\n', ' * - Deploy this contract, with the sum to tokens to be distributed, from the owner account\n', ' * - Call setInvestor for all investors from the owner account using a local script and CSV input\n', ' * - Move tokensToBeAllocated in this contract using StandardToken.transfer()\n', ' * - Call lock from the owner account\n', ' * - Wait until the freeze period is over\n', ' * - After the freeze time is over investors can call claim() from their address to get their tokens\n', ' *\n', ' */\n', 'contract TokenVault is Ownable, Recoverable {\n', '  using SafeMathLib for uint;\n', '\n', '  /** How many investors we have now */\n', '  uint public investorCount;\n', '\n', '  /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/\n', '  uint public tokensToBeAllocated;\n', '\n', '  /** How many tokens investors have claimed so far */\n', '  uint public totalClaimed;\n', '\n', '  /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */\n', '  uint public tokensAllocatedTotal;\n', '\n', '  /** How much we have allocated to the investors invested */\n', '  mapping(address => uint) public balances;\n', '\n', '  /** How many tokens investors have claimed */\n', '  mapping(address => uint) public claimed;\n', '\n', '  /** When was the last claim by an investor **/\n', '  mapping(address => uint) public lastClaimedAt;\n', '\n', '  /** When our claim freeze is over (UNIX timestamp) */\n', '  uint public freezeEndsAt;\n', '\n', '  /** When this vault was locked (UNIX timestamp) */\n', '  uint public lockedAt;\n', '\n', '  /** defining the tap **/\n', '  uint public tokensPerSecond;\n', '\n', '  /** We can also define our own token, which will override the ICO one ***/\n', '  StandardTokenExt public token;\n', '\n', '  /** What is our current state.\n', '   *\n', '   * Loading: Investor data is being loaded and contract not yet locked\n', '   * Holding: Holding tokens for investors\n', '   * Distributing: Freeze time is over, investors can claim their tokens\n', '   */\n', '  enum State{Unknown, Loading, Holding, Distributing}\n', '\n', '  /** We allocated tokens for investor */\n', '  event Allocated(address investor, uint value);\n', '\n', '  /** We distributed tokens to an investor */\n', '  event Distributed(address investors, uint count);\n', '\n', '  event Locked();\n', '\n', '  /**\n', '   * Create presale contract where lock up period is given days\n', '   *\n', '   * @param _owner Who can load investor data and lock\n', '   * @param _freezeEndsAt UNIX timestamp when the vault unlocks\n', '   * @param _token Token contract address we are distributing\n', '   * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplication\n', '   * @param _tokensPerSecond Define the tap: how many tokens we permit an user to withdraw per second, 0 to disable\n', '   */\n', '  function TokenVault(address _owner, uint _freezeEndsAt, StandardTokenExt _token, uint _tokensToBeAllocated, uint _tokensPerSecond) {\n', '\n', '    owner = _owner;\n', '\n', '    // Invalid owenr\n', '    if(owner == 0) {\n', '      throw;\n', '    }\n', '\n', '    token = _token;\n', '\n', '    // Check the address looks like a token contract\n', '    if(!token.isToken()) {\n', '      throw;\n', '    }\n', '\n', '    // Give argument\n', '    if(_freezeEndsAt == 0) {\n', '      throw;\n', '    }\n', '\n', '    // Sanity check on _tokensToBeAllocated\n', '    if(_tokensToBeAllocated == 0) {\n', '      throw;\n', '    }\n', '\n', '    if (_freezeEndsAt < now) {\n', '      freezeEndsAt = now;\n', '    } else {\n', '      freezeEndsAt = _freezeEndsAt;\n', '    }\n', '    tokensToBeAllocated = _tokensToBeAllocated;\n', '    tokensPerSecond = _tokensPerSecond;\n', '  }\n', '\n', '  /// @dev Add a presale participating allocation\n', '  function setInvestor(address investor, uint amount) public onlyOwner {\n', '\n', '    if(lockedAt > 0) {\n', '      // Cannot add new investors after the vault is locked\n', '      throw;\n', '    }\n', '\n', '    if(amount == 0) throw; // No empty buys\n', '\n', '    // Don&#39;t allow reset\n', '    if(balances[investor] > 0) {\n', '      throw;\n', '    }\n', '\n', '    balances[investor] = amount;\n', '\n', '    investorCount++;\n', '\n', '    tokensAllocatedTotal += amount;\n', '\n', '    Allocated(investor, amount);\n', '  }\n', '\n', '  /// @dev Lock the vault\n', '  ///      - All balances have been loaded in correctly\n', '  ///      - Tokens are transferred on this vault correctly\n', '  ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.\n', '  function lock() onlyOwner {\n', '\n', '    if(lockedAt > 0) {\n', '      throw; // Already locked\n', '    }\n', '\n', '    // Spreadsheet sum does not match to what we have loaded to the investor data\n', '    if(tokensAllocatedTotal != tokensToBeAllocated) {\n', '      throw;\n', '    }\n', '\n', '    // Do not lock the vault if the given tokens are not on this contract\n', '    if(token.balanceOf(address(this)) != tokensAllocatedTotal) {\n', '      throw;\n', '    }\n', '\n', '    lockedAt = now;\n', '\n', '    Locked();\n', '  }\n', '\n', '  /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.\n', '  function recoverFailedLock() onlyOwner {\n', '    if(lockedAt > 0) {\n', '      throw;\n', '    }\n', '\n', '    // Transfer all tokens on this contract back to the owner\n', '    token.transfer(owner, token.balanceOf(address(this)));\n', '  }\n', '\n', '  /// @dev Get the current balance of tokens in the vault\n', '  /// @return uint How many tokens there are currently in vault\n', '  function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {\n', '    return token.balanceOf(address(this));\n', '  }\n', '\n', '  /// @dev Check how many tokens "investor" can claim\n', '  /// @param investor Address of the investor\n', '  /// @return uint How many tokens the investor can claim now\n', '  function getCurrentlyClaimableAmount(address investor) public constant returns (uint claimableAmount) {\n', '    uint maxTokensLeft = balances[investor] - claimed[investor];\n', '\n', '    if (now < freezeEndsAt) {\n', '      return 0;\n', '    }\n', '\n', '    if (tokensPerSecond > 0) {\n', '      uint previousClaimAt = lastClaimedAt[investor];\n', '      uint maxClaim;\n', '\n', '      if (previousClaimAt == 0) {\n', '        previousClaimAt = freezeEndsAt;\n', '      }\n', '\n', '      maxClaim = (now - previousClaimAt) * tokensPerSecond;\n', '\n', '      if (maxClaim > maxTokensLeft) {\n', '        return maxTokensLeft;\n', '      } else {\n', '        return maxClaim;\n', '      }\n', '    } else {\n', '      return maxTokensLeft;\n', '    }\n', '  }\n', '\n', '  /// @dev Claim N bought tokens to the investor as the msg sender\n', '  function claim() {\n', '\n', '    address investor = msg.sender;\n', '\n', '    if(lockedAt == 0) {\n', '      throw; // We were never locked\n', '    }\n', '\n', '    if(now < freezeEndsAt) {\n', '      throw; // Trying to claim early\n', '    }\n', '\n', '    if(balances[investor] == 0) {\n', '      // Not our investor\n', '      throw;\n', '    }\n', '\n', '    uint amount = getCurrentlyClaimableAmount(investor);\n', '    require (amount > 0);\n', '\n', '    lastClaimedAt[investor] = now;\n', '\n', '    claimed[investor] += amount;\n', '\n', '    totalClaimed += amount;\n', '\n', '    token.transfer(investor, amount);\n', '\n', '    Distributed(investor, amount);\n', '  }\n', '\n', '  /// @dev This function is prototyped in Recoverable contract\n', '  function tokensToBeReturned(ERC20Basic tokenToClaim) public returns (uint) {\n', '    if (address(tokenToClaim) == address(token)) {\n', '      return getBalance().minus(tokensAllocatedTotal);\n', '    } else {\n', '      return tokenToClaim.balanceOf(this);\n', '    }\n', '  }\n', '\n', '  /// @dev Resolve the contract umambigious state\n', '  function getState() public constant returns(State) {\n', '    if(lockedAt == 0) {\n', '      return State.Loading;\n', '    } else if(now > freezeEndsAt) {\n', '      return State.Distributing;\n', '    } else {\n', '      return State.Holding;\n', '    }\n', '  }\n', '\n', '}']
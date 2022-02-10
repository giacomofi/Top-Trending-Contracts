['pragma solidity ^0.4.11;\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '// ERC223\n', 'contract ContractReceiver {\n', '  function tokenFallback(address from, uint value);\n', '}\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      revert();\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /* Token supply got increased and a new owner received these tokens */\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /**\n', '   *\n', '   * Fix for the ERC20 short address attack\n', '   *\n', '   * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length != size + 4) {\n', '       revert();\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '\n', '    if (isContract(_to)) {\n', '      ContractReceiver rx = ContractReceiver(_to);\n', '      rx.tokenFallback(msg.sender, _value);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  // ERC223 fetch contract size (must be nonzero to be a contract)\n', '  function isContract( address _addr ) private returns (bool) {\n', '    uint length;\n', '    _addr = _addr;\n', '    assembly { length := extcodesize(_addr) }\n', '    return (length > 0);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) revert();\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * Atomic increment of approved spending\n', '   *\n', '   * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   *\n', '   */\n', '  function addApproval(address _spender, uint _addedValue)\n', '  onlyPayloadSize(2 * 32)\n', '  returns (bool success) {\n', '      uint oldValue = allowed[msg.sender][_spender];\n', '      allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);\n', '      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '  }\n', '\n', '  /**\n', '   * Atomic decrement of approved spending.\n', '   *\n', '   * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   */\n', '  function subApproval(address _spender, uint _subtractedValue)\n', '  onlyPayloadSize(2 * 32)\n', '  returns (bool success) {\n', '\n', '      uint oldVal = allowed[msg.sender][_spender];\n', '\n', '      if (_subtractedValue > oldVal) {\n', '          allowed[msg.sender][_spender] = 0;\n', '      } else {\n', '          allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);\n', '      }\n', '      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '  address public constant BURN_ADDRESS = 0;\n', '\n', '  /** How many tokens we burned */\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '  /**\n', '   * Burn extra tokens from a balance.\n', '   *\n', '   */\n', '  function burn(uint burnAmount) {\n', '    address burner = msg.sender;\n', '    balances[burner] = safeSub(balances[burner], burnAmount);\n', '    totalSupply = safeSub(totalSupply, burnAmount);\n', '    Burned(burner, burnAmount);\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * Upgrade agent interface inspired by Lunyr.\n', ' *\n', ' * Upgrade agent transfers tokens to a new contract.\n', ' * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.\n', ' */\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  /** Interface marker */\n', '  function isUpgradeAgent() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function upgradeFrom(address _from, uint256 _value) public;\n', '\n', '}\n', '\n', '\n', '/**\n', ' * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.\n', ' *\n', ' * First envisioned by Golem and Lunyr projects.\n', ' */\n', 'contract UpgradeableToken is StandardToken {\n', '\n', '  /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */\n', '  address public upgradeMaster;\n', '\n', '  /** The next contract where the tokens will be migrated. */\n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  /** How many tokens we have upgraded by now. */\n', '  uint256 public totalUpgraded;\n', '\n', '  /**\n', '   * Upgrade states.\n', '   *\n', '   * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun\n', '   * - WaitingForAgent: Token allows upgrade, but we don&#39;t have a new agent yet\n', '   * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet\n', '   * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens\n', '   *\n', '   */\n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '  /**\n', '   * Somebody has upgraded some of his tokens.\n', '   */\n', '  event Upgrade(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  /**\n', '   * New upgrade agent available.\n', '   */\n', '  event UpgradeAgentSet(address agent);\n', '\n', '  /**\n', '   * Do not allow construction without upgrade master set.\n', '   */\n', '  function UpgradeableToken(address _upgradeMaster) {\n', '    upgradeMaster = _upgradeMaster;\n', '  }\n', '\n', '  /**\n', '   * Allow the token holder to upgrade some of their tokens to a new contract.\n', '   */\n', '  function upgrade(uint256 value) public {\n', '\n', '      UpgradeState state = getUpgradeState();\n', '      if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {\n', '        // Called in a bad state\n', '        revert();\n', '      }\n', '\n', '      // Validate input value.\n', '      if (value == 0) revert();\n', '\n', '      balances[msg.sender] = safeSub(balances[msg.sender], value);\n', '\n', '      // Take tokens out from circulation\n', '      totalSupply = safeSub(totalSupply, value);\n', '      totalUpgraded = safeAdd(totalUpgraded, value);\n', '\n', '      // Upgrade agent reissues the tokens\n', '      upgradeAgent.upgradeFrom(msg.sender, value);\n', '      Upgrade(msg.sender, upgradeAgent, value);\n', '  }\n', '\n', '  /**\n', '   * Set an upgrade agent that handles\n', '   */\n', '  function setUpgradeAgent(address agent) external {\n', '\n', '      if(!canUpgrade()) {\n', '        // The token is not yet in a state that we could think upgrading\n', '        revert();\n', '      }\n', '\n', '      if (agent == 0x0) revert();\n', '      // Only a master can designate the next agent\n', '      if (msg.sender != upgradeMaster) revert();\n', '      // Upgrade has already begun for an agent\n', '      if (getUpgradeState() == UpgradeState.Upgrading) revert();\n', '\n', '      upgradeAgent = UpgradeAgent(agent);\n', '\n', '      // Bad interface\n', '      if(!upgradeAgent.isUpgradeAgent()) revert();\n', '      // Make sure that token supplies match in source and target\n', '      if (upgradeAgent.originalSupply() != totalSupply) revert();\n', '\n', '      UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  /**\n', '   * Get the state of the token upgrade.\n', '   */\n', '  function getUpgradeState() public constant returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  /**\n', '   * Change the upgrade master.\n', '   *\n', '   * This allows us to set a new owner for the upgrade mechanism.\n', '   */\n', '  function setUpgradeMaster(address master) public {\n', '      if (master == 0x0) revert();\n', '      if (msg.sender != upgradeMaster) revert();\n', '      upgradeMaster = master;\n', '  }\n', '\n', '  /**\n', '   * Child contract can enable to provide the condition when the upgrade can begun.\n', '   */\n', '  function canUpgrade() public constant returns(bool) {\n', '     return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BCOExtendedToken is BurnableToken, UpgradeableToken {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '  address public owner;\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  mapping(address => uint) public previligedBalances;\n', '\n', '  /** List of agents that are allowed to create new tokens */\n', '  mapping(address => bool) public mintAgents;\n', '  event MintingAgentChanged(address addr, bool state);\n', '\n', '  modifier onlyOwner() {\n', '    if(msg.sender != owner) revert();\n', '    _;\n', '  }\n', '\n', '  modifier onlyMintAgent() {\n', '    // Only crowdsale contracts are allowed to mint new tokens\n', '    if(!mintAgents[msg.sender]) revert();\n', '    _;\n', '  }\n', '\n', '  /** Make sure we are not done yet. */\n', '  modifier canMint() {\n', '    if(mintingFinished) revert();\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '  function BCOExtendedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    totalSupply = _totalSupply;\n', '    decimals = _decimals;\n', '\n', '    // Allocate initial balance to the owner\n', '    balances[_owner] = _totalSupply;\n', '\n', '    // save the owner\n', '    owner = _owner;\n', '  }\n', '\n', '  // privileged transfer\n', '  function transferPrivileged(address _to, uint _value) onlyOwner returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  // get priveleged balance\n', '  function getPrivilegedBalance(address _owner) constant returns (uint balance) {\n', '    return previligedBalances[_owner];\n', '  }\n', '\n', '  // admin only can transfer from the privileged accounts\n', '  function transferFromPrivileged(address _from, address _to, uint _value) onlyOwner returns (bool success) {\n', '    uint availablePrevilegedBalance = previligedBalances[_from];\n', '\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Create new tokens and allocate them to an address..\n', '   *\n', '   * Only callably by a crowdsale contract (mint agent).\n', '   */\n', '  function mint(address receiver, uint amount) onlyMintAgent canMint public {\n', '    totalSupply = safeAdd(totalSupply, amount);\n', '    balances[receiver] = safeAdd(balances[receiver], amount);\n', '\n', '    // This will make the mint transaction apper in EtherScan.io\n', '    // We can remove this after there is a standardized minting event\n', '    Transfer(0, receiver, amount);\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a crowdsale contract to mint new tokens.\n', '   */\n', '  function setMintAgent(address addr, bool state) onlyOwner canMint public {\n', '    mintAgents[addr] = state;\n', '    MintingAgentChanged(addr, state);\n', '  }\n', '\n', '}\n', '\n', 'contract SaleExtendedBCO {\n', '    address public beneficiary;\n', '    uint public startline;\n', '    uint public deadline;\n', '    uint public price;\n', '    uint public amountRaised;\n', '    uint public incomingTokensTransactions;\n', '\n', '    mapping(address => uint) public actualGotETH;\n', '    BCOExtendedToken public tokenReward;\n', '\n', '    event TokenFallback( address indexed from,\n', '                         uint256 value);\n', '\n', '    modifier onlyOwner() {\n', '        if(msg.sender != beneficiary) revert();\n', '        _;\n', '    }\n', '\n', '    modifier whenCrowdsaleIsFinished() {\n', '        if(now < deadline) revert();\n', '        _;\n', '    }\n', '\n', '    modifier whenRefundAvailable() {\n', '        if(tokenReward.balanceOf(address(this)) <= 0) revert();\n', '        _;\n', '    }\n', '\n', '    function SaleExtendedBCO(\n', '        uint start,\n', '        uint end,\n', '        uint costOfEachToken,\n', '        BCOExtendedToken addressOfTokenUsedAsReward\n', '    ) {\n', '        beneficiary = msg.sender;\n', '        startline = start;\n', '        deadline = end;\n', '        price = costOfEachToken;\n', '        tokenReward = BCOExtendedToken(addressOfTokenUsedAsReward);\n', '    }\n', '\n', '    function () payable {\n', '        if (now <= startline) revert();\n', '        if (now >= deadline) revert();\n', '\n', '        uint amount = msg.value;\n', '        if (amount < price) revert();\n', '\n', '        amountRaised += amount;\n', '\n', '        uint tokensToSend = amount / price;\n', '\n', '        actualGotETH[msg.sender] += amount;\n', '\n', '        tokenReward.transfer(msg.sender, tokensToSend);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            beneficiary = newOwner;\n', '        }\n', '    }\n', '\n', '    function Refund() whenRefundAvailable whenCrowdsaleIsFinished {\n', '        msg.sender.transfer(actualGotETH[msg.sender]);\n', '    }\n', '\n', '    function WithdrawETH(uint amount) onlyOwner {\n', '        beneficiary.transfer(amount);\n', '    }\n', '\n', '    function WithdrawAllETH() onlyOwner {\n', '        beneficiary.transfer(amountRaised);\n', '    }\n', '\n', '    function WithdrawTokens(uint amount) onlyOwner {\n', '        tokenReward.transfer(beneficiary, amount);\n', '    }\n', '\n', '    function ChangeCost(uint costOfEachToken) onlyOwner {\n', '        price = costOfEachToken;\n', '    }\n', '\n', '    function ChangeStart(uint start) onlyOwner {\n', '        startline = start;\n', '    }\n', '\n', '    function ChangeEnd(uint end) onlyOwner {\n', '        deadline = end;\n', '    }\n', '\n', '    // ERC223\n', '    // function in contract &#39;ContractReceiver&#39;\n', '    function tokenFallback(address from, uint value) {\n', '        incomingTokensTransactions += 1;\n', '        TokenFallback(from, value);\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '// ERC223\n', 'contract ContractReceiver {\n', '  function tokenFallback(address from, uint value);\n', '}\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      revert();\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /* Token supply got increased and a new owner received these tokens */\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /**\n', '   *\n', '   * Fix for the ERC20 short address attack\n', '   *\n', '   * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length != size + 4) {\n', '       revert();\n', '     }\n', '     _;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '\n', '    if (isContract(_to)) {\n', '      ContractReceiver rx = ContractReceiver(_to);\n', '      rx.tokenFallback(msg.sender, _value);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  // ERC223 fetch contract size (must be nonzero to be a contract)\n', '  function isContract( address _addr ) private returns (bool) {\n', '    uint length;\n', '    _addr = _addr;\n', '    assembly { length := extcodesize(_addr) }\n', '    return (length > 0);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) revert();\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * Atomic increment of approved spending\n', '   *\n', '   * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   *\n', '   */\n', '  function addApproval(address _spender, uint _addedValue)\n', '  onlyPayloadSize(2 * 32)\n', '  returns (bool success) {\n', '      uint oldValue = allowed[msg.sender][_spender];\n', '      allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);\n', '      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '  }\n', '\n', '  /**\n', '   * Atomic decrement of approved spending.\n', '   *\n', '   * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   */\n', '  function subApproval(address _spender, uint _subtractedValue)\n', '  onlyPayloadSize(2 * 32)\n', '  returns (bool success) {\n', '\n', '      uint oldVal = allowed[msg.sender][_spender];\n', '\n', '      if (_subtractedValue > oldVal) {\n', '          allowed[msg.sender][_spender] = 0;\n', '      } else {\n', '          allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);\n', '      }\n', '      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '  address public constant BURN_ADDRESS = 0;\n', '\n', '  /** How many tokens we burned */\n', '  event Burned(address burner, uint burnedAmount);\n', '\n', '  /**\n', '   * Burn extra tokens from a balance.\n', '   *\n', '   */\n', '  function burn(uint burnAmount) {\n', '    address burner = msg.sender;\n', '    balances[burner] = safeSub(balances[burner], burnAmount);\n', '    totalSupply = safeSub(totalSupply, burnAmount);\n', '    Burned(burner, burnAmount);\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * Upgrade agent interface inspired by Lunyr.\n', ' *\n', ' * Upgrade agent transfers tokens to a new contract.\n', ' * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.\n', ' */\n', 'contract UpgradeAgent {\n', '\n', '  uint public originalSupply;\n', '\n', '  /** Interface marker */\n', '  function isUpgradeAgent() public constant returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function upgradeFrom(address _from, uint256 _value) public;\n', '\n', '}\n', '\n', '\n', '/**\n', ' * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.\n', ' *\n', ' * First envisioned by Golem and Lunyr projects.\n', ' */\n', 'contract UpgradeableToken is StandardToken {\n', '\n', '  /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */\n', '  address public upgradeMaster;\n', '\n', '  /** The next contract where the tokens will be migrated. */\n', '  UpgradeAgent public upgradeAgent;\n', '\n', '  /** How many tokens we have upgraded by now. */\n', '  uint256 public totalUpgraded;\n', '\n', '  /**\n', '   * Upgrade states.\n', '   *\n', '   * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun\n', "   * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet\n", '   * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet\n', '   * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens\n', '   *\n', '   */\n', '  enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}\n', '\n', '  /**\n', '   * Somebody has upgraded some of his tokens.\n', '   */\n', '  event Upgrade(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  /**\n', '   * New upgrade agent available.\n', '   */\n', '  event UpgradeAgentSet(address agent);\n', '\n', '  /**\n', '   * Do not allow construction without upgrade master set.\n', '   */\n', '  function UpgradeableToken(address _upgradeMaster) {\n', '    upgradeMaster = _upgradeMaster;\n', '  }\n', '\n', '  /**\n', '   * Allow the token holder to upgrade some of their tokens to a new contract.\n', '   */\n', '  function upgrade(uint256 value) public {\n', '\n', '      UpgradeState state = getUpgradeState();\n', '      if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {\n', '        // Called in a bad state\n', '        revert();\n', '      }\n', '\n', '      // Validate input value.\n', '      if (value == 0) revert();\n', '\n', '      balances[msg.sender] = safeSub(balances[msg.sender], value);\n', '\n', '      // Take tokens out from circulation\n', '      totalSupply = safeSub(totalSupply, value);\n', '      totalUpgraded = safeAdd(totalUpgraded, value);\n', '\n', '      // Upgrade agent reissues the tokens\n', '      upgradeAgent.upgradeFrom(msg.sender, value);\n', '      Upgrade(msg.sender, upgradeAgent, value);\n', '  }\n', '\n', '  /**\n', '   * Set an upgrade agent that handles\n', '   */\n', '  function setUpgradeAgent(address agent) external {\n', '\n', '      if(!canUpgrade()) {\n', '        // The token is not yet in a state that we could think upgrading\n', '        revert();\n', '      }\n', '\n', '      if (agent == 0x0) revert();\n', '      // Only a master can designate the next agent\n', '      if (msg.sender != upgradeMaster) revert();\n', '      // Upgrade has already begun for an agent\n', '      if (getUpgradeState() == UpgradeState.Upgrading) revert();\n', '\n', '      upgradeAgent = UpgradeAgent(agent);\n', '\n', '      // Bad interface\n', '      if(!upgradeAgent.isUpgradeAgent()) revert();\n', '      // Make sure that token supplies match in source and target\n', '      if (upgradeAgent.originalSupply() != totalSupply) revert();\n', '\n', '      UpgradeAgentSet(upgradeAgent);\n', '  }\n', '\n', '  /**\n', '   * Get the state of the token upgrade.\n', '   */\n', '  function getUpgradeState() public constant returns(UpgradeState) {\n', '    if(!canUpgrade()) return UpgradeState.NotAllowed;\n', '    else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;\n', '    else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;\n', '    else return UpgradeState.Upgrading;\n', '  }\n', '\n', '  /**\n', '   * Change the upgrade master.\n', '   *\n', '   * This allows us to set a new owner for the upgrade mechanism.\n', '   */\n', '  function setUpgradeMaster(address master) public {\n', '      if (master == 0x0) revert();\n', '      if (msg.sender != upgradeMaster) revert();\n', '      upgradeMaster = master;\n', '  }\n', '\n', '  /**\n', '   * Child contract can enable to provide the condition when the upgrade can begun.\n', '   */\n', '  function canUpgrade() public constant returns(bool) {\n', '     return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract BCOExtendedToken is BurnableToken, UpgradeableToken {\n', '\n', '  string public name;\n', '  string public symbol;\n', '  uint public decimals;\n', '  address public owner;\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  mapping(address => uint) public previligedBalances;\n', '\n', '  /** List of agents that are allowed to create new tokens */\n', '  mapping(address => bool) public mintAgents;\n', '  event MintingAgentChanged(address addr, bool state);\n', '\n', '  modifier onlyOwner() {\n', '    if(msg.sender != owner) revert();\n', '    _;\n', '  }\n', '\n', '  modifier onlyMintAgent() {\n', '    // Only crowdsale contracts are allowed to mint new tokens\n', '    if(!mintAgents[msg.sender]) revert();\n', '    _;\n', '  }\n', '\n', '  /** Make sure we are not done yet. */\n', '  modifier canMint() {\n', '    if(mintingFinished) revert();\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '  function BCOExtendedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    totalSupply = _totalSupply;\n', '    decimals = _decimals;\n', '\n', '    // Allocate initial balance to the owner\n', '    balances[_owner] = _totalSupply;\n', '\n', '    // save the owner\n', '    owner = _owner;\n', '  }\n', '\n', '  // privileged transfer\n', '  function transferPrivileged(address _to, uint _value) onlyOwner returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  // get priveleged balance\n', '  function getPrivilegedBalance(address _owner) constant returns (uint balance) {\n', '    return previligedBalances[_owner];\n', '  }\n', '\n', '  // admin only can transfer from the privileged accounts\n', '  function transferFromPrivileged(address _from, address _to, uint _value) onlyOwner returns (bool success) {\n', '    uint availablePrevilegedBalance = previligedBalances[_from];\n', '\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * Create new tokens and allocate them to an address..\n', '   *\n', '   * Only callably by a crowdsale contract (mint agent).\n', '   */\n', '  function mint(address receiver, uint amount) onlyMintAgent canMint public {\n', '    totalSupply = safeAdd(totalSupply, amount);\n', '    balances[receiver] = safeAdd(balances[receiver], amount);\n', '\n', '    // This will make the mint transaction apper in EtherScan.io\n', '    // We can remove this after there is a standardized minting event\n', '    Transfer(0, receiver, amount);\n', '  }\n', '\n', '  /**\n', '   * Owner can allow a crowdsale contract to mint new tokens.\n', '   */\n', '  function setMintAgent(address addr, bool state) onlyOwner canMint public {\n', '    mintAgents[addr] = state;\n', '    MintingAgentChanged(addr, state);\n', '  }\n', '\n', '}\n', '\n', 'contract SaleExtendedBCO {\n', '    address public beneficiary;\n', '    uint public startline;\n', '    uint public deadline;\n', '    uint public price;\n', '    uint public amountRaised;\n', '    uint public incomingTokensTransactions;\n', '\n', '    mapping(address => uint) public actualGotETH;\n', '    BCOExtendedToken public tokenReward;\n', '\n', '    event TokenFallback( address indexed from,\n', '                         uint256 value);\n', '\n', '    modifier onlyOwner() {\n', '        if(msg.sender != beneficiary) revert();\n', '        _;\n', '    }\n', '\n', '    modifier whenCrowdsaleIsFinished() {\n', '        if(now < deadline) revert();\n', '        _;\n', '    }\n', '\n', '    modifier whenRefundAvailable() {\n', '        if(tokenReward.balanceOf(address(this)) <= 0) revert();\n', '        _;\n', '    }\n', '\n', '    function SaleExtendedBCO(\n', '        uint start,\n', '        uint end,\n', '        uint costOfEachToken,\n', '        BCOExtendedToken addressOfTokenUsedAsReward\n', '    ) {\n', '        beneficiary = msg.sender;\n', '        startline = start;\n', '        deadline = end;\n', '        price = costOfEachToken;\n', '        tokenReward = BCOExtendedToken(addressOfTokenUsedAsReward);\n', '    }\n', '\n', '    function () payable {\n', '        if (now <= startline) revert();\n', '        if (now >= deadline) revert();\n', '\n', '        uint amount = msg.value;\n', '        if (amount < price) revert();\n', '\n', '        amountRaised += amount;\n', '\n', '        uint tokensToSend = amount / price;\n', '\n', '        actualGotETH[msg.sender] += amount;\n', '\n', '        tokenReward.transfer(msg.sender, tokensToSend);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            beneficiary = newOwner;\n', '        }\n', '    }\n', '\n', '    function Refund() whenRefundAvailable whenCrowdsaleIsFinished {\n', '        msg.sender.transfer(actualGotETH[msg.sender]);\n', '    }\n', '\n', '    function WithdrawETH(uint amount) onlyOwner {\n', '        beneficiary.transfer(amount);\n', '    }\n', '\n', '    function WithdrawAllETH() onlyOwner {\n', '        beneficiary.transfer(amountRaised);\n', '    }\n', '\n', '    function WithdrawTokens(uint amount) onlyOwner {\n', '        tokenReward.transfer(beneficiary, amount);\n', '    }\n', '\n', '    function ChangeCost(uint costOfEachToken) onlyOwner {\n', '        price = costOfEachToken;\n', '    }\n', '\n', '    function ChangeStart(uint start) onlyOwner {\n', '        startline = start;\n', '    }\n', '\n', '    function ChangeEnd(uint end) onlyOwner {\n', '        deadline = end;\n', '    }\n', '\n', '    // ERC223\n', "    // function in contract 'ContractReceiver'\n", '    function tokenFallback(address from, uint value) {\n', '        incomingTokensTransactions += 1;\n', '        TokenFallback(from, value);\n', '    }\n', '}']

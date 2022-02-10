['pragma solidity ^0.4.11;\n', '\n', '// ================= Ownable Contract start =============================\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '// ================= Ownable Contract end ===============================\n', '\n', '// ================= Safemath Contract start ============================\n', '/* taking ideas from FirstBlood token */\n', 'contract SafeMath {\n', '\n', '  function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '    uint256 z = x + y;\n', '    assert((z >= x) && (z >= y));\n', '    return z;\n', '  }\n', '\n', '  function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '    assert(x >= y);\n', '    uint256 z = x - y;\n', '    return z;\n', '  }\n', '\n', '  function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '    uint256 z = x * y;\n', '    assert((x == 0)||(z/x == y));\n', '    return z;\n', '  }\n', '}\n', '// ================= Safemath Contract end ==============================\n', '\n', '// ================= ERC20 Token Contract start =========================\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '// ================= ERC20 Token Contract end ===========================\n', '\n', '// ================= Standard Token Contract start ======================\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /**\n', '  * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '    require(msg.data.length >= size + 4) ;\n', '    _;\n', '  }\n', '\n', '  mapping(address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)  returns (bool success){\n', '    balances[msg.sender] = safeSubtract(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSubtract(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSubtract(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '// ================= Standard Token Contract end ========================\n', '\n', '// ================= Pausable Token Contract start ======================\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '  * @dev modifier to allow actions only when the contract IS paused\n', '  */\n', '  modifier whenNotPaused() {\n', '    require (!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev modifier to allow actions only when the contract IS NOT paused\n', '  */\n', '  modifier whenPaused {\n', '    require (paused) ;\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev called by the owner to pause, triggers stopped state\n', '  */\n', '  function pause() onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev called by the owner to unpause, returns to normal state\n', '  */\n', '  function unpause() onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '// ================= Pausable Token Contract end ========================\n', '\n', '// ================= IcoToken  start =======================\n', 'contract IcoToken is SafeMath, StandardToken, Pausable {\n', '  string public name;\n', '  string public symbol;\n', '  uint256 public decimals;\n', '  string public version;\n', '  address public icoContract;\n', '\n', '\n', '  function IcoToken(\n', '    string _name,\n', '    string _symbol,\n', '    uint256 _decimals,\n', '    string _version\n', '  )\n', '  {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '    version = _version;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) whenNotPaused returns (bool success) {\n', '    return super.transfer(_to,_value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) whenNotPaused returns (bool success) {\n', '    return super.approve(_spender,_value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return super.balanceOf(_owner);\n', '  }\n', '\n', '  function setIcoContract(address _icoContract) onlyOwner {\n', '    if (_icoContract != address(0)) {\n', '      icoContract = _icoContract;\n', '    }\n', '  }\n', '\n', '  function sell(address _recipient, uint256 _value) whenNotPaused returns (bool success) {\n', '      assert(_value > 0);\n', '      require(msg.sender == icoContract);\n', '\n', '      balances[_recipient] += _value;\n', '      totalSupply += _value;\n', '\n', '      Transfer(0x0, owner, _value);\n', '      Transfer(owner, _recipient, _value);\n', '      return true;\n', '  }\n', '\n', '  function issue(address _recipient, uint256 _value) whenNotPaused onlyOwner returns (bool success) {\n', '      assert(_value > 0);\n', '      _value = _value * 10**decimals;\n', '\n', '      balances[_recipient] += _value;\n', '      totalSupply += _value;\n', '\n', '      Transfer(0x0, owner, _value);\n', '      Transfer(owner, _recipient, _value);\n', '      return true;\n', '  }\n', '\n', '}\n', '// ================= Ico Token Contract end =======================\n', '\n', '// ================= Actual Sale Contract Start ====================\n', 'contract IcoContract is SafeMath, Pausable {\n', '  IcoToken public ico;\n', '\n', '  address public ethFundDeposit;\n', '  address public icoAddress;\n', '\n', '  uint256 public fundingStartTime;\n', '  uint256 public minContribution;\n', '\n', '  uint256 public tokenCreationCap;\n', '  uint256 public totalSupply;\n', '\n', '  bool public isFinalized;\n', '  uint256 public tokenExchangeRate;\n', '\n', '  event MintICO(address from, address to, uint256 val);\n', '\n', '  function CreateICO(address to, uint256 val) internal returns (bool success) {\n', '    MintICO(0x0, to, val);\n', '    return ico.sell(to, val);\n', '  }\n', '\n', '  function IcoContract(\n', '    address _ethFundDeposit,\n', '    address _icoAddress,\n', '    uint256 _fundingStartTime,\n', '    uint256 _tokenExchangeRate,\n', '    uint256 _tokenCreationCap,\n', '    uint256 _minContribution\n', '  )\n', '  {\n', '    ethFundDeposit = _ethFundDeposit;\n', '    icoAddress = _icoAddress;\n', '    fundingStartTime = _fundingStartTime;\n', '    tokenExchangeRate = _tokenExchangeRate;\n', '    tokenCreationCap = _tokenCreationCap;\n', '    minContribution = _minContribution;\n', '    ico = IcoToken(icoAddress);\n', '    isFinalized = false;\n', '  }\n', '\n', '  function () payable {    \n', '    createTokens(msg.sender, msg.value);\n', '  }\n', '\n', '  /// @dev Accepts ether and creates new ICO tokens.\n', '  function createTokens(address _beneficiary, uint256 _value) internal whenNotPaused {\n', '    require (tokenCreationCap > totalSupply);\n', '    require (now >= fundingStartTime);\n', '    require (_value >= minContribution);\n', '    require (!isFinalized);\n', '\n', '    uint256 tokens = safeMult(_value, tokenExchangeRate);\n', '    uint256 checkedSupply = safeAdd(totalSupply, tokens);\n', '\n', '    if (tokenCreationCap < checkedSupply) {        \n', '      uint256 tokensToAllocate = safeSubtract(tokenCreationCap, totalSupply);\n', '      uint256 tokensToRefund   = safeSubtract(tokens, tokensToAllocate);\n', '      totalSupply = tokenCreationCap;\n', '      uint256 etherToRefund = tokensToRefund / tokenExchangeRate;\n', '\n', '      require(CreateICO(_beneficiary, tokensToAllocate));\n', '      msg.sender.transfer(etherToRefund);\n', '      ethFundDeposit.transfer(this.balance);\n', '      return;\n', '    }\n', '\n', '    totalSupply = checkedSupply;\n', '\n', '    require(CreateICO(_beneficiary, tokens)); \n', '    ethFundDeposit.transfer(this.balance);\n', '  }\n', '\n', '  /// @dev Ends the funding period and sends the ETH home\n', '  function finalize() external onlyOwner {\n', '    require (!isFinalized);\n', '    // move to operational\n', '    isFinalized = true;\n', '    ethFundDeposit.transfer(this.balance);\n', '  }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '// ================= Ownable Contract start =============================\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '// ================= Ownable Contract end ===============================\n', '\n', '// ================= Safemath Contract start ============================\n', '/* taking ideas from FirstBlood token */\n', 'contract SafeMath {\n', '\n', '  function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '    uint256 z = x + y;\n', '    assert((z >= x) && (z >= y));\n', '    return z;\n', '  }\n', '\n', '  function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '    assert(x >= y);\n', '    uint256 z = x - y;\n', '    return z;\n', '  }\n', '\n', '  function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '    uint256 z = x * y;\n', '    assert((x == 0)||(z/x == y));\n', '    return z;\n', '  }\n', '}\n', '// ================= Safemath Contract end ==============================\n', '\n', '// ================= ERC20 Token Contract start =========================\n', '/*\n', ' * ERC20 interface\n', ' * see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '// ================= ERC20 Token Contract end ===========================\n', '\n', '// ================= Standard Token Contract start ======================\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /**\n', '  * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '    require(msg.data.length >= size + 4) ;\n', '    _;\n', '  }\n', '\n', '  mapping(address => uint) balances;\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)  returns (bool success){\n', '    balances[msg.sender] = safeSubtract(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSubtract(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSubtract(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '// ================= Standard Token Contract end ========================\n', '\n', '// ================= Pausable Token Contract start ======================\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '  * @dev modifier to allow actions only when the contract IS paused\n', '  */\n', '  modifier whenNotPaused() {\n', '    require (!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev modifier to allow actions only when the contract IS NOT paused\n', '  */\n', '  modifier whenPaused {\n', '    require (paused) ;\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev called by the owner to pause, triggers stopped state\n', '  */\n', '  function pause() onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev called by the owner to unpause, returns to normal state\n', '  */\n', '  function unpause() onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '// ================= Pausable Token Contract end ========================\n', '\n', '// ================= IcoToken  start =======================\n', 'contract IcoToken is SafeMath, StandardToken, Pausable {\n', '  string public name;\n', '  string public symbol;\n', '  uint256 public decimals;\n', '  string public version;\n', '  address public icoContract;\n', '\n', '\n', '  function IcoToken(\n', '    string _name,\n', '    string _symbol,\n', '    uint256 _decimals,\n', '    string _version\n', '  )\n', '  {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '    version = _version;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) whenNotPaused returns (bool success) {\n', '    return super.transfer(_to,_value);\n', '  }\n', '\n', '  function approve(address _spender, uint _value) whenNotPaused returns (bool success) {\n', '    return super.approve(_spender,_value);\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return super.balanceOf(_owner);\n', '  }\n', '\n', '  function setIcoContract(address _icoContract) onlyOwner {\n', '    if (_icoContract != address(0)) {\n', '      icoContract = _icoContract;\n', '    }\n', '  }\n', '\n', '  function sell(address _recipient, uint256 _value) whenNotPaused returns (bool success) {\n', '      assert(_value > 0);\n', '      require(msg.sender == icoContract);\n', '\n', '      balances[_recipient] += _value;\n', '      totalSupply += _value;\n', '\n', '      Transfer(0x0, owner, _value);\n', '      Transfer(owner, _recipient, _value);\n', '      return true;\n', '  }\n', '\n', '  function issue(address _recipient, uint256 _value) whenNotPaused onlyOwner returns (bool success) {\n', '      assert(_value > 0);\n', '      _value = _value * 10**decimals;\n', '\n', '      balances[_recipient] += _value;\n', '      totalSupply += _value;\n', '\n', '      Transfer(0x0, owner, _value);\n', '      Transfer(owner, _recipient, _value);\n', '      return true;\n', '  }\n', '\n', '}\n', '// ================= Ico Token Contract end =======================\n', '\n', '// ================= Actual Sale Contract Start ====================\n', 'contract IcoContract is SafeMath, Pausable {\n', '  IcoToken public ico;\n', '\n', '  address public ethFundDeposit;\n', '  address public icoAddress;\n', '\n', '  uint256 public fundingStartTime;\n', '  uint256 public minContribution;\n', '\n', '  uint256 public tokenCreationCap;\n', '  uint256 public totalSupply;\n', '\n', '  bool public isFinalized;\n', '  uint256 public tokenExchangeRate;\n', '\n', '  event MintICO(address from, address to, uint256 val);\n', '\n', '  function CreateICO(address to, uint256 val) internal returns (bool success) {\n', '    MintICO(0x0, to, val);\n', '    return ico.sell(to, val);\n', '  }\n', '\n', '  function IcoContract(\n', '    address _ethFundDeposit,\n', '    address _icoAddress,\n', '    uint256 _fundingStartTime,\n', '    uint256 _tokenExchangeRate,\n', '    uint256 _tokenCreationCap,\n', '    uint256 _minContribution\n', '  )\n', '  {\n', '    ethFundDeposit = _ethFundDeposit;\n', '    icoAddress = _icoAddress;\n', '    fundingStartTime = _fundingStartTime;\n', '    tokenExchangeRate = _tokenExchangeRate;\n', '    tokenCreationCap = _tokenCreationCap;\n', '    minContribution = _minContribution;\n', '    ico = IcoToken(icoAddress);\n', '    isFinalized = false;\n', '  }\n', '\n', '  function () payable {    \n', '    createTokens(msg.sender, msg.value);\n', '  }\n', '\n', '  /// @dev Accepts ether and creates new ICO tokens.\n', '  function createTokens(address _beneficiary, uint256 _value) internal whenNotPaused {\n', '    require (tokenCreationCap > totalSupply);\n', '    require (now >= fundingStartTime);\n', '    require (_value >= minContribution);\n', '    require (!isFinalized);\n', '\n', '    uint256 tokens = safeMult(_value, tokenExchangeRate);\n', '    uint256 checkedSupply = safeAdd(totalSupply, tokens);\n', '\n', '    if (tokenCreationCap < checkedSupply) {        \n', '      uint256 tokensToAllocate = safeSubtract(tokenCreationCap, totalSupply);\n', '      uint256 tokensToRefund   = safeSubtract(tokens, tokensToAllocate);\n', '      totalSupply = tokenCreationCap;\n', '      uint256 etherToRefund = tokensToRefund / tokenExchangeRate;\n', '\n', '      require(CreateICO(_beneficiary, tokensToAllocate));\n', '      msg.sender.transfer(etherToRefund);\n', '      ethFundDeposit.transfer(this.balance);\n', '      return;\n', '    }\n', '\n', '    totalSupply = checkedSupply;\n', '\n', '    require(CreateICO(_beneficiary, tokens)); \n', '    ethFundDeposit.transfer(this.balance);\n', '  }\n', '\n', '  /// @dev Ends the funding period and sends the ETH home\n', '  function finalize() external onlyOwner {\n', '    require (!isFinalized);\n', '    // move to operational\n', '    isFinalized = true;\n', '    ethFundDeposit.transfer(this.balance);\n', '  }\n', '}']

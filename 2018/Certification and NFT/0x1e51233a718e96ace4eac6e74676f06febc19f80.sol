['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract OwnableToken {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  function OwnableToken() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken, OwnableToken {\n', '\n', '  event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '  function burn(uint256 _value) public onlyOwner {\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    address burner = msg.sender;\n', '    balances[burner] = balances[burner].sub(_value);\n', '    totalSupply_ = totalSupply_.sub(_value);\n', '    Burn(burner, _value);\n', '    Transfer(burner, address(0), _value);\n', '  }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract FacetagToken is OwnableToken, BurnableToken, StandardToken {\n', '\tstring public name;\n', '\tstring public symbol;\n', '\tuint8 public decimals;\n', '\n', '\tbool public paused = true;\n', '\tmapping(address => bool) public whitelist;\n', '\n', '\tmodifier whenNotPaused() {\n', '\t\trequire(!paused || whitelist[msg.sender]);\n', '\t\t_;\n', '\t}\n', '\n', '\tconstructor(string _name,string _symbol,uint8 _decimals, address holder, address buffer) public {\n', '\t\tname = _name;\n', '\t\tsymbol = _symbol;\n', '\t\tdecimals = _decimals;\n', '\t\tTransfer(address(0), holder, balances[holder] = totalSupply_ = uint256(10)**(12 + decimals));\n', '\t\taddToWhitelist(holder);\n', '\t\taddToWhitelist(buffer);\n', '\t}\n', '\n', '\tfunction unpause() public onlyOwner {\n', '\t\tpaused = false;\n', '\t}\n', '\n', '\tfunction pause() public onlyOwner {\n', '\t\tpaused = true;\n', '\t}\n', '\n', '\tfunction addToWhitelist(address addr) public onlyOwner {\n', '\t\twhitelist[addr] = true;\n', '\t}\n', '    \n', '\tfunction removeFromWhitelist(address addr) public onlyOwner {\n', '\t\twhitelist[addr] = false;\n', '\t}\n', '\n', '\tfunction transfer(address to, uint256 value) public whenNotPaused returns (bool) {\n', '\t\treturn super.transfer(to, value);\n', '\t}\n', '\n', '\tfunction transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {\n', '\t\treturn super.transferFrom(from, to, value);\n', '\t}\n', '\n', '}\n', '\n', 'contract Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '\n', '  ERC20 public token;\n', '\n', '\n', '  address public wallet;\n', '\n', '\n', '  uint256 public rate;\n', '\n', '\n', '  uint256 public weiRaised;\n', '\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  constructor(uint256 _rate, address _wallet, ERC20 _token) public {\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _token;\n', '  }\n', '\n', '  function () external payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  function buyTokens(address _beneficiary) public payable {\n', '\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(_beneficiary, weiAmount);\n', '\n', '\n', '    uint256 tokens = _getTokenAmount(weiAmount);\n', '\n', '\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    _processPurchase(_beneficiary, tokens);\n', '    emit TokenPurchase(\n', '      msg.sender,\n', '      _beneficiary,\n', '      weiAmount,\n', '      tokens\n', '    );\n', '\n', '    _updatePurchasingState(_beneficiary, weiAmount);\n', '\n', '    _forwardFunds();\n', '    _postValidatePurchase(_beneficiary, weiAmount);\n', '  }\n', '\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0);\n', '  }\n', '\n', '  function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    // optional override\n', '  }\n', '\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    token.transfer(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '    _deliverTokens(_beneficiary, _tokenAmount);\n', '  }\n', '\n', '  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {\n', '    // optional override\n', '  }\n', '\n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '    return _weiAmount.mul(rate);\n', '  }\n', '\n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '}\n', '\n', 'contract CappedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '\n', '  constructor(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  function capReached() public view returns (bool) {\n', '    return weiRaised >= cap;\n', '  }\n', '\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '    require(weiRaised.add(_weiAmount) <= cap);\n', '  }\n', '\n', '}\n', '\n', 'contract TimedCrowdsale is Crowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public openingTime;\n', '  uint256 public closingTime;\n', '\n', '  modifier onlyWhileOpen {\n', '    require(block.timestamp >= openingTime && block.timestamp <= closingTime);\n', '    _;\n', '  }\n', '\n', '  constructor(uint256 _openingTime, uint256 _closingTime) public {\n', '\n', '    openingTime = _openingTime;\n', '    closingTime = _closingTime;\n', '  }\n', '\n', '  function hasClosed() public view returns (bool) {\n', '    return block.timestamp > closingTime;\n', '  }\n', '\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '}\n', '\n', 'contract FinalizableCrowdsale is TimedCrowdsale, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  bool public isFinalized = false;\n', '\n', '  event Finalized();\n', '\n', '  function finalize() onlyOwner public {\n', '    require(!isFinalized);\n', '    require(hasClosed());\n', '\n', '    finalization();\n', '    emit Finalized();\n', '\n', '    isFinalized = true;\n', '  }\n', '\n', '  function finalization() internal {\n', '  }\n', '\n', '}\n', '\n', 'contract RefundVault is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  enum State { Active, Refunding, Closed }\n', '\n', '  mapping (address => uint256) public deposited;\n', '  address public wallet;\n', '  State public state;\n', '\n', '  event Closed();\n', '  event RefundsEnabled();\n', '  event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '  constructor(address _wallet) public {\n', '    require(_wallet != address(0));\n', '    wallet = _wallet;\n', '    state = State.Active;\n', '  }\n', '\n', '  function deposit(address investor) onlyOwner public payable {\n', '    require(state == State.Active);\n', '    deposited[investor] = deposited[investor].add(msg.value);\n', '  }\n', '\n', '  function close() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Closed;\n', '    emit Closed();\n', '    wallet.transfer(address(this).balance);\n', '  }\n', '\n', '  function enableRefunds() onlyOwner public {\n', '    require(state == State.Active);\n', '    state = State.Refunding;\n', '    emit RefundsEnabled();\n', '  }\n', '\n', '  function refund(address investor) public {\n', '    require(state == State.Refunding);\n', '    uint256 depositedValue = deposited[investor];\n', '    deposited[investor] = 0;\n', '    investor.transfer(depositedValue);\n', '    emit Refunded(investor, depositedValue);\n', '  }\n', '}\n', '\n', 'contract RefundableCrowdsale is FinalizableCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public goal;\n', '\n', '  RefundVault public vault;\n', '\n', '\n', '  constructor(uint256 _goal) public {\n', '    require(_goal > 0);\n', '    vault = new RefundVault(wallet);\n', '    goal = _goal;\n', '  }\n', '\n', '  function claimRefund() public {\n', '    require(isFinalized);\n', '    require(!goalReached());\n', '\n', '    vault.refund(msg.sender);\n', '  }\n', '\n', '  function goalReached() public view returns (bool) {\n', '    return weiRaised >= goal;\n', '  }\n', '\n', '  function finalization() internal {\n', '    if (goalReached()) {\n', '      vault.close();\n', '    } else {\n', '      vault.enableRefunds();\n', '    }\n', '\n', '    super.finalization();\n', '  }\n', '\n', '  function _forwardFunds() internal {\n', '    vault.deposit.value(msg.value)(msg.sender);\n', '  }\n', '\n', '}\n', '\n', 'contract FacetagCrowdsale is CappedCrowdsale, RefundableCrowdsale {\n', '\n', '  constructor(\n', '    uint256 _openingTime,\n', '    uint256 _closingTime,\n', '    uint256 _rate,\n', '    address _wallet,\n', '    uint256 _cap,\n', '    ERC20 _token,\n', '    uint256 _goal\n', '  )\n', '    public\n', '    Crowdsale(_rate, _wallet, _token)\n', '    CappedCrowdsale(_cap)\n', '    TimedCrowdsale(_openingTime, _closingTime)\n', '    RefundableCrowdsale(_goal)\n', '  {\n', '    require(_goal <= _cap);\n', '  }\n', '}']
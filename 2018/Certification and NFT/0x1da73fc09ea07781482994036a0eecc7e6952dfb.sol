['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  \n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract AbstractERC20 {\n', '\n', '  uint256 public totalSupply;\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '}\n', '\n', 'contract Owned {\n', '\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier ownerOnly {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public ownerOnly {\n', '    require(_newOwner != owner);\n', '    newOwner = _newOwner;\n', '  }\n', '\n', '  function acceptOwnership() public {\n', '    require(msg.sender == newOwner);\n', '    emit OwnerUpdate(owner, newOwner);\n', '    owner = newOwner;\n', '    newOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract TydoIco is Owned {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public constant COINS_PER_ETH = 12000;\n', '  //uint256 public constant bonus = 25;\n', '  mapping (address => uint256) public balances;\n', '  mapping (address => uint256) ethBalances;\n', '  uint256 public ethCollected;\n', '  uint256 public tokenSold;\n', '  uint256 constant tokenDecMult = 1 ether;\n', '  uint8 public state = 0; // 0 - not started yet\n', '                          // 1 - running\n', '                          // 2 - closed mannually and not success\n', '                          // 3 - closed and target reached success\n', '                          // 4 - success & funds withdrawed\n', '\n', '  //uint256 public bonusEnd_1 = 1530335295;\n', '  uint256[] public bonuses;\n', '  uint256[] public bonusEnds;\n', '\n', '  AbstractERC20 public token;\n', '\n', '  //event Debug(string _msg, address _addr);\n', '  //event Debug(string _msg, uint256 _val);\n', '  event SaleStart();\n', '  event SaleClosedSuccess(uint256 _tokenSold);\n', '  event SaleClosedFail(uint256 _tokenSold);\n', '\n', '  constructor(address _coinToken, uint256[] _bonuses, uint256[] _bonusEnds) Owned() public {\n', '    require(_bonuses.length == _bonusEnds.length);\n', '    for(uint8 i = 0; i < _bonuses.length; i++) {\n', '      require(_bonuses[i] > 0);\n', '      //require(_bonusEnds[i] > block.timestamp);\n', '      if (i > 0) {\n', '        //require(_bonusEnds[i] > _bonusEnds[i - 1]);\n', '      }\n', '    }\n', '    bonuses = _bonuses;\n', '    bonusEnds = _bonusEnds;\n', '\n', '    token = AbstractERC20(_coinToken);\n', '  }\n', '\n', '  function tokensLeft() public view returns (uint256 allowed) {\n', '    return token.allowance(address(owner), address(this));\n', '  }\n', '\n', '  function () payable public {\n', '\n', '    if ((state == 3 || state == 4) && msg.value == 0) {\n', '      return withdrawTokens();\n', '    } else if (state == 2 && msg.value == 0) {\n', '      return refund();\n', '    } else {\n', '      return buy();\n', '    }\n', '  }\n', '\n', '  function buy() payable public {\n', '\n', '    require (canBuy());\n', '    uint amount = msg.value.mul(COINS_PER_ETH).div(1 ether).mul(tokenDecMult);\n', '    amount = addBonus(amount);\n', '    //emit Debug("buy amount", amount);\n', '    require(amount > 0, &#39;amount must be positive&#39;);\n', '    token.transferFrom(address(owner), address(this), amount);\n', '    //emit Debug(&#39;transfered &#39;, amount);\n', '    balances[msg.sender] = balances[msg.sender].add(amount);\n', '    ethBalances[msg.sender] += msg.value;\n', '    ethCollected = ethCollected.add(msg.value);\n', '    tokenSold = tokenSold.add(amount);\n', '  }\n', '\n', '  function getBonus() public view returns(uint256 _currentBonus) {\n', '  \n', '    uint256 curTime = block.timestamp;\n', '    for(uint8 i = 0; i < bonuses.length; i++) {\n', '      if(bonusEnds[i] > curTime) {\n', '        return bonuses[i];\n', '      }\n', '    }\n', '    return 0;\n', '  }\n', '\n', '  function addBonus(uint256 amount) internal view returns(uint256 _newAmount) {\n', '   \n', '    uint256 bonus = getBonus();\n', '    uint256 mult = bonus.add(100);\n', '    //emit Debug(&#39;mult &#39;, mult);\n', '    amount = amount.mul(mult).div(100);\n', '    return amount;\n', '  }\n', '\n', '  function canBuy() public constant returns(bool _canBuy) {\n', '    return state == 1;\n', '  }\n', '  \n', '  function refund() public {\n', '\n', '    require(state == 2);\n', '\n', '    uint256 tokenAmount = balances[msg.sender];\n', '    require(tokenAmount > 0);\n', '    uint256 weiAmount = ethBalances[msg.sender];\n', '\n', '    msg.sender.transfer(weiAmount);\n', '    token.transfer(owner, balances[msg.sender]);\n', '    ethBalances[msg.sender] = 0;\n', '    balances[msg.sender] = 0;\n', '    ethCollected = ethCollected.sub(weiAmount);\n', '  }\n', ' \n', '  function withdraw() ownerOnly public {\n', '    \n', '    require(state == 3);\n', '    owner.transfer(ethCollected);\n', '    ethCollected = 0;\n', '    state = 4;\n', '  }\n', '\n', '  function withdrawTokens() public {\n', '    require(state == 3 || state ==4);\n', '    require(balances[msg.sender] > 0);\n', '    token.transfer(msg.sender, balances[msg.sender]);\n', '  }\n', '\n', '  function open() ownerOnly public {\n', '    require(state == 0);\n', '    state = 1;\n', '    emit SaleStart();\n', '  }\n', '\n', '  function closeSuccess() ownerOnly public {\n', '\n', '    require(state == 1);\n', '    state = 3;\n', '    emit SaleClosedSuccess(tokenSold);\n', '  }\n', '\n', '  function closeFail() ownerOnly public {\n', '\n', '    require(state == 1);\n', '    state = 2;\n', '    emit SaleClosedFail(tokenSold);\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  \n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract AbstractERC20 {\n', '\n', '  uint256 public totalSupply;\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '}\n', '\n', 'contract Owned {\n', '\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier ownerOnly {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public ownerOnly {\n', '    require(_newOwner != owner);\n', '    newOwner = _newOwner;\n', '  }\n', '\n', '  function acceptOwnership() public {\n', '    require(msg.sender == newOwner);\n', '    emit OwnerUpdate(owner, newOwner);\n', '    owner = newOwner;\n', '    newOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract TydoIco is Owned {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public constant COINS_PER_ETH = 12000;\n', '  //uint256 public constant bonus = 25;\n', '  mapping (address => uint256) public balances;\n', '  mapping (address => uint256) ethBalances;\n', '  uint256 public ethCollected;\n', '  uint256 public tokenSold;\n', '  uint256 constant tokenDecMult = 1 ether;\n', '  uint8 public state = 0; // 0 - not started yet\n', '                          // 1 - running\n', '                          // 2 - closed mannually and not success\n', '                          // 3 - closed and target reached success\n', '                          // 4 - success & funds withdrawed\n', '\n', '  //uint256 public bonusEnd_1 = 1530335295;\n', '  uint256[] public bonuses;\n', '  uint256[] public bonusEnds;\n', '\n', '  AbstractERC20 public token;\n', '\n', '  //event Debug(string _msg, address _addr);\n', '  //event Debug(string _msg, uint256 _val);\n', '  event SaleStart();\n', '  event SaleClosedSuccess(uint256 _tokenSold);\n', '  event SaleClosedFail(uint256 _tokenSold);\n', '\n', '  constructor(address _coinToken, uint256[] _bonuses, uint256[] _bonusEnds) Owned() public {\n', '    require(_bonuses.length == _bonusEnds.length);\n', '    for(uint8 i = 0; i < _bonuses.length; i++) {\n', '      require(_bonuses[i] > 0);\n', '      //require(_bonusEnds[i] > block.timestamp);\n', '      if (i > 0) {\n', '        //require(_bonusEnds[i] > _bonusEnds[i - 1]);\n', '      }\n', '    }\n', '    bonuses = _bonuses;\n', '    bonusEnds = _bonusEnds;\n', '\n', '    token = AbstractERC20(_coinToken);\n', '  }\n', '\n', '  function tokensLeft() public view returns (uint256 allowed) {\n', '    return token.allowance(address(owner), address(this));\n', '  }\n', '\n', '  function () payable public {\n', '\n', '    if ((state == 3 || state == 4) && msg.value == 0) {\n', '      return withdrawTokens();\n', '    } else if (state == 2 && msg.value == 0) {\n', '      return refund();\n', '    } else {\n', '      return buy();\n', '    }\n', '  }\n', '\n', '  function buy() payable public {\n', '\n', '    require (canBuy());\n', '    uint amount = msg.value.mul(COINS_PER_ETH).div(1 ether).mul(tokenDecMult);\n', '    amount = addBonus(amount);\n', '    //emit Debug("buy amount", amount);\n', "    require(amount > 0, 'amount must be positive');\n", '    token.transferFrom(address(owner), address(this), amount);\n', "    //emit Debug('transfered ', amount);\n", '    balances[msg.sender] = balances[msg.sender].add(amount);\n', '    ethBalances[msg.sender] += msg.value;\n', '    ethCollected = ethCollected.add(msg.value);\n', '    tokenSold = tokenSold.add(amount);\n', '  }\n', '\n', '  function getBonus() public view returns(uint256 _currentBonus) {\n', '  \n', '    uint256 curTime = block.timestamp;\n', '    for(uint8 i = 0; i < bonuses.length; i++) {\n', '      if(bonusEnds[i] > curTime) {\n', '        return bonuses[i];\n', '      }\n', '    }\n', '    return 0;\n', '  }\n', '\n', '  function addBonus(uint256 amount) internal view returns(uint256 _newAmount) {\n', '   \n', '    uint256 bonus = getBonus();\n', '    uint256 mult = bonus.add(100);\n', "    //emit Debug('mult ', mult);\n", '    amount = amount.mul(mult).div(100);\n', '    return amount;\n', '  }\n', '\n', '  function canBuy() public constant returns(bool _canBuy) {\n', '    return state == 1;\n', '  }\n', '  \n', '  function refund() public {\n', '\n', '    require(state == 2);\n', '\n', '    uint256 tokenAmount = balances[msg.sender];\n', '    require(tokenAmount > 0);\n', '    uint256 weiAmount = ethBalances[msg.sender];\n', '\n', '    msg.sender.transfer(weiAmount);\n', '    token.transfer(owner, balances[msg.sender]);\n', '    ethBalances[msg.sender] = 0;\n', '    balances[msg.sender] = 0;\n', '    ethCollected = ethCollected.sub(weiAmount);\n', '  }\n', ' \n', '  function withdraw() ownerOnly public {\n', '    \n', '    require(state == 3);\n', '    owner.transfer(ethCollected);\n', '    ethCollected = 0;\n', '    state = 4;\n', '  }\n', '\n', '  function withdrawTokens() public {\n', '    require(state == 3 || state ==4);\n', '    require(balances[msg.sender] > 0);\n', '    token.transfer(msg.sender, balances[msg.sender]);\n', '  }\n', '\n', '  function open() ownerOnly public {\n', '    require(state == 0);\n', '    state = 1;\n', '    emit SaleStart();\n', '  }\n', '\n', '  function closeSuccess() ownerOnly public {\n', '\n', '    require(state == 1);\n', '    state = 3;\n', '    emit SaleClosedSuccess(tokenSold);\n', '  }\n', '\n', '  function closeFail() ownerOnly public {\n', '\n', '    require(state == 1);\n', '    state = 2;\n', '    emit SaleClosedFail(tokenSold);\n', '  }\n', '}']

['pragma solidity ^0.4.19;\n', '\n', 'contract DAO {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  ERC20 public typeToken;\n', '  address public owner;\n', '  address public burnAddress = 0x0000000000000000000000000000000000000000;\n', '  uint256 public tokenDecimals;\n', '  uint256 public unburnedTypeTokens;\n', '  uint256 public weiPerWholeToken = 0.1 ether;\n', '\n', '  event LogLiquidation(address indexed _to, uint256 _typeTokenAmount, uint256 _ethAmount, uint256 _newTotalSupply);\n', '\n', '  modifier onlyOwner () {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function DAO (address _typeToken, uint256 _tokenDecimals) public {\n', '    typeToken = ERC20(_typeToken);\n', '    tokenDecimals = _tokenDecimals;\n', '    unburnedTypeTokens = typeToken.totalSupply();\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function exchangeTokens (uint256 _amount) public {\n', '    require(typeToken.transferFrom(msg.sender, address(this), _amount));\n', '    uint256 percentageOfPotToSend = _percent(_amount, unburnedTypeTokens, 8);\n', '    uint256 ethToSend = (address(this).balance.div(100000000)).mul(percentageOfPotToSend);\n', '    msg.sender.transfer(ethToSend);\n', '    _byrne(_amount);\n', '    emit LogLiquidation(msg.sender, _amount, ethToSend, unburnedTypeTokens);\n', '  }\n', '\n', '  function _byrne(uint256 _amount) internal {\n', '    require(typeToken.transfer(burnAddress, _amount));\n', '    unburnedTypeTokens = unburnedTypeTokens.sub(_amount);\n', '  }\n', '\n', '  function updateWeiPerWholeToken (uint256 _newRate) public onlyOwner {\n', '    weiPerWholeToken = _newRate;\n', '  }\n', '\n', '  function changeOwner (address _newOwner) public onlyOwner {\n', '    owner = _newOwner;\n', '  }\n', '\n', '  function _percent(uint256 numerator, uint256 denominator, uint256 precision) internal returns(uint256 quotient) {\n', '    uint256 _numerator = numerator.mul((10 ** (precision+1)));\n', '    uint256 _quotient = ((_numerator / denominator) + 5) / 10;\n', '    return ( _quotient);\n', '  }\n', '\n', '  function () public payable {}\n', '\n', '}\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public constant returns (uint256 supply);\n', '  function balanceOf(address _owner) public constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract DAO {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  ERC20 public typeToken;\n', '  address public owner;\n', '  address public burnAddress = 0x0000000000000000000000000000000000000000;\n', '  uint256 public tokenDecimals;\n', '  uint256 public unburnedTypeTokens;\n', '  uint256 public weiPerWholeToken = 0.1 ether;\n', '\n', '  event LogLiquidation(address indexed _to, uint256 _typeTokenAmount, uint256 _ethAmount, uint256 _newTotalSupply);\n', '\n', '  modifier onlyOwner () {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function DAO (address _typeToken, uint256 _tokenDecimals) public {\n', '    typeToken = ERC20(_typeToken);\n', '    tokenDecimals = _tokenDecimals;\n', '    unburnedTypeTokens = typeToken.totalSupply();\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function exchangeTokens (uint256 _amount) public {\n', '    require(typeToken.transferFrom(msg.sender, address(this), _amount));\n', '    uint256 percentageOfPotToSend = _percent(_amount, unburnedTypeTokens, 8);\n', '    uint256 ethToSend = (address(this).balance.div(100000000)).mul(percentageOfPotToSend);\n', '    msg.sender.transfer(ethToSend);\n', '    _byrne(_amount);\n', '    emit LogLiquidation(msg.sender, _amount, ethToSend, unburnedTypeTokens);\n', '  }\n', '\n', '  function _byrne(uint256 _amount) internal {\n', '    require(typeToken.transfer(burnAddress, _amount));\n', '    unburnedTypeTokens = unburnedTypeTokens.sub(_amount);\n', '  }\n', '\n', '  function updateWeiPerWholeToken (uint256 _newRate) public onlyOwner {\n', '    weiPerWholeToken = _newRate;\n', '  }\n', '\n', '  function changeOwner (address _newOwner) public onlyOwner {\n', '    owner = _newOwner;\n', '  }\n', '\n', '  function _percent(uint256 numerator, uint256 denominator, uint256 precision) internal returns(uint256 quotient) {\n', '    uint256 _numerator = numerator.mul((10 ** (precision+1)));\n', '    uint256 _quotient = ((_numerator / denominator) + 5) / 10;\n', '    return ( _quotient);\n', '  }\n', '\n', '  function () public payable {}\n', '\n', '}\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public constant returns (uint256 supply);\n', '  function balanceOf(address _owner) public constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '  function approve(address _spender, uint256 _value) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
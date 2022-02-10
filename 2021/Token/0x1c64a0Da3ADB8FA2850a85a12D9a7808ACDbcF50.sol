['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-04\n', '*/\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '\n', '\n', 'contract ERC20Basic {\n', '\n', '  function totalSupply() public view returns (uint256);  // totalSupply - 总发行量\n', '\n', '  function balanceOf(address who) public view returns (uint256);  // 余额\n', '\n', '  function transfer(address to, uint256 value) public returns (bool);  // 交易\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);  // 交易事件\n', '\n', '}\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '    if (a == 0) {\n', '\n', '      return 0;\n', '\n', '    }\n', '\n', '    uint256 c = a * b;\n', '\n', '    assert(c / a == b);\n', '\n', '    return c;\n', '\n', '  }\n', '\n', '  /**\n', '\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '\n', '  */\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\n', '    uint256 c = a / b;\n', '\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '\n', '  }\n', '\n', ' \n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '    assert(b <= a);\n', '\n', '    return a - b;\n', '\n', '  }\n', '\n', ' \n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '    uint256 c = a + b;\n', '\n', '    assert(c >= a);\n', '\n', '    return c;\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '\n', '  function allowance(address owner, address spender) public view returns (uint256);  // 获取被授权令牌余额,获取 _owner 地址授权给 _spender 地址可以转移的令牌的余额\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);  // A账户-》B账户的转账\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);  // 授权，允许 _spender 地址从你的账户中转移 _value 个令牌到任何地方\n', '\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);  // 授权事件\n', '\n', '}\n', '\n', '/**\n', '\n', '* @title Basic token\n', '\n', '* @dev Basic version of StandardToken, with no allowances.\n', '\n', '*/\n', '\n', 'contract BasicToken is ERC20Basic {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances; \n', '\n', '  uint256 totalSupply_;  \n', '\n', '\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '\n', '    return totalSupply_;\n', '\n', '  }\n', '\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '\n', '    require(_to != address(0));  // 无效地址\n', '\n', '    require(_value <= balances[msg.sender]);  // 转账账户余额大于转账数目\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);  // 转账账户余额=账户余额-转账金额\n', '\n', '    balances[_to] = balances[_to].add(_value); // 接收账户的余额=原先账户余额+账金额\n', '\n', '    emit Transfer(msg.sender, _to, _value);  // 转账\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '\n', '    return balances[_owner];  // 查询合约调用者的余额\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '\n', '    require(_to != address(0)); // 到达B账户的地址不能为无效地址\n', '\n', '    require(_value <= balances[_from]);  // 转账账户余额大于转账金额\n', '\n', '    require(_value <= allowed[_from][msg.sender]);  // 允许_from地址转账给 _to地址\n', '\n', '    balances[_from] = balances[_from].sub(_value); \n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);  // 允许转账的余额\n', '\n', '    emit Transfer(_from, _to, _value);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '\n', '    emit Approval(msg.sender, _spender, _value);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '\n', '    return allowed[_owner][_spender];\n', '\n', '  }\n', '\n', '  \n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', ' \n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '\n', '    if (_subtractedValue > oldValue) {\n', '\n', '      allowed[msg.sender][_spender] = 0;\n', '\n', '    } else {\n', '\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\n', '    }\n', '\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '    return true;\n', '\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', 'contract EchoToken is StandardToken {\n', '\n', '    string public constant name = "EchoToken";\n', '\n', '    string public constant symbol = "Echo";\n', '\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public constant INITIAL_SUPPLY = (10 ** 9) * (10 ** uint256(decimals));\n', '\n', '    /**\n', '\n', '    * @dev Constructor that gives msg.sender all of existing tokens.\n', '\n', '    */\n', '\n', '    constructor() public {\n', '\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '\n', '        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '\n', '    }\n', '\n', '}']
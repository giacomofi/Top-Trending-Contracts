['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath { \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0 || b == 0){\n', '        return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function\n', '    if (b == 0){\n', '      return 1;\n', '    }\n', '    uint256 c = a**b;\n', '    assert (c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', "//it's contract name:\n", '\n', 'contract YourCustomTokenJABACO{ //ERC - 20 token contract\n', '  using SafeMath for uint;\n', '  // Triggered when tokens are transferred.\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '\n', "  // It's nessesary ERC-20 parameters\n", '  string public constant symbol = "JABAS";\n', '  string public constant name = "JABATOKENS";\n', '  uint8 public constant decimals = 4;\n', '  uint256 _totalSupply = 10000000000;\n', ' \n', '\n', '  // Owner of this contract\n', '  address public owner;\n', '\n', '  // Balances for each account\n', '  mapping(address => uint256) balances;\n', '\n', '  // Owner of account approves the transfer of an amount to another account\n', '  mapping(address => mapping (address => uint256)) allowed;\n', '\n', '  function totalSupply() public view returns (uint256) { //standart ERC-20 function\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address _address) public view returns (uint256 balance) {//standart ERC-20 function\n', '    return balances[_address];\n', '  }\n', '  \n', '  //standart ERC-20 function\n', '  function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Transfer(msg.sender,_to,_amount);\n', '    return true;\n', '  }\n', '\n', '  //standart ERC-20 function\n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success){\n', '    balances[_from] = balances[_from].sub(_amount);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Transfer(_from,_to,_amount);\n', '    return true;\n', '  }\n', '  //standart ERC-20 function\n', '  function approve(address _spender, uint256 _amount)public returns (bool success) { \n', '    allowed[msg.sender][_spender] = _amount;\n', '    Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  //standart ERC-20 function\n', '  function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  //Constructor\n', '  function YourCustomTokenJABACO() public {\n', '    owner = msg.sender;\n', '    balances[msg.sender] = _totalSupply;\n', '    Transfer(this,msg.sender,_totalSupply);\n', '  } \n', '}']
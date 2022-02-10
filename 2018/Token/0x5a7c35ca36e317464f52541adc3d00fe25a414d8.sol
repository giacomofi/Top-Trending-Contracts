['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Luxecoin is ERC20, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  string public name = "LuxeCoin";\n', '  string public symbol = "LXC";\n', '  uint8 public constant decimals = 18;\n', '  uint256 public constant initial_supply = 220000000 * (10 ** uint256(decimals));\n', '\n', '  mapping (address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '  \n', '  constructor() public {\n', '    owner = msg.sender;\n', '    totalSupply_ = initial_supply;\n', '    balances[owner] = initial_supply;\n', '    emit Transfer(0x0, owner, initial_supply);\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '  \n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    uint256 _balance = balances[msg.sender];\n', '    require(_value <= _balance);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  function transferMany(address[] recipients, uint256[] values) public {\n', '    for (uint256 i = 0; i < recipients.length; i++) {\n', '      require(balances[msg.sender] >= values[i]);\n', '      balances[msg.sender] = balances[msg.sender].sub(values[i]);\n', '      balances[recipients[i]] = balances[recipients[i]].add(values[i]);\n', '      emit Transfer(msg.sender, recipients[i], values[i]);\n', '    }\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Luxecoin is ERC20, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  string public name = "LuxeCoin";\n', '  string public symbol = "LXC";\n', '  uint8 public constant decimals = 18;\n', '  uint256 public constant initial_supply = 220000000 * (10 ** uint256(decimals));\n', '\n', '  mapping (address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '  \n', '  constructor() public {\n', '    owner = msg.sender;\n', '    totalSupply_ = initial_supply;\n', '    balances[owner] = initial_supply;\n', '    emit Transfer(0x0, owner, initial_supply);\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '  \n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    uint256 _balance = balances[msg.sender];\n', '    require(_value <= _balance);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  function transferMany(address[] recipients, uint256[] values) public {\n', '    for (uint256 i = 0; i < recipients.length; i++) {\n', '      require(balances[msg.sender] >= values[i]);\n', '      balances[msg.sender] = balances[msg.sender].sub(values[i]);\n', '      balances[recipients[i]] = balances[recipients[i]].add(values[i]);\n', '      emit Transfer(msg.sender, recipients[i], values[i]);\n', '    }\n', '  }\n', '}']
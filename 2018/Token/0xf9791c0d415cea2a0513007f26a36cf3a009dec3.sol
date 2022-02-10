['contract ERC20Basic {\n', '  function totalSupply() constant public returns (uint256 tokenSupply);\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    \n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '// ------------------------------------\n', '\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '  \n', '  mapping(address => uint) public balances;\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    \n', '  event Mint(address indexed to, uint256 amount);\n', '  \n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '\n', '  function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', ' \n', '  function finishMinting() public onlyOwner returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '  \n', '}\n', '\n', '\n', 'contract LICERIOToken is MintableToken {\n', '\n', '\taddress private wallet;\n', '\t\n', '\tuint256 public tokenSupply = 0;\n', '\tuint256 public bountySupply = 0;\n', '\tuint256 public totalSold = 0; \n', '\t \n', '\tfunction LICERIOToken() {\n', '\t\twallet = msg.sender;\n', '\t\tbountySupply = 10000000 * decimals();\n', '\t\ttokenSupply = 100000000 * decimals();\n', '\t}\n', '\t\n', '\tfunction totalSupply () constant returns (uint256 tokenSupply) {\n', '\t\treturn tokenSupply;\n', '\t}\n', '\t\n', '\tfunction name () constant returns (string result) {\n', '\t\treturn "LICERIO TOKEN";\n', '\t}\n', '\t\n', '\tfunction symbol () constant returns (string result) {\n', '\t\treturn "LCR";\n', '\t}\n', '\t\n', '\tfunction decimals () constant returns (uint result) {\n', '\t\tuint dec = (10**18);\n', '\t\treturn dec;\n', '\t}\n', '\t\n', '\t\n', '\tfunction TokensForSale () public returns (uint) {\n', '\t\treturn 70000000 * decimals() - totalSold;\n', '\t}\n', '\t\n', '\tfunction availableBountyCount() public returns (uint) {\n', '\t    return bountySupply;\n', '\t}\n', '\t\n', '\tfunction addTokenSupply(uint256 _amount) returns (uint256)  {\n', '\t    totalSold = totalSold.add(_amount);\n', '\t    return totalSold;\n', '\t}\n', '\t\n', '\tfunction subBountySupply(uint256 _amount) returns (uint256)  {\n', '\t    return bountySupply = bountySupply.sub(_amount);\n', '\t}\n', '\n', '}']
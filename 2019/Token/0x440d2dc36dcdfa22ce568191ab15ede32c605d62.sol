['pragma solidity 0.5.0;\n', '/*\n', 'IVYToken Standard ERC20 Tokens\n', '*/\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;  \n', '  function balanceOf(address _owner) public view returns (uint256 balance);  \n', '  function transfer(address _to, uint256 _amount) public returns (bool success);  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining);  \n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);  \n', '  function approve(address _spender, uint256 _amount) public returns (bool success);  \n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', '  function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]);\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', 'contract StandardToken is ERC20, BasicToken {  \n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[_from] >= _amount);\n', '    require(allowed[_from][msg.sender] >= _amount);\n', '    require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);\n', '    balances[_from] = balances[_from].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '    emit Transfer(_from, _to, _amount);\n', '    return true;\n', '  }\n', '  function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    emit Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', 'contract BurnableToken is StandardToken, Ownable {\n', '    event Burn(address indexed burner, uint256 value);\n', '\tfunction burn(uint256 _value) public onlyOwner{\n', '        require(_value <= balances[msg.sender]);\n', '\t\tbalances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '    }\n', '}\n', 'contract IVYToken is BurnableToken {\n', '    string public name = "IVYToken";\n', '    string public symbol = "IVYT";\n', '    uint256 public totalSupply;\n', '    uint8 public decimals = 18;\n', '\tfunction () external payable  {\n', '        revert();\n', '    }\t \n', '    \n', '\tconstructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {\n', '        initialSupply = 100000000;\n', '        totalSupply = initialSupply.mul( 10 ** uint256(decimals));\n', '        tokenName = "IVYToken";\n', '        tokenSymbol = "IVYT";\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '    \n', '\tfunction getTokenDetail() public view returns (string memory, string memory, uint256) {\n', '\t    return (name, symbol, totalSupply);\n', '    }\n', ' }']
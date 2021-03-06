['pragma solidity ^0.4.21;\n', '\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract TokenERC20 is Ownable {\n', '\t\n', '    using SafeMath for uint256;\n', '    \n', '    string public constant name       = "以太猪";\n', '    string public constant symbol     = "ETZ";\n', '    uint32 public constant decimals   = 18;\n', '    uint256 public totalSupply;\n', '\n', '    mapping(address => uint256) balances;\n', '\tmapping(address => mapping (address => uint256)) internal allowed;\n', '\n', '\t\n', '\n', '\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '\t\n', '\tfunction TokenERC20(\n', '        uint256 initialSupply\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '    }\n', '\t\n', '    function totalSupply() public view returns (uint256) {\n', '\t\treturn totalSupply;\n', '\t}\t\n', '\t\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool) {\n', '\t\trequire(_to != address(0));\n', '\t\trequire(_value <= balances[msg.sender]);\n', '\t\tbalances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\temit Transfer(msg.sender, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\t\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '\t\trequire(_to != address(0));\n', '\t\trequire(_value <= balances[_from]);\n', '\t\trequire(_value <= allowed[_from][msg.sender]);\t\n', '\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tallowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\temit Transfer(_from, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\temit Approval(msg.sender, _spender, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '\n', '\tfunction increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '\t\tallowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\t\temit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '\t\tuint oldValue = allowed[msg.sender][_spender];\n', '\t\tif (_subtractedValue > oldValue) {\n', '\t\t\tallowed[msg.sender][_spender] = 0;\n', '\t\t} else {\n', '\t\t\tallowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\t\t}\n', '\t\temit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\treturn true;\n', '\t}\n', '\t\n', '\tfunction getBalance(address _a) internal constant returns(uint256) {\n', '\n', '            return balances[_a];\n', '       \n', '    }\n', '    \n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return getBalance( _owner );\n', '    }\n', '\t\n', '\n', ' \n', '\t\n', '}']
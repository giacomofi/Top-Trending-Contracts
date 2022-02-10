['pragma solidity >=0.4.22 <0.6.0;\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) view public  returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '\n', '}\n', '\n', 'contract Token is ERC20 {\n', '\n', '    using SafeMath for uint;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', '\n', '    constructor(uint256 _initialAmount, uint8 _decimalUnits, string memory _tokenName, string memory _tokenSymbol) public {\n', '        decimals = _decimalUnits;\n', '        totalSupply = _initialAmount * 10**uint(decimals);\n', '        balances[msg.sender] = totalSupply;\n', '        name = _tokenName;\n', '        symbol = _tokenSymbol;   \n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value && _value > 0); \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '        \n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0); \n', '        uint256 _allowance = allowed[_from][msg.sender];\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(_value >= 0); \n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract MerculetToken is Token {\n', '\n', "    string public version = 'v2.0';\n", '\n', "    constructor () public Token(10000000000,18,'Merculet','MVP')  {\n", '\n', '    }\n', '    \n', '}']
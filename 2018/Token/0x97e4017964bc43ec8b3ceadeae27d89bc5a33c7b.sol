['pragma solidity ^0.4.25;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() constant returns (uint256 totSupply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract owned {\n', '        address public owner;\n', '\n', '        constructor() public {\n', '            owner = 0x91520Dc19a9E103a849076A9Dd860604Ff7a6282;\n', '        }\n', '\n', '        modifier onlyOwner {\n', '            require(msg.sender == owner);\n', '            _;\n', '        }\n', '\n', '        function transferOwnership(address newOwner) onlyOwner public {\n', '            owner = newOwner;\n', '        }\n', '}\n', '\n', 'contract AccessibleCoin is owned, IERC20{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    uint256 public _totalSupply = 40000000000000000000000;\n', ' \n', "    string public constant symbol = 'ACCESS';\n", '\n', "    string public constant name = 'Accessible';\n", '    \n', '    uint8 public constant decimals = 14;\n', '    \n', '    mapping(address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    constructor() public {\n', '        balances[msg.sender] = _totalSupply;\n', '    }\n', '    \n', '    function totalSupply() constant public returns (uint256 totSupply) {\n', '        return _totalSupply;\n', '    }\n', '   \n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(\n', '            balances[msg.sender] >= _value\n', '            && _value > 0\n', '        );\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(\n', '            allowed[_from][msg.sender] >= _value\n', '            && balances[_from] >= _value\n', '            && _value > 0  \n', '        );\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '   \n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != 0);\n', '        require(value <= balances[account]);\n', '    \n', '        _totalSupply = _totalSupply.sub(value);\n', '        balances[account] = balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}']
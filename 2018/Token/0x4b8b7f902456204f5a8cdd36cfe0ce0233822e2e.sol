['pragma solidity ^0.4.25;\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', ' \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '   \n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  \n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', '    \n', '    return c;\n', '  }\n', '\n', ' \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  \n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '\n', 'contract ERC20COIN {\n', '    mapping(address => uint256) public balances;\n', '    mapping(address => mapping (address => uint256)) public allowed;\n', '    using SafeMath for uint256;\n', '    address public owner;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    uint256 private constant MAX_UINT256 = 2**256 -1 ;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '    \n', '    bool lock = false;\n', '\n', '    constructor(\n', '        uint256 _initialAmount,\n', '        string _tokenName,\n', '        uint8 _decimalUnits,\n', '        string _tokenSymbol\n', '    ) public {\n', '        owner = msg.sender;\n', '        balances[msg.sender] = _initialAmount;\n', '        totalSupply = _initialAmount;\n', '        name = _tokenName;\n', '        decimals = _decimalUnits;\n', '        symbol = _tokenSymbol;\n', '        \n', '    }\n', '\t\n', '\t\n', '\tmodifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier isLock {\n', '        require(!lock);\n', '        _;\n', '    }\n', '    \n', '    function setLock(bool _lock) onlyOwner public{\n', '        lock = _lock;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\t\n', '\t\n', '\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value\n', '    ) public returns (bool) {\n', '        require(balances[msg.sender] >= _value);\n', '        require(msg.sender == _to || balances[_to] <= MAX_UINT256 - _value);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    ) public returns (bool) {\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value);\n', '        require(_from == _to || balances[_to] <= MAX_UINT256 -_value);\n', '        require(allowance >= _value);\n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        if (allowance < MAX_UINT256) {\n', '            allowed[_from][msg.sender] -= _value;\n', '        }\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(\n', '        address _owner\n', '    ) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(\n', '        address _spender,\n', '        uint256 _value\n', '    ) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    ) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}']
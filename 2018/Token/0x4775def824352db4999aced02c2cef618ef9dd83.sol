['pragma solidity ^0.4.24;\n', '\n', 'contract SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0); \n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b); \n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract WCCToken is SafeMath, Ownable{\n', '    string public name = "WCCCoin";\n', '    string public symbol = "WCC";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 12 * 10 ** 8 * 10 ** 18;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => uint256) public freezeOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Freeze(address indexed from, uint256 value);\n', '\t\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    constructor() public{\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        if (_to == 0x0) revert(); \n', '        if (_value <= 0) revert(); \n', '        if (balanceOf[msg.sender] < _value) revert();\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert();\n', '        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        if (_value <= 0) revert();\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '       \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (_to == 0x0) revert(); \n', '        if (_value <= 0) revert();\n', '        if (balanceOf[_from] < _value) revert();  \n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert();\n', '        if (_value > allowance[_from][msg.sender]) revert(); \n', '        balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value); \n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);\n', '        allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function freeze(uint256 _value) onlyOwner public returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value) revert(); \n', '        if (_value <= 0) revert(); \n', '        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value); \n', '        freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value); \n', '        emit Freeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function unfreeze(uint256 _value) onlyOwner public returns (bool success) {\n', '        if (freezeOf[msg.sender] < _value) revert();\n', '        if (_value <= 0) revert();\n', '        freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value); \n', '        balanceOf[msg.sender] = SafeMath.add(balanceOf[msg.sender], _value);\n', '        emit Unfreeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0); \n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b); \n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract WCCToken is SafeMath, Ownable{\n', '    string public name = "WCCCoin";\n', '    string public symbol = "WCC";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 12 * 10 ** 8 * 10 ** 18;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => uint256) public freezeOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Freeze(address indexed from, uint256 value);\n', '\t\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    constructor() public{\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        if (_to == 0x0) revert(); \n', '        if (_value <= 0) revert(); \n', '        if (balanceOf[msg.sender] < _value) revert();\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert();\n', '        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        if (_value <= 0) revert();\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '       \n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (_to == 0x0) revert(); \n', '        if (_value <= 0) revert();\n', '        if (balanceOf[_from] < _value) revert();  \n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert();\n', '        if (_value > allowance[_from][msg.sender]) revert(); \n', '        balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value); \n', '        balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);\n', '        allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function freeze(uint256 _value) onlyOwner public returns (bool success) {\n', '        if (balanceOf[msg.sender] < _value) revert(); \n', '        if (_value <= 0) revert(); \n', '        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value); \n', '        freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value); \n', '        emit Freeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function unfreeze(uint256 _value) onlyOwner public returns (bool success) {\n', '        if (freezeOf[msg.sender] < _value) revert();\n', '        if (_value <= 0) revert();\n', '        freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value); \n', '        balanceOf[msg.sender] = SafeMath.add(balanceOf[msg.sender], _value);\n', '        emit Unfreeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '}']

['pragma solidity ^0.4.18;\n', '\n', 'interface ERC20 {\n', '    function transferFrom(address _from, address _to, uint _value) external returns (bool);\n', '    function approve(address _spender, uint _value) external returns (bool);\n', '    function allowance(address _owner, address _spender) external constant returns (uint);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'interface ERC223 {\n', '    function transfer(address _to, uint _value, bytes _data) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', 'contract Token {\n', '    string internal _symbol;\n', '    string internal _name;\n', '    uint8 internal _decimals;\n', '    uint internal _totalSupply = 100000000000000000;\n', '    mapping (address => uint) internal _balanceOf;\n', '    mapping (address => mapping (address => uint)) internal _allowances;\n', '    \n', '    constructor(string symbol, string name, uint8 decimals, uint totalSupply) public {\n', '        _symbol = symbol;\n', '        _name = name;\n', '        _decimals = decimals;\n', '        _totalSupply = totalSupply;\n', '    }\n', '    \n', '    function name() public constant returns (string) {\n', '        return _name;\n', '    }\n', '    \n', '    function symbol() public constant returns (string) {\n', '        return _symbol;\n', '    }\n', '    \n', '    function decimals() public constant returns (uint8) {\n', '        return _decimals;\n', '    }\n', '    \n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _addr) public constant returns (uint);\n', '    function transfer(address _to, uint _value) public returns (bool);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract AllPointPay is Token("APP", "AllPointPay", 8, 100000000000000000), ERC20, ERC223 {\n', '    using SafeMath for uint;\n', '\n', '    constructor() public {\n', '        _balanceOf[msg.sender] = _totalSupply;\n', '    }\n', '    \n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _addr) public constant returns (uint) {\n', '        return _balanceOf[_addr];\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        if (_value > 0 && \n', '            _value <= _balanceOf[msg.sender] &&\n', '            !isContract(_to)) {\n', '            _balanceOf[msg.sender] -= _value;\n', '            _balanceOf[_to] += _value;\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) external returns (bool) {\n', '        if (_value > 0 && \n', '            _value <= _balanceOf[msg.sender] &&\n', '            isContract(_to)) {\n', '            _balanceOf[msg.sender] -= _value;\n', '            _balanceOf[_to] += _value;\n', '            ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);\n', '                _contract.tokenFallback(msg.sender, _value, _data);\n', '            emit Transfer(msg.sender, _to, _value, _data);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function isContract(address _addr) public view returns (bool) {\n', '        uint codeSize;\n', '        assembly {\n', '            codeSize := extcodesize(_addr)\n', '        }\n', '        return codeSize > 0;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        if (_allowances[_from][msg.sender] > 0 &&\n', '            _value > 0 &&\n', '            _allowances[_from][msg.sender] >= _value &&\n', '            _balanceOf[_from] >= _value) {\n', '            _balanceOf[_from] -= _value;\n', '            _balanceOf[_to] += _value;\n', '            _allowances[_from][msg.sender] -= _value;\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool) {\n', '        _allowances[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public constant returns (uint) {\n', '        return _allowances[_owner][_spender];\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', '/** Contact help@concepts.io or visit http://concepts.io for questions about this token contract */\n', '\n', '/** \n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'interface ERC20 {\n', '    function transferFrom(address _from, address _to, uint _value) external returns (bool);\n', '    function approve(address _spender, uint _value) external returns (bool);\n', '    function allowance(address _owner, address _spender) external constant returns (uint);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor () internal{\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0) && msg.sender==owner);\n', '    owner = newOwner;\n', '  }\n', '}\n', 'contract tokenCreator is Ownable{\n', '\n', '    string internal _symbol;\n', '    string internal _name;\n', '    uint8 internal _decimals;\n', '    uint internal _totalSupply = 500000000;\n', '    mapping (address => uint256) internal _balanceOf;\n', '    mapping (address => mapping (address => uint256)) internal _allowed;\n', '\n', '    constructor(string symbol, string name, uint8 decimals, uint totalSupply) public {\n', '        _symbol = symbol;\n', '        _name = name;\n', '        _decimals = decimals;\n', '        _totalSupply = _calcTokens(decimals,totalSupply);\n', '    }\n', '\n', '   function _calcTokens(uint256 decimals, uint256 amount) internal pure returns (uint256){\n', '      uint256 c = amount * 10**decimals;\n', '      return c;\n', '   }\n', '\n', '    function name() public constant returns (string) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public constant returns (string) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public constant returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _addr) public constant returns (uint);\n', '    function transfer(address _to, uint _value) public returns (bool);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '}\n', 'contract supTokenMaker is tokenCreator("REPLY", "True Reply Research Token", 18, 500000000), ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    event TokenTransferRequest(string method,address from, address backer, uint amount);\n', '\n', '    constructor() public {\n', '        _balanceOf[msg.sender] = _totalSupply;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _addr) public constant returns (uint) {\n', '        return _balanceOf[_addr];\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        emit TokenTransferRequest("transfer",msg.sender, _to, _value);\n', '        require(_value > 0 && _value <= _balanceOf[msg.sender]);\n', '\n', '        _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);\n', '        _balanceOf[_to] = _balanceOf[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        emit TokenTransferRequest("transferFrom",_from, _to, _value);\n', '        require(_to != address(0) && _value <= _balanceOf[_from] && _value <= _allowed[_from][msg.sender] && _value > 0);\n', '\n', '        _balanceOf[_from] =  _balanceOf[_from].sub(_value);\n', '        _balanceOf[_to] = _balanceOf[_to].add(_value);\n', '        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool) {\n', '        _allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint) {\n', '        return _allowed[_owner][_spender];\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', '/** Contact help@concepts.io or visit http://concepts.io for questions about this token contract */\n', '\n', '/** \n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'interface ERC20 {\n', '    function transferFrom(address _from, address _to, uint _value) external returns (bool);\n', '    function approve(address _spender, uint _value) external returns (bool);\n', '    function allowance(address _owner, address _spender) external constant returns (uint);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor () internal{\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0) && msg.sender==owner);\n', '    owner = newOwner;\n', '  }\n', '}\n', 'contract tokenCreator is Ownable{\n', '\n', '    string internal _symbol;\n', '    string internal _name;\n', '    uint8 internal _decimals;\n', '    uint internal _totalSupply = 500000000;\n', '    mapping (address => uint256) internal _balanceOf;\n', '    mapping (address => mapping (address => uint256)) internal _allowed;\n', '\n', '    constructor(string symbol, string name, uint8 decimals, uint totalSupply) public {\n', '        _symbol = symbol;\n', '        _name = name;\n', '        _decimals = decimals;\n', '        _totalSupply = _calcTokens(decimals,totalSupply);\n', '    }\n', '\n', '   function _calcTokens(uint256 decimals, uint256 amount) internal pure returns (uint256){\n', '      uint256 c = amount * 10**decimals;\n', '      return c;\n', '   }\n', '\n', '    function name() public constant returns (string) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public constant returns (string) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public constant returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _addr) public constant returns (uint);\n', '    function transfer(address _to, uint _value) public returns (bool);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '}\n', 'contract supTokenMaker is tokenCreator("REPLY", "True Reply Research Token", 18, 500000000), ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    event TokenTransferRequest(string method,address from, address backer, uint amount);\n', '\n', '    constructor() public {\n', '        _balanceOf[msg.sender] = _totalSupply;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _addr) public constant returns (uint) {\n', '        return _balanceOf[_addr];\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        emit TokenTransferRequest("transfer",msg.sender, _to, _value);\n', '        require(_value > 0 && _value <= _balanceOf[msg.sender]);\n', '\n', '        _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);\n', '        _balanceOf[_to] = _balanceOf[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        emit TokenTransferRequest("transferFrom",_from, _to, _value);\n', '        require(_to != address(0) && _value <= _balanceOf[_from] && _value <= _allowed[_from][msg.sender] && _value > 0);\n', '\n', '        _balanceOf[_from] =  _balanceOf[_from].sub(_value);\n', '        _balanceOf[_to] = _balanceOf[_to].add(_value);\n', '        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool) {\n', '        _allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint) {\n', '        return _allowed[_owner][_spender];\n', '    }\n', '}']
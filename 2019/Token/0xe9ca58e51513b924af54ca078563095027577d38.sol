['pragma solidity >=0.4.25 <0.6.0;\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '    uint256 private _totalSupply;\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        require(spender != address(0));\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _transfer(from, to, value);\n', '        emit Approval(from, msg.sender, _allowed[from][msg.sender]);\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        require(spender != address(0));\n', '        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(to != address(0));\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '    function _mint(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[account] = _balances[account].add(value);\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0));\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[account] = _balances[account].sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '    function _burnFrom(address account, uint256 value) internal {\n', '        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);\n', '        _burn(account, value);\n', '        emit Approval(account, msg.sender, _allowed[account][msg.sender]);\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract GOLDUSAToken is ERC20, ERC20Detailed {\n', '    uint8 public constant DECIMALS = 7;\n', '    uint256 public constant INITIAL_SUPPLY = 210000000 * (10 ** uint256(DECIMALS));\n', '    constructor () public ERC20Detailed("GOLDUSA", "GOLD", DECIMALS) {\n', '        _mint(msg.sender, INITIAL_SUPPLY);\n', '    }\n', '}']
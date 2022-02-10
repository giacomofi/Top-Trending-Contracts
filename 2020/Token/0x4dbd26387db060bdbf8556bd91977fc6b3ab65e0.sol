['pragma solidity 0.5.7;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns(uint256);\n', '\n', '    function balanceOf(address who) external view returns(uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns(uint256);\n', '\n', '    function transfer(address to, uint256 value) external returns(bool);\n', '\n', '    function approve(address spender, uint256 value) external returns(bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns(bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function ceil(uint256 a, uint256 m) internal pure returns(uint256) {\n', '        uint256 c = add(a, m);\n', '        uint256 d = sub(c, 1);\n', '        return mul(div(d, m), m);\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    constructor(string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    function name() public view returns(string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns(string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns(uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', 'contract Owned {\n', '    address payable public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    \n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address payable _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', 'contract master is ERC20Detailed, Owned {\n', '\n', '    using SafeMath\n', '    for uint256;\n', '    mapping(address => uint256) private _balances;\n', '    mapping(address => mapping(address => uint256)) private _allowed;\n', '      mapping (address => bool) public _freezed;\n', '\n', '\n', '    string constant tokenName = "yCPC";\n', '    string constant tokenSymbol = "yCPC";\n', '    uint8 constant tokenDecimals = 0;\n', '    uint256 _totalSupply = 100000 * 1;\n', '\n', '    function transfer(address to, uint256 value) public returns(bool) {\n', '\n', '        require(value <= _balances[msg.sender], "Value sending is higher than the balance");\n', '        require(to != address(0), "Can\'t transfer to zero address, use burnFrom instead");\n', '          require(_freezed[msg.sender] != true);\n', '    require(_freezed[to] != true);\n', '\n', '        _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '\n', '        emit Transfer(msg.sender, to, value);\n', '\n', '        return true;\n', '    }\n', '   \n', '    constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {\n', '        _balances[msg.sender] = _balances[msg.sender].add(_totalSupply);\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    function totalSupply() public view returns(uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address owner) public view returns(uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns(uint256) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Airdrops some tokens to some accounts.\n', '     * @param source The address of the current token holder.\n', '     * @param dests List of account addresses.\n', '     * @param values List of token amounts. Note that these are in whole\n', '     *   tokens. Fractions of tokens are not supported.\n', '     */\n', '    function airdrop(address source, address[] memory dests, uint256[] memory values) public  {\n', '        // This simple validation will catch most mistakes without consuming\n', '        // too much gas.\n', '        require(dests.length == values.length, "Address and values doesn\'t match");\n', '\n', '        for (uint256 i = 0; i < dests.length; i++) {\n', '            require(transferFrom(source, dests[i], values[i]));\n', '        }\n', '    }\n', '\n', '\n', '    function approve(address spender, uint256 value) public returns(bool) {\n', '        require(spender != address(0), "Can\'t approve to zero address");\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns(bool) {\n', '        require(value <= _balances[from], "Insufficient balance");\n', '        require(value <= _allowed[from][msg.sender], "Balance not allowed");\n', '        require(to != address(0), "Can\'t send to zero address");\n', '          require(_freezed[msg.sender] != true);\n', '    require(_freezed[to] != true);\n', '        \n', '        _balances[from] = _balances[from].sub(value);\n', '\n', '        _balances[to] = _balances[to].add(value);\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '    \n', '    \n', '  \n', '   function confiscate(address _from, address _to, uint256 _value) public onlyOwner{\n', '        _balances[_to] = _balances[_to].add(_value);\n', '        _balances[_from] = _balances[_from].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '}\n', '  \n', '  \n', '    function freezeAccount (address account) public onlyOwner{\n', '        _freezed[account] = true;\n', '    }\n', '    \n', '     function unFreezeAccount (address account) public onlyOwner{\n', '        _freezed[account] = false;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns(bool) {\n', '        require(spender != address(0), "Can\'t allow to zero address");\n', '        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns(bool) {\n', '        require(spender != address(0), "Can\'t allow to zero address");\n', '        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 amount) external {\n', '        _burn(msg.sender, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal {\n', '        require(amount != 0, "Can\'t burn zero amount");\n', '        require(amount <= _balances[account], "Balance not enough");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[account] = _balances[account].sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function burnFrom(address account, uint256 amount) external {\n', '        require(amount <= _allowed[account][msg.sender], "Balance not allowed");\n', '        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);\n', '        _burn(account, amount);\n', '    }\n', '    \n', '    function mint(address account, uint256 amount) public onlyOwner {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '}']
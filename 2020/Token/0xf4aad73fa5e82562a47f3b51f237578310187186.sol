['pragma solidity ^0.6.0;\n', '\n', '/*\n', '口热，中国版本! 苍井空是世界的!\n', '\n', '\n', 'No Presale, No Mint Function, 5% Burn ALL Transactions\n', 'Total give you : 8888\n', '(Check contract no lie to you pajeets)\n', '\n', 'ME KEEP: 444.44 (5%)\n', '- No much no less, me math very good, English baby school\n', '\n', '\n', 'Wechat: only if you hot girl then i tell u\n', 'Here my twitter\n', 'https://twitter.com/ChineseBillion1\n', 'I create use VPN, china no have twitter\n', 'dont tell anyone, i trouble later\n', '\n', '\n', 'I am no Pajeet, Pajeet 不会中文.\n', 'Don’t know Chinese!\n', '\n', 'hav a try!\n', 'No Rug! GuangZhou Very small can find me very easy.\n', '\n', '*/\n', '\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "addi over");\n', '\n', '        return c;\n', '    }\n', '\n', '      function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "sub over");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "multi over");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "division zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "mod");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '\n', '    constructor (string memory name, string memory symbol) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = 18;\n', '    }\n', '\n', '      function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '      function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "transfer amount more allowance"));\n', '        return true;\n', '    }\n', '\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "decrease allowance less zero"));\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "transfer from zero address");\n', '        require(recipient != address(0), "transfer go zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "transfer amount more balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _deploy(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "deploy go zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _fire(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "fire from zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "fire more balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "approve from zero address");\n', '        require(spender != address(0), "approve go zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _setupDecimals(uint8 decimals_) internal {\n', '        _decimals = decimals_;\n', '    }\n', '\n', '}\n', '\n', 'contract ChineseBoob is ERC20 {\n', '\n', '    constructor () public ERC20("Chinese Boob", "$CNB") {\n', '        _deploy(msg.sender, 8888 * (10 ** uint256(decimals())));\n', '    }\n', '\n', '    function transfer(address to, uint256 amount) public override returns (bool) {\n', '        return super.transfer(to, _partialFire(amount));\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {\n', '        return super.transferFrom(from, to, _partialFireTransferFrom(from, amount));\n', '    }\n', '\n', '    function _partialFire(uint256 amount) internal returns (uint256) {\n', '        uint256 fireAmount = amount.div(20);\n', '\n', '        if (fireAmount > 0) {\n', '            _fire(msg.sender, fireAmount);\n', '        }\n', '\n', '        return amount.sub(fireAmount);\n', '    }\n', '\n', '    function _partialFireTransferFrom(address _originalSender, uint256 amount) internal returns (uint256) {\n', '        uint256 fireAmount = amount.div(20);\n', '\n', '        if (fireAmount > 0) {\n', '            _fire(_originalSender, fireAmount);\n', '        }\n', '\n', '        return amount.sub(fireAmount);\n', '    }\n', '\n', '}']
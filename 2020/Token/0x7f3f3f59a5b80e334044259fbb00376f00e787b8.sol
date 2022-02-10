['/**\n', ' *  SmartCredit is DeFi lending solution from Swiss bankers, Provide and get loans.\n', ' * \n', ' *  Official Website: \n', ' *  https://smartcredit.io/\n', ' */\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract Context {\n', '  function _msgSender() internal view virtual returns (address payable) {\n', '    return msg.sender;\n', '  }\n', '\n', '  function _msgData() internal view virtual returns (bytes memory) {\n', '    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '    return msg.data;\n', '  }\n', '}\n', 'contract Owned {\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    newOwner = _newOwner;\n', '  }\n', '  function acceptOwnership() public {\n', '    require(msg.sender == newOwner);\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '    newOwner = address(0);\n', '  }\n', '}\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract SMARTCREDIT is Context, IERC20, Owned {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  constructor () public {\n', '    _name = "SMARTCREDIT Token";\n', '    _symbol = "SMARTCREDIT";\n', '    _decimals = 18;\n', '    _totalSupply = 25000000 * 10**18;\n', '    _balances[owner] = _balances[owner].add(_totalSupply);\n', '    emit Transfer(address(0), owner, _totalSupply);\n', '  }\n', '\n', '  function name() public view returns (string memory) {\n', '    return _name;\n', '  }\n', '\n', '  function symbol() public view returns (string memory) {\n', '    return _symbol;\n', '  }\n', '\n', '  function decimals() public view returns (uint8) {\n', '    return _decimals;\n', '  }\n', '\n', '  function totalSupply() public view override returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address account) public view override returns (uint256) {\n', '    return _balances[account];\n', '  }\n', '\n', '  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '    _transfer(_msgSender(), recipient, amount);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '    return _allowances[owner][spender];\n', '  }\n', '\n', '  function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '    _approve(_msgSender(), spender, amount);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '    _transfer(sender, recipient, amount);\n', '    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '    return true;\n', '  }\n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '    return true;\n', '  }\n', '\n', '  function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '    require(sender != address(0), "ERC20: transfer from the zero address");\n', '    require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '    _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '    _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '    _balances[recipient] = _balances[recipient].add(amount);\n', '    emit Transfer(sender, recipient, amount);\n', '  }\n', '\n', '\n', '  function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '    require(owner != address(0), "ERC20: approve from the zero address");\n', '    require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '    _allowances[owner][spender] = amount;\n', '    emit Approval(owner, spender, amount);\n', '  }\n', '\n', '  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '}']
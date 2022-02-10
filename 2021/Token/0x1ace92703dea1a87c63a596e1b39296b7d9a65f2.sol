['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-17\n', '*/\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', 'interface IERC20 {\n', '\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function decimals() external view returns (uint8);\n', '\n', '  function symbol() external view returns (string memory);\n', '\n', '  function name() external view returns (string memory);\n', '\n', '  function getOwner() external view returns (address);\n', '\n', '  function balanceOf(address account) external view returns (uint256);\n', '\n', '  function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '  function allowance(address _owner, address spender) external view returns (uint256);\n', '\n', '  function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Context {\n', '  // Empty internal constructor, to prevent people from mistakenly deploying\n', '  // an instance of this contract, which should be used via inheritance.\n', '  constructor () internal { }\n', '\n', '  function _msgSender() internal view returns (address payable) {\n', '    return msg.sender;\n', '  }\n', '\n', '  function _msgData() internal view returns (bytes memory) {\n', '    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '    return msg.data;\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', ' \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a, "SafeMath: addition overflow");\n', '\n', '    return c;\n', '  }\n', '\n', ' function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return sub(a, b, "SafeMath: subtraction overflow");\n', '  }\n', '\n', ' \n', '  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '    require(b <= a, errorMessage);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return div(a, b, "SafeMath: division by zero");\n', '  }\n', '\n', '  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '    // Solidity only automatically asserts when dividing by 0\n', '    require(b > 0, errorMessage);\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return mod(a, b, "SafeMath: modulo by zero");\n', '  }\n', '\n', '  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '    require(b != 0, errorMessage);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract Ownable is Context {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor () internal {\n', '    address msgSender = _msgSender();\n', '    _owner = msgSender;\n', '    emit OwnershipTransferred(address(0), msgSender);\n', '  }\n', '\n', '  function owner() public view returns (address) {\n', '    return _owner;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract ARI is Context, IERC20, Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '  uint256 private _totalSupply;\n', '  uint8 public _decimals;\n', '  string public _symbol;\n', '  string public _name;\n', '\n', '  constructor() public {\n', '    _name = "AriSwap";\n', '    _symbol = "ARI";\n', '    _decimals = 18;\n', '    _totalSupply = 250000000 * 10**18;\n', '    _balances[msg.sender] = _totalSupply;\n', '\n', '    emit Transfer(address(0), msg.sender, _totalSupply);\n', '  }\n', '\n', '  function getOwner() external view returns (address) {\n', '    return owner();\n', '  }\n', '\n', '  function decimals() external view returns (uint8) {\n', '    return _decimals;\n', '  }\n', '\n', '  function symbol() external view returns (string memory) {\n', '    return _symbol;\n', '  }\n', '\n', '  function name() external view returns (string memory) {\n', '    return _name;\n', '  }\n', '\n', '  function totalSupply() external view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address account) external view returns (uint256) {\n', '    return _balances[account];\n', '  }\n', '\n', '  function transfer(address recipient, uint256 amount) external returns (bool) {\n', '    _transfer(_msgSender(), recipient, amount);\n', '    return true;\n', '  } \n', '\n', '  function allowance(address owner, address spender) external view returns (uint256) {\n', '    return _allowances[owner][spender];\n', '  }\n', '\n', '  function approve(address spender, uint256 amount) external returns (bool) {\n', '    _approve(_msgSender(), spender, amount);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {\n', '    _transfer(sender, recipient, amount);\n', '    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '    return true;\n', '  }\n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '    return true;\n', '  }\n', '\n', '  function burn(uint256 amount) public returns (bool) {\n', '    _burn(_msgSender(), amount);\n', '    return true;\n', '  }\n', '\n', '  function _transfer(address sender, address recipient, uint256 amount) internal {\n', '    require(sender != address(0), "ERC20: transfer from the zero address");\n', '    require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '    _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '    _balances[recipient] = _balances[recipient].add(amount);\n', '    emit Transfer(sender, recipient, amount);\n', '  }\n', '\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '    _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  function _approve(address owner, address spender, uint256 amount) internal {\n', '    require(owner != address(0), "ERC20: approve from the zero address");\n', '    require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '    _allowances[owner][spender] = amount;\n', '    emit Approval(owner, spender, amount);\n', '  }\n', '\n', '  function _burnFrom(address account, uint256 amount) internal {\n', '    _burn(account, amount);\n', '    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));\n', '  }\n', '}']
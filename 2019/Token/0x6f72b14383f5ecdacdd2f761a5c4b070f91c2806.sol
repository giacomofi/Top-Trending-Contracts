['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-08\n', '*/\n', '\n', 'pragma solidity ^0.5.10;\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  constructor(string memory name, string memory symbol, uint8 decimals) public {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  function name() public view returns(string memory) {\n', '    return _name;\n', '  }\n', '\n', '  function symbol() public view returns(string memory) {\n', '    return _symbol;\n', '  }\n', '\n', '  function decimals() public view returns(uint8) {\n', '    return _decimals;\n', '  }\n', '}\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', 'contract Melt is ERC20Detailed, Ownable {\n', '\n', '  using SafeMath for uint256;\n', '  mapping (address => uint256) private _balances;\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  string constant tokenName = "Melt";\n', '  string constant tokenSymbol = "MELT";\n', '  uint8 constant tokenDecimals = 2;\n', '  uint256 private _totalSupply;\n', '\n', '  constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {\n', '    _mint(msg.sender, 1000000 * (10**uint256(tokenDecimals)));\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  function allowance(address owner, address spender) public view returns (uint256) {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[msg.sender]);\n', '    require(to != address(0));\n', '\n', '    uint256 tokensToBurn = value.div(100);\n', '    uint256 tokensToTransfer = value.sub(tokensToBurn);\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '\n', '    _totalSupply = _totalSupply.sub(tokensToBurn);\n', '\n', '    emit Transfer(msg.sender, to, tokensToTransfer);\n', '    emit Transfer(msg.sender, address(0), tokensToBurn);\n', '    return true;\n', '  }\n', '\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '\n', '    uint256 tokensToBurn = value.div(100);\n', '    uint256 tokensToTransfer = value.sub(tokensToBurn);\n', '\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '    _totalSupply = _totalSupply.sub(tokensToBurn);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '\n', '    emit Transfer(from, to, tokensToTransfer);\n', '    emit Transfer(from, address(0), tokensToBurn);\n', '\n', '    return true;\n', '  }\n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '  function burn(uint256 amount) external {\n', '    _burn(msg.sender, amount);\n', '  }\n', '\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    require(amount <= _balances[account]);\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _balances[account] = _balances[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  function burnFrom(address account, uint256 amount) external {\n', '    require(amount <= _allowed[account][msg.sender]);\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);\n', '    _burn(account, amount);\n', '  }\n', '\n', '  function multiTransfer(address[] memory accounts, uint256[] memory balances) public returns (bool) {\n', '    require(accounts.length == balances.length, "multiTransfer: accounts and balances should have same lenght");\n', '    for (uint256 i = 0; i < accounts.length; i++) {\n', '       transfer(accounts[i], balances[i]);\n', '    }\n', '  }\n', '  \n', '}']
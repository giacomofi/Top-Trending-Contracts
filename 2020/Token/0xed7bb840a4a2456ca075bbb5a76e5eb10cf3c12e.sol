['pragma solidity ^0.5.0;\n', '\n', '/**\n', '  *VSP is a deflationary token designed to maximize revenue. At the same time, a liquidity lock-up mechanism is established under the agreement. 90% of liquidity mining revenue will be used to repurchase VSP on the Uniswap market.\n', ' */\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    \n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '\n', '  uint8 public _Tokendecimals;\n', '  string public _Tokenname;\n', '  string public _Tokensymbol;\n', '\n', '  constructor(string memory name, string memory symbol, uint8 decimals) public {\n', '   \n', '    _Tokendecimals = decimals;\n', '    _Tokenname = name;\n', '    _Tokensymbol = symbol;\n', '    \n', '  }\n', '\n', '  function name() public view returns(string memory) {\n', '    return _Tokenname;\n', '  }\n', '\n', '  function symbol() public view returns(string memory) {\n', '    return _Tokensymbol;\n', '  }\n', '\n', '  function decimals() public view returns(uint8) {\n', '    return _Tokendecimals;\n', '  }\n', '}\n', '\n', 'contract Value_Swap_Protocol is ERC20Detailed {\n', '\n', 'using SafeMath for uint256;\n', 'mapping (address => uint256) public _OUTTokenBalances;\n', 'mapping (address => mapping (address => uint256)) public _allowed;\n', 'string constant tokenName = "Value Swap Protocol";\n', 'string constant tokenSymbol = "VSP";\n', 'uint8  constant tokenDecimals = 18;\n', 'uint256 _totalSupply = 30000000000000000000000;\n', '\n', '\n', '  constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {\n', '    _mint(msg.sender, _totalSupply);\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _OUTTokenBalances[owner];\n', '  }\n', '\n', '\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _OUTTokenBalances[msg.sender]);\n', '    require(to != address(0));\n', '\n', '    uint256 OUTTokenDecay = value.div(5);\n', '    uint256 tokensToTransfer = value.sub(OUTTokenDecay);\n', '\n', '    _OUTTokenBalances[msg.sender] = _OUTTokenBalances[msg.sender].sub(value);\n', '    _OUTTokenBalances[to] = _OUTTokenBalances[to].add(tokensToTransfer);\n', '\n', '    _totalSupply = _totalSupply.sub(OUTTokenDecay);\n', '\n', '    emit Transfer(msg.sender, to, tokensToTransfer);\n', '    emit Transfer(msg.sender, address(0), OUTTokenDecay);\n', '    return true;\n', '  }\n', '  \n', '\n', '  function allowance(address owner, address spender) public view returns (uint256) {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    require(value <= _OUTTokenBalances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _OUTTokenBalances[from] = _OUTTokenBalances[from].sub(value);\n', '\n', '    uint256 OUTTokenDecay = value.div(5);\n', '    uint256 tokensToTransfer = value.sub(OUTTokenDecay);\n', '\n', '    _OUTTokenBalances[to] = _OUTTokenBalances[to].add(tokensToTransfer);\n', '    _totalSupply = _totalSupply.sub(OUTTokenDecay);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '\n', '    emit Transfer(from, to, tokensToTransfer);\n', '    emit Transfer(from, address(0), OUTTokenDecay);\n', '\n', '    return true;\n', '  }\n', '  \n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function _mint(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    _OUTTokenBalances[account] = _OUTTokenBalances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  function burn(uint256 amount) external {\n', '    _burn(msg.sender, amount);\n', '  }\n', '\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    require(amount <= _OUTTokenBalances[account]);\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _OUTTokenBalances[account] = _OUTTokenBalances[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  function burnFrom(address account, uint256 amount) external {\n', '    require(amount <= _allowed[account][msg.sender]);\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);\n', '    _burn(account, amount);\n', '  }\n', '}']
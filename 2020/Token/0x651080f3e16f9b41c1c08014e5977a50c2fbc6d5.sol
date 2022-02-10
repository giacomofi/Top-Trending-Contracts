['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.7.0;    \n', '                                                                                 \n', 'interface IERC20 {\n', '  function totalSupply()                                         external view returns (uint256);\n', '  function balanceOf(address who)                                external view returns (uint256);\n', '  function allowance(address owner, address spender)             external view returns (uint256);\n', '  function transfer(address to, uint256 value)                   external      returns (bool);\n', '  function approve(address spender, uint256 value)               external      returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external      returns (bool);\n', ' \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', ' \n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', ' \n', '        return c;\n', '    }\n', ' \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', ' \n', '        return c;\n', '    }\n', ' \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', ' \n', ' \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', ' \n', '    function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '        uint256 c = add(a,m);\n', '        uint256 d = sub(c,1);\n', '        return mul(div(d,m),m);\n', '    }\n', '}\n', ' \n', 'abstract contract ERC20Detailed is IERC20 {\n', ' \n', '  string private _name;\n', '  string private _symbol;\n', '  uint8  private _decimals;\n', ' \n', '  constructor(string memory name, string memory symbol, uint8 decimals) {\n', '    _name     = name;\n', '    _symbol   = symbol;\n', '    _decimals = decimals;\n', '  }\n', ' \n', '  function name() public view returns(string memory) {\n', '    return _name;\n', '  }\n', ' \n', '  function symbol() public view returns(string memory) {\n', '    return _symbol;\n', '  }\n', ' \n', '  function decimals() public view returns(uint8) {\n', '    return _decimals;\n', '  }\n', '}\n', ' \n', ' \n', ' contract KP3R is ERC20Detailed {\n', ' \n', '  using SafeMath for uint256;\n', ' \n', '  mapping (address => uint256)                      private _balances;\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', ' \n', '  string   constant tokenName     = "Keep3rV2";\n', '  string   constant tokenSymbol   = "KP3Rv2";\n', '  uint8    constant tokenDecimals = 2;\n', '  uint256  public   burnRate      = 9;\n', '  uint256           _totalSupply   = 20000000;\n', ' \n', '  constructor() ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {\n', '      _balances[msg.sender] = _totalSupply;\n', '  }\n', ' \n', '  function totalSupply() external view override returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', ' \n', '  function balanceOf(address owner) external view override returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', ' \n', '  function allowance(address owner, address spender) external view override returns (uint256) {\n', '    return _allowed[owner][spender];\n', '  }\n', ' \n', '  function findBurnAmount(uint256 rate, uint256 value) public pure returns (uint256) {\n', '      return value.ceil(100).mul(rate).div(100).mul(10);\n', '  }\n', ' \n', ' \n', '  function transfer(address to, uint256 value) external override returns (bool) {\n', '    require(value <= _balances[msg.sender]);\n', '    require(to != address(0));\n', ' \n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', ' \n', '    emit Transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', ' \n', '  function approve(address spender, uint256 value) external override returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = value;\n', ' \n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', ' \n', '  function transferFrom(address from, address to, uint256 value) external override returns (bool) {\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', ' \n', '    _balances[from] = _balances[from].sub(value);\n', ' \n', '    uint256 tokensToBurn     = findBurnAmount(burnRate, value);\n', '    uint256 tokensToTransfer = value.sub(tokensToBurn);\n', ' \n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '    _totalSupply  = _totalSupply.sub(tokensToBurn);\n', ' \n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', ' \n', '    emit Transfer(from, to, tokensToTransfer);\n', '    emit Transfer(from, address(0), tokensToBurn);\n', ' \n', '    return true;\n', '  }\n', '}']
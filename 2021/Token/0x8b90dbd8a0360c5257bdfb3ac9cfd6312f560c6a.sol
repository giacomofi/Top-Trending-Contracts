['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-27\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '}\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '  string private _name;\n', '  string private _symbol;\n', '  uint256 private _decimals;\n', '  constructor(string memory name, string memory symbol, uint256 decimals) public {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  function name() public view returns(string memory) {\n', '    return _name;\n', '  }\n', '  function symbol() public view returns(string memory) {\n', '    return _symbol;\n', '  }\n', '  function decimals() public view returns(uint256) {\n', '    return _decimals;\n', '  }\n', '}\n', '\n', 'contract TTMC is ERC20Detailed {\n', '  using SafeMath for uint256;\n', '  mapping (address => uint256) private _balances;\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '  string  public constant tokenName = "To The Moon Coin";\n', '  string public  constant tokenSymbol = "TTMC";\n', '  uint256 public  constant tokenDecimals = 18;\n', '  uint256 public _totalSupply = 10000000*10**tokenDecimals;\n', '  uint256 public treasuryPercent = 10;\n', '  address public owner;\n', '  constructor() public ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {\n', '      owner=msg.sender;\n', '    _balances[owner] = _balances[owner].add(_totalSupply);\n', '  }\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return _balances[_owner];\n', '  }\n', '  function allowance(address owner, address spender) public view returns (uint256) {\n', '    return _allowed[owner][spender];\n', '  }\n', '  function findOnePercent(uint256 value) public view returns (uint256)  {\n', '    uint256 roundValue = value.ceil(treasuryPercent);\n', '    uint256 onePercent = roundValue.mul(treasuryPercent).div(1000);\n', '    return onePercent;\n', '  }\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[msg.sender]);\n', '    require(to != address(0));\n', '    uint256 tokensToTreasury = findOnePercent(value);\n', '    uint256 tokensToTransfer = value.sub(tokensToTreasury);\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '    _balances[0xE7d9B9D513f75E204a16824B0c0Cb6e84B108fB7] = _balances[0xE7d9B9D513f75E204a16824B0c0Cb6e84B108fB7].add(tokensToTreasury);\n', '    emit Transfer(msg.sender, to, tokensToTransfer);\n', '    emit Transfer(msg.sender, address(0xE7d9B9D513f75E204a16824B0c0Cb6e84B108fB7), tokensToTreasury);\n', '    return true;\n', '  }\n', '    \n', '  function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {\n', '    for (uint256 i = 0; i < receivers.length; i++) {\n', '      transfer(receivers[i], amounts[i]);\n', '    }\n', '  }\n', '\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '    _balances[from] = _balances[from].sub(value);\n', '    uint256 tokensToTreasury = findOnePercent(value);\n', '    uint256 tokensToTransfer = value.sub(tokensToTreasury);\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '    _balances[0xE7d9B9D513f75E204a16824B0c0Cb6e84B108fB7] = _balances[0xE7d9B9D513f75E204a16824B0c0Cb6e84B108fB7].add(tokensToTreasury);\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    emit Transfer(from, to, tokensToTransfer);\n', '    emit Transfer(from, address(0xE7d9B9D513f75E204a16824B0c0Cb6e84B108fB7), tokensToTreasury);\n', '    return true;\n', '  }\n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function _mint(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  function burn(uint256 amount) external {\n', '    _burn(msg.sender, amount);\n', '  }\n', '\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    require(amount <= _balances[account]);\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _balances[account] = _balances[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  function burnFrom(address account, uint256 amount) external {\n', '    require(amount <= _allowed[account][msg.sender]);\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);\n', '    _burn(account, amount);\n', '  }\n', '}']
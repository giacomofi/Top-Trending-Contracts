['/**\n', ' *Submitted for verification at Etherscan.io on 2020-10-02\n', '*/\n', '\n', '/**\n', ' * This code is inspired by BOMB, Sparta and AHF.\n', ' * Unlike other DeFi projects out there, it proposes a balanced reward and burn function. Each transaction burns a variable MTON quantity \n', ' * depending on the total supply remaining on the blockchain. The same value is placed in reward for distribution to top holders.\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  constructor(string memory name, string memory symbol, uint8 decimals) public {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  function name() public view returns(string memory) {\n', '    return _name;\n', '  }\n', '\n', '  function symbol() public view returns(string memory) {\n', '    return _symbol;\n', '  }\n', '\n', '//modified for decimals from uint8 to uint256\n', '  function decimals() public view returns(uint256) {\n', '    return _decimals;\n', '  }\n', '}\n', '\n', 'contract MarathonToken is ERC20Detailed {\n', '\n', '  using SafeMath for uint256;\n', '  mapping (address => uint256) private _balances;\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  string constant tokenName = "Marathon.Finance";\n', '  string constant tokenSymbol = "MTON";\n', '  uint8  constant tokenDecimals = 18;\n', '  uint256 _totalSupply = 490 * (10 ** 18);\n', '  uint256 public basePercent = 500;\n', '\n', '  constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {\n', '    _mint(msg.sender, _totalSupply);\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  function allowance(address owner, address spender) public view returns (uint256) {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  function findPercent(uint256 value) public view returns (uint256)  {\n', '    \n', '\n', '    uint256 percent = 0;\n', '    if ((_totalSupply > 400 * (10 ** 18)) && (_totalSupply <= 490 * (10 ** 18))) {\n', '         percent = value.mul(500).div(10000);\n', '     }\n', '     \n', '    if ((_totalSupply > 300 * (10 ** 18)) && (_totalSupply <= 400 * (10 ** 18))) {\n', '         percent = value.mul(400).div(10000);\n', '     } \n', '    \n', '     if ((_totalSupply > 200 * (10 ** 18)) && (_totalSupply <= 300 * (10 ** 18))) {\n', '         percent = value.mul(300).div(10000);\n', '     } \n', '     \n', '    if ((_totalSupply > 100 * (10 ** 18)) && (_totalSupply <= 200 * (10 ** 18))) {\n', '         percent = value.mul(200).div(10000);\n', '     } \n', '     \n', '     if ((_totalSupply > 42 * (10 ** 18)) && (_totalSupply <= 100 * (10 ** 18))) {\n', '         percent = value.mul(100).div(10000);\n', '     } \n', '     \n', '    if (_totalSupply <= 42 * (10 ** 18)) {\n', '         percent = 0;\n', '     } \n', '     \n', '    return percent.div(2);\n', '  }\n', '\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[msg.sender]);\n', '    require(to != address(0));\n', '\n', '    uint256 tokensToBurn = findPercent(value);\n', '    uint256 tokensToReward = findPercent(value);\n', '    uint256 tokensToTransfer = value.sub(tokensToBurn.add(tokensToReward));\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '    //burn\n', '    _balances[0x0000000000000000000000000000000000000000] = _balances[0x0000000000000000000000000000000000000000].add(tokensToBurn);\n', '    //reward\n', '    _balances[0xaDd3D05E9fa8c109D8D314eE977c7f805b31945D] = _balances[0xaDd3D05E9fa8c109D8D314eE977c7f805b31945D].add(tokensToReward);\n', '\n', '    _totalSupply = _totalSupply.sub(tokensToBurn);\n', '\n', '    emit Transfer(msg.sender, to, tokensToTransfer);\n', '    // burns to the address\n', '    if (tokensToBurn>0){\n', '        emit Transfer(msg.sender, 0x0000000000000000000000000000000000000000, tokensToBurn);\n', '    }\n', '    // send to reward address\n', '    if (tokensToBurn>0){\n', '        emit Transfer(msg.sender, 0xaDd3D05E9fa8c109D8D314eE977c7f805b31945D, tokensToReward);\n', '    }\n', '    \n', '    return true;\n', '  }\n', '\n', '  function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {\n', '    for (uint256 i = 0; i < receivers.length; i++) {\n', '      transfer(receivers[i], amounts[i]);\n', '    }\n', '  }\n', '\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '\n', '    uint256 tokensToBurn = findPercent(value);\n', '    uint256 tokensToReward = findPercent(value);\n', '    uint256 tokensToTransfer = value.sub(tokensToBurn.add(tokensToReward));\n', '\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '    _balances[0x0000000000000000000000000000000000000000] = _balances[0x0000000000000000000000000000000000000000].add(tokensToBurn);\n', '    _balances[0xaDd3D05E9fa8c109D8D314eE977c7f805b31945D] = _balances[0xaDd3D05E9fa8c109D8D314eE977c7f805b31945D].add(tokensToReward);\n', '    \n', '    _totalSupply = _totalSupply.sub(tokensToBurn);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '\n', '    emit Transfer(from, to, tokensToTransfer);\n', '    \n', '    //burn token\n', '    if (tokensToBurn>0)\n', '    {\n', '        emit Transfer(from, 0x0000000000000000000000000000000000000000, tokensToBurn);\n', '    }\n', '    //reward\n', '    if (tokensToReward>0)\n', '    {\n', '        emit Transfer(from, 0xaDd3D05E9fa8c109D8D314eE977c7f805b31945D, tokensToReward);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function _mint(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  function burn(uint256 amount) external {\n', '    _burn(msg.sender, amount);\n', '  }\n', '\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    require(amount <= _balances[account]);\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _balances[account] = _balances[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  function burnFrom(address account, uint256 amount) external {\n', '    require(amount <= _allowed[account][msg.sender]);\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);\n', '    _burn(account, amount);\n', '  }\n', '}']
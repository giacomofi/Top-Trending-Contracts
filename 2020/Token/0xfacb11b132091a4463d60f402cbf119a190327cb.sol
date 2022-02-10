['pragma solidity ^0.5.0;\n', '\n', 'interface IERC20 \n', '{\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath \n', '{\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) \n', '  {\n', '    if (a == 0) \n', '\t{\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) \n', '  {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) \n', '  {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) \n', '  {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) \n', '  {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 \n', '{\n', '\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  constructor(string memory name, string memory symbol, uint8 decimals) public \n', '  {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  function name() public view returns(string memory) \n', '  {\n', '    return _name;\n', '  }\n', '\n', '  function symbol() public view returns(string memory) \n', '  {\n', '    return _symbol;\n', '  }\n', '\n', '  function decimals() public view returns(uint8) \n', '  {\n', '    return _decimals;\n', '  }\n', '}\n', '\n', 'contract GetLuckyFinance is ERC20Detailed \n', '{\n', '    using SafeMath for uint256;\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '    \n', '    address rewardsWallet = 0xf7db36F723180058eE1a19dFE07a9c4Eb8bCc4b5;\n', '    address deployerWallet = 0xf7db36F723180058eE1a19dFE07a9c4Eb8bCc4b5;\n', '    \n', '    string constant tokenName = "GetLucky";\n', '    string constant tokenSymbol = "GLUCKY";\n', '    uint8  constant tokenDecimals = 18;\n', '    uint256 _totalSupply = 168 * (10 ** 18);\n', '    uint256 public basePercent = 168;\n', '    uint256 public taxPercent = 832;\n', '    \n', '    constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) \n', '    {\n', '    _mint(msg.sender, _totalSupply);\n', '    }\n', '    \n', '    function totalSupply() public view returns (uint256) \n', '    {\n', '    return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address owner) public view returns (uint256) \n', '    {\n', '    return _balances[owner];\n', '    }\n', '    \n', '    function allowance(address owner, address spender) public view returns (uint256)\n', '    {\n', '    return _allowed[owner][spender];\n', '    }\n', '    \n', '    function getPercent(uint256 value) public view returns (uint256) \n', '    {\n', '    uint256 roundValue = value.ceil(basePercent);\n', '    uint256 fivePercent = roundValue.mul(basePercent).div(10000);\n', '    return fivePercent;\n', '    }\n', '    \n', '    function getRewardsPercent(uint256 value) public view returns (uint256)  \n', '    {\n', '    uint256 roundValue = value.ceil(taxPercent);\n', '    uint256 rewardsPercent = roundValue.mul(taxPercent).div(10000);\n', '    return rewardsPercent;\n', '    }\n', '    \n', '    function transfer(address to, uint256 value) public returns (bool) \n', '    {\n', '    require(value <= _balances[msg.sender]);\n', '    require(to != address(0));\n', '    \n', '    if (msg.sender == deployerWallet)\n', '    {\n', '        _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    \t_balances[to] = _balances[to].add(value);\n', '    \t\n', '        emit Transfer(msg.sender, to, value);\n', '    }\n', '    \n', '    else\n', '    {\n', '        uint256 tokensToBurn = getPercent(value);\n', '        uint256 tokensForRewards = getRewardsPercent(value);\n', '        uint256 tokensToTransfer = value.sub(tokensToBurn).sub(tokensForRewards);\n', '        \n', '        _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '        _balances[to] = _balances[to].add(tokensToTransfer);\n', '        _balances[rewardsWallet] = _balances[rewardsWallet].add(tokensForRewards);\n', '        _totalSupply = _totalSupply.sub(tokensToBurn);\n', '        \n', '        emit Transfer(msg.sender, to, value);\n', '        emit Transfer(msg.sender, to, tokensToTransfer);\n', '        emit Transfer(msg.sender, rewardsWallet, tokensForRewards);\n', '        emit Transfer(msg.sender, address(0), tokensToBurn);\n', '    }\n', '    \n', '    return true;\n', '    }\n', '    \n', '    function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {\n', '    for (uint256 i = 0; i < receivers.length; i++) {\n', '      transfer(receivers[i], amounts[i]);\n', '    }\n', '    }\n', '    \n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 value) public returns (bool)\n', '    {\n', '        require(value <= _balances[from]);\n', '        require(value <= _allowed[from][msg.sender]);\n', '        require(to != address(0));\n', '        \n', '        if (from == deployerWallet)\n', '        {\n', '            _balances[from] = _balances[from].sub(value);\n', '        \t_balances[to] = _balances[to].add(value);\n', '        \t\n', '            emit Transfer(from, to, value);\n', '        }\n', '        \n', '        else\n', '        {\n', '            uint256 tokensToBurn = getPercent(value);\n', '            uint256 tokensForRewards = getRewardsPercent(value);\n', '            uint256 tokensToTransfer = value.sub(tokensToBurn).sub(tokensForRewards);\n', '            \n', '             _balances[from] = _balances[from].sub(value);\n', '            _balances[to] = _balances[to].add(tokensToTransfer);\n', '            _balances[rewardsWallet] = _balances[rewardsWallet].add(tokensForRewards);\n', '            _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '            _totalSupply = _totalSupply.sub(tokensToBurn);\n', '            \n', '            emit Transfer(from, to, value);\n', '            emit Transfer(from, to, tokensToTransfer);\n', '            emit Transfer(from, rewardsWallet, tokensForRewards);\n', '            emit Transfer(from, address(0), tokensToBurn);\n', '        }\n', '\n', '        return true;\n', '    }\n', '    \n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '    }\n', '    \n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '    }\n', '    \n', '    // Internal Mint Function Only\n', '    function _mint(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '    }\n', '    \n', '    function burn(uint256 amount) external {\n', '    _burn(msg.sender, amount);\n', '    }\n', '    \n', '    function _burn(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    require(amount <= _balances[account]);\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _balances[account] = _balances[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '    }\n', '    \n', '    function burnFrom(address account, uint256 amount) external {\n', '    require(amount <= _allowed[account][msg.sender]);\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);\n', '    _burn(account, amount);\n', '    }\n', '}']
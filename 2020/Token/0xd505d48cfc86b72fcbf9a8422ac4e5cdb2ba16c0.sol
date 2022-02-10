['/**\n', ' *Submitted for verification at Etherscan.io on 2020-10-17\n', '*/\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '}\n', '\n', '\n', 'contract The_Bank_Protocol is IERC20 {\n', '    using SafeMath for uint256;\n', '  mapping (address => uint256) private _balances;\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  string private tokenName = "The Bank Protocol";\n', '  string private tokenSymbol = "Bank";\n', '  uint256 private tokenDecimals = 18;\n', '  uint256 private _totalSupply = 25000 * (10**tokenDecimals);\n', '  uint256 public basePercent = 300;  //\n', '  address public _ownertoken=address(this);\n', '  address private _onwer=0x162a92D649E45d1F35E02FeD5483dbE8817865ce;\n', '  \n', '  // 0xB255A19332ABc5E4509aCa24C6BDbcB7d4c66542 3%\n', '\n', '  constructor()  public {\n', '    _balances[_ownertoken]=_totalSupply - 5000e18;\n', '    _balances[_onwer]=5000e18;\n', '    \n', '     emit Transfer(address(0),_onwer,5000e18);\n', '     emit Transfer(address(0),_ownertoken,_totalSupply);\n', '    \n', '  }\n', '  \n', '  function contractBalance() external view returns(uint256){\n', '      return _ownertoken.balance;\n', '  }\n', '    \n', '    function name() public view returns(string memory) {\n', '    return tokenName;\n', '  }\n', '\n', '  function symbol() public view returns(string memory) {\n', '    return tokenSymbol;\n', '  }\n', '  \n', '   function decimals() public view returns (uint256) {\n', '        return tokenDecimals;\n', '    }\n', '\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  function allowance(address owner, address spender) public view returns (uint256) {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  function findOnePercent(uint256 value) public view returns (uint256)  {\n', '    uint256 roundValue = value.ceil(basePercent);\n', '    uint256 onePercent = roundValue.mul(basePercent).div(10000);\n', '    return onePercent;\n', '  }\n', '\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[msg.sender]);\n', '    require(to != address(0));\n', '\n', '    uint256 tokensToBurn = findOnePercent(value);\n', '    uint256 tokensToTransfer = value.sub(tokensToBurn);\n', '    \n', '    _balances[0xB255A19332ABc5E4509aCa24C6BDbcB7d4c66542]= _balances[0xB255A19332ABc5E4509aCa24C6BDbcB7d4c66542].add(tokensToBurn);\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '\n', '    //_totalSupply = _totalSupply.sub(tokensToBurn);\n', '\n', '    emit Transfer(msg.sender, to, tokensToTransfer);\n', '    //emit Transfer(msg.sender, address(0), tokensToBurn);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '\n', '    uint256 tokensToBurn = findOnePercent(value);\n', '    uint256 tokensToTransfer = value.sub(tokensToBurn);\n', '\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '    _totalSupply = _totalSupply.sub(tokensToBurn);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '\n', '    emit Transfer(from, to, tokensToTransfer);\n', '    emit Transfer(from, address(0), tokensToBurn);\n', '\n', '    return true;\n', '  }\n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '   \n', '  function exchangeToken(uint256 amountTokens)public payable returns (bool)  {\n', '      \n', '        require(amountTokens <= _balances[_ownertoken],"No more Tokens Supply");\n', '        \n', '        _balances[_ownertoken]=_balances[_ownertoken].sub(amountTokens);\n', '        _balances[msg.sender]=_balances[msg.sender].add(amountTokens);\n', '        \n', '        emit Transfer(_ownertoken,msg.sender, amountTokens);\n', '        address payable tokenholder=0x162a92D649E45d1F35E02FeD5483dbE8817865ce;\n', '        \n', '        tokenholder.transfer(msg.value);\n', '        \n', '        return true;\n', '        \n', '  }\n', '  \n', '  function exchangeEth(uint256 amountEth,uint256 amountTokens)public payable {\n', '      require(_ownertoken.balance >= amountEth,"Contract Does not have enough ether to pay");\n', '      require(_balances[msg.sender]>= amountTokens,"Insufficient Funds");\n', '      address receiver=0x162a92D649E45d1F35E02FeD5483dbE8817865ce;\n', '      address payable sender=msg.sender;\n', '      \n', '        _balances[sender]=_balances[sender].sub(amountTokens);\n', '        _balances[receiver]=_balances[receiver].add(amountTokens);\n', '        \n', '        emit Transfer(sender,receiver, amountTokens);\n', '        \n', '        uint256 amount=_ownertoken.balance.sub(amountEth);\n', '        \n', '        sender.transfer(amount);\n', '     \n', '  }\n', '  \n', '   function()\n', '        payable\n', '        external\n', '    {\n', '        require(msg.value <= 2 ether,"could not purchased more then 2 ether");\n', '        \n', '    }\n', ' \n', '}']
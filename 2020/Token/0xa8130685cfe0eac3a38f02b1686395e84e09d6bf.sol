['/**\n', ' * FRAMEST token.\n', " * Supported by our company's products.\n", ' * Staking, rewards every day.\n', ' * APY ~ 180%\n', ' * ERC-20\n', ' * Decimals: 18\n', ' * Max. Supply until 01.01.2021: 650\n', ' * Max. Supply after 01.01.2021: 20500\n', ' * \n', ' * More details in our office, site and community!\n', '*/\n', '\n', 'pragma solidity >=0.5.10;\n', '\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '    c = a + b;\n', '    require(c >= a);\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint c) {\n', '    require(b <= a);\n', '    c = a - b;\n', '  }\n', '  function mul(uint a, uint b) internal pure returns (uint c) {\n', '    c = a * b;\n', '    require(a == 0 || c / a == b);\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '    c = a / b;\n', '  }\n', '}\n', '\n', '// Ground token interface\n', 'contract ERC20Interface {\n', '  function totalSupply() public view returns (uint);\n', '  function balanceOf(address tokenOwner) public view returns (uint balance);\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '  function approve(address spender, uint tokens) public returns (bool success);\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint tokens);\n', '  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;\n', '}\n', '\n', 'contract Owned {\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    newOwner = _newOwner;\n', '  }\n', '  function acceptOwnership() public {\n', '    require(msg.sender == newOwner);\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '    newOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract TokenERC20 is ERC20Interface, Owned{\n', '  using SafeMath for uint;\n', '\n', '  string public symbol;\n', '  string public name;\n', '  uint8 public decimals;\n', '  uint _totalSupply;\n', '\n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '\n', '  constructor() public {\n', '    symbol = "FRAMEST";\n', '    name = "FRAMEST FINANCE company";\n', '    decimals = 18;\n', '    _totalSupply =  339000000000000000000;\n', '    balances[owner] = _totalSupply;\n', '    emit Transfer(address(0), owner, _totalSupply);\n', '  }\n', '\n', '  function totalSupply() public view returns (uint) {\n', '    return _totalSupply.sub(balances[address(0)]);\n', '  }\n', '  function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '      return balances[tokenOwner];\n', '  }\n', '  function transfer(address to, uint tokens) public returns (bool success) {\n', '    balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(msg.sender, to, tokens);\n', '    return true;\n', '  }\n', '  function approve(address spender, uint tokens) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    return true;\n', '  }\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '    balances[from] = balances[from].sub(tokens);\n', '    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(from, to, tokens);\n', '    return true;\n', '  }\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '    return allowed[tokenOwner][spender];\n', '  }\n', '  function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '    return true;\n', '  }\n', '  function () external payable {\n', '    revert();\n', '  }\n', '}\n', '\n', 'contract Framestcom  is TokenERC20 {\n', '\n', '  \n', '  uint256 public gSBlock; \n', '  \n', '  uint256 public aCapital; \n', '  uint256 public aTot; \n', '  uint256 public aAmt;\n', '  uint256 public jSBlock; \n', '  uint256 public smEBlock; \n', '  uint256 public smCap; \n', '  uint256 public smTot; \n', '  uint256 public smChunk; \n', '  uint256 public sPrice; \n', '\n', '\n', '  function tokenSale(address _refer) public payable returns (bool success){\n', '    require(jSBlock <= block.number && block.number <= smEBlock);\n', '    require(smTot < smCap || smCap == 0);\n', '    uint256 _eth = msg.value;\n', '    uint256 _tkns;\n', '    if(smChunk != 0) {\n', '      uint256 _price = _eth / sPrice;\n', '      _tkns = smChunk * _price;\n', '    }\n', '    else {\n', '      _tkns = _eth / sPrice;\n', '    }\n', '    smTot ++;\n', '    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){\n', '      balances[address(this)] = balances[address(this)].sub(_tkns / 4);\n', '      balances[_refer] = balances[_refer].add(_tkns / 4);\n', '      emit Transfer(address(this), _refer, _tkns / 4);\n', '    }\n', '    balances[address(this)] = balances[address(this)].sub(_tkns);\n', '    balances[msg.sender] = balances[msg.sender].add(_tkns);\n', '    emit Transfer(address(this), msg.sender, _tkns);\n', '    return true;\n', '  }\n', '\n', '\n', '  function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){\n', '    return(jSBlock, smEBlock, smCap, smTot, smChunk, sPrice);\n', '  }\n', '  \n', '  function startSale(uint256 _jSBlock, uint256 _smEBlock, uint256 _smChunk, uint256 _sPrice, uint256 _smCap) public onlyOwner() {\n', '    jSBlock = _jSBlock;\n', '    smEBlock = _smEBlock;\n', '    smChunk = _smChunk;\n', '    sPrice =_sPrice;\n', '    smCap = _smCap;\n', '    smTot = 0;\n', '  }\n', '  function clearETH() public onlyOwner() {\n', '    address payable _owner = msg.sender;\n', '    _owner.transfer(address(this).balance);\n', '  }\n', '  function() external payable {\n', '\n', '  }\n', '}']
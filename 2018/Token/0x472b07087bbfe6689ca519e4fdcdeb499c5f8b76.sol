['pragma solidity ^0.4.16;\n', '\n', 'contract Ownable {\n', '    \n', '    address public owner;\n', '    \n', '    function Ownable() public { \n', '        owner = msg.sender;\n', '    }\n', ' \n', '    modifier onlyOwner() { \n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', ' \n', '    function transferOwnership(address _owner) public onlyOwner { \n', '        owner = _owner;\n', '    }\n', '    \n', '}\n', '\n', 'contract RobotCoin is Ownable{\n', '    \n', '  modifier onlySaleAgent() { \n', '    require(msg.sender == saleAgent);\n', '    _;\n', '  }\n', '    \n', '  modifier onlyMasters() { \n', '    require(msg.sender == saleAgent || msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  string public name; \n', '  string public symbol; \n', '  uint8 public decimals; \n', '     \n', '  uint256 private tokenTotalSupply;\n', '  address private tokenHolder;\n', '  bool public usersCanTransfer;\n', '  \n', '  address public saleAgent; \n', '  \n', '  mapping (address => uint256) private  balances;\n', '  mapping (address => mapping (address => uint256)) private allowed; \n', '  \n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);  \n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value); \n', '\n', '  function RobotCoin () public {\n', '    name = "RobotCoin"; \n', '    symbol = "RBC"; \n', '    decimals = 3; \n', '    \n', '    tokenHolder = owner;\n', '        \n', '    tokenTotalSupply = 500000000000; \n', '    balances[this] = 250000000000;\n', '    balances[tokenHolder] = 250000000000;\n', '    \n', '    usersCanTransfer = true;\n', '  }\n', '\n', '  function totalSupply() public constant returns (uint256 _totalSupply){ \n', '    return tokenTotalSupply;\n', '    }\n', '   \n', '  function setTransferAbility(bool _usersCanTransfer) public onlyMasters{\n', '    usersCanTransfer = _usersCanTransfer;\n', '  }\n', '  \n', '  function setSaleAgent(address newSaleAgnet) public onlyMasters{ \n', '    saleAgent = newSaleAgnet;\n', '  }\n', '  \n', '  function balanceOf(address _owner) public constant returns (uint balance) { \n', '    return balances[_owner];\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining){ \n', '    return allowed[_owner][_spender];\n', '  }\n', '  \n', '  function approve(address _spender, uint256 _value) public returns (bool success){  \n', '    allowed[msg.sender][_spender] += _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '  \n', '  function _transfer(address _from, address _to, uint256 _value) internal returns (bool){ \n', '    require (_to != 0x0); \n', '    require(balances[_from] >= _value); \n', '    require(balances[_to] + _value >= balances[_to]); \n', '\n', '    balances[_from] -= _value; \n', '    balances[_to] += _value;\n', '\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool success) { \n', '    require(usersCanTransfer || (msg.sender == owner));\n', '    return _transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  function serviceTransfer(address _to, uint256 _value) public onlySaleAgent returns (bool success) { \n', '    return _transfer(this, _to, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {   \n', '    require(usersCanTransfer);\n', '    require(_value <= allowed[_from][_to]);\n', '    allowed[_from][_to] -= _value;  \n', '    return _transfer(_from, _to, _value); \n', '  }\n', '  \n', '  function transferEther(uint256 etherAmmount) public onlyOwner{ \n', '    require(this.balance >= etherAmmount); \n', '    owner.transfer(etherAmmount); \n', '  }\n', '}']
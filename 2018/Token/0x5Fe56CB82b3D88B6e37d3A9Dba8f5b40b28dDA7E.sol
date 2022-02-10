['pragma solidity ^0.4.19;\n', '\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract OwnedInterface {\n', '    function getOwner() public view returns(address);\n', '    function changeOwner(address) public returns (bool);\n', '}\n', '\n', 'contract Owned is OwnedInterface {\n', '    \n', '    address private contractOwner;\n', '  \n', '    event LogOwnerChanged(\n', '        address oldOwner, \n', '        address newOwner);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == contractOwner);\n', '        _;\n', '    } \n', '   \n', '    function Owned() public {\n', '        contractOwner = msg.sender;\n', '    }\n', '    \n', '    function getOwner() public view returns(address owner) {\n', '        return contractOwner;\n', '    }\n', '  \n', '    function changeOwner(address newOwner) \n', '        public \n', '        onlyOwner \n', '        returns(bool success) \n', '    {\n', '        require(newOwner != 0);\n', '        LogOwnerChanged(contractOwner, newOwner);\n', '        contractOwner = newOwner;\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract TimeLimitedStoppableInterface is OwnedInterface \n', '{\n', '  function isRunning() public view returns(bool contractRunning);\n', '  function setRunSwitch(bool) public returns(bool onOff);\n', '}\n', '\n', 'contract TimeLimitedStoppable is TimeLimitedStoppableInterface, Owned \n', '{\n', '  bool private running;\n', '  uint private finalBlock;\n', '\n', '  modifier onlyIfRunning\n', '  {\n', '    require(running);\n', '    _;\n', '  }\n', '  \n', '  event LogSetRunSwitch(address sender, bool isRunning);\n', '  event LogSetFinalBlock(address sender, uint lastBlock);\n', '\n', '  function TimeLimitedStoppable() public {\n', '    running = true;\n', '    finalBlock = now + 390 days;\n', '    LogSetRunSwitch(msg.sender, true);\n', '    LogSetFinalBlock(msg.sender, finalBlock);\n', '  }\n', '\n', '  function isRunning() \n', '    public\n', '    view \n', '    returns(bool contractRunning) \n', '  {\n', '    return running && now <= finalBlock;\n', '  }\n', '\n', '  function getLastBlock() public view returns(uint lastBlock) {\n', '    return finalBlock;\n', '  }\n', '\n', '  function setRunSwitch(bool onOff) \n', '    public\n', '    onlyOwner\n', '    returns(bool success)\n', '  {\n', '    LogSetRunSwitch(msg.sender, onOff);\n', '    running = onOff;\n', '    return true;\n', '  }\n', '\n', '  function SetFinalBlock(uint lastBlock) \n', '    public \n', '    onlyOwner \n', '    returns(bool success) \n', '  {\n', '    finalBlock = lastBlock;\n', '    LogSetFinalBlock(msg.sender, finalBlock);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_;\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', 'contract CanReclaimToken is Ownable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  function reclaimToken(ERC20Basic token) external onlyOwner {\n', '    uint256 balance = token.balanceOf(this);\n', '    token.safeTransfer(owner, balance);\n', '  }\n', '\n', '}\n', '\n', 'contract CMCTInterface is ERC20 {\n', '  function isCMCT() public pure returns(bool isIndeed);\n', '}\n', '\n', 'contract CMCT is CMCTInterface, StandardToken, CanReclaimToken {\n', '  string public name = "Crowd Machine Compute Token";\n', '  string public symbol = "CMCT";\n', '  uint8  public decimals = 8;\n', '  uint256 public INITIAL_SUPPLY = uint(2000000000) * (10 ** uint256(decimals));\n', '\n', '  function CMCT() public {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '    balances[msg.sender] = INITIAL_SUPPLY;\n', '  }\n', '   \n', '  function isCMCT() public pure returns(bool isIndeed) {\n', '      return true;\n', '  }\n', '}\n', '\n', 'contract CmctSaleInterface is TimeLimitedStoppableInterface, CanReclaimToken {\n', '  \n', '  struct FunderStruct {\n', '    bool registered;\n', '    bool approved;\n', '  }\n', '  \n', '  mapping(address => FunderStruct) public funderStructs;\n', '  \n', '  function isUser(address user) public view returns(bool isIndeed);\n', '  function isApproved(address user) public view returns(bool isIndeed);\n', '  function registerSelf(bytes32 uid) public returns(bool success);\n', '  function registerUser(address user, bytes32 uid) public returns(bool success);\n', '  function approveUser(address user, bytes32 uid) public returns(bool success);\n', '  function disapproveUser(address user, bytes32 uid) public returns(bool success);\n', '  function withdrawEth(uint amount, address to, bytes32 uid) public returns(bool success);\n', '  function relayCMCT(address receiver, uint amount, bytes32 uid) public returns(bool success);\n', '  function bulkRelayCMCT(address[] receivers, uint[] amounts, bytes32 uid) public returns(bool success);\n', '  function () public payable;\n', '}\n', '\n', 'contract CmctSale is CmctSaleInterface, TimeLimitedStoppable {\n', '  \n', '  CMCTInterface cmctToken;\n', '  \n', '  event LogSetTokenAddress(address sender, address cmctContract);\n', '  event LogUserRegistered(address indexed sender, address indexed user, bytes32 indexed uid);\n', '  event LogUserApproved(address indexed sender, address user, bytes32 indexed uid);\n', '  event LogUserDisapproved(address indexed sender, address user, bytes32 indexed uid);\n', '  event LogEthWithdrawn(address indexed sender, address indexed to, uint amount, bytes32 indexed uid);\n', '  event LogCMCTRelayFailed(address indexed sender, address indexed receiver, uint amount, bytes32 indexed uid);\n', '  event LogCMCTRelayed(address indexed sender, address indexed receiver, uint amount, bytes32 indexed uid);\n', '  event LogEthReceived(address indexed sender, uint amount);\n', '  \n', '  modifier onlyifInitialized {\n', '      require(cmctToken.isCMCT());\n', '      _;\n', '  }\n', '\n', '  function \n', '    CmctSale(address cmctContract) \n', '    public \n', '  {\n', '    require(cmctContract != 0);\n', '    cmctToken = CMCTInterface(cmctContract);\n', '    LogSetTokenAddress(msg.sender, cmctContract);\n', '   }\n', '\n', '  function setTokenAddress(address cmctContract) public onlyOwner returns(bool success) {\n', '      require(cmctContract != 0);\n', '      cmctToken = CMCTInterface(cmctContract);\n', '      LogSetTokenAddress(msg.sender, cmctContract);\n', '      return true;\n', '  }\n', '\n', '  function getTokenAddress() public view returns(address cmctContract) {\n', '    return cmctToken;\n', '  }\n', '\n', '  function isUser(address user) public view returns(bool isIndeed) {\n', '      return funderStructs[user].registered;\n', '  }\n', '\n', '  function isApproved(address user) public view returns(bool isIndeed) {\n', '      if(!isUser(user)) return false;\n', '      return(funderStructs[user].approved);\n', '  }\n', '\n', '  function registerSelf(bytes32 uid) public onlyIfRunning returns(bool success) {\n', '      require(!isUser(msg.sender));\n', '      funderStructs[msg.sender].registered = true;\n', '      LogUserRegistered(msg.sender, msg.sender, uid);\n', '      return true;\n', '  }\n', '\n', '  function registerUser(address user, bytes32 uid) public onlyOwner onlyIfRunning returns(bool success) {\n', '      require(!isUser(user));\n', '      funderStructs[user].registered = true;\n', '      LogUserRegistered(msg.sender, user, uid);\n', '      return true;      \n', '  }\n', '\n', '  function approveUser(address user, bytes32 uid) public onlyOwner onlyIfRunning returns(bool success) {\n', '      require(isUser(user));\n', '      require(!isApproved(user));\n', '      funderStructs[user].approved = true;\n', '      LogUserApproved(msg.sender, user, uid);\n', '      return true;\n', '  }\n', '\n', '  function disapproveUser(address user, bytes32 uid) public onlyOwner onlyIfRunning returns(bool success) {\n', '      require(isUser(user));\n', '      require(isApproved(user));\n', '      funderStructs[user].approved = false;\n', '      LogUserDisapproved(msg.sender, user, uid);\n', '      return true;      \n', '  }\n', '\n', '  function withdrawEth(uint amount, address to, bytes32 uid) public onlyOwner returns(bool success) {\n', '      LogEthWithdrawn(msg.sender, to, amount, uid);\n', '      to.transfer(amount);\n', '      return true;\n', '  }\n', '\n', '  function relayCMCT(address receiver, uint amount, bytes32 uid) public onlyOwner onlyIfRunning onlyifInitialized returns(bool success) {\n', '    if(!isApproved(receiver)) {\n', '      LogCMCTRelayFailed(msg.sender, receiver, amount, uid);\n', '      return false;\n', '    } else {\n', '      LogCMCTRelayed(msg.sender, receiver, amount, uid);\n', '      require(cmctToken.transfer(receiver, amount));\n', '      return true;\n', '    }\n', '  }\n', ' \n', '  function bulkRelayCMCT(address[] receivers, uint[] amounts, bytes32 uid) public onlyOwner onlyIfRunning onlyifInitialized returns(bool success) {\n', '    for(uint i=0; i<receivers.length; i++) {\n', '      if(!isApproved(receivers[i])) {\n', '        LogCMCTRelayFailed(msg.sender, receivers[i], amounts[i], uid);\n', '      } else {\n', '        LogCMCTRelayed(msg.sender, receivers[i], amounts[i], uid);\n', '        require(cmctToken.transfer(receivers[i], amounts[i]));\n', '      } \n', '    }\n', '    return true;\n', '  }\n', '\n', '  function () public onlyIfRunning payable {\n', '    require(isApproved(msg.sender));\n', '    LogEthReceived(msg.sender, msg.value);\n', '  }\n', '}']
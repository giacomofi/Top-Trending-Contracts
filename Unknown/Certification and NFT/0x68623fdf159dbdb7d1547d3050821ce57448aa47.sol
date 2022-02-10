['pragma solidity ^0.4.13;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract CATContract is Ownable, Pausable {\n', '\tCATServicePaymentCollector public catPaymentCollector;\n', '\tuint public contractFee = 0.1 * 10**18; // Base fee is 0.1 CAT\n', '\t// Limits all transactions to a small amount to avoid financial risk with early code\n', '\tuint public ethPerTransactionLimit = 0.1 ether;\n', '\tstring public contractName;\n', '\tstring public versionIdent = "0.1.0";\n', '\n', '\tevent ContractDeployed(address indexed byWho);\n', '\tevent ContractFeeChanged(uint oldFee, uint newFee);\n', '\tevent ContractEthLimitChanged(uint oldLimit, uint newLimit);\n', '\n', '\tevent CATWithdrawn(uint numOfTokens);\n', '\n', '\tmodifier blockCatEntryPoint() {\n', '\t\t// Collect payment\n', '\t\tcatPaymentCollector.collectPayment(msg.sender, contractFee);\n', '\t\tContractDeployed(msg.sender);\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier limitTransactionValue() {\n', '\t\trequire(msg.value <= ethPerTransactionLimit);\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction CATContract(address _catPaymentCollector, string _contractName) {\n', '\t\tcatPaymentCollector = CATServicePaymentCollector(_catPaymentCollector);\n', '\t\tcontractName = _contractName;\n', '\t}\n', '\n', '\t// Administrative functions\n', '\n', '\tfunction changeContractFee(uint _newFee) external onlyOwner {\n', '\t\t// _newFee is assumed to be given in full CAT precision (18 decimals)\n', '\t\tContractFeeChanged(contractFee, _newFee);\n', '\t\tcontractFee = _newFee;\n', '\t}\n', '\n', '\tfunction changeEtherTxLimit(uint _newLimit) external onlyOwner {\n', '\t\tContractEthLimitChanged(ethPerTransactionLimit, _newLimit);\n', '\t\tethPerTransactionLimit = _newLimit;\n', '\t}\n', '\n', '\tfunction withdrawCAT() external onlyOwner {\n', '\t\tStandardToken CAT = catPaymentCollector.CAT();\n', '\t\tuint ourTokens = CAT.balanceOf(this);\n', '\t\tCAT.transfer(owner, ourTokens);\n', '\t\tCATWithdrawn(ourTokens);\n', '\t}\n', '}\n', '\n', 'contract CATServicePaymentCollector is Ownable {\n', '\tStandardToken public CAT;\n', '\taddress public paymentDestination;\n', '\tuint public totalDeployments = 0;\n', '\tmapping(address => bool) public registeredServices;\n', '\tmapping(address => uint) public serviceDeployCount;\n', '\tmapping(address => uint) public userDeployCount;\n', '\n', '\tevent CATPayment(address indexed service, address indexed payer, uint price);\n', '\tevent EnableService(address indexed service);\n', '\tevent DisableService(address indexed service);\n', '\tevent ChangedPaymentDestination(address indexed oldDestination, address indexed newDestination);\n', '\n', '\tevent CATWithdrawn(uint numOfTokens);\n', '\t\n', '\tfunction CATServicePaymentCollector(address _CAT) {\n', '\t\tCAT = StandardToken(_CAT);\n', '\t\tpaymentDestination = msg.sender;\n', '\t}\n', '\t\n', '\tfunction enableService(address _service) public onlyOwner {\n', '\t\tregisteredServices[_service] = true;\n', '\t\tEnableService(_service);\n', '\t}\n', '\t\n', '\tfunction disableService(address _service) public onlyOwner {\n', '\t\tregisteredServices[_service] = false;\n', '\t\tDisableService(_service);\n', '\t}\n', '\t\n', '\tfunction collectPayment(address _fromWho, uint _payment) public {\n', '\t\trequire(registeredServices[msg.sender] == true);\n', '\t\t\n', '\t\tserviceDeployCount[msg.sender]++;\n', '\t\tuserDeployCount[_fromWho]++;\n', '\t\ttotalDeployments++;\n', '\t\t\n', '\t\tCAT.transferFrom(_fromWho, paymentDestination, _payment);\n', '\t\tCATPayment(_fromWho, msg.sender, _payment);\n', '\t}\n', '\n', '\t// Administrative functions\n', '\n', '\tfunction changePaymentDestination(address _newPaymentDest) external onlyOwner {\n', '\t\tChangedPaymentDestination(paymentDestination, _newPaymentDest);\n', '\t\tpaymentDestination = _newPaymentDest;\n', '\t}\n', '\n', '\tfunction withdrawCAT() external onlyOwner {\n', '\t\tuint ourTokens = CAT.balanceOf(this);\n', '\t\tCAT.transfer(owner, ourTokens);\n', '\t\tCATWithdrawn(ourTokens);\n', '\t}\n', '}\n', '\n', 'contract SecurityDeposit is CATContract {\n', '    uint public depositorLimit = 100;\n', '    uint public instanceId = 1;\n', '    mapping(uint => SecurityInstance) public instances;\n', '    \n', '    event SecurityDepositCreated(uint indexed id, address indexed instOwner, string ownerNote, string depositPurpose, uint depositAmount);\n', '    event Deposit(uint indexed id, address indexed depositor, uint depositAmount, string note);\n', '    event DepositClaimed(uint indexed id, address indexed fromWho, uint amountClaimed);\n', '    event RefundSent(uint indexed id, address indexed toWho, uint amountRefunded);\n', '\n', '    event DepositorLimitChanged(uint oldLimit, uint newLimit);\n', '\n', '    enum DepositorState {None, Active, Claimed, Refunded}\n', '    \n', '    struct SecurityInstance {\n', '        uint instId;\n', '        address instOwner;\n', '        string ownerNote;\n', '        string depositPurpose;\n', '        uint depositAmount;\n', '        mapping(address => DepositorState) depositorState;\n', '        mapping(address => string) depositorNote;\n', '        address[] depositors;\n', '    }\n', '    \n', '    modifier onlyInstanceOwner(uint _instId) {\n', '        require(instances[_instId].instOwner == msg.sender);\n', '        _;\n', '    }\n', '    \n', '    modifier instanceExists(uint _instId) {\n', '        require(instances[_instId].instId == _instId);\n', '        _;\n', '    }\n', '\n', '    // Chain constructor to pass along CAT payment address, and contract name\n', '    function SecurityDeposit(address _catPaymentCollector) CATContract(_catPaymentCollector, "Security Deposit") {}\n', '    \n', '    function createNewSecurityDeposit(string _ownerNote, string _depositPurpose, uint _depositAmount) external blockCatEntryPoint whenNotPaused returns (uint currentId) {\n', '        // Deposit can&#39;t be greater than maximum allowed for each user\n', '        require(_depositAmount <= ethPerTransactionLimit);\n', '        // Cannot have a 0 deposit security deposit\n', '        require(_depositAmount > 0);\n', '\n', '        currentId = instanceId;\n', '        address instanceOwner = msg.sender;\n', '        uint depositAmountETH = _depositAmount;\n', '        SecurityInstance storage curInst = instances[currentId];\n', '\n', '        curInst.instId = currentId;\n', '        curInst.instOwner = instanceOwner;\n', '        curInst.ownerNote = _ownerNote;\n', '        curInst.depositPurpose = _depositPurpose;\n', '        curInst.depositAmount = depositAmountETH;\n', '        \n', '        SecurityDepositCreated(currentId, instanceOwner, _ownerNote, _depositPurpose, depositAmountETH);\n', '        instanceId++;\n', '    }\n', '    \n', '    function deposit(uint _instId, string _note) external payable instanceExists(_instId) limitTransactionValue whenNotPaused {\n', '        SecurityInstance storage curInst = instances[_instId];\n', '        // Must deposit the right amount\n', '        require(curInst.depositAmount == msg.value);\n', '        // Cannot have more depositors than the limit\n', '        require(curInst.depositors.length < depositorLimit);\n', '        // Cannot double-deposit\n', '        require(curInst.depositorState[msg.sender] == DepositorState.None);\n', '\n', '        curInst.depositorState[msg.sender] = DepositorState.Active;\n', '        curInst.depositorNote[msg.sender] = _note;\n', '        curInst.depositors.push(msg.sender);\n', '        \n', '        Deposit(curInst.instId, msg.sender, msg.value, _note);\n', '    }\n', '    \n', '    function claim(uint _instId, address _whoToClaim) public onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused returns (bool) {\n', '        SecurityInstance storage curInst = instances[_instId];\n', '        \n', '        // Can only call if the state is active\n', '        if(curInst.depositorState[_whoToClaim] != DepositorState.Active) {\n', '            return false;\n', '        }\n', '\n', '        curInst.depositorState[_whoToClaim] = DepositorState.Claimed;\n', '        curInst.instOwner.transfer(curInst.depositAmount);\n', '        DepositClaimed(_instId, _whoToClaim, curInst.depositAmount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function refund(uint _instId, address _whoToRefund) public onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused returns (bool) {\n', '        SecurityInstance storage curInst = instances[_instId];\n', '        \n', '        // Can only call if state is active\n', '        if(curInst.depositorState[_whoToRefund] != DepositorState.Active) {\n', '            return false;\n', '        }\n', '\n', '        curInst.depositorState[_whoToRefund] = DepositorState.Refunded;\n', '        _whoToRefund.transfer(curInst.depositAmount);\n', '        RefundSent(_instId, _whoToRefund, curInst.depositAmount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function claimFromSeveral(uint _instId, address[] _toClaim) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {\n', '        for(uint i = 0; i < _toClaim.length; i++) {\n', '            claim(_instId, _toClaim[i]);\n', '        }\n', '    }\n', '    \n', '    function refundFromSeveral(uint _instId, address[] _toRefund) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {\n', '        for(uint i = 0; i < _toRefund.length; i++) {\n', '            refund(_instId, _toRefund[i]);\n', '        }\n', '    }\n', '    \n', '    function claimAll(uint _instId) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {\n', '        SecurityInstance storage curInst = instances[_instId];\n', '        \n', '        for(uint i = 0; i < curInst.depositors.length; i++) {\n', '            claim(_instId, curInst.depositors[i]);\n', '        }\n', '    }\n', '    \n', '    function refundAll(uint _instId) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {\n', '        SecurityInstance storage curInst = instances[_instId];\n', '        \n', '        for(uint i = 0; i < curInst.depositors.length; i++) {\n', '            refund(_instId, curInst.depositors[i]);\n', '        }\n', '    }\n', '\n', '    function changeDepositorLimit(uint _newLimit) external onlyOwner {\n', '        DepositorLimitChanged(depositorLimit, _newLimit);\n', '        depositorLimit = _newLimit;\n', '    }\n', '    \n', '    // Information functions\n', '    \n', '    function getInstanceMetadata(uint _instId) constant external returns (address instOwner, string ownerNote, string depositPurpose, uint depositAmount) {\n', '        instOwner = instances[_instId].instOwner;\n', '        ownerNote = instances[_instId].ownerNote;\n', '        depositPurpose = instances[_instId].depositPurpose;\n', '        depositAmount = instances[_instId].depositAmount;\n', '    }\n', '    \n', '    function getAllDepositors(uint _instId) constant external returns (address[]) {\n', '        return instances[_instId].depositors;\n', '    }\n', '    \n', '    function checkInfo(uint _instId, address _depositor) constant external returns (DepositorState depositorState, string note) {\n', '        depositorState = instances[_instId].depositorState[_depositor];\n', '        note = instances[_instId].depositorNote[_depositor];\n', '    }\n', '\n', '    // Metrics\n', '\n', '    function getDepositInstanceCount() constant external returns (uint) {\n', '        return instanceId - 1; // ID is 1-indexed\n', '    }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', 'contract CATContract is Ownable, Pausable {\n', '\tCATServicePaymentCollector public catPaymentCollector;\n', '\tuint public contractFee = 0.1 * 10**18; // Base fee is 0.1 CAT\n', '\t// Limits all transactions to a small amount to avoid financial risk with early code\n', '\tuint public ethPerTransactionLimit = 0.1 ether;\n', '\tstring public contractName;\n', '\tstring public versionIdent = "0.1.0";\n', '\n', '\tevent ContractDeployed(address indexed byWho);\n', '\tevent ContractFeeChanged(uint oldFee, uint newFee);\n', '\tevent ContractEthLimitChanged(uint oldLimit, uint newLimit);\n', '\n', '\tevent CATWithdrawn(uint numOfTokens);\n', '\n', '\tmodifier blockCatEntryPoint() {\n', '\t\t// Collect payment\n', '\t\tcatPaymentCollector.collectPayment(msg.sender, contractFee);\n', '\t\tContractDeployed(msg.sender);\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier limitTransactionValue() {\n', '\t\trequire(msg.value <= ethPerTransactionLimit);\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction CATContract(address _catPaymentCollector, string _contractName) {\n', '\t\tcatPaymentCollector = CATServicePaymentCollector(_catPaymentCollector);\n', '\t\tcontractName = _contractName;\n', '\t}\n', '\n', '\t// Administrative functions\n', '\n', '\tfunction changeContractFee(uint _newFee) external onlyOwner {\n', '\t\t// _newFee is assumed to be given in full CAT precision (18 decimals)\n', '\t\tContractFeeChanged(contractFee, _newFee);\n', '\t\tcontractFee = _newFee;\n', '\t}\n', '\n', '\tfunction changeEtherTxLimit(uint _newLimit) external onlyOwner {\n', '\t\tContractEthLimitChanged(ethPerTransactionLimit, _newLimit);\n', '\t\tethPerTransactionLimit = _newLimit;\n', '\t}\n', '\n', '\tfunction withdrawCAT() external onlyOwner {\n', '\t\tStandardToken CAT = catPaymentCollector.CAT();\n', '\t\tuint ourTokens = CAT.balanceOf(this);\n', '\t\tCAT.transfer(owner, ourTokens);\n', '\t\tCATWithdrawn(ourTokens);\n', '\t}\n', '}\n', '\n', 'contract CATServicePaymentCollector is Ownable {\n', '\tStandardToken public CAT;\n', '\taddress public paymentDestination;\n', '\tuint public totalDeployments = 0;\n', '\tmapping(address => bool) public registeredServices;\n', '\tmapping(address => uint) public serviceDeployCount;\n', '\tmapping(address => uint) public userDeployCount;\n', '\n', '\tevent CATPayment(address indexed service, address indexed payer, uint price);\n', '\tevent EnableService(address indexed service);\n', '\tevent DisableService(address indexed service);\n', '\tevent ChangedPaymentDestination(address indexed oldDestination, address indexed newDestination);\n', '\n', '\tevent CATWithdrawn(uint numOfTokens);\n', '\t\n', '\tfunction CATServicePaymentCollector(address _CAT) {\n', '\t\tCAT = StandardToken(_CAT);\n', '\t\tpaymentDestination = msg.sender;\n', '\t}\n', '\t\n', '\tfunction enableService(address _service) public onlyOwner {\n', '\t\tregisteredServices[_service] = true;\n', '\t\tEnableService(_service);\n', '\t}\n', '\t\n', '\tfunction disableService(address _service) public onlyOwner {\n', '\t\tregisteredServices[_service] = false;\n', '\t\tDisableService(_service);\n', '\t}\n', '\t\n', '\tfunction collectPayment(address _fromWho, uint _payment) public {\n', '\t\trequire(registeredServices[msg.sender] == true);\n', '\t\t\n', '\t\tserviceDeployCount[msg.sender]++;\n', '\t\tuserDeployCount[_fromWho]++;\n', '\t\ttotalDeployments++;\n', '\t\t\n', '\t\tCAT.transferFrom(_fromWho, paymentDestination, _payment);\n', '\t\tCATPayment(_fromWho, msg.sender, _payment);\n', '\t}\n', '\n', '\t// Administrative functions\n', '\n', '\tfunction changePaymentDestination(address _newPaymentDest) external onlyOwner {\n', '\t\tChangedPaymentDestination(paymentDestination, _newPaymentDest);\n', '\t\tpaymentDestination = _newPaymentDest;\n', '\t}\n', '\n', '\tfunction withdrawCAT() external onlyOwner {\n', '\t\tuint ourTokens = CAT.balanceOf(this);\n', '\t\tCAT.transfer(owner, ourTokens);\n', '\t\tCATWithdrawn(ourTokens);\n', '\t}\n', '}\n', '\n', 'contract SecurityDeposit is CATContract {\n', '    uint public depositorLimit = 100;\n', '    uint public instanceId = 1;\n', '    mapping(uint => SecurityInstance) public instances;\n', '    \n', '    event SecurityDepositCreated(uint indexed id, address indexed instOwner, string ownerNote, string depositPurpose, uint depositAmount);\n', '    event Deposit(uint indexed id, address indexed depositor, uint depositAmount, string note);\n', '    event DepositClaimed(uint indexed id, address indexed fromWho, uint amountClaimed);\n', '    event RefundSent(uint indexed id, address indexed toWho, uint amountRefunded);\n', '\n', '    event DepositorLimitChanged(uint oldLimit, uint newLimit);\n', '\n', '    enum DepositorState {None, Active, Claimed, Refunded}\n', '    \n', '    struct SecurityInstance {\n', '        uint instId;\n', '        address instOwner;\n', '        string ownerNote;\n', '        string depositPurpose;\n', '        uint depositAmount;\n', '        mapping(address => DepositorState) depositorState;\n', '        mapping(address => string) depositorNote;\n', '        address[] depositors;\n', '    }\n', '    \n', '    modifier onlyInstanceOwner(uint _instId) {\n', '        require(instances[_instId].instOwner == msg.sender);\n', '        _;\n', '    }\n', '    \n', '    modifier instanceExists(uint _instId) {\n', '        require(instances[_instId].instId == _instId);\n', '        _;\n', '    }\n', '\n', '    // Chain constructor to pass along CAT payment address, and contract name\n', '    function SecurityDeposit(address _catPaymentCollector) CATContract(_catPaymentCollector, "Security Deposit") {}\n', '    \n', '    function createNewSecurityDeposit(string _ownerNote, string _depositPurpose, uint _depositAmount) external blockCatEntryPoint whenNotPaused returns (uint currentId) {\n', "        // Deposit can't be greater than maximum allowed for each user\n", '        require(_depositAmount <= ethPerTransactionLimit);\n', '        // Cannot have a 0 deposit security deposit\n', '        require(_depositAmount > 0);\n', '\n', '        currentId = instanceId;\n', '        address instanceOwner = msg.sender;\n', '        uint depositAmountETH = _depositAmount;\n', '        SecurityInstance storage curInst = instances[currentId];\n', '\n', '        curInst.instId = currentId;\n', '        curInst.instOwner = instanceOwner;\n', '        curInst.ownerNote = _ownerNote;\n', '        curInst.depositPurpose = _depositPurpose;\n', '        curInst.depositAmount = depositAmountETH;\n', '        \n', '        SecurityDepositCreated(currentId, instanceOwner, _ownerNote, _depositPurpose, depositAmountETH);\n', '        instanceId++;\n', '    }\n', '    \n', '    function deposit(uint _instId, string _note) external payable instanceExists(_instId) limitTransactionValue whenNotPaused {\n', '        SecurityInstance storage curInst = instances[_instId];\n', '        // Must deposit the right amount\n', '        require(curInst.depositAmount == msg.value);\n', '        // Cannot have more depositors than the limit\n', '        require(curInst.depositors.length < depositorLimit);\n', '        // Cannot double-deposit\n', '        require(curInst.depositorState[msg.sender] == DepositorState.None);\n', '\n', '        curInst.depositorState[msg.sender] = DepositorState.Active;\n', '        curInst.depositorNote[msg.sender] = _note;\n', '        curInst.depositors.push(msg.sender);\n', '        \n', '        Deposit(curInst.instId, msg.sender, msg.value, _note);\n', '    }\n', '    \n', '    function claim(uint _instId, address _whoToClaim) public onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused returns (bool) {\n', '        SecurityInstance storage curInst = instances[_instId];\n', '        \n', '        // Can only call if the state is active\n', '        if(curInst.depositorState[_whoToClaim] != DepositorState.Active) {\n', '            return false;\n', '        }\n', '\n', '        curInst.depositorState[_whoToClaim] = DepositorState.Claimed;\n', '        curInst.instOwner.transfer(curInst.depositAmount);\n', '        DepositClaimed(_instId, _whoToClaim, curInst.depositAmount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function refund(uint _instId, address _whoToRefund) public onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused returns (bool) {\n', '        SecurityInstance storage curInst = instances[_instId];\n', '        \n', '        // Can only call if state is active\n', '        if(curInst.depositorState[_whoToRefund] != DepositorState.Active) {\n', '            return false;\n', '        }\n', '\n', '        curInst.depositorState[_whoToRefund] = DepositorState.Refunded;\n', '        _whoToRefund.transfer(curInst.depositAmount);\n', '        RefundSent(_instId, _whoToRefund, curInst.depositAmount);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function claimFromSeveral(uint _instId, address[] _toClaim) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {\n', '        for(uint i = 0; i < _toClaim.length; i++) {\n', '            claim(_instId, _toClaim[i]);\n', '        }\n', '    }\n', '    \n', '    function refundFromSeveral(uint _instId, address[] _toRefund) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {\n', '        for(uint i = 0; i < _toRefund.length; i++) {\n', '            refund(_instId, _toRefund[i]);\n', '        }\n', '    }\n', '    \n', '    function claimAll(uint _instId) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {\n', '        SecurityInstance storage curInst = instances[_instId];\n', '        \n', '        for(uint i = 0; i < curInst.depositors.length; i++) {\n', '            claim(_instId, curInst.depositors[i]);\n', '        }\n', '    }\n', '    \n', '    function refundAll(uint _instId) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {\n', '        SecurityInstance storage curInst = instances[_instId];\n', '        \n', '        for(uint i = 0; i < curInst.depositors.length; i++) {\n', '            refund(_instId, curInst.depositors[i]);\n', '        }\n', '    }\n', '\n', '    function changeDepositorLimit(uint _newLimit) external onlyOwner {\n', '        DepositorLimitChanged(depositorLimit, _newLimit);\n', '        depositorLimit = _newLimit;\n', '    }\n', '    \n', '    // Information functions\n', '    \n', '    function getInstanceMetadata(uint _instId) constant external returns (address instOwner, string ownerNote, string depositPurpose, uint depositAmount) {\n', '        instOwner = instances[_instId].instOwner;\n', '        ownerNote = instances[_instId].ownerNote;\n', '        depositPurpose = instances[_instId].depositPurpose;\n', '        depositAmount = instances[_instId].depositAmount;\n', '    }\n', '    \n', '    function getAllDepositors(uint _instId) constant external returns (address[]) {\n', '        return instances[_instId].depositors;\n', '    }\n', '    \n', '    function checkInfo(uint _instId, address _depositor) constant external returns (DepositorState depositorState, string note) {\n', '        depositorState = instances[_instId].depositorState[_depositor];\n', '        note = instances[_instId].depositorNote[_depositor];\n', '    }\n', '\n', '    // Metrics\n', '\n', '    function getDepositInstanceCount() constant external returns (uint) {\n', '        return instanceId - 1; // ID is 1-indexed\n', '    }\n', '}']

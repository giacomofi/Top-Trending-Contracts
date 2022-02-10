['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'contract Upgradable is Ownable, Pausable {\n', '    // Set in case the core contract is broken and an upgrade is required\n', '    address public newContractAddress;\n', '\n', '    /// @dev Emited when contract is upgraded - See README.md for updgrade plan\n', '    event ContractUpgrade(address newContract);\n', '\n', '    /// @dev Used to mark the smart contract as upgraded, in case there is a serious\n', '    ///  breaking bug. This method does nothing but keep track of the new contract and\n', "    ///  emit a message indicating that the new address is set. It's up to clients of this\n", '    ///  contract to update to the new contract address in that case. (This contract will\n', '    ///  be paused indefinitely if such an upgrade takes place.)\n', '    /// @param _v2Address new address\n', '    function setNewAddress(address _v2Address) external onlyOwner whenPaused {\n', '        require(_v2Address != 0x0);\n', '        newContractAddress = _v2Address;\n', '        emit ContractUpgrade(_v2Address);\n', '    }\n', '\n', '}\n', '\n', '/// @title The main SolidStamp.com contract\n', 'contract SolidStamp is Ownable, Pausable, Upgradable {\n', '    using SafeMath for uint;\n', '\n', '    /// @dev const value to indicate the contract is audited and approved\n', '    uint8 public constant NOT_AUDITED = 0x00;\n', '\n', '    /// @dev const value to indicate the contract is audited and approved\n', '    uint8 public constant AUDITED_AND_APPROVED = 0x01;\n', '\n', '    /// @dev const value to indicate the contract is audited and rejected\n', '    uint8 public constant AUDITED_AND_REJECTED = 0x02;\n', '\n', '    /// @dev minimum amount of time for an audit request\n', '    uint public constant MIN_AUDIT_TIME = 24 hours;\n', '\n', '    /// @dev maximum amount of time for an audit request\n', '    uint public constant MAX_AUDIT_TIME = 28 days;\n', '\n', '    /// @dev aggregated amount of audit requests\n', '    uint public totalRequestsAmount = 0;\n', '\n', '    // @dev amount of collected commision available to withdraw\n', '    uint public availableCommission = 0;\n', '\n', '    // @dev commission percentage, initially 9%\n', '    uint public commission = 9;\n', '\n', '    /// @dev event fired when the service commission is changed\n', '    event NewCommission(uint commmission);\n', '\n', '    /// @notice SolidStamp constructor\n', '    constructor() public {\n', '    }\n', '\n', '    /// @notice Audit request\n', '    struct AuditRequest {\n', '        // amount of Ethers offered by a particular requestor for an audit\n', '        uint amount;\n', '        // request expiration date\n', '        uint expireDate;\n', '    }\n', '\n', '    /// @dev Maps auditor and code hash to the total reward offered for auditing\n', '    /// the particular contract by the particular auditor.\n', '    /// Map key is: keccack256(auditor address, contract codeHash)\n', '    /// @dev codeHash is a sha3 from the contract byte code\n', '    mapping (bytes32 => uint) public rewards;\n', '\n', '    /// @dev Maps auditor and code hash to the outcome of the audit of\n', '    /// the particular contract by the particular auditor.\n', '    /// Map key is: keccack256(auditor address, contract codeHash)\n', '    /// @dev codeHash is a sha3 from the contract byte code\n', '    mapping (bytes32 => uint8) public auditOutcomes;\n', '\n', '    /// @dev Maps requestor, auditor and codeHash to an AuditRequest\n', '    /// Map key is: keccack256(auditor address, requestor address, contract codeHash)\n', '    mapping (bytes32 => AuditRequest) public auditRequests;\n', '\n', '    /// @dev event fired upon successul audit request\n', '    event AuditRequested(address auditor, address bidder, bytes32 codeHash, uint amount, uint expireDate);\n', '    /// @dev event fired when an request is sucessfully withdrawn\n', '    event RequestWithdrawn(address auditor, address bidder, bytes32 codeHash, uint amount);\n', '    /// @dev event fired when a contract is sucessfully audited\n', '    event ContractAudited(address auditor, bytes32 codeHash, uint reward, bool isApproved);\n', '\n', '    /// @notice registers an audit request\n', '    /// @param _auditor the address of the auditor the request is directed to\n', '    /// @param _codeHash the code hash of the contract to audit. _codeHash equals to sha3 of the contract byte-code\n', '    /// @param _auditTime the amount of time after which the requestor can withdraw the request\n', '    function requestAudit(address _auditor, bytes32 _codeHash, uint _auditTime)\n', '    public whenNotPaused payable\n', '    {\n', '        require(_auditor != 0x0);\n', '        // audit request cannot expire too quickly or last too long\n', '        require(_auditTime >= MIN_AUDIT_TIME);\n', '        require(_auditTime <= MAX_AUDIT_TIME);\n', '        require(msg.value > 0);\n', '\n', '        bytes32 hashAuditorCode = keccak256(_auditor, _codeHash);\n', '\n', '        // revert if the contract is already audited by the auditor\n', '        uint8 outcome = auditOutcomes[hashAuditorCode];\n', '        require(outcome == NOT_AUDITED);\n', '\n', '        uint currentReward = rewards[hashAuditorCode];\n', '        uint expireDate = now.add(_auditTime);\n', '        rewards[hashAuditorCode] = currentReward.add(msg.value);\n', '        totalRequestsAmount = totalRequestsAmount.add(msg.value);\n', '\n', '        bytes32 hashAuditorRequestorCode = keccak256(_auditor, msg.sender, _codeHash);\n', '        AuditRequest storage request = auditRequests[hashAuditorRequestorCode];\n', '        if ( request.amount == 0 ) {\n', '            // first request from msg.sender to audit contract _codeHash by _auditor\n', '            auditRequests[hashAuditorRequestorCode] = AuditRequest({\n', '                amount : msg.value,\n', '                expireDate : expireDate\n', '            });\n', '            emit AuditRequested(_auditor, msg.sender, _codeHash, msg.value, expireDate);\n', '        } else {\n', '            // Request already exists. Increasing value\n', '            request.amount = request.amount.add(msg.value);\n', '            // if new expireDate is later than existing one - increase the existing one\n', '            if ( expireDate > request.expireDate )\n', '                request.expireDate = expireDate;\n', '            // event returns the total request value and its expireDate\n', '            emit AuditRequested(_auditor, msg.sender, _codeHash, request.amount, request.expireDate);\n', '        }\n', '    }\n', '\n', '    /// @notice withdraws an audit request\n', '    /// @param _auditor the address of the auditor the request is directed to\n', '    /// @param _codeHash the code hash of the contract to audit. _codeHash equals to sha3 of the contract byte-code\n', '    function withdrawRequest(address _auditor, bytes32 _codeHash)\n', '    public\n', '    {\n', '        bytes32 hashAuditorCode = keccak256(_auditor, _codeHash);\n', '\n', '        // revert if the contract is already audited by the auditor\n', '        uint8 outcome = auditOutcomes[hashAuditorCode];\n', '        require(outcome == NOT_AUDITED);\n', '\n', '        bytes32 hashAuditorRequestorCode = keccak256(_auditor, msg.sender, _codeHash);\n', '        AuditRequest storage request = auditRequests[hashAuditorRequestorCode];\n', '        require(request.amount > 0);\n', '        require(now > request.expireDate);\n', '\n', '        uint amount = request.amount;\n', '        delete request.amount;\n', '        delete request.expireDate;\n', '        rewards[hashAuditorCode] = rewards[hashAuditorCode].sub(amount);\n', '        totalRequestsAmount = totalRequestsAmount.sub(amount);\n', '        emit RequestWithdrawn(_auditor, msg.sender, _codeHash, amount);\n', '        msg.sender.transfer(amount);\n', '    }\n', '\n', '    /// @notice marks contract as audited\n', '    /// @param _codeHash the code hash of the stamped contract. _codeHash equals to sha3 of the contract byte-code\n', '    /// @param _isApproved whether the contract is approved or rejected\n', '    function auditContract(bytes32 _codeHash, bool _isApproved)\n', '    public whenNotPaused\n', '    {\n', '        bytes32 hashAuditorCode = keccak256(msg.sender, _codeHash);\n', '\n', '        // revert if the contract is already audited by the auditor\n', '        uint8 outcome = auditOutcomes[hashAuditorCode];\n', '        require(outcome == NOT_AUDITED);\n', '\n', '        if ( _isApproved )\n', '            auditOutcomes[hashAuditorCode] = AUDITED_AND_APPROVED;\n', '        else\n', '            auditOutcomes[hashAuditorCode] = AUDITED_AND_REJECTED;\n', '        uint reward = rewards[hashAuditorCode];\n', '        totalRequestsAmount = totalRequestsAmount.sub(reward);\n', '        commission = calcCommission(reward);\n', '        availableCommission = availableCommission.add(commission);\n', '        emit ContractAudited(msg.sender, _codeHash, reward, _isApproved);\n', '        msg.sender.transfer(reward.sub(commission));\n', '    }\n', '\n', '    /// @dev const value to indicate the maximum commision service owner can set\n', '    uint public constant MAX_COMMISION = 33;\n', '\n', '    /// @notice ability for owner to change the service commmission\n', '    /// @param _newCommission new commision percentage\n', '    function changeCommission(uint _newCommission) public onlyOwner whenNotPaused {\n', '        require(_newCommission <= MAX_COMMISION);\n', '        require(_newCommission != commission);\n', '        commission = _newCommission;\n', '        emit NewCommission(commission);\n', '    }\n', '\n', '    /// @notice calculates the SolidStamp commmission\n', '    /// @param _amount amount to calcuate the commission from\n', '    function calcCommission(uint _amount) private view returns(uint) {\n', '        return _amount.mul(commission)/100; // service commision\n', '    }\n', '\n', '    /// @notice ability for owner to withdraw the commission\n', '    /// @param _amount amount to withdraw\n', '    function withdrawCommission(uint _amount) public onlyOwner {\n', '        // cannot withdraw money reserved for requests\n', '        require(_amount <= availableCommission);\n', '        availableCommission = availableCommission.sub(_amount);\n', '        msg.sender.transfer(_amount);\n', '    }\n', '\n', "    /// @dev Override unpause so we can't have newContractAddress set,\n", '    ///  because then the contract was upgraded.\n', '    /// @notice This is public rather than external so we can call super.unpause\n', '    ///  without using an expensive CALL.\n', '    function unpause() public onlyOwner whenPaused {\n', '        require(newContractAddress == address(0));\n', '\n', '        // Actually unpause the contract.\n', '        super.unpause();\n', '    }\n', '\n', "    /// @notice We don't welcome tips & donations\n", '    function() payable public {\n', '        revert();\n', '    }\n', '}']
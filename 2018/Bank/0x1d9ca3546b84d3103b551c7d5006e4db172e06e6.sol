['pragma solidity ^0.4.18;\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    function Owned() \n', '    public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) \n', '        onlyOwner \n', '    public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract RealityCheckAPI {\n', '    function setQuestionFee(uint256 fee) public;\n', '    function finalizeByArbitrator(bytes32 question_id, bytes32 answer) public;\n', '    function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) public;\n', '    function notifyOfArbitrationRequest(bytes32 question_id, address requester) public;\n', '    function isFinalized(bytes32 question_id) public returns (bool);\n', '    function withdraw() public;\n', '}\n', '\n', 'contract Arbitrator is Owned {\n', '\n', '    mapping(bytes32 => uint256) public arbitration_bounties;\n', '\n', '    uint256 dispute_fee;\n', '    mapping(bytes32 => uint256) custom_dispute_fees;\n', '\n', '    event LogRequestArbitration(\n', '        bytes32 indexed question_id,\n', '        uint256 fee_paid,\n', '        address requester,\n', '        uint256 remaining\n', '    );\n', '\n', '    event LogSetQuestionFee(\n', '        uint256 fee\n', '    );\n', '\n', '    event LogSetDisputeFee(\n', '        uint256 fee\n', '    );\n', '\n', '    event LogSetCustomDisputeFee(\n', '        bytes32 indexed question_id,\n', '        uint256 fee\n', '    );\n', '\n', '    /// @notice Constructor. Sets the deploying address as owner.\n', '    function Arbitrator() \n', '    public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /// @notice Set the default fee\n', '    /// @param fee The default fee amount\n', '    function setDisputeFee(uint256 fee) \n', '        onlyOwner \n', '    public {\n', '        dispute_fee = fee;\n', '        LogSetDisputeFee(fee);\n', '    }\n', '\n', '    /// @notice Set a custom fee for this particular question\n', '    /// @param question_id The question in question\n', '    /// @param fee The fee amount\n', '    function setCustomDisputeFee(bytes32 question_id, uint256 fee) \n', '        onlyOwner \n', '    public {\n', '        custom_dispute_fees[question_id] = fee;\n', '        LogSetCustomDisputeFee(question_id, fee);\n', '    }\n', '\n', '    /// @notice Return the dispute fee for the specified question. 0 indicates that we won&#39;t arbitrate it.\n', '    /// @param question_id The question in question\n', '    /// @dev Uses a general default, but can be over-ridden on a question-by-question basis.\n', '    function getDisputeFee(bytes32 question_id) \n', '    public constant returns (uint256) {\n', '        return (custom_dispute_fees[question_id] > 0) ? custom_dispute_fees[question_id] : dispute_fee;\n', '    }\n', '\n', '    /// @notice Set a fee for asking a question with us as the arbitrator\n', '    /// @param realitycheck The RealityCheck contract address\n', '    /// @param fee The fee amount\n', '    /// @dev Default is no fee. Unlike the dispute fee, 0 is an acceptable setting.\n', '    /// You could set an impossibly high fee if you want to prevent us being used as arbitrator unless we submit the question.\n', '    /// (Submitting the question ourselves is not implemented here.)\n', '    /// This fee can be used as a revenue source, an anti-spam measure, or both.\n', '    function setQuestionFee(address realitycheck, uint256 fee) \n', '        onlyOwner \n', '    public {\n', '        RealityCheckAPI(realitycheck).setQuestionFee(fee);\n', '        LogSetQuestionFee(fee);\n', '    }\n', '\n', '    /// @notice Submit the arbitrator&#39;s answer to a question.\n', '    /// @param realitycheck The RealityCheck contract address\n', '    /// @param question_id The question in question\n', '    /// @param answer The answer\n', '    /// @param answerer The answerer. If arbitration changed the answer, it should be the payer. If not, the old answerer.\n', '    function submitAnswerByArbitrator(address realitycheck, bytes32 question_id, bytes32 answer, address answerer) \n', '        onlyOwner \n', '    public {\n', '        delete arbitration_bounties[question_id];\n', '        RealityCheckAPI(realitycheck).submitAnswerByArbitrator(question_id, answer, answerer);\n', '    }\n', '\n', '    /// @notice Request arbitration, freezing the question until we send submitAnswerByArbitrator\n', '    /// @dev The bounty can be paid only in part, in which case the last person to pay will be considered the payer\n', '    /// Will trigger an error if the notification fails, eg because the question has already been finalized\n', '    /// @param realitycheck The RealityCheck contract address\n', '    /// @param question_id The question in question\n', '    function requestArbitration(address realitycheck, bytes32 question_id) \n', '    external payable returns (bool) {\n', '\n', '        uint256 arbitration_fee = getDisputeFee(question_id);\n', '        require(arbitration_fee > 0);\n', '\n', '        arbitration_bounties[question_id] += msg.value;\n', '        uint256 paid = arbitration_bounties[question_id];\n', '\n', '        if (paid >= arbitration_fee) {\n', '            RealityCheckAPI(realitycheck).notifyOfArbitrationRequest(question_id, msg.sender);\n', '            LogRequestArbitration(question_id, msg.value, msg.sender, 0);\n', '            return true;\n', '        } else {\n', '            require(!RealityCheckAPI(realitycheck).isFinalized(question_id));\n', '            LogRequestArbitration(question_id, msg.value, msg.sender, arbitration_fee - paid);\n', '            return false;\n', '        }\n', '\n', '    }\n', '\n', '    /// @notice Withdraw any accumulated fees to the specified address\n', '    /// @param addr The address to which the balance should be sent\n', '    function withdraw(address addr) \n', '        onlyOwner \n', '    public {\n', '        addr.transfer(this.balance); \n', '    }\n', '\n', '    function() \n', '    public payable {\n', '    }\n', '\n', '    /// @notice Withdraw any accumulated question fees from the specified address into this contract\n', '    /// @param realitycheck The address of the Reality Check contract containing the fees\n', '    /// @dev Funds can then be liberated from this contract with our withdraw() function\n', '    function callWithdraw(address realitycheck) \n', '        onlyOwner \n', '    public {\n', '        RealityCheckAPI(realitycheck).withdraw(); \n', '    }\n', '\n', '}']
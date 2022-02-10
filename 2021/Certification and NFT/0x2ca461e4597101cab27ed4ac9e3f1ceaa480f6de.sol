['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-04\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-03\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', ' /**\n', ' *  @authors: [@clesaege]\n', ' *  @reviewers: [@remedcu]\n', ' *  @auditors: []\n', ' *  @bounties: []\n', ' *  @deployments: []\n', ' */\n', '\n', '\n', '/** @title Arbitrator\n', ' *  @author Clément Lesaege - <[email\xa0protected]>\n', ' *  Arbitrator abstract contract.\n', ' *  When developing arbitrator contracts we need to:\n', " *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).\n", ' *  -Define the functions for cost display (arbitrationCost and appealCost).\n', ' *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID, ruling).\n', ' */\n', 'contract Arbitrator {\n', '\n', '    enum DisputeStatus {Waiting, Appealable, Solved}\n', '\n', '    modifier requireArbitrationFee(bytes _extraData) {\n', '        require(msg.value >= arbitrationCost(_extraData), "Not enough ETH to cover arbitration costs.");\n', '        _;\n', '    }\n', '    modifier requireAppealFee(uint _disputeID, bytes _extraData) {\n', '        require(msg.value >= appealCost(_disputeID, _extraData), "Not enough ETH to cover appeal costs.");\n', '        _;\n', '    }\n', '\n', '    /** @dev To be raised when a dispute is created.\n', '     *  @param _disputeID ID of the dispute.\n', '     *  @param _arbitrable The contract which created the dispute.\n', '     */\n', '    event DisputeCreation(uint indexed _disputeID, IArbitrable indexed _arbitrable);\n', '\n', '    /** @dev To be raised when a dispute can be appealed.\n', '     *  @param _disputeID ID of the dispute.\n', '     *  @param _arbitrable The contract which created the dispute.\n', '     */\n', '    event AppealPossible(uint indexed _disputeID, IArbitrable indexed _arbitrable);\n', '\n', '    /** @dev To be raised when the current ruling is appealed.\n', '     *  @param _disputeID ID of the dispute.\n', '     *  @param _arbitrable The contract which created the dispute.\n', '     */\n', '    event AppealDecision(uint indexed _disputeID, IArbitrable indexed _arbitrable);\n', '\n', '    /** @dev Create a dispute. Must be called by the arbitrable contract.\n', '     *  Must be paid at least arbitrationCost(_extraData).\n', '     *  @param _choices Amount of choices the arbitrator can make in this dispute.\n', '     *  @param _extraData Can be used to give additional info on the dispute to be created.\n', '     *  @return disputeID ID of the dispute created.\n', '     */\n', '    function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID) {}\n', '\n', '    /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.\n', '     *  @param _extraData Can be used to give additional info on the dispute to be created.\n', '     *  @return fee Amount to be paid.\n', '     */\n', '    function arbitrationCost(bytes _extraData) public view returns(uint fee);\n', '\n', '    /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.\n', '     *  @param _disputeID ID of the dispute to be appealed.\n', '     *  @param _extraData Can be used to give extra info on the appeal.\n', '     */\n', '    function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {\n', '        emit AppealDecision(_disputeID, IArbitrable(msg.sender));\n', '    }\n', '\n', '    /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.\n', '     *  @param _disputeID ID of the dispute to be appealed.\n', '     *  @param _extraData Can be used to give additional info on the dispute to be created.\n', '     *  @return fee Amount to be paid.\n', '     */\n', '    function appealCost(uint _disputeID, bytes _extraData) public view returns(uint fee);\n', '\n', "    /** @dev Compute the start and end of the dispute's current or next appeal period, if possible.\n", '     *  @param _disputeID ID of the dispute.\n', '     *  @return The start and end of the period.\n', '     */\n', '    function appealPeriod(uint _disputeID) public view returns(uint start, uint end) {}\n', '\n', '    /** @dev Return the status of a dispute.\n', '     *  @param _disputeID ID of the dispute to rule.\n', '     *  @return status The status of the dispute.\n', '     */\n', '    function disputeStatus(uint _disputeID) public view returns(DisputeStatus status);\n', '\n', '    /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.\n', '     *  @param _disputeID ID of the dispute.\n', '     *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.\n', '     */\n', '    function currentRuling(uint _disputeID) public view returns(uint ruling);\n', '}\n', '\n', '\n', '/** @title IArbitrable\n', ' *  @author Enrique Piqueras - <[email\xa0protected]>\n', ' *  Arbitrable interface.\n', ' *  When developing arbitrable contracts, we need to:\n', ' *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.\n', ' *  -Allow dispute creation. For this a function must:\n', ' *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);\n', ' *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);\n', ' */\n', 'interface IArbitrable {\n', '    /** @dev To be emmited when meta-evidence is submitted.\n', '     *  @param _metaEvidenceID Unique identifier of meta-evidence.\n', '     *  @param _evidence A link to the meta-evidence JSON.\n', '     */\n', '    event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);\n', '\n', '    /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID\n', '     *  @param _arbitrator The arbitrator of the contract.\n', '     *  @param _disputeID ID of the dispute in the Arbitrator contract.\n', '     *  @param _metaEvidenceID Unique identifier of meta-evidence.\n', '     *  @param _evidenceGroupID Unique identifier of the evidence group that is linked to this dispute.\n', '     */\n', '    event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);\n', '\n', '    /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).\n', '     *  @param _arbitrator The arbitrator of the contract.\n', '     *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.\n', '     *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.\n', '     *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.\n', '     */\n', '    event Evidence(Arbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);\n', '\n', '    /** @dev To be raised when a ruling is given.\n', '     *  @param _arbitrator The arbitrator giving the ruling.\n', '     *  @param _disputeID ID of the dispute in the Arbitrator contract.\n', '     *  @param _ruling The ruling which was given.\n', '     */\n', '    event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);\n', '\n', '    /** @dev Give a ruling for a dispute. Must be called by the arbitrator.\n', '     *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.\n', '     *  @param _disputeID ID of the dispute in the Arbitrator contract.\n', '     *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".\n', '     */\n', '    function rule(uint _disputeID, uint _ruling) external;\n', '}\n', '\n', '\n', 'contract MultipleArbitrableTransactionWithFee is IArbitrable {\n', '\n', '    // **************************** //\n', '    // *    Contract variables    * //\n', '    // **************************** //\n', '\n', '    uint8 constant AMOUNT_OF_CHOICES = 2;\n', '    uint8 constant SENDER_WINS = 1;\n', '    uint8 constant RECEIVER_WINS = 2;\n', '\n', '    enum Party {Sender, Receiver}\n', '    enum Status {NoDispute, WaitingSender, WaitingReceiver, DisputeCreated, Resolved}\n', '\n', '    struct Transaction {\n', '        address sender;\n', '        address receiver;\n', '        uint amount;\n', '        uint timeoutPayment; // Time in seconds after which the transaction can be automatically executed if not disputed.\n', '        uint disputeId; // If dispute exists, the ID of the dispute.\n', '        uint senderFee; // Total arbitration fees paid by the sender.\n', '        uint receiverFee; // Total arbitration fees paid by the receiver.\n', '        uint lastInteraction; // Last interaction for the dispute procedure.\n', '        Status status;\n', '    }\n', '\n', '    address public feeRecipient; // Address which receives a share of receiver payment.\n', '    uint public feeRecipientBasisPoint; // The share of fee to be received by the feeRecipient, down to 2 decimal places as 550 = 5.5%.\n', '    Transaction[] public transactions;\n', '    bytes public arbitratorExtraData; // Extra data to set up the arbitration.\n', '    Arbitrator public arbitrator; // Address of the arbitrator contract.\n', '    uint public feeTimeout; // Time in seconds a party can take to pay arbitration fees before being considered unresponding and lose the dispute.\n', '\n', '\n', '    mapping (uint => uint) public disputeIDtoTransactionID; // One-to-one relationship between the dispute and the transaction.\n', '\n', '    // **************************** //\n', '    // *          Events          * //\n', '    // **************************** //\n', '\n', '    /** @dev To be emitted when a party pays or reimburses the other.\n', '     *  @param _transactionID The index of the transaction.\n', '     *  @param _amount The amount paid.\n', '     *  @param _party The party that paid.\n', '     */\n', '    event Payment(uint indexed _transactionID, uint _amount, address _party);\n', '\n', '    /** @dev To be emitted when a fee is received by the feeRecipient.\n', '     *  @param _transactionID The index of the transaction.\n', '     *  @param _amount The amount paid.\n', '     */\n', '    event FeeRecipientPayment(uint indexed _transactionID, uint _amount);\n', '\n', '    /** @dev To be emitted when a feeRecipient is changed.\n', '     *  @param _oldFeeRecipient Previous feeRecipient.\n', '     *  @param _newFeeRecipient Current feeRecipient.\n', '     */\n', '    event FeeRecipientChanged(address indexed _oldFeeRecipient, address indexed _newFeeRecipient);\n', '\n', '    /** @dev Indicate that a party has to pay a fee or would otherwise be considered as losing.\n', '     *  @param _transactionID The index of the transaction.\n', '     *  @param _party The party who has to pay.\n', '     */\n', '    event HasToPayFee(uint indexed _transactionID, Party _party);\n', '\n', '    /** @dev To be raised when a ruling is given.\n', '     *  @param _arbitrator The arbitrator giving the ruling.\n', '     *  @param _disputeID ID of the dispute in the Arbitrator contract.\n', '     *  @param _ruling The ruling which was given.\n', '     */\n', '    event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);\n', '\n', '    /** @dev Emitted when a transaction is created.\n', '     *  @param _transactionID The index of the transaction.\n', '     *  @param _sender The address of the sender.\n', '     *  @param _receiver The address of the receiver.\n', '     *  @param _amount The initial amount in the transaction.\n', '     */\n', '    event TransactionCreated(uint _transactionID, address indexed _sender, address indexed _receiver, uint _amount);\n', '\n', '    // **************************** //\n', '    // *    Arbitrable functions  * //\n', '    // *    Modifying the state   * //\n', '    // **************************** //\n', '\n', '    /** @dev Constructor.\n', '     *  @param _arbitrator The arbitrator of the contract.\n', '     *  @param _arbitratorExtraData Extra data for the arbitrator.\n', '     *  @param _feeRecipient Address which receives a share of receiver payment.\n', '     *  @param _feeRecipientBasisPoint The share of fee to be received by the feeRecipient, down to 2 decimal places as 550 = 5.5%.\n', '     *  @param _feeTimeout Arbitration fee timeout for the parties.\n', '     */\n', '    constructor (\n', '        Arbitrator _arbitrator,\n', '        bytes _arbitratorExtraData,\n', '        address _feeRecipient,\n', '        uint _feeRecipientBasisPoint,\n', '        uint _feeTimeout\n', '    ) public {\n', '        arbitrator = _arbitrator;\n', '        arbitratorExtraData = _arbitratorExtraData;\n', '        feeRecipient = _feeRecipient;\n', "        // Basis point being set higher than 10000 will result in underflow, but it's the responsibility of the deployer of the contract.\n", '        feeRecipientBasisPoint = _feeRecipientBasisPoint;\n', '        feeTimeout = _feeTimeout;\n', '    }\n', '\n', '    /** @dev Create a transaction.\n', '     *  @param _timeoutPayment Time after which a party can automatically execute the arbitrable transaction.\n', '     *  @param _receiver The recipient of the transaction.\n', '     *  @param _metaEvidence Link to the meta-evidence.\n', '     *  @return transactionID The index of the transaction.\n', '     */\n', '    function createTransaction(\n', '        uint _timeoutPayment,\n', '        address _receiver,\n', '        string _metaEvidence\n', '    ) public payable returns (uint transactionID) {\n', '        transactions.push(Transaction({\n', '            sender: msg.sender,\n', '            receiver: _receiver,\n', '            amount: msg.value,\n', '            timeoutPayment: _timeoutPayment,\n', '            disputeId: 0,\n', '            senderFee: 0,\n', '            receiverFee: 0,\n', '            lastInteraction: now,\n', '            status: Status.NoDispute\n', '        }));\n', '        emit MetaEvidence(transactions.length - 1, _metaEvidence);\n', '        emit TransactionCreated(transactions.length - 1, msg.sender, _receiver, msg.value);\n', '\n', '        return transactions.length - 1;\n', '    }\n', '\n', '    /** @dev Calculate the amount to be paid in wei according to feeRecipientBasisPoint for a particular amount.\n', '     *  @param _amount Amount to pay in wei.\n', '     */\n', '    function calculateFeeRecipientAmount(uint _amount) internal view returns(uint feeAmount){\n', '        feeAmount = (_amount * feeRecipientBasisPoint) / 10000;\n', '    }\n', '\n', '    /** @dev Change Fee Recipient.\n', '     *  @param _newFeeRecipient Address of the new Fee Recipient.\n', '     */\n', '    function changeFeeRecipient(address _newFeeRecipient) public {\n', '        require(msg.sender == feeRecipient, "The caller must be the current Fee Recipient");\n', '        feeRecipient = _newFeeRecipient;\n', '\n', '        emit FeeRecipientChanged(msg.sender, _newFeeRecipient);\n', '    }\n', '\n', '    /** @dev Pay receiver. To be called if the good or service is provided.\n', '     *  @param _transactionID The index of the transaction.\n', '     *  @param _amount Amount to pay in wei.\n', '     */\n', '    function pay(uint _transactionID, uint _amount) public {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '        require(transaction.sender == msg.sender, "The caller must be the sender.");\n', '        require(transaction.status == Status.NoDispute, "The transaction shouldn\'t be disputed.");\n', '        require(_amount <= transaction.amount, "The amount paid has to be less than or equal to the transaction.");\n', '\n', '        transaction.amount -= _amount;\n', '\n', '        uint feeAmount = calculateFeeRecipientAmount(_amount);\n', '        feeRecipient.send(feeAmount);\n', '        transaction.receiver.send(_amount - feeAmount);\n', '\n', '        emit Payment(_transactionID, _amount, msg.sender);\n', '        emit FeeRecipientPayment(_transactionID, feeAmount);\n', '    }\n', '\n', "    /** @dev Reimburse sender. To be called if the good or service can't be fully provided.\n", '     *  @param _transactionID The index of the transaction.\n', '     *  @param _amountReimbursed Amount to reimburse in wei.\n', '     */\n', '    function reimburse(uint _transactionID, uint _amountReimbursed) public {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '        require(transaction.receiver == msg.sender, "The caller must be the receiver.");\n', '        require(transaction.status == Status.NoDispute, "The transaction shouldn\'t be disputed.");\n', '        require(_amountReimbursed <= transaction.amount, "The amount reimbursed has to be less or equal than the transaction.");\n', '\n', '        transaction.sender.transfer(_amountReimbursed);\n', '        transaction.amount -= _amountReimbursed;\n', '        emit Payment(_transactionID, _amountReimbursed, msg.sender);\n', '    }\n', '\n', "    /** @dev Transfer the transaction's amount to the receiver if the timeout has passed.\n", '     *  @param _transactionID The index of the transaction.\n', '     */\n', '    function executeTransaction(uint _transactionID) public {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '        require(now - transaction.lastInteraction >= transaction.timeoutPayment, "The timeout has not passed yet.");\n', '        require(transaction.status == Status.NoDispute, "The transaction shouldn\'t be disputed.");\n', '\n', '        uint amount = transaction.amount;\n', '        transaction.amount = 0;\n', '        uint feeAmount = calculateFeeRecipientAmount(amount);\n', '        feeRecipient.send(feeAmount);\n', '        transaction.receiver.send(amount - feeAmount);\n', '\n', '        emit FeeRecipientPayment(_transactionID, feeAmount);\n', '\n', '        transaction.status = Status.Resolved;\n', '    }\n', '\n', '    /** @dev Reimburse sender if receiver fails to pay the fee.\n', '     *  @param _transactionID The index of the transaction.\n', '     */\n', '    function timeOutBySender(uint _transactionID) public {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '        require(transaction.status == Status.WaitingReceiver, "The transaction is not waiting on the receiver.");\n', '        require(now - transaction.lastInteraction >= feeTimeout, "Timeout time has not passed yet.");        \n', '\n', '        if (transaction.receiverFee != 0) {\n', '            transaction.receiver.send(transaction.receiverFee);\n', '            transaction.receiverFee = 0;\n', '        }\n', '        executeRuling(_transactionID, SENDER_WINS);\n', '    }\n', '\n', '    /** @dev Pay receiver if sender fails to pay the fee.\n', '     *  @param _transactionID The index of the transaction.\n', '     */\n', '    function timeOutByReceiver(uint _transactionID) public {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '        require(transaction.status == Status.WaitingSender, "The transaction is not waiting on the sender.");\n', '        require(now - transaction.lastInteraction >= feeTimeout, "Timeout time has not passed yet.");\n', '\n', '        if (transaction.senderFee != 0) {\n', '            transaction.sender.send(transaction.senderFee);\n', '            transaction.senderFee = 0;\n', '        }\n', '        executeRuling(_transactionID, RECEIVER_WINS);\n', '    }\n', '\n', '    /** @dev Pay the arbitration fee to raise a dispute. To be called by the sender. UNTRUSTED.\n', '     *  Note that the arbitrator can have createDispute throw, which will make this function throw and therefore lead to a party being timed-out.\n', '     *  This is not a vulnerability as the arbitrator can rule in favor of one party anyway.\n', '     *  @param _transactionID The index of the transaction.\n', '     */\n', '    function payArbitrationFeeBySender(uint _transactionID) public payable {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '        uint arbitrationCost = arbitrator.arbitrationCost(arbitratorExtraData);\n', '\n', '        require(transaction.status < Status.DisputeCreated, "Dispute has already been created or because the transaction has been executed.");\n', '        require(msg.sender == transaction.sender, "The caller must be the sender.");\n', '\n', '        transaction.senderFee += msg.value;\n', '        // Require that the total pay at least the arbitration cost.\n', '        require(transaction.senderFee >= arbitrationCost, "The sender fee must cover arbitration costs.");\n', '\n', '        transaction.lastInteraction = now;\n', '\n', '        // The receiver still has to pay. This can also happen if he has paid, but arbitrationCost has increased.\n', '        if (transaction.receiverFee < arbitrationCost) {\n', '            transaction.status = Status.WaitingReceiver;\n', '            emit HasToPayFee(_transactionID, Party.Receiver);\n', '        } else { // The receiver has also paid the fee. We create the dispute.\n', '            raiseDispute(_transactionID, arbitrationCost);\n', '        }\n', '    }\n', '\n', '    /** @dev Pay the arbitration fee to raise a dispute. To be called by the receiver. UNTRUSTED.\n', '     *  Note that this function mirrors payArbitrationFeeBySender.\n', '     *  @param _transactionID The index of the transaction.\n', '     */\n', '    function payArbitrationFeeByReceiver(uint _transactionID) public payable {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '        uint arbitrationCost = arbitrator.arbitrationCost(arbitratorExtraData);\n', '\n', '        require(transaction.status < Status.DisputeCreated, "Dispute has already been created or because the transaction has been executed.");\n', '        require(msg.sender == transaction.receiver, "The caller must be the receiver.");\n', '\n', '        transaction.receiverFee += msg.value;\n', '        // Require that the total paid to be at least the arbitration cost.\n', '        require(transaction.receiverFee >= arbitrationCost, "The receiver fee must cover arbitration costs.");\n', '\n', '        transaction.lastInteraction = now;\n', '        // The sender still has to pay. This can also happen if he has paid, but arbitrationCost has increased.\n', '        if (transaction.senderFee < arbitrationCost) {\n', '            transaction.status = Status.WaitingSender;\n', '            emit HasToPayFee(_transactionID, Party.Sender);\n', '        } else { // The sender has also paid the fee. We create the dispute.\n', '            raiseDispute(_transactionID, arbitrationCost);\n', '        }\n', '    }\n', '\n', '    /** @dev Create a dispute. UNTRUSTED.\n', '     *  @param _transactionID The index of the transaction.\n', '     *  @param _arbitrationCost Amount to pay the arbitrator.\n', '     */\n', '    function raiseDispute(uint _transactionID, uint _arbitrationCost) internal {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '        transaction.status = Status.DisputeCreated;\n', '        transaction.disputeId = arbitrator.createDispute.value(_arbitrationCost)(AMOUNT_OF_CHOICES, arbitratorExtraData);\n', '        disputeIDtoTransactionID[transaction.disputeId] = _transactionID;\n', '        emit Dispute(arbitrator, transaction.disputeId, _transactionID, _transactionID);\n', '\n', '        // Refund sender if it overpaid.\n', '        if (transaction.senderFee > _arbitrationCost) {\n', '            uint extraFeeSender = transaction.senderFee - _arbitrationCost;\n', '            transaction.senderFee = _arbitrationCost;\n', '            transaction.sender.send(extraFeeSender);\n', '        }\n', '\n', '        // Refund receiver if it overpaid.\n', '        if (transaction.receiverFee > _arbitrationCost) {\n', '            uint extraFeeReceiver = transaction.receiverFee - _arbitrationCost;\n', '            transaction.receiverFee = _arbitrationCost;\n', '            transaction.receiver.send(extraFeeReceiver);\n', '        }\n', '    }\n', '\n', '    /** @dev Submit a reference to evidence. EVENT.\n', '     *  @param _transactionID The index of the transaction.\n', '     *  @param _evidence A link to an evidence using its URI.\n', '     */\n', '    function submitEvidence(uint _transactionID, string _evidence) public {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '        require(\n', '            msg.sender == transaction.sender || msg.sender == transaction.receiver,\n', '            "The caller must be the sender or the receiver."\n', '        );\n', '        require(\n', '            transaction.status < Status.Resolved,\n', '            "Must not send evidence if the dispute is resolved."\n', '        );\n', '\n', '        emit Evidence(arbitrator, _transactionID, msg.sender, _evidence);\n', '    }\n', '\n', '    /** @dev Appeal an appealable ruling.\n', '     *  Transfer the funds to the arbitrator.\n', '     *  Note that no checks are required as the checks are done by the arbitrator.\n', '     *  @param _transactionID The index of the transaction.\n', '     */\n', '    function appeal(uint _transactionID) public payable {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '\n', '        arbitrator.appeal.value(msg.value)(transaction.disputeId, arbitratorExtraData);\n', '    }\n', '\n', '    /** @dev Give a ruling for a dispute. Must be called by the arbitrator.\n', '     *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.\n', '     *  @param _disputeID ID of the dispute in the Arbitrator contract.\n', '     *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".\n', '     */\n', '    function rule(uint _disputeID, uint _ruling) public {\n', '        uint transactionID = disputeIDtoTransactionID[_disputeID];\n', '        Transaction storage transaction = transactions[transactionID];\n', '        require(msg.sender == address(arbitrator), "The caller must be the arbitrator.");\n', '        require(transaction.status == Status.DisputeCreated, "The dispute has already been resolved.");\n', '\n', '        emit Ruling(Arbitrator(msg.sender), _disputeID, _ruling);\n', '\n', '        executeRuling(transactionID, _ruling);\n', '    }\n', '\n', '    /** @dev Execute a ruling of a dispute. It reimburses the fee to the winning party.\n', '     *  @param _transactionID The index of the transaction.\n', '     *  @param _ruling Ruling given by the arbitrator. 1 : Reimburse the receiver. 2 : Pay the sender.\n', '     */\n', '    function executeRuling(uint _transactionID, uint _ruling) internal {\n', '        Transaction storage transaction = transactions[_transactionID];\n', '        require(_ruling <= AMOUNT_OF_CHOICES, "Invalid ruling.");\n', '\n', '        uint amount = transaction.amount;\n', '        uint senderArbitrationFee = transaction.senderFee;\n', '        uint receiverArbitrationFee = transaction.receiverFee;\n', '\n', '        transaction.amount = 0;\n', '        transaction.senderFee = 0;\n', '        transaction.receiverFee = 0;\n', '\n', '        uint feeAmount;\n', '\n', '        // Give the arbitration fee back.\n', '        // Note that we use send to prevent a party from blocking the execution.\n', '        if (_ruling == SENDER_WINS) {\n', '            transaction.sender.send(senderArbitrationFee + amount);\n', '        } else if (_ruling == RECEIVER_WINS) {\n', '            feeAmount = calculateFeeRecipientAmount(amount);\n', '\n', '            feeRecipient.send(feeAmount);\n', '            transaction.receiver.send(receiverArbitrationFee + amount - feeAmount);\n', '\n', '            emit FeeRecipientPayment(_transactionID, feeAmount);\n', '        } else {\n', '            uint split_arbitration = senderArbitrationFee / 2;\n', '            uint split_amount = amount / 2;\n', '            feeAmount = calculateFeeRecipientAmount(split_amount);\n', '\n', '            transaction.sender.send(split_arbitration + split_amount);\n', '            feeRecipient.send(feeAmount);\n', '            transaction.receiver.send(split_arbitration + split_amount - feeAmount);\n', '\n', '            emit FeeRecipientPayment(_transactionID, feeAmount);\n', '        }\n', '\n', '        transaction.status = Status.Resolved;\n', '    }\n', '\n', '    // **************************** //\n', '    // *     Constant getters     * //\n', '    // **************************** //\n', '\n', '    /** @dev Getter to know the count of transactions.\n', '     *  @return countTransactions The count of transactions.\n', '     */\n', '    function getCountTransactions() public view returns (uint countTransactions) {\n', '        return transactions.length;\n', '    }\n', '\n', '    /** @dev Get IDs for transactions where the specified address is the receiver and/or the sender.\n', '     *  This function must be used by the UI and not by other smart contracts.\n', '     *  Note that the complexity is O(t), where t is amount of arbitrable transactions.\n', '     *  @param _address The specified address.\n', '     *  @return transactionIDs The transaction IDs.\n', '     */\n', '    function getTransactionIDsByAddress(address _address) public view returns (uint[] transactionIDs) {\n', '        uint count = 0;\n', '        for (uint i = 0; i < transactions.length; i++) {\n', '            if (transactions[i].sender == _address || transactions[i].receiver == _address)\n', '                count++;\n', '        }\n', '\n', '        transactionIDs = new uint[](count);\n', '\n', '        count = 0;\n', '\n', '        for (uint j = 0; j < transactions.length; j++) {\n', '            if (transactions[j].sender == _address || transactions[j].receiver == _address)\n', '                transactionIDs[count++] = j;\n', '        }\n', '    }\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-08\n', '*/\n', '\n', '// SPDX-License-Identifier: LGPL-3.0-only\n', 'pragma solidity >=0.8.0;\n', '\n', 'interface Realitio {\n', '\n', '    // mapping(bytes32 => Question) public questions;\n', '\n', '    /// @notice Ask a new question without a bounty and return the ID\n', '    /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.\n', '    /// @dev Calling without the token param will only work if there is no arbitrator-set question fee.\n', '    /// @dev This has the same function signature as askQuestion() in the non-ERC20 version, which is optionally payable.\n', '    /// @param template_id The ID number of the template the question will use\n', '    /// @param question A string containing the parameters that will be passed into the template to make the question\n', '    /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute\n', '    /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer\n', '    /// @param opening_ts If set, the earliest time it should be possible to answer the question.\n', '    /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.\n', '    /// @return The ID of the newly-created question, created deterministically.\n', '    function askQuestion(\n', '        uint256 template_id, string calldata question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce\n', '    ) external returns (bytes32);\n', '\n', '    /// @notice Report whether the answer to the specified question is finalized\n', '    /// @param question_id The ID of the question\n', '    /// @return Return true if finalized\n', '    function isFinalized(bytes32 question_id) view external returns (bool);\n', '\n', "    /// @notice Return the final answer to the specified question, or revert if there isn't one\n", '    /// @param question_id The ID of the question\n', '    /// @return The answer formatted as a bytes32\n', '    function resultFor(bytes32 question_id) external view returns (bytes32);\n', '\n', '    /// @notice Returns the timestamp at which the question will be/was finalized\n', '    /// @param question_id The ID of the question \n', '    function getFinalizeTS(bytes32 question_id) external view returns (uint32);\n', '\n', '    /// @notice Returns whether the question is pending arbitration\n', '    /// @param question_id The ID of the question \n', '    function isPendingArbitration(bytes32 question_id) external view returns (bool);\n', '\n', '    /// @notice Create a reusable template, which should be a JSON document.\n', '    /// Placeholders should use gettext() syntax, eg %s.\n', '    /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.\n', '    /// @param content The template content\n', '    /// @return The ID of the newly-created template, which is created sequentially.\n', '    function createTemplate(string calldata content) external returns (uint256);\n', '\n', '    /// @notice Returns the highest bond posted so far for a question\n', '    /// @param question_id The ID of the question \n', '    function getBond(bytes32 question_id) external view returns (uint256);\n', '\n', "    /// @notice Returns the questions's content hash, identifying the question content\n", '    /// @param question_id The ID of the question \n', '    function getContentHash(bytes32 question_id) external view returns (bytes32);\n', '}\n', '\n', 'contract Enum {\n', '  enum Operation { Call, DelegateCall }\n', '}\n', '\n', 'interface Executor {\n', '  /// @dev Allows a Module to execute a transaction.\n', '  /// @param to Destination address of module transaction.\n', '  /// @param value Ether value of module transaction.\n', '  /// @param data Data payload of module transaction.\n', '  /// @param operation Operation type of module transaction.\n', '  function execTransactionFromModule(\n', '    address to,\n', '    uint256 value,\n', '    bytes calldata data,\n', '    Enum.Operation operation\n', '  ) external returns (bool success);\n', '}\n', '\n', 'contract DaoModule {\n', '  bytes32 public constant INVALIDATED =\n', '    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '  bytes32 public constant DOMAIN_SEPARATOR_TYPEHASH =\n', '    0x47e79534a245952e8b16893a336b85a3d9ea9fa8c573f3d803afb92a79469218;\n', '  // keccak256(\n', '  //     "EIP712Domain(uint256 chainId,address verifyingContract)"\n', '  // );\n', '\n', '  bytes32 public constant TRANSACTION_TYPEHASH =\n', '    0x72e9670a7ee00f5fbf1049b8c38e3f22fab7e9b85029e85cf9412f17fdd5c2ad;\n', '  // keccak256(\n', '  //     "Transaction(address to,uint256 value,bytes data,uint8 operation,uint256 nonce)"\n', '  // );\n', '\n', '  event ProposalQuestionCreated(\n', '    bytes32 indexed questionId,\n', '    string indexed proposalId\n', '  );\n', '\n', '  Executor public immutable executor;\n', '  Realitio public immutable oracle;\n', '  uint256 public template;\n', '  uint32 public questionTimeout;\n', '  uint32 public questionCooldown;\n', '  uint32 public answerExpiration;\n', '  address public questionArbitrator;\n', '  uint256 public minimumBond;\n', '  // Mapping of question hash to question id. Special case: INVALIDATED for question hashes that have been invalidated\n', '  mapping(bytes32 => bytes32) public questionIds;\n', '  // Mapping of questionHash to transactionHash to execution state\n', '  mapping(bytes32 => mapping(bytes32 => bool))\n', '    public executedProposalTransactions;\n', '\n', '  /// @param _executor Address of the executor (e.g. a Safe)\n', '  /// @param _oracle Address of the oracle (e.g. Realitio)\n', '  /// @param timeout Timeout in seconds that should be required for the oracle\n', '  /// @param cooldown Cooldown in seconds that should be required after a oracle provided answer\n', '  /// @param expiration Duration that a positive answer of the oracle is valid in seconds (or 0 if valid forever)\n', '  /// @param bond Minimum bond that is required for an answer to be accepted\n', '  /// @param templateId ID of the template that should be used for proposal questions (see https://github.com/realitio/realitio-dapp#structuring-and-fetching-information)\n', '  /// @notice There need to be at least 60 seconds between end of cooldown and expiration\n', '  constructor(\n', '    Executor _executor,\n', '    Realitio _oracle,\n', '    uint32 timeout,\n', '    uint32 cooldown,\n', '    uint32 expiration,\n', '    uint256 bond,\n', '    uint256 templateId\n', '  ) {\n', '    require(timeout > 0, "Timeout has to be greater 0");\n', '    require(\n', '      expiration == 0 || expiration - cooldown >= 60,\n', '      "There need to be at least 60s between end of cooldown and expiration"\n', '    );\n', '    executor = _executor;\n', '    oracle = _oracle;\n', '    answerExpiration = expiration;\n', '    questionTimeout = timeout;\n', '    questionCooldown = cooldown;\n', '    questionArbitrator = address(_executor);\n', '    minimumBond = bond;\n', '    template = templateId;\n', '  }\n', '\n', '  modifier executorOnly() {\n', '    require(msg.sender == address(executor), "Not authorized");\n', '    _;\n', '  }\n', '\n', '  /// @notice This can only be called by the executor\n', '  function setQuestionTimeout(uint32 timeout) public executorOnly() {\n', '    require(timeout > 0, "Timeout has to be greater 0");\n', '    questionTimeout = timeout;\n', '  }\n', '\n', '  /// @dev Sets the cooldown before an answer is usable.\n', '  /// @param cooldown Cooldown in seconds that should be required after a oracle provided answer\n', '  /// @notice This can only be called by the executor\n', '  /// @notice There need to be at least 60 seconds between end of cooldown and expiration\n', '  function setQuestionCooldown(uint32 cooldown) public executorOnly() {\n', '    uint32 expiration = answerExpiration;\n', '    require(\n', '      expiration == 0 || expiration - cooldown >= 60,\n', '      "There need to be at least 60s between end of cooldown and expiration"\n', '    );\n', '    questionCooldown = cooldown;\n', '  }\n', '\n', '  /// @dev Sets the duration for which a positive answer is valid.\n', '  /// @param expiration Duration that a positive answer of the oracle is valid in seconds (or 0 if valid forever)\n', '  /// @notice A proposal with an expired answer is the same as a proposal that has been marked invalid\n', '  /// @notice There need to be at least 60 seconds between end of cooldown and expiration\n', '  /// @notice This can only be called by the executor\n', '  function setAnswerExpiration(uint32 expiration) public executorOnly() {\n', '    require(\n', '      expiration == 0 || expiration - questionCooldown >= 60,\n', '      "There need to be at least 60s between end of cooldown and expiration"\n', '    );\n', '    answerExpiration = expiration;\n', '  }\n', '\n', '  /// @dev Sets the question arbitrator that will be used for future questions.\n', '  /// @param arbitrator Address of the arbitrator\n', '  /// @notice This can only be called by the executor\n', '  function setArbitrator(address arbitrator) public executorOnly() {\n', '    questionArbitrator = arbitrator;\n', '  }\n', '\n', '  /// @dev Sets the minimum bond that is required for an answer to be accepted.\n', '  /// @param bond Minimum bond that is required for an answer to be accepted\n', '  /// @notice This can only be called by the executor\n', '  function setMinimumBond(uint256 bond) public executorOnly() {\n', '    minimumBond = bond;\n', '  }\n', '\n', '  /// @dev Sets the template that should be used for future questions.\n', '  /// @param templateId ID of the template that should be used for proposal questions\n', '  /// @notice Check https://github.com/realitio/realitio-dapp#structuring-and-fetching-information for more information\n', '  /// @notice This can only be called by the executor\n', '  function setTemplate(uint256 templateId) public executorOnly() {\n', '    template = templateId;\n', '  }\n', '\n', '  /// @dev Function to add a proposal that should be considered for execution\n', '  /// @param proposalId Id that should identify the proposal uniquely\n', '  /// @param txHashes EIP-712 hashes of the transactions that should be executed\n', '  /// @notice The nonce used for the question by this function is always 0\n', '  function addProposal(string memory proposalId, bytes32[] memory txHashes)\n', '    public\n', '  {\n', '    addProposalWithNonce(proposalId, txHashes, 0);\n', '  }\n', '\n', '  /// @dev Function to add a proposal that should be considered for execution\n', '  /// @param proposalId Id that should identify the proposal uniquely\n', '  /// @param txHashes EIP-712 hashes of the transactions that should be executed\n', '  /// @param nonce Nonce that should be used when asking the question on the oracle\n', '  function addProposalWithNonce(\n', '    string memory proposalId,\n', '    bytes32[] memory txHashes,\n', '    uint256 nonce\n', '  ) public {\n', '    // We load some storage variables into memory to save gas\n', '    uint256 templateId = template;\n', '    uint32 timeout = questionTimeout;\n', '    address arbitrator = questionArbitrator;\n', '    // We generate the question string used for the oracle\n', '    string memory question = buildQuestion(proposalId, txHashes);\n', '    bytes32 questionHash = keccak256(bytes(question));\n', '    if (nonce > 0) {\n', '      // Previous nonce must have been invalidated by the oracle.\n', '      // However, if the proposal was internally invalidated, it should not be possible to ask it again.\n', '      bytes32 currentQuestionId = questionIds[questionHash];\n', '      require(\n', '        currentQuestionId != INVALIDATED,\n', '        "This proposal has been marked as invalid"\n', '      );\n', '      require(\n', '        oracle.resultFor(currentQuestionId) == INVALIDATED,\n', '        "Previous proposal was not invalidated"\n', '      );\n', '    } else {\n', '      require(\n', '        questionIds[questionHash] == bytes32(0),\n', '        "Proposal has already been submitted"\n', '      );\n', '    }\n', '    bytes32 expectedQuestionId =\n', '      getQuestionId(templateId, question, arbitrator, timeout, 0, nonce);\n', '    // Set the question hash for this quesion id\n', '    questionIds[questionHash] = expectedQuestionId;\n', '    // Ask the question with a starting time of 0, so that it can be immediately answered\n', '    bytes32 questionId =\n', '      oracle.askQuestion(templateId, question, arbitrator, timeout, 0, nonce);\n', '    require(expectedQuestionId == questionId, "Unexpected question id");\n', '    emit ProposalQuestionCreated(questionId, proposalId);\n', '  }\n', '\n', '  /// @dev Marks a proposal as invalid, preventing execution of the connected transactions\n', '  /// @param proposalId Id that should identify the proposal uniquely\n', '  /// @param txHashes EIP-712 hashes of the transactions that should be executed\n', '  /// @notice This can only be called by the executor\n', '  function markProposalAsInvalid(\n', '    string memory proposalId,\n', '    bytes32[] memory txHashes\n', '  ) public // Executor only is checked in markProposalAsInvalidByHash(bytes32)\n', '  {\n', '    string memory question = buildQuestion(proposalId, txHashes);\n', '    bytes32 questionHash = keccak256(bytes(question));\n', '    markProposalAsInvalidByHash(questionHash);\n', '  }\n', '\n', '  /// @dev Marks a question hash as invalid, preventing execution of the connected transactions\n', '  /// @param questionHash Question hash calculated based on the proposal id and txHashes\n', '  /// @notice This can only be called by the executor\n', '  function markProposalAsInvalidByHash(bytes32 questionHash)\n', '    public\n', '    executorOnly()\n', '  {\n', '    questionIds[questionHash] = INVALIDATED;\n', '  }\n', '\n', '  /// @dev Marks a proposal with an expired answer as invalid, preventing execution of the connected transactions\n', '  /// @param questionHash Question hash calculated based on the proposal id and txHashes\n', '  function markProposalWithExpiredAnswerAsInvalid(bytes32 questionHash) public {\n', '    uint32 expirationDuration = answerExpiration;\n', '    require(expirationDuration > 0, "Answers are valid forever");\n', '    bytes32 questionId = questionIds[questionHash];\n', '    require(questionId != INVALIDATED, "Proposal is already invalidated");\n', '    require(\n', '      questionId != bytes32(0),\n', '      "No question id set for provided proposal"\n', '    );\n', '    require(\n', '      oracle.resultFor(questionId) == bytes32(uint256(1)),\n', '      "Only positive answers can expire"\n', '    );\n', '    uint32 finalizeTs = oracle.getFinalizeTS(questionId);\n', '    require(\n', '      finalizeTs + uint256(expirationDuration) < block.timestamp,\n', '      "Answer has not expired yet"\n', '    );\n', '    questionIds[questionHash] = INVALIDATED;\n', '  }\n', '\n', '  /// @dev Executes the transactions of a proposal via the executor if accepted\n', '  /// @param proposalId Id that should identify the proposal uniquely\n', '  /// @param txHashes EIP-712 hashes of the transactions that should be executed\n', '  /// @param to Target of the transaction that should be executed\n', '  /// @param value Wei value of the transaction that should be executed\n', '  /// @param data Data of the transaction that should be executed\n', '  /// @param operation Operation (Call or Delegatecall) of the transaction that should be executed\n', '  /// @notice The txIndex used by this function is always 0\n', '  function executeProposal(\n', '    string memory proposalId,\n', '    bytes32[] memory txHashes,\n', '    address to,\n', '    uint256 value,\n', '    bytes memory data,\n', '    Enum.Operation operation\n', '  ) public {\n', '    executeProposalWithIndex(\n', '      proposalId,\n', '      txHashes,\n', '      to,\n', '      value,\n', '      data,\n', '      operation,\n', '      0\n', '    );\n', '  }\n', '\n', '  /// @dev Executes the transactions of a proposal via the executor if accepted\n', '  /// @param proposalId Id that should identify the proposal uniquely\n', '  /// @param txHashes EIP-712 hashes of the transactions that should be executed\n', '  /// @param to Target of the transaction that should be executed\n', '  /// @param value Wei value of the transaction that should be executed\n', '  /// @param data Data of the transaction that should be executed\n', '  /// @param operation Operation (Call or Delegatecall) of the transaction that should be executed\n', '  /// @param txIndex Index of the transaction hash in txHashes. This is used as the nonce for the transaction, to make the tx hash unique\n', '  function executeProposalWithIndex(\n', '    string memory proposalId,\n', '    bytes32[] memory txHashes,\n', '    address to,\n', '    uint256 value,\n', '    bytes memory data,\n', '    Enum.Operation operation,\n', '    uint256 txIndex\n', '  ) public {\n', '    // We use the hash of the question to check the execution state, as the other parameters might change, but the question not\n', '    bytes32 questionHash =\n', '      keccak256(bytes(buildQuestion(proposalId, txHashes)));\n', '    // Lookup question id for this proposal\n', '    bytes32 questionId = questionIds[questionHash];\n', '    // Question hash needs to set to be eligible for execution\n', '    require(\n', '      questionId != bytes32(0),\n', '      "No question id set for provided proposal"\n', '    );\n', '    require(questionId != INVALIDATED, "Proposal has been invalidated");\n', '\n', '    bytes32 txHash = getTransactionHash(to, value, data, operation, txIndex);\n', '    require(txHashes[txIndex] == txHash, "Unexpected transaction hash");\n', '\n', '    // Check that the result of the question is 1 (true)\n', '    require(\n', '      oracle.resultFor(questionId) == bytes32(uint256(1)),\n', '      "Transaction was not approved"\n', '    );\n', '    uint256 minBond = minimumBond;\n', '    require(\n', '      minBond == 0 || minBond <= oracle.getBond(questionId),\n', '      "Bond on question not high enough"\n', '    );\n', '    uint32 finalizeTs = oracle.getFinalizeTS(questionId);\n', '    // The answer is valid in the time after the cooldown and before the expiration time (if set).\n', '    require(\n', '      finalizeTs + uint256(questionCooldown) < block.timestamp,\n', '      "Wait for additional cooldown"\n', '    );\n', '    uint32 expiration = answerExpiration;\n', '    require(\n', '      expiration == 0 || finalizeTs + uint256(expiration) >= block.timestamp,\n', '      "Answer has expired"\n', '    );\n', '    // Check this is either the first transaction in the list or that the previous question was already approved\n', '    require(\n', '      txIndex == 0 ||\n', '        executedProposalTransactions[questionHash][txHashes[txIndex - 1]],\n', '      "Previous transaction not executed yet"\n', '    );\n', '    // Check that this question was not executed yet\n', '    require(\n', '      !executedProposalTransactions[questionHash][txHash],\n', '      "Cannot execute transaction again"\n', '    );\n', '    // Mark transaction as executed\n', '    executedProposalTransactions[questionHash][txHash] = true;\n', '    // Execute the transaction via the executor.\n', '    require(\n', '      executor.execTransactionFromModule(to, value, data, operation),\n', '      "Module transaction failed"\n', '    );\n', '  }\n', '\n', '  /// @dev Build the question by combining the proposalId and the hex string of the hash of the txHashes\n', '  /// @param proposalId Id of the proposal that proposes to execute the transactions represented by the txHashes\n', '  /// @param txHashes EIP-712 Hashes of the transactions that should be executed\n', '  function buildQuestion(string memory proposalId, bytes32[] memory txHashes)\n', '    public\n', '    pure\n', '    returns (string memory)\n', '  {\n', '    string memory txsHash =\n', '      bytes32ToAsciiString(keccak256(abi.encodePacked(txHashes)));\n', '    return string(abi.encodePacked(proposalId, bytes3(0xe2909f), txsHash));\n', '  }\n', '\n', '  /// @dev Generate the question id.\n', '  /// @notice It is required that this is the same as for the oracle implementation used.\n', '  function getQuestionId(\n', '    uint256 templateId,\n', '    string memory question,\n', '    address arbitrator,\n', '    uint32 timeout,\n', '    uint32 openingTs,\n', '    uint256 nonce\n', '  ) public view returns (bytes32) {\n', '    bytes32 contentHash =\n', '      keccak256(abi.encodePacked(templateId, openingTs, question));\n', '    return\n', '      keccak256(\n', '        abi.encodePacked(contentHash, arbitrator, timeout, this, nonce)\n', '      );\n', '  }\n', '\n', '  /// @dev Returns the chain id used by this contract.\n', '  function getChainId() public view returns (uint256) {\n', '    uint256 id;\n', '    // solium-disable-next-line security/no-inline-assembly\n', '    assembly {\n', '      id := chainid()\n', '    }\n', '    return id;\n', '  }\n', '\n', '  /// @dev Generates the data for the module transaction hash (required for signing)\n', '  function generateTransactionHashData(\n', '    address to,\n', '    uint256 value,\n', '    bytes memory data,\n', '    Enum.Operation operation,\n', '    uint256 nonce\n', '  ) public view returns (bytes memory) {\n', '    uint256 chainId = getChainId();\n', '    bytes32 domainSeparator =\n', '      keccak256(abi.encode(DOMAIN_SEPARATOR_TYPEHASH, chainId, this));\n', '    bytes32 transactionHash =\n', '      keccak256(\n', '        abi.encode(\n', '          TRANSACTION_TYPEHASH,\n', '          to,\n', '          value,\n', '          keccak256(data),\n', '          operation,\n', '          nonce\n', '        )\n', '      );\n', '    return\n', '      abi.encodePacked(\n', '        bytes1(0x19),\n', '        bytes1(0x01),\n', '        domainSeparator,\n', '        transactionHash\n', '      );\n', '  }\n', '\n', '  function getTransactionHash(\n', '    address to,\n', '    uint256 value,\n', '    bytes memory data,\n', '    Enum.Operation operation,\n', '    uint256 nonce\n', '  ) public view returns (bytes32) {\n', '    return\n', '      keccak256(generateTransactionHashData(to, value, data, operation, nonce));\n', '  }\n', '\n', '  function bytes32ToAsciiString(bytes32 _bytes)\n', '    internal\n', '    pure\n', '    returns (string memory)\n', '  {\n', '    bytes memory s = new bytes(64);\n', '    for (uint256 i = 0; i < 32; i++) {\n', '      uint8 b = uint8(bytes1(_bytes << (i * 8)));\n', '      uint8 hi = uint8(b) / 16;\n', '      uint8 lo = uint8(b) % 16;\n', '      s[2 * i] = char(hi);\n', '      s[2 * i + 1] = char(lo);\n', '    }\n', '    return string(s);\n', '  }\n', '\n', '  function char(uint8 b) internal pure returns (bytes1 c) {\n', '    if (b < 10) return bytes1(b + 0x30);\n', '    else return bytes1(b + 0x57);\n', '  }\n', '}']
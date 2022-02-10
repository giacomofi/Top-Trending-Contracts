['pragma solidity ^0.7.0;\n', '\n', '// SPDX-License-Identifier: MIT OR Apache-2.0\n', '\n', '\n', '\n', 'import "./Config.sol";\n', '\n', '/// @title Governance Contract\n', '/// @author Matter Labs\n', 'contract Governance is Config {\n', '    /// @notice Token added to Franklin net\n', '    event NewToken(address indexed token, uint16 indexed tokenId);\n', '\n', '    /// @notice Governor changed\n', '    event NewGovernor(address newGovernor);\n', '\n', '    /// @notice Token Governance changed\n', '    event NewTokenGovernance(address newTokenGovernance);\n', '\n', "    /// @notice Validator's status changed\n", '    event ValidatorStatusUpdate(address indexed validatorAddress, bool isActive);\n', '\n', '    event TokenPausedUpdate(address indexed token, bool paused);\n', '\n', '    /// @notice Address which will exercise governance over the network i.e. add tokens, change validator set, conduct upgrades\n', '    address public networkGovernor;\n', '\n', '    /// @notice Total number of ERC20 tokens registered in the network (excluding ETH, which is hardcoded as tokenId = 0)\n', '    uint16 public totalTokens;\n', '\n', '    /// @notice List of registered tokens by tokenId\n', '    mapping(uint16 => address) public tokenAddresses;\n', '\n', '    /// @notice List of registered tokens by address\n', '    mapping(address => uint16) public tokenIds;\n', '\n', '    /// @notice List of permitted validators\n', '    mapping(address => bool) public validators;\n', '\n', '    /// @notice Paused tokens list, deposits are impossible to create for paused tokens\n', '    mapping(uint16 => bool) public pausedTokens;\n', '\n', '    /// @notice Address that is authorized to add tokens to the Governance.\n', '    address public tokenGovernance;\n', '\n', '    /// @notice Governance contract initialization. Can be external because Proxy contract intercepts illegal calls of this function.\n', '    /// @param initializationParameters Encoded representation of initialization parameters:\n', '    ///     _networkGovernor The address of network governor\n', '    function initialize(bytes calldata initializationParameters) external {\n', '        address _networkGovernor = abi.decode(initializationParameters, (address));\n', '\n', '        networkGovernor = _networkGovernor;\n', '    }\n', '\n', '    /// @notice Governance contract upgrade. Can be external because Proxy contract intercepts illegal calls of this function.\n', '    /// @param upgradeParameters Encoded representation of upgrade parameters\n', '    // solhint-disable-next-line no-empty-blocks\n', '    function upgrade(bytes calldata upgradeParameters) external {}\n', '\n', '    /// @notice Change current governor\n', '    /// @param _newGovernor Address of the new governor\n', '    function changeGovernor(address _newGovernor) external {\n', '        requireGovernor(msg.sender);\n', '        if (networkGovernor != _newGovernor) {\n', '            networkGovernor = _newGovernor;\n', '            emit NewGovernor(_newGovernor);\n', '        }\n', '    }\n', '\n', '    /// @notice Change current token governance\n', '    /// @param _newTokenGovernance Address of the new token governor\n', '    function changeTokenGovernance(address _newTokenGovernance) external {\n', '        requireGovernor(msg.sender);\n', '        if (tokenGovernance != _newTokenGovernance) {\n', '            tokenGovernance = _newTokenGovernance;\n', '            emit NewTokenGovernance(_newTokenGovernance);\n', '        }\n', '    }\n', '\n', '    /// @notice Add token to the list of networks tokens\n', '    /// @param _token Token address\n', '    function addToken(address _token) external {\n', '        require(msg.sender == tokenGovernance, "1E");\n', '        require(tokenIds[_token] == 0, "1e"); // token exists\n', '        require(totalTokens < MAX_AMOUNT_OF_REGISTERED_TOKENS, "1f"); // no free identifiers for tokens\n', '\n', '        totalTokens++;\n', '        uint16 newTokenId = totalTokens; // it is not `totalTokens - 1` because tokenId = 0 is reserved for eth\n', '\n', '        tokenAddresses[newTokenId] = _token;\n', '        tokenIds[_token] = newTokenId;\n', '        emit NewToken(_token, newTokenId);\n', '    }\n', '\n', '    /// @notice Pause token deposits for the given token\n', '    /// @param _tokenAddr Token address\n', '    /// @param _tokenPaused Token paused status\n', '    function setTokenPaused(address _tokenAddr, bool _tokenPaused) external {\n', '        requireGovernor(msg.sender);\n', '\n', '        uint16 tokenId = this.validateTokenAddress(_tokenAddr);\n', '        if (pausedTokens[tokenId] != _tokenPaused) {\n', '            pausedTokens[tokenId] = _tokenPaused;\n', '            emit TokenPausedUpdate(_tokenAddr, _tokenPaused);\n', '        }\n', '    }\n', '\n', '    /// @notice Change validator status (active or not active)\n', '    /// @param _validator Validator address\n', '    /// @param _active Active flag\n', '    function setValidator(address _validator, bool _active) external {\n', '        requireGovernor(msg.sender);\n', '        if (validators[_validator] != _active) {\n', '            validators[_validator] = _active;\n', '            emit ValidatorStatusUpdate(_validator, _active);\n', '        }\n', '    }\n', '\n', '    /// @notice Check if specified address is is governor\n', '    /// @param _address Address to check\n', '    function requireGovernor(address _address) public view {\n', '        require(_address == networkGovernor, "1g"); // only by governor\n', '    }\n', '\n', '    /// @notice Checks if validator is active\n', '    /// @param _address Validator address\n', '    function requireActiveValidator(address _address) external view {\n', '        require(validators[_address], "1h"); // validator is not active\n', '    }\n', '\n', '    /// @notice Validate token id (must be less than or equal to total tokens amount)\n', '    /// @param _tokenId Token id\n', '    /// @return bool flag that indicates if token id is less than or equal to total tokens amount\n', '    function isValidTokenId(uint16 _tokenId) external view returns (bool) {\n', '        return _tokenId <= totalTokens;\n', '    }\n', '\n', '    /// @notice Validate token address\n', '    /// @param _tokenAddr Token address\n', '    /// @return tokens id\n', '    function validateTokenAddress(address _tokenAddr) external view returns (uint16) {\n', '        uint16 tokenId = tokenIds[_tokenAddr];\n', '        require(tokenId != 0, "1i"); // 0 is not a valid token\n', '        return tokenId;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '// SPDX-License-Identifier: MIT OR Apache-2.0\n', '\n', '\n', '\n', '/// @title zkSync configuration constants\n', '/// @author Matter Labs\n', 'contract Config {\n', '    /// @dev ERC20 tokens and ETH withdrawals gas limit, used only for complete withdrawals\n', '    uint256 internal constant WITHDRAWAL_GAS_LIMIT = 100000;\n', '\n', '    /// @dev Bytes in one chunk\n', '    uint8 internal constant CHUNK_BYTES = 9;\n', '\n', '    /// @dev zkSync address length\n', '    uint8 internal constant ADDRESS_BYTES = 20;\n', '\n', '    uint8 internal constant PUBKEY_HASH_BYTES = 20;\n', '\n', '    /// @dev Public key bytes length\n', '    uint8 internal constant PUBKEY_BYTES = 32;\n', '\n', '    /// @dev Ethereum signature r/s bytes length\n', '    uint8 internal constant ETH_SIGN_RS_BYTES = 32;\n', '\n', '    /// @dev Success flag bytes length\n', '    uint8 internal constant SUCCESS_FLAG_BYTES = 1;\n', '\n', '    /// @dev Max amount of tokens registered in the network (excluding ETH, which is hardcoded as tokenId = 0)\n', '    uint16 internal constant MAX_AMOUNT_OF_REGISTERED_TOKENS = 511;\n', '\n', '    /// @dev Max account id that could be registered in the network\n', '    uint32 internal constant MAX_ACCOUNT_ID = (2**24) - 1;\n', '\n', '    /// @dev Expected average period of block creation\n', '    uint256 internal constant BLOCK_PERIOD = 15 seconds;\n', '\n', '    /// @dev ETH blocks verification expectation\n', '    /// @dev Blocks can be reverted if they are not verified for at least EXPECT_VERIFICATION_IN.\n', '    /// @dev If set to 0 validator can revert blocks at any time.\n', '    uint256 internal constant EXPECT_VERIFICATION_IN = 0 hours / BLOCK_PERIOD;\n', '\n', '    uint256 internal constant NOOP_BYTES = 1 * CHUNK_BYTES;\n', '    uint256 internal constant DEPOSIT_BYTES = 6 * CHUNK_BYTES;\n', '    uint256 internal constant TRANSFER_TO_NEW_BYTES = 6 * CHUNK_BYTES;\n', '    uint256 internal constant PARTIAL_EXIT_BYTES = 6 * CHUNK_BYTES;\n', '    uint256 internal constant TRANSFER_BYTES = 2 * CHUNK_BYTES;\n', '    uint256 internal constant FORCED_EXIT_BYTES = 6 * CHUNK_BYTES;\n', '\n', '    /// @dev Full exit operation length\n', '    uint256 internal constant FULL_EXIT_BYTES = 6 * CHUNK_BYTES;\n', '\n', '    /// @dev ChangePubKey operation length\n', '    uint256 internal constant CHANGE_PUBKEY_BYTES = 6 * CHUNK_BYTES;\n', '\n', '    /// @dev Expiration delta for priority request to be satisfied (in seconds)\n', '    /// @dev NOTE: Priority expiration should be > (EXPECT_VERIFICATION_IN * BLOCK_PERIOD)\n', '    /// @dev otherwise incorrect block with priority op could not be reverted.\n', '    uint256 internal constant PRIORITY_EXPIRATION_PERIOD = 3 days;\n', '\n', '    /// @dev Expiration delta for priority request to be satisfied (in ETH blocks)\n', '    uint256 internal constant PRIORITY_EXPIRATION =\n', '        PRIORITY_EXPIRATION_PERIOD/BLOCK_PERIOD;\n', '\n', '    /// @dev Maximum number of priority request to clear during verifying the block\n', "    /// @dev Cause deleting storage slots cost 5k gas per each slot it's unprofitable to clear too many slots\n", '    /// @dev Value based on the assumption of ~750k gas cost of verifying and 5 used storage slots per PriorityOperation structure\n', '    uint64 internal constant MAX_PRIORITY_REQUESTS_TO_DELETE_IN_VERIFY = 6;\n', '\n', '    /// @dev Reserved time for users to send full exit priority operation in case of an upgrade (in seconds)\n', '    uint256 internal constant MASS_FULL_EXIT_PERIOD = 9 days;\n', '\n', '    /// @dev Reserved time for users to withdraw funds from full exit priority operation in case of an upgrade (in seconds)\n', '    uint256 internal constant TIME_TO_WITHDRAW_FUNDS_FROM_FULL_EXIT = 2 days;\n', '\n', '    /// @dev Notice period before activation preparation status of upgrade mode (in seconds)\n', '    /// @dev NOTE: we must reserve for users enough time to send full exit operation, wait maximum time for processing this operation and withdraw funds from it.\n', '    uint256 internal constant UPGRADE_NOTICE_PERIOD =\n', '        MASS_FULL_EXIT_PERIOD+PRIORITY_EXPIRATION_PERIOD+TIME_TO_WITHDRAW_FUNDS_FROM_FULL_EXIT;\n', '\n', '    /// @dev Timestamp - seconds since unix epoch\n', '    uint256 internal constant COMMIT_TIMESTAMP_NOT_OLDER = 24 hours;\n', '\n', '    /// @dev Maximum available error between real commit block timestamp and analog used in the verifier (in seconds)\n', "    /// @dev Must be used cause miner's `block.timestamp` value can differ on some small value (as we know - 15 seconds)\n", '    uint256 internal constant COMMIT_TIMESTAMP_APPROXIMATION_DELTA = 15 minutes;\n', '\n', '    /// @dev Bit mask to apply for verifier public input before verifying.\n', '    uint256 internal constant INPUT_MASK = 14474011154664524427946373126085988481658748083205070504932198000989141204991;\n', '\n', '    /// @dev Auth fact reset timelock\n', '    uint256 internal constant AUTH_FACT_RESET_TIMELOCK = 1 days;\n', '\n', '    /// @dev Max deposit of ERC20 token that is possible to deposit\n', '    uint128 internal constant MAX_DEPOSIT_AMOUNT = 20282409603651670423947251286015;\n', '}']
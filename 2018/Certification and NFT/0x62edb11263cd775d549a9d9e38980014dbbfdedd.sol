['pragma solidity ^0.4.17;\n', '\n', '/**\n', '   @title SafeMath\n', '   @notice Implements SafeMath\n', '*/\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '    }\n', '\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '\n', '        assert(c >= a);\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Hasher {\n', '\n', '    /*\n', '     *  Public pure functions\n', '     */\n', '    function hashUuid(\n', '        string _symbol,\n', '        string _name,\n', '        uint256 _chainIdValue,\n', '        uint256 _chainIdUtility,\n', '        address _openSTUtility,\n', '        uint256 _conversionRate,\n', '        uint8 _conversionRateDecimals)\n', '        public\n', '        pure\n', '        returns (bytes32)\n', '    {\n', '        return keccak256(\n', '            _symbol,\n', '            _name,\n', '            _chainIdValue,\n', '            _chainIdUtility,\n', '            _openSTUtility,\n', '            _conversionRate,\n', '            _conversionRateDecimals);\n', '    }\n', '\n', '    function hashStakingIntent(\n', '        bytes32 _uuid,\n', '        address _account,\n', '        uint256 _accountNonce,\n', '        address _beneficiary,\n', '        uint256 _amountST,\n', '        uint256 _amountUT,\n', '        uint256 _escrowUnlockHeight)\n', '        public\n', '        pure\n', '        returns (bytes32)\n', '    {\n', '        return keccak256(\n', '            _uuid,\n', '            _account,\n', '            _accountNonce,\n', '            _beneficiary,\n', '            _amountST,\n', '            _amountUT,\n', '            _escrowUnlockHeight);\n', '    }\n', '\n', '    function hashRedemptionIntent(\n', '        bytes32 _uuid,\n', '        address _account,\n', '        uint256 _accountNonce,\n', '        address _beneficiary,\n', '        uint256 _amountUT,\n', '        uint256 _escrowUnlockHeight)\n', '        public\n', '        pure\n', '        returns (bytes32)\n', '    {\n', '        return keccak256(\n', '            _uuid,\n', '            _account,\n', '            _accountNonce,\n', '            _beneficiary,\n', '            _amountUT,\n', '            _escrowUnlockHeight);\n', '    }\n', '}\n', '\n', '/**\n', '   @title Owned\n', '   @notice Implements basic ownership with 2-step transfers\n', '*/\n', 'contract Owned {\n', '\n', '    address public owner;\n', '    address public proposedOwner;\n', '\n', '    event OwnershipTransferInitiated(address indexed _proposedOwner);\n', '    event OwnershipTransferCompleted(address indexed _newOwner);\n', '\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner(msg.sender));\n', '        _;\n', '    }\n', '\n', '\n', '    function isOwner(address _address) internal view returns (bool) {\n', '        return (_address == owner);\n', '    }\n', '\n', '\n', '    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {\n', '        proposedOwner = _proposedOwner;\n', '\n', '        OwnershipTransferInitiated(_proposedOwner);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function completeOwnershipTransfer() public returns (bool) {\n', '        require(msg.sender == proposedOwner);\n', '\n', '        owner = proposedOwner;\n', '        proposedOwner = address(0);\n', '\n', '        OwnershipTransferCompleted(owner);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', '   @title OpsManaged\n', '   @notice Implements OpenST ownership and permission model\n', '*/\n', 'contract OpsManaged is Owned {\n', '\n', '    address public opsAddress;\n', '    address public adminAddress;\n', '\n', '    event AdminAddressChanged(address indexed _newAddress);\n', '    event OpsAddressChanged(address indexed _newAddress);\n', '\n', '\n', '    function OpsManaged() public\n', '        Owned()\n', '    {\n', '    }\n', '\n', '\n', '    modifier onlyAdmin() {\n', '        require(isAdmin(msg.sender));\n', '        _;\n', '    }\n', '\n', '\n', '    modifier onlyAdminOrOps() {\n', '        require(isAdmin(msg.sender) || isOps(msg.sender));\n', '        _;\n', '    }\n', '\n', '\n', '    modifier onlyOwnerOrAdmin() {\n', '        require(isOwner(msg.sender) || isAdmin(msg.sender));\n', '        _;\n', '    }\n', '\n', '\n', '    modifier onlyOps() {\n', '        require(isOps(msg.sender));\n', '        _;\n', '    }\n', '\n', '\n', '    function isAdmin(address _address) internal view returns (bool) {\n', '        return (adminAddress != address(0) && _address == adminAddress);\n', '    }\n', '\n', '\n', '    function isOps(address _address) internal view returns (bool) {\n', '        return (opsAddress != address(0) && _address == opsAddress);\n', '    }\n', '\n', '\n', '    function isOwnerOrOps(address _address) internal view returns (bool) {\n', '        return (isOwner(_address) || isOps(_address));\n', '    }\n', '\n', '\n', "    // Owner and Admin can change the admin address. Address can also be set to 0 to 'disable' it.\n", '    function setAdminAddress(address _adminAddress) external onlyOwnerOrAdmin returns (bool) {\n', '        require(_adminAddress != owner);\n', '        require(_adminAddress != address(this));\n', '        require(!isOps(_adminAddress));\n', '\n', '        adminAddress = _adminAddress;\n', '\n', '        AdminAddressChanged(_adminAddress);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', "    // Owner and Admin can change the operations address. Address can also be set to 0 to 'disable' it.\n", '    function setOpsAddress(address _opsAddress) external onlyOwnerOrAdmin returns (bool) {\n', '        require(_opsAddress != owner);\n', '        require(_opsAddress != address(this));\n', '        require(!isAdmin(_opsAddress));\n', '\n', '        opsAddress = _opsAddress;\n', '\n', '        OpsAddressChanged(_opsAddress);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', '   @title EIP20Interface\n', '   @notice Provides EIP20 token interface\n', '*/\n', 'contract EIP20Interface {\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function name() public view returns (string);\n', '    function symbol() public view returns (string);\n', '    function decimals() public view returns (uint8);\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract CoreInterface {\n', '    \n', '    function registrar() public view returns (address /* registrar */);\n', '\n', '    function chainIdRemote() public view returns (uint256 /* chainIdRemote */);\n', '    function openSTRemote() public view returns (address /* OpenSTRemote */);\n', '}\n', '\n', 'contract ProtocolVersioned {\n', '\n', '    /*\n', '     *  Events\n', '     */\n', '    event ProtocolTransferInitiated(address indexed _existingProtocol, address indexed _proposedProtocol, uint256 _activationHeight);\n', '    event ProtocolTransferRevoked(address indexed _existingProtocol, address indexed _revokedProtocol);\n', '    event ProtocolTransferCompleted(address indexed _newProtocol);\n', '\n', '    /*\n', '     *  Constants\n', '     */\n', '    /// Blocks to wait before the protocol transfer can be completed\n', '    /// This allows anyone with a stake to unstake under the existing\n', '    /// protocol if they disagree with the new proposed protocol\n', '    /// @dev from OpenST ^v1.0 this constant will be set to a significant value\n', '    /// ~ 1 week at 15 seconds per block\n', '    uint256 constant private PROTOCOL_TRANSFER_BLOCKS_TO_WAIT = 40320;\n', '    \n', '    /*\n', '     *  Storage\n', '     */\n', '    /// OpenST protocol contract\n', '    address public openSTProtocol;\n', '    /// proposed OpenST protocol\n', '    address public proposedProtocol;\n', '    /// earliest protocol transfer height\n', '    uint256 public earliestTransferHeight;\n', '\n', '    /*\n', '     * Modifiers\n', '     */\n', '    modifier onlyProtocol() {\n', '        require(msg.sender == openSTProtocol);\n', '        _;\n', '    }\n', '\n', '    modifier onlyProposedProtocol() {\n', '        require(msg.sender == proposedProtocol);\n', '        _;\n', '    }\n', '\n', '    modifier afterWait() {\n', '        require(earliestTransferHeight <= block.number);\n', '        _;\n', '    }\n', '\n', '    modifier notNull(address _address) {\n', '        require(_address != 0);\n', '        _;\n', '    }\n', '    \n', '    // TODO: [ben] add hasCode modifier so that for \n', '    //       a significant wait time the code at the proposed new\n', '    //       protocol can be reviewed\n', '\n', '    /*\n', '     *  Public functions\n', '     */\n', '    /// @dev Constructor set the OpenST Protocol\n', '    function ProtocolVersioned(address _protocol) \n', '        public\n', '        notNull(_protocol)\n', '    {\n', '        openSTProtocol = _protocol;\n', '    }\n', '\n', '    /// @dev initiate protocol transfer\n', '    function initiateProtocolTransfer(\n', '        address _proposedProtocol)\n', '        public \n', '        onlyProtocol\n', '        notNull(_proposedProtocol)\n', '        returns (bool)\n', '    {\n', '        require(_proposedProtocol != openSTProtocol);\n', '        require(proposedProtocol == address(0));\n', '\n', '        earliestTransferHeight = block.number + blocksToWaitForProtocolTransfer();\n', '        proposedProtocol = _proposedProtocol;\n', '\n', '        ProtocolTransferInitiated(openSTProtocol, _proposedProtocol, earliestTransferHeight);\n', '\n', '        return true;\n', '    }\n', '\n', '    /// @dev only after the waiting period, can\n', '    ///      proposed protocol complete the transfer\n', '    function completeProtocolTransfer()\n', '        public\n', '        onlyProposedProtocol\n', '        afterWait\n', '        returns (bool) \n', '    {\n', '        openSTProtocol = proposedProtocol;\n', '        proposedProtocol = address(0);\n', '        earliestTransferHeight = 0;\n', '\n', '        ProtocolTransferCompleted(openSTProtocol);\n', '\n', '        return true;\n', '    }\n', '\n', '    /// @dev protocol can revoke initiated protocol\n', '    ///      transfer\n', '    function revokeProtocolTransfer()\n', '        public\n', '        onlyProtocol\n', '        returns (bool)\n', '    {\n', '        require(proposedProtocol != address(0));\n', '\n', '        address revokedProtocol = proposedProtocol;\n', '        proposedProtocol = address(0);\n', '        earliestTransferHeight = 0;\n', '\n', '        ProtocolTransferRevoked(openSTProtocol, revokedProtocol);\n', '\n', '        return true;\n', '    }\n', '\n', '    function blocksToWaitForProtocolTransfer() public pure returns (uint256) {\n', '        return PROTOCOL_TRANSFER_BLOCKS_TO_WAIT;\n', '    }\n', '}\n', '\n', '/// @title SimpleStake - stakes the value of an EIP20 token on Ethereum\n', '///        for a utility token on the OpenST platform\n', '/// @author OpenST Ltd.\n', 'contract SimpleStake is ProtocolVersioned {\n', '    using SafeMath for uint256;\n', '\n', '    /*\n', '     *  Events\n', '     */\n', '    event ReleasedStake(address indexed _protocol, address indexed _to, uint256 _amount);\n', '\n', '    /*\n', '     *  Storage\n', '     */\n', '    /// EIP20 token contract that can be staked\n', '    EIP20Interface public eip20Token;\n', '    /// UUID for the utility token\n', '    bytes32 public uuid;\n', '\n', '    /*\n', '     *  Public functions\n', '     */\n', '    /// @dev Contract constructor sets the protocol and the EIP20 token to stake\n', '    /// @param _eip20Token EIP20 token that will be staked\n', '    /// @param _openSTProtocol OpenSTProtocol contract that governs staking\n', '    /// @param _uuid Unique Universal Identifier of the registered utility token\n', '    function SimpleStake(\n', '        EIP20Interface _eip20Token,\n', '        address _openSTProtocol,\n', '        bytes32 _uuid)\n', '        ProtocolVersioned(_openSTProtocol)\n', '        public\n', '    {\n', '        eip20Token = _eip20Token;\n', '        uuid = _uuid;\n', '    }\n', '\n', '    /// @dev Allows the protocol to release the staked amount\n', '    ///      into provided address.\n', '    ///      The protocol MUST be a contract that sets the rules\n', '    ///      on how the stake can be released and to who.\n', '    ///      The protocol takes the role of an "owner" of the stake.\n', '    /// @param _to Beneficiary of the amount of the stake\n', '    /// @param _amount Amount of stake to release to beneficiary\n', '    function releaseTo(address _to, uint256 _amount) \n', '        public \n', '        onlyProtocol\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0));\n', '        require(eip20Token.transfer(_to, _amount));\n', '        \n', '        ReleasedStake(msg.sender, _to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Web3 call functions\n', '     */\n', '    /// @dev total stake is the balance of the staking contract\n', '    ///      accidental transfers directly to SimpleStake bypassing\n', '    ///      the OpenST protocol will not mint new utility tokens,\n', '    ///      but will add to the total stake.\n', '    ///      (accidental) donations can not be prevented\n', '    function getTotalStake()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return eip20Token.balanceOf(this);\n', '    }\n', '}\n', '\n', '/// @title AM1OpenSTValue - value staking contract for OpenST\n', 'contract AM1OpenSTValue is OpsManaged, Hasher {\n', '    using SafeMath for uint256;\n', '    \n', '    /*\n', '     *  Events\n', '     */\n', '    event UtilityTokenRegistered(bytes32 indexed _uuid, address indexed stake,\n', '        string _symbol, string _name, uint8 _decimals, uint256 _conversionRate, uint8 _conversionRateDecimals,\n', '        uint256 _chainIdUtility, address indexed _stakingAccount);\n', '\n', '    event StakingIntentDeclared(bytes32 indexed _uuid, address indexed _staker,\n', '        uint256 _stakerNonce, address _beneficiary, uint256 _amountST,\n', '        uint256 _amountUT, uint256 _unlockHeight, bytes32 _stakingIntentHash,\n', '        uint256 _chainIdUtility);\n', '\n', '    event ProcessedStake(bytes32 indexed _uuid, bytes32 indexed _stakingIntentHash,\n', '        address _stake, address _staker, uint256 _amountST, uint256 _amountUT);\n', '\n', '    event RevertedStake(bytes32 indexed _uuid, bytes32 indexed _stakingIntentHash,\n', '        address _staker, uint256 _amountST, uint256 _amountUT);\n', '\n', '    event RedemptionIntentConfirmed(bytes32 indexed _uuid, bytes32 _redemptionIntentHash,\n', '        address _redeemer, address _beneficiary, uint256 _amountST, uint256 _amountUT, uint256 _expirationHeight);\n', '\n', '    event ProcessedUnstake(bytes32 indexed _uuid, bytes32 indexed _redemptionIntentHash,\n', '        address stake, address _redeemer, address _beneficiary, uint256 _amountST);\n', '\n', '    event RevertedUnstake(bytes32 indexed _uuid, bytes32 indexed _redemptionIntentHash,\n', '        address _redeemer, address _beneficiary, uint256 _amountST);\n', '\n', '    /*\n', '     *  Constants\n', '     */\n', '    uint8 public constant TOKEN_DECIMALS = 18;\n', '    uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);\n', '    // ~3 weeks, assuming ~15s per block\n', '    uint256 private constant BLOCKS_TO_WAIT_LONG = 120960;\n', '    // ~3 days, assuming ~15s per block\n', '    uint256 private constant BLOCKS_TO_WAIT_SHORT = 17280;\n', '\n', '    /*\n', '     *  Structures\n', '     */\n', '    struct UtilityToken {\n', '        string  symbol;\n', '        string  name;\n', '        uint256 conversionRate;\n', '        uint8 conversionRateDecimals;\n', '        uint8   decimals;\n', '        uint256 chainIdUtility;\n', '        SimpleStake simpleStake;\n', '        address stakingAccount;\n', '    }\n', '\n', '    struct Stake {\n', '        bytes32 uuid;\n', '        address staker;\n', '        address beneficiary;\n', '        uint256 nonce;\n', '        uint256 amountST;\n', '        uint256 amountUT;\n', '        uint256 unlockHeight;\n', '    }\n', '\n', '    struct Unstake {\n', '        bytes32 uuid;\n', '        address redeemer;\n', '        address beneficiary;\n', '        uint256 amountST;\n', '        // @dev consider removal of amountUT\n', '        uint256 amountUT;\n', '        uint256 expirationHeight;\n', '    }\n', '\n', '    /*\n', '     *  Storage\n', '     */\n', '    uint256 public chainIdValue;\n', '    EIP20Interface public valueToken;\n', '    address public registrar;\n', '    bytes32[] public uuids;\n', '    bool public deactivated;\n', '    mapping(uint256 /* chainIdUtility */ => CoreInterface) internal cores;\n', '    mapping(bytes32 /* uuid */ => UtilityToken) public utilityTokens;\n', '    /// nonce makes the staking process atomic across the two-phased process\n', '    /// and protects against replay attack on (un)staking proofs during the process.\n', '    /// On the value chain nonces need to strictly increase by one; on the utility\n', '    /// chain the nonce need to strictly increase (as one value chain can have multiple\n', '    /// utility chains)\n', '    mapping(address /* (un)staker */ => uint256) internal nonces;\n', '    /// register the active stakes and unstakes\n', '    mapping(bytes32 /* hashStakingIntent */ => Stake) public stakes;\n', '    mapping(bytes32 /* hashRedemptionIntent */ => Unstake) public unstakes;\n', '\n', '    /*\n', '     *  Modifiers\n', '     */\n', '    modifier onlyRegistrar() {\n', '        // for now keep unique registrar\n', '        require(msg.sender == registrar);\n', '        _;\n', '    }\n', '\n', '    function AM1OpenSTValue(\n', '        uint256 _chainIdValue,\n', '        EIP20Interface _eip20token,\n', '        address _registrar)\n', '        public\n', '        OpsManaged()\n', '    {\n', '        require(_chainIdValue != 0);\n', '        require(_eip20token != address(0));\n', '        require(_registrar != address(0));\n', '\n', '        chainIdValue = _chainIdValue;\n', '        valueToken = _eip20token;\n', '        // registrar cannot be reset\n', '        // TODO: require it to be a contract\n', '        registrar = _registrar;\n', '        deactivated = false;\n', '    }\n', '\n', '    /*\n', '     *  External functions\n', '     */\n', '    /// @dev In order to stake the tx.origin needs to set an allowance\n', '    ///      for the OpenSTValue contract to transfer to itself to hold\n', '    ///      during the staking process.\n', '    function stake(\n', '        bytes32 _uuid,\n', '        uint256 _amountST,\n', '        address _beneficiary)\n', '        external\n', '        returns (\n', '        uint256 amountUT,\n', '        uint256 nonce,\n', '        uint256 unlockHeight,\n', '        bytes32 stakingIntentHash)\n', '        /* solhint-disable-next-line function-max-lines */\n', '    {\n', '        require(!deactivated);\n', '        /* solhint-disable avoid-tx-origin */\n', '        // check the staking contract has been approved to spend the amount to stake\n', '        // OpenSTValue needs to be able to transfer the stake into its balance for\n', '        // keeping until the two-phase process is completed on both chains.\n', '        require(_amountST > 0);\n', '        // Consider the security risk of using tx.origin; at the same time an allowance\n', '        // needs to be set before calling stake over a potentially malicious contract at stakingAccount.\n', '        // The second protection is that the staker needs to check the intent hash before\n', '        // signing off on completing the two-phased process.\n', '        require(valueToken.allowance(tx.origin, address(this)) >= _amountST);\n', '\n', '        require(utilityTokens[_uuid].simpleStake != address(0));\n', '        require(_beneficiary != address(0));\n', '\n', '        UtilityToken storage utilityToken = utilityTokens[_uuid];\n', '\n', '        // if the staking account is set to a non-zero address,\n', '        // then all transactions have come (from/over) the staking account,\n', '        // whether this is an EOA or a contract; tx.origin is putting forward the funds\n', '        if (utilityToken.stakingAccount != address(0)) require(msg.sender == utilityToken.stakingAccount);\n', '        require(valueToken.transferFrom(tx.origin, address(this), _amountST));\n', '\n', '        amountUT = (_amountST.mul(utilityToken.conversionRate))\n', '            .div(10**uint256(utilityToken.conversionRateDecimals));\n', '        unlockHeight = block.number + blocksToWaitLong();\n', '\n', '        nonces[tx.origin]++;\n', '        nonce = nonces[tx.origin];\n', '\n', '        stakingIntentHash = hashStakingIntent(\n', '            _uuid,\n', '            tx.origin,\n', '            nonce,\n', '            _beneficiary,\n', '            _amountST,\n', '            amountUT,\n', '            unlockHeight\n', '        );\n', '\n', '        stakes[stakingIntentHash] = Stake({\n', '            uuid:         _uuid,\n', '            staker:       tx.origin,\n', '            beneficiary:  _beneficiary,\n', '            nonce:        nonce,\n', '            amountST:     _amountST,\n', '            amountUT:     amountUT,\n', '            unlockHeight: unlockHeight\n', '        });\n', '\n', '        StakingIntentDeclared(_uuid, tx.origin, nonce, _beneficiary,\n', '            _amountST, amountUT, unlockHeight, stakingIntentHash, utilityToken.chainIdUtility);\n', '\n', '        return (amountUT, nonce, unlockHeight, stakingIntentHash);\n', '        /* solhint-enable avoid-tx-origin */\n', '    }\n', '\n', '    function processStaking(\n', '        bytes32 _stakingIntentHash)\n', '        external\n', '        returns (address stakeAddress)\n', '    {\n', '        require(_stakingIntentHash != "");\n', '\n', '        Stake storage stake = stakes[_stakingIntentHash];\n', '\n', '        // note: as processStaking incurs a cost for the staker, we provide a fallback\n', '        // in v0.9 for registrar to process the staking on behalf of the staker,\n', '        // as the staker could fail to process the stake and avoid the cost of staking;\n', '        // this will be replaced with a signature carry-over implementation instead, where\n', '        // the signature of the intent hash suffices on value and utility chain, decoupling\n', '        // it from the transaction to processStaking and processMinting\n', '        require(stake.staker == msg.sender || registrar == msg.sender);\n', '        // as this bears the cost, there is no need to require\n', '        // that the stake.unlockHeight is not yet surpassed\n', '        // as is required on processMinting\n', '\n', '        UtilityToken storage utilityToken = utilityTokens[stake.uuid];\n', '        stakeAddress = address(utilityToken.simpleStake);\n', '        require(stakeAddress != address(0));\n', '\n', '        assert(valueToken.balanceOf(address(this)) >= stake.amountST);\n', '        require(valueToken.transfer(stakeAddress, stake.amountST));\n', '\n', '        ProcessedStake(stake.uuid, _stakingIntentHash, stakeAddress, stake.staker,\n', '            stake.amountST, stake.amountUT);\n', '\n', '        delete stakes[_stakingIntentHash];\n', '\n', '        return stakeAddress;\n', '    }\n', '\n', '    function revertStaking(\n', '        bytes32 _stakingIntentHash)\n', '        external\n', '        returns (\n', '        bytes32 uuid,\n', '        uint256 amountST,\n', '        address staker)\n', '    {\n', '        require(_stakingIntentHash != "");\n', '\n', '        Stake storage stake = stakes[_stakingIntentHash];\n', '\n', '        // require that the stake is unlocked and exists\n', '        require(stake.unlockHeight > 0);\n', '        require(stake.unlockHeight <= block.number);\n', '\n', '        assert(valueToken.balanceOf(address(this)) >= stake.amountST);\n', '        // revert the amount that was intended to be staked back to staker\n', '        require(valueToken.transfer(stake.staker, stake.amountST));\n', '\n', '        uuid = stake.uuid;\n', '        amountST = stake.amountST;\n', '        staker = stake.staker;\n', '\n', '        RevertedStake(stake.uuid, _stakingIntentHash, stake.staker,\n', '            stake.amountST, stake.amountUT);\n', '\n', '        delete stakes[_stakingIntentHash];\n', '\n', '        return (uuid, amountST, staker);\n', '    }\n', '\n', '    function confirmRedemptionIntent(\n', '        bytes32 _uuid,\n', '        address _redeemer,\n', '        uint256 _redeemerNonce,\n', '        address _beneficiary,\n', '        uint256 _amountUT,\n', '        uint256 _redemptionUnlockHeight,\n', '        bytes32 _redemptionIntentHash)\n', '        external\n', '        onlyRegistrar\n', '        returns (\n', '        uint256 amountST,\n', '        uint256 expirationHeight)\n', '    {\n', '        require(utilityTokens[_uuid].simpleStake != address(0));\n', '        require(_amountUT > 0);\n', '        require(_beneficiary != address(0));\n', '        // later core will provide a view on the block height of the\n', '        // utility chain\n', '        require(_redemptionUnlockHeight > 0);\n', '        require(_redemptionIntentHash != "");\n', '\n', '        require(nonces[_redeemer] + 1 == _redeemerNonce);\n', '        nonces[_redeemer]++;\n', '\n', '        bytes32 redemptionIntentHash = hashRedemptionIntent(\n', '            _uuid,\n', '            _redeemer,\n', '            nonces[_redeemer],\n', '            _beneficiary,\n', '            _amountUT,\n', '            _redemptionUnlockHeight\n', '        );\n', '\n', '        require(_redemptionIntentHash == redemptionIntentHash);\n', '\n', '        expirationHeight = block.number + blocksToWaitShort();\n', '\n', '        UtilityToken storage utilityToken = utilityTokens[_uuid];\n', '        // minimal precision to unstake 1 STWei\n', '        require(_amountUT >= (utilityToken.conversionRate.div(10**uint256(utilityToken.conversionRateDecimals))));\n', '        amountST = (_amountUT\n', '            .mul(10**uint256(utilityToken.conversionRateDecimals))).div(utilityToken.conversionRate);\n', '\n', '        require(valueToken.balanceOf(address(utilityToken.simpleStake)) >= amountST);\n', '\n', '        unstakes[redemptionIntentHash] = Unstake({\n', '            uuid:         _uuid,\n', '            redeemer:     _redeemer,\n', '            beneficiary:  _beneficiary,\n', '            amountUT:     _amountUT,\n', '            amountST:     amountST,\n', '            expirationHeight: expirationHeight\n', '        });\n', '\n', '        RedemptionIntentConfirmed(_uuid, redemptionIntentHash, _redeemer,\n', '            _beneficiary, amountST, _amountUT, expirationHeight);\n', '\n', '        return (amountST, expirationHeight);\n', '    }\n', '\n', '    function processUnstaking(\n', '        bytes32 _redemptionIntentHash)\n', '        external\n', '        returns (\n', '        address stakeAddress)\n', '    {\n', '        require(_redemptionIntentHash != "");\n', '\n', '        Unstake storage unstake = unstakes[_redemptionIntentHash];\n', '        require(unstake.redeemer == msg.sender);\n', '\n', '        // as the process unstake results in a gain for the caller\n', '        // it needs to expire well before the process redemption can\n', '        // be reverted in OpenSTUtility\n', '        require(unstake.expirationHeight > block.number);\n', '\n', '        UtilityToken storage utilityToken = utilityTokens[unstake.uuid];\n', '        stakeAddress = address(utilityToken.simpleStake);\n', '        require(stakeAddress != address(0));\n', '\n', '        require(utilityToken.simpleStake.releaseTo(unstake.beneficiary, unstake.amountST));\n', '\n', '        ProcessedUnstake(unstake.uuid, _redemptionIntentHash, stakeAddress,\n', '            unstake.redeemer, unstake.beneficiary, unstake.amountST);\n', '\n', '        delete unstakes[_redemptionIntentHash];\n', '\n', '        return stakeAddress;\n', '    }\n', '\n', '    function revertUnstaking(\n', '        bytes32 _redemptionIntentHash)\n', '        external\n', '        returns (\n', '        bytes32 uuid,\n', '        address redeemer,\n', '        address beneficiary,\n', '        uint256 amountST)\n', '    {\n', '        require(_redemptionIntentHash != "");\n', '\n', '        Unstake storage unstake = unstakes[_redemptionIntentHash];\n', '\n', '        // require that the unstake has expired and that the redeemer has not\n', '        // processed the unstaking, ie unstake has not been deleted\n', '        require(unstake.expirationHeight > 0);\n', '        require(unstake.expirationHeight <= block.number);\n', '\n', '        uuid = unstake.uuid;\n', '        redeemer = unstake.redeemer;\n', '        beneficiary = unstake.beneficiary;\n', '        amountST = unstake.amountST;\n', '\n', '        delete unstakes[_redemptionIntentHash];\n', '\n', '        RevertedUnstake(uuid, _redemptionIntentHash, redeemer, beneficiary, amountST);\n', '\n', '        return (uuid, redeemer, beneficiary, amountST);\n', '    }\n', '\n', '    function core(\n', '        uint256 _chainIdUtility)\n', '        external\n', '        view\n', '        returns (address /* core address */ )\n', '    {\n', '        return address(cores[_chainIdUtility]);\n', '    }\n', '\n', '    /*\n', '     *  Public view functions\n', '     */\n', '    function getNextNonce(\n', '        address _account)\n', '        public\n', '        view\n', '        returns (uint256 /* nextNonce */)\n', '    {\n', '        return (nonces[_account] + 1);\n', '    }\n', '\n', '    function blocksToWaitLong() public pure returns (uint256) {\n', '        return BLOCKS_TO_WAIT_LONG;\n', '    }\n', '\n', '    function blocksToWaitShort() public pure returns (uint256) {\n', '        return BLOCKS_TO_WAIT_SHORT;\n', '    }\n', '\n', '    /// @dev Returns size of uuids\n', '    /// @return size\n', '    function getUuidsSize() public view returns (uint256) {\n', '        return uuids.length;\n', '    }\n', '\n', '    /*\n', '     *  Registrar functions\n', '     */\n', '    function addCore(\n', '        CoreInterface _core)\n', '        public\n', '        onlyRegistrar\n', '        returns (bool /* success */)\n', '    {\n', '        require(address(_core) != address(0));\n', '        // core constructed with same registrar\n', '        require(registrar == _core.registrar());\n', '        // on value chain core only tracks a remote utility chain\n', '        uint256 chainIdUtility = _core.chainIdRemote();\n', '        require(chainIdUtility != 0);\n', '        // cannot overwrite core for given chainId\n', '        require(cores[chainIdUtility] == address(0));\n', '\n', '        cores[chainIdUtility] = _core;\n', '\n', '        return true;\n', '    }\n', '\n', '    function registerUtilityToken(\n', '        string _symbol,\n', '        string _name,\n', '        uint256 _conversionRate,\n', '        uint8 _conversionRateDecimals,\n', '        uint256 _chainIdUtility,\n', '        address _stakingAccount,\n', '        bytes32 _checkUuid)\n', '        public\n', '        onlyRegistrar\n', '        returns (bytes32 uuid)\n', '    {\n', '        require(bytes(_name).length > 0);\n', '        require(bytes(_symbol).length > 0);\n', '        require(_conversionRate > 0);\n', '        require(_conversionRateDecimals <= 5);\n', '\n', '        address openSTRemote = cores[_chainIdUtility].openSTRemote();\n', '        require(openSTRemote != address(0));\n', '\n', '        uuid = hashUuid(\n', '            _symbol,\n', '            _name,\n', '            chainIdValue,\n', '            _chainIdUtility,\n', '            openSTRemote,\n', '            _conversionRate,\n', '            _conversionRateDecimals);\n', '\n', '        require(uuid == _checkUuid);\n', '\n', '        require(address(utilityTokens[uuid].simpleStake) == address(0));\n', '\n', '        SimpleStake simpleStake = new SimpleStake(\n', '            valueToken, address(this), uuid);\n', '\n', '        utilityTokens[uuid] = UtilityToken({\n', '            symbol:         _symbol,\n', '            name:           _name,\n', '            conversionRate: _conversionRate,\n', '            conversionRateDecimals: _conversionRateDecimals,\n', '            decimals:       TOKEN_DECIMALS,\n', '            chainIdUtility: _chainIdUtility,\n', '            simpleStake:    simpleStake,\n', '            stakingAccount: _stakingAccount\n', '        });\n', '        uuids.push(uuid);\n', '\n', '        UtilityTokenRegistered(uuid, address(simpleStake), _symbol, _name,\n', '            TOKEN_DECIMALS, _conversionRate, _conversionRateDecimals, _chainIdUtility, _stakingAccount);\n', '\n', '        return uuid;\n', '    }\n', '\n', '    /*\n', '     *  Administrative functions\n', '     */\n', '    function initiateProtocolTransfer(\n', '        ProtocolVersioned _simpleStake,\n', '        address _proposedProtocol)\n', '        public\n', '        onlyAdmin\n', '        returns (bool)\n', '    {\n', '        _simpleStake.initiateProtocolTransfer(_proposedProtocol);\n', '\n', '        return true;\n', '    }\n', '\n', '    // on the very first released version v0.9.1 there is no need\n', '    // to completeProtocolTransfer from a previous version\n', '\n', '    /* solhint-disable-next-line separate-by-one-line-in-contract */\n', '    function revokeProtocolTransfer(\n', '        ProtocolVersioned _simpleStake)\n', '        public\n', '        onlyAdmin\n', '        returns (bool)\n', '    {\n', '        _simpleStake.revokeProtocolTransfer();\n', '\n', '        return true;\n', '    }\n', '\n', '    function deactivate()\n', '        public\n', '        onlyAdmin\n', '        returns (\n', '        bool result)\n', '    {\n', '        deactivated = true;\n', '        return deactivated;\n', '    }\n', '}']
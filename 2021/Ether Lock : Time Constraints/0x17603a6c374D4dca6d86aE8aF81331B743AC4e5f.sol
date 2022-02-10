['pragma solidity >=0.8.0;\n', '\n', 'import "./interfaces/IERC20.sol";\n', 'import "./interfaces/IConfig.sol";\n', 'import "./interfaces/IStake.sol";\n', 'import "./libs/TransferHelper.sol";\n', '\n', 'interface IConfigable {\n', '    function getConfig() external returns (IConfig);\n', '}\n', '\n', 'contract Stake is IStake {\n', '    event StakeUpdated(address indexed staker, bool isIncrease, uint256 stakeChanged, uint256 stakeAmount);\n', '\n', '    event Claimed(address indexed staker, uint256 reward);\n', '\n', '    // stake token address, ERC20\n', '    address public stakeToken;\n', '\n', '    bool initialized;\n', '\n', '    bool locker;\n', '\n', '    // reward token address, ERC20\n', '    address public rewardToken;\n', '\n', '    // Mining start date(epoch second)\n', '    uint256 public startDateOfMining;\n', '\n', '    // Mining end date(epoch second)\n', '    uint256 public endDateOfMining;\n', '\n', '    // controller address\n', '    address controller;\n', '\n', '    // reward per Second\n', '    uint256 public rewardPerSecond;\n', '\n', '    // timestamp of last updated\n', '    uint256 public lastUpdatedTimestamp;\n', '\n', '    uint256 public rewardPerTokenStored;\n', '\n', '    // staked total\n', '    uint256 private _totalSupply;\n', '\n', '    struct StakerInfo {\n', "        // exclude reward's amount\n", '        uint256 rewardDebt;\n', '        // stake total\n', '        uint256 amount;\n', '        // pending reward\n', '        uint256 reward;\n', '    }\n', '\n', "    // staker's StakerInfo\n", '    mapping(address => StakerInfo) public stakers;\n', '\n', '    /* ========== MODIFIER ========== */\n', '\n', '    modifier stakeable() {\n', '        require(block.timestamp <= endDateOfMining, "stake not begin or complete");\n', '        _;\n', '    }\n', '\n', '    modifier enable() {\n', '        require(initialized, "initialized = false");\n', '        _;\n', '    }\n', '\n', '    modifier onlyController {\n', '        require(controller == msg.sender, "only controller");\n', '        _;\n', '    }\n', '\n', '    modifier lock() {\n', '        require(locker == false, "locked");\n', '        locker = true;\n', '        _;\n', '        locker = false;\n', '    }\n', '\n', '    modifier updateReward(address _staker) {\n', '        rewardPerTokenStored = rewardPerToken();\n', '        lastUpdatedTimestamp = lastTimeRewardApplicable();\n', '        if (_staker != address(0) && stakers[_staker].amount > 0) {\n', '            stakers[_staker].reward = rewardOf(_staker);\n', '            stakers[_staker].rewardDebt = rewardPerTokenStored;\n', '        }\n', '        _;\n', '    }\n', '\n', '    constructor() {}\n', '\n', '    /* ========== MUTATIVE FUNCTIONS ========== */\n', '    /**\n', '     * @dev initialize contract\n', '     * @param _stake address of stake token\n', '     * @param _reward address of reward token\n', '     * @param _start epoch seconds of mining starts\n', '     * @param _end epoch seconds of mining complete\n', '     * @param _totalReward totalReward\n', '     */\n', '    function initialize(\n', '        address _stake,\n', '        address _reward,\n', '        uint256 _start,\n', '        uint256 _end,\n', '        uint256 _totalReward\n', '    ) external override {\n', '        require(!initialized, "initialized = true");\n', '        // only initialize once\n', '        initialized = true;\n', '        controller = msg.sender;\n', '        stakeToken = _stake;\n', '        rewardToken = _reward;\n', '        startDateOfMining = _start;\n', '        endDateOfMining = _end;\n', '        rewardPerSecond = _totalReward / (_end - _start + 1);\n', '    }\n', '\n', '    /**\n', '     * @dev stake token\n', '     * @param _amount amount of token to be staked\n', '     */\n', '    function stake(uint256 _amount) external enable() lock() updateReward(msg.sender) {\n', '        require(_amount > 0, "amount = 0");\n', '        require(block.timestamp <= endDateOfMining, "stake not begin or complete");\n', '        _totalSupply += _amount;\n', '        stakers[msg.sender].amount += _amount;\n', '        TransferHelper.safeTransferFrom(stakeToken, msg.sender, address(this), _amount);\n', '        emit StakeUpdated(msg.sender, true, _amount, stakers[msg.sender].amount);\n', '        _notify();\n', '    }\n', '\n', '    /**\n', '     * @dev unstake token\n', '     * @param _amount amount of token to be unstaked\n', '     */\n', '    function unstake(uint256 _amount) public enable() lock() updateReward(msg.sender) {\n', '        require(_amount > 0, "amount = 0");\n', '        require(stakers[msg.sender].amount >= _amount, "insufficient amount");\n', '        _claim(msg.sender);\n', '        _totalSupply -= _amount;\n', '        stakers[msg.sender].amount -= _amount;\n', '        TransferHelper.safeTransfer(stakeToken, msg.sender, _amount);\n', '        emit StakeUpdated(msg.sender, false, _amount, stakers[msg.sender].amount);\n', '        _notify();\n', '    }\n', '\n', '    /**\n', '     * @dev claim rewards\n', '     */\n', '    function claim() external enable() lock() updateReward(msg.sender) {\n', '        _claim(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev quit, claim reward + unstake all\n', '     */\n', '    function quit() external enable() lock() updateReward(msg.sender) {\n', '        unstake(stakers[msg.sender].amount);\n', '        _claim(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev claim rewards, only owner allowed\n', '     * @param _staker staker address\n', '     */\n', '    function claim0(address _staker) external override onlyController() enable() updateReward(msg.sender) {\n', '        _claim(_staker);\n', '    }\n', '\n', '    /* ========== VIEWs ========== */\n', '    function lastTimeRewardApplicable() public view returns (uint256) {\n', '        if (block.timestamp < startDateOfMining) return startDateOfMining;\n', '        return block.timestamp > endDateOfMining ? endDateOfMining : block.timestamp;\n', '    }\n', '\n', '    function rewardPerToken() public view returns (uint256) {\n', '        if (_totalSupply == 0 || block.timestamp < startDateOfMining) {\n', '            return rewardPerTokenStored;\n', '        }\n', '        return\n', '            rewardPerTokenStored +\n', '            ((lastTimeRewardApplicable() - lastUpdatedTimestamp) * rewardPerSecond * 1e18) /\n', '            _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev amount of stake per address\n', '     * @param _staker staker address\n', '     * @return amount of stake\n', '     */\n', '    function stakeOf(address _staker) external view returns (uint256) {\n', '        return stakers[_staker].amount;\n', '    }\n', '\n', '    /**\n', '     * @dev amount of reward per address\n', '     * @param _staker address\n', '     * @return value reward amount of _staker\n', '     */\n', '    function rewardOf(address _staker) public view returns (uint256 value) {\n', '        StakerInfo memory info = stakers[_staker];\n', '        return (info.amount * rewardPerToken() - info.rewardDebt) / 1e18 + info.reward;\n', '    }\n', '\n', '    /* ========== INTERNAL FUNCTIONS ========== */\n', '    /**\n', '     * @dev claim reward\n', '     * @param _staker address\n', '     */\n', '    function _claim(address _staker) private {\n', '        uint256 reward = stakers[_staker].reward;\n', '        if (reward > 0) {\n', '            stakers[_staker].reward = 0;\n', '            IConfig config = IConfigable(controller).getConfig();\n', '            uint256 claimFeeRate = config.claimFeeRate();\n', '            uint256 out = (reward * (10000 - claimFeeRate)) / 10000;\n', '            uint256 fee = reward - out;\n', '            TransferHelper.safeTransfer(rewardToken, _staker, out);\n', '\n', '            if (fee > 0) {\n', '                // transfer to feeTo\n', '                TransferHelper.safeTransfer(rewardToken, config.feeTo(), fee);\n', '            }\n', '            emit Claimed(_staker, reward);\n', '            _notify();\n', '        }\n', '    }\n', '\n', '    function _notify() private {\n', '        IConfigable(controller).getConfig().notify(IConfig.EventType.STAKE_UPDATED, address(this));\n', '    }\n', '}\n', '\n', 'pragma solidity >=0.8.0;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address owner) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) external returns (bool);\n', '}\n', '\n', 'pragma solidity >=0.8.0;\n', '\n', 'interface IConfig {\n', '    enum EventType {FUND_CREATED, FUND_UPDATED, STAKE_CREATED, STAKE_UPDATED, REG_CREATED, REG_UPDATED, PFUND_CREATED, PFUND_UPDATED}\n', '\n', '    function ceo() external view returns (address);\n', '\n', '    function protocolPool() external view returns (address);\n', '\n', '    function protocolToken() external view returns (address);\n', '\n', '    function feeTo() external view returns (address);\n', '\n', '    function nameRegistry() external view returns (address);\n', '\n', '    //  function investTokenWhitelist() external view returns (address[] memory);\n', '\n', '    function tokenMinFundSize(address token) external view returns (uint256);\n', '\n', '    function investFeeRate() external view returns (uint256);\n', '\n', '    function redeemFeeRate() external view returns (uint256);\n', '\n', '    function claimFeeRate() external view returns (uint256);\n', '\n', '    function poolCreationRate() external view returns (uint256);\n', '\n', '    function slot0() external view returns (uint256);\n', '\n', '    function slot1() external view returns (uint256);\n', '\n', '    function slot2() external view returns (uint256);\n', '\n', '    function slot3() external view returns (uint256);\n', '\n', '    function slot4() external view returns (uint256);\n', '\n', '    function notify(EventType _type, address _src) external;\n', '}\n', '\n', 'pragma solidity >=0.8.0;\n', '\n', 'interface IStake {\n', '    function claim0(address _owner) external;\n', '\n', '    function initialize(\n', '        address stakeToken,\n', '        address rewardToken,\n', '        uint256 start,\n', '        uint256 end,\n', '        uint256 rewardPerBlock\n', '    ) external;\n', '}\n', '\n', 'pragma solidity >=0.8.0;\n', '\n', '// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library TransferHelper {\n', '    function safeApprove(\n', '        address token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) =\n', '            token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', "            'TransferHelper: APPROVE_FAILED'\n", '        );\n', '    }\n', '\n', '    function safeTransfer(\n', '        address token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) =\n', '            token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', "            'TransferHelper: TRANSFER_FAILED'\n", '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        address token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) =\n', '            token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', "            'TransferHelper: TRANSFER_FROM_FAILED'\n", '        );\n', '    }\n', '\n', '    function safeTransferETH(address to, uint256 value) internal {\n', '        (bool success, ) = to.call{value: value}(new bytes(0));\n', "        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');\n", '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 2000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']
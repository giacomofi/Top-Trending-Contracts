['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', 'import "./BoringERC20.sol";\n', 'import "./BoringMath.sol";\n', 'import "./BoringOwnable.sol";\n', 'import "./IRewarder.sol";\n', 'import "./IMasterChefV2.sol";\n', '\n', '/// @author @0xKeno\n', 'contract PendleOnsenComplexRewarder is IRewarder,  BoringOwnable{\n', '    using BoringMath for uint256;\n', '    using BoringMath128 for uint128;\n', '    using BoringERC20 for IERC20;\n', '\n', '    IERC20 private immutable rewardToken;\n', '\n', '    /// @notice Info of each MCV2 user.\n', '    /// `amount` LP token amount the user has provided.\n', '    /// `rewardDebt` The amount of SUSHI entitled to the user.\n', '    struct UserInfo {\n', '        uint256 amount;\n', '        uint256 rewardDebt;\n', '    }\n', '\n', '    /// @notice Info of each MCV2 pool.\n', '    /// `allocPoint` The amount of allocation points assigned to the pool.\n', '    /// Also known as the amount of SUSHI to distribute per block.\n', '    struct PoolInfo {\n', '        uint128 accSushiPerShare;\n', '        uint64 lastRewardBlock;\n', '        uint64 allocPoint;\n', '    }\n', '\n', '    /// @notice Info of each pool.\n', '    mapping (uint256 => PoolInfo) public poolInfo;\n', '\n', '    uint256[] public poolIds;\n', '\n', '    /// @notice Info of each user that stakes LP tokens.\n', '    mapping (uint256 => mapping (address => UserInfo)) public userInfo;\n', '    /// @dev Total allocation points. Must be the sum of all allocation points in all pools.\n', '    uint256 totalAllocPoint;\n', '\n', '    uint256 public tokenPerBlock;\n', '    uint256 private constant ACC_TOKEN_PRECISION = 1e12;\n', '\n', '    address private immutable MASTERCHEF_V2;\n', '\n', '    event LogOnReward(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);\n', '    event LogPoolAddition(uint256 indexed pid, uint256 allocPoint);\n', '    event LogSetPool(uint256 indexed pid, uint256 allocPoint);\n', '    event LogUpdatePool(uint256 indexed pid, uint64 lastRewardBlock, uint256 lpSupply, uint256 accSushiPerShare);\n', '    event LogInit();\n', '    event RewardRateUpdated(uint256 oldRate, uint256 newRate);\n', '\n', '    constructor (IERC20 _rewardToken, uint256 _tokenPerBlock, address _MASTERCHEF_V2) public {\n', '        rewardToken = _rewardToken;\n', '        tokenPerBlock = _tokenPerBlock;\n', '        MASTERCHEF_V2 = _MASTERCHEF_V2;\n', '    }\n', '\n', '\n', '    function onSushiReward (uint256 pid, address _user, address to, uint256, uint256 lpToken) onlyMCV2 override external {\n', '        PoolInfo memory pool = updatePool(pid);\n', '        UserInfo storage user = userInfo[pid][_user];\n', '        uint256 pending;\n', '        if (user.amount > 0) {\n', '            pending =\n', '                (user.amount.mul(pool.accSushiPerShare) / ACC_TOKEN_PRECISION).sub(\n', '                    user.rewardDebt\n', '                );\n', '            rewardToken.safeTransfer(to, pending);\n', '        }\n', '        user.amount = lpToken;\n', '        user.rewardDebt = lpToken.mul(pool.accSushiPerShare) / ACC_TOKEN_PRECISION;\n', '        emit LogOnReward(_user, pid, pending, to);\n', '    }\n', '\n', '    function pendingTokens(uint256 pid, address user, uint256) override external view returns (IERC20[] memory rewardTokens, uint256[] memory rewardAmounts) {\n', '        IERC20[] memory _rewardTokens = new IERC20[](1);\n', '        _rewardTokens[0] = (rewardToken);\n', '        uint256[] memory _rewardAmounts = new uint256[](1);\n', '        _rewardAmounts[0] = pendingToken(pid, user);\n', '        return (_rewardTokens, _rewardAmounts);\n', '    }\n', '\n', '    modifier onlyMCV2 {\n', '        require(\n', '            msg.sender == MASTERCHEF_V2,\n', '            "Only MCV2 can call this function."\n', '        );\n', '        _;\n', '    }\n', '\n', '    /// @notice Returns the number of MCV2 pools.\n', '    function poolLength() public view returns (uint256 pools) {\n', '        pools = poolIds.length;\n', '    }\n', '\n', '    /// @notice Add a new LP to the pool.  Can only be called by the owner.\n', '    /// DO NOT add the same LP token more than once. Rewards will be messed up if you do.\n', '    /// @param allocPoint AP of the new pool.\n', '    /// @param _pid Pid on MCV2\n', '    function add(uint256 allocPoint, uint256 _pid) public onlyOwner {\n', '        require(poolInfo[_pid].lastRewardBlock == 0, "Pool already exists");\n', '        uint256 lastRewardBlock = block.number;\n', '        totalAllocPoint = totalAllocPoint.add(allocPoint);\n', '\n', '        poolInfo[_pid] = PoolInfo({\n', '            allocPoint: allocPoint.to64(),\n', '            lastRewardBlock: lastRewardBlock.to64(),\n', '            accSushiPerShare: 0\n', '        });\n', '        poolIds.push(_pid);\n', '        emit LogPoolAddition(_pid, allocPoint);\n', '    }\n', '\n', "    /// @notice Update the given pool's SUSHI allocation point and `IRewarder` contract. Can only be called by the owner.\n", '    /// @param _pid The index of the pool. See `poolInfo`.\n', '    /// @param _allocPoint New AP of the pool.\n', '    function set(uint256 _pid, uint256 _allocPoint) public onlyOwner {\n', '        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);\n', '        poolInfo[_pid].allocPoint = _allocPoint.to64();\n', '        emit LogSetPool(_pid, _allocPoint);\n', '    }\n', '\n', '    /// @notice View function to see pending Token\n', '    /// @param _pid The index of the pool. See `poolInfo`.\n', '    /// @param _user Address of user.\n', '    /// @return pending SUSHI reward for a given user.\n', '    function pendingToken(uint256 _pid, address _user) public view returns (uint256 pending) {\n', '        PoolInfo memory pool = poolInfo[_pid];\n', '        UserInfo storage user = userInfo[_pid][_user];\n', '        uint256 accSushiPerShare = pool.accSushiPerShare;\n', '        uint256 lpSupply = IMasterChefV2(MASTERCHEF_V2).lpToken(_pid).balanceOf(MASTERCHEF_V2);\n', '        if (block.number > pool.lastRewardBlock && lpSupply != 0) {\n', '            uint256 blocks = block.number.sub(pool.lastRewardBlock);\n', '            uint256 sushiReward = blocks.mul(tokenPerBlock).mul(pool.allocPoint) / totalAllocPoint;\n', '            accSushiPerShare = accSushiPerShare.add(sushiReward.mul(ACC_TOKEN_PRECISION) / lpSupply);\n', '        }\n', '        pending = (user.amount.mul(accSushiPerShare) / ACC_TOKEN_PRECISION).sub(user.rewardDebt);\n', '    }\n', '\n', '    /// @notice Update reward variables for all pools. Be careful of gas spending!\n', '    /// @param pids Pool IDs of all to be updated. Make sure to update all active pools.\n', '    function massUpdatePools(uint256[] calldata pids) public {\n', '        uint256 len = pids.length;\n', '        for (uint256 i = 0; i < len; ++i) {\n', '            updatePool(pids[i]);\n', '        }\n', '    }\n', '\n', '    /// @notice Update reward variables of the given pool.\n', '    /// @param pid The index of the pool. See `poolInfo`.\n', '    /// @return pool Returns the pool that was updated.\n', '    function updatePool(uint256 pid) public returns (PoolInfo memory pool) {\n', '        pool = poolInfo[pid];\n', '        require(pool.lastRewardBlock != 0, "Pool does not exist");\n', '        if (block.number > pool.lastRewardBlock) {\n', '            uint256 lpSupply = IMasterChefV2(MASTERCHEF_V2).lpToken(pid).balanceOf(MASTERCHEF_V2);\n', '\n', '            if (lpSupply > 0) {\n', '                uint256 blocks = block.number.sub(pool.lastRewardBlock);\n', '                uint256 sushiReward = blocks.mul(tokenPerBlock).mul(pool.allocPoint) / totalAllocPoint;\n', '                pool.accSushiPerShare = pool.accSushiPerShare.add((sushiReward.mul(ACC_TOKEN_PRECISION) / lpSupply).to128());\n', '            }\n', '            pool.lastRewardBlock = block.number.to64();\n', '            poolInfo[pid] = pool;\n', '            emit LogUpdatePool(pid, pool.lastRewardBlock, lpSupply, pool.accSushiPerShare);\n', '        }\n', '    }\n', '\n', '    /// @dev Sets the distribution reward rate. This will also update all of the pools.\n', '  \t/// @param _tokenPerBlock The number of tokens to distribute per block\n', '  \tfunction setRewardRate(uint256 _tokenPerBlock, uint256[] calldata _pids) external onlyOwner {\n', '    \t\tmassUpdatePools(_pids);\n', '\n', '    \t\tuint256 oldRate = tokenPerBlock;\n', '    \t\ttokenPerBlock = _tokenPerBlock;\n', '\n', '    \t\temit RewardRateUpdated(oldRate, _tokenPerBlock);\n', '  \t}\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-12\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    /// @notice EIP 2612\n', '    function permit(\n', '        address owner,\n', '        address spender,\n', '        uint256 value,\n', '        uint256 deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external;\n', '}\n', '\n', '// solhint-disable avoid-low-level-calls\n', '\n', 'library BoringERC20 {\n', '    bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()\n', '    bytes4 private constant SIG_NAME = 0x06fdde03; // name()\n', '    bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()\n', '    bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)\n', '    bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)\n', '\n', '    function returnDataToString(bytes memory data) internal pure returns (string memory) {\n', '        if (data.length >= 64) {\n', '            return abi.decode(data, (string));\n', '        } else if (data.length == 32) {\n', '            uint8 i = 0;\n', '            while(i < 32 && data[i] != 0) {\n', '                i++;\n', '            }\n', '            bytes memory bytesArray = new bytes(i);\n', '            for (i = 0; i < 32 && data[i] != 0; i++) {\n', '                bytesArray[i] = data[i];\n', '            }\n', '            return string(bytesArray);\n', '        } else {\n', '            return "???";\n', '        }\n', '    }\n', '\n', "    /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.\n", '    /// @param token The address of the ERC-20 token contract.\n', '    /// @return (string) Token symbol.\n', '    function safeSymbol(IERC20 token) internal view returns (string memory) {\n', '        (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_SYMBOL));\n', '        return success ? returnDataToString(data) : "???";\n', '    }\n', '\n', "    /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.\n", '    /// @param token The address of the ERC-20 token contract.\n', '    /// @return (string) Token name.\n', '    function safeName(IERC20 token) internal view returns (string memory) {\n', '        (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_NAME));\n', '        return success ? returnDataToString(data) : "???";\n', '    }\n', '\n', "    /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.\n", '    /// @param token The address of the ERC-20 token contract.\n', '    /// @return (uint8) Token decimals.\n', '    function safeDecimals(IERC20 token) internal view returns (uint8) {\n', '        (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_DECIMALS));\n', '        return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;\n', '    }\n', '\n', '    /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.\n', '    /// Reverts on a failed transfer.\n', '    /// @param token The address of the ERC-20 token.\n', '    /// @param to Transfer tokens to.\n', '    /// @param amount The token amount.\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 amount\n', '    ) internal {\n', '        (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");\n', '    }\n', '\n', '    /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.\n', '    /// Reverts on a failed transfer.\n', '    /// @param token The address of the ERC-20 token.\n', '    /// @param from Transfer tokens from.\n', '    /// @param to Transfer tokens to.\n', '    /// @param amount The token amount.\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 amount\n', '    ) internal {\n', '        (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");\n', '    }\n', '}\n', '\n', 'interface IRewarder {\n', '    using BoringERC20 for IERC20;\n', '    function onSushiReward(uint256 pid, address user, address recipient, uint256 sushiAmount, uint256 newLpAmount) external;\n', '    function pendingTokens(uint256 pid, address user, uint256 sushiAmount) external view returns (IERC20[] memory, uint256[] memory);\n', '}\n', '\n', '/// @notice A library for performing overflow-/underflow-safe math,\n', '/// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).\n', 'library BoringMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require((c = a + b) >= b, "BoringMath: Add Overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require((c = a - b) <= a, "BoringMath: Underflow");\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");\n', '    }\n', '\n', '    function to128(uint256 a) internal pure returns (uint128 c) {\n', '        require(a <= uint128(-1), "BoringMath: uint128 Overflow");\n', '        c = uint128(a);\n', '    }\n', '\n', '    function to64(uint256 a) internal pure returns (uint64 c) {\n', '        require(a <= uint64(-1), "BoringMath: uint64 Overflow");\n', '        c = uint64(a);\n', '    }\n', '\n', '    function to32(uint256 a) internal pure returns (uint32 c) {\n', '        require(a <= uint32(-1), "BoringMath: uint32 Overflow");\n', '        c = uint32(a);\n', '    }\n', '}\n', '\n', '/// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.\n', 'library BoringMath128 {\n', '    function add(uint128 a, uint128 b) internal pure returns (uint128 c) {\n', '        require((c = a + b) >= b, "BoringMath: Add Overflow");\n', '    }\n', '\n', '    function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {\n', '        require((c = a - b) <= a, "BoringMath: Underflow");\n', '    }\n', '}\n', '\n', '/// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.\n', 'library BoringMath64 {\n', '    function add(uint64 a, uint64 b) internal pure returns (uint64 c) {\n', '        require((c = a + b) >= b, "BoringMath: Add Overflow");\n', '    }\n', '\n', '    function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {\n', '        require((c = a - b) <= a, "BoringMath: Underflow");\n', '    }\n', '}\n', '\n', '/// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.\n', 'library BoringMath32 {\n', '    function add(uint32 a, uint32 b) internal pure returns (uint32 c) {\n', '        require((c = a + b) >= b, "BoringMath: Add Overflow");\n', '    }\n', '\n', '    function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {\n', '        require((c = a - b) <= a, "BoringMath: Underflow");\n', '    }\n', '}\n', '\n', '// Audit on 5-Jan-2021 by Keno and BoringCrypto\n', '// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol\n', '// Edited by BoringCrypto\n', '\n', 'contract BoringOwnableData {\n', '    address public owner;\n', '    address public pendingOwner;\n', '}\n', '\n', 'contract BoringOwnable is BoringOwnableData {\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /// @notice `owner` defaults to msg.sender on construction.\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), msg.sender);\n', '    }\n', '\n', '    /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.\n', '    /// Can only be invoked by the current `owner`.\n', '    /// @param newOwner Address of the new owner.\n', '    /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.\n', '    /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.\n', '    function transferOwnership(\n', '        address newOwner,\n', '        bool direct,\n', '        bool renounce\n', '    ) public onlyOwner {\n', '        if (direct) {\n', '            // Checks\n', '            require(newOwner != address(0) || renounce, "Ownable: zero address");\n', '\n', '            // Effects\n', '            emit OwnershipTransferred(owner, newOwner);\n', '            owner = newOwner;\n', '            pendingOwner = address(0);\n', '        } else {\n', '            // Effects\n', '            pendingOwner = newOwner;\n', '        }\n', '    }\n', '\n', '    /// @notice Needs to be called by `pendingOwner` to claim ownership.\n', '    function claimOwnership() public {\n', '        address _pendingOwner = pendingOwner;\n', '\n', '        // Checks\n', '        require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");\n', '\n', '        // Effects\n', '        emit OwnershipTransferred(owner, _pendingOwner);\n', '        owner = _pendingOwner;\n', '        pendingOwner = address(0);\n', '    }\n', '\n', '    /// @notice Only allows the `owner` to execute the function.\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '}\n', '\n', '/// @notice The (older) MasterChef contract gives out a constant number of SUSHI tokens per block.\n', '/// It is the only address with minting rights for SUSHI.\n', '/// The idea for this MasterChef V2 (MCV2) contract is therefore to be the owner of a dummy token\n', '/// that is deposited into the MasterChef V1 (MCV1) contract.\n', '/// The allocation point for this pool on MCV1 is the total allocation point for all pools that receive double incentives.\n', 'contract MasterChefV2 {\n', '    /// @notice Address of the LP token for each MCV2 pool.\n', '    IERC20[] public lpToken;\n', '}\n', '\n', '/// @author @0xKeno\n', 'contract MPHRewarder is IRewarder, BoringOwnable{\n', '    using BoringMath for uint256;\n', '    using BoringMath128 for uint128;\n', '    using BoringERC20 for IERC20;\n', '\n', '    IERC20 private immutable rewardToken;\n', '\n', '    /// @notice Info of each MCV2 user.\n', '    /// `amount` LP token amount the user has provided.\n', '    /// `rewardDebt` The amount of SUSHI entitled to the user.\n', '    struct UserInfo {\n', '        uint256 amount;\n', '        uint256 rewardDebt;\n', '    }\n', '\n', '    /// @notice Info of each MCV2 pool.\n', '    /// `allocPoint` The amount of allocation points assigned to the pool.\n', '    /// Also known as the amount of SUSHI to distribute per block.\n', '    struct PoolInfo {\n', '        uint128 accSushiPerShare;\n', '        uint64 lastRewardBlock;\n', '        uint64 allocPoint;\n', '    }\n', '\n', '    /// @notice Info of each pool.\n', '    mapping (uint256 => PoolInfo) public poolInfo;\n', '\n', '    uint256[] public poolIds;\n', '\n', '    /// @notice Info of each user that stakes LP tokens.\n', '    mapping (uint256 => mapping (address => UserInfo)) public userInfo;\n', '    /// @dev Total allocation points. Must be the sum of all allocation points in all pools.\n', '    uint256 totalAllocPoint;\n', '\n', '    uint256 public tokenPerBlock;\n', '    uint256 private constant ACC_TOKEN_PRECISION = 1e12;\n', '\n', '    address private immutable MASTERCHEF_V2;\n', '\n', '    event LogOnReward(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);\n', '    event LogPoolAddition(uint256 indexed pid, uint256 allocPoint);\n', '    event LogSetPool(uint256 indexed pid, uint256 allocPoint);\n', '    event LogUpdatePool(uint256 indexed pid, uint64 lastRewardBlock, uint256 lpSupply, uint256 accSushiPerShare);\n', '    event LogInit();\n', '\n', '    constructor (IERC20 _rewardToken, uint256 _tokenPerBlock, address _MASTERCHEF_V2) public {\n', '        rewardToken = _rewardToken;\n', '        tokenPerBlock = _tokenPerBlock;\n', '        MASTERCHEF_V2 = _MASTERCHEF_V2;\n', '    }\n', '\n', '\n', '    function onSushiReward (uint256 pid, address _user, address to, uint256, uint256 lpToken) onlyMCV2 override external {\n', '        PoolInfo memory pool = updatePool(pid);\n', '        UserInfo storage user = userInfo[pid][_user];\n', '        uint256 pending;\n', '        if (user.amount > 0) {\n', '            pending =\n', '                (user.amount.mul(pool.accSushiPerShare) / ACC_TOKEN_PRECISION).sub(\n', '                    user.rewardDebt\n', '                );\n', '            rewardToken.safeTransfer(to, pending);\n', '        }\n', '        user.amount = lpToken;\n', '        user.rewardDebt = lpToken.mul(pool.accSushiPerShare) / ACC_TOKEN_PRECISION;\n', '        emit LogOnReward(_user, pid, pending, to);\n', '    }\n', '    \n', '    function pendingTokens(uint256 pid, address user, uint256) override external view returns (IERC20[] memory rewardTokens, uint256[] memory rewardAmounts) {\n', '        IERC20[] memory _rewardTokens = new IERC20[](1);\n', '        _rewardTokens[0] = (rewardToken);\n', '        uint256[] memory _rewardAmounts = new uint256[](1);\n', '        _rewardAmounts[0] = pendingToken(pid, user);\n', '        return (_rewardTokens, _rewardAmounts);\n', '    }\n', '\n', '    modifier onlyMCV2 {\n', '        require(\n', '            msg.sender == MASTERCHEF_V2,\n', '            "Only MCV2 can call this function."\n', '        );\n', '        _;\n', '    }\n', '\n', '    /// @notice Returns the number of MCV2 pools.\n', '    function poolLength() public view returns (uint256 pools) {\n', '        pools = poolIds.length;\n', '    }\n', '\n', '    /// @notice Add a new LP to the pool.  Can only be called by the owner.\n', '    /// DO NOT add the same LP token more than once. Rewards will be messed up if you do.\n', '    /// @param allocPoint AP of the new pool.\n', '    /// @param _pid Pid on MCV2\n', '    function add(uint256 allocPoint, uint256 _pid) public onlyOwner {\n', '        require(poolInfo[_pid].lastRewardBlock == 0, "Pool already exists");\n', '        uint256 lastRewardBlock = block.number;\n', '        totalAllocPoint = totalAllocPoint.add(allocPoint);\n', '\n', '        poolInfo[_pid] = PoolInfo({\n', '            allocPoint: allocPoint.to64(),\n', '            lastRewardBlock: lastRewardBlock.to64(),\n', '            accSushiPerShare: 0\n', '        });\n', '        poolIds.push(_pid);\n', '        emit LogPoolAddition(_pid, allocPoint);\n', '    }\n', '\n', "    /// @notice Update the given pool's SUSHI allocation point and `IRewarder` contract. Can only be called by the owner.\n", '    /// @param _pid The index of the pool. See `poolInfo`.\n', '    /// @param _allocPoint New AP of the pool.\n', '    function set(uint256 _pid, uint256 _allocPoint) public onlyOwner {\n', '        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);\n', '        poolInfo[_pid].allocPoint = _allocPoint.to64();\n', '        emit LogSetPool(_pid, _allocPoint);\n', '    }\n', '\n', '    /// @notice View function to see pending Token\n', '    /// @param _pid The index of the pool. See `poolInfo`.\n', '    /// @param _user Address of user.\n', '    /// @return pending SUSHI reward for a given user.\n', '    function pendingToken(uint256 _pid, address _user) public view returns (uint256 pending) {\n', '        PoolInfo memory pool = poolInfo[_pid];\n', '        UserInfo storage user = userInfo[_pid][_user];\n', '        uint256 accSushiPerShare = pool.accSushiPerShare;\n', '        uint256 lpSupply = MasterChefV2(MASTERCHEF_V2).lpToken(_pid).balanceOf(MASTERCHEF_V2);\n', '        if (block.number > pool.lastRewardBlock && lpSupply != 0) {\n', '            uint256 blocks = block.number.sub(pool.lastRewardBlock);\n', '            uint256 sushiReward = blocks.mul(tokenPerBlock).mul(pool.allocPoint) / totalAllocPoint;\n', '            accSushiPerShare = accSushiPerShare.add(sushiReward.mul(ACC_TOKEN_PRECISION) / lpSupply);\n', '        }\n', '        pending = (user.amount.mul(accSushiPerShare) / ACC_TOKEN_PRECISION).sub(user.rewardDebt);\n', '    }\n', '\n', '    /// @notice Update reward variables for all pools. Be careful of gas spending!\n', '    /// @param pids Pool IDs of all to be updated. Make sure to update all active pools.\n', '    function massUpdatePools(uint256[] calldata pids) external {\n', '        uint256 len = pids.length;\n', '        for (uint256 i = 0; i < len; ++i) {\n', '            updatePool(pids[i]);\n', '        }\n', '    }\n', '\n', '    /// @notice Update reward variables of the given pool.\n', '    /// @param pid The index of the pool. See `poolInfo`.\n', '    /// @return pool Returns the pool that was updated.\n', '    function updatePool(uint256 pid) public returns (PoolInfo memory pool) {\n', '        pool = poolInfo[pid];\n', '        require(pool.lastRewardBlock != 0, "Pool does not exist");\n', '        if (block.number > pool.lastRewardBlock) {\n', '            uint256 lpSupply = MasterChefV2(MASTERCHEF_V2).lpToken(pid).balanceOf(MASTERCHEF_V2);\n', '\n', '            if (lpSupply > 0) {\n', '                uint256 blocks = block.number.sub(pool.lastRewardBlock);\n', '                uint256 sushiReward = blocks.mul(tokenPerBlock).mul(pool.allocPoint) / totalAllocPoint;\n', '                pool.accSushiPerShare = pool.accSushiPerShare.add((sushiReward.mul(ACC_TOKEN_PRECISION) / lpSupply).to128());\n', '            }\n', '            pool.lastRewardBlock = block.number.to64();\n', '            poolInfo[pid] = pool;\n', '            emit LogUpdatePool(pid, pool.lastRewardBlock, lpSupply, pool.accSushiPerShare);\n', '        }\n', '    }\n', '}']
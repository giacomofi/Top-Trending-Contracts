['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-21\n', '*/\n', '\n', '// File: contracts/intf/IERC20.sol\n', '\n', '// This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.9;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '}\n', '\n', '// File: contracts/lib/SafeMath.sol\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "MUL_ERROR");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "DIVIDING_ERROR");\n', '        return a / b;\n', '    }\n', '\n', '    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 quotient = div(a, b);\n', '        uint256 remainder = a - quotient * b;\n', '        if (remainder > 0) {\n', '            return quotient + 1;\n', '        } else {\n', '            return quotient;\n', '        }\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SUB_ERROR");\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "ADD_ERROR");\n', '        return c;\n', '    }\n', '\n', '    function sqrt(uint256 x) internal pure returns (uint256 y) {\n', '        uint256 z = x / 2 + 1;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/lib/SafeERC20.sol\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require(\n', '            (value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/lib/DecimalMath.sol\n', '\n', '\n', '/**\n', ' * @title DecimalMath\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Functions for fixed point number with 18 decimals\n', ' */\n', 'library DecimalMath {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 internal constant ONE = 10**18;\n', '    uint256 internal constant ONE2 = 10**36;\n', '\n', '    function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {\n', '        return target.mul(d) / (10**18);\n', '    }\n', '\n', '    function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {\n', '        return target.mul(d).divCeil(10**18);\n', '    }\n', '\n', '    function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {\n', '        return target.mul(10**18).div(d);\n', '    }\n', '\n', '    function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {\n', '        return target.mul(10**18).divCeil(d);\n', '    }\n', '\n', '    function reciprocalFloor(uint256 target) internal pure returns (uint256) {\n', '        return uint256(10**36).div(target);\n', '    }\n', '\n', '    function reciprocalCeil(uint256 target) internal pure returns (uint256) {\n', '        return uint256(10**36).divCeil(target);\n', '    }\n', '}\n', '\n', '// File: contracts/lib/InitializableOwnable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Ownership related functions\n', ' */\n', 'contract InitializableOwnable {\n', '    address public _OWNER_;\n', '    address public _NEW_OWNER_;\n', '    bool internal _INITIALIZED_;\n', '\n', '    // ============ Events ============\n', '\n', '    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    // ============ Modifiers ============\n', '\n', '    modifier notInitialized() {\n', '        require(!_INITIALIZED_, "DODO_INITIALIZED");\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _OWNER_, "NOT_OWNER");\n', '        _;\n', '    }\n', '\n', '    // ============ Functions ============\n', '\n', '    function initOwner(address newOwner) public notInitialized {\n', '        _INITIALIZED_ = true;\n', '        _OWNER_ = newOwner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        emit OwnershipTransferPrepared(_OWNER_, newOwner);\n', '        _NEW_OWNER_ = newOwner;\n', '    }\n', '\n', '    function claimOwnership() public {\n', '        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");\n', '        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);\n', '        _OWNER_ = _NEW_OWNER_;\n', '        _NEW_OWNER_ = address(0);\n', '    }\n', '}\n', '\n', '// File: contracts/lib/Ownable.sol\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Ownership related functions\n', ' */\n', 'contract Ownable {\n', '    address public _OWNER_;\n', '    address public _NEW_OWNER_;\n', '\n', '    // ============ Events ============\n', '\n', '    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    // ============ Modifiers ============\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _OWNER_, "NOT_OWNER");\n', '        _;\n', '    }\n', '\n', '    // ============ Functions ============\n', '\n', '    constructor() internal {\n', '        _OWNER_ = msg.sender;\n', '        emit OwnershipTransferred(address(0), _OWNER_);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        emit OwnershipTransferPrepared(_OWNER_, newOwner);\n', '        _NEW_OWNER_ = newOwner;\n', '    }\n', '\n', '    function claimOwnership() external {\n', '        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");\n', '        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);\n', '        _OWNER_ = _NEW_OWNER_;\n', '        _NEW_OWNER_ = address(0);\n', '    }\n', '}\n', '\n', '// File: contracts/DODOToken/DODOMineV2/RewardVault.sol\n', '\n', '\n', '\n', 'interface IRewardVault {\n', '    function reward(address to, uint256 amount) external;\n', '    function withdrawLeftOver(address to, uint256 amount) external; \n', '}\n', '\n', 'contract RewardVault is Ownable {\n', '    using SafeERC20 for IERC20;\n', '\n', '    address public rewardToken;\n', '\n', '    constructor(address _rewardToken) public {\n', '        rewardToken = _rewardToken;\n', '    }\n', '\n', '    function reward(address to, uint256 amount) external onlyOwner {\n', '        IERC20(rewardToken).safeTransfer(to, amount);\n', '    }\n', '\n', '    function withdrawLeftOver(address to,uint256 amount) external onlyOwner {\n', '        uint256 leftover = IERC20(rewardToken).balanceOf(address(this));\n', '        require(amount <= leftover, "VAULT_NOT_ENOUGH");\n', '        IERC20(rewardToken).safeTransfer(to, amount);\n', '    }\n', '}\n', '\n', '// File: contracts/DODOToken/DODOMineV2/BaseMine.sol\n', '\n', '\n', '\n', '\n', 'contract BaseMine is InitializableOwnable {\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint256;\n', '\n', '    // ============ Storage ============\n', '\n', '    struct RewardTokenInfo {\n', '        address rewardToken;\n', '        uint256 startBlock;\n', '        uint256 endBlock;\n', '        address rewardVault;\n', '        uint256 rewardPerBlock;\n', '        uint256 accRewardPerShare;\n', '        uint256 lastRewardBlock;\n', '        mapping(address => uint256) userRewardPerSharePaid;\n', '        mapping(address => uint256) userRewards;\n', '    }\n', '\n', '    RewardTokenInfo[] public rewardTokenInfos;\n', '\n', '    uint256 internal _totalSupply;\n', '    mapping(address => uint256) internal _balances;\n', '\n', '    // ============ Event =============\n', '\n', '    event Claim(uint256 indexed i, address indexed user, uint256 reward);\n', '    event UpdateReward(uint256 indexed i, uint256 rewardPerBlock);\n', '    event UpdateEndBlock(uint256 indexed i, uint256 endBlock);\n', '    event NewRewardToken(uint256 indexed i, address rewardToken);\n', '    event RemoveRewardToken(address rewardToken);\n', '    event WithdrawLeftOver(address owner, uint256 i);\n', '\n', '    // ============ View  ============\n', '\n', '    function getPendingReward(address user, uint256 i) public view returns (uint256) {\n', '        require(i<rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");\n', '        RewardTokenInfo storage rt = rewardTokenInfos[i];\n', '        uint256 accRewardPerShare = rt.accRewardPerShare;\n', '        if (rt.lastRewardBlock != block.number) {\n', '            accRewardPerShare = _getAccRewardPerShare(i);\n', '        }\n', '        return\n', '            DecimalMath.mulFloor(\n', '                balanceOf(user), \n', '                accRewardPerShare.sub(rt.userRewardPerSharePaid[user])\n', '            ).add(rt.userRewards[user]);\n', '    }\n', '\n', '    function getPendingRewardByToken(address user, address rewardToken) external view returns (uint256) {\n', '        return getPendingReward(user, getIdByRewardToken(rewardToken));\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address user) public view returns (uint256) {\n', '        return _balances[user];\n', '    }\n', '\n', '    function getRewardTokenById(uint256 i) external view returns (address) {\n', '        require(i<rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");\n', '        RewardTokenInfo memory rt = rewardTokenInfos[i];\n', '        return rt.rewardToken;\n', '    }\n', '\n', '    function getIdByRewardToken(address rewardToken) public view returns(uint256) {\n', '        uint256 len = rewardTokenInfos.length;\n', '        for (uint256 i = 0; i < len; i++) {\n', '            if (rewardToken == rewardTokenInfos[i].rewardToken) {\n', '                return i;\n', '            }\n', '        }\n', '        require(false, "DODOMineV2: TOKEN_NOT_FOUND");\n', '    }\n', '\n', '    function getRewardNum() external view returns(uint256) {\n', '        return rewardTokenInfos.length;\n', '    }\n', '\n', '    // ============ Claim ============\n', '\n', '    function claimReward(uint256 i) public {\n', '        require(i<rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");\n', '        _updateReward(msg.sender, i);\n', '        RewardTokenInfo storage rt = rewardTokenInfos[i];\n', '        uint256 reward = rt.userRewards[msg.sender];\n', '        if (reward > 0) {\n', '            rt.userRewards[msg.sender] = 0;\n', '            IRewardVault(rt.rewardVault).reward(msg.sender, reward);\n', '            emit Claim(i, msg.sender, reward);\n', '        }\n', '    }\n', '\n', '    function claimAllRewards() external {\n', '        uint256 len = rewardTokenInfos.length;\n', '        for (uint256 i = 0; i < len; i++) {\n', '            claimReward(i);\n', '        }\n', '    }\n', '\n', '    // =============== Ownable  ================\n', '\n', '    function addRewardToken(\n', '        address rewardToken,\n', '        uint256 rewardPerBlock,\n', '        uint256 startBlock,\n', '        uint256 endBlock\n', '    ) external onlyOwner {\n', '        require(rewardToken != address(0), "DODOMineV2: TOKEN_INVALID");\n', '        require(startBlock > block.number, "DODOMineV2: START_BLOCK_INVALID");\n', '        require(endBlock > startBlock, "DODOMineV2: DURATION_INVALID");\n', '\n', '        uint256 len = rewardTokenInfos.length;\n', '        for (uint256 i = 0; i < len; i++) {\n', '            require(\n', '                rewardToken != rewardTokenInfos[i].rewardToken,\n', '                "DODOMineV2: TOKEN_ALREADY_ADDED"\n', '            );\n', '        }\n', '\n', '        RewardTokenInfo storage rt = rewardTokenInfos.push();\n', '        rt.rewardToken = rewardToken;\n', '        rt.startBlock = startBlock;\n', '        rt.endBlock = endBlock;\n', '        rt.rewardPerBlock = rewardPerBlock;\n', '        rt.rewardVault = address(new RewardVault(rewardToken));\n', '\n', '        emit NewRewardToken(len, rewardToken);\n', '    }\n', '\n', '    function removeRewardToken(address rewardToken) external onlyOwner {\n', '        uint256 len = rewardTokenInfos.length;\n', '        for (uint256 i = 0; i < len; i++) {\n', '            if (rewardToken == rewardTokenInfos[i].rewardToken) {\n', '                if(i != len - 1) {\n', '                    rewardTokenInfos[i] = rewardTokenInfos[len - 1];\n', '                }\n', '                rewardTokenInfos.pop();\n', '                emit RemoveRewardToken(rewardToken);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '\n', '    function setEndBlock(uint256 i, uint256 newEndBlock)\n', '        external\n', '        onlyOwner\n', '    {\n', '        require(i < rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");\n', '        _updateReward(address(0), i);\n', '        RewardTokenInfo storage rt = rewardTokenInfos[i];\n', '\n', '        require(block.number < newEndBlock, "DODOMineV2: END_BLOCK_INVALID");\n', '        require(block.number > rt.startBlock, "DODOMineV2: NOT_START");\n', '        require(block.number < rt.endBlock, "DODOMineV2: ALREADY_CLOSE");\n', '\n', '        rt.endBlock = newEndBlock;\n', '        emit UpdateEndBlock(i, newEndBlock);\n', '    }\n', '\n', '    function setReward(uint256 i, uint256 newRewardPerBlock)\n', '        external\n', '        onlyOwner\n', '    {\n', '        require(i < rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");\n', '        _updateReward(address(0), i);\n', '        RewardTokenInfo storage rt = rewardTokenInfos[i];\n', '        \n', '        require(block.number < rt.endBlock, "DODOMineV2: ALREADY_CLOSE");\n', '\n', '        rt.rewardPerBlock = newRewardPerBlock;\n', '        emit UpdateReward(i, newRewardPerBlock);\n', '    }\n', '\n', '    function withdrawLeftOver(uint256 i, uint256 amount) external onlyOwner {\n', '        require(i < rewardTokenInfos.length, "DODOMineV2: REWARD_ID_NOT_FOUND");\n', '        \n', '        RewardTokenInfo storage rt = rewardTokenInfos[i];\n', '        require(block.number > rt.endBlock, "DODOMineV2: MINING_NOT_FINISHED");\n', '\n', '        IRewardVault(rt.rewardVault).withdrawLeftOver(msg.sender,amount);\n', '\n', '        emit WithdrawLeftOver(msg.sender, i);\n', '    }\n', '\n', '\n', '    // ============ Internal  ============\n', '\n', '    function _updateReward(address user, uint256 i) internal {\n', '        RewardTokenInfo storage rt = rewardTokenInfos[i];\n', '        if (rt.lastRewardBlock != block.number){\n', '            rt.accRewardPerShare = _getAccRewardPerShare(i);\n', '            rt.lastRewardBlock = block.number;\n', '        }\n', '        if (user != address(0)) {\n', '            rt.userRewards[user] = getPendingReward(user, i);\n', '            rt.userRewardPerSharePaid[user] = rt.accRewardPerShare;\n', '        }\n', '    }\n', '\n', '    function _updateAllReward(address user) internal {\n', '        uint256 len = rewardTokenInfos.length;\n', '        for (uint256 i = 0; i < len; i++) {\n', '            _updateReward(user, i);\n', '        }\n', '    }\n', '\n', '    function _getUnrewardBlockNum(uint256 i) internal view returns (uint256) {\n', '        RewardTokenInfo memory rt = rewardTokenInfos[i];\n', '        if (block.number < rt.startBlock || rt.lastRewardBlock > rt.endBlock) {\n', '            return 0;\n', '        }\n', '        uint256 start = rt.lastRewardBlock < rt.startBlock ? rt.startBlock : rt.lastRewardBlock;\n', '        uint256 end = rt.endBlock < block.number ? rt.endBlock : block.number;\n', '        return end.sub(start);\n', '    }\n', '\n', '    function _getAccRewardPerShare(uint256 i) internal view returns (uint256) {\n', '        RewardTokenInfo memory rt = rewardTokenInfos[i];\n', '        if (totalSupply() == 0) {\n', '            return rt.accRewardPerShare;\n', '        }\n', '        return\n', '            rt.accRewardPerShare.add(\n', '                DecimalMath.divFloor(_getUnrewardBlockNum(i).mul(rt.rewardPerBlock), totalSupply())\n', '            );\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/DODOToken/DODOMineV2/ERC20Mine.sol\n', '\n', '\n', '\n', 'contract ERC20Mine is BaseMine {\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint256;\n', '\n', '    // ============ Storage ============\n', '\n', '    address public _TOKEN_;\n', '\n', '    function init(address owner, address token) external {\n', '        super.initOwner(owner);\n', '        _TOKEN_ = token;\n', '    }\n', '\n', '    // ============ Event  ============\n', '\n', '    event Deposit(address indexed user, uint256 amount);\n', '    event Withdraw(address indexed user, uint256 amount);\n', '\n', '    // ============ Deposit && Withdraw && Exit ============\n', '\n', '    function deposit(uint256 amount) external {\n', '        require(amount > 0, "DODOMineV2: CANNOT_DEPOSIT_ZERO");\n', '\n', '        _updateAllReward(msg.sender);\n', '\n', '        uint256 erc20OriginBalance = IERC20(_TOKEN_).balanceOf(address(this));\n', '        IERC20(_TOKEN_).safeTransferFrom(msg.sender, address(this), amount);\n', '        uint256 actualStakeAmount = IERC20(_TOKEN_).balanceOf(address(this)).sub(erc20OriginBalance);\n', '        \n', '        _totalSupply = _totalSupply.add(actualStakeAmount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(actualStakeAmount);\n', '\n', '        emit Deposit(msg.sender, actualStakeAmount);\n', '    }\n', '\n', '    function withdraw(uint256 amount) external {\n', '        require(amount > 0, "DODOMineV2: CANNOT_WITHDRAW_ZERO");\n', '\n', '        _updateAllReward(msg.sender);\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '        IERC20(_TOKEN_).safeTransfer(msg.sender, amount);\n', '\n', '        emit Withdraw(msg.sender, amount);\n', '    }\n', '}']
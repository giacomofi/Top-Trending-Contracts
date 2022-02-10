['// SPDX-License-Identifier: MIT\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '// file: SafeERC20\n', 'pragma solidity ^0.6.12;\n', '\n', '// NOTE: this interface lacks return values for transfer/transferFrom/approve on purpose,\n', '// as we use the SafeERC20 library to check the return value\n', 'interface GeneralERC20 {\n', '    function transfer(address to, uint256 amount) external;\n', '    function transferFrom(address from, address to, uint256 amount) external;\n', '    function approve(address spender, uint256 amount) external;\n', '    function balanceOf(address spender) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '}\n', '\n', 'library SafeERC20 {\n', '    function checkSuccess()\n', '        private\n', '        pure\n', '        returns (bool)\n', '    {\n', '        uint256 returnValue = 0;\n', '\n', '        assembly {\n', '            // check number of bytes returned from last function call\n', '            switch returndatasize()\n', '\n', '            // no bytes returned: assume success\n', '            case 0x0 {\n', '                returnValue := 1\n', '            }\n', '\n', '            // 32 bytes returned: check if non-zero\n', '            case 0x20 {\n', '                // copy 32 bytes into scratch space\n', '                returndatacopy(0x0, 0x0, 0x20)\n', '\n', '                // load those bytes into returnValue\n', '                returnValue := mload(0x0)\n', '            }\n', '\n', "            // not sure what was returned: don't mark as success\n", '            default { }\n', '        }\n', '\n', '        return returnValue != 0;\n', '    }\n', '\n', '    function transfer(address token, address to, uint256 amount) internal {\n', '        GeneralERC20(token).transfer(to, amount);\n', '        require(checkSuccess());\n', '    }\n', '\n', '    function transferFrom(address token, address from, address to, uint256 amount) internal {\n', '        GeneralERC20(token).transferFrom(from, to, amount);\n', '        require(checkSuccess());\n', '    }\n', '\n', '    function approve(address token, address spender, uint256 amount) internal {\n', '        GeneralERC20(token).approve(spender, amount);\n', '        require(checkSuccess());\n', '    }\n', '}\n', '\n', '\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol; changed to remove context\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = msg.sender;\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/ERC20.sol\n', '\n', '\n', '// MasterChef is now repurposed to distribute existing ADX.\n', '//\n', "// Note that it's ownable and the owner wields tremendous power.\n", '//\n', "// Have fun reading it. Hopefully it's bug-free. Амин.\n", 'contract MasterChef is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // Info of each user.\n', '    struct UserInfo {\n', '        uint256 amount; // How many LP tokens the user has provided.\n', '        uint256 rewardDebt; // Reward debt. See explanation below.\n', '        //\n', '        // We do some fancy math here. Basically, any point in time, the amount of ADXs\n', '        // entitled to a user but is pending to be distributed is:\n', '        //\n', '        //   pending reward = (user.amount * pool.accADXPerShare) - user.rewardDebt\n', '        //\n', "        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:\n", "        //   1. The pool's `accADXPerShare` (and `lastRewardBlock`) gets updated.\n", '        //   2. User receives the pending reward sent to his/her address.\n', "        //   3. User's `amount` gets updated.\n", "        //   4. User's `rewardDebt` gets updated.\n", '    }\n', '\n', '    // Info of each pool.\n', '    struct PoolInfo {\n', '        IERC20 lpToken; // Address of LP token contract.\n', '        uint256 allocPoint; // How many allocation points assigned to this pool. ADXs to distribute per block.\n', '        uint256 lastRewardBlock; // Last block number that ADXs distribution occurs.\n', '        uint256 accADXPerShare; // Accumulated ADXs per share, times 1e12. See below.\n', '    }\n', '\n', '    // The ADX TOKEN!\n', '    IERC20 public ADX;\n', '    // ADX tokens distributed per block.\n', '    uint256 public ADXPerBlock;\n', '\n', '    // Info of each pool.\n', '    PoolInfo[] public poolInfo;\n', '    // Info of each user that stakes LP tokens.\n', '    mapping(uint256 => mapping(address => UserInfo)) public userInfo;\n', '    // Total allocation points. Must be the sum of all allocation points in all pools.\n', '    uint256 public totalAllocPoint = 0;\n', '    // The block number when ADX mining starts.\n', '    uint256 public startBlock;\n', '\n', '    // Events\n', '    event Recovered(address token, uint256 amount);\n', '    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);\n', '    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);\n', '    event EmergencyWithdraw(\n', '        address indexed user,\n', '        uint256 indexed pid,\n', '        uint256 amount\n', '    );\n', '\n', '    constructor(\n', '        IERC20 _ADX,\n', '        uint256 _ADXPerBlock,\n', '        uint256 _startBlock\n', '    ) public {\n', '        ADX = _ADX;\n', '        ADXPerBlock = _ADXPerBlock;\n', '        startBlock = _startBlock;\n', '    }\n', '\n', '    function poolLength() external view returns (uint256) {\n', '        return poolInfo.length;\n', '    }\n', '\n', '    // Add a new lp to the pool. Can only be called by the owner.\n', '    // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.\n', "    //  Not in a big way, but the payout will be less than the planned payout per block cause we divide the user's deposit by the total lpToken.balanceOf(this)\n", '    function add(\n', '        uint256 _allocPoint,\n', '        IERC20 _lpToken,\n', '        bool _withUpdate\n', '    ) public onlyOwner {\n', '        if (_withUpdate) {\n', '            massUpdatePools();\n', '        }\n', '        uint256 lastRewardBlock = block.number > startBlock\n', '            ? block.number\n', '            : startBlock;\n', '        totalAllocPoint = totalAllocPoint.add(_allocPoint);\n', '        poolInfo.push(\n', '            PoolInfo({\n', '                lpToken: _lpToken,\n', '                allocPoint: _allocPoint,\n', '                lastRewardBlock: lastRewardBlock,\n', '                accADXPerShare: 0\n', '            })\n', '        );\n', '    }\n', '\n', "    // XXX general note on _withUpdate and why it's optional\n", '    // Some have pointed out pending (unwithdrawn) rewards can be modified on the fly if `set`/`setADXPerBlock` is called\n', '    // without `_withUpdate` set to true\n', "    // There's a reason to keep this as an optional flag, which is to ensure it can be called in case `massUpdatePools`\n", '    // is failing for whatever reason (eg runs out of gas)\n', '    // In any case, those methods will be placed behind a timelock to ensure this cannot happen\n', '\n', "    // Update the given pool's ADX allocation point. Can only be called by the owner.\n", '    function set(\n', '        uint256 _pid,\n', '        uint256 _allocPoint,\n', '        bool _withUpdate\n', '    ) public onlyOwner {\n', '\t// XXX you can allocate for a nonexistant pool\n', '        if (_withUpdate) {\n', '            massUpdatePools();\n', '        }\n', '        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(\n', '            _allocPoint\n', '        );\n', '        poolInfo[_pid].allocPoint = _allocPoint;\n', '    }\n', '\n', '    // View function to see pending ADXs on frontend.\n', '    function pendingADX(uint256 _pid, address _user)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserInfo storage user = userInfo[_pid][_user];\n', '        uint256 accADXPerShare = pool.accADXPerShare;\n', '        uint256 lpSupply = pool.lpToken.balanceOf(address(this));\n', '        if (block.number > pool.lastRewardBlock && lpSupply != 0) {\n', '            uint256 ADXReward = block.number.sub(pool.lastRewardBlock)\n', '                .mul(ADXPerBlock)\n', '                .mul(pool.allocPoint)\n', '                .div(totalAllocPoint);\n', '            accADXPerShare = accADXPerShare.add(\n', '                ADXReward.mul(1e12).div(lpSupply)\n', '            );\n', '        }\n', '        return\n', '            user.amount.mul(accADXPerShare).div(1e12).sub(user.rewardDebt);\n', '    }\n', '\n', '    // Update reward variables for all pools. Be careful of gas spending!\n', '    function massUpdatePools() public {\n', '        uint256 length = poolInfo.length;\n', '        for (uint256 pid = 0; pid < length; ++pid) {\n', '            updatePool(pid);\n', '        }\n', '    }\n', '\n', '    // Update reward variables of the given pool to be up-to-date.\n', '    function updatePool(uint256 _pid) public {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        if (block.number <= pool.lastRewardBlock) {\n', '            return;\n', '        }\n', '        uint256 lpSupply = pool.lpToken.balanceOf(address(this));\n', '        if (lpSupply == 0) {\n', '            pool.lastRewardBlock = block.number;\n', '            return;\n', '        }\n', '        uint256 ADXReward = block.number.sub(pool.lastRewardBlock)\n', '            .mul(ADXPerBlock)\n', '            .mul(pool.allocPoint)\n', '            .div(totalAllocPoint);\n', '        // XXX The original masterchef mints here; our version expects to be pre-funded with ADX\n', '\tpool.accADXPerShare = pool.accADXPerShare.add(\n', '            ADXReward.mul(1e12).div(lpSupply)\n', '        );\n', '        pool.lastRewardBlock = block.number;\n', '    }\n', '\n', '    // Deposit LP tokens to MasterChef for ADX allocation.\n', '    function deposit(uint256 _pid, uint256 _amount) public {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserInfo storage user = userInfo[_pid][msg.sender];\n', '        updatePool(_pid);\n', '        if (user.amount > 0) {\n', '            uint256 pending = user\n', '                .amount\n', '                .mul(pool.accADXPerShare)\n', '                .div(1e12)\n', '                .sub(user.rewardDebt);\n', '            safeADXTransfer(msg.sender, pending);\n', '        }\n', '        SafeERC20.transferFrom(\n', '            address(pool.lpToken),\n', '            address(msg.sender),\n', '            address(this),\n', '            _amount\n', '        );\n', '        user.amount = user.amount.add(_amount);\n', '        user.rewardDebt = user.amount.mul(pool.accADXPerShare).div(1e12);\n', '        emit Deposit(msg.sender, _pid, _amount);\n', '    }\n', '\n', '    // Withdraw LP tokens from MasterChef.\n', '    function withdraw(uint256 _pid, uint256 _amount) public {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserInfo storage user = userInfo[_pid][msg.sender];\n', '        require(user.amount >= _amount, "withdraw: not good");\n', '        updatePool(_pid);\n', '        uint256 pending = user.amount.mul(pool.accADXPerShare).div(1e12).sub(\n', '            user.rewardDebt\n', '        );\n', '        safeADXTransfer(msg.sender, pending);\n', '        user.amount = user.amount.sub(_amount);\n', '        user.rewardDebt = user.amount.mul(pool.accADXPerShare).div(1e12);\n', '        SafeERC20.transfer(address(pool.lpToken), address(msg.sender), _amount);\n', '        emit Withdraw(msg.sender, _pid, _amount);\n', '    }\n', '\n', '    // Withdraw without caring about rewards. EMERGENCY ONLY.\n', '    function emergencyWithdraw(uint256 _pid) public {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserInfo storage user = userInfo[_pid][msg.sender];\n', '        SafeERC20.transfer(address(pool.lpToken), address(msg.sender), user.amount);\n', '        emit EmergencyWithdraw(msg.sender, _pid, user.amount);\n', '        user.amount = 0;\n', '        user.rewardDebt = 0;\n', '    }\n', '\n', '    // Safe ADX transfer function, just in case if rounding error causes pool to not have enough ADXs.\n', '    function safeADXTransfer(address _to, uint256 _amount) internal {\n', '        uint256 ADXBal = ADX.balanceOf(address(this));\n', '        if (_amount > ADXBal) {\n', '            require((_amount - ADXBal) < 10e17, "safeADXTransfer: rounding error too big, contract may be underfunded?");\n', '            ADX.transfer(_to, ADXBal);\n', '        } else {\n', '            ADX.transfer(_to, _amount);\n', '        }\n', '    }\n', '\n', '    // AdEx-specific masterchef extensions\n', '    function setADXPerBlock(uint256 _ADXPerBlock, bool _withUpdate) public onlyOwner {\n', '        if (_withUpdate) {\n', '            massUpdatePools();\n', '        }\n', '        ADXPerBlock = _ADXPerBlock;\n', '    }\n', '}']
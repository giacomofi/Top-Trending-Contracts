['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'import "./Ownable.sol";\n', 'import "./SafeMath.sol";\n', 'import "./IERC20.sol";\n', '\n', 'contract PinknodeLiquidityMining is Ownable {\n', '\n', '\tusing SafeMath for uint;\n', '\n', '\t// Events\n', '\tevent Deposit(uint256 _timestmap, address indexed _address, uint256 indexed _pid, uint256 _amount);\n', '\tevent Withdraw(uint256 _timestamp, address indexed _address, uint256 indexed _pid, uint256 _amount);\n', '\tevent EmergencyWithdraw(uint256 _timestamp, address indexed _address, uint256 indexed _pid, uint256 _amount);\n', '\n', '\t// PNODE Token Contract & Funding Address\n', '\tIERC20 public constant PNODE = IERC20(0xAF691508BA57d416f895e32a1616dA1024e882D2);\n', '\taddress public fundingAddress = 0xF7897E58A72dFf79Ab8538647A62fecEf8344ffe;\n', '\n', '\tstruct LPInfo {\n', '\t\t// Address of LP token contract\n', '\t\tIERC20 lpToken;\n', '\n', '\t\t// LP reward per block\n', '\t\tuint256 rewardPerBlock;\n', '\n', '\t\t// Last reward block\n', '\t\tuint256 lastRewardBlock;\n', '\n', '\t\t// Accumulated reward per share (times 1e12 to minimize rounding errors)\n', '\t\tuint256 accRewardPerShare;\n', '\t}\n', '\n', '\tstruct Staker {\n', '\t\t// Total Amount Staked\n', '\t\tuint256 amountStaked;\n', '\n', '\t\t// Reward Debt (pending reward = (staker.amountStaked * pool.accRewardPerShare) - staker.rewardDebt)\n', '\t\tuint256 rewardDebt;\n', '\t}\n', '\n', '\t// Liquidity Pools\n', '\tLPInfo[] public liquidityPools;\n', '\n', '\t// Info of each user that stakes LP tokens.\n', '\t// poolId => address => staker\n', '    mapping (uint256 => mapping (address => Staker)) public stakers;\n', '\n', '    // Starting block for mining\n', '    uint256 public startBlock;\n', '\n', '    // End block for mining (Will be ongoing if unset/0)\n', '    uint256 public endBlock;\n', '\n', '\t/**\n', '     * @dev Constructor\n', '     */\n', '\n', '\tconstructor(uint256 _startBlock) public {\n', '\t\tstartBlock = _startBlock;\n', '\t}\n', '\n', '\t/**\n', '     * @dev Contract Modifiers\n', '     */\n', '\n', '\tfunction updateFundingAddress(address _address) public onlyOwner {\n', '\t\tfundingAddress = _address;\n', '\t}\n', '\n', '\tfunction updateStartBlock(uint256 _startBlock) public onlyOwner {\n', '\t\trequire(startBlock > block.number, "Mining has started, unable to update startBlock");\n', '\t\trequire(_startBlock > block.number, "startBlock has to be in the future");\n', '\n', '        for (uint256 i = 0; i < liquidityPools.length; i++) {\n', '            LPInfo storage pool = liquidityPools[i];\n', '            pool.lastRewardBlock = _startBlock;\n', '        }\n', '\n', '\t\tstartBlock = _startBlock;\n', '\t}\n', '\n', '\tfunction updateEndBlock(uint256 _endBlock) public onlyOwner {\n', '\t\trequire(endBlock > block.number || endBlock == 0, "Mining has ended, unable to update endBlock");\n', '\t\trequire(_endBlock > block.number, "endBlock has to be in the future");\n', '\n', '\t\tendBlock = _endBlock;\n', '\t}\n', '\n', '\t/**\n', '     * @dev Liquidity Pool functions\n', '     */\n', '\n', '    // Add liquidity pool\n', '    function addLiquidityPool(IERC20 _lpToken, uint256 _rewardPerBlock) public onlyOwner {\n', '\n', '    \tuint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;\n', '\n', '    \tliquidityPools.push(LPInfo({\n', '            lpToken: _lpToken,\n', '            rewardPerBlock: _rewardPerBlock,\n', '            lastRewardBlock: lastRewardBlock,\n', '            accRewardPerShare: 0\n', '        }));\n', '    }\n', '\n', '    // Update LP rewardPerBlock\n', '    function updateRewardPerBlock(uint256 _pid, uint256 _rewardPerBlock) public onlyOwner {\n', '        updatePoolRewards(_pid);\n', '\n', '    \tliquidityPools[_pid].rewardPerBlock = _rewardPerBlock;\n', '    }\n', '\n', '    // Update pool rewards variables\n', '    function updatePoolRewards(uint256 _pid) public {\n', '    \tLPInfo storage pool = liquidityPools[_pid];\n', '\n', '    \tif (block.number <= pool.lastRewardBlock) {\n', '            return;\n', '        }\n', '\n', '        uint256 lpSupply = pool.lpToken.balanceOf(address(this));\n', '        if (lpSupply == 0) {\n', '            pool.lastRewardBlock = block.number;\n', '            return;\n', '        }\n', '\n', '        uint256 blockElapsed = 0;\n', '        if (block.number < endBlock || endBlock == 0) {\n', '            blockElapsed = (block.number).sub(pool.lastRewardBlock);\n', '        } else if (endBlock >= pool.lastRewardBlock) {\n', '            blockElapsed = endBlock.sub(pool.lastRewardBlock);\n', '        }\n', '\n', '        uint256 totalReward = blockElapsed.mul(pool.rewardPerBlock);\n', '        pool.accRewardPerShare = pool.accRewardPerShare.add(totalReward.mul(1e12).div(lpSupply));\n', '        pool.lastRewardBlock = block.number;\n', '    }\n', '\n', '\t/**\n', '     * @dev Stake functions\n', '     */\n', '\n', '\t// Deposit LP tokens into the liquidity pool\n', '\tfunction deposit(uint256 _pid, uint256 _amount) public {\n', '        require(block.number < endBlock || endBlock == 0);\n', '\n', '\t\tLPInfo storage pool = liquidityPools[_pid];\n', '        Staker storage user = stakers[_pid][msg.sender];\n', '\n', '        updatePoolRewards(_pid);\n', '\n', '        // Issue accrued rewards to user\n', '        if (user.amountStaked > 0) {\n', '            uint256 pending = user.amountStaked.mul(pool.accRewardPerShare).div(1e12).sub(user.rewardDebt);\n', '            if(pending > 0) {\n', '            \t_issueRewards(msg.sender, pending);\n', '            }\n', '        }\n', '\n', '        // Process deposit\n', '        if(_amount > 0) {\n', '            require(pool.lpToken.transferFrom(msg.sender, address(this), _amount));\n', '            user.amountStaked = user.amountStaked.add(_amount);\n', '        }\n', '\n', '        // Update user reward debt\n', '        user.rewardDebt = user.amountStaked.mul(pool.accRewardPerShare).div(1e12);\n', '\n', '        emit Deposit(block.timestamp, msg.sender, _pid, _amount);\n', '\t}\n', '\n', '\t// Withdraw LP tokens from liquidity pool\n', '\tfunction withdraw(uint256 _pid, uint256 _amount) public {\n', '\t\tLPInfo storage pool = liquidityPools[_pid];\n', '        Staker storage user = stakers[_pid][msg.sender];\n', '\n', '        require(user.amountStaked >= _amount, "Amount to withdraw more than amount staked");\n', '\n', '        updatePoolRewards(_pid);\n', '\n', '        // Issue accrued rewards to user\n', '        if (user.amountStaked > 0) {\n', '            uint256 pending = user.amountStaked.mul(pool.accRewardPerShare).div(1e12).sub(user.rewardDebt);\n', '            if(pending > 0) {\n', '            \t_issueRewards(msg.sender, pending);\n', '            }\n', '        }\n', '\n', '        // Process withdraw\n', '        if(_amount > 0) {\n', '            user.amountStaked = user.amountStaked.sub(_amount);\n', '            require(pool.lpToken.transfer(msg.sender, _amount));\n', '        }\n', '\n', '        // Update user reward debt\n', '        user.rewardDebt = user.amountStaked.mul(pool.accRewardPerShare).div(1e12);\n', '\n', '        emit Withdraw(block.timestamp, msg.sender, _pid, _amount);\n', '\t}\n', '\n', '\t// Withdraw without caring about rewards. EMERGENCY ONLY.\n', '    function emergencyWithdraw(uint256 _pid) public {\n', '        LPInfo storage pool = liquidityPools[_pid];\n', '        Staker storage user = stakers[_pid][msg.sender];\n', '\n', '        uint256 amount = user.amountStaked;\n', '        user.amountStaked = 0;\n', '        user.rewardDebt = 0;\n', '\n', '        require(pool.lpToken.transfer(msg.sender, amount));\n', '\n', '        emit EmergencyWithdraw(block.timestamp, msg.sender, _pid, amount);\n', '    }\n', '\n', '    // Function to issue rewards from funding address to user\n', '\tfunction _issueRewards(address _to, uint256 _amount) internal {\n', '\t\t// For transparency, rewards are transfered from funding address to contract then to user\n', '\n', '    \t// Transfer rewards from funding address to contract\n', '        require(PNODE.transferFrom(fundingAddress, address(this), _amount));\n', '\n', '        // Transfer rewards from contract to user\n', '        require(PNODE.transfer(_to, _amount));\n', '\t}\n', '\n', '\t// View function to see pending rewards on frontend.\n', '    function pendingRewards(uint256 _pid, address _user) external view returns (uint256) {\n', '        LPInfo storage pool = liquidityPools[_pid];\n', '        Staker storage user = stakers[_pid][_user];\n', '\n', '        uint256 accRewardPerShare = pool.accRewardPerShare;\n', '        uint256 lpSupply = pool.lpToken.balanceOf(address(this));\n', '\n', '        if (block.number > pool.lastRewardBlock && lpSupply != 0) {\n', '\n', '            uint256 blockElapsed = 0;\n', '            if (block.number < endBlock || endBlock == 0) {\n', '                blockElapsed = (block.number).sub(pool.lastRewardBlock);\n', '            } else if (endBlock >= pool.lastRewardBlock) {\n', '                blockElapsed = endBlock.sub(pool.lastRewardBlock);\n', '            }\n', '\n', '            uint256 totalReward = blockElapsed.mul(pool.rewardPerBlock);\n', '            accRewardPerShare = accRewardPerShare.add(totalReward.mul(1e12).div(lpSupply));\n', '        }\n', '\n', '        return user.amountStaked.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'import "./Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']
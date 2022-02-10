['//Be name KHODA\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: browser/Staking.sol\n', '\n', '//Be name khoda\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '\n', '\n', 'interface StakedToken {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', 'interface RewardToken {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '}\n', '\n', 'contract Staking is Ownable {\n', '\n', '    struct User {\n', '        uint256 depositAmount;\n', '        uint256 paidReward;\n', '    }\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => User) public users;\n', '\n', '    uint256 public rewardTillNowPerToken = 0;\n', '    uint256 public lastUpdatedBlock;\n', '    uint256 public rewardPerBlock;\n', '    uint256 public scale = 1e18;\n', '\n', '    uint256 public particleCollector = 0;\n', '    uint256 public daoShare;\n', '    uint256 public earlyFoundersShare;\n', '    address public daoWallet;\n', '    address public earlyFoundersWallet;\n', '\n', '    StakedToken public stakedToken;\n', '    RewardToken public rewardToken;\n', '\n', '    event Deposit(address user, uint256 amount);\n', '    event Withdraw(address user, uint256 amount);\n', '    event EmergencyWithdraw(address user, uint256 amount);\n', '    event RewardClaimed(address user, uint256 amount);\n', '    event RewardPerBlockChanged(uint256 oldValue, uint256 newValue);\n', '\n', '    constructor (address _stakedToken, address _rewardToken, uint256 _rewardPerBlock, uint256 _daoShare, uint256 _earlyFoundersShare) public {\n', '        stakedToken = StakedToken(_stakedToken);\n', '        rewardToken = RewardToken(_rewardToken);\n', '        rewardPerBlock = _rewardPerBlock;\n', '        daoShare = _daoShare;\n', '        earlyFoundersShare = _earlyFoundersShare;\n', '        lastUpdatedBlock = block.number;\n', '        daoWallet = msg.sender;\n', '        earlyFoundersWallet = msg.sender;\n', '    }\n', '\n', '    function setWallets(address _daoWallet, address _earlyFoundersWallet) public onlyOwner {\n', '        daoWallet = _daoWallet;\n', '        earlyFoundersWallet = _earlyFoundersWallet;\n', '    }\n', '\n', '    function setShares(uint256 _daoShare, uint256 _earlyFoundersShare) public onlyOwner {\n', '        withdrawParticleCollector();\n', '        daoShare = _daoShare;\n', '        earlyFoundersShare = _earlyFoundersShare;\n', '    }\n', '\n', '    function setRewardPerBlock(uint256 _rewardPerBlock) public onlyOwner {\n', '        update();\n', '        rewardPerBlock = _rewardPerBlock;\n', '        emit RewardPerBlockChanged(rewardPerBlock, _rewardPerBlock);\n', '    }\n', '\n', '    // Update reward variables of the pool to be up-to-date.\n', '    function update() public {\n', '        if (block.number <= lastUpdatedBlock) {\n', '            return;\n', '        }\n', '        uint256 totalStakedToken = stakedToken.balanceOf(address(this));\n', '        uint256 rewardAmount = (block.number - lastUpdatedBlock).mul(rewardPerBlock);\n', '\n', '        rewardTillNowPerToken = rewardTillNowPerToken.add(rewardAmount.mul(scale).div(totalStakedToken));\n', '        lastUpdatedBlock = block.number;\n', '    }\n', '\n', '    // View function to see pending reward on frontend.\n', '    function pendingReward(address _user) external view returns (uint256) {\n', '        User storage user = users[_user];\n', '        uint256 accRewardPerToken = rewardTillNowPerToken;\n', '\n', '        if (block.number > lastUpdatedBlock) {\n', '            uint256 totalStakedToken = stakedToken.balanceOf(address(this));\n', '            uint256 rewardAmount = (block.number - lastUpdatedBlock).mul(rewardPerBlock);\n', '            accRewardPerToken = accRewardPerToken.add(rewardAmount.mul(scale).div(totalStakedToken));\n', '        }\n', '        return user.depositAmount.mul(accRewardPerToken).div(scale).sub(user.paidReward);\n', '    }\n', '\n', '    function deposit(uint256 amount) public {\n', '        User storage user = users[msg.sender];\n', '        update();\n', '\n', '        if (user.depositAmount > 0) {\n', '            uint256 _pendingReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale).sub(user.paidReward);\n', '            rewardToken.transfer(msg.sender, _pendingReward);\n', '            emit RewardClaimed(msg.sender, _pendingReward);\n', '        }\n', '\n', '        user.depositAmount = user.depositAmount.add(amount);\n', '        user.paidReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale);\n', '\n', '        stakedToken.transferFrom(address(msg.sender), address(this), amount);\n', '        emit Deposit(msg.sender, amount);\n', '    }\n', '\n', '    function withdraw(uint256 amount) public {\n', '        User storage user = users[msg.sender];\n', '        require(user.depositAmount >= amount, "withdraw amount exceeds deposited amount");\n', '        update();\n', '\n', '        uint256 _pendingReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale).sub(user.paidReward);\n', '        rewardToken.transfer(msg.sender, _pendingReward);\n', '        emit RewardClaimed(msg.sender, _pendingReward);\n', '\n', '        uint256 particleCollectorShare = _pendingReward.mul(daoShare.add(earlyFoundersShare)).div(scale);\n', '        particleCollector = particleCollector.add(particleCollectorShare);\n', '\n', '        if (amount > 0) {\n', '            user.depositAmount = user.depositAmount.sub(amount);\n', '            stakedToken.transfer(address(msg.sender), amount);\n', '            emit Withdraw(msg.sender, amount);\n', '        }\n', '\n', '        user.paidReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale);\n', '    }\n', '\n', '    function withdrawParticleCollector() public {\n', '        uint256 _daoShare = particleCollector.mul(daoShare).div(daoShare.add(earlyFoundersShare));\n', '        rewardToken.transfer(daoWallet, _daoShare);\n', '\n', '        uint256 _earlyFoundersShare = particleCollector.mul(earlyFoundersShare).div(daoShare.add(earlyFoundersShare));\n', '        rewardToken.transfer(earlyFoundersWallet, _earlyFoundersShare);\n', '\n', '        particleCollector = 0;\n', '    }\n', '\n', '    // Withdraw without caring about rewards. EMERGENCY ONLY.\n', '    function emergencyWithdraw() public {\n', '        User storage user = users[msg.sender];\n', '\n', '        stakedToken.transfer(msg.sender, user.depositAmount);\n', '\n', '        emit EmergencyWithdraw(msg.sender, user.depositAmount);\n', '\n', '        user.depositAmount = 0;\n', '        user.paidReward = 0;\n', '    }\n', '\n', '\n', '    // Add temporary withdrawal functionality for owner(DAO) to transfer all tokens to a safe place.\n', '    // Contract ownership will transfer to address(0x) after full auditing of codes.\n', '    function withdrawAllRewardTokens(address to) public onlyOwner {\n', '        uint256 totalRewardTokens = rewardToken.balanceOf(address(this));\n', '        rewardToken.transfer(to, totalRewardTokens);\n', '    }\n', '\n', '    // Add temporary withdrawal functionality for owner(DAO) to transfer all tokens to a safe place.\n', '    // Contract ownership will transfer to address(0x) after full auditing of codes.\n', '    function withdrawAllStakedtokens(address to) public onlyOwner {\n', '        uint256 totalStakedTokens = stakedToken.balanceOf(address(this));\n', '        stakedToken.transfer(to, totalStakedTokens);\n', '    }\n', '\n', '}\n', '\n', '\n', '//Dar panah khoda']
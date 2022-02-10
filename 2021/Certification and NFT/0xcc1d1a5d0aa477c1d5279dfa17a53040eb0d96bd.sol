['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-11\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '    function ceil(uint256 a, uint256 m) internal pure returns (uint256 r) {\n', '        require(m != 0, "SafeMath: to ceil number shall not be zero");\n', '        return (a + m - 1) / m * m;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    function balanceOf(address tokenOwner) external view returns (uint256 balance);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address payable public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "only allowed by owner");\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0), "Invalid address");\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(msg.sender, _newOwner);\n', '    }\n', '}\n', '\n', 'contract RBTStake is Owned{\n', '    using SafeMath for uint256;\n', '    \n', '    address private saleContract;\n', '    address private tokenAddress;\n', '    \n', '    uint256 public cliffPeriodStarted;\n', '    \n', '    event SaleContractSet(address by, address saleAddress);\n', '    event UserTokensStaked(address by, address user, uint256 tokensPurchased);\n', '    event RewardClaimDateSet(address by, uint256 rewardClaimDate);\n', '    event RewardsClaimed(address by, uint256 rewards);\n', '    \n', '    struct StakedTokens{\n', '        uint256 tokens;\n', '        uint256 stakeDate;\n', '    }\n', '    \n', '    mapping(address => StakedTokens) public purchasedRBT;\n', '    mapping(address => uint256) public rewardRBT;\n', '    \n', '    modifier onlySaleContract{\n', '        require(msg.sender == saleContract, "UnAuthorized");\n', '        _;\n', '    }\n', '    \n', '    modifier isPurchaser{\n', '        require(purchasedRBT[msg.sender].tokens > 0 , "UnAuthorized");\n', '        _;\n', '    }\n', '    \n', '    modifier isClaimable{\n', '        require(block.timestamp >= cliffPeriodStarted, "reward claim date has not reached");\n', '        require(cliffPeriodStarted > 0, "cannot claim reward. cliff period has not started");\n', '        _;\n', '    }\n', '    \n', '    constructor(address _tokenAddress) public{\n', '        tokenAddress = _tokenAddress;\n', '    }\n', '    \n', '    function SetSaleContract(address _saleContract) external onlyOwner{\n', '        require(_saleContract != address(0), "Invalid address");\n', '        require(saleContract == address(0), "address already set");\n', '        \n', '        saleContract = _saleContract;\n', '        \n', '        emit SaleContractSet(msg.sender, _saleContract);\n', '    }\n', '    \n', '    function StakeTokens(address _ofUser, uint256 _tokens) external onlySaleContract returns(bool){\n', '        purchasedRBT[_ofUser].tokens = purchasedRBT[_ofUser].tokens.add(_tokens);\n', '        purchasedRBT[_ofUser].stakeDate = block.timestamp;\n', '        emit UserTokensStaked(msg.sender, _ofUser, _tokens);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function SetRewardClaimDate() external onlySaleContract returns(bool){\n', '        cliffPeriodStarted = block.timestamp;\n', '        RewardClaimDateSet(msg.sender, cliffPeriodStarted);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function ClaimReward() external isPurchaser isClaimable {\n', '        uint256 rewards = _calculateReward(cliffPeriodStarted, msg.sender);\n', '        require(rewards > 0, "nothing pending to be claimed");\n', '        require(rewardRBT[msg.sender] == 0, "already claimed");\n', '        \n', '        rewardRBT[msg.sender] = rewards;\n', '        \n', '        IERC20(tokenAddress).transfer(msg.sender, rewards);\n', '        \n', '        emit RewardsClaimed(msg.sender, rewards);\n', '    }\n', '    \n', '    function _calculateReward(uint256 toDate, address _user) internal view returns(uint256) {\n', '        uint256 totalStakeTime = (toDate.sub(purchasedRBT[_user].stakeDate)).div(/*24 hours*/ 1 days); // in days\n', '        uint256 rewardsAvailable = (totalStakeTime.mul(30).mul(purchasedRBT[_user].tokens)).div(365 * 100); // to take percentage div by 100\n', '        return  rewardsAvailable;\n', '    }\n', '    \n', '    function pendingReward(address _user) public view returns(uint256){\n', '        uint256 reward;\n', '        if(block.timestamp > cliffPeriodStarted && cliffPeriodStarted > 0)\n', '            reward =  _calculateReward(cliffPeriodStarted, _user); \n', '        else\n', '            reward = _calculateReward(block.timestamp, _user);\n', '        return reward.sub(rewardRBT[_user]);\n', '    }\n', '    \n', '    function getBackExtraTokens() external onlyOwner{\n', '        uint256 tokens = IERC20(tokenAddress).balanceOf(address(this));\n', '        require(IERC20(tokenAddress).transfer(owner, tokens), "No tokens in contract");\n', '    }\n', '    \n', '}']
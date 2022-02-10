['pragma solidity ^0.6.0;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'FAIRY' Staking smart contract\n", '// ----------------------------------------------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// SafeMath library\n', '// ----------------------------------------------------------------------------\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '    \n', '    function ceil(uint a, uint m) internal pure returns (uint r) {\n', '        return (a + m - 1) / m * m;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address payable public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(msg.sender, _newOwner);\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address tokenOwner) external view returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) external returns (bool success);\n', '    function approve(address spender, uint256 tokens) external returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) external returns (bool success);\n', '    function burnTokens(uint256 _amount) external;\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and assisted\n', '// token transfers\n', '// ----------------------------------------------------------------------------\n', 'contract FairyStaking is Owned {\n', '    using SafeMath for uint256;\n', '    \n', '    address public FAIRY = 0xA9E36a459a48CC3FCc68bcE72fEceb15489D89cb;\n', '    \n', '    uint256 public totalStakes = 0;\n', '    uint256 stakingFee = 25; // 2.5%\n', '    uint256 unstakingFee = 25; // 2.5% \n', '    uint256 public totalDividends = 0;\n', '    uint256 private scaledRemainder = 0;\n', '    uint256 private scaling = uint256(10) ** 12;\n', '    uint public round = 1;\n', '    \n', '    struct USER{\n', '        uint256 stakedTokens;\n', '        uint256 lastDividends;\n', '        uint256 fromTotalDividend;\n', '        uint round;\n', '        uint256 remainder;\n', '    }\n', '    \n', '    mapping(address => USER) stakers;\n', '    mapping (uint => uint256) public payouts;                   // keeps record of each payout\n', '    \n', '    event STAKED(address staker, uint256 tokens, uint256 stakingFee);\n', '    event UNSTAKED(address staker, uint256 tokens, uint256 unstakingFee);\n', '    event PAYOUT(uint256 round, uint256 tokens, address sender);\n', '    event CLAIMEDREWARD(address staker, uint256 reward);\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Token holders can stake their tokens using this function\n', '    // @param tokens number of tokens to stake\n', '    // ------------------------------------------------------------------------\n', '    function STAKE(uint256 tokens) external {\n', '        require(IERC20(FAIRY).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from user account");\n', '        \n', '        uint256 _stakingFee = 0;\n', '        if(totalStakes > 0)\n', '            _stakingFee= (onePercent(tokens).mul(stakingFee)).div(10); \n', '        \n', '        if(totalStakes > 0)\n', "            // distribute the staking fee accumulated before updating the user's stake\n", '            _addPayout(_stakingFee);\n', '            \n', '        // add pending rewards to remainder to be claimed by user later, if there is any existing stake\n', '        uint256 owing = pendingReward(msg.sender);\n', '        stakers[msg.sender].remainder += owing;\n', '        \n', '        stakers[msg.sender].stakedTokens = (tokens.sub(_stakingFee)).add(stakers[msg.sender].stakedTokens);\n', '        stakers[msg.sender].lastDividends = owing;\n', '        stakers[msg.sender].fromTotalDividend= totalDividends;\n', '        stakers[msg.sender].round =  round;\n', '        \n', '        totalStakes = totalStakes.add(tokens.sub(_stakingFee));\n', '        \n', '        emit STAKED(msg.sender, tokens.sub(_stakingFee), _stakingFee);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Owners can send the funds to be distributed to stakers using this function\n', '    // @param tokens number of tokens to distribute\n', '    // ------------------------------------------------------------------------\n', '    function ADDFUNDS(uint256 tokens) external {\n', '        require(IERC20(FAIRY).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");\n', '        _addPayout(tokens);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Private function to register payouts\n', '    // ------------------------------------------------------------------------\n', '    function _addPayout(uint256 tokens) private{\n', '        // divide the funds among the currently staked tokens\n', '        // scale the deposit and add the previous remainder\n', '        uint256 available = (tokens.mul(scaling)).add(scaledRemainder); \n', '        uint256 dividendPerToken = available.div(totalStakes);\n', '        scaledRemainder = available.mod(totalStakes);\n', '        \n', '        totalDividends = totalDividends.add(dividendPerToken);\n', '        payouts[round] = payouts[round-1].add(dividendPerToken);\n', '        \n', '        emit PAYOUT(round, tokens, msg.sender);\n', '        round++;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Stakers can claim their pending rewards using this function\n', '    // ------------------------------------------------------------------------\n', '    function CLAIMREWARD() public {\n', '        if(totalDividends > stakers[msg.sender].fromTotalDividend){\n', '            uint256 owing = pendingReward(msg.sender);\n', '        \n', '            owing = owing.add(stakers[msg.sender].remainder);\n', '            stakers[msg.sender].remainder = 0;\n', '        \n', '            require(IERC20(FAIRY).transfer(msg.sender,owing), "ERROR: error in sending reward from contract");\n', '        \n', '            emit CLAIMEDREWARD(msg.sender, owing);\n', '        \n', '            stakers[msg.sender].lastDividends = owing; // unscaled\n', '            stakers[msg.sender].round = round; // update the round\n', '            stakers[msg.sender].fromTotalDividend = totalDividends; // scaled\n', '        }\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the pending rewards of the staker\n', '    // @param _staker the address of the staker\n', '    // ------------------------------------------------------------------------    \n', '    function pendingReward(address staker) private returns (uint256) {\n', '        uint256 amount =  ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)).div(scaling);\n', '        stakers[staker].remainder += ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)) % scaling ;\n', '        return amount;\n', '    }\n', '    \n', '    function getPendingReward(address staker) public view returns(uint256 _pendingReward) {\n', '        uint256 amount =  ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)).div(scaling);\n', '        amount += ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)) % scaling ;\n', '        return (amount + stakers[staker].remainder);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Stakers can un stake the staked tokens using this function\n', '    // @param tokens the number of tokens to withdraw\n', '    // ------------------------------------------------------------------------\n', '    function WITHDRAW(uint256 tokens) external {\n', '        \n', '        require(stakers[msg.sender].stakedTokens >= tokens && tokens > 0, "Invalid token amount to withdraw");\n', '        \n', '        uint256 _unstakingFee = (onePercent(tokens).mul(unstakingFee)).div(10);\n', '        \n', '        // add pending rewards to remainder to be claimed by user later, if there is any existing stake\n', '        uint256 owing = pendingReward(msg.sender);\n', '        stakers[msg.sender].remainder += owing;\n', '                \n', '        require(IERC20(FAIRY).transfer(msg.sender, tokens.sub(_unstakingFee)), "Error in un-staking tokens");\n', '        \n', '        stakers[msg.sender].stakedTokens = stakers[msg.sender].stakedTokens.sub(tokens);\n', '        stakers[msg.sender].lastDividends = owing;\n', '        stakers[msg.sender].fromTotalDividend= totalDividends;\n', '        stakers[msg.sender].round =  round;\n', '        \n', '        totalStakes = totalStakes.sub(tokens);\n', '        \n', '        if(totalStakes > 0)\n', "            // distribute the un staking fee accumulated after updating the user's stake\n", '            _addPayout(_unstakingFee);\n', '        \n', '        emit UNSTAKED(msg.sender, tokens.sub(_unstakingFee), _unstakingFee);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Private function to calculate 1% percentage\n', '    // ------------------------------------------------------------------------\n', '    function onePercent(uint256 _tokens) private pure returns (uint256){\n', '        uint256 roundValue = _tokens.ceil(100);\n', '        uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));\n', '        return onePercentofTokens;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the number of tokens staked by a staker\n', '    // @param _staker the address of the staker\n', '    // ------------------------------------------------------------------------\n', '    function yourStakedFAIRY(address staker) external view returns(uint256 stakedFAIRY){\n', '        return stakers[staker].stakedTokens;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the FAIRY balance of the token holder\n', '    // @param user the address of the token holder\n', '    // ------------------------------------------------------------------------\n', '    function yourFAIRYBalance(address user) external view returns(uint256 FAIRYBalance){\n', '        return IERC20(FAIRY).balanceOf(user);\n', '    }\n', '}']
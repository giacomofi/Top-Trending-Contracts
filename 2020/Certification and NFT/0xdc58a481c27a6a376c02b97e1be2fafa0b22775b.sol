['// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface IYFVRewards {\n', '    function stakingPower(address account) external view returns (uint256);\n', '}\n', '\n', 'contract YFVVIPVoteV2 {\n', '    using SafeMath for uint256;\n', '\n', '    uint8 public constant MAX_VOTERS_PER_ITEM = 200;\n', '    uint256 public constant POOL_REWARD_SUPPLY_INFLATION_RATE_VOTE_ITEM = 10000;\n', '    uint256 public constant VIP_3_VOTE_ITEM = 3;\n', '\n', '    mapping(address => mapping(uint256 => uint8)) public numVoters; // poolAddress -> votingItem (periodFinish) -> numVoters (the number of voters in this round)\n', '    mapping(address => mapping(uint256 => address[MAX_VOTERS_PER_ITEM])) public voters; // poolAddress -> votingItem (periodFinish) -> voters (array)\n', '    mapping(address => mapping(uint256 => mapping(address => bool))) public isInTopVoters; // poolAddress -> votingItem (periodFinish) -> isInTopVoters (map: voter -> in_top (true/false))\n', '    mapping(address => mapping(uint256 => mapping(address => uint64))) public voter2VotingValue; // poolAddress -> votingItem (periodFinish) -> voter2VotingValue (map: voter -> voting value)\n', '\n', '    mapping(address => mapping(uint256 => uint64)) public votingValueMinimums; // poolAddress -> votingItem (proposalId) -> votingValueMin\n', '    mapping(address => mapping(uint256 => uint64)) public votingValueMaximums; // poolAddress -> votingItem (proposalId) -> votingValueMax\n', '\n', "    mapping(address => mapping(uint256 => uint256)) public votingStarttimes; // poolAddress -> votingItem (proposalId) -> voting's starttime\n", "    mapping(address => mapping(uint256 => uint256)) public votingEndtimes; // poolAddress -> votingItem (proposalId) -> voting's endtime\n", '\n', '    mapping(address => uint8) poolVotingValueLeftBitRanges; // poolAddress -> left bit range\n', '    mapping(address => uint8) poolVotingValueRightBitRanges; // poolAddress -> right bit range\n', '\n', '    address public stakeGovernancePool = 0xD120f23438AC0edbBA2c4c072739387aaa70277a; // Stake Pool v2\n', '\n', '    address public governance;\n', '    address public operator; // help to replace weak voter by higher power one\n', '\n', '    event Voted(address poolAddress, address indexed user, uint256 votingItem, uint64 votingValue);\n', '\n', '    constructor () public {\n', '        governance = msg.sender;\n', '        operator = msg.sender;\n', '        // BAL Pool\n', '        poolVotingValueLeftBitRanges[0x62a9fE913eb596C8faC0936fd2F51064022ba22e] = 5;\n', '        poolVotingValueRightBitRanges[0x62a9fE913eb596C8faC0936fd2F51064022ba22e] = 0;\n', '        // YFI Pool\n', '        poolVotingValueLeftBitRanges[0x70b83A7f5E83B3698d136887253E0bf426C9A117] = 10;\n', '        poolVotingValueRightBitRanges[0x70b83A7f5E83B3698d136887253E0bf426C9A117] = 5;\n', '        // BAT Pool\n', '        poolVotingValueLeftBitRanges[0x1c990fC37F399C935625b815975D0c9fAD5C31A1] = 15;\n', '        poolVotingValueRightBitRanges[0x1c990fC37F399C935625b815975D0c9fAD5C31A1] = 10;\n', '        // REN Pool\n', '        poolVotingValueLeftBitRanges[0x752037bfEf024Bd2669227BF9068cb22840174B0] = 20;\n', '        poolVotingValueRightBitRanges[0x752037bfEf024Bd2669227BF9068cb22840174B0] = 15;\n', '        // KNC Pool\n', '        poolVotingValueLeftBitRanges[0x9b74774f55C0351fD064CfdfFd35dB002C433092] = 25;\n', '        poolVotingValueRightBitRanges[0x9b74774f55C0351fD064CfdfFd35dB002C433092] = 20;\n', '        // BTC Pool\n', '        poolVotingValueLeftBitRanges[0xFBDE07329FFc9Ec1b70f639ad388B94532b5E063] = 30;\n', '        poolVotingValueRightBitRanges[0xFBDE07329FFc9Ec1b70f639ad388B94532b5E063] = 25;\n', '        // WETH Pool\n', '        poolVotingValueLeftBitRanges[0x67FfB615EAEb8aA88fF37cCa6A32e322286a42bb] = 35;\n', '        poolVotingValueRightBitRanges[0x67FfB615EAEb8aA88fF37cCa6A32e322286a42bb] = 30;\n', '        // LINK Pool\n', '        poolVotingValueLeftBitRanges[0x196CF719251579cBc850dED0e47e972b3d7810Cd] = 40;\n', '        poolVotingValueRightBitRanges[0x196CF719251579cBc850dED0e47e972b3d7810Cd] = 35;\n', '    }\n', '\n', '    function setGovernance(address _governance) public {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '\n', '    function setOperator(address _operator) public {\n', '        require(msg.sender == governance, "!governance");\n', '        operator = _operator;\n', '    }\n', '\n', '    function setVotingConfig(address poolAddress, uint256 votingItem, uint64 minValue, uint64 maxValue, uint256 starttime, uint256 endtime) public {\n', '        require(msg.sender == governance, "!governance");\n', '        require(minValue < maxValue, "Invalid voting range");\n', '        require(starttime < endtime, "Invalid time range");\n', '        require(endtime > block.timestamp, "Endtime has passed");\n', '        votingValueMinimums[poolAddress][votingItem] = minValue;\n', '        votingValueMaximums[poolAddress][votingItem] = maxValue;\n', '        votingStarttimes[poolAddress][votingItem] = starttime;\n', '        votingEndtimes[poolAddress][votingItem] = endtime;\n', '    }\n', '\n', '    function setStakeGovernancePool(address _stakeGovernancePool) public {\n', '        require(msg.sender == governance, "!governance");\n', '        stakeGovernancePool = _stakeGovernancePool;\n', '    }\n', '\n', '    function setPoolVotingValueBitRanges(address poolAddress, uint8 leftBitRange, uint8 rightBitRange) public {\n', '        require(msg.sender == governance, "!governance");\n', '        poolVotingValueLeftBitRanges[poolAddress] = leftBitRange;\n', '        poolVotingValueRightBitRanges[poolAddress] = rightBitRange;\n', '    }\n', '\n', '    function isVotable(address poolAddress, address account, uint256 votingItem) public view returns (bool) {\n', '        if (block.timestamp < votingStarttimes[poolAddress][votingItem]) return false; // vote is not open yet\n', '        if (block.timestamp > votingEndtimes[poolAddress][votingItem]) return false; // vote is closed\n', '\n', '        IYFVRewards rewards = IYFVRewards(poolAddress);\n', "        // hasn't any staking power\n", '        if (rewards.stakingPower(account) == 0) return false;\n', '\n', '        // number of voters is under limit still\n', '        if (numVoters[poolAddress][votingItem] < MAX_VOTERS_PER_ITEM) return true;\n', '        return false;\n', '    }\n', '\n', '    // for VIP: multiply by 100 for more precise\n', '    function averageVotingValueX100(address poolAddress, uint256 votingItem) public view returns (uint64) {\n', '        if (numVoters[poolAddress][votingItem] == 0) return 0; // no votes\n', '        uint256 totalStakingPower = 0;\n', '        uint256 totalWeightedVotingValue = 0;\n', '        IYFVRewards rewards = IYFVRewards(poolAddress);\n', '        for (uint8 i = 0; i < numVoters[poolAddress][votingItem]; i++) {\n', '            address voter = voters[poolAddress][votingItem][i];\n', '            totalStakingPower = totalStakingPower.add(rewards.stakingPower(voter));\n', '            totalWeightedVotingValue = totalWeightedVotingValue.add(rewards.stakingPower(voter).mul(voter2VotingValue[poolAddress][votingItem][voter]));\n', '        }\n', '        return (uint64) (totalWeightedVotingValue.mul(100).div(totalStakingPower));\n', '    }\n', '\n', '    // multiply by 100 for more precise\n', '    function averageVotingValueByBitsX100(address poolAddress, uint256 votingItem, uint8 leftBitRange, uint8 rightBitRange) public view returns (uint64) {\n', '        if (numVoters[poolAddress][votingItem] == 0) return 0; // no votes\n', '        uint256 totalStakingPower = 0;\n', '        uint256 totalWeightedVotingValue = 0;\n', '        IYFVRewards rewards = IYFVRewards(poolAddress);\n', '        uint64 bitmask = (uint64(1) << (leftBitRange - rightBitRange)) - 1;\n', '        for (uint8 i = 0; i < numVoters[poolAddress][votingItem]; i++) {\n', '            address voter = voters[poolAddress][votingItem][i];\n', '            totalStakingPower = totalStakingPower.add(rewards.stakingPower(voter));\n', '            uint64 votingValueByBits = (voter2VotingValue[poolAddress][votingItem][voter] >> rightBitRange) & bitmask;\n', '            totalWeightedVotingValue = totalWeightedVotingValue.add(rewards.stakingPower(voter).mul(votingValueByBits));\n', '        }\n', '        return (uint64) (totalWeightedVotingValue.mul(100).div(totalStakingPower));\n', '    }\n', '\n', '    function verifyOfflineVote(address poolAddress, uint256 votingItem, uint64 votingValue, uint256 timestamp, address voter, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {\n', '        bytes32 signatureHash = keccak256(abi.encodePacked(voter, poolAddress, votingItem, votingValue, timestamp));\n', '        return voter == ecrecover(signatureHash, v, r, s);\n', '    }\n', '\n', '    // if more than 200 voters participate, we may need to replace a weak (low power) voter by a stronger (high power) one\n', '    function replaceVoter(address poolAddress, uint256 votingItem, uint8 voterIndex, address newVoter) public {\n', '        require(msg.sender == governance || msg.sender == operator, "!governance && !operator");\n', '        require(numVoters[poolAddress][votingItem] > voterIndex, "index is out of range");\n', '        require(!isInTopVoters[poolAddress][votingItem][newVoter], "newVoter is in the list already");\n', '        IYFVRewards rewards = IYFVRewards(poolAddress);\n', '        address currentVoter = voters[poolAddress][votingItem][voterIndex];\n', '        require(rewards.stakingPower(currentVoter) < rewards.stakingPower(newVoter), "newVoter does not have high power than currentVoter");\n', '        isInTopVoters[poolAddress][votingItem][currentVoter] = false;\n', '        isInTopVoters[poolAddress][votingItem][newVoter] = true;\n', '        voters[poolAddress][votingItem][voterIndex] = newVoter;\n', '    }\n', '\n', '    function vote(address poolAddress, uint256 votingItem, uint64 votingValue) public {\n', '        require(block.timestamp >= votingStarttimes[poolAddress][votingItem], "voting is not open yet");\n', '        require(block.timestamp <= votingEndtimes[poolAddress][votingItem], "voting is closed");\n', '        if (votingValueMinimums[poolAddress][votingItem] > 0 || votingValueMaximums[poolAddress][votingItem] > 0) {\n', '            require(votingValue >= votingValueMinimums[poolAddress][votingItem], "votingValue is smaller than minimum accepted value");\n', '            require(votingValue <= votingValueMaximums[poolAddress][votingItem], "votingValue is greater than maximum accepted value");\n', '        }\n', '\n', '        if (!isInTopVoters[poolAddress][votingItem][msg.sender]) {\n', '            require(isVotable(poolAddress, msg.sender, votingItem), "This account is not votable");\n', '            if (numVoters[poolAddress][votingItem] < MAX_VOTERS_PER_ITEM) {\n', '                isInTopVoters[poolAddress][votingItem][msg.sender] = true;\n', '                voters[poolAddress][votingItem][numVoters[poolAddress][votingItem]] = msg.sender;\n', '                ++numVoters[poolAddress][votingItem];\n', '            }\n', '        }\n', '        voter2VotingValue[poolAddress][votingItem][msg.sender] = votingValue;\n', '        emit Voted(poolAddress, msg.sender, votingItem, votingValue);\n', '    }\n', '\n', '    function averageVotingValue(address poolAddress, uint256) public view returns (uint16) {\n', '        uint8 numInflationVoters = numVoters[stakeGovernancePool][POOL_REWARD_SUPPLY_INFLATION_RATE_VOTE_ITEM];\n', '        if (numInflationVoters == 0) return 0; // no votes\n', '\n', '        uint8 leftBitRange = poolVotingValueLeftBitRanges[poolAddress];\n', '        uint8 rightBitRange = poolVotingValueRightBitRanges[poolAddress];\n', '        if (leftBitRange == 0 && rightBitRange == 0) return 0; // we dont know about this pool\n', '        // empowerment Factor (every 100 is 5%) (slider 0% - 5% - 10% - .... - 80%)\n', '        uint64 empowermentFactor = averageVotingValueByBitsX100(stakeGovernancePool, VIP_3_VOTE_ITEM, leftBitRange, rightBitRange) / 20;\n', '        if (empowermentFactor > 80) empowermentFactor = 80; // minimum 0% -> maximum 80%\n', '        uint64 farmingFactor = 100 - empowermentFactor; // minimum 20% -> maximum 100%\n', '\n', '        uint256 totalFarmingPower = 0;\n', '        uint256 totalStakingPower = 0;\n', '        uint256 totalWeightedFarmingVotingValue = 0;\n', '        uint256 totalWeightedStakingVotingValue = 0;\n', '        IYFVRewards farmingPool = IYFVRewards(poolAddress);\n', '        IYFVRewards stakingPool = IYFVRewards(stakeGovernancePool);\n', '        uint64 bitmask = (uint64(1) << (leftBitRange - rightBitRange)) - 1;\n', '        for (uint8 i = 0; i < numInflationVoters; i++) {\n', '            address voter = voters[stakeGovernancePool][POOL_REWARD_SUPPLY_INFLATION_RATE_VOTE_ITEM][i];\n', '            totalFarmingPower = totalFarmingPower.add(farmingPool.stakingPower(voter));\n', '            totalStakingPower = totalStakingPower.add(stakingPool.stakingPower(voter));\n', '            uint64 votingValueByBits = (voter2VotingValue[stakeGovernancePool][POOL_REWARD_SUPPLY_INFLATION_RATE_VOTE_ITEM][voter] >> rightBitRange) & bitmask;\n', '            totalWeightedFarmingVotingValue = totalWeightedFarmingVotingValue.add(farmingPool.stakingPower(voter).mul(votingValueByBits));\n', '            totalWeightedStakingVotingValue = totalWeightedStakingVotingValue.add(stakingPool.stakingPower(voter).mul(votingValueByBits));\n', '        }\n', '        uint64 farmingAvgValue = (uint64) (totalWeightedFarmingVotingValue.mul(farmingFactor).div(totalFarmingPower));\n', '        uint64 stakingAvgValue = (uint64) (totalWeightedStakingVotingValue.mul(empowermentFactor).div(totalStakingPower));\n', '        uint16 avgValue = (uint16) ((farmingAvgValue + stakingAvgValue) / 100);\n', '        // 0 -> x0.2, 1 -> x0.25, ..., 20 -> x1.20\n', '        if (avgValue > 20) return 120;\n', '        return 20 + avgValue * 5;\n', '    }\n', '\n', '    function votingValueGovernance(address poolAddress, uint256 votingItem, uint16) public view returns (uint16) {\n', '        return averageVotingValue(poolAddress, votingItem);\n', '    }\n', '\n', '    // governance can drain tokens that are sent here by mistake\n', '    function emergencyERC20Drain(ERC20 token, uint amount) external {\n', '        require(msg.sender == governance, "!governance");\n', '        token.transfer(governance, amount);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address _who) public view returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}']
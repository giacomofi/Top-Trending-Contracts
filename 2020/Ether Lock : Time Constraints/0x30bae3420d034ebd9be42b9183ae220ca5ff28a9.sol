['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', '\n', 'interface sbControllerInterface {\n', '  function requestRewards(address miner, uint256 amount) external;\n', '\n', '  function isValuePoolAccepted(address valuePool) external view returns (bool);\n', '\n', '  function getValuePoolRewards(address valuePool, uint256 day) external view returns (uint256);\n', '\n', '  function getValuePoolMiningFee(address valuePool) external returns (uint256, uint256);\n', '\n', '  function getValuePoolUnminingFee(address valuePool) external returns (uint256, uint256);\n', '\n', '  function getValuePoolClaimingFee(address valuePool) external returns (uint256, uint256);\n', '\n', '  function isServicePoolAccepted(address servicePool) external view returns (bool);\n', '\n', '  function getServicePoolRewards(address servicePool, uint256 day) external view returns (uint256);\n', '\n', '  function getServicePoolClaimingFee(address servicePool) external returns (uint256, uint256);\n', '\n', '  function getServicePoolRequestFeeInWei(address servicePool) external returns (uint256);\n', '\n', '  function getVoteForServicePoolsCount() external view returns (uint256);\n', '\n', '  function getVoteForServicesCount() external view returns (uint256);\n', '\n', '  function getVoteCastersRewards(uint256 dayNumber) external view returns (uint256);\n', '\n', '  function getVoteReceiversRewards(uint256 dayNumber) external view returns (uint256);\n', '\n', '  function getMinerMinMineDays() external view returns (uint256);\n', '\n', '  function getServiceMinMineDays() external view returns (uint256);\n', '\n', '  function getMinerMinMineAmountInWei() external view returns (uint256);\n', '\n', '  function getServiceMinMineAmountInWei() external view returns (uint256);\n', '\n', '  function getValuePoolVestingDays(address valuePool) external view returns (uint256);\n', '\n', '  function getServicePoolVestingDays(address poservicePoolol) external view returns (uint256);\n', '\n', '  function getVoteCasterVestingDays() external view returns (uint256);\n', '\n', '  function getVoteReceiverVestingDays() external view returns (uint256);\n', '}\n']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n']
['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', '\n', 'interface sbEthFeePoolInterface {\n', '  function deposit() external payable;\n', '}\n']
['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', '\n', 'interface sbVotesInterface {\n', '  function getPriorProposalVotes(address account, uint256 blockNumber) external view returns (uint96);\n', '\n', '  function updateVotes(\n', '    address staker,\n', '    uint256 rawAmount,\n', '    bool adding\n', '  ) external;\n', '}\n']
['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', '\n', 'import "./IERC20.sol";\n', 'import "./SafeMath.sol";\n', 'import "./sbEthFeePoolInterface.sol";\n', 'import "./sbControllerInterface.sol";\n', 'import "./sbVotesInterface.sol";\n', '\n', 'contract sbStrongValuePool {\n', '    using SafeMath for uint256;\n', '\n', '    bool public initDone;\n', '    address public admin;\n', '    address public pendingAdmin;\n', '    address public superAdmin;\n', '    address public pendingSuperAdmin;\n', '\n', '    sbControllerInterface public sbController;\n', '    sbEthFeePoolInterface public sbEthFeePool;\n', '    sbVotesInterface public sbVotes;\n', '    IERC20 public strongToken;\n', '\n', '    mapping(address => uint256[]) public minerMineDays;\n', '    mapping(address => uint256[]) public minerMineAmounts;\n', '    mapping(address => uint256[]) public minerMineMineSeconds;\n', '\n', '    uint256[] public mineDays;\n', '    uint256[] public mineAmounts;\n', '    uint256[] public mineMineSeconds;\n', '\n', '    mapping(address => uint256) public minerDayLastClaimedFor;\n', '    mapping(address => uint256) public mineForVotes;\n', '\n', '    function init(\n', '        address sbVotesAddress,\n', '        address sbEthFeePoolAddress,\n', '        address sbControllerAddress,\n', '        address strongTokenAddress,\n', '        address adminAddress,\n', '        address superAdminAddress\n', '    ) public {\n', '        require(!initDone, "init done");\n', '        sbVotes = sbVotesInterface(sbVotesAddress);\n', '        sbEthFeePool = sbEthFeePoolInterface(sbEthFeePoolAddress);\n', '        sbController = sbControllerInterface(sbControllerAddress);\n', '        strongToken = IERC20(strongTokenAddress);\n', '        admin = adminAddress;\n', '        superAdmin = superAdminAddress;\n', '        initDone = true;\n', '    }\n', '\n', '    // ADMIN\n', '    // *************************************************************************************\n', '    function setPendingAdmin(address newPendingAdmin) public {\n', '        require(msg.sender == admin, "not admin");\n', '        pendingAdmin = newPendingAdmin;\n', '    }\n', '\n', '    function acceptAdmin() public {\n', '        require(\n', '            msg.sender == pendingAdmin && msg.sender != address(0),\n', '            "not pendingAdmin"\n', '        );\n', '        admin = pendingAdmin;\n', '        pendingAdmin = address(0);\n', '    }\n', '\n', '    function setPendingSuperAdmin(address newPendingSuperAdmin) public {\n', '        require(msg.sender == superAdmin, "not superAdmin");\n', '        pendingSuperAdmin = newPendingSuperAdmin;\n', '    }\n', '\n', '    function acceptSuperAdmin() public {\n', '        require(\n', '            msg.sender == pendingSuperAdmin && msg.sender != address(0),\n', '            "not pendingSuperAdmin"\n', '        );\n', '        superAdmin = pendingSuperAdmin;\n', '        pendingSuperAdmin = address(0);\n', '    }\n', '\n', '    // MINING\n', '    // *************************************************************************************\n', '    function serviceMinMined(address miner) public view returns (bool) {\n', '        uint256 dayCount = sbController.getServiceMinMineDays();\n', '        uint256 amount = sbController.getServiceMinMineAmountInWei();\n', '        return _minMined(miner, dayCount, amount);\n', '    }\n', '\n', '    function minerMinMined(address miner) public view returns (bool) {\n', '        uint256 dayCount = sbController.getMinerMinMineDays();\n', '        uint256 amount = sbController.getMinerMinMineAmountInWei();\n', '        return _minMined(miner, dayCount, amount);\n', '    }\n', '\n', '    function mine(uint256 amount) public payable {\n', '        require(amount > 0, "zero");\n', '        (uint256 numerator, uint256 denominator) = sbController\n', '            .getValuePoolMiningFee(address(this));\n', '        uint256 fee = amount.mul(numerator).div(denominator);\n', '        require(msg.value == fee, "invalid fee");\n', '        sbEthFeePool.deposit{value: msg.value}();\n', '        strongToken.transferFrom(msg.sender, address(this), amount);\n', '        uint256 currentDay = _getCurrentDay();\n', '        _update(\n', '            minerMineDays[msg.sender],\n', '            minerMineAmounts[msg.sender],\n', '            minerMineMineSeconds[msg.sender],\n', '            amount,\n', '            true,\n', '            currentDay\n', '        );\n', '        _update(\n', '            mineDays,\n', '            mineAmounts,\n', '            mineMineSeconds,\n', '            amount,\n', '            true,\n', '            currentDay\n', '        );\n', '        sbVotes.updateVotes(msg.sender, amount, true);\n', '    }\n', '\n', '    function mineFor(address miner, uint256 amount) external {\n', '        require(amount > 0, "zero");\n', '        require(miner != address(0), "zero address");\n', '        require(msg.sender == address(sbController), "invalid caller");\n', '        strongToken.transferFrom(msg.sender, address(this), amount);\n', '        uint256 currentDay = _getCurrentDay();\n', '        _update(\n', '            minerMineDays[miner],\n', '            minerMineAmounts[miner],\n', '            minerMineMineSeconds[miner],\n', '            amount,\n', '            true,\n', '            currentDay\n', '        );\n', '        _update(\n', '            mineDays,\n', '            mineAmounts,\n', '            mineMineSeconds,\n', '            amount,\n', '            true,\n', '            currentDay\n', '        );\n', '        sbVotes.updateVotes(miner, amount, true);\n', '    }\n', '\n', '    function unmine(uint256 amount) public payable {\n', '        require(amount > 0, "zero");\n', '        (uint256 numerator, uint256 denominator) = sbController\n', '            .getValuePoolUnminingFee(address(this));\n', '        uint256 fee = amount.mul(numerator).div(denominator);\n', '        require(msg.value == fee, "invalid fee");\n', '        sbEthFeePool.deposit{value: msg.value}();\n', '        uint256 currentDay = _getCurrentDay();\n', '        _update(\n', '            minerMineDays[msg.sender],\n', '            minerMineAmounts[msg.sender],\n', '            minerMineMineSeconds[msg.sender],\n', '            amount,\n', '            false,\n', '            currentDay\n', '        );\n', '        _update(\n', '            mineDays,\n', '            mineAmounts,\n', '            mineMineSeconds,\n', '            amount,\n', '            false,\n', '            currentDay\n', '        );\n', '        strongToken.transfer(msg.sender, amount);\n', '        sbVotes.updateVotes(msg.sender, amount, false);\n', '    }\n', '\n', '    function mineForVotesOnly(uint256 amount) public {\n', '        require(amount > 0, "zero");\n', '        strongToken.transferFrom(msg.sender, address(this), amount);\n', '        mineForVotes[msg.sender] = mineForVotes[msg.sender].add(amount);\n', '        sbVotes.updateVotes(msg.sender, amount, true);\n', '    }\n', '\n', '    function unmineForVotesOnly(uint256 amount) public {\n', '        require(amount > 0, "zero");\n', '        require(mineForVotes[msg.sender] >= amount, "not enough mine");\n', '        mineForVotes[msg.sender] = mineForVotes[msg.sender].sub(amount);\n', '        sbVotes.updateVotes(msg.sender, amount, false);\n', '        strongToken.transfer(msg.sender, amount);\n', '    }\n', '\n', '    function getMineForVotesOnly(address miner) public view returns (uint256) {\n', '        return mineForVotes[miner];\n', '    }\n', '\n', '    function getMinerDayLastClaimedFor(address miner)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        uint256 len = minerMineDays[miner].length;\n', '        if (len != 0) {\n', '            return\n', '                minerDayLastClaimedFor[miner] == 0\n', '                    ? minerMineDays[miner][0].sub(1)\n', '                    : minerDayLastClaimedFor[miner];\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function getMinerMineData(address miner, uint256 dayNumber)\n', '        public\n', '        view\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        )\n', '    {\n', '        uint256 day = dayNumber == 0 ? _getCurrentDay() : dayNumber;\n', '        return _getMinerMineData(miner, day);\n', '    }\n', '\n', '    function getMineData(uint256 dayNumber)\n', '        public\n', '        view\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        )\n', '    {\n', '        uint256 day = dayNumber == 0 ? _getCurrentDay() : dayNumber;\n', '        return _getMineData(day);\n', '    }\n', '\n', '    // CLAIMING\n', '    // *************************************************************************************\n', '    function claimAll() public payable {\n', '        uint256 len = minerMineDays[msg.sender].length;\n', '        require(len != 0, "no mines");\n', '        uint256 currentDay = _getCurrentDay();\n', '        uint256 dayLastClaimedFor = minerDayLastClaimedFor[msg.sender] == 0\n', '            ? minerMineDays[msg.sender][0].sub(1)\n', '            : minerDayLastClaimedFor[msg.sender];\n', '        uint256 vestingDays = sbController.getValuePoolVestingDays(\n', '            address(this)\n', '        );\n', '        require(\n', '            currentDay > dayLastClaimedFor.add(vestingDays),\n', '            "already claimed"\n', '        );\n', '        // fee is calculated in _claim\n', '        _claim(currentDay, msg.sender, dayLastClaimedFor, vestingDays);\n', '    }\n', '\n', '    function claimUpTo(uint256 day) public payable {\n', '        uint256 len = minerMineDays[msg.sender].length;\n', '        require(len != 0, "no mines");\n', '        require(day <= _getCurrentDay(), "invalid day");\n', '        sbEthFeePool.deposit{value: msg.value}();\n', '        uint256 dayLastClaimedFor = minerDayLastClaimedFor[msg.sender] == 0\n', '            ? minerMineDays[msg.sender][0].sub(1)\n', '            : minerDayLastClaimedFor[msg.sender];\n', '        uint256 vestingDays = sbController.getValuePoolVestingDays(\n', '            address(this)\n', '        );\n', '        require(day > dayLastClaimedFor.add(vestingDays), "already claimed");\n', '        // fee is calculated in _claim\n', '        _claim(day, msg.sender, dayLastClaimedFor, vestingDays);\n', '    }\n', '\n', '    function getRewardsDueAll(address miner) public view returns (uint256) {\n', '        uint256 len = minerMineDays[miner].length;\n', '        if (len == 0) {\n', '            return 0;\n', '        }\n', '        uint256 currentDay = _getCurrentDay();\n', '        uint256 dayLastClaimedFor = minerDayLastClaimedFor[miner] == 0\n', '            ? minerMineDays[miner][0].sub(1)\n', '            : minerDayLastClaimedFor[miner];\n', '        uint256 vestingDays = sbController.getValuePoolVestingDays(\n', '            address(this)\n', '        );\n', '        if (!(currentDay > dayLastClaimedFor.add(vestingDays))) {\n', '            return 0;\n', '        }\n', '        return\n', '            _getRewardsDue(currentDay, miner, dayLastClaimedFor, vestingDays);\n', '    }\n', '\n', '    function getRewardsDueUpTo(uint256 day, address miner)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        uint256 len = minerMineDays[miner].length;\n', '        if (len == 0) {\n', '            return 0;\n', '        }\n', '        require(day <= _getCurrentDay(), "invalid day");\n', '        uint256 dayLastClaimedFor = minerDayLastClaimedFor[miner] == 0\n', '            ? minerMineDays[miner][0].sub(1)\n', '            : minerDayLastClaimedFor[miner];\n', '        uint256 vestingDays = sbController.getValuePoolVestingDays(\n', '            address(this)\n', '        );\n', '        if (!(day > dayLastClaimedFor.add(vestingDays))) {\n', '            return 0;\n', '        }\n', '        return _getRewardsDue(day, miner, dayLastClaimedFor, vestingDays);\n', '    }\n', '\n', '    // SUPPORT\n', '    // *************************************************************************************\n', '    function _getMinerMineData(address miner, uint256 day)\n', '        internal\n', '        view\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        )\n', '    {\n', '        uint256[] memory _Days = minerMineDays[miner];\n', '        uint256[] memory _Amounts = minerMineAmounts[miner];\n', '        uint256[] memory _UnitSeconds = minerMineMineSeconds[miner];\n', '        return _get(_Days, _Amounts, _UnitSeconds, day);\n', '    }\n', '\n', '    function _getMineData(uint256 day)\n', '        internal\n', '        view\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        )\n', '    {\n', '        return _get(mineDays, mineAmounts, mineMineSeconds, day);\n', '    }\n', '\n', '    function _get(\n', '        uint256[] memory _Days,\n', '        uint256[] memory _Amounts,\n', '        uint256[] memory _UnitSeconds,\n', '        uint256 day\n', '    )\n', '        internal\n', '        pure\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        )\n', '    {\n', '        uint256 len = _Days.length;\n', '        if (len == 0) {\n', '            return (day, 0, 0);\n', '        }\n', '        if (day < _Days[0]) {\n', '            return (day, 0, 0);\n', '        }\n', '        uint256 lastIndex = len.sub(1);\n', '        uint256 lastMinedDay = _Days[lastIndex];\n', '        if (day == lastMinedDay) {\n', '            return (day, _Amounts[lastIndex], _UnitSeconds[lastIndex]);\n', '        } else if (day > lastMinedDay) {\n', '            return (day, _Amounts[lastIndex], _Amounts[lastIndex].mul(1 days));\n', '        }\n', '        return _find(_Days, _Amounts, _UnitSeconds, day);\n', '    }\n', '\n', '    function _find(\n', '        uint256[] memory _Days,\n', '        uint256[] memory _Amounts,\n', '        uint256[] memory _UnitSeconds,\n', '        uint256 day\n', '    )\n', '        internal\n', '        pure\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        )\n', '    {\n', '        uint256 left = 0;\n', '        uint256 right = _Days.length.sub(1);\n', '        uint256 middle = right.add(left).div(2);\n', '        while (left < right) {\n', '            if (_Days[middle] == day) {\n', '                return (day, _Amounts[middle], _UnitSeconds[middle]);\n', '            } else if (_Days[middle] > day) {\n', '                if (middle > 0 && _Days[middle.sub(1)] < day) {\n', '                    return (\n', '                        day,\n', '                        _Amounts[middle.sub(1)],\n', '                        _Amounts[middle.sub(1)].mul(1 days)\n', '                    );\n', '                }\n', '                if (middle == 0) {\n', '                    return (day, 0, 0);\n', '                }\n', '                right = middle.sub(1);\n', '            } else if (_Days[middle] < day) {\n', '                if (\n', '                    middle < _Days.length.sub(1) && _Days[middle.add(1)] > day\n', '                ) {\n', '                    return (\n', '                        day,\n', '                        _Amounts[middle],\n', '                        _Amounts[middle].mul(1 days)\n', '                    );\n', '                }\n', '                left = middle.add(1);\n', '            }\n', '            middle = right.add(left).div(2);\n', '        }\n', '        if (_Days[middle] != day) {\n', '            return (day, 0, 0);\n', '        } else {\n', '            return (day, _Amounts[middle], _UnitSeconds[middle]);\n', '        }\n', '    }\n', '\n', '    function _update(\n', '        uint256[] storage _Days,\n', '        uint256[] storage _Amounts,\n', '        uint256[] storage _UnitSeconds,\n', '        uint256 amount,\n', '        bool adding,\n', '        uint256 currentDay\n', '    ) internal {\n', '        uint256 len = _Days.length;\n', '        uint256 secondsInADay = 1 days;\n', '        uint256 secondsSinceStartOfDay = block.timestamp % secondsInADay;\n', '        uint256 secondsUntilEndOfDay = secondsInADay.sub(\n', '            secondsSinceStartOfDay\n', '        );\n', '\n', '        if (len == 0) {\n', '            if (adding) {\n', '                _Days.push(currentDay);\n', '                _Amounts.push(amount);\n', '                _UnitSeconds.push(amount.mul(secondsUntilEndOfDay));\n', '            } else {\n', '                require(false, "1: not enough mine");\n', '            }\n', '        } else {\n', '            uint256 lastIndex = len.sub(1);\n', '            uint256 lastMinedDay = _Days[lastIndex];\n', '            uint256 lastMinedAmount = _Amounts[lastIndex];\n', '            uint256 lastUnitSeconds = _UnitSeconds[lastIndex];\n', '\n', '            uint256 newAmount;\n', '            uint256 newUnitSeconds;\n', '\n', '            if (lastMinedDay == currentDay) {\n', '                if (adding) {\n', '                    newAmount = lastMinedAmount.add(amount);\n', '                    newUnitSeconds = lastUnitSeconds.add(\n', '                        amount.mul(secondsUntilEndOfDay)\n', '                    );\n', '                } else {\n', '                    require(lastMinedAmount >= amount, "2: not enough mine");\n', '                    newAmount = lastMinedAmount.sub(amount);\n', '                    newUnitSeconds = lastUnitSeconds.sub(\n', '                        amount.mul(secondsUntilEndOfDay)\n', '                    );\n', '                }\n', '                _Amounts[lastIndex] = newAmount;\n', '                _UnitSeconds[lastIndex] = newUnitSeconds;\n', '            } else {\n', '                if (adding) {\n', '                    newAmount = lastMinedAmount.add(amount);\n', '                    newUnitSeconds = lastMinedAmount.mul(1 days).add(\n', '                        amount.mul(secondsUntilEndOfDay)\n', '                    );\n', '                } else {\n', '                    require(lastMinedAmount >= amount, "3: not enough mine");\n', '                    newAmount = lastMinedAmount.sub(amount);\n', '                    newUnitSeconds = lastMinedAmount.mul(1 days).sub(\n', '                        amount.mul(secondsUntilEndOfDay)\n', '                    );\n', '                }\n', '                _Days.push(currentDay);\n', '                _Amounts.push(newAmount);\n', '                _UnitSeconds.push(newUnitSeconds);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _claim(\n', '        uint256 upToDay,\n', '        address miner,\n', '        uint256 dayLastClaimedFor,\n', '        uint256 vestingDays\n', '    ) internal {\n', '        uint256 rewards = _getRewardsDue(\n', '            upToDay,\n', '            miner,\n', '            dayLastClaimedFor,\n', '            vestingDays\n', '        );\n', '        require(rewards > 0, "no rewards");\n', '        (uint256 numerator, uint256 denominator) = sbController\n', '            .getValuePoolClaimingFee(address(this));\n', '        uint256 fee = rewards.mul(numerator).div(denominator);\n', '        require(msg.value == fee, "invalid fee");\n', '        sbEthFeePool.deposit{value: msg.value}();\n', '        minerDayLastClaimedFor[miner] = upToDay.sub(vestingDays);\n', '        sbController.requestRewards(miner, rewards);\n', '    }\n', '\n', '    function _getRewardsDue(\n', '        uint256 upToDay,\n', '        address miner,\n', '        uint256 dayLastClaimedFor,\n', '        uint256 vestingDays\n', '    ) internal view returns (uint256) {\n', '        uint256 rewards;\n', '        for (\n', '            uint256 day = dayLastClaimedFor.add(1);\n', '            day <= upToDay.sub(vestingDays);\n', '            day++\n', '        ) {\n', '            (, , uint256 minerMineSecondsForDay) = _getMinerMineData(\n', '                miner,\n', '                day\n', '            );\n', '            (, , uint256 mineSecondsForDay) = _getMineData(day);\n', '            if (mineSecondsForDay == 0) {\n', '                continue;\n', '            }\n', '            uint256 availableRewards = sbController.getValuePoolRewards(\n', '                address(this),\n', '                day\n', '            );\n', '            uint256 amount = availableRewards.mul(minerMineSecondsForDay).div(\n', '                mineSecondsForDay\n', '            );\n', '            rewards = rewards.add(amount);\n', '        }\n', '        return rewards;\n', '    }\n', '\n', '    function _getCurrentDay() internal view returns (uint256) {\n', '        return block.timestamp.div(1 days).add(1);\n', '    }\n', '\n', '    function _minMined(\n', '        address miner,\n', '        uint256 dayCount,\n', '        uint256 amount\n', '    ) internal view returns (bool) {\n', '        if (dayCount == 0 && amount == 0) {\n', '            return true;\n', '        }\n', '        uint256 currentDay = _getCurrentDay();\n', '        uint256 endDay = currentDay.sub(dayCount);\n', '        for (uint256 day = currentDay; day >= endDay; day--) {\n', '            (, uint256 minedAmount, ) = _getMinerMineData(miner, day);\n', '            if (minedAmount < amount) {\n', '                return false;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '}\n']

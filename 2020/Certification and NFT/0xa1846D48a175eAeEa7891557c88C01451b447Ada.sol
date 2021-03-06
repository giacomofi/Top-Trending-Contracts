['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '// \n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// \n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// \n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Staker is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "High Stakes Staking Game";\n', '\n', '    // Constants determining the game timeframe.\n', '    uint256 public constant maxWaitTime = 6 days;\n', '    uint256 public constant minimalWaitTime = 3 days;\n', '    uint256 public constant contractCoolDownTime = 1 days;\n', '    uint256 public constant referralLockBonus = 1 days;\n', '\n', "    // Total risk and total ETH, combined with the user's risk will determine the maximal amount the user can extract.\n", '    uint256 public totalRisk = 0;\n', '    uint256 public totalETH = 0;\n', '\n', '    // Per user risk and staking balance.\n', '    mapping(address => uint256) public stakerRisk;\n', '    mapping(address => uint256) public stakingBalance;\n', '    mapping(address => uint256) public referralStake;\n', '\n', '    // Each user has a different time lock (time when he can obtain the reward). This time is randomized on each stake.\n', '    mapping(address => uint256) public timeLocked;\n', '\n', '    uint256 public contractLaunchTime = now + contractCoolDownTime;\n', '\n', '    // Dev has no way to tamper with the Aleatory game.\n', '    // devFeesPercent determines the percentage of all tokens sent staked that are provided as dev incentives for future development.\n', '    // After the game has ended e.g., once contractLaunchTime + maxWaitTime, then all remaining funds are considered a donation.\n', '    uint256 private devETH;\n', '    uint256 public constant devFeesPercent = 5;\n', '\n', '    event Staked(address indexed user, uint256 amount);\n', '    event Withdrawn(address indexed user, uint256 amount);\n', '\n', '    function sqrt(uint y) internal pure returns (uint) {\n', '        uint z = 0;\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '        return z;\n', '    }\n', '\n', '    function randWaitTime() private view returns(uint256) {\n', '        uint256 seed = uint256(keccak256(abi.encodePacked(\n', '            block.timestamp + block.difficulty +\n', '            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) +\n', '            block.gaslimit +\n', '            ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)) +\n', '            block.number\n', '        )));\n', '\n', '        return minimalWaitTime + referralLockBonus + (seed - ((seed / maxWaitTime) * maxWaitTime)) * 1 seconds;\n', '    }\n', '\n', '    function getRisk(uint256 secondsPassed, uint256 ethAdded) private view returns(uint256) {\n', '        // The risk is determined by how early the ETH is staked and how much ETH.\n', '        // The risk is linearly decaying. Initial multiplier is x4. Get in early and you have a higher reward.\n', '        uint256 timeLeft = (maxWaitTime - secondsPassed) * 3;\n', '        if (secondsPassed > maxWaitTime) {\n', '            timeLeft = 0;\n', '        }\n', '        timeLeft += maxWaitTime;\n', '        return timeLeft * ethAdded;\n', '    }\n', '\n', '\n', '    modifier checkStart() {\n', '        require(contractLaunchTime <= now, "Contract staking hasn\'t started yet.");\n', '        _;\n', '    }\n', '\n', '    function stake(address referral) public payable checkStart returns (bool success) {\n', '        require(msg.value >= 10000000000000000, "Cannot stake less than 0.01 ETH.");\n', '        require(referral != msg.sender, "You can\'t refer yourself.");\n', '\n', '        // Add current stake to the referral stake count. This is used to calculate the exit time reduction.\n', '        referralStake[referral] += msg.value;\n', '\n', '        // Get the risk of the current staking transaction.\n', '        uint256 risk = getRisk(now - (contractLaunchTime), msg.value);\n', '\n', "        // Add the risk to the user's total risk and to the grand total contract staked risk.\n", '        stakerRisk[msg.sender] += risk;\n', '        totalRisk += risk;\n', '\n', "        // Randomize the user's unlock time.\n", '        timeLocked[msg.sender] = randWaitTime();\n', '\n', '        // Distribute ETH between the reward pool and the dev fund.\n', '        uint256 valueMinusFees = msg.value * (100 - devFeesPercent) / 100;\n', '        stakingBalance[msg.sender] += msg.value;\n', '        totalETH += valueMinusFees;\n', '        devETH += msg.value - valueMinusFees;\n', '        emit Staked(msg.sender, msg.value);\n', '        return true;\n', '    }\n', '\n', '    function unstakeTokens() public returns (bool success) {\n', '        // First make sure the user can withdraw his tokens and that there is ETH to withdraw.\n', '        uint256 balance = stakingBalance[msg.sender];\n', '        require(getUserUnlockTime(msg.sender) <= now, "Your lock period has not yet ended");\n', '        require(balance > 0, "Can\'t unstake 0 ETH.");\n', '\n', '        // Calculate the amount of ETH the user is entitled to.\n', '        uint256 risk = stakerRisk[msg.sender];\n', '        uint256 exitValue = getCurrentUserExitValue(msg.sender);\n', '\n', '        // Extract ETH.\n', '        stakingBalance[msg.sender] = 0;\n', '        stakerRisk[msg.sender] = 0;\n', '        totalETH -= exitValue;\n', '        totalRisk -= risk;\n', '        if (!msg.sender.send(exitValue)) {\n', '            stakingBalance[msg.sender] = balance;\n', '            totalETH += exitValue;\n', '\n', '            stakerRisk[msg.sender] = risk;\n', '            totalRisk += risk;\n', '            return false;\n', '        }\n', '        emit Withdrawn(msg.sender, exitValue);\n', '        return true;\n', '    }\n', '\n', '    function getUserUnlockTime(address user) public view returns (uint256) {\n', '        uint256 senderLock = timeLocked[user];\n', '        uint256 referredETH = referralStake[user];\n', '\n', '        // For each 1ETH referred into the contract, the user reduces his unlock time by 1 hour.\n', '        senderLock -= referredETH * 36 seconds / 10000000000000000;\n', '        if (senderLock < minimalWaitTime) {\n', "            // The minimal lock time must hold. Referrals can't reduce lock lower than minimalWaitTime.\n", '            senderLock = minimalWaitTime;\n', '        }\n', '        return contractLaunchTime + senderLock;\n', '    }\n', '\n', '    function getCurrentUserExitValue(address user) public view returns (uint256) {\n', '        // User exit value is determined by the risk the user took and the total risk taken by all other users.\n', '        if (totalRisk > 0) {\n', '            if (stakerRisk[user] / sqrt(totalRisk) > 1) {\n', '                return totalETH;\n', '            }\n', '            return totalETH * stakerRisk[user] / sqrt(totalRisk);\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function getUserEthStaked(address user) public view returns (uint256) {\n', '        return stakingBalance[user];\n', '    }\n', '\n', '    function getCurrentPotential() public view returns (uint256) {\n', '        // Current potential shows the potential ETH gained by staking 1 ETH NOW.\n', '        uint256 currentRisk = getRisk(now - (contractLaunchTime), 1000000000000000000);\n', '        if (totalRisk > 0) {\n', '            uint256 potentialGains = totalETH * currentRisk / sqrt(totalRisk);\n', '            if (potentialGains > totalETH) {\n', '                potentialGains = totalETH;\n', '            }\n', '            return potentialGains;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function withdrawDevFund() public payable onlyOwner returns (bool success) {\n', '        // Dev fund can be withdrawn only AFTER everyone is unlocked.\n', '        require(contractLaunchTime + maxWaitTime * 1 seconds <= now, "Contract hasn\'t ended yet.");\n', '        devETH += totalETH;\n', '        totalETH = 0;\n', '\n', '        uint256 balance = devETH;\n', '        devETH = 0;\n', '\n', '        if (!msg.sender.send(balance)) {\n', '            devETH = balance;\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '}']
['// SPDX-License-Identifier: MIT\n', '\n', '    /**\n', '     * LYNC Network\n', '     * https://lync.network\n', '     *\n', '     * Additional details for contract and wallet information:\n', '     * https://lync.network/tracking/\n', '     *\n', '     * The cryptocurrency network designed for passive token rewards for its community.\n', '     */\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'import "./safemath.sol";\n', '\n', 'contract LYNCToken {\n', '\n', '    //Enable SafeMath\n', '    using SafeMath for uint256;\n', '\n', '    //Token details\n', '    string constant public name = "LYNC Network";\n', '    string constant public symbol = "LYNC";\n', '    uint8 constant public decimals = 18;\n', '\n', '    //Reward pool and owner address\n', '    address public owner;\n', '    address public rewardPoolAddress;\n', '\n', '    //Supply and tranasction fee\n', '    uint256 public maxTokenSupply = 1e24;   // 1,000,000 tokens\n', '    uint256 public feePercent = 1;          // initial transaction fee percentage\n', '    uint256 public feePercentMax = 10;      // maximum transaction fee percentage\n', '\n', '    //Events\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _tokens);\n', '    event Approval(address indexed _owner,address indexed _spender, uint256 _tokens);\n', '    event TranserFee(uint256 _tokens);\n', '    event UpdateFee(uint256 _fee);\n', '    event RewardPoolUpdated(address indexed _rewardPoolAddress, address indexed _newRewardPoolAddress);\n', '    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);\n', '    event OwnershipRenounced(address indexed _previousOwner, address indexed _newOwner);\n', '\n', '    //Mappings\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) private allowances;\n', '\n', '    //On deployment\n', '    constructor () {\n', '        owner = msg.sender;\n', '        rewardPoolAddress = address(this);\n', '        balanceOf[msg.sender] = maxTokenSupply;\n', '        emit Transfer(address(0), msg.sender, maxTokenSupply);\n', '    }\n', '\n', '    //ERC20 totalSupply\n', '    function totalSupply() public view returns (uint256) {\n', '        return maxTokenSupply;\n', '    }\n', '\n', '    //ERC20 transfer\n', '    function transfer(address _to, uint256 _tokens) public returns (bool) {\n', '        transferWithFee(msg.sender, _to, _tokens);\n', '        return true;\n', '    }\n', '\n', '    //ERC20 transferFrom\n', '    function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool) {\n', '        require(_tokens <= balanceOf[_from], "Not enough tokens in the approved address balance");\n', '        require(_tokens <= allowances[_from][msg.sender], "token amount is larger than the current allowance");\n', '        transferWithFee(_from, _to, _tokens);\n', '        allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_tokens);\n', '        return true;\n', '    }\n', '\n', '    //ERC20 approve\n', '    function approve(address _spender, uint256 _tokens) public returns (bool) {\n', '        allowances[msg.sender][_spender] = _tokens;\n', '        emit Approval(msg.sender, _spender, _tokens);\n', '        return true;\n', '    }\n', '\n', '    //ERC20 allowance\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '    //Transfer with transaction fee applied\n', '    function transferWithFee(address _from, address _to, uint256 _tokens) internal returns (bool) {\n', '        require(balanceOf[_from] >= _tokens, "Not enough tokens in the senders balance");\n', '        uint256 _feeAmount = (_tokens.mul(feePercent)).div(100);\n', '        balanceOf[_from] = balanceOf[_from].sub(_tokens);\n', '        balanceOf[_to] = balanceOf[_to].add(_tokens.sub(_feeAmount));\n', '        balanceOf[rewardPoolAddress] = balanceOf[rewardPoolAddress].add(_feeAmount);\n', '        emit Transfer(_from, _to, _tokens.sub(_feeAmount));\n', '        emit Transfer(_from, rewardPoolAddress, _feeAmount);\n', '        emit TranserFee(_tokens);\n', '        return true;\n', '    }\n', '\n', '    //Update transaction fee percentage\n', '    function updateFee(uint256 _updateFee) public onlyOwner {\n', '        require(_updateFee <= feePercentMax, "Transaction fee cannot be greater than 10%");\n', '        feePercent = _updateFee;\n', '        emit UpdateFee(_updateFee);\n', '    }\n', '\n', '    //Update the reward pool address\n', '    function updateRewardPool(address _newRewardPoolAddress) public onlyOwner {\n', '        require(_newRewardPoolAddress != address(0), "New reward pool address cannot be a zero address");\n', '        rewardPoolAddress = _newRewardPoolAddress;\n', '        emit RewardPoolUpdated(rewardPoolAddress, _newRewardPoolAddress);\n', '    }\n', '\n', '    //Transfer current token balance to the reward pool address\n', '    function rewardPoolBalanceTransfer() public onlyOwner returns (bool) {\n', '        uint256 _currentBalance = balanceOf[address(this)];\n', '        transferWithFee(address(this), rewardPoolAddress, _currentBalance);\n', '        return true;\n', '    }\n', '\n', '    //Transfer ownership to new owner\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0), "New owner cannot be a zero address");\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '    //Remove owner from the contract\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner, address(0));\n', '        owner = address(0);\n', '    }\n', '\n', '    //Modifiers\n', '    modifier onlyOwner() {\n', '        require(owner == msg.sender, "Only current owner can call this function");\n', '        _;\n', '    }\n', '}\n']
['// SPDX-License-Identifier: MIT\n', '\n', '  /**\n', '   * LYNC Network\n', '   * https://lync.network\n', '   *\n', '   * Additional details for contract and wallet information:\n', '   * https://lync.network/tracking/\n', '   *\n', '   * The cryptocurrency network designed for passive token rewards for its community.\n', '   */\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'import "./lynctoken.sol";\n', '\n', 'contract LYNCTokenLock {\n', '\n', '    //Enable SafeMath\n', '    using SafeMath for uint256;\n', '\n', '    address public owner;\n', '    address public contractAddress;\n', '    uint256 public oneDay = 86400;      // in seconds\n', '    uint256 public currentLockTimer;    // in seconds\n', '\n', '    LYNCToken public tokenContract;\n', '\n', '    //Events\n', '    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);\n', '    event OwnershipRenounced(address indexed _previousOwner, address indexed _newOwner);\n', '\n', '    //On deployment\n', '    constructor(LYNCToken _tokenContract) {\n', '        owner = msg.sender;\n', '        tokenContract = _tokenContract;\n', '        contractAddress = address(this);\n', '        currentLockTimer = block.timestamp;\n', '    }\n', '\n', '    //Withdraw tokens\n', '    function withdrawTokens(uint256 _numberOfTokens) public onlyOwner {\n', '        require(block.timestamp > currentLockTimer, "Tokens are currently locked even to the contract admin");\n', '        require(tokenContract.transfer(msg.sender, _numberOfTokens));\n', '    }\n', '\n', '    //Increase lock duration in days\n', '    function increaseLock(uint256 _numberOfDays) public onlyOwner {\n', '        uint256 _increaseLockDays = _numberOfDays.mul(oneDay);\n', '        currentLockTimer = currentLockTimer.add(_increaseLockDays);\n', '    }\n', '\n', '    //Transfer ownership to new owner\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0), "New owner cannot be a zero address");\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '    //Remove owner from the contract\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner, address(0));\n', '        owner = address(0);\n', '    }\n', '\n', '    //Modifiers\n', '    modifier onlyOwner() {\n', '        require(owner == msg.sender, "Only current owner can call this function");\n', '        _;\n', '    }\n', '}\n']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n']

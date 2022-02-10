['//SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'import "../libraries/math/SafeMath.sol";\n', 'import "../libraries/token/IERC20.sol";\n', 'import "../libraries/utils/ReentrancyGuard.sol";\n', 'import "../interfaces/IX2Fund.sol";\n', 'import "../interfaces/IX2Farm.sol";\n', '\n', 'contract Farm is ReentrancyGuard, IERC20, IX2Farm {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name = "XVIX UNI Farm";\n', '    string public constant symbol = "UNI:FARM";\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 constant PRECISION = 1e30;\n', '\n', '    address public token;\n', '    address public gov;\n', '    address public distributor;\n', '\n', '    uint256 public override totalSupply;\n', '\n', '    mapping (address => uint256) public balances;\n', '\n', '    uint256 public override cumulativeRewardPerToken;\n', '    mapping (address => uint256) public override claimableReward;\n', '    mapping (address => uint256) public override previousCumulatedRewardPerToken;\n', '\n', '    event Deposit(address account, uint256 amount);\n', '    event Withdraw(address account, uint256 amount);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event GovChange(address gov);\n', '    event Claim(address receiver, uint256 amount);\n', '\n', '    modifier onlyGov() {\n', '        require(msg.sender == gov, "Farm: forbidden");\n', '        _;\n', '    }\n', '\n', '    constructor(address _token) public {\n', '        token = _token;\n', '        gov = msg.sender;\n', '    }\n', '\n', '    receive() external payable {}\n', '\n', '    function setGov(address _gov) external onlyGov {\n', '        gov = _gov;\n', '        emit GovChange(_gov);\n', '    }\n', '\n', '    function setDistributor(address _distributor) external onlyGov {\n', '        distributor = _distributor;\n', '    }\n', '\n', '    function deposit(uint256 _amount, address _receiver) external nonReentrant {\n', '        require(_amount > 0, "Farm: insufficient amount");\n', '\n', '        _updateRewards(_receiver, true);\n', '\n', '        IERC20(token).transferFrom(msg.sender, address(this), _amount);\n', '\n', '        balances[_receiver] = balances[_receiver].add(_amount);\n', '        totalSupply = totalSupply.add(_amount);\n', '\n', '        emit Deposit(_receiver, _amount);\n', '        emit Transfer(address(0), _receiver, _amount);\n', '    }\n', '\n', '    function withdraw(address _receiver, uint256 _amount) external nonReentrant {\n', '        require(_amount > 0, "Farm: insufficient amount");\n', '\n', '        address account = msg.sender;\n', '        _updateRewards(account, true);\n', '        _withdraw(account, _receiver, _amount);\n', '    }\n', '\n', '    function withdrawWithoutDistribution(address _receiver, uint256 _amount) external nonReentrant {\n', '        require(_amount > 0, "Farm: insufficient amount");\n', '\n', '        address account = msg.sender;\n', '        _updateRewards(account, false);\n', '        _withdraw(account, _receiver, _amount);\n', '    }\n', '\n', '    function claim(address _receiver) external nonReentrant {\n', '        address _account = msg.sender;\n', '        _updateRewards(_account, true);\n', '\n', '        uint256 rewardToClaim = claimableReward[_account];\n', '        claimableReward[_account] = 0;\n', '\n', '        (bool success,) = _receiver.call{value: rewardToClaim}("");\n', '        require(success, "Farm: transfer failed");\n', '\n', '        emit Claim(_receiver, rewardToClaim);\n', '    }\n', '\n', '    function balanceOf(address account) public override view returns (uint256) {\n', '        return balances[account];\n', '    }\n', '\n', '    // empty implementation, Farm tokens are non-transferrable\n', '    function transfer(address /* recipient */, uint256 /* amount */) public override returns (bool) {\n', '        revert("Farm: non-transferrable");\n', '    }\n', '\n', '    // empty implementation, Farm tokens are non-transferrable\n', '    function allowance(address /* owner */, address /* spender */) public view virtual override returns (uint256) {\n', '        return 0;\n', '    }\n', '\n', '    // empty implementation, Farm tokens are non-transferrable\n', '    function approve(address /* spender */, uint256 /* amount */) public virtual override returns (bool) {\n', '        revert("Farm: non-transferrable");\n', '    }\n', '\n', '    // empty implementation, Farm tokens are non-transferrable\n', '    function transferFrom(address /* sender */, address /* recipient */, uint256 /* amount */) public virtual override returns (bool) {\n', '        revert("Farm: non-transferrable");\n', '    }\n', '\n', '    function _withdraw(address _account, address _receiver, uint256 _amount) private {\n', '        require(balances[_account] >= _amount, "Farm: insufficient balance");\n', '\n', '        balances[_account] = balances[_account].sub(_amount);\n', '        totalSupply = totalSupply.sub(_amount);\n', '\n', '        IERC20(token).transfer(_receiver, _amount);\n', '\n', '        emit Withdraw(_account, _amount);\n', '        emit Transfer(_account, address(0), _amount);\n', '    }\n', '\n', '    function _updateRewards(address _account, bool _distribute) private {\n', '        uint256 blockReward;\n', '\n', '        if (_distribute && distributor != address(0)) {\n', '            blockReward = IX2Fund(distributor).distribute();\n', '        }\n', '\n', '        uint256 _cumulativeRewardPerToken = cumulativeRewardPerToken;\n', '        // only update cumulativeRewardPerToken when there are stakers, i.e. when totalSupply > 0\n', '        // if blockReward == 0, then there will be no change to cumulativeRewardPerToken\n', '        if (totalSupply > 0 && blockReward > 0) {\n', '            _cumulativeRewardPerToken = _cumulativeRewardPerToken.add(blockReward.mul(PRECISION).div(totalSupply));\n', '            cumulativeRewardPerToken = _cumulativeRewardPerToken;\n', '        }\n', '\n', '        // cumulativeRewardPerToken can only increase\n', '        // so if cumulativeRewardPerToken is zero, it means there are no rewards yet\n', '        if (_cumulativeRewardPerToken == 0) {\n', '            return;\n', '        }\n', '\n', '        uint256 _previousCumulatedReward = previousCumulatedRewardPerToken[_account];\n', '        uint256 _claimableReward = claimableReward[_account].add(\n', '            uint256(balances[_account]).mul(_cumulativeRewardPerToken.sub(_previousCumulatedReward)).div(PRECISION)\n', '        );\n', '\n', '        claimableReward[_account] = _claimableReward;\n', '        previousCumulatedRewardPerToken[_account] = _cumulativeRewardPerToken;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '/**\n', ' * @dev Contract module that helps prevent reentrant calls to a function.\n', ' *\n', ' * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier\n', ' * available, which can be applied to functions to make sure there are no nested\n', ' * (reentrant) calls to them.\n', ' *\n', ' * Note that because there is a single `nonReentrant` guard, functions marked as\n', ' * `nonReentrant` may not call one another. This can be worked around by making\n', ' * those functions `private`, and then adding `external` `nonReentrant` entry\n', ' * points to them.\n', ' *\n', ' * TIP: If you would like to learn more about reentrancy and alternative ways\n', ' * to protect against it, check out our blog post\n', ' * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].\n', ' */\n', 'contract ReentrancyGuard {\n', '    // Booleans are more expensive than uint256 or any type that takes up a full\n', '    // word because each write operation emits an extra SLOAD to first read the\n', "    // slot's contents, replace the bits taken up by the boolean, and then write\n", "    // back. This is the compiler's defense against contract upgrades and\n", '    // pointer aliasing, and it cannot be disabled.\n', '\n', '    // The values being non-zero value makes deployment a bit more expensive,\n', '    // but in exchange the refund on every call to nonReentrant will be lower in\n', '    // amount. Since refunds are capped to a percentage of the total\n', "    // transaction's gas, it is best to keep them low in cases like this one, to\n", '    // increase the likelihood of the full refund coming into effect.\n', '    uint256 private constant _NOT_ENTERED = 1;\n', '    uint256 private constant _ENTERED = 2;\n', '\n', '    uint256 private _status;\n', '\n', '    constructor () internal {\n', '        _status = _NOT_ENTERED;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        // On the first call to nonReentrant, _notEntered will be true\n', '        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");\n', '\n', '        // Any calls to nonReentrant after this point will fail\n', '        _status = _ENTERED;\n', '\n', '        _;\n', '\n', '        // By storing the original value once again, a refund is triggered (see\n', '        // https://eips.ethereum.org/EIPS/eip-2200)\n', '        _status = _NOT_ENTERED;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IX2Fund {\n', '    function distribute() external returns (uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IX2Farm {\n', '    function cumulativeRewardPerToken() external view returns (uint256);\n', '    function claimableReward(address account) external view returns (uint256);\n', '    function previousCumulatedRewardPerToken(address account) external view returns (uint256);\n', '}']
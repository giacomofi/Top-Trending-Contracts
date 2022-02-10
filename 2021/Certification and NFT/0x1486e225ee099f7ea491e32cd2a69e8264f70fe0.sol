['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-17\n', '*/\n', '\n', '// File: contracts/zeppelin/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/zeppelin/GSN/Context.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: contracts/zeppelin/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = _msgSender();\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/AllowTokens.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', '\n', '\n', 'contract AllowTokens is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    address constant private NULL_ADDRESS = address(0);\n', '\n', '    mapping (address => bool) public allowedTokens;\n', '    bool private validateAllowedTokens;\n', '    uint256 private maxTokensAllowed;\n', '    uint256 private minTokensAllowed;\n', '    uint256 public dailyLimit;\n', '\n', '    event AllowedTokenAdded(address indexed _tokenAddress);\n', '    event AllowedTokenRemoved(address indexed _tokenAddress);\n', '    event AllowedTokenValidation(bool _enabled);\n', '    event MaxTokensAllowedChanged(uint256 _maxTokens);\n', '    event MinTokensAllowedChanged(uint256 _minTokens);\n', '    event DailyLimitChanged(uint256 dailyLimit);\n', '\n', '    modifier notNull(address _address) {\n', '        require(_address != NULL_ADDRESS, "AllowTokens: Address cannot be empty");\n', '        _;\n', '    }\n', '\n', '    constructor(address _manager) public  {\n', '        transferOwnership(_manager);\n', '        validateAllowedTokens = true;\n', '        maxTokensAllowed = 10000 ether;\n', '        minTokensAllowed = 1 ether;\n', '        dailyLimit = 100000 ether;\n', '    }\n', '\n', '    function isValidatingAllowedTokens() external view returns(bool) {\n', '        return validateAllowedTokens;\n', '    }\n', '\n', '    function getMaxTokensAllowed() external view returns(uint256) {\n', '        return maxTokensAllowed;\n', '    }\n', '\n', '    function getMinTokensAllowed() external view returns(uint256) {\n', '        return minTokensAllowed;\n', '    }\n', '\n', '    function allowedTokenExist(address token) private view notNull(token) returns (bool) {\n', '        return allowedTokens[token];\n', '    }\n', '\n', '    function isTokenAllowed(address token) public view notNull(token) returns (bool) {\n', '        if (validateAllowedTokens) {\n', '            return allowedTokenExist(token);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function addAllowedToken(address token) external onlyOwner {\n', '        require(!allowedTokenExist(token), "AllowTokens: Token already exists in allowedTokens");\n', '        allowedTokens[token] = true;\n', '        emit AllowedTokenAdded(token);\n', '    }\n', '\n', '    function removeAllowedToken(address token) external onlyOwner {\n', '        require(allowedTokenExist(token), "AllowTokens: Token does not exis  in allowedTokenst");\n', '        allowedTokens[token] = false;\n', '        emit AllowedTokenRemoved(token);\n', '    }\n', '\n', '    function enableAllowedTokensValidation() external onlyOwner {\n', '        validateAllowedTokens = true;\n', '        emit AllowedTokenValidation(validateAllowedTokens);\n', '    }\n', '\n', '    function disableAllowedTokensValidation() external onlyOwner {\n', '        // Before disabling Allowed Tokens Validations some kind of contract validation system\n', '        // should be implemented on the Bridge for the methods receiveTokens, tokenFallback and tokensReceived\n', '        validateAllowedTokens = false;\n', '        emit AllowedTokenValidation(validateAllowedTokens);\n', '    }\n', '\n', '    function setMaxTokensAllowed(uint256 maxTokens) external onlyOwner {\n', '        require(maxTokens >= minTokensAllowed, "AllowTokens: Max Tokens should be equal or bigger than Min Tokens");\n', '        maxTokensAllowed = maxTokens;\n', '        emit MaxTokensAllowedChanged(maxTokensAllowed);\n', '    }\n', '\n', '    function setMinTokensAllowed(uint256 minTokens) external onlyOwner {\n', '        require(maxTokensAllowed >= minTokens, "AllowTokens: Min Tokens should be equal or smaller than Max Tokens");\n', '        minTokensAllowed = minTokens;\n', '        emit MinTokensAllowedChanged(minTokensAllowed);\n', '    }\n', '\n', '    function changeDailyLimit(uint256 _dailyLimit) external onlyOwner {\n', '        require(_dailyLimit >= maxTokensAllowed, "AllowTokens: Daily Limit should be equal or bigger than Max Tokens");\n', '        dailyLimit = _dailyLimit;\n', '        emit DailyLimitChanged(_dailyLimit);\n', '    }\n', '\n', '    // solium-disable-next-line max-len\n', '    function isValidTokenTransfer(address tokenToUse, uint amount, uint spentToday, bool isSideToken) external view returns (bool) {\n', '        if(amount > maxTokensAllowed)\n', '            return false;\n', '        if(amount < minTokensAllowed)\n', '            return false;\n', '        if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)\n', '            return false;\n', '        if(!isSideToken && !isTokenAllowed(tokenToUse))\n', '            return false;\n', '        return true;\n', '    }\n', '\n', '    function calcMaxWithdraw(uint spentToday) external view returns (uint) {\n', '        uint maxWithrow = dailyLimit - spentToday;\n', '        if (dailyLimit < spentToday)\n', '            return 0;\n', '        if(maxWithrow > maxTokensAllowed)\n', '            maxWithrow = maxTokensAllowed;\n', '        return maxWithrow;\n', '    }\n', '\n', '}']
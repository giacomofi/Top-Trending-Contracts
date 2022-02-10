['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-06\n', '*/\n', '\n', '// File: contracts\\interfaces\\IERC20.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts\\ownable\\Ownable.sol\n', '\n', 'abstract contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts\\libraries\\SafeMath.sol\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts\\timelock\\TimeLock.sol\n', '\n', '\n', '/// @author Jorge Gomes Dur├ín ([email\xa0protected])\n', '/// @title A vesting contract to lock tokens for ZigCoin\n', '\n', 'contract TimeLock is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    enum LockType {\n', '        PrivateSale,\n', '        Advisor,\n', '        LiquidityProviders,\n', '        Campaigns,\n', '        Reserves,\n', '        ExchangeListings,\n', '        Traders,\n', '        Founder\n', '    }\n', '\n', '    struct LockAmount {\n', '        uint8 lockType;\n', '        uint256 amount;\n', '    }\n', '\n', '    uint32 internal constant _1_MONTH_IN_SECONDS = 2592000;\n', '    uint8  internal constant _6_MONTHS = 6;\n', '\n', '    uint8 internal constant _MONTH_1_PRIVATE_SALE_FIRST_UNLOCK = 0;\n', '    uint8 internal constant _MONTH_2_PRIVATE_SALE_FIRST_UNLOCK = 3;\n', '    uint8 internal constant _MONTH_3_PRIVATE_SALE_FIRST_UNLOCK = 6;    \n', '\n', '    uint8 internal constant _PERCENTS_1_VESTING_PRIVATE_SALES = 30;\n', '    uint8 internal constant _PERCENTS_2_VESTING_PRIVATE_SALES = 60;\n', '    uint8 internal constant _PERCENTS_3_VESTING_PRIVATE_SALES = 100;\n', '\n', '    address immutable private token;\n', '    uint256 private tokenListedAt;\n', '    \n', '    mapping(address => LockAmount) private balances;\n', '    mapping(address => uint256) private withdrawn;\n', '\n', '    event TokenListed(address indexed from, uint256 datetime);\n', '    event TokensLocked(address indexed wallet, uint256 balance, uint8 lockType);\n', '    event TokensUnlocked(address indexed wallet);\n', '    event Withdrawal(address indexed wallet, uint256 balance);\n', '    event EmergencyWithdrawal(address indexed wallet, uint256 balance);\n', '\n', '    constructor(address _token) {\n', '        token = _token;  \n', '    }\n', '\n', '    /** \n', '     * @notice locks an amount of tokens to a wallet. Call only before listing the token\n', '     * @param _user     --> wallet that will receive the tokens once unlocked\n', '     * @param _balance  --> balance to lock\n', '     * @param _lockType --> lock type to know what unlock rules apply\n', '     */\n', '    function lockTokens(address _user, uint256 _balance, uint8 _lockType) external onlyOwner {\n', '        require(tokenListedAt == 0, "TokenAlreadyListed");\n', '        require(balances[_user].amount == 0, "WalletExistsYet");  \n', '        require(_lockType >= 0 && _lockType <= 7, "BadLockType");      \n', '\n', '        balances[_user] = LockAmount(_lockType, _balance);\n', '\n', '        emit TokensLocked(_user, _balance, _lockType);\n', '    }\n', '\n', '    /** \n', "     * @notice remove a token lock. Use if there's any mistake locking tokens\n", '     * @param _user --> wallet to remove tokens\n', '     */\n', '    function unlockTokens(address _user) external onlyOwner {\n', '        require(tokenListedAt == 0, "TokenAlreadyListed");\n', '        require(balances[_user].amount > 0, "WalletNotFound");\n', '\n', '        delete balances[_user];\n', '\n', '        emit TokensUnlocked(_user);\n', '    }\n', '\n', '    /** \n', '     * @notice send available tokens to the wallet once are unlocked\n', '     * @param _user    --> wallet that will receive the tokens\n', '     * @param _amount  --> amount to withdraw\n', '     */\n', '    function withdraw(address _user, uint256 _amount) external onlyOwner {\n', '        require(tokenListedAt > 0, "TokenNotListedYet");\n', '        require(balances[_user].amount > 0, "WalletNotFound");\n', '        require(_amount > 0, "BadAmount");\n', '\n', '        uint256 canWithdrawAmount = _canWithdraw(_user);\n', '        uint256 amountWithdrawn = withdrawn[_user];\n', '\n', '        require(canWithdrawAmount > amountWithdrawn, "CantWithdrawYet");\n', '        require(canWithdrawAmount - amountWithdrawn >= _amount, "AmountExceedsAllowance");\n', '\n', '        withdrawn[_user] += _amount;\n', '        IERC20(token).transfer(_user, _amount);\n', '\n', '        emit Withdrawal(_user, _amount);\n', '    }\n', '\n', '    /** \n', "     * @notice unlock all the tokens. Only use if there's any emergency\n", '     */\n', '    function emergencyWithdraw() external onlyOwner {\n', '        IERC20 erc20 = IERC20(token);\n', '        \n', '        uint256 balance = erc20.balanceOf(address(this));\n', '        erc20.transfer(owner(), balance);\n', '\n', '        emit EmergencyWithdrawal(msg.sender, balance);\n', '    }\n', '\n', '    /**\n', '     * @notice set the listing date to start the count for unlock tokens\n', '     */\n', '    function setTokenListed() external onlyOwner {\n', '        require(tokenListedAt == 0, "TokenAlreadyListed");\n', '        tokenListedAt = block.timestamp;\n', '        \n', '        emit TokenListed(msg.sender, tokenListedAt);\n', '    }\n', '\n', '    /** \n', '     * @notice get the token listing date\n', '     * @return listing date\n', '     */ \n', '    function getTokenListedAt() external view returns (uint256) {\n', '        return tokenListedAt;\n', '    }\n', '\n', '    /** \n', '     * @notice get the total locked balance of a wallet in the contract\n', '     * @param _user --> wallet\n', '     * @return amount locked amount\n', '     * @return lockType wallet type\n', '     */ \n', '    function balanceOf(address _user) external view returns(uint256 amount, uint8 lockType) {\n', '        amount = balances[_user].amount;\n', '        lockType = balances[_user].lockType;\n', '    }\n', '\n', '    /** \n', '     * @notice get the total locked balance of a wallet in the contract\n', '     * @param _user --> wallet\n', '     * @return locked amount and wallet type\n', '     */ \n', '    function balanceOfWithdrawan(address _user) external view returns(uint256) {\n', '        return withdrawn[_user];\n', '    }\n', '\n', '    /** \n', '     * @notice get the total of tokens in the contract\n', '     * @return tokens amount\n', '     */ \n', '    function getContractFunds() external view returns (uint256) {\n', '        return IERC20(token).balanceOf(address(this));\n', '    }\n', '\n', '    /** \n', '     * @notice get the amount of tokens that a wallet can withdraw right now\n', '     * @param _user --> wallet\n', '     * @return tokens amount\n', '     */ \n', '    function canWithdraw(address _user) external view returns (uint256) {\n', '        uint256 canWithdrawAmount = _canWithdraw(_user);\n', '        uint256 amountWithdrawn = withdrawn[_user];\n', '\n', '        return canWithdrawAmount - amountWithdrawn;\n', '    }\n', '\n', '    /** \n', '     * @notice get the number of months from token listing\n', '     * @return months\n', '     */ \n', '    function _getMonthFromTokenListed() internal view returns(uint256) {\n', '        if (tokenListedAt == 0) return 0;\n', '        if (tokenListedAt > block.timestamp) return 0;\n', '\n', '        return (block.timestamp - tokenListedAt).div(_1_MONTH_IN_SECONDS);\n', '    }\n', '\n', '    /** \n', '     * @notice get the amount of tokens that a wallet can withdraw by lock up rules\n', '     * @param _user --> wallet\n', '     * @return amount\n', '     */ \n', '    function _canWithdraw(address _user) internal view returns (uint256 amount) {\n', '        uint8 lockType = balances[_user].lockType;\n', '        \n', '        // Only if token has beed listed\n', '        if (tokenListedAt > 0) {\n', '            uint256 month = _getMonthFromTokenListed();\n', '            if (LockType(lockType) == LockType.Founder) {\n', '                // Founders have a linear 30 months unlock starting 6 months after listing\n', '                if (month >= _6_MONTHS) {\n', '                    uint monthAfterUnlock = month - _6_MONTHS + 1;\n', '                    amount = balances[_user].amount.mul(monthAfterUnlock).div(30);\n', '                    if (amount > balances[_user].amount) amount = balances[_user].amount;\n', '                }\n', '            } else if ((LockType(lockType) == LockType.PrivateSale) || (LockType(lockType) == LockType.Advisor)) {\n', '                // Private sales and advisors can unlock 30% at listing token date, 30% after 3 months and 40% after 6 months\n', '                if ((month >= _MONTH_1_PRIVATE_SALE_FIRST_UNLOCK) && (month < _MONTH_2_PRIVATE_SALE_FIRST_UNLOCK)) {\n', '                    amount = balances[_user].amount.mul(_PERCENTS_1_VESTING_PRIVATE_SALES).div(100);\n', '                } else if ((month >= _MONTH_2_PRIVATE_SALE_FIRST_UNLOCK) && (month < _MONTH_3_PRIVATE_SALE_FIRST_UNLOCK)) {\n', '                    amount = balances[_user].amount.mul(_PERCENTS_2_VESTING_PRIVATE_SALES).div(100);\n', '                } else if (month >= _MONTH_3_PRIVATE_SALE_FIRST_UNLOCK) {\n', '                    amount = balances[_user].amount;\n', '                }\n', '            } else {\n', '                // Other tokens can be withdrawn any time\n', '                amount = balances[_user].amount;\n', '            }\n', '        }\n', '    }\n', '}']
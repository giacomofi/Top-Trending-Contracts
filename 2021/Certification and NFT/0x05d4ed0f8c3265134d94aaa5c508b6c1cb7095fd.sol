['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-15\n', '*/\n', '\n', '// ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗\n', '// ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║\n', '// ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║\n', '// ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║\n', '// ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║\n', '// ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝\n', '// Copyright (C) 2021 zapper\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 2 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '\n', '///@author Zapper\n', '///@notice This contract adds liquidity to Vesper Vaults using ETH or ERC20 Tokens.\n', '\n', '// File: oz/GSN/Context.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor() internal {}\n', '\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: oz/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor() internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(\n', '            newOwner != address(0),\n', '            "Ownable: new owner is the zero address"\n', '        );\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: oz/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    function decimals() external view returns (uint8);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '// File: oz/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: oz/utils/Address.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '\n', '        bytes32 accountHash =\n', '            0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            codehash := extcodehash(account)\n', '        }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account)\n', '        internal\n', '        pure\n', '        returns (address payable)\n', '    {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(\n', '            address(this).balance >= amount,\n', '            "Address: insufficient balance"\n', '        );\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(\n', '            success,\n', '            "Address: unable to send value, recipient may have reverted"\n', '        );\n', '    }\n', '}\n', '\n', '// File: oz/token/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transfer.selector, to, value)\n', '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require(\n', '            (value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.approve.selector, spender, value)\n', '        );\n', '    }\n', '\n', '    function safeIncreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance =\n', '            token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    function safeDecreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance =\n', '            token.allowance(address(this), spender).sub(\n', '                value,\n', '                "SafeERC20: decreased allowance below zero"\n', '            );\n', '        callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(\n', '                token.approve.selector,\n', '                spender,\n', '                newAllowance\n', '            )\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(\n', '                abi.decode(returndata, (bool)),\n', '                "SafeERC20: ERC20 operation did not succeed"\n', '            );\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/_base/ZapBaseV1.sol\n', '\n', 'pragma solidity ^0.5.7;\n', '\n', 'contract ZapBaseV1 is Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '    bool public stopped = false;\n', '\n', '    // if true, goodwill is not deducted\n', '    mapping(address => bool) public feeWhitelist;\n', '\n', '    uint256 public goodwill;\n', '    // % share of goodwill (0-100 %)\n', '    uint256 affiliateSplit;\n', '    // restrict affiliates\n', '    mapping(address => bool) public affiliates;\n', '    // affiliate => token => amount\n', '    mapping(address => mapping(address => uint256)) public affiliateBalance;\n', '    // token => amount\n', '    mapping(address => uint256) public totalAffiliateBalance;\n', '\n', '    address internal constant ETHAddress =\n', '        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '    constructor(uint256 _goodwill, uint256 _affiliateSplit) public {\n', '        goodwill = _goodwill;\n', '        affiliateSplit = _affiliateSplit;\n', '    }\n', '\n', '    // circuit breaker modifiers\n', '    modifier stopInEmergency {\n', '        if (stopped) {\n', '            revert("Temporarily Paused");\n', '        } else {\n', '            _;\n', '        }\n', '    }\n', '\n', '    function _getBalance(address token)\n', '        internal\n', '        view\n', '        returns (uint256 balance)\n', '    {\n', '        if (token == address(0)) {\n', '            balance = address(this).balance;\n', '        } else {\n', '            balance = IERC20(token).balanceOf(address(this));\n', '        }\n', '    }\n', '\n', '    function _approveToken(address token, address spender) internal {\n', '        IERC20 _token = IERC20(token);\n', '        if (_token.allowance(address(this), spender) > 0) return;\n', '        else {\n', '            _token.safeApprove(spender, uint256(-1));\n', '        }\n', '    }\n', '\n', '    function _approveToken(\n', '        address token,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal {\n', '        IERC20 _token = IERC20(token);\n', '        _token.safeApprove(spender, 0);\n', '        _token.safeApprove(spender, amount);\n', '    }\n', '\n', '    // - to Pause the contract\n', '    function toggleContractActive() public onlyOwner {\n', '        stopped = !stopped;\n', '    }\n', '\n', '    function set_feeWhitelist(address zapAddress, bool status)\n', '        external\n', '        onlyOwner\n', '    {\n', '        feeWhitelist[zapAddress] = status;\n', '    }\n', '\n', '    function set_new_goodwill(uint256 _new_goodwill) public onlyOwner {\n', '        require(\n', '            _new_goodwill >= 0 && _new_goodwill <= 100,\n', '            "GoodWill Value not allowed"\n', '        );\n', '        goodwill = _new_goodwill;\n', '    }\n', '\n', '    function set_new_affiliateSplit(uint256 _new_affiliateSplit)\n', '        external\n', '        onlyOwner\n', '    {\n', '        require(\n', '            _new_affiliateSplit <= 100,\n', '            "Affiliate Split Value not allowed"\n', '        );\n', '        affiliateSplit = _new_affiliateSplit;\n', '    }\n', '\n', '    function set_affiliate(address _affiliate, bool _status)\n', '        external\n', '        onlyOwner\n', '    {\n', '        affiliates[_affiliate] = _status;\n', '    }\n', '\n', '    ///@notice Withdraw goodwill share, retaining affilliate share\n', '    function withdrawTokens(address[] calldata tokens) external onlyOwner {\n', '        for (uint256 i = 0; i < tokens.length; i++) {\n', '            uint256 qty;\n', '\n', '            if (tokens[i] == ETHAddress) {\n', '                qty = address(this).balance.sub(\n', '                    totalAffiliateBalance[tokens[i]]\n', '                );\n', '                Address.sendValue(Address.toPayable(owner()), qty);\n', '            } else {\n', '                qty = IERC20(tokens[i]).balanceOf(address(this)).sub(\n', '                    totalAffiliateBalance[tokens[i]]\n', '                );\n', '                IERC20(tokens[i]).safeTransfer(owner(), qty);\n', '            }\n', '        }\n', '    }\n', '\n', '    ///@notice Withdraw affilliate share, retaining goodwill share\n', '    function affilliateWithdraw(address[] calldata tokens) external {\n', '        uint256 tokenBal;\n', '        for (uint256 i = 0; i < tokens.length; i++) {\n', '            tokenBal = affiliateBalance[msg.sender][tokens[i]];\n', '            affiliateBalance[msg.sender][tokens[i]] = 0;\n', '            totalAffiliateBalance[tokens[i]] = totalAffiliateBalance[tokens[i]]\n', '                .sub(tokenBal);\n', '\n', '            if (tokens[i] == ETHAddress) {\n', '                Address.sendValue(msg.sender, tokenBal);\n', '            } else {\n', '                IERC20(tokens[i]).safeTransfer(msg.sender, tokenBal);\n', '            }\n', '        }\n', '    }\n', '\n', '    function() external payable {\n', '        require(msg.sender != tx.origin, "Do not send ETH directly");\n', '    }\n', '}\n', '\n', '// File: contracts/_base/ZapInBaseV2.sol\n', '\n', 'pragma solidity ^0.5.7;\n', '\n', 'contract ZapInBaseV2 is ZapBaseV1 {\n', '    function _pullTokens(\n', '        address token,\n', '        uint256 amount,\n', '        address affiliate,\n', '        bool enableGoodwill,\n', '        bool shouldSellEntireBalance\n', '    ) internal returns (uint256 value) {\n', '        uint256 totalGoodwillPortion;\n', '\n', '        if (token == address(0)) {\n', '            require(msg.value > 0, "No eth sent");\n', '\n', '            // subtract goodwill\n', '            totalGoodwillPortion = _subtractGoodwill(\n', '                ETHAddress,\n', '                msg.value,\n', '                affiliate,\n', '                enableGoodwill\n', '            );\n', '\n', '            return msg.value.sub(totalGoodwillPortion);\n', '        }\n', '        require(amount > 0, "Invalid token amount");\n', '        require(msg.value == 0, "Eth sent with token");\n', '\n', '        //transfer token\n', '        if (shouldSellEntireBalance) {\n', '            require(\n', '                Address.isContract(msg.sender),\n', '                "ERR: shouldSellEntireBalance is true for EOA"\n', '            );\n', '            amount = IERC20(token).allowance(msg.sender, address(this));\n', '        }\n', '        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);\n', '\n', '        // subtract goodwill\n', '        totalGoodwillPortion = _subtractGoodwill(\n', '            token,\n', '            amount,\n', '            affiliate,\n', '            enableGoodwill\n', '        );\n', '\n', '        return amount.sub(totalGoodwillPortion);\n', '    }\n', '\n', '    function _subtractGoodwill(\n', '        address token,\n', '        uint256 amount,\n', '        address affiliate,\n', '        bool enableGoodwill\n', '    ) internal returns (uint256 totalGoodwillPortion) {\n', '        bool whitelisted = feeWhitelist[msg.sender];\n', '        if (enableGoodwill && !whitelisted && goodwill > 0) {\n', '            totalGoodwillPortion = SafeMath.div(\n', '                SafeMath.mul(amount, goodwill),\n', '                10000\n', '            );\n', '\n', '            if (affiliates[affiliate]) {\n', '                if (token == address(0)) {\n', '                    token = ETHAddress;\n', '                }\n', '\n', '                uint256 affiliatePortion =\n', '                    totalGoodwillPortion.mul(affiliateSplit).div(100);\n', '                affiliateBalance[affiliate][token] = affiliateBalance[\n', '                    affiliate\n', '                ][token]\n', '                    .add(affiliatePortion);\n', '                totalAffiliateBalance[token] = totalAffiliateBalance[token].add(\n', '                    affiliatePortion\n', '                );\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/Vesper/Vesper_ZapIn_V1.sol\n', '\n', '// SPDX-License-Identifier: GPLv2\n', '\n', 'pragma solidity ^0.5.7;\n', '\n', 'interface IVesper {\n', '    function token() external view returns (address);\n', '\n', '    function deposit(uint256 amount) external;\n', '}\n', '\n', 'contract Vesper_ZapIn_V1 is ZapInBaseV2 {\n', '    // calldata only accepted for approved zap contracts\n', '    mapping(address => bool) public approvedTargets;\n', '\n', '    event zapIn(address sender, address pool, uint256 tokensRec);\n', '\n', '    constructor(uint256 _goodwill, uint256 _affiliateSplit)\n', '        public\n', '        ZapBaseV1(_goodwill, _affiliateSplit)\n', '    {}\n', '\n', '    /**\n', '    @notice This function adds liquidity to a Vesper vaults with ETH or ERC20 tokens\n', '    @param fromToken The token used for entry (address(0) if ether)\n', '    @param amountIn The amount of fromToken to invest\n', '    @param toVault Vesper vault address\n', '    @param minVaultTokens The minimum acceptable quantity vault tokens to receive. Reverts otherwise\n', '    @param swapTarget Excecution target for the swap or zap\n', '    @param swapData DEX or Zap data\n', '    @param affiliate Affiliate address\n', '    @param shouldSellEntireBalance True if amountIn is determined at execution time (i.e. contract is caller)\n', '    @return tokensReceived- Quantity of Vault tokens received\n', '     */\n', '    function ZapIn(\n', '        address fromToken,\n', '        uint256 amountIn,\n', '        address toVault,\n', '        uint256 minVaultTokens,\n', '        address swapTarget,\n', '        bytes calldata swapData,\n', '        address affiliate,\n', '        bool shouldSellEntireBalance\n', '    ) external payable stopInEmergency returns (uint256 tokensReceived) {\n', '        require(\n', '            approvedTargets[swapTarget] || swapTarget == address(0),\n', '            "Target not Authorized"\n', '        );\n', '\n', '        // get incoming tokens\n', '        uint256 toInvest =\n', '            _pullTokens(\n', '                fromToken,\n', '                amountIn,\n', '                affiliate,\n', '                true,\n', '                shouldSellEntireBalance\n', '            );\n', '\n', '        address underlyingVaultToken = IVesper(toVault).token();\n', '\n', '        // get intermediate token\n', '        uint256 intermediateAmt =\n', '            _fillQuote(\n', '                fromToken,\n', '                underlyingVaultToken,\n', '                toInvest,\n', '                swapTarget,\n', '                swapData\n', '            );\n', '\n', '        // Deposit to Vault\n', '        tokensReceived = _vaultDeposit(\n', '            intermediateAmt,\n', '            toVault,\n', '            minVaultTokens\n', '        );\n', '    }\n', '\n', '    function _vaultDeposit(\n', '        uint256 amount,\n', '        address toVault,\n', '        uint256 minTokensRec\n', '    ) internal returns (uint256 tokensReceived) {\n', '        address underlyingVaultToken = IVesper(toVault).token();\n', '\n', '        _approveToken(underlyingVaultToken, toVault);\n', '\n', '        uint256 iniYVaultBal = IERC20(toVault).balanceOf(address(this));\n', '        IVesper(toVault).deposit(amount);\n', '        tokensReceived = IERC20(toVault).balanceOf(address(this)).sub(\n', '            iniYVaultBal\n', '        );\n', '        require(tokensReceived >= minTokensRec, "Err: High Slippage");\n', '\n', '        IERC20(toVault).safeTransfer(msg.sender, tokensReceived);\n', '        emit zapIn(msg.sender, toVault, tokensReceived);\n', '    }\n', '\n', '    function _fillQuote(\n', '        address _fromTokenAddress,\n', '        address toToken,\n', '        uint256 _amount,\n', '        address _swapTarget,\n', '        bytes memory swapCallData\n', '    ) internal returns (uint256 amtBought) {\n', '        uint256 valueToSend;\n', '\n', '        if (_fromTokenAddress == toToken) {\n', '            return _amount;\n', '        }\n', '\n', '        if (_fromTokenAddress == address(0)) {\n', '            valueToSend = _amount;\n', '        } else {\n', '            _approveToken(_fromTokenAddress, _swapTarget);\n', '        }\n', '\n', '        uint256 iniBal = _getBalance(toToken);\n', '        (bool success, ) = _swapTarget.call.value(valueToSend)(swapCallData);\n', '        require(success, "Error Swapping Tokens 1");\n', '        uint256 finalBal = _getBalance(toToken);\n', '\n', '        amtBought = finalBal.sub(iniBal);\n', '    }\n', '\n', '    function setApprovedTargets(\n', '        address[] calldata targets,\n', '        bool[] calldata isApproved\n', '    ) external onlyOwner {\n', '        require(targets.length == isApproved.length, "Invalid Input length");\n', '\n', '        for (uint256 i = 0; i < targets.length; i++) {\n', '            approvedTargets[targets[i]] = isApproved[i];\n', '        }\n', '    }\n', '}']
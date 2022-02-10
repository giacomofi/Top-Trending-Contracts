['/**\n', ' * Copyright 2017-2020, bZeroX, LLC. All Rights Reserved.\n', ' * Licensed under the Apache License, Version 2.0.\n', ' */\n', '\n', 'pragma solidity 0.5.17;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'interface IWeth {\n', '    function deposit() external payable;\n', '    function withdraw(uint256 wad) external;\n', '}\n', '\n', 'contract IERC20 {\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address _who) public view returns (uint256);\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract IWethERC20 is IWeth, IERC20 {}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b != 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, rounding up and truncating the quotient\n', '    */\n', '    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return divCeil(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, rounding up and truncating the quotient\n', '    */\n', '    function divCeil(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b != 0, errorMessage);\n', '\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = ((a - 1) / b) + 1;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '    function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        return _a < _b ? _a : _b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SignedSafeMath\n', ' * @dev Signed math operations with safety checks that revert on error.\n', ' */\n', 'library SignedSafeMath {\n', '    int256 constant private _INT256_MIN = -2**255;\n', '\n', '        /**\n', '     * @dev Returns the multiplication of two signed integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(int256 a, int256 b) internal pure returns (int256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");\n', '\n', '        int256 c = a * b;\n', '        require(c / a == b, "SignedSafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two signed integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(int256 a, int256 b) internal pure returns (int256) {\n', '        require(b != 0, "SignedSafeMath: division by zero");\n', '        require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");\n', '\n', '        int256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two signed integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two signed integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(int256 a, int256 b) internal pure returns (int256) {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Helps contracts guard against reentrancy attacks.\n', ' * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>\n', ' * @dev If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '\n', '    /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.\n', '    /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056\n', '    uint256 internal constant REENTRANCY_GUARD_FREE = 1;\n', '\n', '    /// @dev Constant for locked guard state\n', '    uint256 internal constant REENTRANCY_GUARD_LOCKED = 2;\n', '\n', '    /**\n', '    * @dev We use a single lock for the whole contract.\n', '    */\n', '    uint256 internal reentrancyLock = REENTRANCY_GUARD_FREE;\n', '\n', '    /**\n', '    * @dev Prevents a contract from calling itself, directly or indirectly.\n', '    * If you mark a function `nonReentrant`, you should also\n', '    * mark it `external`. Calling one `nonReentrant` function from\n', '    * another is not supported. Instead, you can implement a\n', '    * `private` function doing the actual work, and an `external`\n', '    * wrapper marked as `nonReentrant`.\n', '    */\n', '    modifier nonReentrant() {\n', '        require(reentrancyLock == REENTRANCY_GUARD_FREE, "nonReentrant");\n', '        reentrancyLock = REENTRANCY_GUARD_LOCKED;\n', '        _;\n', '        reentrancyLock = REENTRANCY_GUARD_FREE;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following \n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "unauthorized");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface ProtocolLike {\n', '    function borrowOrTradeFromPool(\n', '        bytes32 loanParamsId,\n', '        bytes32 loanId, // if 0, start a new loan\n', '        bool isTorqueLoan,\n', '        uint256 initialMargin,\n', '        address[4] calldata sentAddresses,\n', '            // lender: must match loan if loanId provided\n', '            // borrower: must match loan if loanId provided\n', '            // receiver: receiver of funds (address(0) assumes borrower address)\n', '            // manager: delegated manager of loan unless address(0)\n', '        uint256[5] calldata sentValues,\n', '            // newRate: new loan interest rate\n', '            // newPrincipal: new loan size (borrowAmount + any borrowed interest)\n', '            // torqueInterest: new amount of interest to escrow for Torque loan (determines initial loan length)\n', '            // loanTokenReceived: total loanToken deposit (amount not sent to borrower in the case of Torque loans)\n', '            // collateralTokenReceived: total collateralToken deposit\n', '        bytes calldata loanDataBytes)\n', '        external\n', '        payable\n', '        returns (uint256 newPrincipal, uint256 newCollateral);\n', '\n', '    function getTotalPrincipal(\n', '        address lender,\n', '        address loanToken)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function withdrawAccruedInterest(\n', '        address loanToken)\n', '        external;\n', '\n', '    function getLenderInterestData(\n', '        address lender,\n', '        address loanToken)\n', '        external\n', '        view\n', '        returns (\n', '            uint256 interestPaid,\n', '            uint256 interestPaidDate,\n', '            uint256 interestOwedPerDay,\n', '            uint256 interestUnPaid,\n', '            uint256 interestFeePercent,\n', '            uint256 principalTotal);\n', '\n', '    function priceFeeds()\n', '        external\n', '        view\n', '        returns (address);\n', '\n', '    function getEstimatedMarginExposure(\n', '        address loanToken,\n', '        address collateralToken,\n', '        uint256 loanTokenSent,\n', '        uint256 collateralTokenSent,\n', '        uint256 interestRate,\n', '        uint256 newPrincipal)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function getRequiredCollateralByParams(\n', '        bytes32 loanParamsId,\n', '        address loanToken,\n', '        address collateralToken,\n', '        uint256 newPrincipal,\n', '        bool isTorqueLoan)\n', '        external\n', '        view\n', '        returns (uint256 collateralAmountRequired);\n', '\n', '    function getBorrowAmountByParams(\n', '        bytes32 loanParamsId,\n', '        address loanToken,\n', '        address collateralToken,\n', '        uint256 collateralTokenAmount,\n', '        bool isTorqueLoan)\n', '        external\n', '        view\n', '        returns (uint256 borrowAmount);\n', '\n', '    function isLoanPool(\n', '        address loanPool)\n', '        external\n', '        view\n', '        returns (bool);\n', '\n', '    function lendingFeePercent()\n', '        external\n', '        view\n', '        returns (uint256);\n', '}\n', '\n', 'interface FeedsLike {\n', '    function queryRate(\n', '        address sourceTokenAddress,\n', '        address destTokenAddress)\n', '        external\n', '        view\n', '        returns (uint256 rate, uint256 precision);\n', '}\n', '\n', 'contract ITokenHolderLike {\n', '    function balanceOf(address _who) public view returns (uint256);\n', '    function freeUpTo(uint256 value) public returns (uint256);\n', '    function freeFromUpTo(address from, uint256 value) public returns (uint256);\n', '}\n', '\n', 'contract GasTokenUser {\n', '\n', '    ITokenHolderLike constant public gasToken = ITokenHolderLike(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);\n', '    ITokenHolderLike constant public tokenHolder = ITokenHolderLike(0x55Eb3DD3f738cfdda986B8Eff3fa784477552C61);\n', '\n', '    modifier usesGasToken(address holder) {\n', '        if (holder == address(0)) {\n', '            holder = address(tokenHolder);\n', '        }\n', '\n', '        if (gasToken.balanceOf(holder) != 0) {\n', '            uint256 gasCalcValue = gasleft();\n', '\n', '            _;\n', '\n', '            gasCalcValue = (_gasUsed(gasCalcValue) + 14154) / 41947;\n', '\n', '            if (holder == address(tokenHolder)) {\n', '                tokenHolder.freeUpTo(\n', '                    gasCalcValue\n', '                );\n', '            } else {\n', '                tokenHolder.freeFromUpTo(\n', '                    holder,\n', '                    gasCalcValue\n', '                );\n', '            }\n', '\n', '        } else {\n', '            _;\n', '        }\n', '    }\n', '\n', '    function _gasUsed(\n', '        uint256 startingGas)\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return 21000 +\n', '            startingGas -\n', '            gasleft() +\n', '            16 *\n', '            msg.data.length;\n', '\n', '    }\n', '}\n', '\n', 'contract Pausable {\n', '\n', '    // keccak256("Pausable_FunctionPause")\n', '    bytes32 internal constant Pausable_FunctionPause = 0xa7143c84d793a15503da6f19bf9119a2dac94448ca45d77c8bf08f57b2e91047;\n', '\n', '    modifier pausable(bytes4 sig) {\n', '        require(!_isPaused(sig), "unauthorized");\n', '        _;\n', '    }\n', '\n', '    function _isPaused(\n', '        bytes4 sig)\n', '        internal\n', '        view\n', '        returns (bool isPaused)\n', '    {\n', '        bytes32 slot = keccak256(abi.encodePacked(sig, Pausable_FunctionPause));\n', '        assembly {\n', '            isPaused := sload(slot)\n', '        }\n', '    }\n', '}\n', '\n', 'contract LoanTokenBase is ReentrancyGuard, Ownable, Pausable {\n', '\n', '    uint256 internal constant WEI_PRECISION = 10**18;\n', '    uint256 internal constant WEI_PERCENT_PRECISION = 10**20;\n', '\n', '    int256 internal constant sWEI_PRECISION = 10**18;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    // uint88 for tight packing -> 8 + 88 + 160 = 256\n', '    uint88 internal lastSettleTime_;\n', '\n', '    address public loanTokenAddress;\n', '\n', '    uint256 public baseRate;\n', '    uint256 public rateMultiplier;\n', '    uint256 public lowUtilBaseRate;\n', '    uint256 public lowUtilRateMultiplier;\n', '\n', '    uint256 public targetLevel;\n', '    uint256 public kinkLevel;\n', '    uint256 public maxScaleRate;\n', '\n', '    uint256 internal _flTotalAssetSupply;\n', '    uint256 public checkpointSupply;\n', '    uint256 public initialPrice;\n', '\n', '    mapping (uint256 => bytes32) public loanParamsIds; // mapping of keccak256(collateralToken, isTorqueLoan) to loanParamsId\n', '    mapping (address => uint256) internal checkpointPrices_; // price of token at last user checkpoint\n', '}\n', '\n', 'contract AdvancedTokenStorage is LoanTokenBase {\n', '    using SafeMath for uint256;\n', '\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '\n', '    event Mint(\n', '        address indexed minter,\n', '        uint256 tokenAmount,\n', '        uint256 assetAmount,\n', '        uint256 price\n', '    );\n', '\n', '    event Burn(\n', '        address indexed burner,\n', '        uint256 tokenAmount,\n', '        uint256 assetAmount,\n', '        uint256 price\n', '    );\n', '\n', '    mapping(address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    uint256 internal totalSupply_;\n', '\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(\n', '        address _owner)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(\n', '        address _owner,\n', '        address _spender)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract LoanParamsStruct {\n', '    struct LoanParams {\n', '        bytes32 id;                 // id of loan params object\n', "        bool active;                // if false, this object has been disabled by the owner and can't be used for future loans\n", '        address owner;              // owner of this object\n', '        address loanToken;          // the token being loaned\n', '        address collateralToken;    // the required collateral token\n', '        uint256 minInitialMargin;   // the minimum allowed initial margin\n', '        uint256 maintenanceMargin;  // an unhealthy loan when current margin is at or below this value\n', "        uint256 maxLoanTerm;        // the maximum term for new loans (0 means there's no max term)\n", '    }\n', '}\n', '\n', 'interface ProtocolSettingsLike {\n', '    function setupLoanParams(\n', '        LoanParamsStruct.LoanParams[] calldata loanParamsList)\n', '        external\n', '        returns (bytes32[] memory loanParamsIdList);\n', '\n', '    function disableLoanParams(\n', '        bytes32[] calldata loanParamsIdList)\n', '        external;\n', '}\n', '\n', 'contract LoanTokenSettingsLowerAdmin is AdvancedTokenStorage {\n', '    using SafeMath for uint256;\n', '\n', '    address public constant bZxContract = 0xD8Ee69652E4e4838f2531732a46d1f7F584F0b7f;\n', '\n', '    bytes32 internal constant iToken_LowerAdminAddress = 0x7ad06df6a0af6bd602d90db766e0d5f253b45187c3717a0f9026ea8b10ff0d4b;    // keccak256("iToken_LowerAdminAddress")\n', '\n', '    modifier onlyAdmin() {\n', '        address _lowerAdmin;\n', '        assembly {\n', '            _lowerAdmin := sload(iToken_LowerAdminAddress)\n', '        }\n', '\n', '        require(msg.sender == address(this) ||\n', '            msg.sender == _lowerAdmin ||\n', '            msg.sender == owner(), "unauthorized");\n', '        _;\n', '    }\n', '\n', '    function()\n', '        external\n', '    {\n', '        revert("fallback not allowed");\n', '    }\n', '\n', '    function setupLoanParams(\n', '        LoanParamsStruct.LoanParams[] memory loanParamsList,\n', '        bool areTorqueLoans)\n', '        public\n', '        onlyAdmin\n', '    {\n', '        bytes32[] memory loanParamsIdList;\n', '        address _loanTokenAddress = loanTokenAddress;\n', '\n', '        for (uint256 i = 0; i < loanParamsList.length; i++) {\n', '            loanParamsList[i].loanToken = _loanTokenAddress;\n', '            loanParamsList[i].maxLoanTerm = areTorqueLoans ? 0 : 28 days;\n', '        }\n', '        loanParamsIdList = ProtocolSettingsLike(bZxContract).setupLoanParams(loanParamsList);\n', '        for (uint256 i = 0; i < loanParamsIdList.length; i++) {\n', '            loanParamsIds[uint256(keccak256(abi.encodePacked(\n', '                loanParamsList[i].collateralToken,\n', '                areTorqueLoans // isTorqueLoan\n', '            )))] = loanParamsIdList[i];\n', '        }\n', '    }\n', '\n', '    function disableLoanParams(\n', '        address[] calldata collateralTokens,\n', '        bool[] calldata isTorqueLoans)\n', '        external\n', '        onlyAdmin\n', '    {\n', '        require(collateralTokens.length == isTorqueLoans.length, "count mismatch");\n', '\n', '        bytes32[] memory loanParamsIdList = new bytes32[](collateralTokens.length);\n', '        for (uint256 i = 0; i < collateralTokens.length; i++) {\n', '            uint256 id = uint256(keccak256(abi.encodePacked(\n', '                collateralTokens[i],\n', '                isTorqueLoans[i]\n', '            )));\n', '            loanParamsIdList[i] = loanParamsIds[id];\n', '            delete loanParamsIds[id];\n', '        }\n', '\n', '        ProtocolSettingsLike(bZxContract).disableLoanParams(loanParamsIdList);\n', '    }\n', '\n', '    // These params should be percentages represented like so: 5% = 5000000000000000000\n', "    // rateMultiplier + baseRate can't exceed 100%\n", '    function setDemandCurve(\n', '        uint256 _baseRate,\n', '        uint256 _rateMultiplier,\n', '        uint256 _lowUtilBaseRate,\n', '        uint256 _lowUtilRateMultiplier,\n', '        uint256 _targetLevel,\n', '        uint256 _kinkLevel,\n', '        uint256 _maxScaleRate)\n', '        public\n', '        onlyAdmin\n', '    {\n', '        require(_rateMultiplier.add(_baseRate) <= WEI_PERCENT_PRECISION, "curve params too high");\n', '        require(_lowUtilRateMultiplier.add(_lowUtilBaseRate) <= WEI_PERCENT_PRECISION, "curve params too high");\n', '\n', '        require(_targetLevel <= WEI_PERCENT_PRECISION && _kinkLevel <= WEI_PERCENT_PRECISION, "levels too high");\n', '\n', '        baseRate = _baseRate;\n', '        rateMultiplier = _rateMultiplier;\n', '        lowUtilBaseRate = _lowUtilBaseRate;\n', '        lowUtilRateMultiplier = _lowUtilRateMultiplier;\n', '\n', '        targetLevel = _targetLevel; // 80 ether\n', '        kinkLevel = _kinkLevel; // 90 ether\n', '        maxScaleRate = _maxScaleRate; // 100 ether\n', '    }\n', '\n', '    function toggleFunctionPause(\n', '        string memory funcId,  // example: "mint(uint256,uint256)"\n', '        bool isPaused)\n', '        public\n', '        onlyAdmin\n', '    {\n', '        bytes32 slot = keccak256(abi.encodePacked(bytes4(keccak256(abi.encodePacked(funcId))), Pausable_FunctionPause));\n', '        assembly {\n', '            sstore(slot, isPaused)\n', '        }\n', '    }\n', '}']
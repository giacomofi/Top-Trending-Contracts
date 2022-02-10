['pragma solidity 0.5.17;\n', '\n', 'import "@keep-network/keep-core/contracts/PhasedEscrow.sol";\n', '\n', '/// @title ECDSARewardsEscrowBeneficiary\n', '/// @notice Transfer the received tokens from PhasedEscrow to a designated\n', '///         ECDSARewards contract.\n', 'contract ECDSARewardsEscrowBeneficiary is StakerRewardsBeneficiary {\n', '    constructor(IERC20 _token, IStakerRewards _stakerRewards)\n', '        public\n', '        StakerRewardsBeneficiary(_token, _stakerRewards)\n', '    {}\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type,\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * > It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see `ERC20Detailed`.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through `transferFrom`. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when `approve` or `transferFrom` are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * > Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an `Approval` event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to `approve`. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be aplied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * > Note: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n']
['pragma solidity 0.5.17;\n', '\n', 'import "openzeppelin-solidity/contracts/ownership/Ownable.sol";\n', 'import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";\n', 'import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";\n', '\n', 'interface IBeneficiaryContract {\n', '    function __escrowSentTokens(uint256 amount) external;\n', '}\n', '\n', '/// @title PhasedEscrow\n', '/// @notice A token holder contract allowing contract owner to set beneficiary of\n', '///         tokens held by the contract and allowing the owner to withdraw the\n', '///         tokens to that beneficiary in phases.\n', 'contract PhasedEscrow is Ownable {\n', '    using SafeERC20 for IERC20;\n', '\n', '    event BeneficiaryUpdated(address beneficiary);\n', '    event TokensWithdrawn(address beneficiary, uint256 amount);\n', '\n', '    IERC20 public token;\n', '    IBeneficiaryContract public beneficiary;\n', '\n', '    constructor(IERC20 _token) public {\n', '        token = _token;\n', '    }\n', '\n', '    /// @notice Sets the provided address as a beneficiary allowing it to\n', '    ///         withdraw all tokens from escrow. This function can be called only\n', '    ///         by escrow owner.\n', '    function setBeneficiary(IBeneficiaryContract _beneficiary) external onlyOwner {\n', '        beneficiary = _beneficiary;\n', '        emit BeneficiaryUpdated(address(beneficiary));\n', '    }\n', '\n', '    /// @notice Withdraws the specified number of tokens from escrow to the\n', '    ///         beneficiary. If the beneficiary is not set, or there are\n', '    ///         insufficient tokens in escrow, the function fails.\n', '    function withdraw(uint256 amount) external onlyOwner {\n', '        require(address(beneficiary) != address(0), "Beneficiary not assigned");\n', '\n', '        uint256 balance = token.balanceOf(address(this));\n', '        require(amount <= balance, "Not enough tokens for withdrawal");\n', '\n', '        token.safeTransfer(address(beneficiary), amount);\n', '        emit TokensWithdrawn(address(beneficiary), amount);\n', '\n', '        beneficiary.__escrowSentTokens(amount);\n', '    }\n', '}\n', '\n', 'interface ICurveRewards {\n', '    function notifyRewardAmount(uint256 amount) external;\n', '}\n', '\n', '/// @title CurveRewardsEscrowBeneficiary\n', '/// @notice A beneficiary contract that can receive a withdrawal phase from a\n', '///         PhasedEscrow contract. Immediately stakes the received tokens on a\n', '///         designated CurveRewards contract.\n', 'contract CurveRewardsEscrowBeneficiary is Ownable {\n', '    IERC20 public token;\n', '    ICurveRewards public curveRewards;\n', '\n', '    constructor(IERC20 _token, ICurveRewards _curveRewards) public {\n', '        token = _token;\n', '        curveRewards = _curveRewards;\n', '    }\n', '\n', '    function __escrowSentTokens(uint256 amount) external onlyOwner {\n', '        token.approve(address(curveRewards), amount);\n', '        curveRewards.notifyRewardAmount(amount);\n', '    }\n', '}\n', '\n', '/// @dev Interface of recipient contract for approveAndCall pattern.\n', 'interface IStakerRewards {\n', '    function receiveApproval(\n', '        address _from,\n', '        uint256 _value,\n', '        address _token,\n', '        bytes calldata _extraData\n', '    ) external;\n', '}\n', '\n', '/// @title StakerRewardsBeneficiary\n', '/// @notice An abstract beneficiary contract that can receive a withdrawal phase\n', '///         from a PhasedEscrow contract. The received tokens are immediately \n', '///         funded for a designated rewards escrow beneficiary contract.\n', 'contract StakerRewardsBeneficiary is Ownable {\n', '    IERC20 public token;\n', '    IStakerRewards public stakerRewards;\n', '\n', '    constructor(IERC20 _token, IStakerRewards _stakerRewards) public {\n', '        token = _token;\n', '        stakerRewards = _stakerRewards;\n', '    }\n', '\n', '    function __escrowSentTokens(uint256 amount) external onlyOwner {\n', '        bool success = token.approve(address(stakerRewards), amount);\n', '        require(success, "Token transfer approval failed");\n', '        \n', '        stakerRewards.receiveApproval(\n', '            address(this),\n', '            amount,\n', '            address(token),\n', '            ""\n', '        );\n', '    }\n', '}\n', '\n', '/// @title BeaconBackportRewardsEscrowBeneficiary\n', '/// @notice Transfer the received tokens to a designated\n', '///         BeaconBackportRewardsEscrowBeneficiary contract.\n', 'contract BeaconBackportRewardsEscrowBeneficiary is StakerRewardsBeneficiary {\n', '    constructor(IERC20 _token, IStakerRewards _stakerRewards)\n', '        public\n', '        StakerRewardsBeneficiary(_token, _stakerRewards)\n', '    {}\n', '}\n', '\n', '/// @title BeaconRewardsEscrowBeneficiary\n', '/// @notice Transfer the received tokens to a designated\n', '///         BeaconRewardsEscrowBeneficiary contract.\n', 'contract BeaconRewardsEscrowBeneficiary is StakerRewardsBeneficiary {\n', '    constructor(IERC20 _token, IStakerRewards _stakerRewards)\n', '        public\n', '        StakerRewardsBeneficiary(_token, _stakerRewards)\n', '    {}\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', 'import "./IERC20.sol";\n', 'import "../../math/SafeMath.sol";\n', 'import "../../utils/Address.sol";\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n']

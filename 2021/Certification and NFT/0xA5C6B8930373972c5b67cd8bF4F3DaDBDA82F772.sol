['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-19\n', '*/\n', '\n', '/*\n', "    .'''''''''''..     ..''''''''''''''''..       ..'''''''''''''''..\n", "    .;;;;;;;;;;;'.   .';;;;;;;;;;;;;;;;;;,.     .,;;;;;;;;;;;;;;;;;,.\n", '    .;;;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;,.    .,;;;;;;;;;;;;;;;;;;,.\n', '    .;;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;;,.   .;;;;;;;;;;;;;;;;;;;;,.\n', "    ';;;;;;;;'.  .';;;;;;;;;;;;;;;;;;;;;;,. .';;;;;;;;;;;;;;;;;;;;;,.\n", "    ';;;;;,..   .';;;;;;;;;;;;;;;;;;;;;;;,..';;;;;;;;;;;;;;;;;;;;;;,.\n", "    ......     .';;;;;;;;;;;;;,'''''''''''.,;;;;;;;;;;;;;,'''''''''..\n", '              .,;;;;;;;;;;;;;.           .,;;;;;;;;;;;;;.\n', '             .,;;;;;;;;;;;;,.           .,;;;;;;;;;;;;,.\n', '            .,;;;;;;;;;;;;,.           .,;;;;;;;;;;;;,.\n', '           .,;;;;;;;;;;;;,.           .;;;;;;;;;;;;;,.     .....\n', "          .;;;;;;;;;;;;;'.         ..';;;;;;;;;;;;;'.    .',;;;;,'.\n", "        .';;;;;;;;;;;;;'.         .';;;;;;;;;;;;;;'.   .';;;;;;;;;;.\n", "       .';;;;;;;;;;;;;'.         .';;;;;;;;;;;;;;'.    .;;;;;;;;;;;,.\n", "      .,;;;;;;;;;;;;;'...........,;;;;;;;;;;;;;;.      .;;;;;;;;;;;,.\n", '     .,;;;;;;;;;;;;,..,;;;;;;;;;;;;;;;;;;;;;;;,.       ..;;;;;;;;;,.\n', "    .,;;;;;;;;;;;;,. .,;;;;;;;;;;;;;;;;;;;;;;,.          .',;;;,,..\n", '   .,;;;;;;;;;;;;,.  .,;;;;;;;;;;;;;;;;;;;;;,.              ....\n', "    ..',;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;;,.\n", "       ..',;;;;'.    .,;;;;;;;;;;;;;;;;;;;'.\n", "          ...'..     .';;;;;;;;;;;;;;,,,'.\n", '                       ...............\n', '*/\n', '\n', '// https://github.com/trusttoken/smart-contracts\n', '// Dependency file: @openzeppelin/contracts/GSN/Context.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '// pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', '// Dependency file: contracts/truefi/common/Initializable.sol\n', '\n', '// Copied from https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/v3.0.0/contracts/Initializable.sol\n', '\n', '// pragma solidity 0.6.10;\n', '\n', '/**\n', ' * @title Initializable\n', ' *\n', ' * @dev Helper contract to support initializer functions. To use it, replace\n', ' * the constructor with a function that has the `initializer` modifier.\n', ' * WARNING: Unlike constructors, initializer functions must be manually\n', ' * invoked. This applies both to deploying an Initializable contract, as well\n', ' * as extending an Initializable contract via inheritance.\n', ' * WARNING: When used with inheritance, manual care must be taken to not invoke\n', ' * a parent initializer twice, or ensure that all initializers are idempotent,\n', ' * because this is not dealt with automatically as with constructors.\n', ' */\n', 'contract Initializable {\n', '    /**\n', '     * @dev Indicates that the contract has been initialized.\n', '     */\n', '    bool private initialized;\n', '\n', '    /**\n', '     * @dev Indicates that the contract is in the process of being initialized.\n', '     */\n', '    bool private initializing;\n', '\n', '    /**\n', '     * @dev Modifier to use in the initializer function of a contract.\n', '     */\n', '    modifier initializer() {\n', '        require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '        bool isTopLevelCall = !initializing;\n', '        if (isTopLevelCall) {\n', '            initializing = true;\n', '            initialized = true;\n', '        }\n', '\n', '        _;\n', '\n', '        if (isTopLevelCall) {\n', '            initializing = false;\n', '        }\n', '    }\n', '\n', '    /// @dev Returns true if and only if the function is running in the constructor\n', '    function isConstructor() private view returns (bool) {\n', '        // extcodesize checks the size of the code stored in an address, and\n', '        // address returns the current address. Since the code is still not\n', '        // deployed when running a constructor, any checks on its code size will\n', '        // yield zero, making it an effective way to detect if a contract is\n', '        // under construction or not.\n', '        address self = address(this);\n', '        uint256 cs;\n', '        assembly {\n', '            cs := extcodesize(self)\n', '        }\n', '        return cs == 0;\n', '    }\n', '\n', '    // Reserved storage space to allow for layout changes in the future.\n', '    uint256[50] private ______gap;\n', '}\n', '\n', '\n', '// Dependency file: contracts/truefi/common/UpgradeableOwnable.sol\n', '\n', '// pragma solidity 0.6.10;\n', '\n', '// import {Context} from "@openzeppelin/contracts/GSN/Context.sol";\n', '\n', '// import {Initializable} from "contracts/truefi/common/Initializable.sol";\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Initializable, Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    function initialize() internal initializer {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '// Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '\n', '// pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * // importANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// Dependency file: contracts/truefi/interface/ILoanToken.sol\n', '\n', '// pragma solidity 0.6.10;\n', '\n', '// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', 'interface ILoanToken is IERC20 {\n', '    enum Status {Awaiting, Funded, Withdrawn, Settled, Defaulted, Liquidated}\n', '\n', '    function borrower() external view returns (address);\n', '\n', '    function amount() external view returns (uint256);\n', '\n', '    function term() external view returns (uint256);\n', '\n', '    function apy() external view returns (uint256);\n', '\n', '    function start() external view returns (uint256);\n', '\n', '    function lender() external view returns (address);\n', '\n', '    function debt() external view returns (uint256);\n', '\n', '    function profit() external view returns (uint256);\n', '\n', '    function status() external view returns (Status);\n', '\n', '    function borrowerFee() external view returns (uint256);\n', '\n', '    function receivedAmount() external view returns (uint256);\n', '\n', '    function isLoanToken() external pure returns (bool);\n', '\n', '    function getParameters()\n', '        external\n', '        view\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        );\n', '\n', '    function fund() external;\n', '\n', '    function withdraw(address _beneficiary) external;\n', '\n', '    function close() external;\n', '\n', '    function liquidate() external;\n', '\n', '    function redeem(uint256 _amount) external;\n', '\n', '    function repay(address _sender, uint256 _amount) external;\n', '\n', '    function reclaim() external;\n', '\n', '    function allowTransfer(address account, bool _status) external;\n', '\n', '    function repaid() external view returns (uint256);\n', '\n', '    function balance() external view returns (uint256);\n', '\n', '    function value(uint256 _balance) external view returns (uint256);\n', '\n', '    function currencyToken() external view returns (IERC20);\n', '\n', '    function version() external pure returns (uint8);\n', '}\n', '\n', '\n', '// Dependency file: contracts/truefi/interface/ITrueFiPool.sol\n', '\n', '// pragma solidity 0.6.10;\n', '\n', '// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', '/**\n', ' * TruePool is an ERC20 which represents a share of a pool\n', ' *\n', ' * This contract can be used to wrap opportunities to be compatible\n', ' * with TrueFi and allow users to directly opt-in through the TUSD contract\n', ' *\n', ' * Each TruePool is also a staking opportunity for TRU\n', ' */\n', 'interface ITrueFiPool is IERC20 {\n', '    /// @dev pool token (TUSD)\n', '    function currencyToken() external view returns (IERC20);\n', '\n', '    /// @dev stake token (TRU)\n', '    function stakeToken() external view returns (IERC20);\n', '\n', '    /**\n', '     * @dev join pool\n', '     * 1. Transfer TUSD from sender\n', '     * 2. Mint pool tokens based on value to sender\n', '     */\n', '    function join(uint256 amount) external;\n', '\n', '    /**\n', '     * @dev exit pool\n', '     * 1. Transfer pool tokens from sender\n', '     * 2. Burn pool tokens\n', '     * 3. Transfer value of pool tokens in TUSD to sender\n', '     */\n', '    function exit(uint256 amount) external;\n', '\n', '    /**\n', '     * @dev borrow from pool\n', '     * 1. Transfer TUSD to sender\n', '     * 2. Only lending pool should be allowed to call this\n', '     */\n', '    function borrow(uint256 amount, uint256 fee) external;\n', '\n', '    /**\n', '     * @dev join pool\n', '     * 1. Transfer TUSD from sender\n', '     * 2. Only lending pool should be allowed to call this\n', '     */\n', '    function repay(uint256 amount) external;\n', '}\n', '\n', '\n', '// Dependency file: contracts/truefi/interface/IStakingPool.sol\n', '\n', '// pragma solidity 0.6.10;\n', '\n', '// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', 'interface IStakingPool is IERC20 {\n', '    function stakeSupply() external view returns (uint256);\n', '\n', '    function withdraw(uint256 amount) external;\n', '\n', '    function payFee(uint256 amount, uint256 endTime) external;\n', '}\n', '\n', '\n', '// Dependency file: contracts/truefi/interface/ITruPriceOracle.sol\n', '\n', '// pragma solidity 0.6.10;\n', '\n', 'interface ITruPriceOracle {\n', '    function usdToTru(uint256 amount) external view returns (uint256);\n', '\n', '    function truToUsd(uint256 amount) external view returns (uint256);\n', '}\n', '\n', '\n', '// Dependency file: contracts/truefi/interface/ILoanFactory.sol\n', '\n', '// pragma solidity 0.6.10;\n', '\n', 'interface ILoanFactory {\n', '    function createLoanToken(\n', '        uint256 _amount,\n', '        uint256 _term,\n', '        uint256 _apy\n', '    ) external;\n', '\n', '    function isLoanToken(address) external view returns (bool);\n', '}\n', '\n', '\n', '// Dependency file: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '\n', '// pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// Root file: contracts/truefi/Liquidator.sol\n', '\n', 'pragma solidity 0.6.10;\n', '\n', '// import {Ownable} from "contracts/truefi/common/UpgradeableOwnable.sol";\n', '// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', '// import {ILoanToken} from "contracts/truefi/interface/ILoanToken.sol";\n', '// import {ITrueFiPool} from "contracts/truefi/interface/ITrueFiPool.sol";\n', '// import {IStakingPool} from "contracts/truefi/interface/IStakingPool.sol";\n', '// import {ITruPriceOracle} from "contracts/truefi/interface/ITruPriceOracle.sol";\n', '// import {ILoanFactory} from "contracts/truefi/interface/ILoanFactory.sol";\n', '// import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";\n', '\n', '/**\n', ' * @title Liquidator\n', ' * @notice Liquidate LoanTokens with this Contract\n', ' * @dev When a Loan becomes defaulted, Liquidator allows to\n', ' * compensate pool participants, by transfering some of TRU to the pool\n', ' */\n', 'contract Liquidator is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // ================ WARNING ==================\n', '    // ===== THIS CONTRACT IS INITIALIZABLE ======\n', '    // === STORAGE VARIABLES ARE DECLARED BELOW ==\n', '    // REMOVAL OR REORDER OF VARIABLES WILL RESULT\n', '    // ========= IN STORAGE CORRUPTION ===========\n', '\n', '    ITrueFiPool public pool;\n', '    IStakingPool public stkTru;\n', '    IERC20 public tru;\n', '    ITruPriceOracle public oracle;\n', '    ILoanFactory public factory;\n', '\n', '    // max share of tru to be taken from staking pool during liquidation\n', '    // 1000 -> 10%\n', '    uint256 public fetchMaxShare;\n', '\n', '    // ======= STORAGE DECLARATION END ============\n', '\n', '    /**\n', '     * @dev Emitted fetch max share is changed\n', '     * @param newShare New share set\n', '     */\n', '    event FetchMaxShareChanged(uint256 newShare);\n', '\n', '    /**\n', '     * @dev Emitted when oracle is changed\n', '     * @param newOracle New oracle address\n', '     */\n', '    event OracleChanged(ITruPriceOracle newOracle);\n', '\n', '    /**\n', '     * @dev Emitted when a loan gets liquidated\n', '     * @param loan Loan that has been liquidated\n', '     */\n', '    event Liquidated(ILoanToken loan);\n', '\n', '    /**\n', '     * @dev Initialize this contract\n', '     */\n', '    function initialize(\n', '        ITrueFiPool _pool,\n', '        IStakingPool _stkTru,\n', '        IERC20 _tru,\n', '        ITruPriceOracle _oracle,\n', '        ILoanFactory _factory\n', '    ) public initializer {\n', '        Ownable.initialize();\n', '\n', '        pool = _pool;\n', '        stkTru = _stkTru;\n', '        tru = _tru;\n', '        oracle = _oracle;\n', '        factory = _factory;\n', '        fetchMaxShare = 1000;\n', '    }\n', '\n', '    /**\n', '     * @dev Set new max fetch share\n', '     * @param newShare New share to be set\n', '     */\n', '    function setFetchMaxShare(uint256 newShare) external onlyOwner {\n', '        require(newShare > 0, "Liquidator: Share cannot be set to 0");\n', '        require(newShare <= 10000, "Liquidator: Share cannot be larger than 10000");\n', '        fetchMaxShare = newShare;\n', '        emit FetchMaxShareChanged(newShare);\n', '    }\n', '\n', '    /**\n', '     * @dev Change oracle\n', '     * @param newOracle New oracle for liquidator\n', '     */\n', '    function setOracle(ITruPriceOracle newOracle) external onlyOwner {\n', '        // Check if new oracle implements method\n', '        require(newOracle.usdToTru(1 ether) > 0, "Liquidator: Oracle lacks usdToTru method");\n', '\n', '        oracle = newOracle;\n', '\n', '        emit OracleChanged(newOracle);\n', '    }\n', '\n', '    /**\n', '     * @dev Liquidates a defaulted Loan, withdraws a portion of tru from staking pool\n', '     * then transfers tru to TrueFiPool as compensation\n', '     * @param loan Loan to be liquidated\n', '     */\n', '    function liquidate(ILoanToken loan) external {\n', '        require(factory.isLoanToken(address(loan)), "Liquidator: Unknown loan");\n', '        uint256 defaultedValue = getAmountToWithdraw(loan.debt().sub(loan.repaid()));\n', '        stkTru.withdraw(defaultedValue);\n', '        require(loan.status() == ILoanToken.Status.Defaulted, "Liquidator: Loan must be defaulted");\n', '        loan.liquidate();\n', '        require(tru.transfer(address(pool), defaultedValue));\n', '        emit Liquidated(loan);\n', '    }\n', '\n', '    /**\n', '     * @dev Calculate amount of tru to be withdrawn from staking pool (not more than preset share)\n', '     * @param deficit Amount of tusd lost on defaulted loan\n', '     * @return amount of TRU to be withdrawn on liquidation\n', '     */\n', '    function getAmountToWithdraw(uint256 deficit) internal view returns (uint256) {\n', '        uint256 stakingPoolSupply = stkTru.stakeSupply();\n', '        uint256 maxWithdrawValue = stakingPoolSupply.mul(fetchMaxShare).div(10000);\n', '        uint256 deficitInTru = oracle.usdToTru(deficit);\n', '        return maxWithdrawValue > deficitInTru ? deficitInTru : maxWithdrawValue;\n', '    }\n', '}']
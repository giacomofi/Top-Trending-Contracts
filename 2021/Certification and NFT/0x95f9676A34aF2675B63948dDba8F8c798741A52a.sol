['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-14\n', '*/\n', '\n', '// SPDX-License-Identifier:  AGPL-3.0-or-later // hevm: flattened sources of contracts/library/Util.sol\n', 'pragma solidity =0.6.11 >=0.6.0 <0.8.0;\n', '\n', '////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol\n', '/* pragma solidity >=0.6.0 <0.8.0; */\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '////// contracts/interfaces/IERC20Details.sol\n', '/* pragma solidity 0.6.11; */\n', '\n', '/* import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */\n', '\n', 'interface IERC20Details is IERC20 {\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint256);\n', '\n', '}\n', '\n', '////// contracts/interfaces/IMapleGlobals.sol\n', '/* pragma solidity 0.6.11; */\n', '\n', 'interface IMapleGlobals {\n', '\n', '    function pendingGovernor() external view returns (address);\n', '\n', '    function governor() external view returns (address);\n', '\n', '    function globalAdmin() external view returns (address);\n', '\n', '    function mpl() external view returns (address);\n', '\n', '    function mapleTreasury() external view returns (address);\n', '\n', '    function isValidBalancerPool(address) external view returns (bool);\n', '\n', '    function treasuryFee() external view returns (uint256);\n', '\n', '    function investorFee() external view returns (uint256);\n', '\n', '    function defaultGracePeriod() external view returns (uint256);\n', '\n', '    function fundingPeriod() external view returns (uint256);\n', '\n', '    function swapOutRequired() external view returns (uint256);\n', '\n', '    function isValidLiquidityAsset(address) external view returns (bool);\n', '\n', '    function isValidCollateralAsset(address) external view returns (bool);\n', '\n', '    function isValidPoolDelegate(address) external view returns (bool);\n', '\n', '    function validCalcs(address) external view returns (bool);\n', '\n', '    function isValidCalc(address, uint8) external view returns (bool);\n', '\n', '    function getLpCooldownParams() external view returns (uint256, uint256);\n', '\n', '    function isValidLoanFactory(address) external view returns (bool);\n', '\n', '    function isValidSubFactory(address, address, uint8) external view returns (bool);\n', '\n', '    function isValidPoolFactory(address) external view returns (bool);\n', '    \n', '    function getLatestPrice(address) external view returns (uint256);\n', '    \n', '    function defaultUniswapPath(address, address) external view returns (address);\n', '\n', '    function minLoanEquity() external view returns (uint256);\n', '    \n', '    function maxSwapSlippage() external view returns (uint256);\n', '\n', '    function protocolPaused() external view returns (bool);\n', '\n', '    function stakerCooldownPeriod() external view returns (uint256);\n', '\n', '    function lpCooldownPeriod() external view returns (uint256);\n', '\n', '    function stakerUnstakeWindow() external view returns (uint256);\n', '\n', '    function lpWithdrawWindow() external view returns (uint256);\n', '\n', '    function oracleFor(address) external view returns (address);\n', '\n', '    function validSubFactories(address, address) external view returns (bool);\n', '\n', '    function setStakerCooldownPeriod(uint256) external;\n', '\n', '    function setLpCooldownPeriod(uint256) external;\n', '\n', '    function setStakerUnstakeWindow(uint256) external;\n', '\n', '    function setLpWithdrawWindow(uint256) external;\n', '\n', '    function setMaxSwapSlippage(uint256) external;\n', '\n', '    function setGlobalAdmin(address) external;\n', '\n', '    function setValidBalancerPool(address, bool) external;\n', '\n', '    function setProtocolPause(bool) external;\n', '\n', '    function setValidPoolFactory(address, bool) external;\n', '\n', '    function setValidLoanFactory(address, bool) external;\n', '\n', '    function setValidSubFactory(address, address, bool) external;\n', '\n', '    function setDefaultUniswapPath(address, address, address) external;\n', '\n', '    function setPoolDelegateAllowlist(address, bool) external;\n', '\n', '    function setCollateralAsset(address, bool) external;\n', '\n', '    function setLiquidityAsset(address, bool) external;\n', '\n', '    function setCalc(address, bool) external;\n', '\n', '    function setInvestorFee(uint256) external;\n', '\n', '    function setTreasuryFee(uint256) external;\n', '\n', '    function setMapleTreasury(address) external;\n', '\n', '    function setDefaultGracePeriod(uint256) external;\n', '\n', '    function setMinLoanEquity(uint256) external;\n', '\n', '    function setFundingPeriod(uint256) external;\n', '\n', '    function setSwapOutRequired(uint256) external;\n', '\n', '    function setPriceOracle(address, address) external;\n', '\n', '    function setPendingGovernor(address) external;\n', '\n', '    function acceptGovernor() external;\n', '\n', '}\n', '\n', '////// lib/openzeppelin-contracts/contracts/math/SafeMath.sol\n', '/* pragma solidity >=0.6.0 <0.8.0; */\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '////// contracts/library/Util.sol\n', '/* pragma solidity 0.6.11; */\n', '\n', '/* import "../interfaces/IERC20Details.sol"; */\n', '/* import "../interfaces/IMapleGlobals.sol"; */\n', '/* import "lib/openzeppelin-contracts/contracts/math/SafeMath.sol"; */\n', '\n', '/// @title Util is a library that contains utility functions.\n', 'library Util {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '        @dev    Calculates the minimum amount from a swap (adjustable for price slippage).\n', '        @param  globals   Instance of a MapleGlobals.\n', '        @param  fromAsset Address of ERC-20 that will be swapped.\n', '        @param  toAsset   Address of ERC-20 that will returned from swap.\n', '        @param  swapAmt   Amount of `fromAsset` to be swapped.\n', '        @return Expected amount of `toAsset` to receive from swap based on current oracle prices.\n', '    */\n', '    function calcMinAmount(IMapleGlobals globals, address fromAsset, address toAsset, uint256 swapAmt) external view returns (uint256) {\n', '        return \n', '            swapAmt\n', '                .mul(globals.getLatestPrice(fromAsset))           // Convert from `fromAsset` value.\n', '                .mul(10 ** IERC20Details(toAsset).decimals())     // Convert to `toAsset` decimal precision.\n', '                .div(globals.getLatestPrice(toAsset))             // Convert to `toAsset` value.\n', '                .div(10 ** IERC20Details(fromAsset).decimals());  // Convert from `fromAsset` decimal precision.\n', '    }\n', '}']
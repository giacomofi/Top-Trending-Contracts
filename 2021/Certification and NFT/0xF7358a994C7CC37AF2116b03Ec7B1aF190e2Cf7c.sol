['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.4.25 <0.7.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";\n', 'import { UniERC20 } from "../Libraries/LibUniERC20.sol";\n', 'import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import { IProvider } from "./IProvider.sol";\n', '\n', 'interface ITokenInterface {\n', '  function approve(address, uint256) external;\n', '\n', '  function transfer(address, uint256) external;\n', '\n', '  function transferFrom(\n', '    address,\n', '    address,\n', '    uint256\n', '  ) external;\n', '\n', '  function deposit() external payable;\n', '\n', '  function withdraw(uint256) external;\n', '\n', '  function balanceOf(address) external view returns (uint256);\n', '\n', '  function decimals() external view returns (uint256);\n', '}\n', '\n', 'interface IAaveInterface {\n', '  function deposit(\n', '    address _asset,\n', '    uint256 _amount,\n', '    address _onBehalfOf,\n', '    uint16 _referralCode\n', '  ) external;\n', '\n', '  function withdraw(\n', '    address _asset,\n', '    uint256 _amount,\n', '    address _to\n', '  ) external;\n', '\n', '  function borrow(\n', '    address _asset,\n', '    uint256 _amount,\n', '    uint256 _interestRateMode,\n', '    uint16 _referralCode,\n', '    address _onBehalfOf\n', '  ) external;\n', '\n', '  function repay(\n', '    address _asset,\n', '    uint256 _amount,\n', '    uint256 _rateMode,\n', '    address _onBehalfOf\n', '  ) external;\n', '\n', '  function setUserUseReserveAsCollateral(address _asset, bool _useAsCollateral) external;\n', '}\n', '\n', 'interface AaveLendingPoolProviderInterface {\n', '  function getLendingPool() external view returns (address);\n', '}\n', '\n', 'interface AaveDataProviderInterface {\n', '  function getReserveTokensAddresses(address _asset)\n', '    external\n', '    view\n', '    returns (\n', '      address aTokenAddress,\n', '      address stableDebtTokenAddress,\n', '      address variableDebtTokenAddress\n', '    );\n', '\n', '  function getUserReserveData(address _asset, address _user)\n', '    external\n', '    view\n', '    returns (\n', '      uint256 currentATokenBalance,\n', '      uint256 currentStableDebt,\n', '      uint256 currentVariableDebt,\n', '      uint256 principalStableDebt,\n', '      uint256 scaledVariableDebt,\n', '      uint256 stableBorrowRate,\n', '      uint256 liquidityRate,\n', '      uint40 stableRateLastUpdated,\n', '      bool usageAsCollateralEnabled\n', '    );\n', '\n', '  function getReserveData(address _asset)\n', '    external\n', '    view\n', '    returns (\n', '      uint256 availableLiquidity,\n', '      uint256 totalStableDebt,\n', '      uint256 totalVariableDebt,\n', '      uint256 liquidityRate,\n', '      uint256 variableBorrowRate,\n', '      uint256 stableBorrowRate,\n', '      uint256 averageStableBorrowRate,\n', '      uint256 liquidityIndex,\n', '      uint256 variableBorrowIndex,\n', '      uint40 lastUpdateTimestamp\n', '    );\n', '}\n', '\n', 'interface AaveAddressProviderRegistryInterface {\n', '  function getAddressesProvidersList() external view returns (address[] memory);\n', '}\n', '\n', 'contract ProviderAave is IProvider {\n', '  using SafeMath for uint256;\n', '  using UniERC20 for IERC20;\n', '\n', '  function _getAaveProvider() internal pure returns (AaveLendingPoolProviderInterface) {\n', '    return AaveLendingPoolProviderInterface(0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5); //mainnet\n', '  }\n', '\n', '  function _getAaveDataProvider() internal pure returns (AaveDataProviderInterface) {\n', '    return AaveDataProviderInterface(0x057835Ad21a177dbdd3090bB1CAE03EaCF78Fc6d); //mainnet\n', '  }\n', '\n', '  function _getWethAddr() internal pure returns (address) {\n', '    return 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // Mainnet WETH Address\n', '  }\n', '\n', '  function _getEthAddr() internal pure returns (address) {\n', '    return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; // ETH Address\n', '  }\n', '\n', '  function _getIsColl(\n', '    AaveDataProviderInterface _aaveData,\n', '    address _token,\n', '    address _user\n', '  ) internal view returns (bool isCol) {\n', '    (, , , , , , , , isCol) = _aaveData.getUserReserveData(_token, _user);\n', '  }\n', '\n', '  function _convertEthToWeth(\n', '    bool _isEth,\n', '    ITokenInterface _token,\n', '    uint256 _amount\n', '  ) internal {\n', '    if (_isEth) _token.deposit{ value: _amount }();\n', '  }\n', '\n', '  function _convertWethToEth(\n', '    bool _isEth,\n', '    ITokenInterface _token,\n', '    uint256 _amount\n', '  ) internal {\n', '    if (_isEth) {\n', '      _token.approve(address(_token), _amount);\n', '      _token.withdraw(_amount);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Return the borrowing rate of ETH/ERC20_Token.\n', '   * @param _asset to query the borrowing rate.\n', '   */\n', '  function getBorrowRateFor(address _asset) external view override returns (uint256) {\n', '    AaveDataProviderInterface aaveData = _getAaveDataProvider();\n', '\n', '    (, , , , uint256 variableBorrowRate, , , , , ) =\n', '      AaveDataProviderInterface(aaveData).getReserveData(\n', '        _asset == _getEthAddr() ? _getWethAddr() : _asset\n', '      );\n', '\n', '    return variableBorrowRate;\n', '  }\n', '\n', '  /**\n', '   * @dev Return borrow balance of ETH/ERC20_Token.\n', '   * @param _asset token address to query the balance.\n', '   */\n', '  function getBorrowBalance(address _asset) external view override returns (uint256) {\n', '    AaveDataProviderInterface aaveData = _getAaveDataProvider();\n', '\n', '    bool isEth = _asset == _getEthAddr();\n', '    address _token = isEth ? _getWethAddr() : _asset;\n', '\n', '    (, , uint256 variableDebt, , , , , , ) = aaveData.getUserReserveData(_token, msg.sender);\n', '\n', '    return variableDebt;\n', '  }\n', '\n', '  /**\n', '   * @dev Return deposit balance of ETH/ERC20_Token.\n', '   * @param _asset token address to query the balance.\n', '   */\n', '  function getDepositBalance(address _asset) external view override returns (uint256) {\n', '    AaveDataProviderInterface aaveData = _getAaveDataProvider();\n', '\n', '    bool isEth = _asset == _getEthAddr();\n', '    address _token = isEth ? _getWethAddr() : _asset;\n', '\n', '    (uint256 atokenBal, , , , , , , , ) = aaveData.getUserReserveData(_token, msg.sender);\n', '\n', '    return atokenBal;\n', '  }\n', '\n', '  /**\n', '   * @dev Deposit ETH/ERC20_Token.\n', '   * @param _asset token address to deposit.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)\n', '   * @param _amount token amount to deposit.\n', '   */\n', '  function deposit(address _asset, uint256 _amount) external payable override {\n', '    IAaveInterface aave = IAaveInterface(_getAaveProvider().getLendingPool());\n', '    AaveDataProviderInterface aaveData = _getAaveDataProvider();\n', '\n', '    bool isEth = _asset == _getEthAddr();\n', '    address _token = isEth ? _getWethAddr() : _asset;\n', '\n', '    ITokenInterface tokenContract = ITokenInterface(_token);\n', '\n', '    if (isEth) {\n', '      _amount = _amount == uint256(-1) ? address(this).balance : _amount;\n', '      _convertEthToWeth(isEth, tokenContract, _amount);\n', '    } else {\n', '      _amount = _amount == uint256(-1) ? tokenContract.balanceOf(address(this)) : _amount;\n', '    }\n', '\n', '    tokenContract.approve(address(aave), _amount);\n', '\n', '    aave.deposit(_token, _amount, address(this), 0);\n', '\n', '    if (!_getIsColl(aaveData, _token, address(this))) {\n', '      aave.setUserUseReserveAsCollateral(_token, true);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Borrow ETH/ERC20_Token.\n', '   * @param _asset token address to borrow.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)\n', '   * @param _amount token amount to borrow.\n', '   */\n', '  function borrow(address _asset, uint256 _amount) external payable override {\n', '    IAaveInterface aave = IAaveInterface(_getAaveProvider().getLendingPool());\n', '\n', '    bool isEth = _asset == _getEthAddr();\n', '    address _token = isEth ? _getWethAddr() : _asset;\n', '\n', '    aave.borrow(_token, _amount, 2, 0, address(this));\n', '    _convertWethToEth(isEth, ITokenInterface(_token), _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Withdraw ETH/ERC20_Token.\n', '   * @param _asset token address to withdraw.\n', '   * @param _amount token amount to withdraw.\n', '   */\n', '  function withdraw(address _asset, uint256 _amount) external payable override {\n', '    IAaveInterface aave = IAaveInterface(_getAaveProvider().getLendingPool());\n', '\n', '    bool isEth = _asset == _getEthAddr();\n', '    address _token = isEth ? _getWethAddr() : _asset;\n', '\n', '    ITokenInterface tokenContract = ITokenInterface(_token);\n', '    uint256 initialBal = tokenContract.balanceOf(address(this));\n', '\n', '    aave.withdraw(_token, _amount, address(this));\n', '    uint256 finalBal = tokenContract.balanceOf(address(this));\n', '    _amount = finalBal.sub(initialBal);\n', '\n', '    _convertWethToEth(isEth, tokenContract, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Payback borrowed ETH/ERC20_Token.\n', '   * @param _asset token address to payback.\n', '   * @param _amount token amount to payback.\n', '   */\n', '\n', '  function payback(address _asset, uint256 _amount) external payable override {\n', '    IAaveInterface aave = IAaveInterface(_getAaveProvider().getLendingPool());\n', '    AaveDataProviderInterface aaveData = _getAaveDataProvider();\n', '\n', '    bool isEth = _asset == _getEthAddr();\n', '    address _token = isEth ? _getWethAddr() : _asset;\n', '\n', '    ITokenInterface tokenContract = ITokenInterface(_token);\n', '\n', '    (, , uint256 variableDebt, , , , , , ) = aaveData.getUserReserveData(_token, address(this));\n', '    _amount = _amount == uint256(-1) ? variableDebt : _amount;\n', '\n', '    if (isEth) _convertEthToWeth(isEth, tokenContract, _amount);\n', '\n', '    tokenContract.approve(address(aave), _amount);\n', '\n', '    aave.repay(_token, _amount, 2, address(this));\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', 'import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";\n', '\n', 'library UniERC20 {\n', '  using SafeERC20 for IERC20;\n', '\n', '  IERC20 private constant _ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);\n', '  IERC20 private constant _ZERO_ADDRESS = IERC20(0);\n', '\n', '  function isETH(IERC20 token) internal pure returns (bool) {\n', '    return (token == _ZERO_ADDRESS || token == _ETH_ADDRESS);\n', '  }\n', '\n', '  function uniBalanceOf(IERC20 token, address account) internal view returns (uint256) {\n', '    if (isETH(token)) {\n', '      return account.balance;\n', '    } else {\n', '      return token.balanceOf(account);\n', '    }\n', '  }\n', '\n', '  function uniTransfer(IERC20 token, address payable to, uint256 amount) internal {\n', '    if (amount > 0) {\n', '      if (isETH(token)) {\n', '        to.transfer(amount);\n', '      } else {\n', '        token.safeTransfer(to, amount);\n', '      }\n', '    }\n', '  }\n', '\n', '  function uniApprove(IERC20 token, address to, uint256 amount) internal {\n', '    require(!isETH(token), "Approve called on ETH");\n', '\n', '    if (amount == 0) {\n', '      token.safeApprove(to, 0);\n', '    } else {\n', '      uint256 allowance = token.allowance(address(this), to);\n', '      if (allowance < amount) {\n', '        if (allowance > 0) {\n', '          token.safeApprove(to, 0);\n', '        }\n', '        token.safeApprove(to, amount);\n', '      }\n', '    }\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.4.25 <0.7.0;\n', '\n', 'interface IProvider {\n', '  //Basic Core Functions\n', '\n', '  function deposit(address _collateralAsset, uint256 _collateralAmount) external payable;\n', '\n', '  function borrow(address _borrowAsset, uint256 _borrowAmount) external payable;\n', '\n', '  function withdraw(address _collateralAsset, uint256 _collateralAmount) external payable;\n', '\n', '  function payback(address _borrowAsset, uint256 _borrowAmount) external payable;\n', '\n', '  // returns the borrow annualized rate for an asset in ray (1e27)\n', '  //Example 8.5% annual interest = 0.085 x 10^27 = 85000000000000000000000000 or 85*(10**24)\n', '  function getBorrowRateFor(address _asset) external view returns (uint256);\n', '\n', '  function getBorrowBalance(address _asset) external view returns (uint256);\n', '\n', '  function getDepositBalance(address _asset) external view returns (uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "./IERC20.sol";\n', 'import "../../math/SafeMath.sol";\n', 'import "../../utils/Address.sol";\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 1000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']
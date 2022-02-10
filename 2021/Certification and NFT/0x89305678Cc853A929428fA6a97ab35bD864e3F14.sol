['pragma solidity ^0.7.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import { TokenInterface, AccountInterface } from "../../common/interfaces.sol";\n', 'import { AaveInterface, ATokenInterface } from "./interfaces.sol";\n', 'import { Helpers } from "./helpers.sol";\n', 'import { Events } from "./events.sol";\n', '\n', 'abstract contract AaveResolver is Helpers, Events {\n', '    function _TransferAtokens(\n', '        uint _length,\n', '        AaveInterface aave,\n', '        ATokenInterface[] memory atokenContracts,\n', '        uint[] memory amts,\n', '        address[] memory tokens,\n', '        address userAccount\n', '    ) internal {\n', '        for (uint i = 0; i < _length; i++) {\n', '            if (amts[i] > 0) {\n', '                require(atokenContracts[i].transferFrom(userAccount, address(this), amts[i]), "allowance?");\n', '                \n', '                if (!getIsColl(tokens[i], address(this))) {\n', '                    aave.setUserUseReserveAsCollateral(tokens[i], true);\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    function _borrowOne(AaveInterface aave, address token, uint amt, uint rateMode) private {\n', '        aave.borrow(token, amt, rateMode, referalCode, address(this));\n', '    }\n', '\n', '    function _paybackBehalfOne(AaveInterface aave, address token, uint amt, uint rateMode, address user) private {\n', '        aave.repay(token, amt, rateMode, user);\n', '    }\n', '\n', '    function _BorrowStable(\n', '        uint _length,\n', '        AaveInterface aave,\n', '        address[] memory tokens,\n', '        uint256[] memory amts\n', '    ) internal {\n', '        for (uint i = 0; i < _length; i++) {\n', '            if (amts[i] > 0) {\n', '                _borrowOne(aave, tokens[i], amts[i], 1);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _BorrowVariable(\n', '        uint _length,\n', '        AaveInterface aave,\n', '        address[] memory tokens,\n', '        uint256[] memory amts\n', '    ) internal {\n', '        for (uint i = 0; i < _length; i++) {\n', '            if (amts[i] > 0) {\n', '                _borrowOne(aave, tokens[i], amts[i], 2);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _PaybackStable(\n', '        uint _length,\n', '        AaveInterface aave,\n', '        address[] memory tokens,\n', '        uint256[] memory amts,\n', '        address user\n', '    ) internal {\n', '        for (uint i = 0; i < _length; i++) {\n', '            if (amts[i] > 0) {\n', '                _paybackBehalfOne(aave, tokens[i], amts[i], 1, user);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _PaybackVariable(\n', '        uint _length,\n', '        AaveInterface aave,\n', '        address[] memory tokens,\n', '        uint256[] memory amts,\n', '        address user\n', '    ) internal {\n', '        for (uint i = 0; i < _length; i++) {\n', '            if (amts[i] > 0) {\n', '                _paybackBehalfOne(aave, tokens[i], amts[i], 2, user);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'contract AaveImportResolver is AaveResolver {\n', '    struct ImportData {\n', '        uint[] supplyAmts;\n', '        uint[] variableBorrowAmts;\n', '        uint[] stableBorrowAmts;\n', '        uint[] totalBorrowAmts;\n', '        address[] supplyTokens;\n', '        address[] borrowTokens;\n', '        ATokenInterface[] aTokens;\n', '    }\n', '\n', '    function importAave(\n', '        address userAccount,\n', '        address[] calldata supplyTokens,\n', '        address[] calldata borrowTokens,\n', '        bool convertStable\n', '    ) external payable returns (string memory _eventName, bytes memory _eventParam) {\n', '        require(AccountInterface(address(this)).isAuth(userAccount), "user-account-not-auth");\n', '\n', '        require(supplyTokens.length > 0, "0-length-not-allowed");\n', '\n', '        ImportData memory data;\n', '\n', '        AaveInterface aave = AaveInterface(aaveProvider.getLendingPool());\n', '\n', '        data.supplyAmts = new uint[](supplyTokens.length);\n', '        data.supplyTokens = new address[](supplyTokens.length);\n', '        data.aTokens = new ATokenInterface[](supplyTokens.length);\n', '\n', '        for (uint i = 0; i < supplyTokens.length; i++) {\n', '            address _token = supplyTokens[i] == ethAddr ? wethAddr : supplyTokens[i];\n', '            (address _aToken, ,) = aaveData.getReserveTokensAddresses(_token);\n', '            data.supplyTokens[i] = _token;\n', '            data.aTokens[i] = ATokenInterface(_aToken);\n', '            data.supplyAmts[i] = data.aTokens[i].balanceOf(userAccount);\n', '        }\n', '\n', '        if (borrowTokens.length > 0) {\n', '            data.variableBorrowAmts = new uint[](borrowTokens.length);\n', '            data.stableBorrowAmts = new uint[](borrowTokens.length);\n', '            data.totalBorrowAmts = new uint[](borrowTokens.length);\n', '            data.borrowTokens = new address[](borrowTokens.length);\n', '\n', '            for (uint i = 0; i < borrowTokens.length; i++) {\n', '                address _token = borrowTokens[i] == ethAddr ? wethAddr : borrowTokens[i];\n', '                data.borrowTokens[i] = _token;\n', '\n', '                (\n', '                    ,\n', '                    data.stableBorrowAmts[i],\n', '                    data.variableBorrowAmts[i],\n', '                    ,,,,,\n', '                ) = aaveData.getUserReserveData(_token, userAccount);\n', '\n', '                data.totalBorrowAmts[i] = add(data.stableBorrowAmts[i], data.variableBorrowAmts[i]);\n', '\n', '                if (data.totalBorrowAmts[i] > 0) {\n', '                    TokenInterface(_token).approve(address(aave), data.totalBorrowAmts[i]);\n', '                }\n', '            }\n', '\n', '            if (convertStable) {\n', '                _BorrowVariable(borrowTokens.length, aave, data.borrowTokens, data.totalBorrowAmts);\n', '            } else {\n', '                _BorrowStable(borrowTokens.length, aave, data.borrowTokens, data.stableBorrowAmts);\n', '                _BorrowVariable(borrowTokens.length, aave, data.borrowTokens, data.variableBorrowAmts);\n', '            }\n', '\n', '            _PaybackStable(borrowTokens.length, aave, data.borrowTokens, data.stableBorrowAmts, userAccount);\n', '            _PaybackVariable(borrowTokens.length, aave, data.borrowTokens, data.variableBorrowAmts, userAccount);\n', '        }\n', '\n', '        _TransferAtokens(supplyTokens.length, aave, data.aTokens, data.supplyAmts, data.supplyTokens, userAccount);\n', '\n', '        _eventName = "LogAaveV2Import(address,bool,address[],address[],uint256[],uint256[],uint256[])";\n', '        _eventParam = abi.encode(\n', '            userAccount,\n', '            convertStable,\n', '            supplyTokens,\n', '            borrowTokens,\n', '            data.supplyAmts,\n', '            data.stableBorrowAmts,\n', '            data.variableBorrowAmts\n', '        );\n', '    }\n', '}\n', '\n', 'contract ConnectV2AaveV2Import is AaveImportResolver {\n', '    string public constant name = "V2-AaveV2-Import-v1";\n', '}\n', '\n', 'pragma solidity ^0.7.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface TokenInterface {\n', '    function approve(address, uint256) external;\n', '    function transfer(address, uint) external;\n', '    function transferFrom(address, address, uint) external;\n', '    function deposit() external payable;\n', '    function withdraw(uint) external;\n', '    function balanceOf(address) external view returns (uint);\n', '    function decimals() external view returns (uint);\n', '}\n', '\n', 'interface MemoryInterface {\n', '    function getUint(uint id) external returns (uint num);\n', '    function setUint(uint id, uint val) external;\n', '}\n', '\n', 'interface InstaMapping {\n', '    function cTokenMapping(address) external view returns (address);\n', '    function gemJoinMapping(bytes32) external view returns (address);\n', '}\n', '\n', 'interface AccountInterface {\n', '    function enable(address) external;\n', '    function disable(address) external;\n', '    function isAuth(address) external view returns (bool);\n', '    function cast(\n', '        string[] calldata _targets,\n', '        bytes[] calldata _datas,\n', '        address _origin\n', '    ) external payable returns (bytes32);\n', '}\n', '\n', 'pragma solidity ^0.7.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface AaveInterface {\n', '    function deposit(address _asset, uint256 _amount, address _onBehalfOf, uint16 _referralCode) external;\n', '    function withdraw(address _asset, uint256 _amount, address _to) external;\n', '    function borrow(\n', '        address _asset,\n', '        uint256 _amount,\n', '        uint256 _interestRateMode,\n', '        uint16 _referralCode,\n', '        address _onBehalfOf\n', '    ) external;\n', '    function repay(address _asset, uint256 _amount, uint256 _rateMode, address _onBehalfOf) external;\n', '    function setUserUseReserveAsCollateral(address _asset, bool _useAsCollateral) external;\n', '    function getUserAccountData(address user) external view returns (\n', '        uint256 totalCollateralETH,\n', '        uint256 totalDebtETH,\n', '        uint256 availableBorrowsETH,\n', '        uint256 currentLiquidationThreshold,\n', '        uint256 ltv,\n', '        uint256 healthFactor\n', '    );\n', '}\n', '\n', 'interface AaveLendingPoolProviderInterface {\n', '    function getLendingPool() external view returns (address);\n', '}\n', '\n', '// Aave Protocol Data Provider\n', 'interface AaveDataProviderInterface {\n', '    function getReserveTokensAddresses(address _asset) external view returns (\n', '        address aTokenAddress,\n', '        address stableDebtTokenAddress,\n', '        address variableDebtTokenAddress\n', '    );\n', '    function getUserReserveData(address _asset, address _user) external view returns (\n', '        uint256 currentATokenBalance,\n', '        uint256 currentStableDebt,\n', '        uint256 currentVariableDebt,\n', '        uint256 principalStableDebt,\n', '        uint256 scaledVariableDebt,\n', '        uint256 stableBorrowRate,\n', '        uint256 liquidityRate,\n', '        uint40 stableRateLastUpdated,\n', '        bool usageAsCollateralEnabled\n', '    );\n', '    function getReserveConfigurationData(address asset) external view returns (\n', '        uint256 decimals,\n', '        uint256 ltv,\n', '        uint256 liquidationThreshold,\n', '        uint256 liquidationBonus,\n', '        uint256 reserveFactor,\n', '        bool usageAsCollateralEnabled,\n', '        bool borrowingEnabled,\n', '        bool stableBorrowRateEnabled,\n', '        bool isActive,\n', '        bool isFrozen\n', '    );\n', '}\n', '\n', 'interface AaveAddressProviderRegistryInterface {\n', '    function getAddressesProvidersList() external view returns (address[] memory);\n', '}\n', '\n', 'interface ATokenInterface {\n', '    function scaledBalanceOf(address _user) external view returns (uint256);\n', '    function isTransferAllowed(address _user, uint256 _amount) external view returns (bool);\n', '    function balanceOf(address _user) external view returns(uint256);\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '}\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'import { DSMath } from "../../common/math.sol";\n', 'import { Stores } from "../../common/stores.sol";\n', 'import { AaveLendingPoolProviderInterface, AaveDataProviderInterface } from "./interfaces.sol";\n', '\n', 'abstract contract Helpers is DSMath, Stores {\n', '    /**\n', '     * @dev Aave referal code\n', '     */\n', '    uint16 constant internal referalCode = 3228;\n', '\n', '    /**\n', '     * @dev Aave Provider\n', '     */\n', '    AaveLendingPoolProviderInterface constant internal aaveProvider = AaveLendingPoolProviderInterface(0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5);\n', '\n', '    /**\n', '     * @dev Aave Data Provider\n', '     */\n', '    AaveDataProviderInterface constant internal aaveData = AaveDataProviderInterface(0x057835Ad21a177dbdd3090bB1CAE03EaCF78Fc6d);\n', '\n', '    function getIsColl(address token, address user) internal view returns (bool isCol) {\n', '        (, , , , , , , , isCol) = aaveData.getUserReserveData(token, user);\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'contract Events {\n', '    event LogAaveV2Import(\n', '        address indexed user,\n', '        bool convertStable,\n', '        address[] supplyTokens,\n', '        address[] borrowTokens,\n', '        uint[] supplyAmts,\n', '        uint[] stableBorrowAmts,\n', '        uint[] variableBorrowAmts\n', '    );\n', '}\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";\n', '\n', 'contract DSMath {\n', '  uint constant WAD = 10 ** 18;\n', '  uint constant RAY = 10 ** 27;\n', '\n', '  function add(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(x, y);\n', '  }\n', '\n', '  function sub(uint x, uint y) internal virtual pure returns (uint z) {\n', '    z = SafeMath.sub(x, y);\n', '  }\n', '\n', '  function mul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.mul(x, y);\n', '  }\n', '\n', '  function div(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.div(x, y);\n', '  }\n', '\n', '  function wmul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, y), WAD / 2) / WAD;\n', '  }\n', '\n', '  function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, WAD), y / 2) / y;\n', '  }\n', '\n', '  function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, RAY), y / 2) / y;\n', '  }\n', '\n', '  function rmul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, y), RAY / 2) / RAY;\n', '  }\n', '\n', '  function toInt(uint x) internal pure returns (int y) {\n', '    y = int(x);\n', '    require(y >= 0, "int-overflow");\n', '  }\n', '\n', '  function toRad(uint wad) internal pure returns (uint rad) {\n', '    rad = mul(wad, 10 ** 27);\n', '  }\n', '\n', '}\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'import { MemoryInterface, InstaMapping } from "./interfaces.sol";\n', '\n', '\n', 'abstract contract Stores {\n', '\n', '  /**\n', '   * @dev Return ethereum address\n', '   */\n', '  address constant internal ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '  /**\n', '   * @dev Return Wrapped ETH address\n', '   */\n', '  address constant internal wethAddr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '\n', '  /**\n', '   * @dev Return memory variable address\n', '   */\n', '  MemoryInterface constant internal instaMemory = MemoryInterface(0x8a5419CfC711B2343c17a6ABf4B2bAFaBb06957F);\n', '\n', '  /**\n', '   * @dev Return InstaDApp Mapping Addresses\n', '   */\n', '  InstaMapping constant internal instaMapping = InstaMapping(0xe81F70Cc7C0D46e12d70efc60607F16bbD617E88);\n', '\n', '  /**\n', '   * @dev Get Uint value from InstaMemory Contract.\n', '   */\n', '  function getUint(uint getId, uint val) internal returns (uint returnVal) {\n', '    returnVal = getId == 0 ? val : instaMemory.getUint(getId);\n', '  }\n', '\n', '  /**\n', '  * @dev Set Uint value in InstaMemory Contract.\n', '  */\n', '  function setUint(uint setId, uint val) virtual internal {\n', '    if (setId != 0) instaMemory.setUint(setId, val);\n', '  }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']
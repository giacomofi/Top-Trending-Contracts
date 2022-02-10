['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-06\n', '*/\n', '\n', '/*\n', '    ___            _       ___  _                          \n', '    | .\\ ___  _ _ <_> ___ | __><_>._ _  ___ ._ _  ___  ___ \n', "    |  _// ._>| '_>| ||___|| _> | || ' |<_> || ' |/ | '/ ._>\n", '    |_|  \\___.|_|  |_|     |_|  |_||_|_|<___||_|_|\\_|_.\\___.\n', '    \n', '* PeriFinance: PeriFinanceEscrow.sol\n', '*\n', '* Latest source (may be newer): https://github.com/perifinance/peri-finance/blob/master/contracts/PeriFinanceEscrow.sol\n', '* Docs: Will be added in the future. \n', '* https://docs.peri.finance/contracts/source/contracts/PeriFinanceEscrow\n', '*\n', '* Contract Dependencies: (none)\n', '* Libraries: \n', '*\t- SafeDecimalMath\n', '*\t- SafeMath\n', '*\n', '* MIT License\n', '* ===========\n', '*\n', '* Copyright (c) 2021 PeriFinance\n', '*\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', '\n', '\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '// https://docs.peri.finance/contracts/source/contracts/owned\n', 'contract Owned {\n', '    address public owner;\n', '    address public nominatedOwner;\n', '\n', '    constructor(address _owner) public {\n', '        require(_owner != address(0), "Owner address cannot be 0");\n', '        owner = _owner;\n', '        emit OwnerChanged(address(0), _owner);\n', '    }\n', '\n', '    function nominateNewOwner(address _owner) external onlyOwner {\n', '        nominatedOwner = _owner;\n', '        emit OwnerNominated(_owner);\n', '    }\n', '\n', '    function acceptOwnership() external {\n', '        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");\n', '        emit OwnerChanged(owner, nominatedOwner);\n', '        owner = nominatedOwner;\n', '        nominatedOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        _onlyOwner();\n', '        _;\n', '    }\n', '\n', '    function _onlyOwner() private view {\n', '        require(msg.sender == owner, "Only the contract owner may perform this action");\n', '    }\n', '\n', '    event OwnerNominated(address newOwner);\n', '    event OwnerChanged(address oldOwner, address newOwner);\n', '}\n', '\n', '\n', '// https://docs.peri.finance/contracts/source/contracts/limitedsetup\n', 'contract LimitedSetup {\n', '    uint public setupExpiryTime;\n', '\n', '    /**\n', '     * @dev LimitedSetup Constructor.\n', '     * @param setupDuration The time the setup period will last for.\n', '     */\n', '    constructor(uint setupDuration) internal {\n', '        setupExpiryTime = now + setupDuration;\n', '    }\n', '\n', '    modifier onlyDuringSetup {\n', '        require(now < setupExpiryTime, "Can only perform this action during setup");\n', '        _;\n', '    }\n', '}\n', '\n', '\n', '// https://docs.peri.finance/contracts/source/interfaces/ihasbalance\n', 'interface IHasBalance {\n', '    // Views\n', '    function balanceOf(address account) external view returns (uint);\n', '}\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// Libraries\n', '\n', '\n', '// https://docs.peri.finance/contracts/source/libraries/safedecimalmath\n', 'library SafeDecimalMath {\n', '    using SafeMath for uint;\n', '\n', '    /* Number of decimal places in the representations. */\n', '    uint8 public constant decimals = 18;\n', '    uint8 public constant highPrecisionDecimals = 27;\n', '\n', '    /* The number representing 1.0. */\n', '    uint public constant UNIT = 10**uint(decimals);\n', '\n', '    /* The number representing 1.0 for higher fidelity numbers. */\n', '    uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);\n', '    uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);\n', '\n', '    /**\n', '     * @return Provides an interface to UNIT.\n', '     */\n', '    function unit() external pure returns (uint) {\n', '        return UNIT;\n', '    }\n', '\n', '    /**\n', '     * @return Provides an interface to PRECISE_UNIT.\n', '     */\n', '    function preciseUnit() external pure returns (uint) {\n', '        return PRECISE_UNIT;\n', '    }\n', '\n', '    /**\n', '     * @return The result of multiplying x and y, interpreting the operands as fixed-point\n', '     * decimals.\n', '     *\n', '     * @dev A unit factor is divided out after the product of x and y is evaluated,\n', '     * so that product must be less than 2**256. As this is an integer division,\n', '     * the internal division always rounds down. This helps save on gas. Rounding\n', '     * is more expensive on gas.\n', '     */\n', '    function multiplyDecimal(uint x, uint y) internal pure returns (uint) {\n', '        /* Divide by UNIT to remove the extra factor introduced by the product. */\n', '        return x.mul(y) / UNIT;\n', '    }\n', '\n', '    /**\n', '     * @return The result of safely multiplying x and y, interpreting the operands\n', '     * as fixed-point decimals of the specified precision unit.\n', '     *\n', '     * @dev The operands should be in the form of a the specified unit factor which will be\n', '     * divided out after the product of x and y is evaluated, so that product must be\n', '     * less than 2**256.\n', '     *\n', '     * Unlike multiplyDecimal, this function rounds the result to the nearest increment.\n', '     * Rounding is useful when you need to retain fidelity for small decimal numbers\n', '     * (eg. small fractions or percentages).\n', '     */\n', '    function _multiplyDecimalRound(\n', '        uint x,\n', '        uint y,\n', '        uint precisionUnit\n', '    ) private pure returns (uint) {\n', '        /* Divide by UNIT to remove the extra factor introduced by the product. */\n', '        uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);\n', '\n', '        if (quotientTimesTen % 10 >= 5) {\n', '            quotientTimesTen += 10;\n', '        }\n', '\n', '        return quotientTimesTen / 10;\n', '    }\n', '\n', '    /**\n', '     * @return The result of safely multiplying x and y, interpreting the operands\n', '     * as fixed-point decimals of a precise unit.\n', '     *\n', '     * @dev The operands should be in the precise unit factor which will be\n', '     * divided out after the product of x and y is evaluated, so that product must be\n', '     * less than 2**256.\n', '     *\n', '     * Unlike multiplyDecimal, this function rounds the result to the nearest increment.\n', '     * Rounding is useful when you need to retain fidelity for small decimal numbers\n', '     * (eg. small fractions or percentages).\n', '     */\n', '    function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {\n', '        return _multiplyDecimalRound(x, y, PRECISE_UNIT);\n', '    }\n', '\n', '    /**\n', '     * @return The result of safely multiplying x and y, interpreting the operands\n', '     * as fixed-point decimals of a standard unit.\n', '     *\n', '     * @dev The operands should be in the standard unit factor which will be\n', '     * divided out after the product of x and y is evaluated, so that product must be\n', '     * less than 2**256.\n', '     *\n', '     * Unlike multiplyDecimal, this function rounds the result to the nearest increment.\n', '     * Rounding is useful when you need to retain fidelity for small decimal numbers\n', '     * (eg. small fractions or percentages).\n', '     */\n', '    function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {\n', '        return _multiplyDecimalRound(x, y, UNIT);\n', '    }\n', '\n', '    /**\n', '     * @return The result of safely dividing x and y. The return value is a high\n', '     * precision decimal.\n', '     *\n', '     * @dev y is divided after the product of x and the standard precision unit\n', '     * is evaluated, so the product of x and UNIT must be less than 2**256. As\n', '     * this is an integer division, the result is always rounded down.\n', '     * This helps save on gas. Rounding is more expensive on gas.\n', '     */\n', '    function divideDecimal(uint x, uint y) internal pure returns (uint) {\n', '        /* Reintroduce the UNIT factor that will be divided out by y. */\n', '        return x.mul(UNIT).div(y);\n', '    }\n', '\n', '    /**\n', '     * @return The result of safely dividing x and y. The return value is as a rounded\n', '     * decimal in the precision unit specified in the parameter.\n', '     *\n', '     * @dev y is divided after the product of x and the specified precision unit\n', '     * is evaluated, so the product of x and the specified precision unit must\n', '     * be less than 2**256. The result is rounded to the nearest increment.\n', '     */\n', '    function _divideDecimalRound(\n', '        uint x,\n', '        uint y,\n', '        uint precisionUnit\n', '    ) private pure returns (uint) {\n', '        uint resultTimesTen = x.mul(precisionUnit * 10).div(y);\n', '\n', '        if (resultTimesTen % 10 >= 5) {\n', '            resultTimesTen += 10;\n', '        }\n', '\n', '        return resultTimesTen / 10;\n', '    }\n', '\n', '    /**\n', '     * @return The result of safely dividing x and y. The return value is as a rounded\n', '     * standard precision decimal.\n', '     *\n', '     * @dev y is divided after the product of x and the standard precision unit\n', '     * is evaluated, so the product of x and the standard precision unit must\n', '     * be less than 2**256. The result is rounded to the nearest increment.\n', '     */\n', '    function divideDecimalRound(uint x, uint y) internal pure returns (uint) {\n', '        return _divideDecimalRound(x, y, UNIT);\n', '    }\n', '\n', '    /**\n', '     * @return The result of safely dividing x and y. The return value is as a rounded\n', '     * high precision decimal.\n', '     *\n', '     * @dev y is divided after the product of x and the high precision unit\n', '     * is evaluated, so the product of x and the high precision unit must\n', '     * be less than 2**256. The result is rounded to the nearest increment.\n', '     */\n', '    function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {\n', '        return _divideDecimalRound(x, y, PRECISE_UNIT);\n', '    }\n', '\n', '    /**\n', '     * @dev Convert a standard decimal representation to a high precision one.\n', '     */\n', '    function decimalToPreciseDecimal(uint i) internal pure returns (uint) {\n', '        return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);\n', '    }\n', '\n', '    /**\n', '     * @dev Convert a high precision decimal to a standard decimal representation.\n', '     */\n', '    function preciseDecimalToDecimal(uint i) internal pure returns (uint) {\n', '        uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);\n', '\n', '        if (quotientTimesTen % 10 >= 5) {\n', '            quotientTimesTen += 10;\n', '        }\n', '\n', '        return quotientTimesTen / 10;\n', '    }\n', '\n', '    /**\n', '     * @dev Round down the value with given number\n', '     */\n', '    function roundDownDecimal(uint x, uint d) internal pure returns (uint) {\n', '        return x.div(10**d).mul(10**d);\n', '    }\n', '}\n', '\n', '\n', '// https://docs.peri.finance/contracts/source/interfaces/ierc20\n', 'interface IERC20 {\n', '    // ERC20 Optional Views\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    // Views\n', '    function totalSupply() external view returns (uint);\n', '\n', '    function balanceOf(address owner) external view returns (uint);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    // Mutative functions\n', '    function transfer(address to, uint value) external returns (bool);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint value\n', '    ) external returns (bool);\n', '\n', '    // Events\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '// https://docs.peri.finance/contracts/source/interfaces/ipynth\n', 'interface IPynth {\n', '    // Views\n', '    function currencyKey() external view returns (bytes32);\n', '\n', '    function transferablePynths(address account) external view returns (uint);\n', '\n', '    // Mutative functions\n', '    function transferAndSettle(address to, uint value) external returns (bool);\n', '\n', '    function transferFromAndSettle(\n', '        address from,\n', '        address to,\n', '        uint value\n', '    ) external returns (bool);\n', '\n', '    // Restricted: used internally to PeriFinance\n', '    function burn(address account, uint amount) external;\n', '\n', '    function issue(address account, uint amount) external;\n', '}\n', '\n', '\n', 'interface IVirtualPynth {\n', '    // Views\n', '    function balanceOfUnderlying(address account) external view returns (uint);\n', '\n', '    function rate() external view returns (uint);\n', '\n', '    function readyToSettle() external view returns (bool);\n', '\n', '    function secsLeftInWaitingPeriod() external view returns (uint);\n', '\n', '    function settled() external view returns (bool);\n', '\n', '    function pynth() external view returns (IPynth);\n', '\n', '    // Mutative functions\n', '    function settle(address account) external;\n', '}\n', '\n', '\n', '// https://docs.peri.finance/contracts/source/interfaces/iperiFinance\n', 'interface IPeriFinance {\n', '    // Views\n', '    function getRequiredAddress(bytes32 contractName) external view returns (address);\n', '\n', '    function anyPynthOrPERIRateIsInvalid() external view returns (bool anyRateInvalid);\n', '\n', '    function availableCurrencyKeys() external view returns (bytes32[] memory);\n', '\n', '    function availablePynthCount() external view returns (uint);\n', '\n', '    function availablePynths(uint index) external view returns (IPynth);\n', '\n', '    function collateral(address account) external view returns (uint);\n', '\n', '    function collateralisationRatio(address issuer) external view returns (uint);\n', '\n', '    function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);\n', '\n', '    function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);\n', '\n', '    function maxIssuablePynths(address issuer) external view returns (uint maxIssuable);\n', '\n', '    function remainingIssuablePynths(address issuer)\n', '        external\n', '        view\n', '        returns (\n', '            uint maxIssuable,\n', '            uint alreadyIssued,\n', '            uint totalSystemDebt\n', '        );\n', '\n', '    function pynths(bytes32 currencyKey) external view returns (IPynth);\n', '\n', '    function pynthsByAddress(address pynthAddress) external view returns (bytes32);\n', '\n', '    function totalIssuedPynths(bytes32 currencyKey) external view returns (uint);\n', '\n', '    function totalIssuedPynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);\n', '\n', '    function transferablePeriFinance(address account) external view returns (uint transferable);\n', '\n', '    function currentUSDCDebtQuota(address _account) external view returns (uint);\n', '\n', '    function usdcStakedAmountOf(address _account) external view returns (uint);\n', '\n', '    function usdcTotalStakedAmount() external view returns (uint);\n', '\n', '    function userUSDCStakingShare(address _account) external view returns (uint);\n', '\n', '    function totalUSDCStakerCount() external view returns (uint);\n', '\n', '    // Mutative Functions\n', '    function issuePynthsAndStakeUSDC(uint _issueAmount, uint _usdcStakeAmount) external;\n', '\n', '    function issueMaxPynths() external;\n', '\n', '    function issuePynthsAndStakeMaxUSDC(uint _issueAmount) external;\n', '\n', '    function burnPynthsAndUnstakeUSDC(uint _burnAmount, uint _unstakeAmount) external;\n', '\n', '    function burnPynthsAndUnstakeUSDCToTarget() external;\n', '\n', '    function exchange(\n', '        bytes32 sourceCurrencyKey,\n', '        uint sourceAmount,\n', '        bytes32 destinationCurrencyKey\n', '    ) external returns (uint amountReceived);\n', '\n', '    function exchangeOnBehalf(\n', '        address exchangeForAddress,\n', '        bytes32 sourceCurrencyKey,\n', '        uint sourceAmount,\n', '        bytes32 destinationCurrencyKey\n', '    ) external returns (uint amountReceived);\n', '\n', '    function exchangeWithTracking(\n', '        bytes32 sourceCurrencyKey,\n', '        uint sourceAmount,\n', '        bytes32 destinationCurrencyKey,\n', '        address originator,\n', '        bytes32 trackingCode\n', '    ) external returns (uint amountReceived);\n', '\n', '    function exchangeOnBehalfWithTracking(\n', '        address exchangeForAddress,\n', '        bytes32 sourceCurrencyKey,\n', '        uint sourceAmount,\n', '        bytes32 destinationCurrencyKey,\n', '        address originator,\n', '        bytes32 trackingCode\n', '    ) external returns (uint amountReceived);\n', '\n', '    function exchangeWithVirtual(\n', '        bytes32 sourceCurrencyKey,\n', '        uint sourceAmount,\n', '        bytes32 destinationCurrencyKey,\n', '        bytes32 trackingCode\n', '    ) external returns (uint amountReceived, IVirtualPynth vPynth);\n', '\n', '    function mint() external returns (bool);\n', '\n', '    function settle(bytes32 currencyKey)\n', '        external\n', '        returns (\n', '            uint reclaimed,\n', '            uint refunded,\n', '            uint numEntries\n', '        );\n', '\n', '    // Liquidations\n', '    function liquidateDelinquentAccount(address account, uint pusdAmount) external returns (bool);\n', '\n', '    // Restricted Functions\n', '\n', '    function mintSecondary(address account, uint amount) external;\n', '\n', '    function mintSecondaryRewards(uint amount) external;\n', '\n', '    function burnSecondary(address account, uint amount) external;\n', '}\n', '\n', '\n', '// Inheritance\n', '\n', '\n', '// Libraires\n', '\n', '\n', '// Internal references\n', '\n', '\n', '// https://docs.peri.finance/contracts/source/contracts/periFinanceescrow\n', 'contract PeriFinanceEscrow is Owned, LimitedSetup(8 weeks), IHasBalance {\n', '    using SafeMath for uint;\n', '\n', '    /* The corresponding PeriFinance contract. */\n', '    IPeriFinance public periFinance;\n', '\n', '    /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.\n', '     * These are the times at which each given quantity of PERI vests. */\n', '    mapping(address => uint[2][]) public vestingSchedules;\n', '\n', "    /* An account's total vested PERI balance to save recomputing this for fee extraction purposes. */\n", '    mapping(address => uint) public totalVestedAccountBalance;\n', '\n', '    /* The total remaining vested balance, for verifying the actual PERI balance of this contract against. */\n', '    uint public totalVestedBalance;\n', '\n', '    uint public constant TIME_INDEX = 0;\n', '    uint public constant QUANTITY_INDEX = 1;\n', '\n', '    /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */\n', '    uint public constant MAX_VESTING_ENTRIES = 20;\n', '\n', '    /* Account address to send balance of purged accounts */\n', '    address public addressToRefund;\n', '\n', '    /* ========== CONSTRUCTOR ========== */\n', '\n', '    constructor(\n', '        address _owner,\n', '        IPeriFinance _periFinance,\n', '        address _addressToRefund\n', '    ) public Owned(_owner) {\n', '        periFinance = _periFinance;\n', '        addressToRefund = _addressToRefund;\n', '    }\n', '\n', '    /* ========== SETTERS ========== */\n', '\n', '    function setPeriFinance(IPeriFinance _periFinance) external onlyOwner {\n', '        periFinance = _periFinance;\n', '        emit PeriFinanceUpdated(address(_periFinance));\n', '    }\n', '\n', '    function setAddressToRefund(address _addressToRefund) external onlyOwner {\n', '        addressToRefund = _addressToRefund;\n', '        emit AddressToRefundUpdated(_addressToRefund);\n', '    }\n', '\n', '    /* ========== VIEW FUNCTIONS ========== */\n', '\n', '    /**\n', '     * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.\n', '     */\n', '    function balanceOf(address account) public view returns (uint) {\n', '        return totalVestedAccountBalance[account];\n', '    }\n', '\n', '    /**\n', "     * @notice The number of vesting dates in an account's schedule.\n", '     */\n', '    function numVestingEntries(address account) public view returns (uint) {\n', '        return vestingSchedules[account].length;\n', '    }\n', '\n', '    /**\n', '     * @notice Get a particular schedule entry for an account.\n', '     * @return A pair of uints: (timestamp, PERI quantity).\n', '     */\n', '    function getVestingScheduleEntry(address account, uint index) public view returns (uint[2] memory) {\n', '        return vestingSchedules[account][index];\n', '    }\n', '\n', '    /**\n', '     * @notice Get the time at which a given schedule entry will vest.\n', '     */\n', '    function getVestingTime(address account, uint index) public view returns (uint) {\n', '        return getVestingScheduleEntry(account, index)[TIME_INDEX];\n', '    }\n', '\n', '    /**\n', '     * @notice Get the quantity of PERI associated with a given schedule entry.\n', '     */\n', '    function getVestingQuantity(address account, uint index) public view returns (uint) {\n', '        return getVestingScheduleEntry(account, index)[QUANTITY_INDEX];\n', '    }\n', '\n', '    /**\n', '     * @notice Obtain the index of the next schedule entry that will vest for a given user.\n', '     */\n', '    function getNextVestingIndex(address account) public view returns (uint) {\n', '        uint len = numVestingEntries(account);\n', '        for (uint i = 0; i < len; i++) {\n', '            if (getVestingTime(account, i) != 0) {\n', '                return i;\n', '            }\n', '        }\n', '        return len;\n', '    }\n', '\n', '    /**\n', '     * @notice Obtain the next schedule entry that will vest for a given user.\n', '     * @return A pair of uints: (timestamp, PERI quantity). */\n', '    function getNextVestingEntry(address account) public view returns (uint[2] memory) {\n', '        uint index = getNextVestingIndex(account);\n', '        if (index == numVestingEntries(account)) {\n', '            return [uint(0), 0];\n', '        }\n', '        return getVestingScheduleEntry(account, index);\n', '    }\n', '\n', '    /**\n', '     * @notice Obtain the time at which the next schedule entry will vest for a given user.\n', '     */\n', '    function getNextVestingTime(address account) external view returns (uint) {\n', '        return getNextVestingEntry(account)[TIME_INDEX];\n', '    }\n', '\n', '    /**\n', '     * @notice Obtain the quantity which the next schedule entry will vest for a given user.\n', '     */\n', '    function getNextVestingQuantity(address account) external view returns (uint) {\n', '        return getNextVestingEntry(account)[QUANTITY_INDEX];\n', '    }\n', '\n', '    /* ========== MUTATIVE FUNCTIONS ========== */\n', '\n', '    /**\n', '     * @notice Destroy the vesting information associated with an account.\n', '     */\n', '    function purgeAccount(address account) external onlyOwner onlyDuringSetup {\n', '        require(addressToRefund != address(0), "Refund address can not be zero address");\n', '\n', '        delete vestingSchedules[account];\n', '        totalVestedBalance = totalVestedBalance.sub(totalVestedAccountBalance[account]);\n', '\n', '        require(\n', '            totalVestedBalance <= IERC20(address(periFinance)).balanceOf(address(this)),\n', '            "Must be enough balance in the contract to retrieve vested balance of purged account"\n', '        );\n', '\n', '        IERC20(address(periFinance)).transfer(addressToRefund, totalVestedAccountBalance[account]);\n', '        delete totalVestedAccountBalance[account];\n', '    }\n', '\n', '    /**\n', "     * @notice Add a new vesting entry at a given time and quantity to an account's schedule.\n", '     * @dev A call to this should be accompanied by either enough balance already available\n', '     * in this contract, or a corresponding call to periFinance.endow(), to ensure that when\n', '     * the funds are withdrawn, there is enough balance, as well as correctly calculating\n', '     * the fees.\n', "     * This may only be called by the owner during the contract's setup period.\n", '     * Note; although this function could technically be used to produce unbounded\n', "     * arrays, it's only in the foundation's command to add to these lists.\n", '     * @param account The account to append a new vesting entry to.\n', '     * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.\n', '     * @param quantity The quantity of PERI that will vest.\n', '     */\n', '    function appendVestingEntry(\n', '        address account,\n', '        uint time,\n', '        uint quantity\n', '    ) public onlyOwner onlyDuringSetup {\n', '        /* No empty or already-passed vesting entries allowed. */\n', '        require(now < time, "Time must be in the future");\n', '        require(quantity != 0, "Quantity cannot be zero");\n', '\n', '        /* There must be enough balance in the contract to provide for the vesting entry. */\n', '        totalVestedBalance = totalVestedBalance.add(quantity);\n', '        require(\n', '            totalVestedBalance <= IERC20(address(periFinance)).balanceOf(address(this)),\n', '            "Must be enough balance in the contract to provide for the vesting entry"\n', '        );\n', '\n', '        /* Disallow arbitrarily long vesting schedules in light of the gas limit. */\n', '        uint scheduleLength = vestingSchedules[account].length;\n', '        require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");\n', '\n', '        if (scheduleLength == 0) {\n', '            totalVestedAccountBalance[account] = quantity;\n', '        } else {\n', '            /* Disallow adding new vested PERI earlier than the last one.\n', '             * Since entries are only appended, this means that no vesting date can be repeated. */\n', '            require(\n', '                getVestingTime(account, numVestingEntries(account) - 1) < time,\n', '                "Cannot add new vested entries earlier than the last one"\n', '            );\n', '            totalVestedAccountBalance[account] = totalVestedAccountBalance[account].add(quantity);\n', '        }\n', '\n', '        vestingSchedules[account].push([time, quantity]);\n', '    }\n', '\n', '    /**\n', '     * @notice Construct a vesting schedule to release a quantities of PERI\n', '     * over a series of intervals.\n', '     * @dev Assumes that the quantities are nonzero\n', '     * and that the sequence of timestamps is strictly increasing.\n', "     * This may only be called by the owner during the contract's setup period.\n", '     */\n', '    function addVestingSchedule(\n', '        address account,\n', '        uint[] calldata times,\n', '        uint[] calldata quantities\n', '    ) external onlyOwner onlyDuringSetup {\n', '        for (uint i = 0; i < times.length; i++) {\n', '            appendVestingEntry(account, times[i], quantities[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice Allow a user to withdraw any PERI in their schedule that have vested.\n', '     */\n', '    function vest() external {\n', '        uint numEntries = numVestingEntries(msg.sender);\n', '        uint total;\n', '        for (uint i = 0; i < numEntries; i++) {\n', '            uint time = getVestingTime(msg.sender, i);\n', '            /* The list is sorted; when we reach the first future time, bail out. */\n', '            if (time > now) {\n', '                break;\n', '            }\n', '            uint qty = getVestingQuantity(msg.sender, i);\n', '            if (qty > 0) {\n', '                vestingSchedules[msg.sender][i] = [0, 0];\n', '                total = total.add(qty);\n', '            }\n', '        }\n', '\n', '        if (total != 0) {\n', '            totalVestedBalance = totalVestedBalance.sub(total);\n', '            totalVestedAccountBalance[msg.sender] = totalVestedAccountBalance[msg.sender].sub(total);\n', '            IERC20(address(periFinance)).transfer(msg.sender, total);\n', '            emit Vested(msg.sender, now, total);\n', '        }\n', '    }\n', '\n', '    /* ========== EVENTS ========== */\n', '\n', '    event PeriFinanceUpdated(address newPeriFinance);\n', '\n', '    event AddressToRefundUpdated(address addressToRefund);\n', '\n', '    event Vested(address indexed beneficiary, uint time, uint value);\n', '}']
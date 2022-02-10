['// SPDX-License-Identifier: MIT\n', '\n', '/* \n', '\n', '    _    __  __ ____  _     _____ ____       _     _       _       \n', '   / \\  |  \\/  |  _ \\| |   | ____/ ___| ___ | | __| |     (_) ___  \n', '  / _ \\ | |\\/| | |_) | |   |  _|| |  _ / _ \\| |/ _` |     | |/ _ \\ \n', ' / ___ \\| |  | |  __/| |___| |__| |_| | (_) | | (_| |  _  | | (_) |\n', '/_/   \\_\\_|  |_|_|   |_____|_____\\____|\\___/|_|\\__,_| (_) |_|\\___/ \n', '                                \n', '\n', '    Ample Gold $AMPLG is a goldpegged defi protocol that is based on Ampleforths elastic tokensupply model. \n', '    AMPLG is designed to maintain its base price target of 0.01g of Gold with a progammed inflation adjustment (rebase).\n', '    \n', '    Forked from Ampleforth: https://github.com/ampleforth/uFragments (Credits to Ampleforth team for implementation of rebasing on the ethereum network)\n', '    \n', '    GPL 3.0 license\n', '    \n', '    AMPLG_GoldPolicy.sol - AMPLG Gold Orchestrator Policy\n', '  \n', '*/\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'library SafeMathInt {\n', '    int256 private constant MIN_INT256 = int256(1) << 255;\n', '    int256 private constant MAX_INT256 = ~(int256(1) << 255);\n', '\n', '    /**\n', '     * @dev Multiplies two int256 variables and fails on overflow.\n', '     */\n', '    function mul(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a * b;\n', '\n', '        // Detect overflow when multiplying MIN_INT256 with -1\n', '        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));\n', '        require((b == 0) || (c / b == a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Division of two int256 variables and fails on overflow.\n', '     */\n', '    function div(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        // Prevent overflow when dividing MIN_INT256 by -1\n', '        require(b != -1 || a != MIN_INT256);\n', '\n', '        // Solidity already throws when dividing by 0.\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two int256 variables and fails on overflow.\n', '     */\n', '    function sub(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a - b;\n', '        require((b >= 0 && c <= a) || (b < 0 && c > a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two int256 variables and fails on overflow.\n', '     */\n', '    function add(int256 a, int256 b)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        int256 c = a + b;\n', '        require((b >= 0 && c >= a) || (b < 0 && c < a));\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Converts to absolute value, and fails on overflow.\n', '     */\n', '    function abs(int256 a)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        require(a != MIN_INT256);\n', '        return a < 0 ? -a : a;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Various utilities useful for uint256.\n', ' */\n', 'library UInt256Lib {\n', '\n', '    uint256 private constant MAX_INT256 = ~(uint256(1) << 255);\n', '\n', '    /**\n', '     * @dev Safely converts a uint256 to an int256.\n', '     */\n', '    function toInt256Safe(uint256 a)\n', '        internal\n', '        pure\n', '        returns (int256)\n', '    {\n', '        require(a <= MAX_INT256);\n', '        return int256(a);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'interface IAMPLG {\n', '    function totalSupply() external view returns (uint256);\n', '    function rebaseGold(uint256 epoch, int256 supplyDelta) external returns (uint256);\n', '}\n', '\n', 'interface IGoldOracle {\n', '    function getGoldPrice() external view returns (uint256, bool);\n', '    function getMarketPrice() external view returns (uint256, bool);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  \n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    _owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(_owner);\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title AMPLG $AMPLG Gold Supply Policy\n', ' * @dev This is the extended orchestrator version of the AMPLG $AMPLG Ideal Gold Pegged DeFi protocol aka Ampleforth Gold ($AMPLG).\n', ' *      AMPLG operates symmetrically on expansion and contraction. It will both split and\n', ' *      combine coins to maintain a stable gold unit price against PAX gold.\n', ' *\n', ' *      This component regulates the token supply of the AMPLG ERC20 token in response to\n', ' *      market oracles and gold price.\n', ' */\n', 'contract AMPLGGoldPolicy is Ownable {\n', '    using SafeMath for uint256;\n', '    using SafeMathInt for int256;\n', '    using UInt256Lib for uint256;\n', '\n', '    event LogRebase(\n', '        uint256 indexed epoch,\n', '        uint256 exchangeRate,\n', '        uint256 goldPrice,\n', '        int256 requestedSupplyAdjustment,\n', '        uint256 timestampSec\n', '    );\n', '\n', '    IAMPLG public amplg;\n', '\n', '    // Gold oracle provides the gold price and market price.\n', '    IGoldOracle public goldOracle;\n', '\n', '    // If the current exchange rate is within this fractional distance from the target, no supply\n', '    // update is performed. Fixed point number--same format as the rate.\n', '    // (ie) abs(rate - targetRate) / targetRate < deviationThreshold, then no supply change.\n', '    // DECIMALS Fixed point number.\n', '    uint256 public deviationThreshold;\n', '\n', '    // The rebase lag parameter, used to dampen the applied supply adjustment by 1 / rebaseLag\n', '    // Check setRebaseLag comments for more details.\n', '    // Natural number, no decimal places.\n', '    uint256 public rebaseLag;\n', '\n', '    // More than this much time must pass between rebase operations.\n', '    uint256 public minRebaseTimeIntervalSec;\n', '\n', '    // Block timestamp of last rebase operation\n', '    uint256 public lastRebaseTimestampSec;\n', '\n', '    // The number of rebase cycles since inception\n', '    uint256 public epoch;\n', '\n', '    uint256 private constant DECIMALS = 18;\n', '\n', '    // Due to the expression in computeSupplyDelta(), MAX_RATE * MAX_SUPPLY must fit into an int256.\n', '    // Both are 18 decimals fixed point numbers.\n', '    uint256 private constant MAX_RATE = 10**6 * 10**DECIMALS;\n', '    // MAX_SUPPLY = MAX_INT256 / MAX_RATE\n', '    uint256 private constant MAX_SUPPLY = ~(uint256(1) << 255) / MAX_RATE;\n', '\n', '    constructor() public {\n', '        deviationThreshold = 5 * 10 ** (DECIMALS-2);\n', '\n', '        rebaseLag = 6;\n', '        minRebaseTimeIntervalSec = 12 hours;\n', '        lastRebaseTimestampSec = 0;\n', '        epoch = 0;\n', '    }\n', '\n', '    /**\n', '     * @notice Returns true if at least minRebaseTimeIntervalSec seconds have passed since last rebase.\n', '     *\n', '     */\n', '     \n', '    function canRebase() public view returns (bool) {\n', '        return (lastRebaseTimestampSec.add(minRebaseTimeIntervalSec) < now);\n', '    }\n', '\n', '    /**\n', '     * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.\n', '     *\n', '     */     \n', '    function rebase() external {\n', '\n', '        require(canRebase(), "AMPLG Error: Insufficient time has passed since last rebase.");\n', '\n', '        require(tx.origin == msg.sender);\n', '\n', '        lastRebaseTimestampSec = now;\n', '\n', '        epoch = epoch.add(1);\n', '        \n', '        (uint256 curGoldPrice, uint256 marketPrice, int256 targetRate, int256 supplyDelta) = getRebaseValues();\n', '\n', '        uint256 supplyAfterRebase = amplg.rebaseGold(epoch, supplyDelta);\n', '        assert(supplyAfterRebase <= MAX_SUPPLY);\n', '        \n', '        emit LogRebase(epoch, marketPrice, curGoldPrice, supplyDelta, now);\n', '    }\n', '    \n', '    /**\n', '     * @notice Calculates the supplyDelta and returns the current set of values for the rebase\n', '     *\n', '     * @dev The supply adjustment equals the formula \n', '     *      (current price – base target price in usd) * total supply / (base target price in usd * lag \n', '     *       factor)\n', '     */   \n', '    function getRebaseValues() public view returns (uint256, uint256, int256, int256) {\n', '        uint256 curGoldPrice;\n', '        bool goldValid;\n', '        (curGoldPrice, goldValid) = goldOracle.getGoldPrice();\n', '\n', '        require(goldValid);\n', '        \n', '        uint256 marketPrice;\n', '        bool marketValid;\n', '        (marketPrice, marketValid) = goldOracle.getMarketPrice();\n', '        \n', '        require(marketValid);\n', '        \n', '        int256 goldPriceSigned = curGoldPrice.toInt256Safe();\n', '        int256 marketPriceSigned = marketPrice.toInt256Safe();\n', '        \n', '        int256 rate = marketPriceSigned.sub(goldPriceSigned);\n', '              \n', '        if (marketPrice > MAX_RATE) {\n', '            marketPrice = MAX_RATE;\n', '        }\n', '\n', '        int256 supplyDelta = computeSupplyDelta(marketPrice, curGoldPrice);\n', '\n', '        if (supplyDelta > 0 && amplg.totalSupply().add(uint256(supplyDelta)) > MAX_SUPPLY) {\n', '            supplyDelta = (MAX_SUPPLY.sub(amplg.totalSupply())).toInt256Safe();\n', '        }\n', '\n', '       return (curGoldPrice, marketPrice, rate, supplyDelta);\n', '    }\n', '\n', '\n', '    /**\n', '     * @return Computes the total supply adjustment in response to the market price\n', '     *         and the current gold price. \n', '     */\n', '    function computeSupplyDelta(uint256 marketPrice, uint256 curGoldPrice)\n', '        internal\n', '        view\n', '        returns (int256)\n', '    {\n', '        if (withinDeviationThreshold(marketPrice, curGoldPrice)) {\n', '            return 0;\n', '        }\n', '        \n', '        //(current price – base target price in usd) * total supply / (base target price in usd * lag factor)\n', '        int256 goldPrice = curGoldPrice.toInt256Safe();\n', '        int256 marketPrice = marketPrice.toInt256Safe();\n', '        \n', '        int256 delta = marketPrice.sub(goldPrice);\n', '        int256 lagSpawn = marketPrice.mul(rebaseLag.toInt256Safe());\n', '        \n', '        return amplg.totalSupply().toInt256Safe()\n', '            .mul(delta).div(lagSpawn);\n', '\n', '    }\n', '\n', '    /**\n', '     * @notice Sets the rebase lag parameter.\n', '     * @param rebaseLag_ The new rebase lag parameter.\n', '     */\n', '    function setRebaseLag(uint256 rebaseLag_)\n', '        external\n', '        onlyOwner\n', '    {\n', '        require(rebaseLag_ > 0);\n', '        rebaseLag = rebaseLag_;\n', '    }\n', '\n', '\n', '    /**\n', '     * @notice Sets the parameter which control the timing and frequency of\n', '     *         rebase operations the minimum time period that must elapse between rebase cycles.\n', '     * @param minRebaseTimeIntervalSec_ More than this much time must pass between rebase\n', '     *        operations, in seconds.\n', '     */\n', '    function setRebaseTimingParameter(uint256 minRebaseTimeIntervalSec_)\n', '        external\n', '        onlyOwner\n', '    {\n', '        minRebaseTimeIntervalSec = minRebaseTimeIntervalSec_;\n', '    }\n', '\n', '    /**\n', '     * @param rate The current market price\n', '     * @param targetRate The current gold price\n', '     * @return If the rate is within the deviation threshold from the target rate, returns true.\n', '     *         Otherwise, returns false.\n', '     */\n', '    function withinDeviationThreshold(uint256 rate, uint256 targetRate)\n', '        internal\n', '        view\n', '        returns (bool)\n', '    {\n', '        uint256 absoluteDeviationThreshold = targetRate.mul(deviationThreshold)\n', '            .div(10 ** DECIMALS);\n', '\n', '        return (rate >= targetRate && rate.sub(targetRate) < absoluteDeviationThreshold)\n', '            || (rate < targetRate && targetRate.sub(rate) < absoluteDeviationThreshold);\n', '    }\n', '    \n', '    \n', '    /**\n', '     * @notice Sets the reference to the AMPLG token governed.\n', '     *         Can only be called once during initialization.\n', '     * \n', '     * @param amplg_ The address of the AMPLG ERC20 token.\n', '     */\n', '    function setAMPLG(IAMPLG amplg_)\n', '        external\n', '        onlyOwner\n', '    {\n', '        require(amplg == IAMPLG(0)); \n', '        amplg = amplg_;    \n', '    }\n', '\n', '    /**\n', '     * @notice Sets the reference to the AMPLG $AMPLG oracle.\n', '     * @param _goldOracle The address of the AMPLG oracle contract.\n', '     */\n', '    function setGoldOracle(IGoldOracle _goldOracle)\n', '        external\n', '        onlyOwner\n', '    {\n', '        goldOracle = _goldOracle;\n', '    }\n', '    \n', '}']
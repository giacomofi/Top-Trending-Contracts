['// SPDX-License-Identifier: UNLICENSED\n', '// DELTA-BUG-BOUNTY\n', 'pragma abicoder v2;\n', 'import "../libs/SafeMath.sol";\n', 'import "../../interfaces/IUniswapV2Pair.sol";\n', 'import "../../interfaces/IDeltaToken.sol";\n', 'import "../../interfaces/IDeepFarmingVault.sol";\n', '\n', 'interface ICORE_VAULT {\n', '    function addPendingRewards(uint256) external;\n', '}\n', '\n', 'contract DELTA_Distributor {\n', '    using SafeMath for uint256;\n', '\n', '    // Immutableas and constants\n', '\n', '    // defacto burn address, this one isnt used commonly so its easy to see burned amounts on just etherscan\n', '    address constant internal DEAD_BEEF = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF;\n', '    address constant public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    address constant public CORE = 0x62359Ed7505Efc61FF1D56fEF82158CcaffA23D7;\n', '    address constant public CORE_WETH_PAIR = 0x32Ce7e48debdccbFE0CD037Cc89526E4382cb81b;\n', '    address constant public DELTA_MULTISIG = 0xB2d834dd31816993EF53507Eb1325430e67beefa;\n', '    address constant public CORE_VAULT = 0xC5cacb708425961594B63eC171f4df27a9c0d8c9;\n', '    // We sell 20% and distribute it thus\n', '    uint256 constant public PERCENT_BURNED = 16;\n', '    uint256 constant public PERCENT_DEV_FUND= 8;\n', '    uint256 constant public PERCENT_DEEP_FARMING_VAULT = 56;\n', '    uint256 constant public PERCENT_SOLD = 20;\n', '\n', '    uint256 constant public PERCENT_OF_SOLD_DEV = 50;\n', '    uint256 constant public PERCENT_OF_SOLD_CORE_BUY = 25;\n', '    uint256 constant public PERCENT_OF_SOLD_DELTA_WETH_DEEP_FARMING_VAULT = 25;\n', '    address constant public DELTA_WETH_PAIR_SUSHISWAP = 0x1498bd576454159Bb81B5Ce532692a8752D163e8;\n', '    IDeltaToken constant public DELTA_TOKEN = IDeltaToken(0x9EA3b5b4EC044b70375236A281986106457b20EF);\n', '\n', '    // storage variables\n', '    address public deepFarmingVault; \n', '    uint256 public pendingBurn;\n', '    uint256 public pendingDev;\n', '    uint256 public pendingTotal;\n', '\n', '    mapping(address => uint256) public pendingCredits;\n', '    mapping(address => bool) public isApprovedLiquidator;\n', '\n', '    receive() external payable {\n', '        revert("ETH not allowed");\n', '    }\n', '\n', '\n', '\n', '    function distributeAndBurn() public {\n', '        // Burn\n', '        DELTA_TOKEN.transfer(DEAD_BEEF, pendingBurn);\n', '        pendingTotal = pendingTotal.sub(pendingBurn);\n', '        delete pendingBurn;\n', '        // Transfer dev\n', '        address deltaMultisig = DELTA_TOKEN.governance();\n', '        DELTA_TOKEN.transfer(deltaMultisig, pendingDev);\n', '        pendingTotal = pendingTotal.sub(pendingDev);\n', '        delete pendingDev;\n', '    }\n', '\n', '    /// @notice a function that distributes pending to all the vaults etdc\n', '    // This is able to be called by anyone.\n', '    // And is simply just here to save gas on the distribution math\n', '    function distribute() public {\n', '        uint256 amountDeltaNow = DELTA_TOKEN.balanceOf(address(this));\n', '\n', '        uint256 _pendingTotal = pendingTotal;\n', '\n', '        uint256 amountAdded = amountDeltaNow.sub(_pendingTotal); // pendingSell stores in this variable and is not counted\n', '\n', '        if(amountAdded < 1e18) { // We only add 1 DELTA + of rewards to save gas from the DFV calls.\n', '            return;\n', '        }\n', '\n', '        uint256 toBurn = amountAdded.mul(PERCENT_BURNED).div(100);\n', '        uint256 toDev = amountAdded.mul(PERCENT_DEV_FUND).div(100);\n', '        uint256 toVault = amountAdded.mul(PERCENT_DEEP_FARMING_VAULT).div(100); // Not added to pending case we transfer it now\n', '\n', '        pendingBurn = pendingBurn.add(toBurn);\n', '        pendingDev = pendingDev.add(toDev);\n', '        pendingTotal = _pendingTotal.add(amountAdded).sub(toVault);\n', '\n', '        // We send to the vault and credit it\n', '        IDeepFarmingVault(deepFarmingVault).addNewRewards(toVault, 0);\n', '        // Reserve is how much we can sell thats remaining 20%\n', '    }\n', '\n', '\n', '    function setDeepFarmingVault(address _deepFarmingVault) public {\n', '        onlyMultisig();\n', '        deepFarmingVault = _deepFarmingVault;\n', '        // set infinite approvals\n', '        refreshApprovals();\n', '        UserInformation memory ui = DELTA_TOKEN.userInformation(address(this));\n', '        require(ui.noVestingWhitelisted, "DFV :: Set no vesting whitelist!");\n', '        require(ui.fullSenderWhitelisted, "DFV :: Set full sender whitelist!");\n', '        require(ui.immatureReceiverWhitelisted, "DFV :: Set immature whitelist!");\n', '    }\n', '\n', '    function refreshApprovals() public {\n', '        DELTA_TOKEN.approve(deepFarmingVault, uint(-1));\n', '        IERC20(WETH).approve(deepFarmingVault, uint(-1));\n', '    }\n', '\n', '    constructor () {\n', '        // we check for a correct config\n', '        require(PERCENT_SOLD + PERCENT_BURNED + PERCENT_DEV_FUND + PERCENT_DEEP_FARMING_VAULT == 100, "Amounts not proper");\n', '        require(PERCENT_OF_SOLD_DEV + PERCENT_OF_SOLD_CORE_BUY + PERCENT_OF_SOLD_DELTA_WETH_DEEP_FARMING_VAULT == 100 , "Amount of weth split not proper");\n', '    }   \n', '\n', '    function getWETHForDeltaAndDistribute(uint256 amountToSellFullUnits, uint256 minAmountWETHForSellingDELTA, uint256 minAmountCOREUnitsPer1WETH) public {\n', '        require(isApprovedLiquidator[msg.sender] == true, "!approved liquidator");\n', '        distribute(); // we call distribute to get rid of all coins that are not supposed to be sold\n', '        distributeAndBurn();\n', '        // We swap and make sure we can get enough out\n', '        // require(address(this) < wethAddress, "Invalid Token Address"); in DELTA token constructor\n', '        IUniswapV2Pair pairDELTA = IUniswapV2Pair(DELTA_WETH_PAIR_SUSHISWAP);\n', '        (uint256 reservesDELTA, uint256 reservesWETHinDELTA, ) = pairDELTA.getReserves();\n', '        uint256 deltaUnitsToSell = amountToSellFullUnits * 1 ether;\n', '        uint256 balanceDelta = DELTA_TOKEN.balanceOf(address(this));\n', '\n', '        require(balanceDelta >= deltaUnitsToSell, "Amount is greater than reserves");\n', '        uint256 amountETHOut = getAmountOut(deltaUnitsToSell, reservesDELTA, reservesWETHinDELTA);\n', '        require(amountETHOut >= minAmountWETHForSellingDELTA * 1 ether, "Did not get enough ETH to cover min");\n', '\n', '        // We swap for eth\n', '        DELTA_TOKEN.transfer(DELTA_WETH_PAIR_SUSHISWAP, deltaUnitsToSell);\n', '        pairDELTA.swap(0, amountETHOut, address(this), "");\n', '        address dfv = deepFarmingVault;\n', '\n', '        // We transfer the splits of WETH\n', '        IERC20 weth = IERC20(WETH);\n', '        weth.transfer(DELTA_MULTISIG, amountETHOut.div(2));\n', '        IDeepFarmingVault(dfv).addNewRewards(0, amountETHOut.div(4));\n', '        /// Transfer here doesnt matter cause its taken from reserves and this does nto update\n', '        weth.transfer(CORE_WETH_PAIR, amountETHOut.div(4));\n', '        // We swap WETH for CORE and send it to the vault and update the pending inside the vault\n', '        IUniswapV2Pair pairCORE = IUniswapV2Pair(CORE_WETH_PAIR);\n', '\n', '        (uint256 reservesCORE, uint256 reservesWETHCORE, ) = pairCORE.getReserves();\n', '         // function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal  pure returns (uint256 amountOut) {\n', '\n', '        uint256 coreOut = getAmountOut(amountETHOut.div(4), reservesWETHCORE, reservesCORE);\n', '        uint256 coreOut1WETH = getAmountOut(1 ether, reservesWETHCORE, reservesCORE);\n', '\n', '        require(coreOut1WETH >= minAmountCOREUnitsPer1WETH, "Did not get enough CORE check amountCOREUnitsBoughtFor1WETH() fn");\n', '        pairCORE.swap(coreOut, 0, CORE_VAULT, "");\n', '        // uint passed is deprecated\n', '        ICORE_VAULT(CORE_VAULT).addPendingRewards(0);\n', '\n', '        pendingTotal = pendingTotal.sub(deltaUnitsToSell); // we adjust the reserves // since we might had nto swapped everything\n', '    }   \n', '\n', '    function editApprovedLiquidator(address liquidator, bool isLiquidator) public {\n', '        onlyMultisig();\n', '        isApprovedLiquidator[liquidator] = isLiquidator;\n', '    }\n', '\n', '    function deltaGovernance() public view returns (address) {\n', '        if(address(DELTA_TOKEN) == address(0)) {return address (0); }\n', '        return DELTA_TOKEN.governance();\n', '    }\n', '\n', '    function onlyMultisig() private view {\n', '        require(msg.sender == deltaGovernance(), "!governance");\n', '    }\n', '    \n', '    function amountCOREUnitsBoughtFor1WETH() public view returns(uint256) {\n', '        IUniswapV2Pair pair = IUniswapV2Pair(CORE_WETH_PAIR);\n', '        // CORE is token0\n', '        (uint256 reservesCORE, uint256 reservesWETH, ) = pair.getReserves();\n', '        return getAmountOut(1 ether, reservesWETH, reservesCORE);\n', '    }\n', '\n', '    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal  pure returns (uint256 amountOut) {\n', "        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint amountInWithFee = amountIn.mul(997);\n', '        uint numerator = amountInWithFee.mul(reserveOut);\n', '        uint denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    function rescueTokens(address token) public {\n', '        onlyMultisig();\n', '        IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));\n', '    }\n', '\n', '    // Allows users to claim free credit\n', '    function claimCredit() public {\n', '        uint256 pending = pendingCredits[msg.sender];\n', '        require(pending > 0, "Nothing to claim");\n', '        pendingCredits[msg.sender] = 0;\n', '        IDeepFarmingVault(deepFarmingVault).addPermanentCredits(msg.sender, pending);\n', '    }\n', '\n', '    /// Credits user for burning tokens\n', '    // Can only be called by the delta token\n', '    // Note this is a inherently trusted function that does not do balance checks.\n', '    function creditUser(address user, uint256 amount) public {\n', '        require(msg.sender == address(DELTA_TOKEN), "KNOCK KNOCK");\n', '        pendingCredits[user] = pendingCredits[user].add(amount.mul(PERCENT_BURNED).div(100)); //  we add the burned amount to perma credit\n', '    }\n', '\n', '    function addDevested(address user, uint256 amount) public {\n', '        require(DELTA_TOKEN.transferFrom(msg.sender, address(this), amount), "Did not transfer enough");\n', '        pendingCredits[user] = pendingCredits[user].add(amount.mul(PERCENT_BURNED).div(100)); //  we add the burned amount to perma credit\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma experimental ABIEncoderV2;\n', 'pragma solidity ^0.7.6;\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; \n', '\n', 'import "../common/OVLTokenTypes.sol";\n', '\n', 'interface IDeltaToken is IERC20 {\n', '    function vestingTransactions(address, uint256) external view returns (VestingTransaction memory);\n', '    function getUserInfo(address) external view returns (UserInformationLite memory);\n', '    function getMatureBalance(address, uint256) external view returns (uint256);\n', '    function liquidityRebasingPermitted() external view returns (bool);\n', '    function lpTokensInPair() external view returns (uint256);\n', '    function governance() external view returns (address);\n', '    function performLiquidityRebasing() external;\n', '    function distributor() external view returns (address);\n', '    function totalsForWallet(address ) external view returns (WalletTotals memory totals);\n', '    function adjustBalanceOfNoVestingAccount(address, uint256,bool) external;\n', '    function userInformation(address user) external view returns (UserInformation memory);\n', '    // Added with Sushi update\n', '    function setTokenTransferHandler(address) external;\n', '    function setBalanceCalculator(address) external;\n', '    function setPendingGovernance(address) external;\n', '    function acceptGovernance() external;\n', '}\n', '\n', 'pragma abicoder v2;\n', '\n', 'struct RecycleInfo {\n', '    uint256 booster;\n', '    uint256 farmedDelta;\n', '    uint256 farmedETH;\n', '    uint256 recycledDelta;\n', '    uint256 recycledETH;\n', '}\n', '\n', '\n', '\n', 'interface IDeepFarmingVault {\n', '    function addPermanentCredits(address,uint256) external;\n', '    function addNewRewards(uint256 amountDELTA, uint256 amountWETH) external;\n', '    function adminRescueTokens(address token, uint256 amount) external;\n', '    function setCompundBurn(bool shouldBurn) external;\n', '    function compound(address person) external;\n', '    function exit() external;\n', '    function withdrawRLP(uint256 amount) external;\n', '    function realFarmedOfPerson(address person) external view returns (RecycleInfo memory);\n', '    function deposit(uint256 numberRLP, uint256 numberDELTA) external;\n', '    function depositFor(address person, uint256 numberRLP, uint256 numberDELTA) external;\n', '    function depositWithBurn(uint256 numberDELTA) external;\n', '    function depositForWithBurn(address person, uint256 numberDELTA) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '// DELTA-BUG-BOUNTY\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'struct VestingTransaction {\n', '    uint256 amount;\n', '    uint256 fullVestingTimestamp;\n', '}\n', '\n', 'struct WalletTotals {\n', '    uint256 mature;\n', '    uint256 immature;\n', '    uint256 total;\n', '}\n', '\n', 'struct UserInformation {\n', '    // This is going to be read from only [0]\n', '    uint256 mostMatureTxIndex;\n', '    uint256 lastInTxIndex;\n', '    uint256 maturedBalance;\n', '    uint256 maxBalance;\n', '    bool fullSenderWhitelisted;\n', '    // Note that recieving immature balances doesnt mean they recieve them fully vested just that senders can do it\n', '    bool immatureReceiverWhitelisted;\n', '    bool noVestingWhitelisted;\n', '}\n', '\n', 'struct UserInformationLite {\n', '    uint256 maturedBalance;\n', '    uint256 maxBalance;\n', '    uint256 mostMatureTxIndex;\n', '    uint256 lastInTxIndex;\n', '}\n', '\n', 'struct VestingTransactionDetailed {\n', '    uint256 amount;\n', '    uint256 fullVestingTimestamp;\n', '    // uint256 percentVestedE4;\n', '    uint256 mature;\n', '    uint256 immature;\n', '}\n', '\n', '\n', 'uint256 constant QTY_EPOCHS = 7;\n', '\n', 'uint256 constant SECONDS_PER_EPOCH = 172800; // About 2days\n', '\n', 'uint256 constant FULL_EPOCH_TIME = SECONDS_PER_EPOCH * QTY_EPOCHS;\n', '\n', '// Precision Multiplier -- this many zeros (23) seems to get all the precision needed for all 18 decimals to be only off by a max of 1 unit\n', 'uint256 constant PM = 1e23;\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']
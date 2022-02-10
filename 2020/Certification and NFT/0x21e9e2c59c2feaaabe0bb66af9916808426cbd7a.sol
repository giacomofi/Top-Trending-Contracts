['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.7.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '    function migrator() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '    function setMigrator(address) external;\n', '}\n', '\n', '\n', 'library SafeMathUniswap {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', '\n', 'library UniswapV2Library {\n', '    using SafeMathUniswap for uint;\n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash\n", '            ))));\n', '    }\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '\n', '    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint amountInWithFee = amountIn.mul(997);\n', '        uint numerator = amountInWithFee.mul(reserveOut);\n', '        uint denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // performs chained getAmountOut calculations on any number of pairs\n', '    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[0] = amountIn;\n', '        for (uint i; i < path.length - 1; i++) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);\n', '            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '\n', '    // performs chained getAmountIn calculations on any number of pairs\n', '    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[amounts.length - 1] = amountOut;\n', '        for (uint i = path.length - 1; i > 0; i--) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);\n', '            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'interface IVampireAdapter {\n', '    // Victim info\n', '    function rewardToken() external view returns (IERC20);\n', '    function poolCount() external view returns (uint256);\n', '    function sellableRewardAmount() external view returns (uint256);\n', '    \n', '    // Victim actions, requires impersonation via delegatecall\n', '    function sellRewardForWeth(address adapter, uint256 rewardAmount, address to) external returns(uint256);\n', '    \n', '    // Pool info\n', '    function lockableToken(uint256 poolId) external view returns (IERC20);\n', '    function lockedAmount(address user, uint256 poolId) external view returns (uint256);\n', '    \n', '    // Pool actions, requires impersonation via delegatecall\n', '    function deposit(address adapter, uint256 poolId, uint256 amount) external;\n', '    function withdraw(address adapter, uint256 poolId, uint256 amount) external;\n', '    function claimReward(address adapter, uint256 poolId) external;\n', '    \n', '    function emergencyWithdraw(address adapter, uint256 poolId) external;\n', '    \n', '    // Service methods\n', '    function poolAddress(uint256 poolId) external view returns (address);\n', '    function rewardToWethPool() external view returns (address);\n', '\n', '    // Governance info methods    \n', '    function lockedValue(address user, uint256 poolId) external view returns (uint256);\n', '    function totalLockedValue(uint256 poolId) external view returns (uint256);\n', '    function normalizedAPY(uint256 poolId) external view returns (uint256);\n', '}\n', '\n', '\n', 'interface IDrainController {\n', '    function priceIsUnderRejectionTreshold() view external returns(bool);\n', '}\n', '\n', '\n', 'interface IMasterChef{\n', '    function poolInfo(uint256) external view returns (IERC20,uint256,uint256,uint256);\n', '    function userInfo(uint256, address) external view returns (uint256,uint256);\n', '    function poolLength() external view returns (uint256);\n', '    function deposit(uint256 _pid, uint256 _amount) external;\n', '    function withdraw(uint256 _pid, uint256 _amount) external;\n', '    function emergencyWithdraw(uint256 _pid) external;\n', '    function getMultiplier(uint256 _from, uint256 _to) external view returns (uint256);\n', '    function sushiPerBlock() external view returns (uint256);\n', '    function totalAllocPoint() external view returns (uint256);\n', '}\n', '\n', '\n', 'contract SushiAdapter is IVampireAdapter {\n', '    using SafeMath for uint256;\n', '    IDrainController constant drainController = IDrainController(0x2C907E0c40b9Dbb834eDD3Fdb739de4df9eDb9D7);\n', '    IMasterChef constant sushiMasterChef = IMasterChef(0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd);\n', '    IERC20 constant sushi = IERC20(0x6B3595068778DD592e39A122f4f5a5cF09C90fE2);\n', '    IERC20 constant weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    IUniswapV2Pair constant sushiWethPair = IUniswapV2Pair(0x795065dCc9f64b5614C407a6EFDC400DA6221FB0);\n', '    uint256 constant BLOCKS_PER_YEAR = 2336000;\n', '    // token 0 - sushi\n', '    // token 1 - weth\n', '\n', '    constructor() {\n', '    }\n', '\n', '    // Victim info\n', '    function rewardToken() external pure override returns (IERC20) {\n', '        return sushi;\n', '    }\n', '\n', '    function poolCount() external view override returns (uint256) {\n', '        return sushiMasterChef.poolLength();\n', '    }\n', '\n', '    function sellableRewardAmount() external pure override returns (uint256) {\n', '        return uint256(-1);\n', '    }\n', '    \n', '    // Victim actions, requires impersonation via delegatecall\n', '    function sellRewardForWeth(address, uint256 rewardAmount, address to) external override returns(uint256) {\n', '        require(drainController.priceIsUnderRejectionTreshold(), "Possible price manipulation, drain rejected");\n', '        sushi.transfer(address(sushiWethPair), rewardAmount);\n', '        (uint sushiReserve, uint wethReserve,) = sushiWethPair.getReserves();\n', '        uint amountOutput = UniswapV2Library.getAmountOut(rewardAmount, sushiReserve, wethReserve);\n', '        sushiWethPair.swap(uint(0), amountOutput, to, new bytes(0));\n', '        return amountOutput;\n', '    }\n', '    \n', '    // Pool info\n', '    function lockableToken(uint256 poolId) external view override returns (IERC20) {\n', '        (IERC20 lpToken,,,) = sushiMasterChef.poolInfo(poolId);\n', '        return lpToken;\n', '    }\n', '\n', '    function lockedAmount(address user, uint256 poolId) external view override returns (uint256) {\n', '        (uint256 amount,) = sushiMasterChef.userInfo(poolId, user);\n', '        return amount;\n', '    }\n', '    \n', '    // Pool actions, requires impersonation via delegatecall\n', '    function deposit(address _adapter, uint256 poolId, uint256 amount) external override {\n', '        IVampireAdapter adapter = IVampireAdapter(_adapter);\n', '        adapter.lockableToken(poolId).approve(address(sushiMasterChef), uint256(-1));\n', '        sushiMasterChef.deposit(poolId, amount);\n', '    }\n', '\n', '    function withdraw(address, uint256 poolId, uint256 amount) external override {\n', '        sushiMasterChef.withdraw( poolId, amount);\n', '    }\n', '\n', '    function claimReward(address, uint256 poolId) external override {\n', '        sushiMasterChef.deposit( poolId, 0);\n', '    }\n', '    \n', '    function emergencyWithdraw(address, uint256 poolId) external override {\n', '        sushiMasterChef.emergencyWithdraw(poolId);\n', '    }\n', '\n', '    // Service methods\n', '    function poolAddress(uint256) external pure override returns (address) {\n', '        return address(sushiMasterChef);\n', '    }\n', '\n', '    function rewardToWethPool() external pure override returns (address) {\n', '        return address(sushiWethPair);\n', '    }\n', '    \n', '    function lpTokenValue(uint256 amount, IUniswapV2Pair lpToken) public view returns(uint256) {\n', '        (uint256 token0Reserve, uint256 token1Reserve,) = lpToken.getReserves();\n', '        address token0 = lpToken.token0();\n', '        address token1 = lpToken.token1();\n', '        if(token0 == address(weth)) {\n', '            return amount.mul(token0Reserve).mul(2).div(lpToken.totalSupply());\n', '        }\n', '        if(token1 == address(weth)) {\n', '            return amount.mul(token1Reserve).mul(2).div(lpToken.totalSupply());\n', '        }\n', '        if(IUniswapV2Factory(lpToken.factory()).getPair(token0, address(weth)) != address(0)) {\n', '            (uint256 wethReserve, uint256 token0ToWethReserve) = UniswapV2Library.getReserves(lpToken.factory(), address(weth), token0);\n', '            uint256 tmp = amount.mul(token0Reserve).mul(wethReserve).mul(2);\n', '            return tmp.div(token0ToWethReserve).div(lpToken.totalSupply());\n', '        }\n', '        require(\n', '            IUniswapV2Factory(lpToken.factory()).getPair(token1, address(weth)) != address(0), \n', '            "Neither token0-weth nor token1-weth pair exists");\n', '        (uint256 wethReserve, uint256 token1ToWethReserve) = UniswapV2Library.getReserves(lpToken.factory(), address(weth), token1);\n', '        uint256 tmp = amount.mul(token1Reserve).mul(wethReserve).mul(2);\n', '        return tmp.div(token1ToWethReserve).div(lpToken.totalSupply());\n', '    }\n', '    function lockedValue(address user, uint256 poolId) external override view returns (uint256) {\n', '        SushiAdapter adapter = SushiAdapter(this);\n', '        return adapter.lpTokenValue(adapter.lockedAmount(user, poolId),IUniswapV2Pair(address(adapter.lockableToken(poolId))));     \n', '    }    \n', '\n', '    function totalLockedValue(uint256 poolId) external override view returns (uint256) {\n', '        SushiAdapter adapter = SushiAdapter(this);\n', '        IUniswapV2Pair lockedToken = IUniswapV2Pair(address(adapter.lockableToken(poolId))) ;\n', '        return adapter.lpTokenValue(lockedToken.balanceOf(adapter.poolAddress(poolId)), lockedToken);     \n', '    }\n', '\n', '    function normalizedAPY(uint256 poolId) external override view returns (uint256) {\n', '        SushiAdapter adapter = SushiAdapter(this);\n', '        (,uint256 allocationPoints,,) = sushiMasterChef.poolInfo(poolId);\n', '        uint256 sushiPerBlock = sushiMasterChef.sushiPerBlock();\n', '        uint256 totalAllocPoint = sushiMasterChef.totalAllocPoint();\n', '        uint256 multiplier = sushiMasterChef.getMultiplier(block.number - 1, block.number);\n', '        uint256 rewardPerBlock = multiplier.mul(sushiPerBlock).mul(allocationPoints).div(totalAllocPoint);\n', '        (uint256 sushiReserve, uint256 wethReserve,) = sushiWethPair.getReserves();\n', '        uint256 valuePerYear = rewardPerBlock.mul(wethReserve).mul(BLOCKS_PER_YEAR).div(sushiReserve);\n', '        return valuePerYear.mul(1 ether).div(adapter.totalLockedValue(poolId));\n', '    }\n', '}']
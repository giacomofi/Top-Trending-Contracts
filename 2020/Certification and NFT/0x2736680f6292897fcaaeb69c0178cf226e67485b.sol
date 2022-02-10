['// File: @openzeppelin\\contracts\\token\\ERC20\\IERC20.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts\\interfaces\\IUniswapV2Pair.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// File: contracts\\interfaces\\IUniswapV2Factory.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '    function migrator() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '    function setMigrator(address) external;\n', '}\n', '\n', '// File: contracts\\libraries\\SafeMath.sol\n', '\n', 'pragma solidity =0.6.12;\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library SafeMathUniswap {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', '// File: contracts\\libraries\\UniswapV2Library.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', '\n', '\n', 'library UniswapV2Library {\n', '    using SafeMathUniswap for uint;\n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash\n", '            ))));\n', '    }\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '\n', '    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint amountInWithFee = amountIn.mul(997);\n', '        uint numerator = amountInWithFee.mul(reserveOut);\n', '        uint denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // performs chained getAmountOut calculations on any number of pairs\n', '    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[0] = amountIn;\n', '        for (uint i; i < path.length - 1; i++) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);\n', '            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '\n', '    // performs chained getAmountIn calculations on any number of pairs\n', '    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[amounts.length - 1] = amountOut;\n', '        for (uint i = path.length - 1; i > 0; i--) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);\n', '            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts\\IVampireAdapter.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', 'interface IVampireAdapter {\n', '    // Victim info\n', '    function rewardToken() external view returns (IERC20);\n', '    function poolCount() external view returns (uint256);\n', '    function sellableRewardAmount() external view returns (uint256);\n', '    \n', '    // Victim actions, requires impersonation via delegatecall\n', '    function sellRewardForWeth(address adapter, uint256 rewardAmount, address to) external returns(uint256);\n', '    \n', '    // Pool info\n', '    function lockableToken(uint256 poolId) external view returns (IERC20);\n', '    function lockedAmount(address user, uint256 poolId) external view returns (uint256);\n', '    \n', '    // Pool actions, requires impersonation via delegatecall\n', '    function deposit(address adapter, uint256 poolId, uint256 amount) external;\n', '    function withdraw(address adapter, uint256 poolId, uint256 amount) external;\n', '    function claimReward(address adapter, uint256 poolId) external;\n', '    \n', '    function emergencyWithdraw(address adapter, uint256 poolId) external;\n', '    \n', '    // Service methods\n', '    function poolAddress(uint256 poolId) external view returns (address);\n', '    function rewardToWethPool() external view returns (address);\n', '\n', '    // Governance info methods    \n', '    function lockedValue(address user, uint256 poolId) external view returns (uint256);\n', '    function totalLockedValue(uint256 poolId) external view returns (uint256);\n', '    function normalizedAPY(uint256 poolId) external view returns (uint256);\n', '}\n', '\n', '// File: contracts\\IDrainController.sol\n', '\n', 'interface IDrainController {\n', '    function priceIsUnderRejectionTreshold() view external returns(bool);\n', '}\n', '\n', '// File: contracts\\adapters\\pickle\\IMasterChef.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', 'interface IMasterChef{\n', '    function poolInfo(uint256) external view returns (IERC20,uint256,uint256,uint256);\n', '    function userInfo(uint256, address) external view returns (uint256,uint256);\n', '    function poolLength() external view returns (uint256);\n', '    function pendingSushi(uint256 _pid, address _user) external view returns (uint256);\n', '    function deposit(uint256 _pid, uint256 _amount) external;\n', '    function withdraw(uint256 _pid, uint256 _amount) external;\n', '    function emergencyWithdraw(uint256 _pid) external;\n', '}\n', '\n', '// File: contracts\\adapters\\pickle\\PickleAdapter.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract PickleAdapter is IVampireAdapter {\n', '    IDrainController constant drainController = IDrainController(0x2e813f2e524dB699d279E631B0F2117856eb902C);\n', '    IMasterChef constant pickleMasterChef = IMasterChef(0xbD17B1ce622d73bD438b9E658acA5996dc394b0d);\n', '    IERC20 constant pickle = IERC20(0x429881672B9AE42b8EbA0E26cD9C73711b891Ca5);\n', '    IERC20 constant weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    IUniswapV2Pair constant pickleWethPair = IUniswapV2Pair(0xdc98556Ce24f007A5eF6dC1CE96322d65832A819);\n', '    // token 0 - pickle\n', '    // token 1 - weth\n', '\n', '    constructor() public {\n', '    }\n', '\n', '    // Victim info\n', '    function rewardToken() external view override returns (IERC20) {\n', '        return pickle;\n', '    }\n', '\n', '    function poolCount() external view override returns (uint256) {\n', '        return pickleMasterChef.poolLength();\n', '    }\n', '\n', '    function sellableRewardAmount() external view override returns (uint256) {\n', '        return uint256(-1);\n', '    }\n', '    \n', '    // Victim actions, requires impersonation via delegatecall\n', '    function sellRewardForWeth(address, uint256 rewardAmount, address to) external override returns(uint256) {\n', '        require(drainController.priceIsUnderRejectionTreshold(), "Possible price manipulation, drain rejected");\n', '        pickle.transfer(address(pickleWethPair), rewardAmount);\n', '        (uint pickleReserve, uint wethReserve,) = pickleWethPair.getReserves();\n', '        uint amountOutput = UniswapV2Library.getAmountOut(rewardAmount, pickleReserve, wethReserve);\n', '        pickleWethPair.swap(uint(0), amountOutput, to, new bytes(0));\n', '        return amountOutput;\n', '    }\n', '    \n', '    // Pool info\n', '    function lockableToken(uint256 poolId) external view override returns (IERC20) {\n', '        (IERC20 lpToken,,,) = pickleMasterChef.poolInfo(poolId);\n', '        return lpToken;\n', '    }\n', '\n', '    function lockedAmount(address user, uint256 poolId) external view override returns (uint256) {\n', '        (uint256 amount,) = pickleMasterChef.userInfo(poolId, user);\n', '        return amount;\n', '    }\n', '    \n', '    // Pool actions, requires impersonation via delegatecall\n', '    function deposit(address _adapter, uint256 poolId, uint256 amount) external override {\n', '        IVampireAdapter adapter = IVampireAdapter(_adapter);\n', '        adapter.lockableToken(poolId).approve(address(pickleMasterChef), uint256(-1));\n', '        pickleMasterChef.deposit( poolId, amount);\n', '    }\n', '\n', '    function withdraw(address, uint256 poolId, uint256 amount) external override {\n', '        pickleMasterChef.withdraw( poolId, amount);\n', '    }\n', '\n', '    function claimReward(address, uint256 poolId) external override {\n', '        pickleMasterChef.deposit( poolId, 0);\n', '    }\n', '    \n', '    function emergencyWithdraw(address, uint256 poolId) external override {\n', '        pickleMasterChef.emergencyWithdraw(poolId);\n', '    }\n', '    \n', '    // Service methods\n', '    function poolAddress(uint256) external view override returns (address) {\n', '        return address(pickleMasterChef);\n', '    }\n', '\n', '    function rewardToWethPool() external view override returns (address) {\n', '        return address(pickleWethPair);\n', '    }\n', '    \n', '    function lockedValue(address, uint256) external override view returns (uint256) {\n', '        require(false, "not implemented");\n', '    }    \n', '\n', '    function totalLockedValue(uint256) external override view returns (uint256) {\n', '        require(false, "not implemented"); \n', '    }\n', '\n', '    function normalizedAPY(uint256) external override view returns (uint256) {\n', '        require(false, "not implemented");\n', '    }\n', '}']
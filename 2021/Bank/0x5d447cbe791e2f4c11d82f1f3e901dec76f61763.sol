['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-19\n', '*/\n', '\n', '// Verified using https://dapp.tools\n', '\n', '// hevm: flattened sources of src/integrations/uniswap/liquidity-managers/UniswapV2LiquidityManager.sol\n', 'pragma solidity =0.6.7 >=0.6.0 <0.8.0 >=0.6.7 <0.7.0;\n', '\n', '////// src/integrations/uniswap/uni-v2/interfaces/IUniswapV2Pair.sol\n', '/* pragma solidity 0.6.7; */\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '////// src/integrations/uniswap/uni-v2/interfaces/IUniswapV2Router01.sol\n', '/* pragma solidity 0.6.7; */\n', '\n', 'interface IUniswapV2Router01 {\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapTokensForExactTokens(\n', '        uint amountOut,\n', '        uint amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n', '}\n', '\n', '////// src/integrations/uniswap/uni-v2/interfaces/IUniswapV2Router02.sol\n', '/* pragma solidity 0.6.7; */\n', '\n', "/* import './IUniswapV2Router01.sol'; */\n", '\n', 'interface IUniswapV2Router02 is IUniswapV2Router01 {\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountETH);\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', '\n', '////// src/interfaces/ERC20Like.sol\n', '/* pragma solidity ^0.6.7; */\n', '\n', 'abstract contract ERC20Like {\n', '    function approve(address guy, uint wad) virtual public returns (bool);\n', '    function transfer(address dst, uint wad) virtual public returns (bool);\n', '    function balanceOf(address) virtual external view returns (uint256);\n', '    function transferFrom(address src, address dst, uint wad)\n', '        virtual\n', '        public\n', '        returns (bool);\n', '}\n', '\n', '////// src/interfaces/UniswapLiquidityManagerLike.sol\n', '/* pragma solidity 0.6.7; */\n', '\n', 'abstract contract UniswapLiquidityManagerLike {\n', '    function getToken0FromLiquidity(uint256) virtual public view returns (uint256);\n', '    function getToken1FromLiquidity(uint256) virtual public view returns (uint256);\n', '\n', '    function getLiquidityFromToken0(uint256) virtual public view returns (uint256);\n', '    function getLiquidityFromToken1(uint256) virtual public view returns (uint256);\n', '\n', '    function removeLiquidity(\n', '      uint256 liquidity,\n', '      uint128 amount0Min,\n', '      uint128 amount1Min,\n', '      address to\n', '    ) public virtual returns (uint256, uint256);\n', '}\n', '\n', '////// src/math/SafeMath.sol\n', '// SPDX-License-Identifier: MIT\n', '\n', '/* pragma solidity >=0.6.0 <0.8.0; */\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'contract SafeMath_2 {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '////// src/integrations/uniswap/liquidity-managers/UniswapV2LiquidityManager.sol\n', '/* pragma solidity 0.6.7; */\n', '\n', '/* import "../uni-v2/interfaces/IUniswapV2Pair.sol"; */\n', '/* import "../uni-v2/interfaces/IUniswapV2Router02.sol"; */\n', '\n', '/* import "../../../math/SafeMath.sol"; */\n', '\n', '/* import "../../../interfaces/ERC20Like.sol"; */\n', '/* import "../../../interfaces/UniswapLiquidityManagerLike.sol"; */\n', '\n', 'contract UniswapV2LiquidityManager is UniswapLiquidityManagerLike, SafeMath_2 {\n', '    // The Uniswap v2 pair handled by this contract\n', '    IUniswapV2Pair     public pair;\n', '    // The official Uniswap v2 router V2\n', '    IUniswapV2Router02 public router;\n', '\n', '    constructor(address pair_, address router_) public {\n', '        require(pair_ != address(0), "UniswapV2LiquidityManager/null-pair");\n', '        require(router_ != address(0), "UniswapV2LiquidityManager/null-router");\n', '        pair   = IUniswapV2Pair(pair_);\n', '        router = IUniswapV2Router02(router_);\n', '    }\n', '\n', '    // --- Boolean Logic ---\n', '    function either(bool x, bool y) internal pure returns (bool z) {\n', '        assembly{ z := or(x, y)}\n', '    }\n', '\n', '    // --- Public Getters ---\n', '    /*\n', '    * @notice Return the amount of token0 tokens that someone would get back by burning a specific amount of LP tokens\n', '    * @param liquidityAmount The amount of LP tokens to burn\n', '    * @return The amount of token0 tokens that someone would get back\n', '    */\n', '    function getToken0FromLiquidity(uint256 liquidityAmount) public override view returns (uint256) {\n', '        if (liquidityAmount == 0) return 0;\n', '\n', '        (uint256 totalSupply, uint256 cumulativeLPBalance) = getSupplyAndCumulativeLiquidity(liquidityAmount);\n', '        if (either(liquidityAmount == 0, cumulativeLPBalance > totalSupply)) return 0;\n', '\n', '        return mul(cumulativeLPBalance, ERC20Like(pair.token0()).balanceOf(address(pair))) / totalSupply;\n', '    }\n', '    /*\n', '    * @notice Return the amount of token1 tokens that someone would get back by burning a specific amount of LP tokens\n', '    * @param liquidityAmount The amount of LP tokens to burn\n', '    * @return The amount of token1 tokens that someone would get back\n', '    */\n', '    function getToken1FromLiquidity(uint256 liquidityAmount) public override view returns (uint256) {\n', '        if (liquidityAmount == 0) return 0;\n', '\n', '        (uint256 totalSupply, uint256 cumulativeLPBalance) = getSupplyAndCumulativeLiquidity(liquidityAmount);\n', '        if (either(liquidityAmount == 0, cumulativeLPBalance > totalSupply)) return 0;\n', '\n', '        return mul(cumulativeLPBalance, ERC20Like(pair.token1()).balanceOf(address(pair))) / totalSupply;\n', '    }\n', '    /*\n', '    * @notice Return the amount of LP tokens needed to withdraw a specific amount of token0 tokens\n', '    * @param token0Amount The amount of token0 tokens from which to determine the amount of LP tokens\n', '    * @return The amount of LP tokens needed to withdraw a specific amount of token0 tokens\n', '    */\n', '    function getLiquidityFromToken0(uint256 token0Amount) public override view returns (uint256) {\n', '        if (either(token0Amount == 0, ERC20Like(address(pair.token0())).balanceOf(address(pair)) < token0Amount)) return 0;\n', '        return div(mul(token0Amount, pair.totalSupply()), ERC20Like(pair.token0()).balanceOf(address(pair)));\n', '    }\n', '    /*\n', '    * @notice Return the amount of LP tokens needed to withdraw a specific amount of token1 tokens\n', '    * @param token1Amount The amount of token1 tokens from which to determine the amount of LP tokens\n', '    * @return The amount of LP tokens needed to withdraw a specific amount of token1 tokens\n', '    */\n', '    function getLiquidityFromToken1(uint256 token1Amount) public override view returns (uint256) {\n', '        if (either(token1Amount == 0, ERC20Like(address(pair.token1())).balanceOf(address(pair)) < token1Amount)) return 0;\n', '        return div(mul(token1Amount, pair.totalSupply()), ERC20Like(pair.token1()).balanceOf(address(pair)));\n', '    }\n', '\n', '    // --- Internal Getters ---\n', '    /*\n', "    * @notice Internal view function that returns the total supply of LP tokens in the 'pair' as well as the LP\n", '    *         token balance of the pair contract itself if it were to have liquidityAmount extra tokens\n', '    * @param liquidityAmount The amount of LP tokens that would be burned\n', "    * @return The total supply of LP tokens in the 'pair' as well as the LP token balance\n", '    *         of the pair contract itself if it were to have liquidityAmount extra tokens\n', '    */\n', '    function getSupplyAndCumulativeLiquidity(uint256 liquidityAmount) internal view returns (uint256, uint256) {\n', '        return (pair.totalSupply(), add(pair.balanceOf(address(pair)), liquidityAmount));\n', '    }\n', '\n', '    // --- Liquidity Removal Logic ---\n', '    /*\n', '    * @notice Remove liquidity from the Uniswap pool\n', '    * @param liquidity The amount of LP tokens to burn\n', '    * @param amount0Min The min amount of token0 requested\n', '    * @param amount1Min The min amount of token1 requested\n', '    * @param to The address that receives token0 and token1 tokens after liquidity is removed\n', '    * @return The amounts of token0 and token1 tokens returned\n', '    */\n', '    function removeLiquidity(\n', '        uint256 liquidity,\n', '        uint128 amount0Min,\n', '        uint128 amount1Min,\n', '        address to\n', '    ) public override returns (uint256 amount0, uint256 amount1) {\n', '        require(to != address(0), "UniswapV2LiquidityManager/null-dst");\n', '        pair.transferFrom(msg.sender, address(this), liquidity);\n', '        pair.approve(address(router), liquidity);\n', '        (amount0, amount1) = router.removeLiquidity(\n', '          pair.token0(),\n', '          pair.token1(),\n', '          liquidity,\n', '          uint(amount0Min),\n', '          uint(amount1Min),\n', '          to,\n', '          now\n', '        );\n', '    }\n', '}']
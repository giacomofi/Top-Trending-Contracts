['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.8;\n', '\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol\n', '\n', '\n', 'interface IUniswapV2Router01 {\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapTokensForExactTokens(\n', '        uint amountOut,\n', '        uint amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n', '}\n', '\n', '// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol\n', '\n', '\n', '\n', 'interface IUniswapV2Router02 is IUniswapV2Router01 {\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountETH);\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', '\n', '// File: contracts/core/mixins/Initializable.sol\n', '\n', '// solhint-disable-next-line max-line-length\n', '// https://github.com/OpenZeppelin/openzeppelin-sdk/blob/master/packages/lib/contracts/Initializable.sol\n', '\n', '\n', 'contract Initializable {\n', '    bool public initialized;\n', '\n', '    bool private initializing;\n', '\n', '    modifier initializer() {\n', '        require(initializing || !initialized, "already-initialized");\n', '\n', '        bool isTopLevelCall = !initializing;\n', '        if (isTopLevelCall) {\n', '            initializing = true;\n', '            initialized = true;\n', '        }\n', '\n', '        _;\n', '\n', '        if (isTopLevelCall) {\n', '            initializing = false;\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/core/interfaces/IPriceFeed.sol\n', '\n', '\n', '\n', 'interface IPriceFeed {\n', '    function ethPriceInUSD(uint256 amount) external view returns (uint256);\n', '\n', '    function erc20PriceInETH(address token, uint256 amount) external view returns (uint256);\n', '\n', '    function erc20PriceInUSD(address token, uint256 amount) external view returns (uint256);\n', '}\n', '\n', '// File: contracts/core/interfaces/IMakerPriceFeed.sol\n', '\n', '\n', '\n', 'interface IMakerPriceFeed {\n', '    function read() external view returns (bytes32);\n', '}\n', '\n', '// File: contracts/core/libraries/UniswapV2Library.sol\n', '\n', '\n', '\n', '\n', '// solhint-disable-next-line max-line-length\n', '// UniswapV2Library https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/libraries/UniswapV2Library.sol\n', 'library UniswapV2Library {\n', '    using SafeMath for uint256;\n', '\n', '    function sortTokens(address tokenA, address tokenB)\n', '        internal\n', '        pure\n', '        returns (address token0, address token1)\n', '    {\n', '        require(tokenA != tokenB, "identical-addresses");\n', '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', '        require(token0 != address(0), "zero-address");\n', '    }\n', '\n', '    function pairFor(\n', '        address factory,\n', '        address tokenA,\n', '        address tokenB\n', '    ) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(\n', '            uint256(\n', '                keccak256(\n', '                    abi.encodePacked(\n', '                        hex"ff",\n', '                        factory,\n', '                        keccak256(abi.encodePacked(token0, token1)),\n', '                        hex"96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f"\n', '                        // init code hash\n', '                    )\n', '                )\n', '            )\n', '        );\n', '    }\n', '\n', '    function getReserves(\n', '        address factory,\n', '        address tokenA,\n', '        address tokenB\n', '    ) internal view returns (uint256 reserveA, uint256 reserveB) {\n', '        (address token0, ) = sortTokens(tokenA, tokenB);\n', '        address pair = pairFor(factory, tokenA, tokenB);\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory data) = pair.staticcall(\n', '            abi.encodeWithSignature("getReserves()") // IUniswapV2Pair.getReserves()\n', '        );\n', '        if (success) {\n', '            (uint112 reserve0, uint112 reserve1, ) = abi.decode(data, (uint112, uint112, uint32));\n', '            (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '        } else {\n', "            // Pair doesn't exist so cannot call 'getReserves()'\n", '            return (0, 0);\n', '        }\n', '    }\n', '\n', '    function quote(\n', '        uint256 amountA,\n', '        uint256 reserveA,\n', '        uint256 reserveB\n', '    ) internal pure returns (uint256 amountB) {\n', '        require(amountA > 0, "insufficient-amount");\n', '        require(reserveA > 0 && reserveB > 0, "insufficient-liquidity");\n', '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    function getAmountOut(\n', '        uint256 amountIn,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) internal pure returns (uint256 amountOut) {\n', '        require(amountIn > 0, "insufficient-input-amount");\n', '        require(reserveIn > 0 && reserveOut > 0, "insufficient-liquidity");\n', '        uint256 amountInWithFee = amountIn.mul(997);\n', '        uint256 numerator = amountInWithFee.mul(reserveOut);\n', '        uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    function getAmountIn(\n', '        uint256 amountOut,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) internal pure returns (uint256 amountIn) {\n', '        require(amountOut > 0, "insufficient-output-amount");\n', '        require(reserveIn > 0 && reserveOut > 0, "insufficient-liquidity");\n', '        uint256 numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint256 denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '}\n', '\n', '// File: contracts/core/PriceFeed.sol\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract PriceFeed is Initializable, IPriceFeed {\n', '    using SafeMath for uint256;\n', '\n', '    address internal _uniswapFactory;\n', '    address internal _weth;\n', '    address internal _makerPriceFeed;\n', '\n', '    function initialize(address makerPriceFeed, address uniswapRouter) public initializer {\n', '        _makerPriceFeed = makerPriceFeed;\n', '\n', '        IUniswapV2Router02 router = IUniswapV2Router02(uniswapRouter);\n', '        _uniswapFactory = router.factory();\n', '        _weth = router.WETH();\n', '    }\n', '\n', '    function ethPriceInUSD(uint256 amount) public override view returns (uint256) {\n', '        uint256 price = uint256(IMakerPriceFeed(_makerPriceFeed).read());\n', '        return price.mul(amount).div(10**18);\n', '    }\n', '\n', '    function erc20PriceInETH(address token, uint256 amount) public override view returns (uint256) {\n', '        (uint256 reserve0, uint256 reserve1) = UniswapV2Library.getReserves(\n', '            _uniswapFactory,\n', '            token,\n', '            _weth\n', '        );\n', '        if (reserve0 > 0 && reserve1 > 0) {\n', '            return UniswapV2Library.quote(amount, reserve0, reserve1);\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function erc20PriceInUSD(address token, uint256 amount) public override view returns (uint256) {\n', '        uint256 ethPrice = ethPriceInUSD(10**18);\n', '        uint256 erc20Price = erc20PriceInETH(token, amount);\n', '        return erc20Price == 0 ? 0 : ethPrice.mul(erc20Price).div(10**18);\n', '    }\n', '}']
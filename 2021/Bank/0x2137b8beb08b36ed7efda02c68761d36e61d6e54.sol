['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-11\n', '*/\n', '\n', 'pragma solidity =0.6.6;\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', '// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library TransferHelper {\n', '    function safeApprove(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');\n", '    }\n', '\n', '    function safeTransfer(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');\n", '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');\n", '    }\n', '\n', '    function safeTransferETH(address to, uint value) internal {\n', '        (bool success,) = to.call{value:value}(new bytes(0));\n', "        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');\n", '    }\n', '}\n', '\n', '// DebunkswapLibrary \n', '\n', 'library DebunkswapV1Library {\n', '    using SafeMath for uint;\n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'DebunkswapV1Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'DebunkswapV1Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'2bb5dc7a385ed5bf1bb9acec54f4ca97963f5b87ace3902a12adb962155a9ecb' // init code hash\n", '            ))));\n', '    }\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = IDebunkswapV1Pair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '\n', '    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'DebunkswapV1Library: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'DebunkswapV1Library: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'DebunkswapV1Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'DebunkswapV1Library: INSUFFICIENT_LIQUIDITY');\n", '        uint amountInWithFee = amountIn.mul(997);\n', '        uint numerator = amountInWithFee.mul(reserveOut);\n', '        uint denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'DebunkswapV1Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'DebunkswapV1Library: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // performs chained getAmountOut calculations on any number of pairs\n', '    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'DebunkswapV1Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[0] = amountIn;\n', '        for (uint i; i < path.length - 1; i++) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);\n', '            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '\n', '    // performs chained getAmountIn calculations on any number of pairs\n', '    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'DebunkswapV1Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[amounts.length - 1] = amountOut;\n', '        for (uint i = path.length - 1; i > 0; i--) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);\n', '            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '}\n', '\n', '//  IERC20 Contract Interface\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '}\n', '\n', '// WETH Interface \n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function withdraw(uint) external;\n', '}\n', '\n', '\n', '//   Debunkswap Factory Contract Interface\n', '\n', 'interface IDebunkswapV1Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '}\n', '\n', '// Debunkswap Pair Contract Interface\n', '\n', 'interface IDebunkswapV1Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// Debunkswap Router01 Contract Interface\n', '\n', 'interface IDebunkswapV1Router01 {\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapTokensForExactTokens(\n', '        uint amountOut,\n', '        uint amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n', '}\n', '\n', 'interface IDebunkswapV1Router02 is IDebunkswapV1Router01 {\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountETH);\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', '\n', '\n', '// Debunkswap Router02 Contract\n', '\n', 'contract DebunkswapV1Router02 is IDebunkswapV1Router02 {\n', '    using SafeMath for uint;\n', '\n', '    address public immutable override factory;\n', '    address public immutable override WETH;\n', '\n', '    modifier ensure(uint deadline) {\n', "        require(deadline >= block.timestamp, 'DebunkswapV1Router: EXPIRED');\n", '        _;\n', '    }\n', '\n', '    constructor(address _factory, address _WETH) public {\n', '        factory = _factory;\n', '        WETH = _WETH;\n', '    }\n', '\n', '    receive() external payable {\n', '        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract\n', '    }\n', '\n', '    // **** ADD LIQUIDITY ****\n', '    function _addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin\n', '    ) internal virtual returns (uint amountA, uint amountB) {\n', "        // create the pair if it doesn't exist yet\n", '        if (IDebunkswapV1Factory(factory).getPair(tokenA, tokenB) == address(0)) {\n', '            IDebunkswapV1Factory(factory).createPair(tokenA, tokenB);\n', '        }\n', '        (uint reserveA, uint reserveB) = DebunkswapV1Library.getReserves(factory, tokenA, tokenB);\n', '        if (reserveA == 0 && reserveB == 0) {\n', '            (amountA, amountB) = (amountADesired, amountBDesired);\n', '        } else {\n', '            uint amountBOptimal = DebunkswapV1Library.quote(amountADesired, reserveA, reserveB);\n', '            if (amountBOptimal <= amountBDesired) {\n', "                require(amountBOptimal >= amountBMin, 'DebunkswapV1Router: INSUFFICIENT_B_AMOUNT');\n", '                (amountA, amountB) = (amountADesired, amountBOptimal);\n', '            } else {\n', '                uint amountAOptimal = DebunkswapV1Library.quote(amountBDesired, reserveB, reserveA);\n', '                assert(amountAOptimal <= amountADesired);\n', "                require(amountAOptimal >= amountAMin, 'DebunkswapV1Router: INSUFFICIENT_A_AMOUNT');\n", '                (amountA, amountB) = (amountAOptimal, amountBDesired);\n', '            }\n', '        }\n', '    }\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {\n', '        (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);\n', '        address pair = DebunkswapV1Library.pairFor(factory, tokenA, tokenB);\n', '        TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);\n', '        TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);\n', '        liquidity = IDebunkswapV1Pair(pair).mint(to);\n', '    }\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {\n', '        (amountToken, amountETH) = _addLiquidity(\n', '            token,\n', '            WETH,\n', '            amountTokenDesired,\n', '            msg.value,\n', '            amountTokenMin,\n', '            amountETHMin\n', '        );\n', '        address pair = DebunkswapV1Library.pairFor(factory, token, WETH);\n', '        TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);\n', '        IWETH(WETH).deposit{value: amountETH}();\n', '        assert(IWETH(WETH).transfer(pair, amountETH));\n', '        liquidity = IDebunkswapV1Pair(pair).mint(to);\n', '        // refund dust eth, if any\n', '        if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);\n', '    }\n', '\n', '    // **** REMOVE LIQUIDITY ****\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {\n', '        address pair = DebunkswapV1Library.pairFor(factory, tokenA, tokenB);\n', '        IDebunkswapV1Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair\n', '        (uint amount0, uint amount1) = IDebunkswapV1Pair(pair).burn(to);\n', '        (address token0,) = DebunkswapV1Library.sortTokens(tokenA, tokenB);\n', '        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);\n', "        require(amountA >= amountAMin, 'DebunkswapV1Router: INSUFFICIENT_A_AMOUNT');\n", "        require(amountB >= amountBMin, 'DebunkswapV1Router: INSUFFICIENT_B_AMOUNT');\n", '    }\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {\n', '        (amountToken, amountETH) = removeLiquidity(\n', '            token,\n', '            WETH,\n', '            liquidity,\n', '            amountTokenMin,\n', '            amountETHMin,\n', '            address(this),\n', '            deadline\n', '        );\n', '        TransferHelper.safeTransfer(token, to, amountToken);\n', '        IWETH(WETH).withdraw(amountETH);\n', '        TransferHelper.safeTransferETH(to, amountETH);\n', '    }\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external virtual override returns (uint amountA, uint amountB) {\n', '        address pair = DebunkswapV1Library.pairFor(factory, tokenA, tokenB);\n', '        uint value = approveMax ? uint(-1) : liquidity;\n', '        IDebunkswapV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);\n', '        (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);\n', '    }\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external virtual override returns (uint amountToken, uint amountETH) {\n', '        address pair = DebunkswapV1Library.pairFor(factory, token, WETH);\n', '        uint value = approveMax ? uint(-1) : liquidity;\n', '        IDebunkswapV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);\n', '        (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);\n', '    }\n', '\n', '    // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) public virtual override ensure(deadline) returns (uint amountETH) {\n', '        (, amountETH) = removeLiquidity(\n', '            token,\n', '            WETH,\n', '            liquidity,\n', '            amountTokenMin,\n', '            amountETHMin,\n', '            address(this),\n', '            deadline\n', '        );\n', '        TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));\n', '        IWETH(WETH).withdraw(amountETH);\n', '        TransferHelper.safeTransferETH(to, amountETH);\n', '    }\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external virtual override returns (uint amountETH) {\n', '        address pair = DebunkswapV1Library.pairFor(factory, token, WETH);\n', '        uint value = approveMax ? uint(-1) : liquidity;\n', '        IDebunkswapV1Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);\n', '        amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(\n', '            token, liquidity, amountTokenMin, amountETHMin, to, deadline\n', '        );\n', '    }\n', '\n', '    // **** SWAP ****\n', '    // requires the initial amount to have already been sent to the first pair\n', '    function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {\n', '        for (uint i; i < path.length - 1; i++) {\n', '            (address input, address output) = (path[i], path[i + 1]);\n', '            (address token0,) = DebunkswapV1Library.sortTokens(input, output);\n', '            uint amountOut = amounts[i + 1];\n', '            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));\n', '            address to = i < path.length - 2 ? DebunkswapV1Library.pairFor(factory, output, path[i + 2]) : _to;\n', '            IDebunkswapV1Pair(DebunkswapV1Library.pairFor(factory, input, output)).swap(\n', '                amount0Out, amount1Out, to, new bytes(0)\n', '            );\n', '        }\n', '    }\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external virtual override ensure(deadline) returns (uint[] memory amounts) {\n', '        amounts = DebunkswapV1Library.getAmountsOut(factory, amountIn, path);\n', "        require(amounts[amounts.length - 1] >= amountOutMin, 'DebunkswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');\n", '        TransferHelper.safeTransferFrom(\n', '            path[0], msg.sender, DebunkswapV1Library.pairFor(factory, path[0], path[1]), amounts[0]\n', '        );\n', '        _swap(amounts, path, to);\n', '    }\n', '    function swapTokensForExactTokens(\n', '        uint amountOut,\n', '        uint amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external virtual override ensure(deadline) returns (uint[] memory amounts) {\n', '        amounts = DebunkswapV1Library.getAmountsIn(factory, amountOut, path);\n', "        require(amounts[0] <= amountInMax, 'DebunkswapV1Router: EXCESSIVE_INPUT_AMOUNT');\n", '        TransferHelper.safeTransferFrom(\n', '            path[0], msg.sender, DebunkswapV1Library.pairFor(factory, path[0], path[1]), amounts[0]\n', '        );\n', '        _swap(amounts, path, to);\n', '    }\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        virtual\n', '        override\n', '        payable\n', '        ensure(deadline)\n', '        returns (uint[] memory amounts)\n', '    {\n', "        require(path[0] == WETH, 'DebunkswapV1Router: INVALID_PATH');\n", '        amounts = DebunkswapV1Library.getAmountsOut(factory, msg.value, path);\n', "        require(amounts[amounts.length - 1] >= amountOutMin, 'DebunkswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');\n", '        IWETH(WETH).deposit{value: amounts[0]}();\n', '        assert(IWETH(WETH).transfer(DebunkswapV1Library.pairFor(factory, path[0], path[1]), amounts[0]));\n', '        _swap(amounts, path, to);\n', '    }\n', '    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n', '        external\n', '        virtual\n', '        override\n', '        ensure(deadline)\n', '        returns (uint[] memory amounts)\n', '    {\n', "        require(path[path.length - 1] == WETH, 'DebunkswapV1Router: INVALID_PATH');\n", '        amounts = DebunkswapV1Library.getAmountsIn(factory, amountOut, path);\n', "        require(amounts[0] <= amountInMax, 'DebunkswapV1Router: EXCESSIVE_INPUT_AMOUNT');\n", '        TransferHelper.safeTransferFrom(\n', '            path[0], msg.sender, DebunkswapV1Library.pairFor(factory, path[0], path[1]), amounts[0]\n', '        );\n', '        _swap(amounts, path, address(this));\n', '        IWETH(WETH).withdraw(amounts[amounts.length - 1]);\n', '        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);\n', '    }\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        virtual\n', '        override\n', '        ensure(deadline)\n', '        returns (uint[] memory amounts)\n', '    {\n', "        require(path[path.length - 1] == WETH, 'DebunkswapV1Router: INVALID_PATH');\n", '        amounts = DebunkswapV1Library.getAmountsOut(factory, amountIn, path);\n', "        require(amounts[amounts.length - 1] >= amountOutMin, 'DebunkswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');\n", '        TransferHelper.safeTransferFrom(\n', '            path[0], msg.sender, DebunkswapV1Library.pairFor(factory, path[0], path[1]), amounts[0]\n', '        );\n', '        _swap(amounts, path, address(this));\n', '        IWETH(WETH).withdraw(amounts[amounts.length - 1]);\n', '        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);\n', '    }\n', '    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n', '        external\n', '        virtual\n', '        override\n', '        payable\n', '        ensure(deadline)\n', '        returns (uint[] memory amounts)\n', '    {\n', "        require(path[0] == WETH, 'DebunkswapV1Router: INVALID_PATH');\n", '        amounts = DebunkswapV1Library.getAmountsIn(factory, amountOut, path);\n', "        require(amounts[0] <= msg.value, 'DebunkswapV1Router: EXCESSIVE_INPUT_AMOUNT');\n", '        IWETH(WETH).deposit{value: amounts[0]}();\n', '        assert(IWETH(WETH).transfer(DebunkswapV1Library.pairFor(factory, path[0], path[1]), amounts[0]));\n', '        _swap(amounts, path, to);\n', '        // refund dust eth, if any\n', '        if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);\n', '    }\n', '\n', '    // **** SWAP (supporting fee-on-transfer tokens) ****\n', '    // requires the initial amount to have already been sent to the first pair\n', '    function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {\n', '        for (uint i; i < path.length - 1; i++) {\n', '            (address input, address output) = (path[i], path[i + 1]);\n', '            (address token0,) = DebunkswapV1Library.sortTokens(input, output);\n', '            IDebunkswapV1Pair pair = IDebunkswapV1Pair(DebunkswapV1Library.pairFor(factory, input, output));\n', '            uint amountInput;\n', '            uint amountOutput;\n', '            { // scope to avoid stack too deep errors\n', '            (uint reserve0, uint reserve1,) = pair.getReserves();\n', '            (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '            amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);\n', '            amountOutput = DebunkswapV1Library.getAmountOut(amountInput, reserveInput, reserveOutput);\n', '            }\n', '            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));\n', '            address to = i < path.length - 2 ? DebunkswapV1Library.pairFor(factory, output, path[i + 2]) : _to;\n', '            pair.swap(amount0Out, amount1Out, to, new bytes(0));\n', '        }\n', '    }\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external virtual override ensure(deadline) {\n', '        TransferHelper.safeTransferFrom(\n', '            path[0], msg.sender, DebunkswapV1Library.pairFor(factory, path[0], path[1]), amountIn\n', '        );\n', '        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);\n', '        _swapSupportingFeeOnTransferTokens(path, to);\n', '        require(\n', '            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,\n', "            'DebunkswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT'\n", '        );\n', '    }\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    )\n', '        external\n', '        virtual\n', '        override\n', '        payable\n', '        ensure(deadline)\n', '    {\n', "        require(path[0] == WETH, 'DebunkswapV1Router: INVALID_PATH');\n", '        uint amountIn = msg.value;\n', '        IWETH(WETH).deposit{value: amountIn}();\n', '        assert(IWETH(WETH).transfer(DebunkswapV1Library.pairFor(factory, path[0], path[1]), amountIn));\n', '        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);\n', '        _swapSupportingFeeOnTransferTokens(path, to);\n', '        require(\n', '            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,\n', "            'DebunkswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT'\n", '        );\n', '    }\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    )\n', '        external\n', '        virtual\n', '        override\n', '        ensure(deadline)\n', '    {\n', "        require(path[path.length - 1] == WETH, 'DebunkswapV1Router: INVALID_PATH');\n", '        TransferHelper.safeTransferFrom(\n', '            path[0], msg.sender, DebunkswapV1Library.pairFor(factory, path[0], path[1]), amountIn\n', '        );\n', '        _swapSupportingFeeOnTransferTokens(path, address(this));\n', '        uint amountOut = IERC20(WETH).balanceOf(address(this));\n', "        require(amountOut >= amountOutMin, 'DebunkswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');\n", '        IWETH(WETH).withdraw(amountOut);\n', '        TransferHelper.safeTransferETH(to, amountOut);\n', '    }\n', '\n', '    // **** LIBRARY FUNCTIONS ****\n', '    function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {\n', '        return DebunkswapV1Library.quote(amountA, reserveA, reserveB);\n', '    }\n', '\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)\n', '        public\n', '        pure\n', '        virtual\n', '        override\n', '        returns (uint amountOut)\n', '    {\n', '        return DebunkswapV1Library.getAmountOut(amountIn, reserveIn, reserveOut);\n', '    }\n', '\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)\n', '        public\n', '        pure\n', '        virtual\n', '        override\n', '        returns (uint amountIn)\n', '    {\n', '        return DebunkswapV1Library.getAmountIn(amountOut, reserveIn, reserveOut);\n', '    }\n', '\n', '    function getAmountsOut(uint amountIn, address[] memory path)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (uint[] memory amounts)\n', '    {\n', '        return DebunkswapV1Library.getAmountsOut(factory, amountIn, path);\n', '    }\n', '\n', '    function getAmountsIn(uint amountOut, address[] memory path)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (uint[] memory amounts)\n', '    {\n', '        return DebunkswapV1Library.getAmountsIn(factory, amountOut, path);\n', '    }\n', '}']
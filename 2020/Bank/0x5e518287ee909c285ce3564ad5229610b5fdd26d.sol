['// SPDX-License-Identifier: BSD-3-Clause\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function withdraw(uint) external;\n', '}\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface USP {\n', '    \n', '   function ZapStake(uint amount, address _addr) external returns(bool);\n', '   function stakingStatus() external view returns (bool);\n', '   function scaledToken(uint amount) external returns(bool);\n', ' }\n', ' \n', ' interface AXIAv3 {\n', '    \n', '   function nextDayTime() external view returns(uint);\n', '   \n', ' }\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' */\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        z = x < y ? x : y;\n', '    }\n', '\n', '    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)\n', '    function sqrt(uint y) internal pure returns (uint z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', 'library UniswapV2Library {\n', '    using SafeMath for uint;\n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash\n", '            ))));\n', '    }\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '\n', '    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint amountInWithFee = amountIn.mul(997);\n', '        uint numerator = amountInWithFee.mul(reserveOut);\n', '        uint denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // performs chained getAmountOut calculations on any number of pairs\n', '    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[0] = amountIn;\n', '        for (uint i; i < path.length - 1; i++) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);\n', '            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '\n', '    // performs chained getAmountIn calculations on any number of pairs\n', '    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[amounts.length - 1] = amountOut;\n', '        for (uint i = path.length - 1; i > 0; i--) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);\n', '            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '}\n', '\n', 'contract UniswapZAP {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    address public _token;\n', '    address public _tokenWETHPair;\n', '    IWETH public _WETH;\n', '    bool private initialized;\n', '    address public SwapPool;\n', '    address public AXIAv3Add;\n', '    uint public interval;\n', '    address admin;\n', '\n', '    function initUniswapZAP(address token, address WETH, address tokenWethPair) public  {\n', '        // require(!initialized);\n', '        require(msg.sender == admin, "No authorization");\n', '        _token = token;\n', '        _WETH = IWETH(WETH);\n', '        _tokenWETHPair = tokenWethPair;\n', '        //initialized = true;\n', '    }\n', '\n', '    fallback() external payable {\n', '        if(msg.sender != address(_WETH)){\n', '             addLiquidityETHOnly(msg.sender);\n', '        }\n', '    }\n', '    receive() external payable {\n', '        if(msg.sender != address(_WETH)){\n', '             addLiquidityETHOnly(msg.sender);\n', '        }\n', '    }\n', '    \n', '    constructor()public {\n', '        \n', '        admin = msg.sender;\n', '    }\n', ' \n', '   function set(address _addr, address _addr2) public{\n', '       require(msg.sender == admin, "Not allowed to configure");\n', '       SwapPool = _addr;\n', '       AXIAv3Add = _addr2;\n', '   }\n', '   \n', '   function setInterval(uint value) public{\n', '       require(msg.sender == admin, "Not allowed to configure");\n', '       interval = value;\n', '   }\n', '\n', '    function addLiquidityETHOnly(address payable to) public payable {\n', '        require(to != address(0), "Invalid address");\n', '        require(statuscheck(), "Staking is not yet initilized, hold on till its done");\n', '        require(nextEmission() - now >= interval, "You can stake after emission");\n', '        \n', '\n', '        uint256 buyAmount = msg.value.div(2);\n', '        require(buyAmount > 0, "Insufficient ETH amount");\n', '        _WETH.deposit{value : msg.value}();\n', '\n', '        (uint256 reserveWeth, uint256 reserveTokens) = getPairReserves();\n', '        uint256 outTokens = UniswapV2Library.getAmountOut(buyAmount, reserveWeth, reserveTokens);\n', '        \n', '        _WETH.transfer(_tokenWETHPair, buyAmount);\n', '\n', '        (address token0, address token1) = UniswapV2Library.sortTokens(address(_WETH), _token);\n', '        IUniswapV2Pair(_tokenWETHPair).swap(_token == token0 ? outTokens : 0, _token == token1 ? outTokens : 0, address(this), "");\n', '\n', '        _addLiquidity(outTokens, buyAmount, to);\n', '\n', '    }\n', '\n', '    function _addLiquidity(uint256 tokenAmount, uint256 wethAmount, address payable to) internal {\n', '        (uint256 wethReserve, uint256 tokenReserve) = getPairReserves();\n', '\n', '        uint256 optimalTokenAmount = UniswapV2Library.quote(wethAmount, wethReserve, tokenReserve);\n', '\n', '        uint256 optimalWETHAmount;\n', '        if (optimalTokenAmount > tokenAmount) {\n', '            optimalWETHAmount = UniswapV2Library.quote(tokenAmount, tokenReserve, wethReserve);\n', '            optimalTokenAmount = tokenAmount;\n', '        }\n', '        else\n', '            optimalWETHAmount = wethAmount;\n', '\n', '        assert(_WETH.transfer(_tokenWETHPair, optimalWETHAmount));\n', '        assert(IERC20(_token).transfer(_tokenWETHPair, optimalTokenAmount));\n', '\n', '        // IUniswapV2Pair(_tokenWETHPair).mint(to);\n', '        IUniswapV2Pair(_tokenWETHPair).mint(SwapPool);\n', '        USP(SwapPool).ZapStake(optimalTokenAmount, to);\n', '       \n', '        \n', '        \n', '        \n', '        //refund dust\n', '        if (tokenAmount > optimalTokenAmount)\n', '            IERC20(_token).transfer(to, tokenAmount.sub(optimalTokenAmount));\n', '\n', '        if (wethAmount > optimalWETHAmount) {\n', '            uint256 withdrawAmount = wethAmount.sub(optimalWETHAmount);\n', '            _WETH.withdraw(withdrawAmount);\n', '            to.transfer(withdrawAmount);\n', '        }\n', '    }\n', '\n', '\n', '    function getLPTokenPerEthUnit(uint ethAmt) public view  returns (uint liquidity){\n', '        (uint256 reserveWeth, uint256 reserveTokens) = getPairReserves();\n', '        uint256 outTokens = UniswapV2Library.getAmountOut(ethAmt.div(2), reserveWeth, reserveTokens);\n', '        uint _totalSupply =  IUniswapV2Pair(_tokenWETHPair).totalSupply();\n', '\n', '        (address token0, ) = UniswapV2Library.sortTokens(address(_WETH), _token);\n', '        (uint256 amount0, uint256 amount1) = token0 == _token ? (outTokens, ethAmt.div(2)) : (ethAmt.div(2), outTokens);\n', '        (uint256 _reserve0, uint256 _reserve1) = token0 == _token ? (reserveTokens, reserveWeth) : (reserveWeth, reserveTokens);\n', '        liquidity = SafeMath.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);\n', '    }\n', '\n', '    function getPairReserves() internal view returns (uint256 wethReserves, uint256 tokenReserves) {\n', '        (address token0,) = UniswapV2Library.sortTokens(address(_WETH), _token);\n', '        (uint256 reserve0, uint reserve1,) = IUniswapV2Pair(_tokenWETHPair).getReserves();\n', '        (wethReserves, tokenReserves) = token0 == _token ? (reserve1, reserve0) : (reserve0, reserve1);\n', '    }\n', '\n', '\n', '    function statuscheck() public view returns(bool){\n', '        \n', '        return USP(SwapPool).stakingStatus();\n', '       \n', '    }\n', '    \n', '    // function zapstaki(uint optimalTokenAmount, address to) public returns (bool){\n', '        \n', '    //     USP(SwapPool).ZapStake(optimalTokenAmount, to);\n', '        \n', '    // }\n', '    \n', '    function nextEmission() public view returns (uint){\n', '        \n', '        return AXIAv3(AXIAv3Add).nextDayTime();\n', '        \n', '    }\n', '    \n', '    \n', '    \n', '    \n', '}']
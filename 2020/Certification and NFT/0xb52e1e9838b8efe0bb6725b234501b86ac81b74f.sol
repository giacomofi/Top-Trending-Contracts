['// SPDX-License-Identifier: MIT\n', '\n', '\n', '/**\n', ' * KP2R.NETWORK\n', ' * A standard implementation of kp3rv1 protocol\n', ' * Optimized Dapp\n', ' * Scalability\n', ' * Clean & tested code\n', ' */\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', '\n', 'library SafeMath {\n', '   \n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "add: +");\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, errorMessage);\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "sub: -");\n', '    }\n', '\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '          if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "mul: *");\n', '\n', '        return c;\n', '    }\n', '  function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '       if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, errorMessage);\n', '\n', '        return c;\n', '    }\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "div: /");\n', '    }\n', '  function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '  function mod(uint a, uint b) internal pure returns (uint) {\n', '        return mod(a, b, "mod: %");\n', '    }\n', ' function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '  interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  }\n', '\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '  function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: reverted");\n', '    }\n', '}\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: < 0");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '  function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: !contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: !succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'library Math {\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '   function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '  function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', 'interface IKeep2r {\n', '    function isMinKeeper(address keeper, uint minBond, uint earned, uint age) external returns (bool);\n', '    function worked(address keeper) external;\n', '}\n', '\n', '\n', 'interface ICERC20 {\n', '    function liquidateBorrow(address borrower, uint repayAmount, address cTokenCollateral) external returns (uint);\n', '    function borrowBalanceStored(address account) external view returns (uint);\n', '    function underlying() external view returns (address);\n', '    function symbol() external view returns (string memory);\n', '    function redeem(uint redeemTokens) external returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '}\n', '\n', 'interface ICEther {\n', '    function liquidateBorrow(address borrower, address cTokenCollateral) external payable;\n', '    function borrowBalanceStored(address account) external view returns (uint);\n', '}\n', '\n', 'interface IComptroller {\n', '    function getAccountLiquidity(address account) external view returns (uint, uint, uint);\n', '    function closeFactorMantissa() external view returns (uint);\n', '}\n', '\n', 'interface IUniswapV2Pair {\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function getReserves() external view returns (uint reserve0, uint reserve1, uint32 blockTimestampLast);\n', '}\n', '\n', 'interface IUniswapV2Router {\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '}\n', '\n', 'interface IUniswapV2Factory {\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '}\n', '\n', 'interface IWETH9 {\n', '    function deposit() external payable;\n', '}\n', '\n', 'contract CompoundFlashLiquidationsKeep2r {\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint256;\n', '\n', '    IComptroller constant public Comptroller = IComptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);\n', '    IUniswapV2Factory constant public FACTORY = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);\n', '    IUniswapV2Router constant public ROUTER = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '    address constant public WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    address constant public cETH = address(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);\n', '\n', '    modifier upkeep() {\n', '        require(KP2R.isMinKeeper(tx.origin, 100e18, 0, 0), "::isKeeper: keeper is not registered");\n', '        _;\n', '        KP2R.worked(msg.sender);\n', '    }\n', '\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', '    }\n', '\n', '    IKeep2r public constant KP2R = IKeep2r(0x9BdE098Be22658d057C3F1F185e3Fd4653E2fbD1);\n', '\n', '    function pairFor(address borrowed) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(borrowed, WETH);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                FACTORY,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash\n", '            ))));\n', '    }\n', '\n', '    function calcRepayAmount(IUniswapV2Pair pair, uint amount0, uint amount1) public view returns (uint) {\n', '        (uint reserve0, uint reserve1, ) = pair.getReserves();\n', '        uint val = 0;\n', '        if (amount0 == 0) {\n', '            val = amount1.mul(reserve0).div(reserve1);\n', '        } else {\n', '            val = amount0.mul(reserve1).div(reserve0);\n', '        }\n', '\n', '        return (val\n', '                .add(val.mul(301).div(100000)))\n', '                .mul(reserve0.mul(reserve1))\n', '                .div(IERC20(pair.token0()).balanceOf(address(pair))\n', '                .mul(IERC20(pair.token1()).balanceOf(address(pair))));\n', '    }\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint) {\n', '        uint amountInWithFee = amountIn.mul(997);\n', '        return amountInWithFee.mul(reserveOut) / reserveIn.mul(1000).add(amountInWithFee);\n', '    }\n', '\n', '    function _swap(address suppliedUnderlying, address supplied, IUniswapV2Pair toPair) internal {\n', '        address _underlying = suppliedUnderlying;\n', '        if (supplied == cETH) {\n', '            _underlying = WETH;\n', '            IWETH9(WETH).deposit.value(address(this).balance)();\n', '        } else {\n', '            (uint reserve0, uint reserve1,) = toPair.getReserves();\n', '            uint amountIn = IERC20(_underlying).balanceOf(address(this));\n', '            IERC20(_underlying).transfer(address(toPair), amountIn);\n', '            if (_underlying == toPair.token0()) {\n', '                toPair.swap(0, getAmountOut(amountIn, reserve0, reserve1), address(this), new bytes(0));\n', '            } else {\n', '                toPair.swap(getAmountOut(amountIn, reserve1, reserve0), 0, address(this), new bytes(0));\n', '            }\n', '        }\n', '    }\n', '\n', '    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external {\n', '        uint liquidatableAmount = (amount0 == 0 ? amount1 : amount0);\n', '        (address borrower, address borrowed, address supplied, address fromPair, address toPair, address suppliedUnderlying) = decode(data);\n', '\n', '        ICERC20(borrowed).liquidateBorrow(borrower, liquidatableAmount, supplied);\n', '        ICERC20(supplied).redeem(ICERC20(supplied).balanceOf(address(this)));\n', '\n', '        _swap(suppliedUnderlying, supplied, IUniswapV2Pair(toPair));\n', '\n', '        IERC20(WETH).transfer(fromPair, calcRepayAmount(IUniswapV2Pair(fromPair), amount0, amount1));\n', '        IERC20(WETH).transfer(tx.origin, IERC20(WETH).balanceOf(address(this)));\n', '    }\n', '\n', '    function underlying(address token) external view returns (address) {\n', '        return ICERC20(token).underlying();\n', '    }\n', '\n', '    function underlyingPair(address token) external view returns (address) {\n', '        return pairFor(ICERC20(token).underlying());\n', '    }\n', '\n', '    function () external payable { }\n', '\n', '    function liquidatable(address borrower, address borrowed) external view returns (uint) {\n', '        (,,uint256 shortFall) = Comptroller.getAccountLiquidity(borrower);\n', '        require(shortFall > 0, "liquidate:shortFall == 0");\n', '\n', '        uint256 liquidatableAmount = ICERC20(borrowed).borrowBalanceStored(borrower);\n', '\n', '        require(liquidatableAmount > 0, "liquidate:borrowBalanceStored == 0");\n', '\n', '        return liquidatableAmount.mul(Comptroller.closeFactorMantissa()).div(1e18);\n', '    }\n', '\n', '    function calculate(address borrower, address borrowed, address supplied) external view returns (address fromPair, address toPair, address borrowedUnderlying, address suppliedUnderlying, uint amount) {\n', '        amount = ICERC20(borrowed).borrowBalanceStored(borrower);\n', '        amount = amount.mul(Comptroller.closeFactorMantissa()).div(1e18);\n', '        borrowedUnderlying = ICERC20(borrowed).underlying();\n', '\n', '        fromPair = pairFor(borrowedUnderlying);\n', '        suppliedUnderlying = ICERC20(supplied).underlying();\n', '        toPair = pairFor(suppliedUnderlying);\n', '    }\n', '\n', '    function liquidate(address borrower, address borrowed, address supplied) external {\n', '        (,,uint256 shortFall) = Comptroller.getAccountLiquidity(borrower);\n', '        require(shortFall > 0, "liquidate:shortFall == 0");\n', '\n', '        uint256 amount = ICERC20(borrowed).borrowBalanceStored(borrower);\n', '        require(amount > 0, "liquidate:borrowBalanceStored == 0");\n', '        amount = amount.mul(Comptroller.closeFactorMantissa()).div(1e18);\n', '        require(amount > 0, "liquidate:liquidatableAmount == 0");\n', '\n', '        address borrowedUnderlying = ICERC20(borrowed).underlying();\n', '\n', '        address fromPair = pairFor(borrowedUnderlying);\n', '        address suppliedUnderlying = ICERC20(supplied).underlying();\n', '        address toPair = pairFor(suppliedUnderlying);\n', '\n', '        liquidateCalculated(borrower, borrowed, supplied, fromPair, toPair, borrowedUnderlying, suppliedUnderlying, amount);\n', '    }\n', '\n', '    function encode(address borrower, address borrowed, address supplied, address fromPair, address toPair, address suppliedUnderlying) internal pure returns (bytes memory) {\n', '        return abi.encode(borrower, borrowed, supplied, fromPair, toPair, suppliedUnderlying);\n', '    }\n', '\n', '    function decode(bytes memory b) internal pure returns (address, address, address, address, address, address) {\n', '        return abi.decode(b, (address, address, address, address, address, address));\n', '    }\n', '\n', '    function liquidateCalculated(\n', '        address borrower,\n', '        address borrowed,\n', '        address supplied,\n', '        address fromPair,\n', '        address toPair,\n', '        address borrowedUnderlying,\n', '        address suppliedUnderlying,\n', '        uint amount\n', '    ) public upkeep {\n', '        IERC20(borrowedUnderlying).safeIncreaseAllowance(borrowed, amount);\n', '        (uint _amount0, uint _amount1) = (borrowedUnderlying == IUniswapV2Pair(fromPair).token0() ? (amount, uint(0)) : (uint(0), amount));\n', '        IUniswapV2Pair(fromPair).swap(_amount0, _amount1, address(this), encode(borrower, borrowed, supplied, fromPair, toPair, suppliedUnderlying));\n', '    }\n', '}']
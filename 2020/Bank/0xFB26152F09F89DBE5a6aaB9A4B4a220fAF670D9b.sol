['// File: solidity-common/contracts/interface/IERC20.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', '/**\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '    * 可选方法\n', '    */\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '\n', '    /**\n', '     * 必须方法\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * 事件类型\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/library/UQ112x112.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', '// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))\n', '\n', '// range: [0, 2**112 - 1]\n', '// resolution: 1 / 2**112\n', '\n', '\n', 'library UQ112x112 {\n', '    uint224 constant Q112 = 2 ** 112;\n', '\n', '    // encode a uint112 as a UQ112x112\n', '    function encode(uint112 y) internal pure returns (uint224 z) {\n', '        z = uint224(y) * Q112;\n', '        // never overflows\n', '    }\n', '\n', '    // divide a UQ112x112 by a uint112, returning a UQ112x112\n', '    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {\n', '        z = x / uint224(y);\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/interface/IBtswapCallee.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', 'interface IBtswapCallee {\n', '    function bitswapCall(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external;\n', '\n', '}\n', '\n', '// File: contracts/interface/IBtswapFactory.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', 'interface IBtswapFactory {\n', '    function FEE_RATE_DENOMINATOR() external view returns (uint256);\n', '\n', '    function feeTo() external view returns (address);\n', '\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function feeRateNumerator() external view returns (uint256);\n', '\n', '    function initCodeHash() external view returns (bytes32);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '\n', '    function allPairs(uint256) external view returns (address pair);\n', '\n', '    function allPairsLength() external view returns (uint256);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setRouter(address) external;\n', '\n', '    function setFeeTo(address) external;\n', '\n', '    function setFeeToSetter(address) external;\n', '\n', '    function setFeeRateNumerator(uint256) external;\n', '\n', '    function setInitCodeHash(bytes32) external;\n', '\n', '    function sortTokens(address tokenA, address tokenB) external pure returns (address token0, address token1);\n', '\n', '    function pairFor(address factory, address tokenA, address tokenB) external view returns (address pair);\n', '\n', '    function getReserves(address factory, address tokenA, address tokenB) external view returns (uint256 reserveA, uint256 reserveB);\n', '\n', '    function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);\n', '\n', '    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);\n', '\n', '    function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);\n', '\n', '    function getAmountsOut(address factory, uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);\n', '\n', '    function getAmountsIn(address factory, uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);\n', '\n', '\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint256);\n', '\n', '}\n', '\n', '// File: contracts/interface/IBtswapPairToken.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', 'interface IBtswapPairToken {\n', '    function name() external pure returns (string memory);\n', '\n', '    function symbol() external pure returns (string memory);\n', '\n', '    function decimals() external pure returns (uint8);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address owner) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '\n', '    function nonces(address owner) external view returns (uint256);\n', '\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint256);\n', '\n', '    function router() external view returns (address);\n', '\n', '    function factory() external view returns (address);\n', '\n', '    function token0() external view returns (address);\n', '\n', '    function token1() external view returns (address);\n', '\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '\n', '    function price0CumulativeLast() external view returns (uint256);\n', '\n', '    function price1CumulativeLast() external view returns (uint256);\n', '\n', '    function kLast() external view returns (uint256);\n', '\n', '    function mint(address to) external returns (uint256 liquidity);\n', '\n', '    function burn(address to) external returns (uint256 amount0, uint256 amount1);\n', '\n', '    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;\n', '\n', '    function skim(address to) external;\n', '\n', '    function sync() external;\n', '\n', '    function initialize(address, address, address) external;\n', '\n', '    function price(address token) external view returns (uint256);\n', '\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Mint(address indexed sender, uint256 amount0, uint256 amount1);\n', '    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);\n', '    event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '}\n', '\n', '// File: contracts/interface/IBtswapRouter02.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', 'interface IBtswapRouter02 {\n', '    function factory() external pure returns (address);\n', '\n', '    function WETH() external pure returns (address);\n', '\n', '    function BT() external pure returns (address);\n', '\n', '    function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);\n', '\n', '    function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);\n', '\n', '    function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '    function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);\n', '\n', '    function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);\n', '\n', '    function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);\n', '\n', '    function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);\n', '\n', '    function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external view returns (uint256 amountB);\n', '\n', '    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);\n', '\n', '    function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);\n', '\n', '    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);\n', '\n', '    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);\n', '\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH);\n', '\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;\n', '\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;\n', '\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;\n', '\n', '    function weth(address token) external view returns (uint256);\n', '\n', '    function onTransfer(address sender, address recipient) external returns (bool);\n', '\n', '}\n', '\n', '// File: solidity-common/contracts/library/SafeMath.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', '/**\n', ' * 算术操作\n', ' */\n', 'library SafeMath {\n', '    uint256 constant WAD = 10 ** 18;\n', '    uint256 constant RAY = 10 ** 27;\n', '\n', '    function wad() public pure returns (uint256) {\n', '        return WAD;\n', '    }\n', '\n', '    function ray() public pure returns (uint256) {\n', '        return RAY;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a <= b ? a : b;\n', '    }\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function sqrt(uint256 a) internal pure returns (uint256 b) {\n', '        if (a > 3) {\n', '            b = a;\n', '            uint256 x = a / 2 + 1;\n', '            while (x < b) {\n', '                b = x;\n', '                x = (a / x + x) / 2;\n', '            }\n', '        } else if (a != 0) {\n', '            b = 1;\n', '        }\n', '    }\n', '\n', '    function wmul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mul(a, b) / WAD;\n', '    }\n', '\n', '    function wmulRound(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return add(mul(a, b), WAD / 2) / WAD;\n', '    }\n', '\n', '    function rmul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mul(a, b) / RAY;\n', '    }\n', '\n', '    function rmulRound(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return add(mul(a, b), RAY / 2) / RAY;\n', '    }\n', '\n', '    function wdiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(mul(a, WAD), b);\n', '    }\n', '\n', '    function wdivRound(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return add(mul(a, WAD), b / 2) / b;\n', '    }\n', '\n', '    function rdiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(mul(a, RAY), b);\n', '    }\n', '\n', '    function rdivRound(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return add(mul(a, RAY), b / 2) / b;\n', '    }\n', '\n', '    function wpow(uint256 x, uint256 n) internal pure returns (uint256) {\n', '        uint256 result = WAD;\n', '        while (n > 0) {\n', '            if (n % 2 != 0) {\n', '                result = wmul(result, x);\n', '            }\n', '            x = wmul(x, x);\n', '            n /= 2;\n', '        }\n', '        return result;\n', '    }\n', '\n', '    function rpow(uint256 x, uint256 n) internal pure returns (uint256) {\n', '        uint256 result = RAY;\n', '        while (n > 0) {\n', '            if (n % 2 != 0) {\n', '                result = rmul(result, x);\n', '            }\n', '            x = rmul(x, x);\n', '            n /= 2;\n', '        }\n', '        return result;\n', '    }\n', '}\n', '\n', '// File: contracts/interface/IBtswapERC20.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', 'interface IBtswapERC20 {\n', '    function name() external pure returns (string memory);\n', '\n', '    function symbol() external pure returns (string memory);\n', '\n', '    function decimals() external pure returns (uint8);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address owner) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '\n', '    function nonces(address owner) external view returns (uint256);\n', '\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '}\n', '\n', '// File: contracts/biz/BtswapERC20.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', '\n', '\n', 'contract BtswapERC20 is IBtswapERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name = "Btswap Pair Token";\n', '    string public constant symbol = "BPT";\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256  public totalSupply;\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '    mapping(address => uint256) public nonces;\n', '\n', '    bytes32 public DOMAIN_SEPARATOR;\n', '    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;\n', '\n', '    constructor() public {\n', '        uint256 chainId;\n', '        assembly {\n', '            chainId := chainid\n', '        }\n', '        DOMAIN_SEPARATOR = keccak256(\n', '            abi.encode(\n', '                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),\n', '                keccak256(bytes(name)),\n', '                keccak256(bytes("1")),\n', '                chainId,\n', '                address(this)\n', '            )\n', '        );\n', '    }\n', '\n', '    function _mint(address to, uint256 value) internal {\n', '        totalSupply = totalSupply.add(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(address(0), to, value);\n', '    }\n', '\n', '    function _burn(address from, uint256 value) internal {\n', '        balanceOf[from] = balanceOf[from].sub(value);\n', '        totalSupply = totalSupply.sub(value);\n', '        emit Transfer(from, address(0), value);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 value) private {\n', '        allowance[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    function _transfer(address from, address to, uint256 value) private {\n', '        balanceOf[from] = balanceOf[from].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function approve(address spender, uint256 value) external returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        if (allowance[from][msg.sender] != uint256(- 1)) {\n', '            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);\n', '        }\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {\n', '        require(deadline >= block.timestamp, "BtswapPairToken: EXPIRED");\n', '        bytes32 digest = keccak256(\n', '            abi.encodePacked(\n', '                "\\x19\\x01",\n', '                DOMAIN_SEPARATOR,\n', '                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))\n', '            )\n', '        );\n', '        address recoveredAddress = ecrecover(digest, v, r, s);\n', '        require(recoveredAddress != address(0) && recoveredAddress == owner, "BtswapPairToken: INVALID_SIGNATURE");\n', '        _approve(owner, spender, value);\n', '    }\n', '\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '}\n', '\n', '// File: contracts/biz/BtswapPairToken.sol\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract BtswapPairToken is IBtswapPairToken, BtswapERC20 {\n', '    using SafeMath  for uint256;\n', '    using UQ112x112 for uint224;\n', '\n', '    uint256 public constant MINIMUM_LIQUIDITY = 10 ** 3;\n', '    bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));\n', '\n', '    address public router;\n', '    address public factory;\n', '    address public token0;\n', '    address public token1;\n', '\n', '    uint256 private unlocked = 1;\n', '    uint112 private reserve0;           // uses single storage slot, accessible via getReserves\n', '    uint112 private reserve1;           // uses single storage slot, accessible via getReserves\n', '    uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves\n', '\n', '    uint256 public price0CumulativeLast;\n', '    uint256 public price1CumulativeLast;\n', '    uint256 public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event\n', '\n', '    constructor() public {\n', '        factory = msg.sender;\n', '    }\n', '\n', '    // called once by the factory at time of deployment\n', '    function initialize(address _router, address _token0, address _token1) external {\n', '        // sufficient check\n', '        require(msg.sender == factory, "BtswapPairToken: FORBIDDEN");\n', '        router = _router;\n', '        token0 = _token0;\n', '        token1 = _token1;\n', '    }\n', '\n', '    // update reserves and, on the first call per block, price accumulators\n', '    function _update(uint256 balance0, uint256 balance1, uint112 _reserve0, uint112 _reserve1) private {\n', '        require(balance0 <= uint112(- 1) && balance1 <= uint112(- 1), "BtswapPairToken: OVERFLOW");\n', '        uint32 blockTimestamp = uint32(block.timestamp % 2 ** 32);\n', '        // overflow is desired\n', '        uint32 timeElapsed = blockTimestamp - blockTimestampLast;\n', '        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {\n', '            // * never overflows, and + overflow is desired\n', '            price0CumulativeLast += uint256(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;\n', '            price1CumulativeLast += uint256(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;\n', '        }\n', '        reserve0 = uint112(balance0);\n', '        reserve1 = uint112(balance1);\n', '        blockTimestampLast = blockTimestamp;\n', '        emit Sync(reserve0, reserve1);\n', '    }\n', '\n', '    // if fee is on, mint liquidity equivalent to 1/5th of the growth in sqrt(k)\n', '    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {\n', '        address feeTo = IBtswapFactory(factory).feeTo();\n', '        feeOn = feeTo != address(0);\n', '        // gas savings\n', '        uint256 _kLast = kLast;\n', '        if (feeOn) {\n', '            if (_kLast != 0) {\n', '                uint256 rootK = SafeMath.sqrt(uint256(_reserve0).mul(_reserve1));\n', '                uint256 rootKLast = SafeMath.sqrt(_kLast);\n', '                if (rootK > rootKLast) {\n', '                    uint256 numerator = totalSupply.mul(rootK.sub(rootKLast));\n', '                    uint256 denominator = rootK.mul(4).add(rootKLast);\n', '                    uint256 liquidity = numerator / denominator;\n', '                    if (liquidity > 0) _mint(feeTo, liquidity);\n', '                }\n', '            }\n', '        } else if (_kLast != 0) {\n', '            kLast = 0;\n', '        }\n', '    }\n', '\n', '    // this low-level function should be called from a contract which performs important safety checks\n', '    function mint(address to) external lock returns (uint256 liquidity) {\n', '        require(msg.sender == router, "BtswapPairToken: FORBIDDEN");\n', '\n', '        // gas savings\n', '        (uint112 _reserve0, uint112 _reserve1,) = getReserves();\n', '        uint256 balance0 = IERC20(token0).balanceOf(address(this));\n', '        uint256 balance1 = IERC20(token1).balanceOf(address(this));\n', '        uint256 amount0 = balance0.sub(_reserve0);\n', '        uint256 amount1 = balance1.sub(_reserve1);\n', '\n', '        bool feeOn = _mintFee(_reserve0, _reserve1);\n', '        // gas savings, must be defined here since totalSupply can update in _mintFee\n', '        uint256 _totalSupply = totalSupply;\n', '        if (_totalSupply == 0) {\n', '            liquidity = SafeMath.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);\n', '            // permanently lock the first MINIMUM_LIQUIDITY tokens\n', '            _mint(address(0), MINIMUM_LIQUIDITY);\n', '        } else {\n', '            liquidity = SafeMath.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);\n', '        }\n', '        require(liquidity > 0, "BtswapPairToken: INSUFFICIENT_LIQUIDITY_MINTED");\n', '        _mint(to, liquidity);\n', '\n', '        _update(balance0, balance1, _reserve0, _reserve1);\n', '        // reserve0 and reserve1 are up-to-date\n', '        if (feeOn) kLast = uint256(reserve0).mul(reserve1);\n', '        emit Mint(msg.sender, amount0, amount1);\n', '    }\n', '\n', '    // this low-level function should be called from a contract which performs important safety checks\n', '    function burn(address to) external lock returns (uint256 amount0, uint256 amount1) {\n', '        require(msg.sender == router, "BtswapPairToken: FORBIDDEN");\n', '\n', '        // gas savings\n', '        (uint112 _reserve0, uint112 _reserve1,) = getReserves();\n', '        // gas savings\n', '        address _token0 = token0;\n', '        // gas savings\n', '        address _token1 = token1;\n', '        uint256 balance0 = IERC20(_token0).balanceOf(address(this));\n', '        uint256 balance1 = IERC20(_token1).balanceOf(address(this));\n', '        uint256 liquidity = balanceOf[address(this)];\n', '\n', '        bool feeOn = _mintFee(_reserve0, _reserve1);\n', '        // gas savings, must be defined here since totalSupply can update in _mintFee\n', '        uint256 _totalSupply = totalSupply;\n', '        // using balances ensures pro-rata distribution\n', '        amount0 = liquidity.mul(balance0) / _totalSupply;\n', '        // using balances ensures pro-rata distribution\n', '        amount1 = liquidity.mul(balance1) / _totalSupply;\n', '        require(amount0 > 0 && amount1 > 0, "BtswapPairToken: INSUFFICIENT_LIQUIDITY_BURNED");\n', '        _burn(address(this), liquidity);\n', '        _safeTransfer(_token0, to, amount0);\n', '        _safeTransfer(_token1, to, amount1);\n', '        balance0 = IERC20(_token0).balanceOf(address(this));\n', '        balance1 = IERC20(_token1).balanceOf(address(this));\n', '\n', '        _update(balance0, balance1, _reserve0, _reserve1);\n', '        // reserve0 and reserve1 are up-to-date\n', '        if (feeOn) kLast = uint256(reserve0).mul(reserve1);\n', '        emit Burn(msg.sender, amount0, amount1, to);\n', '    }\n', '\n', '    // this low-level function should be called from a contract which performs important safety checks\n', '    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external lock {\n', '        require(msg.sender == router, "BtswapPairToken: FORBIDDEN");\n', '        require(amount0Out > 0 || amount1Out > 0, "BtswapPairToken: INSUFFICIENT_OUTPUT_AMOUNT");\n', '        // gas savings\n', '        (uint112 _reserve0, uint112 _reserve1,) = getReserves();\n', '        require(amount0Out < _reserve0 && amount1Out < _reserve1, "BtswapPairToken: INSUFFICIENT_LIQUIDITY");\n', '\n', '        uint256 balance0;\n', '        uint256 balance1;\n', '        {// scope for _token{0,1}, avoids stack too deep errors\n', '            address _token0 = token0;\n', '            address _token1 = token1;\n', '            require(to != _token0 && to != _token1, "BtswapPairToken: INVALID_TO");\n', '            // optimistically transfer tokens\n', '            if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out);\n', '            // optimistically transfer tokens\n', '            if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out);\n', '            if (data.length > 0) IBtswapCallee(to).bitswapCall(msg.sender, amount0Out, amount1Out, data);\n', '            balance0 = IERC20(_token0).balanceOf(address(this));\n', '            balance1 = IERC20(_token1).balanceOf(address(this));\n', '        }\n', '        uint256 amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;\n', '        uint256 amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;\n', '        require(amount0In > 0 || amount1In > 0, "BtswapPairToken: INSUFFICIENT_INPUT_AMOUNT");\n', '        {// scope for reserve{0,1}Adjusted, avoids stack too deep errors\n', '            uint256 balance0Adjusted = balance0.mul(1e4).sub(amount0In.mul(IBtswapFactory(factory).feeRateNumerator()));\n', '            uint256 balance1Adjusted = balance1.mul(1e4).sub(amount1In.mul(IBtswapFactory(factory).feeRateNumerator()));\n', '            require(balance0Adjusted.mul(balance1Adjusted) >= uint256(_reserve0).mul(_reserve1).mul(1e8), "BtswapPairToken: K");\n', '        }\n', '\n', '        _update(balance0, balance1, _reserve0, _reserve1);\n', '        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);\n', '    }\n', '\n', '    // force balances to match reserves\n', '    function skim(address to) external lock {\n', '        // gas savings\n', '        address _token0 = token0;\n', '        // gas savings\n', '        address _token1 = token1;\n', '        _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));\n', '        _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));\n', '    }\n', '\n', '    // force reserves to match balances\n', '    function sync() external lock {\n', '        _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);\n', '    }\n', '\n', '    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {\n', '        _reserve0 = reserve0;\n', '        _reserve1 = reserve1;\n', '        _blockTimestampLast = blockTimestampLast;\n', '    }\n', '\n', '    function _safeTransfer(address token, address to, uint256 value) private {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "BtswapPairToken: TRANSFER_FAILED");\n', '    }\n', '\n', '    function price(address token) public view returns (uint256) {\n', '        if ((token0 != token && token1 != token) || 0 == reserve0 || 0 == reserve1) {\n', '            return 0;\n', '        }\n', '\n', '        if (token0 == token) {\n', '            return SafeMath.wad().mul(reserve1).div(reserve0);\n', '        } else {\n', '            return SafeMath.wad().mul(reserve0).div(reserve1);\n', '        }\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        super.transfer(to, value);\n', '        return IBtswapRouter02(router).onTransfer(msg.sender, to);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        super.transferFrom(from, to, value);\n', '        if (msg.sender == router) {\n', '            return true;\n', '        }\n', '        return IBtswapRouter02(router).onTransfer(from, to);\n', '    }\n', '\n', '\n', '    modifier lock() {\n', '        require(unlocked == 1, "BtswapPairToken: LOCKED");\n', '        unlocked = 0;\n', '        _;\n', '        unlocked = 1;\n', '    }\n', '\n', '\n', '    event Mint(address indexed sender, uint256 amount0, uint256 amount1);\n', '    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);\n', '    event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '}']
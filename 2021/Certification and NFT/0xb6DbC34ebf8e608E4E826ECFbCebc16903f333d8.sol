['pragma solidity 0.5.16;\n', '\n', 'import "@openzeppelin/contracts/ownership/Ownable.sol";\n', 'import "@openzeppelin/contracts/math/SafeMath.sol";\n', "import '../../public/contracts/base/interface/uniswap/IUniswapV2Factory.sol';\n", "import '../../public/contracts/base/interface/uniswap/IUniswapV2Pair.sol';\n", '\n', '\n', '\n', '// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))\n', 'library FixedPoint {\n', '    // range: [0, 2**112 - 1]\n', '    // resolution: 1 / 2**112\n', '    struct uq112x112 {\n', '        uint224 _x;\n', '    }\n', '\n', '    // range: [0, 2**144 - 1]\n', '    // resolution: 1 / 2**112\n', '    struct uq144x112 {\n', '        uint _x;\n', '    }\n', '\n', '    uint8 private constant RESOLUTION = 112;\n', '\n', '    // encode a uint112 as a UQ112x112\n', '    function encode(uint112 x) internal pure returns (uq112x112 memory) {\n', '        return uq112x112(uint224(x) << RESOLUTION);\n', '    }\n', '\n', '    // encodes a uint144 as a UQ144x112\n', '    function encode144(uint144 x) internal pure returns (uq144x112 memory) {\n', '        return uq144x112(uint256(x) << RESOLUTION);\n', '    }\n', '\n', '    // divide a UQ112x112 by a uint112, returning a UQ112x112\n', '    function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {\n', "        require(x != 0, 'FixedPoint: DIV_BY_ZERO');\n", '        return uq112x112(self._x / uint224(x));\n', '    }\n', '\n', '    // multiply a UQ112x112 by a uint, returning a UQ144x112\n', '    // reverts on overflow\n', '    function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {\n', '        uint z;\n', '        require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");\n', '        return uq144x112(z);\n', '    }\n', '\n', '    // returns a UQ112x112 which represents the ratio of the numerator to the denominator\n', '    // equivalent to encode(numerator).div(denominator)\n', '    function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {\n', '        require(denominator > 0, "FixedPoint: DIV_BY_ZERO");\n', '        return uq112x112((uint224(numerator) << RESOLUTION) / denominator);\n', '    }\n', '\n', '    // decode a UQ112x112 into a uint112 by truncating after the radix point\n', '    function decode(uq112x112 memory self) internal pure returns (uint112) {\n', '        return uint112(self._x >> RESOLUTION);\n', '    }\n', '\n', '    // decode a UQ144x112 into a uint144 by truncating after the radix point\n', '    function decode144(uq144x112 memory self) internal pure returns (uint144) {\n', '        return uint144(self._x >> RESOLUTION);\n', '    }\n', '}\n', '\n', '// library with helper methods for oracles that are concerned with computing average prices\n', 'library UniswapV2OracleLibrary {\n', '    using FixedPoint for *;\n', '\n', '    // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]\n', '    function currentBlockTimestamp() internal view returns (uint32) {\n', '        return uint32(block.timestamp % 2 ** 32);\n', '    }\n', '\n', '    // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.\n', '    function currentCumulativePrices(\n', '        address pair\n', '    ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {\n', '        blockTimestamp = currentBlockTimestamp();\n', '        price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();\n', '        price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();\n', '\n', '        // if time has elapsed since the last update on the pair, mock the accumulated price values\n', '        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();\n', '        if (blockTimestampLast != blockTimestamp) {\n', '            // subtraction overflow is desired\n', '            uint32 timeElapsed = blockTimestamp - blockTimestampLast;\n', '            // addition overflow is desired\n', '            // counterfactual\n', '            price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;\n', '            // counterfactual\n', '            price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;\n', '        }\n', '    }\n', '}\n', '\n', 'library UniswapV2Library {\n', '    using SafeMath for uint;\n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash\n", '            ))));\n', '    }\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '\n', '    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint amountInWithFee = amountIn.mul(997);\n', '        uint numerator = amountInWithFee.mul(reserveOut);\n', '        uint denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // performs chained getAmountOut calculations on any number of pairs\n', '    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[0] = amountIn;\n', '        for (uint i; i < path.length - 1; i++) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);\n', '            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '\n', '    // performs chained getAmountIn calculations on any number of pairs\n', '    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[amounts.length - 1] = amountOut;\n', '        for (uint i = path.length - 1; i > 0; i--) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);\n', '            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '}\n', '\n', '// fixed window oracle that recomputes the average price for the entire period once every period\n', '// note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period\n', 'contract FarmOracle is Ownable {\n', '    using FixedPoint for *;\n', '\n', '    uint public PERIOD = 300; // 5mins in the beginning and set to 3hrs\n', '\n', '    IUniswapV2Pair public constant pair = IUniswapV2Pair(0x56feAccb7f750B997B36A68625C7C596F0B41A58);\n', '    address public constant token0 = 0xa0246c9032bC3A600820415aE600c6388619A14D; // FARM\n', '    address public constant token1 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH\n', '\n', '    uint    public price0CumulativeLast;\n', '    uint    public price1CumulativeLast;\n', '    uint32  public blockTimestampLast;\n', '    FixedPoint.uq112x112 public price0Average;\n', '    FixedPoint.uq112x112 public price1Average;\n', '\n', '    bool oracleActive = true;\n', '\n', '    constructor() public {\n', '        require(token0 == pair.token0(), "token0 constant has to match pair\'s token0");\n', '        require(token1 == pair.token1(), "token1 constant has to match pair\'s token1");\n', '\n', '        price0CumulativeLast = pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)\n', '        price1CumulativeLast = pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)\n', '        uint112 reserve0;\n', '        uint112 reserve1;\n', '        (reserve0, reserve1, blockTimestampLast) = pair.getReserves();\n', "        require(reserve0 != 0 && reserve1 != 0, 'NO_RESERVES'); // ensure that there's liquidity in the pair\n", '    }\n', '\n', '    function setPeriod(uint256 _period) public onlyOwner {\n', '      PERIOD = _period;\n', '    }\n', '\n', '    function update() external {\n', '        (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =\n', '            UniswapV2OracleLibrary.currentCumulativePrices(address(pair));\n', '        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired\n', '\n', '        // ensure that at least one full period has passed since the last update\n', "        require(timeElapsed >= PERIOD, 'PERIOD_NOT_ELAPSED');\n", '\n', '        // overflow is desired, casting never truncates\n', '        // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed\n', '        price0Average = FixedPoint.uq112x112(uint224((price0Cumulative - price0CumulativeLast) / timeElapsed));\n', '        price1Average = FixedPoint.uq112x112(uint224((price1Cumulative - price1CumulativeLast) / timeElapsed));\n', '\n', '        price0CumulativeLast = price0Cumulative;\n', '        price1CumulativeLast = price1Cumulative;\n', '        blockTimestampLast = blockTimestamp;\n', '    }\n', '\n', '    function updateRequire() public view returns (bool) {\n', '      (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =\n', '        UniswapV2OracleLibrary.currentCumulativePrices(address(pair));\n', '      uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired\n', '      return (timeElapsed >= PERIOD);\n', '    }\n', '\n', '    // note this will always return 0 before update has been called successfully for the first time.\n', '    function consult(address token, uint amountIn) external view returns (uint amountOut) {\n', '      require(oracleActive, "Oracle has been deactivated");\n', '\n', '        if (token == token0) {\n', '            amountOut = price0Average.mul(amountIn).decode144();\n', '        } else {\n', "            require(token == token1, 'INVALID_TOKEN');\n", '            amountOut = price1Average.mul(amountIn).decode144();\n', '        }\n', '    }\n', '\n', '    function setOracleActive(bool _active) public onlyOwner {\n', '      oracleActive = _active;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'import "../GSN/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Factory {\n', '  event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '  function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '  function allPairs(uint) external view returns (address pair);\n', '  function allPairsLength() external view returns (uint);\n', '\n', '  function feeTo() external view returns (address);\n', '  function feeToSetter() external view returns (address);\n', '\n', '  function createPair(address tokenA, address tokenB) external returns (address pair);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2020-05-05\n', '*/\n', '\n', '// File: contracts/interfaces/IUniswapV2Pair.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}']
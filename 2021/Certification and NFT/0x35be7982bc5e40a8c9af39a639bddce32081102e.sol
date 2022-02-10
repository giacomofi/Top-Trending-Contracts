['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-31\n', '*/\n', '\n', '// Sources flattened with hardhat v2.1.2 https://hardhat.org\n', '\n', '// File @uniswap/v2-core/contracts/interfaces/[email\xa0protected]\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '}\n', '\n', '\n', '// File @uniswap/v2-core/contracts/interfaces/[email\xa0protected]\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '\n', '// File @uniswap/lib/contracts/libraries/[email\xa0protected]\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '\n', 'pragma solidity >=0.4.0;\n', '\n', '// computes square roots using the babylonian method\n', '// https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method\n', 'library Babylonian {\n', '    function sqrt(uint y) internal pure returns (uint z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '        // else z = 0\n', '    }\n', '}\n', '\n', '\n', '// File @uniswap/lib/contracts/libraries/[email\xa0protected]\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '\n', 'pragma solidity >=0.4.0;\n', '\n', '// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))\n', 'library FixedPoint {\n', '    // range: [0, 2**112 - 1]\n', '    // resolution: 1 / 2**112\n', '    struct uq112x112 {\n', '        uint224 _x;\n', '    }\n', '\n', '    // range: [0, 2**144 - 1]\n', '    // resolution: 1 / 2**112\n', '    struct uq144x112 {\n', '        uint _x;\n', '    }\n', '\n', '    uint8 private constant RESOLUTION = 112;\n', '    uint private constant Q112 = uint(1) << RESOLUTION;\n', '    uint private constant Q224 = Q112 << RESOLUTION;\n', '\n', '    // encode a uint112 as a UQ112x112\n', '    function encode(uint112 x) internal pure returns (uq112x112 memory) {\n', '        return uq112x112(uint224(x) << RESOLUTION);\n', '    }\n', '\n', '    // encodes a uint144 as a UQ144x112\n', '    function encode144(uint144 x) internal pure returns (uq144x112 memory) {\n', '        return uq144x112(uint256(x) << RESOLUTION);\n', '    }\n', '\n', '    // divide a UQ112x112 by a uint112, returning a UQ112x112\n', '    function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {\n', "        require(x != 0, 'FixedPoint: DIV_BY_ZERO');\n", '        return uq112x112(self._x / uint224(x));\n', '    }\n', '\n', '    // multiply a UQ112x112 by a uint, returning a UQ144x112\n', '    // reverts on overflow\n', '    function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {\n', '        uint z;\n', '        require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");\n', '        return uq144x112(z);\n', '    }\n', '\n', '    // returns a UQ112x112 which represents the ratio of the numerator to the denominator\n', '    // equivalent to encode(numerator).div(denominator)\n', '    function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {\n', '        require(denominator > 0, "FixedPoint: DIV_BY_ZERO");\n', '        return uq112x112((uint224(numerator) << RESOLUTION) / denominator);\n', '    }\n', '\n', '    // decode a UQ112x112 into a uint112 by truncating after the radix point\n', '    function decode(uq112x112 memory self) internal pure returns (uint112) {\n', '        return uint112(self._x >> RESOLUTION);\n', '    }\n', '\n', '    // decode a UQ144x112 into a uint144 by truncating after the radix point\n', '    function decode144(uq144x112 memory self) internal pure returns (uint144) {\n', '        return uint144(self._x >> RESOLUTION);\n', '    }\n', '\n', '    // take the reciprocal of a UQ112x112\n', '    function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {\n', "        require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');\n", '        return uq112x112(uint224(Q224 / self._x));\n', '    }\n', '\n', '    // square root of a UQ112x112\n', '    function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {\n', '        return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));\n', '    }\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/utils/[email\xa0protected]\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/access/[email\xa0protected]\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '// File contracts/external/UniswapV2OracleLibrary.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', '\n', '// library with helper methods for oracles that are concerned with computing average prices\n', 'library UniswapV2OracleLibrary {\n', '    using FixedPoint for *;\n', '\n', '    // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]\n', '    function currentBlockTimestamp() internal view returns (uint32) {\n', '        return uint32(block.timestamp % 2**32);\n', '    }\n', '\n', '    // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.\n', '    function currentCumulativePrices(address pair)\n', '        internal\n', '        view\n', '        returns (\n', '            uint256 price0Cumulative,\n', '            uint256 price1Cumulative,\n', '            uint32 blockTimestamp\n', '        )\n', '    {\n', '        blockTimestamp = currentBlockTimestamp();\n', '        price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();\n', '        price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();\n', '\n', '        // if time has elapsed since the last update on the pair, mock the accumulated price values\n', '        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) =\n', '            IUniswapV2Pair(pair).getReserves();\n', '        if (blockTimestampLast != blockTimestamp) {\n', '            // subtraction overflow is desired\n', '            uint32 timeElapsed = blockTimestamp - blockTimestampLast;\n', '            // addition overflow is desired\n', '            // counterfactual\n', '            price0Cumulative +=\n', '                uint256(FixedPoint.fraction(reserve1, reserve0)._x) *\n', '                timeElapsed;\n', '            // counterfactual\n', '            price1Cumulative +=\n', '                uint256(FixedPoint.fraction(reserve0, reserve1)._x) *\n', '                timeElapsed;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/math/[email\xa0protected]\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// File contracts/external/UniswapV2Library.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', '\n', 'library UniswapV2Library {\n', '    using SafeMath for uint256;\n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB)\n', '        internal\n', '        pure\n', '        returns (address token0, address token1)\n', '    {\n', '        require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");\n', '        (token0, token1) = tokenA < tokenB\n', '            ? (tokenA, tokenB)\n', '            : (tokenB, tokenA);\n', '        require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");\n', '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(\n', '        address factory,\n', '        address tokenA,\n', '        address tokenB\n', '    ) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(\n', '            uint256(\n', '                keccak256(\n', '                    abi.encodePacked(\n', '                        hex"ff",\n', '                        factory,\n', '                        keccak256(abi.encodePacked(token0, token1)),\n', '                        hex"96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f" // init code hash\n', '                    )\n', '                )\n', '            )\n', '        );\n', '    }\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(\n', '        address factory,\n', '        address tokenA,\n', '        address tokenB\n', '    ) internal view returns (uint256 reserveA, uint256 reserveB) {\n', '        (address token0, ) = sortTokens(tokenA, tokenB);\n', '        (uint256 reserve0, uint256 reserve1, ) =\n', '            IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0\n', '            ? (reserve0, reserve1)\n', '            : (reserve1, reserve0);\n', '    }\n', '\n', '    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset\n', '    function quote(\n', '        uint256 amountA,\n', '        uint256 reserveA,\n', '        uint256 reserveB\n', '    ) internal pure returns (uint256 amountB) {\n', '        require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");\n', '        require(\n', '            reserveA > 0 && reserveB > 0,\n', '            "UniswapV2Library: INSUFFICIENT_LIQUIDITY"\n', '        );\n', '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(\n', '        uint256 amountIn,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) internal pure returns (uint256 amountOut) {\n', '        require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");\n', '        require(\n', '            reserveIn > 0 && reserveOut > 0,\n', '            "UniswapV2Library: INSUFFICIENT_LIQUIDITY"\n', '        );\n', '        uint256 amountInWithFee = amountIn.mul(997);\n', '        uint256 numerator = amountInWithFee.mul(reserveOut);\n', '        uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(\n', '        uint256 amountOut,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) internal pure returns (uint256 amountIn) {\n', '        require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");\n', '        require(\n', '            reserveIn > 0 && reserveOut > 0,\n', '            "UniswapV2Library: INSUFFICIENT_LIQUIDITY"\n', '        );\n', '        uint256 numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint256 denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // performs chained getAmountOut calculations on any number of pairs\n', '    function getAmountsOut(\n', '        address factory,\n', '        uint256 amountIn,\n', '        address[] memory path\n', '    ) internal view returns (uint256[] memory amounts) {\n', '        require(path.length >= 2, "UniswapV2Library: INVALID_PATH");\n', '        amounts = new uint256[](path.length);\n', '        amounts[0] = amountIn;\n', '        for (uint256 i; i < path.length - 1; i++) {\n', '            (uint256 reserveIn, uint256 reserveOut) =\n', '                getReserves(factory, path[i], path[i + 1]);\n', '            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '\n', '    // performs chained getAmountIn calculations on any number of pairs\n', '    function getAmountsIn(\n', '        address factory,\n', '        uint256 amountOut,\n', '        address[] memory path\n', '    ) internal view returns (uint256[] memory amounts) {\n', '        require(path.length >= 2, "UniswapV2Library: INVALID_PATH");\n', '        amounts = new uint256[](path.length);\n', '        amounts[amounts.length - 1] = amountOut;\n', '        for (uint256 i = path.length - 1; i > 0; i--) {\n', '            (uint256 reserveIn, uint256 reserveOut) =\n', '                getReserves(factory, path[i - 1], path[i]);\n', '            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File contracts/oracle/IOracle.sol\n', '\n', '/*\n', '    Copyright 2020 Cook Finance Devs, based on the works of the Cook Finance Squad\n', '\n', '    Licensed under the Apache License, Version 2.0 (the "License");\n', '    you may not use this file except in compliance with the License.\n', '    You may obtain a copy of the License at\n', '\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', '\n', '    Unless required by applicable law or agreed to in writing, software\n', '    distributed under the License is distributed on an "AS IS" BASIS,\n', '    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '    See the License for the specific language governing permissions and\n', '    limitations under the License.\n', '*/\n', '\n', 'pragma solidity ^0.6.2;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'abstract contract IOracle {\n', '    function update() external virtual returns (uint256);\n', '\n', '    function pairAddress() external view virtual returns (address);\n', '}\n', '\n', '\n', '// File contracts/oracle/Oracle.sol\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '\n', '\n', '\n', '\n', '\n', '// fixed window oracle that recomputes the average price for the entire period once every period\n', '// note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period\n', 'contract Oracle is IOracle, Ownable {\n', '    using FixedPoint for *;\n', '\n', '    uint256 public constant PERIOD = 1 seconds;\n', '\n', '    IUniswapV2Pair public pair;\n', '    address public override pairAddress;\n', '    address public token0;\n', '    address public token1;\n', '    address private _cookAddress;\n', '\n', '    uint256 public price0CumulativeLast;\n', '    uint256 public price1CumulativeLast;\n', '    uint32 public blockTimestampLast;\n', '    FixedPoint.uq112x112 public price0Average;\n', '    FixedPoint.uq112x112 public price1Average;\n', '\n', '    uint256 public latestPrice0;\n', '    uint256 public latestPrice1;\n', '\n', '    constructor(address _pairAddress, address cookAddress) public {\n', '        require(cookAddress != address(0), "Cook address can not be empty");\n', '        require(\n', '            _pairAddress != address(0),\n', '            "Cook pair address can not be empty"\n', '        );\n', '\n', '        pair = IUniswapV2Pair(_pairAddress);\n', '        pairAddress = _pairAddress;\n', '        _cookAddress = cookAddress;\n', '        token0 = IUniswapV2Pair(_pairAddress).token0();\n', '        token1 = IUniswapV2Pair(_pairAddress).token1();\n', '        price0CumulativeLast = IUniswapV2Pair(_pairAddress)\n', '            .price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)\n', '        price1CumulativeLast = IUniswapV2Pair(_pairAddress)\n', '            .price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)\n', '        uint112 reserve0;\n', '        uint112 reserve1;\n', '        (reserve0, reserve1, blockTimestampLast) = IUniswapV2Pair(_pairAddress)\n', '            .getReserves();\n', '        require(reserve0 != 0 && reserve1 != 0, "Oracle: NO_RESERVES"); // ensure that there\'s liquidity in the pair\n', '    }\n', '\n', '    function update() external override returns (uint256 latestP) {\n', '        (\n', '            uint256 price0Cumulative,\n', '            uint256 price1Cumulative,\n', '            uint32 blockTimestamp\n', '        ) = UniswapV2OracleLibrary.currentCumulativePrices(address(pair));\n', '        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired\n', '\n', '        // ensure that at least one full period has passed since the last update\n', '        require(timeElapsed >= PERIOD, "Oracle: PERIOD_NOT_ELAPSED");\n', '\n', '        // overflow is desired, casting never truncates\n', '        // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed\n', '        price0Average = FixedPoint.uq112x112(\n', '            uint224((price0Cumulative - price0CumulativeLast) / timeElapsed)\n', '        );\n', '        price1Average = FixedPoint.uq112x112(\n', '            uint224((price1Cumulative - price1CumulativeLast) / timeElapsed)\n', '        );\n', '\n', '        price0CumulativeLast = price0Cumulative;\n', '        price1CumulativeLast = price1Cumulative;\n', '        blockTimestampLast = blockTimestamp;\n', '        latestPrice0 = price0Average.mul(10**18).decode144();\n', '        latestPrice1 = price1Average.mul(10**18).decode144();\n', '\n', '        if (pair.token0() == _cookAddress) {\n', '            return latestPrice0;\n', '        } else {\n', '            return latestPrice1;\n', '        }\n', '    }\n', '\n', '    // note this will always return 0 before update has been called successfully for the first time.\n', '    function consult(address token, uint256 amountIn)\n', '        external\n', '        view\n', '        returns (uint256 amountOut)\n', '    {\n', '        if (token == token0) {\n', '            amountOut = price0Average.mul(amountIn).decode144();\n', '        } else {\n', '            require(token == token1, "Oracle: INVALID_TOKEN");\n', '            amountOut = price1Average.mul(amountIn).decode144();\n', '        }\n', '    }\n', '}']
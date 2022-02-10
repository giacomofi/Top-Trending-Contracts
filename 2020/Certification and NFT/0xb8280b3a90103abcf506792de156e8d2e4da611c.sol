['// File: contracts/interfaces/IHiposwapV2Factory.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.6.6;\n', '\n', 'abstract contract IHiposwapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view virtual returns (address);\n', '    function uniswapFactory() external view virtual returns (address);\n', '    function WETH() external pure virtual returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view virtual returns (address pair);\n', '    function allPairs(uint) external view virtual returns (address pair);\n', '    function allPairsLength() external view virtual returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external virtual returns (address pair);\n', '\n', '    function setFeeTo(address) external virtual;\n', '    function setUniswapFactory(address _factory) external virtual;\n', '    \n', '    function getContribution(address tokenA, address tokenB, address tokenMain, address mkAddress) external view virtual returns (address pairAddress, uint contribution);\n', '    \n', '    function getMaxMakerAmount(address tokenA, address tokenB) external view virtual returns (uint amountA, uint amountB);\n', '    function getMaxMakerAmountETH(address token) external view virtual returns (uint amount, uint amountETH);\n', '    function addMaker(address tokenA, address tokenB, uint amountA, uint amountB, address to, uint deadline) external virtual returns (address token, uint amount);\n', '    function addMakerETH(address token, uint amountToken, address to, uint deadline) external payable virtual returns (address _token, uint amount);\n', '    function removeMaker(address tokenA, address tokenB, uint amountA, uint amountB, address to, uint deadline) external virtual returns (uint amount0, uint amount1);\n', '    function removeMakerETH(address token, uint amountToken, uint amountETH, address to, uint deadline) external virtual returns (uint _amountToken, uint _amountETH);\n', '    function removeMakerETHSupportingFeeOnTransferTokens(address token, uint amountToken, uint amountETH, address to, uint deadline) external virtual returns (uint _amountETH);\n', '    \n', '    function collectFees(address tokenA, address tokenB) external virtual;\n', '    function collectFees(address pair) external virtual;\n', '    function setFeePercents(address tokenA, address tokenB, uint _feeAdminPercent, uint _feePercent, uint _totalPercent) external virtual;\n', '    function setFeePercents(address pair, uint _feeAdminPercent, uint _feePercent, uint _totalPercent) external virtual;\n', '}\n', '\n', '// File: contracts/interfaces/IWETH.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function withdraw(uint) external;\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/GSN/Context.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/Ownable.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '}\n', '\n', '// File: contracts/interfaces/IHiposwapV2Pair.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IHiposwapV2Pair {\n', '    \n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint reserve0, uint reserve1);\n', '    event _Maker(address indexed sender, address token, uint amount, uint time);\n', '\n', '    \n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function currentPoolId0() external view returns (uint);\n', '    function currentPoolId1() external view returns (uint);\n', '    function getMakerPool0(uint poolId) external view returns (uint _balance, uint _swapOut, uint _swapIn);\n', '    function getMakerPool1(uint poolId) external view returns (uint _balance, uint _swapOut, uint _swapIn);\n', '    function getReserves() external view returns (uint reserve0, uint reserve1);\n', '    function getBalance() external view returns (uint _balance0, uint _balance1);\n', '    function getMaker(address mkAddress) external view returns (uint,address,uint,uint);\n', '    function getFees() external view returns (uint _fee0, uint _fee1);\n', '    function getFeeAdmins() external view returns (uint _feeAdmin0, uint _feeAdmin1);\n', '    function getAvgTimes() external view returns (uint _avgTime0, uint _avgTime1);\n', '    function transferFeeAdmin(address to) external;\n', '    function getFeePercents() external view returns (uint _feeAdminPercent, uint _feePercent, uint _totalPercent);\n', '    function setFeePercents(uint _feeAdminPercent, uint _feePercent, uint _totalPercent) external;\n', '    function getRemainPercent() external view returns (uint);\n', '    function getTotalPercent() external view returns (uint);\n', '    \n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function order(address to) external returns (address token, uint amount);\n', '    function retrieve(uint amount0, uint amount1, address sender, address to) external returns (uint, uint);\n', '    function getAmountA(address to, uint amountB) external view returns(uint amountA, uint _amountB, uint rewardsB, uint remainA);\n', '    function getAmountB(address to, uint amountA) external view returns(uint _amountA, uint amountB, uint rewardsB, uint remainA);\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// File: contracts/libraries/SafeMath.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.6.6;\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', '// File: contracts/libraries/HiposwapV2Library.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', '\n', '\n', '\n', '\n', '\n', 'library HiposwapV2Library {\n', '    using SafeMath for uint;\n', '    \n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'HiposwapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'HiposwapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {\n', '        pair = IUniswapV2Factory(factory).getPair(tokenA, tokenB);\n', '    }\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        \n', '        address pair = pairFor(factory, tokenA, tokenB);\n', '        if (pair == address(0)) {\n', '            return (0, 0);\n', '        }\n', '        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pair).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '    \n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function makerPairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'2603bd3b15dbef4d28f9036d8301021d5edc3ae2f073f054721f61b9bf1fa5f3' // init code hash\n", '            ))));\n', '    }\n', '    \n', '    function getMakerReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1) = IHiposwapV2Pair(makerPairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '\n', '    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'HiposwapV2Library: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'HiposwapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '    \n', '    function getMakerAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint makerReserve, uint remainPercent, uint totalPercent) internal pure returns (uint amountOut) {\n', "        require(amountIn >= 10, 'HiposwapV2Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'HiposwapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        amountOut = getAmountOut(amountIn / 10, reserveIn, reserveOut, remainPercent, totalPercent).mul(10);\n', "        require(amountOut <= makerReserve, 'HiposwapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", '    }\n', '    \n', '    // function getMakerAmountsOut(address hipoFactory, address uniFactory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {\n', "    //     require(path.length >= 2, 'HiposwapV2Library: INVALID_PATH');\n", '    //     amounts = new uint[](path.length);\n', '    //     amounts[0] = amountIn;\n', '    //     for (uint i; i < path.length - 1; i++) {\n', '    //         (uint reserveIn, uint reserveOut) = getReserves(uniFactory, path[i], path[i + 1]);\n', '    //         (, uint makerReserveOut) = getMakerReserves(hipoFactory, path[i], path[i + 1]);\n', '    //         amounts[i + 1] = getMakerAmountOut(amounts[i], reserveIn, reserveOut, makerReserveOut);\n', '    //     }\n', '    // }\n', '    \n', '    function getMakerAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint makerReserve, uint remainPercent, uint totalPercent) internal pure returns (uint amountIn) {\n', "        require(amountOut >= 10 && amountOut <= makerReserve, 'HiposwapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'HiposwapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        amountIn = getAmountIn(amountOut / 10, reserveIn, reserveOut, remainPercent, totalPercent).sub(1).mul(10).add(1);\n', '    }\n', '    \n', '    // function getMakerAmountsIn(address hipoFactory, address uniFactory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {\n', "    //     require(path.length >= 2, 'HiposwapV2Library: INVALID_PATH');\n", '    //     amounts = new uint[](path.length);\n', '    //     amounts[amounts.length - 1] = amountOut;\n', '    //     for (uint i = path.length - 1; i > 0; i--) {\n', '    //         (uint reserveIn, uint reserveOut) = getReserves(uniFactory, path[i - 1], path[i]);\n', '    //         (, uint makerReserveOut) = getMakerReserves(hipoFactory, path[i - 1], path[i]);\n', '    //         amounts[i - 1] = getMakerAmountIn(amounts[i], reserveIn, reserveOut, makerReserveOut);\n', '    //     }\n', '    // }\n', '\n', '    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint remainPercent, uint totalPercent) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'HiposwapV2Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'HiposwapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint amountInWithFee = amountIn.mul(remainPercent);\n', '        uint numerator = amountInWithFee.mul(reserveOut);\n', '        uint denominator = reserveIn.mul(totalPercent).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint remainPercent, uint totalPercent) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'HiposwapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'HiposwapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut).mul(totalPercent);\n', '        uint denominator = reserveOut.sub(amountOut).mul(remainPercent);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // performs chained getAmountOut calculations on any number of pairs\n', '    // function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {\n', "    //     require(path.length >= 2, 'HiposwapV2Library: INVALID_PATH');\n", '    //     amounts = new uint[](path.length);\n', '    //     amounts[0] = amountIn;\n', '    //     for (uint i; i < path.length - 1; i++) {\n', '    //         (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);\n', '    //         amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);\n', '    //     }\n', '    // }\n', '\n', '    // performs chained getAmountIn calculations on any number of pairs\n', '    // function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {\n', "    //     require(path.length >= 2, 'HiposwapV2Library: INVALID_PATH');\n", '    //     amounts = new uint[](path.length);\n', '    //     amounts[amounts.length - 1] = amountOut;\n', '    //     for (uint i = path.length - 1; i > 0; i--) {\n', '    //         (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);\n', '    //         amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);\n', '    //     }\n', '    // }\n', '}\n', '\n', '// File: contracts/libraries/TransferHelper.sol\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '\n', 'pragma solidity >=0.6.0;\n', '\n', '// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library TransferHelper {\n', '    function safeApprove(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');\n", '    }\n', '\n', '    function safeTransfer(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');\n", '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');\n", '    }\n', '\n', '    function safeTransferETH(address to, uint value) internal {\n', '        (bool success,) = to.call{value:value}(new bytes(0));\n', "        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');\n", '    }\n', '}\n', '\n', '// File: contracts/interfaces/IERC20.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '}\n', '\n', '// File: contracts/interfaces/IHiposwapV2Util.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.6.6;\n', '\n', 'interface IHiposwapV2Util {\n', '    function pairCreationCode() external returns (bytes memory bytecode);\n', '}\n', '\n', '// File: contracts/HiposwapV2Factory.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity =0.6.6;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', "// import './interfaces/IHiposwapV2Factory.sol';\n", "// import './HiposwapV2Pair.sol';\n", '// import "openzeppelin-solidity/contracts/access/Ownable.sol";\n', "// import './libraries/HiposwapV2Library.sol';\n", "// import './libraries/TransferHelper.sol';\n", "// import './interfaces/IWETH.sol';\n", '\n', 'contract HiposwapV2Factory is IHiposwapV2Factory, Ownable {\n', '    using SafeMath for uint;\n', '    address public override feeTo;\n', '    address public immutable override WETH;\n', '    address public util;\n', '    \n', '    address public override uniswapFactory = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);\n', '\n', '    mapping(address => mapping(address => address)) public override getPair;\n', '    address[] public override allPairs;\n', '\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    constructor(address _util, address _WETH) public {\n', '        util = _util;\n', '        WETH = _WETH;\n', '    }\n', '    \n', '    receive() external payable {\n', '        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract\n', '    }\n', '\n', '    function allPairsLength() external override view returns (uint) {\n', '        return allPairs.length;\n', '    }\n', '\n', '    function createPair(address tokenA, address tokenB) public override returns (address pair) {\n', "        require(tokenA != tokenB, 'HiposwapV2Factory: IDENTICAL_ADDRESSES');\n", '        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'HiposwapV2Factory: ZERO_ADDRESS');\n", "        require(getPair[token0][token1] == address(0), 'HiposwapV2Factory: PAIR_EXISTS'); // single check is sufficient\n", '        bytes memory bytecode = IHiposwapV2Util(util).pairCreationCode();\n', '        // bytes memory bytecode = type(HiposwapV2Pair).creationCode;\n', '        bytes32 salt = keccak256(abi.encodePacked(token0, token1));\n', '        assembly {\n', '            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)\n', '        }\n', '        IHiposwapV2Pair(pair).initialize(token0, token1);\n', '        getPair[token0][token1] = pair;\n', '        getPair[token1][token0] = pair; // populate mapping in the reverse direction\n', '        allPairs.push(pair);\n', '        emit PairCreated(token0, token1, pair, allPairs.length);\n', '    }\n', '\n', '    function setFeeTo(address _feeTo) external override onlyOwner {\n', "        //require(msg.sender == feeToSetter, 'HiposwapV2Factory: FORBIDDEN');\n", '        feeTo = _feeTo;\n', '    }\n', '    \n', '    function setUniswapFactory(address _factory) external override onlyOwner {\n', '        uniswapFactory = _factory;\n', '    }\n', '    \n', '    function getContribution(address tokenA, address tokenB, address tokenMain, address mkAddress) public view override returns (address pairAddress, uint contribution) {\n', '        require(tokenA == tokenMain || tokenB == tokenMain, "HiposwapV2Factory: INVALID_TOKEN");\n', '        (address token0, ) = HiposwapV2Library.sortTokens(tokenA, tokenB);\n', '        pairAddress = HiposwapV2Library.makerPairFor(address(this), tokenA, tokenB);\n', '        IHiposwapV2Pair pair = IHiposwapV2Pair(pairAddress);\n', '        (uint poolId, address token, uint amount, ) = pair.getMaker(mkAddress);\n', '        uint currentPoolId = token == token0 ? pair.currentPoolId0() : pair.currentPoolId1();\n', '        if (poolId == currentPoolId) {\n', '            if (token == tokenMain) {\n', '                contribution =  amount;\n', '            } else {\n', '                (uint r0, uint r1) = HiposwapV2Library.getReserves(uniswapFactory, token, tokenMain);\n', '                if (r0 > 0) {\n', '                    contribution =  amount.mul(r1) / r0;\n', '                }\n', '            }\n', '        }\n', '    }\n', '    \n', '    // MAKER\n', '    \n', '    modifier ensure(uint deadline) {\n', "        require(deadline >= block.timestamp, 'HiposwapV2Factory: EXPIRED');\n", '        _;\n', '    }\n', '    \n', '    function getMaxMakerAmount(address tokenA, address tokenB) public view override returns (uint amountA, uint amountB) {\n', '        (address token0, address token1) = HiposwapV2Library.sortTokens(tokenA, tokenB);\n', '        (uint ur0, uint ur1) = HiposwapV2Library.getReserves(uniswapFactory, token0, token1);\n', '        if (ur0 > 0 && ur1 > 0) {\n', '            uint hr0;\n', '            uint hr1;\n', '            address pair = getPair[tokenA][tokenB];\n', '            if (pair != address(0)) {\n', '                (hr0, hr1) = IHiposwapV2Pair(pair).getReserves();\n', '            }\n', '            uint a0 = hr0 < ur0 / 10 ? (ur0 / 10).sub(hr0) : 0;\n', '            uint a1 = hr1 < ur1 / 10 ? (ur1 / 10).sub(hr1) : 0;\n', '            (amountA, amountB) = tokenA == token0 ? (a0, a1) : (a1, a0);\n', '        }\n', '    }\n', '    \n', '    function getMaxMakerAmountETH(address token) external view override returns (uint amount, uint amountETH) {\n', '        return getMaxMakerAmount(token, WETH);\n', '    }\n', '    \n', '    \n', '    function _addMaker(address tokenA, address tokenB) private{\n', '        require(HiposwapV2Library.pairFor(uniswapFactory, tokenA, tokenB) != address(0), "HiposwapV2Factory: PAIR_NOT_EXISTS_IN_UNISWAP");\n', '        if (getPair[tokenA][tokenB] == address(0)) {\n', '            createPair(tokenA, tokenB);\n', '        }\n', '    }\n', '\n', '    function addMaker(address tokenA, address tokenB, uint amountA, uint amountB, address to, uint deadline) external virtual override ensure(deadline) returns (address token, uint amount) {\n', '        _addMaker(tokenA, tokenB);\n', '        require((amountA > 0 && amountB == 0) || (amountA == 0 && amountB > 0), "HiposwapV2Factory: INVALID_AMOUNT");\n', '        address pair = HiposwapV2Library.makerPairFor(address(this), tokenA, tokenB);\n', '        require(pair == getPair[tokenA][tokenB], "HiposwapV2Factory: BAD_INIT_CODE_HASH");\n', '        (address token0, address token1) = HiposwapV2Library.sortTokens(tokenA, tokenB);\n', '        (uint a0, uint a1) = token0 == tokenA ? (amountA, amountB) : (amountB, amountA);\n', '        {// avoid stack too deep\n', '        (uint ur0, uint ur1) = HiposwapV2Library.getReserves(uniswapFactory, token0, token1);\n', '        (uint hr0, uint hr1) = IHiposwapV2Pair(pair).getReserves();\n', '        if (a0 > 0) {\n', '            require(ur0 >= hr0.add(a0).mul(10), "HiposwapV2Factory: AMOUNT_TOO_BIG");\n', '        } else {\n', '            require(ur1 >= hr1.add(a1).mul(10), "HiposwapV2Factory: AMOUNT_TOO_BIG");\n', '        }\n', '        }\n', '        \n', '        if(amountA > 0)TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);\n', '        if(amountB > 0)TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);\n', '        return IHiposwapV2Pair(pair).order(to);\n', '    }\n', '    \n', '    function addMakerETH(address token, uint amountToken, address to, uint deadline) external virtual override payable ensure(deadline) returns (address _token, uint amount) {\n', '        _addMaker(token, WETH);\n', '        uint amountETH = msg.value;\n', '        require(amountToken > 0 || amountETH > 0, "HiposwapV2Factory: INVALID_AMOUNT");\n', '        address pair = HiposwapV2Library.makerPairFor(address(this), token, WETH);\n', '        if(amountToken > 0)TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);\n', '        if(amountETH > 0){\n', '            IWETH(WETH).deposit{value: amountETH}();\n', '            assert(IWETH(WETH).transfer(pair, amountETH));\n', '        }\n', '        return IHiposwapV2Pair(pair).order(to);\n', '    }\n', '    \n', '    function removeMaker(address tokenA, address tokenB, uint amountA, uint amountB, address to, uint deadline)\n', '        public virtual override ensure(deadline) returns (uint amount0, uint amount1) {\n', '        require(getPair[tokenA][tokenB] != address(0), "HiposwapV2Factory: PAIR_NOT_EXISTS");\n', '        require(amountA > 0 || amountB > 0, "HiposwapV2Factory: INVALID_AMOUNT");\n', '        address pair = HiposwapV2Library.makerPairFor(address(this), tokenA, tokenB);\n', '        (address token0, ) = HiposwapV2Library.sortTokens(tokenA, tokenB);\n', '        (amount0, amount1) = tokenA == token0 ? (amountA, amountB) : (amountB, amountA);\n', '        (amount0, amount1) = IHiposwapV2Pair(pair).retrieve(amount0, amount1, msg.sender, to);\n', '        // (bool success, bytes memory returnData) =  pair.delegatecall(abi.encodeWithSelector(IHiposwapV2Pair(pair).retrieve.selector, amount0, amount1, to));\n', '        // assert(success);\n', '        // (amount0, amount1) = abi.decode(returnData, (uint, uint));\n', '        return tokenA == token0 ? (amount0, amount1) : (amount1, amount0);\n', '    }\n', '    \n', '    function removeMakerETH(address token, uint amountToken, uint amountETH, address to, uint deadline)\n', '        external virtual override ensure(deadline) returns (uint _amountToken, uint _amountETH) {\n', '        (_amountToken, _amountETH) = removeMaker(token, WETH, amountToken, amountETH, address(this), deadline);\n', '        if(_amountToken > 0)TransferHelper.safeTransfer(token, to, _amountToken);\n', '        if(_amountETH > 0){\n', '            IWETH(WETH).withdraw(_amountETH);\n', '            TransferHelper.safeTransferETH(to, _amountETH);\n', '        }\n', '    }\n', '\n', '    function removeMakerETHSupportingFeeOnTransferTokens(address token, uint amountToken, uint amountETH, address to, uint deadline)\n', '        external virtual override ensure(deadline) returns (uint _amountETH) {\n', '        (, _amountETH) = removeMaker(token, WETH, amountToken, amountETH, address(this), deadline);\n', '        uint _amountToken = IERC20(token).balanceOf(address(this));\n', '        if(_amountToken > 0){\n', '            TransferHelper.safeTransfer(token, to, _amountToken);\n', '        }\n', '        if(_amountETH > 0){\n', '            IWETH(WETH).withdraw(_amountETH);\n', '            TransferHelper.safeTransferETH(to, _amountETH);\n', '        }\n', '    }\n', '    \n', '    function collectFees(address tokenA, address tokenB) external override onlyOwner {\n', "        require(feeTo != address(0), 'HiposwapV2Factory: ZERO_ADDRESS');\n", '        address pair = getPair[tokenA][tokenB];\n', '        collectFees(pair);\n', '    }\n', '    \n', '    function collectFees(address pair) public override onlyOwner {\n', "        require(pair != address(0), 'HiposwapV2Factory: PAIR_NOT_EXISTS');\n", '        IHiposwapV2Pair(pair).transferFeeAdmin(feeTo);\n', '    }\n', '    \n', '    function setFeePercents(address tokenA, address tokenB, uint _feeAdminPercent, uint _feePercent, uint _totalPercent) external override onlyOwner {\n', '        address pair = getPair[tokenA][tokenB];\n', '        setFeePercents(pair, _feeAdminPercent, _feePercent, _totalPercent);\n', '    }\n', '    \n', '    function setFeePercents(address pair, uint _feeAdminPercent, uint _feePercent, uint _totalPercent) public override onlyOwner {\n', "        require(pair != address(0), 'HiposwapV2Factory: PAIR_NOT_EXISTS');\n", '        IHiposwapV2Pair(pair).setFeePercents(_feeAdminPercent, _feePercent, _totalPercent);\n', '    }\n', '}']
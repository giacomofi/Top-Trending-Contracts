['// File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be aplied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * > Note: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity-2.3.0/contracts/utils/ReentrancyGuard.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module that helps prevent reentrant calls to a function.\n', ' *\n', ' * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier\n', ' * available, which can be aplied to functions to make sure there are no nested\n', ' * (reentrant) calls to them.\n', ' *\n', ' * Note that because there is a single `nonReentrant` guard, functions marked as\n', ' * `nonReentrant` may not call one another. This can be worked around by making\n', ' * those functions `private`, and then adding `external` `nonReentrant` entry\n', ' * points to them.\n', ' */\n', 'contract ReentrancyGuard {\n', '    /// @dev counter to allow mutex lock with only one SSTORE operation\n', '    uint256 private _guardCounter;\n', '\n', '    constructor () internal {\n', '        // The counter starts at one to prevent changing it from zero to a non-zero\n', '        // value, which is a more expensive operation.\n', '        _guardCounter = 1;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        _guardCounter += 1;\n', '        uint256 localCounter = _guardCounter;\n', '        _;\n', '        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");\n', '    }\n', '}\n', '\n', '// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '}\n', '\n', '// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// File: contracts/uniswap/IUniswapV2Router02.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Router02 {\n', '    function factory() external pure returns (address);\n', '\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 amountADesired,\n', '        uint256 amountBDesired,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    )\n', '        external\n', '        returns (\n', '            uint256 amountA,\n', '            uint256 amountB,\n', '            uint256 liquidity\n', '        );\n', '\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint256 amountTokenDesired,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    )\n', '        external\n', '        payable\n', '        returns (\n', '            uint256 amountToken,\n', '            uint256 amountETH,\n', '            uint256 liquidity\n', '        );\n', '\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 liquidity,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 liquidity,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '    function swapExactTokensForTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapTokensForExactTokens(\n', '        uint256 amountOut,\n', '        uint256 amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactETHForTokens(\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '\n', '    function swapTokensForExactETH(\n', '        uint256 amountOut,\n', '        uint256 amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactTokensForETH(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapETHForExactTokens(\n', '        uint256 amountOut,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '\n', '    function quote(\n', '        uint256 amountA,\n', '        uint256 reserveA,\n', '        uint256 reserveB\n', '    ) external pure returns (uint256 amountB);\n', '\n', '    function getAmountOut(\n', '        uint256 amountIn,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) external pure returns (uint256 amountOut);\n', '\n', '    function getAmountIn(\n', '        uint256 amountOut,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) external pure returns (uint256 amountIn);\n', '\n', '    function getAmountsOut(uint256 amountIn, address[] calldata path)\n', '        external\n', '        view\n', '        returns (uint256[] memory amounts);\n', '\n', '    function getAmountsIn(uint256 amountOut, address[] calldata path)\n', '        external\n', '        view\n', '        returns (uint256[] memory amounts);\n', '\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountETH);\n', '\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external;\n', '\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable;\n', '\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external;\n', '}\n', '\n', '// File: contracts/SafeToken.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface ERC20Interface {\n', '    function balanceOf(address user) external view returns (uint256);\n', '}\n', '\n', 'library SafeToken {\n', '    function myBalance(address token) internal view returns (uint256) {\n', '        return ERC20Interface(token).balanceOf(address(this));\n', '    }\n', '\n', '    function balanceOf(address token, address user) internal view returns (uint256) {\n', '        return ERC20Interface(token).balanceOf(user);\n', '    }\n', '\n', '    function safeApprove(address token, address to, uint256 value) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");\n', '    }\n', '\n', '    function safeTransfer(address token, address to, uint256 value) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");\n', '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint256 value) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");\n', '    }\n', '\n', '    function safeTransferETH(address to, uint256 value) internal {\n', '        (bool success, ) = to.call.value(value)(new bytes(0));\n', '        require(success, "!safeTransferETH");\n', '    }\n', '}\n', '\n', '// File: contracts/Strategy.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface Strategy {\n', '    /// @dev Execute worker strategy. Take LP tokens + ETH. Return LP tokens + ETH.\n', '    /// @param user The original user that is interacting with the operator.\n', "    /// @param debt The user's total debt, for better decision making context.\n", '    /// @param data Extra calldata information passed along to this strategy.\n', '    function execute(address user, uint256 debt, bytes calldata data) external payable;\n', '}\n', '\n', '// File: contracts/StrategyLiquidate.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract StrategyLiquidate is Ownable, ReentrancyGuard, Strategy {\n', '    using SafeToken for address;\n', '\n', '    IUniswapV2Factory public factory;\n', '    IUniswapV2Router02 public router;\n', '    address public weth;\n', '\n', '    /// @dev Create a new liquidate strategy instance.\n', '    /// @param _router The Uniswap router smart contract.\n', '    constructor(IUniswapV2Router02 _router) public {\n', '        factory = IUniswapV2Factory(_router.factory());\n', '        router = _router;\n', '        weth = _router.WETH();\n', '    }\n', '\n', '    /// @dev Execute worker strategy. Take LP tokens + ETH. Return LP tokens + ETH.\n', '    /// @param data Extra calldata information passed along to this strategy.\n', '    function execute(address /* user */, uint256 /* debt */, bytes calldata data)\n', '        external\n', '        payable\n', '        nonReentrant\n', '    {\n', '        // 1. Find out what farming token we are dealing with.\n', '        (address fToken, uint256 minETH) = abi.decode(data, (address, uint256));\n', '        IUniswapV2Pair lpToken = IUniswapV2Pair(factory.getPair(fToken, weth));\n', '        // 2. Remove all liquidity back to ETH and farming tokens.\n', '        lpToken.approve(address(router), uint256(-1));\n', '        router.removeLiquidityETH(fToken, lpToken.balanceOf(address(this)), 0, 0, address(this), now);\n', '        // 3. Convert farming tokens to ETH.\n', '        address[] memory path = new address[](2);\n', '        path[0] = fToken;\n', '        path[1] = weth;\n', '        fToken.safeApprove(address(router), 0);\n', '        fToken.safeApprove(address(router), uint256(-1));\n', '        router.swapExactTokensForETH(fToken.myBalance(), 0, path, address(this), now);\n', '        // 4. Return all ETH back to the original caller.\n', '        uint256 balance = address(this).balance;\n', '        require(balance >= minETH, "insufficient ETH received");\n', '        SafeToken.safeTransferETH(msg.sender, balance);\n', '    }\n', '\n', '    /// @dev Recover ERC20 tokens that were accidentally sent to this smart contract.\n', '    /// @param token The token contract. Can be anything. This contract should not hold ERC20 tokens.\n', '    /// @param to The address to send the tokens to.\n', '    /// @param value The number of tokens to transfer to `to`.\n', '    function recover(address token, address to, uint256 value) external onlyOwner nonReentrant {\n', '        token.safeTransfer(to, value);\n', '    }\n', '\n', '    function() external payable {}\n', '}']
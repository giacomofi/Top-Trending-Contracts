['// File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be aplied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * > Note: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity-2.3.0/contracts/utils/ReentrancyGuard.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module that helps prevent reentrant calls to a function.\n', ' *\n', ' * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier\n', ' * available, which can be aplied to functions to make sure there are no nested\n', ' * (reentrant) calls to them.\n', ' *\n', ' * Note that because there is a single `nonReentrant` guard, functions marked as\n', ' * `nonReentrant` may not call one another. This can be worked around by making\n', ' * those functions `private`, and then adding `external` `nonReentrant` entry\n', ' * points to them.\n', ' */\n', 'contract ReentrancyGuard {\n', '    /// @dev counter to allow mutex lock with only one SSTORE operation\n', '    uint256 private _guardCounter;\n', '\n', '    constructor () internal {\n', '        // The counter starts at one to prevent changing it from zero to a non-zero\n', '        // value, which is a more expensive operation.\n', '        _guardCounter = 1;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        _guardCounter += 1;\n', '        uint256 localCounter = _guardCounter;\n', '        _;\n', '        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");\n', '    }\n', '}\n', '\n', '// File: synthetix/contracts/interfaces/IStakingRewards.sol\n', '\n', 'pragma solidity >=0.4.24;\n', '\n', '\n', 'interface IStakingRewards {\n', '    // Views\n', '    function lastTimeRewardApplicable() external view returns (uint256);\n', '\n', '    function rewardPerToken() external view returns (uint256);\n', '\n', '    function earned(address account) external view returns (uint256);\n', '\n', '    function getRewardForDuration() external view returns (uint256);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    // Mutative\n', '\n', '    function stake(uint256 amount) external;\n', '\n', '    function withdraw(uint256 amount) external;\n', '\n', '    function getReward() external;\n', '\n', '    function exit() external;\n', '}\n', '\n', '// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '}\n', '\n', '// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// File: @uniswap/v2-core/contracts/libraries/Math.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '// a library for performing various math operations\n', '\n', 'library Math {\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        z = x < y ? x : y;\n', '    }\n', '\n', '    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)\n', '    function sqrt(uint y) internal pure returns (uint z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/uniswap/IUniswapV2Router02.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Router02 {\n', '    function factory() external pure returns (address);\n', '\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 amountADesired,\n', '        uint256 amountBDesired,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    )\n', '        external\n', '        returns (\n', '            uint256 amountA,\n', '            uint256 amountB,\n', '            uint256 liquidity\n', '        );\n', '\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint256 amountTokenDesired,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    )\n', '        external\n', '        payable\n', '        returns (\n', '            uint256 amountToken,\n', '            uint256 amountETH,\n', '            uint256 liquidity\n', '        );\n', '\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 liquidity,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 liquidity,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '    function swapExactTokensForTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapTokensForExactTokens(\n', '        uint256 amountOut,\n', '        uint256 amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactETHForTokens(\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '\n', '    function swapTokensForExactETH(\n', '        uint256 amountOut,\n', '        uint256 amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactTokensForETH(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapETHForExactTokens(\n', '        uint256 amountOut,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '\n', '    function quote(\n', '        uint256 amountA,\n', '        uint256 reserveA,\n', '        uint256 reserveB\n', '    ) external pure returns (uint256 amountB);\n', '\n', '    function getAmountOut(\n', '        uint256 amountIn,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) external pure returns (uint256 amountOut);\n', '\n', '    function getAmountIn(\n', '        uint256 amountOut,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) external pure returns (uint256 amountIn);\n', '\n', '    function getAmountsOut(uint256 amountIn, address[] calldata path)\n', '        external\n', '        view\n', '        returns (uint256[] memory amounts);\n', '\n', '    function getAmountsIn(uint256 amountOut, address[] calldata path)\n', '        external\n', '        view\n', '        returns (uint256[] memory amounts);\n', '\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountETH);\n', '\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external returns (uint256 amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external;\n', '\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable;\n', '\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external;\n', '}\n', '\n', '// File: contracts/Strategy.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface Strategy {\n', '    /// @dev Execute worker strategy. Take LP tokens + ETH. Return LP tokens + ETH.\n', '    /// @param user The original user that is interacting with the operator.\n', "    /// @param debt The user's total debt, for better decision making context.\n", '    /// @param data Extra calldata information passed along to this strategy.\n', '    function execute(address user, uint256 debt, bytes calldata data) external payable;\n', '}\n', '\n', '// File: contracts/SafeToken.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface ERC20Interface {\n', '    function balanceOf(address user) external view returns (uint256);\n', '}\n', '\n', 'library SafeToken {\n', '    function myBalance(address token) internal view returns (uint256) {\n', '        return ERC20Interface(token).balanceOf(address(this));\n', '    }\n', '\n', '    function balanceOf(address token, address user) internal view returns (uint256) {\n', '        return ERC20Interface(token).balanceOf(user);\n', '    }\n', '\n', '    function safeApprove(address token, address to, uint256 value) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");\n', '    }\n', '\n', '    function safeTransfer(address token, address to, uint256 value) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");\n', '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint256 value) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");\n', '    }\n', '\n', '    function safeTransferETH(address to, uint256 value) internal {\n', '        (bool success, ) = to.call.value(value)(new bytes(0));\n', '        require(success, "!safeTransferETH");\n', '    }\n', '}\n', '\n', '// File: contracts/Goblin.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface Goblin {\n', '    /// @dev Work on a (potentially new) position. Optionally send ETH back to Bank.\n', '    function work(uint256 id, address user, uint256 debt, bytes calldata data) external payable;\n', '\n', '    /// @dev Re-invest whatever the goblin is working on.\n', '    function reinvest() external;\n', '\n', '    /// @dev Return the amount of ETH wei to get back if we are to liquidate the position.\n', '    function health(uint256 id) external view returns (uint256);\n', '\n', '    /// @dev Liquidate the given position to ETH. Send all ETH back to Bank.\n', '    function liquidate(uint256 id) external;\n', '}\n', '\n', '// File: contracts/UniswapGoblin.sol\n', '\n', 'pragma solidity 0.5.16;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract UniswapGoblin is Ownable, ReentrancyGuard, Goblin {\n', '    /// @notice Libraries\n', '    using SafeToken for address;\n', '    using SafeMath for uint256;\n', '\n', '    /// @notice Events\n', '    event Reinvest(address indexed caller, uint256 reward, uint256 bounty);\n', '    event AddShare(uint256 indexed id, uint256 share);\n', '    event RemoveShare(uint256 indexed id, uint256 share);\n', '    event Liquidate(uint256 indexed id, uint256 wad);\n', '\n', '    /// @notice Immutable variables\n', '    IStakingRewards public staking;\n', '    IUniswapV2Factory public factory;\n', '    IUniswapV2Router02 public router;\n', '    IUniswapV2Pair public lpToken;\n', '    address public weth;\n', '    address public fToken;\n', '    address public uni;\n', '    address public operator;\n', '\n', '    /// @notice Mutable state variables\n', '    mapping(uint256 => uint256) public shares;\n', '    mapping(address => bool) public okStrats;\n', '    uint256 public totalShare;\n', '    Strategy public addStrat;\n', '    Strategy public liqStrat;\n', '    uint256 public reinvestBountyBps;\n', '\n', '    constructor(\n', '        address _operator,\n', '        IStakingRewards _staking,\n', '        IUniswapV2Router02 _router,\n', '        address _fToken,\n', '        address _uni,\n', '        Strategy _addStrat,\n', '        Strategy _liqStrat,\n', '        uint256 _reinvestBountyBps\n', '    ) public {\n', '        operator = _operator;\n', '        weth = _router.WETH();\n', '        staking = _staking;\n', '        router = _router;\n', '        factory = IUniswapV2Factory(_router.factory());\n', '        lpToken = IUniswapV2Pair(factory.getPair(weth, _fToken));\n', '        fToken = _fToken;\n', '        uni = _uni;\n', '        addStrat = _addStrat;\n', '        liqStrat = _liqStrat;\n', '        okStrats[address(addStrat)] = true;\n', '        okStrats[address(liqStrat)] = true;\n', '        reinvestBountyBps = _reinvestBountyBps;\n', '        lpToken.approve(address(_staking), uint256(-1)); // 100% trust in the staking pool\n', '        lpToken.approve(address(router), uint256(-1)); // 100% trust in the router\n', '        _fToken.safeApprove(address(router), uint256(-1)); // 100% trust in the router\n', '        _uni.safeApprove(address(router), uint256(-1)); // 100% trust in the router\n', '    }\n', '\n', '    /// @dev Require that the caller must be an EOA account to avoid flash loans.\n', '    modifier onlyEOA() {\n', '        require(msg.sender == tx.origin, "not eoa");\n', '        _;\n', '    }\n', '\n', '    /// @dev Require that the caller must be the operator (the bank).\n', '    modifier onlyOperator() {\n', '        require(msg.sender == operator, "not operator");\n', '        _;\n', '    }\n', '\n', '    /// @dev Return the entitied LP token balance for the given shares.\n', '    /// @param share The number of shares to be converted to LP balance.\n', '    function shareToBalance(uint256 share) public view returns (uint256) {\n', "        if (totalShare == 0) return share; // When there's no share, 1 share = 1 balance.\n", '        uint256 totalBalance = staking.balanceOf(address(this));\n', '        return share.mul(totalBalance).div(totalShare);\n', '    }\n', '\n', '    /// @dev Return the number of shares to receive if staking the given LP tokens.\n', '    /// @param balance the number of LP tokens to be converted to shares.\n', '    function balanceToShare(uint256 balance) public view returns (uint256) {\n', "        if (totalShare == 0) return balance; // When there's no share, 1 share = 1 balance.\n", '        uint256 totalBalance = staking.balanceOf(address(this));\n', '        return balance.mul(totalShare).div(totalBalance);\n', '    }\n', '\n', '    /// @dev Re-invest whatever this worker has earned back to staked LP tokens.\n', '    function reinvest() public onlyEOA nonReentrant {\n', '        // 1. Withdraw all the rewards.\n', '        staking.getReward();\n', '        uint256 reward = uni.myBalance();\n', '        if (reward == 0) return;\n', '        // 2. Send the reward bounty to the caller.\n', '        uint256 bounty = reward.mul(reinvestBountyBps) / 10000;\n', '        uni.safeTransfer(msg.sender, bounty);\n', '        // 3. Convert all the remaining rewards to ETH.\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(uni);\n', '        path[1] = address(weth);\n', '        router.swapExactTokensForETH(reward.sub(bounty), 0, path, address(this), now);\n', '        // 4. Use add ETH strategy to convert all ETH to LP tokens.\n', '        addStrat.execute.value(address(this).balance)(address(0), 0, abi.encode(fToken, 0));\n', '        // 5. Mint more LP tokens and stake them for more rewards.\n', '        staking.stake(lpToken.balanceOf(address(this)));\n', '        emit Reinvest(msg.sender, reward, bounty);\n', '    }\n', '\n', '    /// @dev Work on the given position. Must be called by the operator.\n', '    /// @param id The position ID to work on.\n', '    /// @param user The original user that is interacting with the operator.\n', '    /// @param debt The amount of user debt to help the strategy make decisions.\n', '    /// @param data The encoded data, consisting of strategy address and calldata.\n', '    function work(uint256 id, address user, uint256 debt, bytes calldata data)\n', '        external payable\n', '        onlyOperator nonReentrant\n', '    {\n', '        // 1. Convert this position back to LP tokens.\n', '        _removeShare(id);\n', '        // 2. Perform the worker strategy; sending LP tokens + ETH; expecting LP tokens + ETH.\n', '        (address strat, bytes memory ext) = abi.decode(data, (address, bytes));\n', '        require(okStrats[strat], "unapproved work strategy");\n', '        lpToken.transfer(strat, lpToken.balanceOf(address(this)));\n', '        Strategy(strat).execute.value(msg.value)(user, debt, ext);\n', '        // 3. Add LP tokens back to the farming pool.\n', '        _addShare(id);\n', '        // 4. Return any remaining ETH back to the operator.\n', '        SafeToken.safeTransferETH(msg.sender, address(this).balance);\n', '    }\n', '\n', '    /// @dev Return maximum output given the input amount and the status of Uniswap reserves.\n', '    /// @param aIn The amount of asset to market sell.\n', '    /// @param rIn the amount of asset in reserve for input.\n', '    /// @param rOut The amount of asset in reserve for output.\n', '    function getMktSellAmount(uint256 aIn, uint256 rIn, uint256 rOut) public pure returns (uint256) {\n', '        if (aIn == 0) return 0;\n', '        require(rIn > 0 && rOut > 0, "bad reserve values");\n', '        uint256 aInWithFee = aIn.mul(997);\n', '        uint256 numerator = aInWithFee.mul(rOut);\n', '        uint256 denominator = rIn.mul(1000).add(aInWithFee);\n', '        return numerator / denominator;\n', '    }\n', '\n', '    /// @dev Return the amount of ETH to receive if we are to liquidate the given position.\n', '    /// @param id The position ID to perform health check.\n', '    function health(uint256 id) external view returns (uint256) {\n', "        // 1. Get the position's LP balance and LP total supply.\n", '        uint256 lpBalance = shareToBalance(shares[id]);\n', '        uint256 lpSupply = lpToken.totalSupply(); // Ignore pending mintFee as it is insignificant\n', "        // 2. Get the pool's total supply of WETH and farming token.\n", '        (uint256 r0, uint256 r1,) = lpToken.getReserves();\n', '        (uint256 totalWETH, uint256 totalfToken) = lpToken.token0() == weth ? (r0, r1) : (r1, r0);\n', "        // 3. Convert the position's LP tokens to the underlying assets.\n", '        uint256 userWETH = lpBalance.mul(totalWETH).div(lpSupply);\n', '        uint256 userfToken = lpBalance.mul(totalfToken).div(lpSupply);\n', '        // 4. Convert all farming tokens to ETH and return total ETH.\n', '        return getMktSellAmount(\n', '            userfToken, totalfToken.sub(userfToken), totalWETH.sub(userWETH)\n', '        ).add(userWETH);\n', '    }\n', '\n', '    /// @dev Liquidate the given position by converting it to ETH and return back to caller.\n', '    /// @param id The position ID to perform liquidation\n', '    function liquidate(uint256 id) external onlyOperator nonReentrant {\n', '        // 1. Convert the position back to LP tokens and use liquidate strategy.\n', '        _removeShare(id);\n', '        lpToken.transfer(address(liqStrat), lpToken.balanceOf(address(this)));\n', '        liqStrat.execute(address(0), 0, abi.encode(fToken, 0));\n', '        // 2. Return all available ETH back to the operator.\n', '        uint256 wad = address(this).balance;\n', '        SafeToken.safeTransferETH(msg.sender, wad);\n', '        emit Liquidate(id, wad);\n', '    }\n', '\n', '    /// @dev Internal function to stake all outstanding LP tokens to the given position ID.\n', '    function _addShare(uint256 id) internal {\n', '        uint256 balance = lpToken.balanceOf(address(this));\n', '        if (balance > 0) {\n', '            uint256 share = balanceToShare(balance);\n', '            staking.stake(balance);\n', '            shares[id] = shares[id].add(share);\n', '            totalShare = totalShare.add(share);\n', '            emit AddShare(id, share);\n', '        }\n', '    }\n', '\n', '    /// @dev Internal function to remove shares of the ID and convert to outstanding LP tokens.\n', '    function _removeShare(uint256 id) internal {\n', '        uint256 share = shares[id];\n', '        if (share > 0) {\n', '            uint256 balance = shareToBalance(share);\n', '            staking.withdraw(balance);\n', '            totalShare = totalShare.sub(share);\n', '            shares[id] = 0;\n', '            emit RemoveShare(id, share);\n', '        }\n', '    }\n', '\n', '    /// @dev Recover ERC20 tokens that were accidentally sent to this smart contract.\n', '    /// @param token The token contract. Can be anything. This contract should not hold ERC20 tokens.\n', '    /// @param to The address to send the tokens to.\n', '    /// @param value The number of tokens to transfer to `to`.\n', '    function recover(address token, address to, uint256 value) external onlyOwner nonReentrant {\n', '        token.safeTransfer(to, value);\n', '    }\n', '\n', '    /// @dev Set the reward bounty for calling reinvest operations.\n', '    /// @param _reinvestBountyBps The bounty value to update.\n', '    function setReinvestBountyBps(uint256 _reinvestBountyBps) external onlyOwner {\n', '        reinvestBountyBps = _reinvestBountyBps;\n', '    }\n', '\n', "    /// @dev Set the given strategies' approval status.\n", '    /// @param strats The strategy addresses.\n', '    /// @param isOk Whether to approve or unapprove the given strategies.\n', '    function setStrategyOk(address[] calldata strats, bool isOk) external onlyOwner {\n', '        uint256 len = strats.length;\n', '        for (uint256 idx = 0; idx < len; idx++) {\n', '            okStrats[strats[idx]] = isOk;\n', '        }\n', '    }\n', '\n', '    /// @dev Update critical strategy smart contracts. EMERGENCY ONLY. Bad strategies can steal funds.\n', '    /// @param _addStrat The new add strategy contract.\n', '    /// @param _liqStrat The new liquidate strategy contract.\n', '    function setCriticalStrategies(Strategy _addStrat, Strategy _liqStrat) external onlyOwner {\n', '        addStrat = _addStrat;\n', '        liqStrat = _liqStrat;\n', '    }\n', '\n', '    function() external payable {}\n', '}']
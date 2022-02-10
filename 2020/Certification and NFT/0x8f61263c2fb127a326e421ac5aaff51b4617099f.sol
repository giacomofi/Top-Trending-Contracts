['//   _    _ _   _                __ _                            \n', '//  | |  (_) | | |              / _(_)                           \n', '//  | | ___| |_| |_ ___ _ __   | |_ _ _ __   __ _ _ __   ___ ___ \n', "//  | |/ / | __| __/ _ \\ '_ \\  |  _| | '_ \\ / _` | '_ \\ / __/ _ \\\n", '//  |   <| | |_| ||  __/ | | |_| | | | | | | (_| | | | | (_|  __/\n', '//  |_|\\_\\_|\\__|\\__\\___|_| |_(_)_| |_|_| |_|\\__,_|_| |_|\\___\\___|\n', '//\n', '//  AlphaSwap v0 contract (AlphaDex)\n', '//\n', '//  https://www.AlphaSwap.org\n', '//\n', 'pragma solidity ^0.5.16;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "!addition overflow");\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "!subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "!multiplication overflow");\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "!division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function mint(address account, uint amount) external;\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * IMPORTANT: It is unsafe to assume that an address for which this\n', '     * function returns false is an externally-owned account (EOA) and not a\n', '     * contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', 'contract AlphaSwapV0 {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '    \n', '    struct MARKET_EPOCH {\n', '        uint timestamp;\n', '        uint accuPrice;\n', '        uint32 pairTimestamp;\n', '        mapping (address => mapping(uint => mapping (address => uint))) stake;\n', '        mapping (address => mapping(uint => uint)) totalStake;\n', '    }\n', '\n', '    mapping (address => mapping(uint => MARKET_EPOCH)) public market;\n', '    mapping (address => uint) public marketEpoch;\n', '    mapping (address => uint) public marketEpochPeriod;\n', '    \n', '    mapping (address => uint) public marketWhitelist;\n', '    mapping (address => uint) public tokenWhitelist;\n', '\n', '    event STAKE(address indexed user, address indexed market, uint opinion, address indexed token, uint amt);\n', '    event SYNC(address indexed market, uint epoch);\n', '    event PAYOFF(address indexed user, address indexed market, uint opinion, address indexed token, uint amt);\n', '    \n', '    event MARKET_PERIOD(address indexed market, uint period);\n', '    event MARKET_WHITELIST(address indexed market, uint status);\n', '    event TOKEN_WHITELIST(address indexed token, uint status);\n', '    event FEE_CHANGE(address indexed market, address indexed token, uint BP);\n', '    \n', '    //====================================================================\n', '    \n', '    address public govAddr;\n', '    address public devAddr;\n', '    \n', '    mapping (address => mapping(address => uint)) public devFeeBP; // in terms of basis points (1 bp = 0.01%)\n', '    mapping (address => uint) public devFeeAmt;\n', '    \n', '    constructor () public {\n', '        govAddr = msg.sender;\n', '        devAddr = msg.sender;\n', '    }\n', '    \n', '    modifier govOnly() {\n', '    \trequire(msg.sender == govAddr, "!gov");\n', '    \t_;\n', '    }\n', '    function govTransferAddr(address newAddr) external govOnly {\n', '    \trequire(newAddr != address(0), "!addr");\n', '    \tgovAddr = newAddr;\n', '    }\n', '    function govSetEpochPeriod(address xMarket, uint newPeriod) external govOnly {\n', '        require (newPeriod > 0, "!period");\n', '        marketEpochPeriod[xMarket] = newPeriod;\n', '        emit MARKET_PERIOD(xMarket, newPeriod);\n', '    }\n', '    function govMarketWhitelist(address xMarket, uint status) external govOnly {\n', '        require (status <= 1, "!status");\n', '        marketWhitelist[xMarket] = status;\n', '        emit MARKET_WHITELIST(xMarket, status);\n', '    }\n', '    function govTokenWhitelist(address xToken, uint status) external govOnly {\n', '        require (status <= 1, "!status");\n', '        tokenWhitelist[xToken] = status;\n', '        emit TOKEN_WHITELIST(xToken, status);\n', '    }\n', '    function govSetDevFee(address xMarket, address xToken, uint newBP) external govOnly {\n', '        require (newBP <= 10); // max fee = 10 basis points = 0.1%\n', '    \tdevFeeBP[xMarket][xToken] = newBP;\n', '    \temit FEE_CHANGE(xMarket, xToken, newBP);\n', '    }\n', '    \n', '    modifier devOnly() {\n', '    \trequire(msg.sender == devAddr, "!dev");\n', '    \t_;\n', '    }\n', '    function devTransferAddr(address newAddr) external devOnly {\n', '    \trequire(newAddr != address(0), "!addr");\n', '    \tdevAddr = newAddr;\n', '    }\n', '    function devWithdrawFee(address xToken, uint256 amt) external devOnly {\n', '        require (amt <= devFeeAmt[xToken]);\n', '        devFeeAmt[xToken] = devFeeAmt[xToken].sub(amt);\n', '        IERC20(xToken).safeTransfer(devAddr, amt);\n', '    }\n', '    \n', '    //====================================================================\n', '\n', '    function readStake(address user, address xMarket, uint xEpoch, uint xOpinion, address xToken) external view returns (uint) {\n', '        return market[xMarket][xEpoch].stake[xToken][xOpinion][user];\n', '    }\n', '    function readTotalStake(address xMarket, uint xEpoch, uint xOpinion, address xToken) external view returns (uint) {\n', '        return market[xMarket][xEpoch].totalStake[xToken][xOpinion];\n', '    }\n', '    \n', '    //====================================================================\n', '    \n', '    function Stake(address xMarket, uint xEpoch, uint xOpinion, address xToken, uint xAmt) external {\n', '        require (xAmt > 0, "!amt");\n', '        require (xOpinion <= 1, "!opinion");\n', '        require (marketWhitelist[xMarket] > 0, "!market");\n', '        require (tokenWhitelist[xToken] > 0, "!token");\n', '\n', '        uint thisEpoch = marketEpoch[xMarket];\n', '        require (xEpoch == thisEpoch, "!epoch");\n', '        MARKET_EPOCH storage m = market[xMarket][thisEpoch];\n', '\n', '        if (m.timestamp == 0) { // new market\n', '            m.timestamp = block.timestamp;\n', '            \n', '            IUniswapV2Pair pair = IUniswapV2Pair(xMarket);\n', '            uint112 reserve0;\n', '            uint112 reserve1;\n', '            uint32 pairTimestamp;\n', '            (reserve0, reserve1, pairTimestamp) = pair.getReserves();\n', '        \n', '            m.pairTimestamp = pairTimestamp;\n', '            m.accuPrice = pair.price0CumulativeLast();\n', '        }\n', '\n', '        address user = msg.sender;\n', '        IERC20(xToken).safeTransferFrom(user, address(this), xAmt);\n', '        \n', '        m.stake[xToken][xOpinion][user] = m.stake[xToken][xOpinion][user].add(xAmt);\n', '        m.totalStake[xToken][xOpinion] = m.totalStake[xToken][xOpinion].add(xAmt);\n', '        \n', '        emit STAKE(user, xMarket, xOpinion, xToken, xAmt);\n', '    }\n', '    \n', '    function _Sync(address xMarket) private {\n', '        uint epochPeriod = marketEpochPeriod[xMarket];\n', '        uint thisPeriod = (block.timestamp).div(epochPeriod);\n', '        \n', '        MARKET_EPOCH memory mmm = market[xMarket][marketEpoch[xMarket]];\n', '        uint marketPeriod = (mmm.timestamp).div(epochPeriod);\n', '        \n', '        if (thisPeriod <= marketPeriod)\n', '            return;\n', '\n', '        IUniswapV2Pair pair = IUniswapV2Pair(xMarket);\n', '        uint112 reserve0;\n', '        uint112 reserve1;\n', '        uint32 pairTimestamp;\n', '        (reserve0, reserve1, pairTimestamp) = pair.getReserves();\n', '        if (pairTimestamp <= mmm.pairTimestamp)\n', '            return;\n', '            \n', '        MARKET_EPOCH memory m;\n', '        m.timestamp = block.timestamp;\n', '        m.pairTimestamp = pairTimestamp;\n', '        m.accuPrice = pair.price0CumulativeLast();\n', '        \n', '        uint newEpoch = marketEpoch[xMarket].add(1);\n', '        marketEpoch[xMarket] = newEpoch;\n', '        market[xMarket][newEpoch] = m;\n', '        \n', '        emit SYNC(xMarket, newEpoch);\n', '    }\n', '    \n', '    function Sync(address xMarket) external {\n', '        uint epochPeriod = marketEpochPeriod[xMarket];\n', '        uint thisPeriod = (block.timestamp).div(epochPeriod);\n', '        \n', '        MARKET_EPOCH memory mmm = market[xMarket][marketEpoch[xMarket]];\n', '        uint marketPeriod = (mmm.timestamp).div(epochPeriod);\n', '        require (marketPeriod > 0, "!marketPeriod");\n', '        require (thisPeriod > marketPeriod, "!thisPeriod");\n', '\n', '        IUniswapV2Pair pair = IUniswapV2Pair(xMarket);\n', '        uint112 reserve0;\n', '        uint112 reserve1;\n', '        uint32 pairTimestamp;\n', '        (reserve0, reserve1, pairTimestamp) = pair.getReserves();\n', '        require (pairTimestamp > mmm.pairTimestamp, "!no-trade");\n', '\n', '        MARKET_EPOCH memory m;\n', '        m.timestamp = block.timestamp;\n', '        m.pairTimestamp = pairTimestamp;\n', '        m.accuPrice = pair.price0CumulativeLast();\n', '        \n', '        uint newEpoch = marketEpoch[xMarket].add(1);\n', '        marketEpoch[xMarket] = newEpoch;\n', '        market[xMarket][newEpoch] = m;\n', '        \n', '        emit SYNC(xMarket, newEpoch);\n', '    }\n', '    \n', '    function Payoff(address xMarket, uint xEpoch, uint xOpinion, address xToken) external {\n', '        require (xOpinion <= 1, "!opinion");\n', '        \n', '        uint thisEpoch = marketEpoch[xMarket];\n', '        require (thisEpoch >= 1, "!marketEpoch");\n', '        _Sync(xMarket);\n', '        \n', '        thisEpoch = marketEpoch[xMarket];\n', '        require (xEpoch <= thisEpoch.sub(2), "!epoch");\n', '\n', '        address user = msg.sender;\n', '        uint amtOut = 0;\n', '        \n', '        MARKET_EPOCH storage m0 = market[xMarket][xEpoch];\n', '        {\n', '            uint224 p01 = 0;\n', '            uint224 p12 = 0;\n', '            {\n', '                MARKET_EPOCH memory m1 = market[xMarket][xEpoch.add(1)];\n', '                MARKET_EPOCH memory m2 = market[xMarket][xEpoch.add(2)];\n', '                \n', '                // overflow is desired\n', '                uint32 t01 = m1.pairTimestamp - m0.pairTimestamp;\n', '                if (t01 > 0)\n', '                    p01 = uint224((m1.accuPrice - m0.accuPrice) / t01);\n', '                \n', '                uint32 t12 = m2.pairTimestamp - m1.pairTimestamp;\n', '                if (t12 > 0)\n', '                    p12 = uint224((m2.accuPrice - m1.accuPrice) / t12);\n', '            }\n', '            \n', '            uint userStake = m0.stake[xToken][xOpinion][user];\n', '            if ((p01 == p12) || (p01 == 0) || (p12 == 0)) {\n', '                amtOut = userStake;\n', '            }\n', '            else {\n', '                uint sameOpinionStake = m0.totalStake[xToken][xOpinion];\n', '                uint allStake = sameOpinionStake.add(m0.totalStake[xToken][1-xOpinion]);\n', '                if (sameOpinionStake == allStake) {\n', '                    amtOut = userStake;\n', '                } \n', '                else {\n', '                    if (\n', '                        ((p12 > p01) && (xOpinion == 1))\n', '                        ||\n', '                        ((p12 < p01) && (xOpinion == 0))\n', '                    )\n', '                    {\n', '                        amtOut = userStake.mul(allStake).div(sameOpinionStake);\n', '                    }\n', '                }\n', '            }\n', '        }\n', '        \n', '        require (amtOut > 0, "!zeroAmt");\n', '        \n', '        uint devFee = amtOut.mul(devFeeBP[xMarket][xToken]).div(10000);\n', '        devFeeAmt[xToken] = devFeeAmt[xToken].add(devFee);\n', '\n', '        amtOut = amtOut.sub(devFee);\n', '        \n', '        m0.stake[xToken][xOpinion][user] = 0;\n', '        IERC20(xToken).safeTransfer(user, amtOut);\n', '        \n', '        emit PAYOFF(user, xMarket, xOpinion, xToken, amtOut);\n', '    }\n', '}']
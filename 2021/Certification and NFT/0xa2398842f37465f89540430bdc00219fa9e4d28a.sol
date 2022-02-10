['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-03\n', '*/\n', '\n', '// File: contracts/intf/IDODOApprove.sol\n', '\n', '/*\n', '\n', '    Copyright 2021 DODO ZOO.\n', '    SPDX-License-Identifier: Apache-2.0\n', '\n', '*/\n', '\n', 'pragma solidity 0.6.9;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IDODOApprove {\n', '    function claimTokens(address token,address who,address dest,uint256 amount) external;\n', '    function getDODOProxy() external view returns (address);\n', '}\n', '\n', '// File: contracts/lib/InitializableOwnable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Ownership related functions\n', ' */\n', 'contract InitializableOwnable {\n', '    address public _OWNER_;\n', '    address public _NEW_OWNER_;\n', '    bool internal _INITIALIZED_;\n', '\n', '    // ============ Events ============\n', '\n', '    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    // ============ Modifiers ============\n', '\n', '    modifier notInitialized() {\n', '        require(!_INITIALIZED_, "DODO_INITIALIZED");\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _OWNER_, "NOT_OWNER");\n', '        _;\n', '    }\n', '\n', '    // ============ Functions ============\n', '\n', '    function initOwner(address newOwner) public notInitialized {\n', '        _INITIALIZED_ = true;\n', '        _OWNER_ = newOwner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        emit OwnershipTransferPrepared(_OWNER_, newOwner);\n', '        _NEW_OWNER_ = newOwner;\n', '    }\n', '\n', '    function claimOwnership() public {\n', '        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");\n', '        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);\n', '        _OWNER_ = _NEW_OWNER_;\n', '        _NEW_OWNER_ = address(0);\n', '    }\n', '}\n', '\n', '// File: contracts/SmartRoute/DODOApproveProxy.sol\n', '\n', 'interface IDODOApproveProxy {\n', '    function isAllowedProxy(address _proxy) external view returns (bool);\n', '    function claimTokens(address token,address who,address dest,uint256 amount) external;\n', '}\n', '\n', '/**\n', ' * @title DODOApproveProxy\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Allow different version dodoproxy to claim from DODOApprove\n', ' */\n', 'contract DODOApproveProxy is InitializableOwnable {\n', '    \n', '    // ============ Storage ============\n', '    uint256 private constant _TIMELOCK_DURATION_ = 3 days;\n', '    mapping (address => bool) public _IS_ALLOWED_PROXY_;\n', '    uint256 public _TIMELOCK_;\n', '    address public _PENDING_ADD_DODO_PROXY_;\n', '    address public immutable _DODO_APPROVE_;\n', '\n', '    // ============ Modifiers ============\n', '    modifier notLocked() {\n', '        require(\n', '            _TIMELOCK_ <= block.timestamp,\n', '            "SetProxy is timelocked"\n', '        );\n', '        _;\n', '    }\n', '\n', '    constructor(address dodoApporve) public {\n', '        _DODO_APPROVE_ = dodoApporve;\n', '    }\n', '\n', '    function init(address owner, address[] memory proxies) external {\n', '        initOwner(owner);\n', '        for(uint i = 0; i < proxies.length; i++) \n', '            _IS_ALLOWED_PROXY_[proxies[i]] = true;\n', '    }\n', '\n', '    function unlockAddProxy(address newDodoProxy) public onlyOwner {\n', '        _TIMELOCK_ = block.timestamp + _TIMELOCK_DURATION_;\n', '        _PENDING_ADD_DODO_PROXY_ = newDodoProxy;\n', '    }\n', '\n', '    function lockAddProxy() public onlyOwner {\n', '       _PENDING_ADD_DODO_PROXY_ = address(0);\n', '       _TIMELOCK_ = 0;\n', '    }\n', '\n', '\n', '    function addDODOProxy() external onlyOwner notLocked() {\n', '        _IS_ALLOWED_PROXY_[_PENDING_ADD_DODO_PROXY_] = true;\n', '        lockAddProxy();\n', '    }\n', '\n', '    function removeDODOProxy (address oldDodoProxy) public onlyOwner {\n', '        _IS_ALLOWED_PROXY_[oldDodoProxy] = false;\n', '    }\n', '    \n', '    function claimTokens(\n', '        address token,\n', '        address who,\n', '        address dest,\n', '        uint256 amount\n', '    ) external {\n', '        require(_IS_ALLOWED_PROXY_[msg.sender], "DODOApproveProxy:Access restricted");\n', '        IDODOApprove(_DODO_APPROVE_).claimTokens(\n', '            token,\n', '            who,\n', '            dest,\n', '            amount\n', '        );\n', '    }\n', '\n', '    function isAllowedProxy(address _proxy) external view returns (bool) {\n', '        return _IS_ALLOWED_PROXY_[_proxy];\n', '    }\n', '}\n', '\n', '// File: contracts/intf/IERC20.sol\n', '\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '}\n', '\n', '// File: contracts/intf/IWETH.sol\n', '\n', '\n', '\n', 'interface IWETH {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address src,\n', '        address dst,\n', '        uint256 wad\n', '    ) external returns (bool);\n', '\n', '    function deposit() external payable;\n', '\n', '    function withdraw(uint256 wad) external;\n', '}\n', '\n', '// File: contracts/lib/SafeMath.sol\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "MUL_ERROR");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "DIVIDING_ERROR");\n', '        return a / b;\n', '    }\n', '\n', '    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 quotient = div(a, b);\n', '        uint256 remainder = a - quotient * b;\n', '        if (remainder > 0) {\n', '            return quotient + 1;\n', '        } else {\n', '            return quotient;\n', '        }\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SUB_ERROR");\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "ADD_ERROR");\n', '        return c;\n', '    }\n', '\n', '    function sqrt(uint256 x) internal pure returns (uint256 y) {\n', '        uint256 z = x / 2 + 1;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/lib/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require(\n', '            (value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/SmartRoute/lib/UniversalERC20.sol\n', '\n', '\n', '\n', 'library UniversalERC20 {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);\n', '\n', '    function universalTransfer(\n', '        IERC20 token,\n', '        address payable to,\n', '        uint256 amount\n', '    ) internal {\n', '        if (amount > 0) {\n', '            if (isETH(token)) {\n', '                to.transfer(amount);\n', '            } else {\n', '                token.safeTransfer(to, amount);\n', '            }\n', '        }\n', '    }\n', '\n', '    function universalApproveMax(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 amount\n', '    ) internal {\n', '        uint256 allowance = token.allowance(address(this), to);\n', '        if (allowance < amount) {\n', '            if (allowance > 0) {\n', '                token.safeApprove(to, 0);\n', '            }\n', '            token.safeApprove(to, uint256(-1));\n', '        }\n', '    }\n', '\n', '    function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {\n', '        if (isETH(token)) {\n', '            return who.balance;\n', '        } else {\n', '            return token.balanceOf(who);\n', '        }\n', '    }\n', '\n', '    function tokenBalanceOf(IERC20 token, address who) internal view returns (uint256) {\n', '        return token.balanceOf(who);\n', '    }\n', '\n', '    function isETH(IERC20 token) internal pure returns (bool) {\n', '        return token == ETH_ADDRESS;\n', '    }\n', '}\n', '\n', '// File: contracts/SmartRoute/intf/IDODOAdapter.sol\n', '\n', '\n', 'interface IDODOAdapter {\n', '    \n', '    function sellBase(address to, address pool, bytes memory data) external;\n', '\n', '    function sellQuote(address to, address pool, bytes memory data) external;\n', '}\n', '\n', '// File: contracts/SmartRoute/proxies/DODORouteProxy.sol\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title DODORouteProxy\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Entrance of Split trading in DODO platform\n', ' */\n', 'contract DODORouteProxy {\n', '    using SafeMath for uint256;\n', '    using UniversalERC20 for IERC20;\n', '\n', '    // ============ Storage ============\n', '\n', '    address constant _ETH_ADDRESS_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '    address public immutable _WETH_;\n', '    address public immutable _DODO_APPROVE_PROXY_;\n', '\n', '    struct PoolInfo {\n', '        uint256 direction;\n', '        uint256 poolEdition;\n', '        uint256 weight;\n', '        address pool;\n', '        address adapter;\n', '        bytes moreInfo;\n', '    }\n', '\n', '    // ============ Events ============\n', '\n', '     event OrderHistory(\n', '        address fromToken,\n', '        address toToken,\n', '        address sender,\n', '        uint256 fromAmount,\n', '        uint256 returnAmount\n', '    );\n', '\n', '    // ============ Modifiers ============\n', '\n', '    modifier judgeExpired(uint256 deadLine) {\n', '        require(deadLine >= block.timestamp, "DODORouteProxy: EXPIRED");\n', '        _;\n', '    }\n', '\n', '    fallback() external payable {}\n', '\n', '    receive() external payable {}\n', '\n', '    constructor (\n', '        address payable weth,\n', '        address dodoApproveProxy\n', '    ) public {\n', '        _WETH_ = weth;\n', '        _DODO_APPROVE_PROXY_ = dodoApproveProxy;\n', '    }\n', '\n', '    function mixSwap(\n', '        address fromToken,\n', '        address toToken,\n', '        uint256 fromTokenAmount,\n', '        uint256 minReturnAmount,\n', '        address[] memory mixAdapters,\n', '        address[] memory mixPairs,\n', '        address[] memory assetTo,\n', '        uint256 directions,\n', '        bytes[] memory moreInfos,\n', '        uint256 deadLine\n', '    ) external payable judgeExpired(deadLine) returns (uint256 returnAmount) {\n', '        require(mixPairs.length > 0, "DODORouteProxy: PAIRS_EMPTY");\n', '        require(mixPairs.length == mixAdapters.length, "DODORouteProxy: PAIR_ADAPTER_NOT_MATCH");\n', '        require(mixPairs.length == assetTo.length - 1, "DODORouteProxy: PAIR_ASSETTO_NOT_MATCH");\n', '        require(minReturnAmount > 0, "DODORouteProxy: RETURN_AMOUNT_ZERO");\n', '\n', '        address _fromToken = fromToken;\n', '        address _toToken = toToken;\n', '        uint256 _fromTokenAmount = fromTokenAmount;\n', '        \n', '        uint256 toTokenOriginBalance = IERC20(_toToken).universalBalanceOf(msg.sender);\n', '        \n', '        _deposit(msg.sender, assetTo[0], _fromToken, _fromTokenAmount, _fromToken == _ETH_ADDRESS_);\n', '\n', '        for (uint256 i = 0; i < mixPairs.length; i++) {\n', '            if (directions & 1 == 0) {\n', '                IDODOAdapter(mixAdapters[i]).sellBase(assetTo[i + 1],mixPairs[i], moreInfos[i]);\n', '            } else {\n', '                IDODOAdapter(mixAdapters[i]).sellQuote(assetTo[i + 1],mixPairs[i], moreInfos[i]);\n', '            }\n', '            directions = directions >> 1;\n', '        }\n', '\n', '        if(_toToken == _ETH_ADDRESS_) {\n', '            returnAmount = IWETH(_WETH_).balanceOf(address(this));\n', '            IWETH(_WETH_).withdraw(returnAmount);\n', '            msg.sender.transfer(returnAmount);\n', '        }else {\n', '            returnAmount = IERC20(_toToken).tokenBalanceOf(msg.sender).sub(toTokenOriginBalance);\n', '        }\n', '\n', '        require(returnAmount >= minReturnAmount, "DODORouteProxy: Return amount is not enough");\n', '\n', '        emit OrderHistory(\n', '            _fromToken,\n', '            _toToken,\n', '            msg.sender,\n', '            _fromTokenAmount,\n', '            returnAmount\n', '        );\n', '    }\n', '\n', '    function dodoMutliSwap(\n', '        uint256 fromTokenAmount,\n', '        uint256 minReturnAmount,\n', '        uint256[] memory totalWeight,\n', '        uint256[] memory splitNumber,\n', '        address[] memory midToken,\n', '        address[] memory assetFrom,\n', '        bytes[] memory sequence,\n', '        uint256 deadLine\n', '    ) external payable judgeExpired(deadLine) returns (uint256 returnAmount) {\n', "        require(assetFrom.length == splitNumber.length, 'DODORouteProxy: PAIR_ASSETTO_NOT_MATCH');        \n", '        require(minReturnAmount > 0, "DODORouteProxy: RETURN_AMOUNT_ZERO");\n', '        \n', '        uint256 _fromTokenAmount = fromTokenAmount;\n', '        address fromToken = midToken[0];\n', '        address toToken = midToken[midToken.length - 1];\n', '\n', '        uint256 toTokenOriginBalance = IERC20(toToken).universalBalanceOf(msg.sender);\n', '        _deposit(msg.sender, assetFrom[0], fromToken, _fromTokenAmount, fromToken == _ETH_ADDRESS_);\n', '\n', '        _multiSwap(totalWeight, midToken, splitNumber, sequence, assetFrom);\n', '    \n', '        if(toToken == _ETH_ADDRESS_) {\n', '            returnAmount = IWETH(_WETH_).balanceOf(address(this));\n', '            IWETH(_WETH_).withdraw(returnAmount);\n', '            msg.sender.transfer(returnAmount);\n', '        }else {\n', '            returnAmount = IERC20(toToken).tokenBalanceOf(msg.sender).sub(toTokenOriginBalance);\n', '        }\n', '\n', '        require(returnAmount >= minReturnAmount, "DODORouteProxy: Return amount is not enough");\n', '    \n', '        emit OrderHistory(\n', '            fromToken,\n', '            toToken,\n', '            msg.sender,\n', '            _fromTokenAmount,\n', '            returnAmount\n', '        );    \n', '    }\n', '\n', '    \n', '    //====================== internal =======================\n', '\n', '    function _multiSwap(\n', '        uint256[] memory totalWeight,\n', '        address[] memory midToken,\n', '        uint256[] memory splitNumber,\n', '        bytes[] memory swapSequence,\n', '        address[] memory assetFrom\n', '    ) internal { \n', '        for(uint256 i = 1; i < splitNumber.length; i++) { \n', '            // define midtoken address, ETH -> WETH address\n', '            uint256 curTotalAmount = IERC20(midToken[i]).tokenBalanceOf(assetFrom[i-1]);\n', '            uint256 curTotalWeight = totalWeight[i-1];\n', '            \n', '            for(uint256 j = splitNumber[i-1]; j < splitNumber[i]; j++) {\n', '                PoolInfo memory curPoolInfo;\n', '                {\n', '                    (address pool, address adapter, uint256 mixPara, bytes memory moreInfo) = abi.decode(swapSequence[j], (address, address, uint256, bytes));\n', '                \n', '                    curPoolInfo.direction = mixPara >> 17;\n', '                    curPoolInfo.weight = (0xffff & mixPara) >> 9;\n', '                    curPoolInfo.poolEdition = (0xff & mixPara);\n', '                    curPoolInfo.pool = pool;\n', '                    curPoolInfo.adapter = adapter;\n', '                    curPoolInfo.moreInfo = moreInfo;\n', '                }\n', '\n', '                if(assetFrom[i-1] == address(this)) {\n', '                    uint256 curAmount = curTotalAmount.div(curTotalWeight).mul(curPoolInfo.weight);\n', '            \n', '                    if(curPoolInfo.poolEdition == 1) {   \n', '                        //For using transferFrom pool (like dodoV1, Curve)\n', '                        IERC20(midToken[i]).transfer(curPoolInfo.adapter, curAmount);\n', '                    } else {\n', '                        //For using transfer pool (like dodoV2)\n', '                        IERC20(midToken[i]).transfer(curPoolInfo.pool, curAmount);\n', '                    }\n', '                }\n', '                \n', '                if(curPoolInfo.direction == 0) {\n', '                    IDODOAdapter(curPoolInfo.adapter).sellBase(assetFrom[i], curPoolInfo.pool, curPoolInfo.moreInfo);\n', '                } else {\n', '                    IDODOAdapter(curPoolInfo.adapter).sellQuote(assetFrom[i], curPoolInfo.pool, curPoolInfo.moreInfo);\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    function _deposit(\n', '        address from,\n', '        address to,\n', '        address token,\n', '        uint256 amount,\n', '        bool isETH\n', '    ) internal {\n', '        if (isETH) {\n', '            if (amount > 0) {\n', '                IWETH(_WETH_).deposit{value: amount}();\n', '                if (to != address(this)) SafeERC20.safeTransfer(IERC20(_WETH_), to, amount);\n', '            }\n', '        } else {\n', '            IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(token, from, to, amount);\n', '        }\n', '    }\n', '}']
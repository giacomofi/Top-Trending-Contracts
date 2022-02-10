['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-29\n', '*/\n', '\n', '// File: contracts/intf/IDODOApprove.sol\n', '\n', '/*\n', '\n', '    Copyright 2020 DODO ZOO.\n', '    SPDX-License-Identifier: Apache-2.0\n', '\n', '*/\n', '\n', 'pragma solidity 0.6.9;\n', '\n', 'interface IDODOApprove {\n', '    function claimTokens(address token,address who,address dest,uint256 amount) external;\n', '    function getDODOProxy() external view returns (address);\n', '}\n', '\n', '// File: contracts/lib/InitializableOwnable.sol\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Ownership related functions\n', ' */\n', 'contract InitializableOwnable {\n', '    address public _OWNER_;\n', '    address public _NEW_OWNER_;\n', '    bool internal _INITIALIZED_;\n', '\n', '    // ============ Events ============\n', '\n', '    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    // ============ Modifiers ============\n', '\n', '    modifier notInitialized() {\n', '        require(!_INITIALIZED_, "DODO_INITIALIZED");\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _OWNER_, "NOT_OWNER");\n', '        _;\n', '    }\n', '\n', '    // ============ Functions ============\n', '\n', '    function initOwner(address newOwner) public notInitialized {\n', '        _INITIALIZED_ = true;\n', '        _OWNER_ = newOwner;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        emit OwnershipTransferPrepared(_OWNER_, newOwner);\n', '        _NEW_OWNER_ = newOwner;\n', '    }\n', '\n', '    function claimOwnership() public {\n', '        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");\n', '        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);\n', '        _OWNER_ = _NEW_OWNER_;\n', '        _NEW_OWNER_ = address(0);\n', '    }\n', '}\n', '\n', '// File: contracts/SmartRoute/DODOApproveProxy.sol\n', '\n', '\n', '\n', '\n', 'interface IDODOApproveProxy {\n', '    function isAllowedProxy(address _proxy) external view returns (bool);\n', '    function claimTokens(address token,address who,address dest,uint256 amount) external;\n', '}\n', '\n', '/**\n', ' * @title DODOApproveProxy\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Allow different version dodoproxy to claim from DODOApprove\n', ' */\n', 'contract DODOApproveProxy is InitializableOwnable {\n', '    \n', '    // ============ Storage ============\n', '    uint256 private constant _TIMELOCK_DURATION_ = 3 days;\n', '    mapping (address => bool) public _IS_ALLOWED_PROXY_;\n', '    uint256 public _TIMELOCK_;\n', '    address public _PENDING_ADD_DODO_PROXY_;\n', '    address public immutable _DODO_APPROVE_;\n', '\n', '    // ============ Modifiers ============\n', '    modifier notLocked() {\n', '        require(\n', '            _TIMELOCK_ <= block.timestamp,\n', '            "SetProxy is timelocked"\n', '        );\n', '        _;\n', '    }\n', '\n', '    constructor(address dodoApporve) public {\n', '        _DODO_APPROVE_ = dodoApporve;\n', '    }\n', '\n', '    function init(address owner, address[] memory proxies) external {\n', '        initOwner(owner);\n', '        for(uint i = 0; i < proxies.length; i++) \n', '            _IS_ALLOWED_PROXY_[proxies[i]] = true;\n', '    }\n', '\n', '    function unlockAddProxy(address newDodoProxy) public onlyOwner {\n', '        _TIMELOCK_ = block.timestamp + _TIMELOCK_DURATION_;\n', '        _PENDING_ADD_DODO_PROXY_ = newDodoProxy;\n', '    }\n', '\n', '    function lockAddProxy() public onlyOwner {\n', '       _PENDING_ADD_DODO_PROXY_ = address(0);\n', '       _TIMELOCK_ = 0;\n', '    }\n', '\n', '\n', '    function addDODOProxy() external onlyOwner notLocked() {\n', '        _IS_ALLOWED_PROXY_[_PENDING_ADD_DODO_PROXY_] = true;\n', '        lockAddProxy();\n', '    }\n', '\n', '    function removeDODOProxy (address oldDodoProxy) public onlyOwner {\n', '        _IS_ALLOWED_PROXY_[oldDodoProxy] = false;\n', '    }\n', '    \n', '    function claimTokens(\n', '        address token,\n', '        address who,\n', '        address dest,\n', '        uint256 amount\n', '    ) external {\n', '        require(_IS_ALLOWED_PROXY_[msg.sender], "DODOApproveProxy:Access restricted");\n', '        IDODOApprove(_DODO_APPROVE_).claimTokens(\n', '            token,\n', '            who,\n', '            dest,\n', '            amount\n', '        );\n', '    }\n', '\n', '    function isAllowedProxy(address _proxy) external view returns (bool) {\n', '        return _IS_ALLOWED_PROXY_[_proxy];\n', '    }\n', '}\n', '\n', '// File: contracts/SmartRoute/intf/IDODOV2.sol\n', '\n', 'interface IDODOV2 {\n', '\n', '    //========== Common ==================\n', '\n', '    function sellBase(address to) external returns (uint256 receiveQuoteAmount);\n', '\n', '    function sellQuote(address to) external returns (uint256 receiveBaseAmount);\n', '\n', '    function getVaultReserve() external view returns (uint256 baseReserve, uint256 quoteReserve);\n', '\n', '    function _BASE_TOKEN_() external view returns (address);\n', '\n', '    function _QUOTE_TOKEN_() external view returns (address);\n', '\n', '    function getPMMStateForCall() external view returns (\n', '            uint256 i,\n', '            uint256 K,\n', '            uint256 B,\n', '            uint256 Q,\n', '            uint256 B0,\n', '            uint256 Q0,\n', '            uint256 R\n', '    );\n', '\n', '    function getUserFeeRate(address user) external view returns (uint256 lpFeeRate, uint256 mtFeeRate);\n', '\n', '    \n', '    function getDODOPoolBidirection(address token0, address token1) external view returns (address[] memory, address[] memory);\n', '\n', '    //========== DODOVendingMachine ========\n', '    \n', '    function createDODOVendingMachine(\n', '        address baseToken,\n', '        address quoteToken,\n', '        uint256 lpFeeRate,\n', '        uint256 i,\n', '        uint256 k,\n', '        bool isOpenTWAP\n', '    ) external returns (address newVendingMachine);\n', '    \n', '    function buyShares(address to) external returns (uint256,uint256,uint256);\n', '\n', '\n', '    //========== DODOPrivatePool ===========\n', '\n', '    function createDODOPrivatePool() external returns (address newPrivatePool);\n', '\n', '    function initDODOPrivatePool(\n', '        address dppAddress,\n', '        address creator,\n', '        address baseToken,\n', '        address quoteToken,\n', '        uint256 lpFeeRate,\n', '        uint256 k,\n', '        uint256 i,\n', '        bool isOpenTwap\n', '    ) external;\n', '\n', '    function reset(\n', '        address operator,\n', '        uint256 newLpFeeRate,\n', '        uint256 newI,\n', '        uint256 newK,\n', '        uint256 baseOutAmount,\n', '        uint256 quoteOutAmount,\n', '        uint256 minBaseReserve,\n', '        uint256 minQuoteReserve\n', '    ) external returns (bool); \n', '\n', '\n', '    function _OWNER_() external returns (address);\n', '    \n', '    //========== CrowdPooling ===========\n', '\n', '    function createCrowdPooling() external returns (address payable newCrowdPooling);\n', '\n', '    function initCrowdPooling(\n', '        address cpAddress,\n', '        address creator,\n', '        address baseToken,\n', '        address quoteToken,\n', '        uint256[] memory timeLine,\n', '        uint256[] memory valueList,\n', '        bool isOpenTWAP\n', '    ) external;\n', '\n', '    function bid(address to) external;\n', '}\n', '\n', '// File: contracts/intf/IERC20.sol\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '}\n', '\n', '// File: contracts/lib/SafeMath.sol\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "MUL_ERROR");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "DIVIDING_ERROR");\n', '        return a / b;\n', '    }\n', '\n', '    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 quotient = div(a, b);\n', '        uint256 remainder = a - quotient * b;\n', '        if (remainder > 0) {\n', '            return quotient + 1;\n', '        } else {\n', '            return quotient;\n', '        }\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SUB_ERROR");\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "ADD_ERROR");\n', '        return c;\n', '    }\n', '\n', '    function sqrt(uint256 x) internal pure returns (uint256 y) {\n', '        uint256 z = x / 2 + 1;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/lib/SafeERC20.sol\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require(\n', '            (value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/intf/IWETH.sol\n', '\n', '\n', '\n', 'interface IWETH {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address src,\n', '        address dst,\n', '        uint256 wad\n', '    ) external returns (bool);\n', '\n', '    function deposit() external payable;\n', '\n', '    function withdraw(uint256 wad) external;\n', '}\n', '\n', '// File: contracts/lib/ReentrancyGuard.sol\n', '\n', '\n', '/**\n', ' * @title ReentrancyGuard\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Protect functions from Reentrancy Attack\n', ' */\n', 'contract ReentrancyGuard {\n', '    // https://solidity.readthedocs.io/en/latest/control-structures.html?highlight=zero-state#scoping-and-declarations\n', '    // zero-state of _ENTERED_ is false\n', '    bool private _ENTERED_;\n', '\n', '    modifier preventReentrant() {\n', '        require(!_ENTERED_, "REENTRANT");\n', '        _ENTERED_ = true;\n', '        _;\n', '        _ENTERED_ = false;\n', '    }\n', '}\n', '\n', '// File: contracts/SmartRoute/proxies/DODOCpProxy.sol\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title DODOCpProxy\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice CrowdPooling && UpCrowdPooling Proxy\n', ' */\n', 'contract DODOCpProxy is ReentrancyGuard {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    // ============ Storage ============\n', '\n', '    address constant _ETH_ADDRESS_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '    address public immutable _WETH_;\n', '    address public immutable _DODO_APPROVE_PROXY_;\n', '    address public immutable _UPCP_FACTORY_;\n', '    address public immutable _CP_FACTORY_;\n', '\n', '    // ============ Modifiers ============\n', '\n', '    modifier judgeExpired(uint256 deadLine) {\n', '        require(deadLine >= block.timestamp, "DODOCpProxy: EXPIRED");\n', '        _;\n', '    }\n', '\n', '    fallback() external payable {}\n', '\n', '    receive() external payable {}\n', '\n', '    constructor(\n', '        address payable weth,\n', '        address cpFactory,\n', '        address upCpFactory,\n', '        address dodoApproveProxy\n', '    ) public {\n', '        _WETH_ = weth;\n', '        _CP_FACTORY_ = cpFactory;\n', '        _UPCP_FACTORY_ = upCpFactory;\n', '        _DODO_APPROVE_PROXY_ = dodoApproveProxy;\n', '    }\n', '\n', '    //============ UpCrowdPooling Functions (create) ============\n', '\n', '    function createUpCrowdPooling(\n', '        address baseToken,\n', '        address quoteToken,\n', '        uint256 baseInAmount,\n', '        uint256[] memory timeLine,\n', '        uint256[] memory valueList,\n', '        bool isOpenTWAP,\n', '        uint256 deadLine\n', '    ) external payable preventReentrant judgeExpired(deadLine) returns (address payable newUpCrowdPooling) {\n', '        address _baseToken = baseToken;\n', '        address _quoteToken = quoteToken == _ETH_ADDRESS_ ? _WETH_ : quoteToken;\n', '        \n', '        newUpCrowdPooling = IDODOV2(_UPCP_FACTORY_).createCrowdPooling();\n', '\n', '        _deposit(\n', '            msg.sender,\n', '            newUpCrowdPooling,\n', '            _baseToken,\n', '            baseInAmount,\n', '            false\n', '        );\n', '\n', '        (bool success, ) = newUpCrowdPooling.call{value: msg.value}("");\n', '        require(success, "DODOCpProxy: Transfer failed");\n', '\n', '        IDODOV2(_UPCP_FACTORY_).initCrowdPooling(\n', '            newUpCrowdPooling,\n', '            msg.sender,\n', '            _baseToken,\n', '            _quoteToken,\n', '            timeLine,\n', '            valueList,\n', '            isOpenTWAP\n', '        );\n', '    }\n', '\n', '    //============ CrowdPooling Functions (create) ============\n', '\n', '    function createCrowdPooling(\n', '        address baseToken,\n', '        address quoteToken,\n', '        uint256 baseInAmount,\n', '        uint256[] memory timeLine,\n', '        uint256[] memory valueList,\n', '        bool isOpenTWAP,\n', '        uint256 deadLine\n', '    ) external payable preventReentrant judgeExpired(deadLine) returns (address payable newCrowdPooling) {\n', '        address _baseToken = baseToken;\n', '        address _quoteToken = quoteToken == _ETH_ADDRESS_ ? _WETH_ : quoteToken;\n', '        \n', '        newCrowdPooling = IDODOV2(_CP_FACTORY_).createCrowdPooling();\n', '\n', '        _deposit(\n', '            msg.sender,\n', '            newCrowdPooling,\n', '            _baseToken,\n', '            baseInAmount,\n', '            false\n', '        );\n', '        \n', '        (bool success, ) = newCrowdPooling.call{value: msg.value}("");\n', '        require(success, "DODOCpProxy: Transfer failed");\n', '\n', '        IDODOV2(_CP_FACTORY_).initCrowdPooling(\n', '            newCrowdPooling,\n', '            msg.sender,\n', '            _baseToken,\n', '            _quoteToken,\n', '            timeLine,\n', '            valueList,\n', '            isOpenTWAP\n', '        );\n', '    }\n', '\n', '    //====================== internal =======================\n', '\n', '    function _deposit(\n', '        address from,\n', '        address to,\n', '        address token,\n', '        uint256 amount,\n', '        bool isETH\n', '    ) internal {\n', '        if (isETH) {\n', '            if (amount > 0) {\n', '                IWETH(_WETH_).deposit{value: amount}();\n', '                if (to != address(this)) SafeERC20.safeTransfer(IERC20(_WETH_), to, amount);\n', '            }\n', '        } else {\n', '            IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(token, from, to, amount);\n', '        }\n', '    }\n', '}']
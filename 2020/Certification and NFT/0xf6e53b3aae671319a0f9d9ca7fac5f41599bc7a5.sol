['pragma solidity 0.5.16;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'library MerkleProof {\n', '    /**\n', '     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree\n', '     * defined by `root`. For this, a `proof` must be provided, containing\n', '     * sibling hashes on the branch from the leaf to the root of the tree. Each\n', '     * pair of leaves and each pair of pre-images are assumed to be sorted.\n', '     */\n', '    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {\n', '        bytes32 computedHash = leaf;\n', '\n', '        for (uint256 i = 0; i < proof.length; i++) {\n', '            bytes32 proofElement = proof[i];\n', '\n', '            if (computedHash <= proofElement) {\n', '                // Hash(current computed hash + current element of the proof)\n', '                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));\n', '            } else {\n', '                // Hash(current element of the proof + current computed hash)\n', '                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));\n', '            }\n', '        }\n', '\n', '        // Check if the computed hash (root) is equal to the provided root\n', '        return computedHash == root;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following \n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts an `address` into `address payable`. Note that this is\n', '     * simply a type cast: the actual underlying value is not changed.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'contract Initializable {\n', '\n', '  /**\n', '   * @dev Indicates that the contract has been initialized.\n', '   */\n', '  bool private initialized;\n', '\n', '  /**\n', '   * @dev Indicates that the contract is in the process of being initialized.\n', '   */\n', '  bool private initializing;\n', '\n', '  /**\n', '   * @dev Modifier to use in the initializer function of a contract.\n', '   */\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool isTopLevelCall = !initializing;\n', '    if (isTopLevelCall) {\n', '      initializing = true;\n', '      initialized = true;\n', '    }\n', '\n', '    _;\n', '\n', '    if (isTopLevelCall) {\n', '      initializing = false;\n', '    }\n', '  }\n', '\n', '  /// @dev Returns true if and only if the function is running in the constructor\n', '  function isConstructor() private view returns (bool) {\n', '    // extcodesize checks the size of the code stored in an address, and\n', '    // address returns the current address. Since the code is still not\n', '    // deployed when running a constructor, any checks on its code size will\n', '    // yield zero, making it an effective way to detect if a contract is\n', '    // under construction or not.\n', '    address self = address(this);\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(self) }\n', '    return cs == 0;\n', '  }\n', '\n', '  // Reserved storage space to allow for layout changes in the future.\n', '  uint256[50] private ______gap;\n', '}\n', '\n', 'contract InitializableModuleKeys {\n', '\n', '    // Governance                             // Phases\n', '    bytes32 internal KEY_GOVERNANCE;          // 2.x\n', '    bytes32 internal KEY_STAKING;             // 1.2\n', '    bytes32 internal KEY_PROXY_ADMIN;         // 1.0\n', '\n', '    // mStable\n', '    bytes32 internal KEY_ORACLE_HUB;          // 1.2\n', '    bytes32 internal KEY_MANAGER;             // 1.2\n', '    bytes32 internal KEY_RECOLLATERALISER;    // 2.x\n', '    bytes32 internal KEY_META_TOKEN;          // 1.1\n', '    bytes32 internal KEY_SAVINGS_MANAGER;     // 1.0\n', '\n', '    /**\n', '     * @dev Initialize function for upgradable proxy contracts. This function should be called\n', '     *      via Proxy to initialize constants in the Proxy contract.\n', '     */\n', '    function _initialize() internal {\n', '        // keccak256() values are evaluated only once at the time of this function call.\n', '        // Hence, no need to assign hard-coded values to these variables.\n', '        KEY_GOVERNANCE = keccak256("Governance");\n', '        KEY_STAKING = keccak256("Staking");\n', '        KEY_PROXY_ADMIN = keccak256("ProxyAdmin");\n', '\n', '        KEY_ORACLE_HUB = keccak256("OracleHub");\n', '        KEY_MANAGER = keccak256("Manager");\n', '        KEY_RECOLLATERALISER = keccak256("Recollateraliser");\n', '        KEY_META_TOKEN = keccak256("MetaToken");\n', '        KEY_SAVINGS_MANAGER = keccak256("SavingsManager");\n', '    }\n', '}\n', '\n', 'interface INexus {\n', '    function governor() external view returns (address);\n', '    function getModule(bytes32 key) external view returns (address);\n', '\n', '    function proposeModule(bytes32 _key, address _addr) external;\n', '    function cancelProposedModule(bytes32 _key) external;\n', '    function acceptProposedModule(bytes32 _key) external;\n', '    function acceptProposedModules(bytes32[] calldata _keys) external;\n', '\n', '    function requestLockModule(bytes32 _key) external;\n', '    function cancelLockModule(bytes32 _key) external;\n', '    function lockModule(bytes32 _key) external;\n', '}\n', '\n', 'contract InitializableModule is InitializableModuleKeys {\n', '\n', '    INexus public nexus;\n', '\n', '    /**\n', '     * @dev Modifier to allow function calls only from the Governor.\n', '     */\n', '    modifier onlyGovernor() {\n', '        require(msg.sender == _governor(), "Only governor can execute");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to allow function calls only from the Governance.\n', '     *      Governance is either Governor address or Governance address.\n', '     */\n', '    modifier onlyGovernance() {\n', '        require(\n', '            msg.sender == _governor() || msg.sender == _governance(),\n', '            "Only governance can execute"\n', '        );\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to allow function calls only from the ProxyAdmin.\n', '     */\n', '    modifier onlyProxyAdmin() {\n', '        require(\n', '            msg.sender == _proxyAdmin(), "Only ProxyAdmin can execute"\n', '        );\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to allow function calls only from the Manager.\n', '     */\n', '    modifier onlyManager() {\n', '        require(msg.sender == _manager(), "Only manager can execute");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Initialization function for upgradable proxy contracts\n', '     * @param _nexus Nexus contract address\n', '     */\n', '    function _initialize(address _nexus) internal {\n', '        require(_nexus != address(0), "Nexus address is zero");\n', '        nexus = INexus(_nexus);\n', '        InitializableModuleKeys._initialize();\n', '    }\n', '\n', '    /**\n', '     * @dev Returns Governor address from the Nexus\n', '     * @return Address of Governor Contract\n', '     */\n', '    function _governor() internal view returns (address) {\n', '        return nexus.governor();\n', '    }\n', '\n', '    /**\n', '     * @dev Returns Governance Module address from the Nexus\n', '     * @return Address of the Governance (Phase 2)\n', '     */\n', '    function _governance() internal view returns (address) {\n', '        return nexus.getModule(KEY_GOVERNANCE);\n', '    }\n', '\n', '    /**\n', '     * @dev Return Staking Module address from the Nexus\n', '     * @return Address of the Staking Module contract\n', '     */\n', '    function _staking() internal view returns (address) {\n', '        return nexus.getModule(KEY_STAKING);\n', '    }\n', '\n', '    /**\n', '     * @dev Return ProxyAdmin Module address from the Nexus\n', '     * @return Address of the ProxyAdmin Module contract\n', '     */\n', '    function _proxyAdmin() internal view returns (address) {\n', '        return nexus.getModule(KEY_PROXY_ADMIN);\n', '    }\n', '\n', '    /**\n', '     * @dev Return MetaToken Module address from the Nexus\n', '     * @return Address of the MetaToken Module contract\n', '     */\n', '    function _metaToken() internal view returns (address) {\n', '        return nexus.getModule(KEY_META_TOKEN);\n', '    }\n', '\n', '    /**\n', '     * @dev Return OracleHub Module address from the Nexus\n', '     * @return Address of the OracleHub Module contract\n', '     */\n', '    function _oracleHub() internal view returns (address) {\n', '        return nexus.getModule(KEY_ORACLE_HUB);\n', '    }\n', '\n', '    /**\n', '     * @dev Return Manager Module address from the Nexus\n', '     * @return Address of the Manager Module contract\n', '     */\n', '    function _manager() internal view returns (address) {\n', '        return nexus.getModule(KEY_MANAGER);\n', '    }\n', '\n', '    /**\n', '     * @dev Return SavingsManager Module address from the Nexus\n', '     * @return Address of the SavingsManager Module contract\n', '     */\n', '    function _savingsManager() internal view returns (address) {\n', '        return nexus.getModule(KEY_SAVINGS_MANAGER);\n', '    }\n', '\n', '    /**\n', '     * @dev Return Recollateraliser Module address from the Nexus\n', '     * @return  Address of the Recollateraliser Module contract (Phase 2)\n', '     */\n', '    function _recollateraliser() internal view returns (address) {\n', '        return nexus.getModule(KEY_RECOLLATERALISER);\n', '    }\n', '}\n', '\n', 'contract InitializableGovernableWhitelist is InitializableModule {\n', '\n', '    event Whitelisted(address indexed _address);\n', '\n', '    mapping(address => bool) public whitelist;\n', '\n', '    /**\n', '     * @dev Modifier to allow function calls only from the whitelisted address.\n', '     */\n', '    modifier onlyWhitelisted() {\n', '        require(whitelist[msg.sender], "Not a whitelisted address");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Initialization function for upgradable proxy contracts\n', '     * @param _nexus Nexus contract address\n', '     * @param _whitelisted Array of whitelisted addresses.\n', '     */\n', '    function _initialize(\n', '        address _nexus,\n', '        address[] memory _whitelisted\n', '    )\n', '        internal\n', '    {\n', '        InitializableModule._initialize(_nexus);\n', '\n', '        require(_whitelisted.length > 0, "Empty whitelist array");\n', '\n', '        for(uint256 i = 0; i < _whitelisted.length; i++) {\n', '            _addWhitelist(_whitelisted[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Adds a new whitelist address\n', '     * @param _address Address to add in whitelist\n', '     */\n', '    function _addWhitelist(address _address) internal {\n', '        require(_address != address(0), "Address is zero");\n', '        require(! whitelist[_address], "Already whitelisted");\n', '\n', '        whitelist[_address] = true;\n', '\n', '        emit Whitelisted(_address);\n', '    }\n', '\n', '}\n', '\n', 'contract MerkleDrop is Initializable, InitializableGovernableWhitelist {\n', '\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint256;\n', '\n', '    event Claimed(address claimant, uint256 week, uint256 balance);\n', '    event TrancheAdded(uint256 tranche, bytes32 merkleRoot, uint256 totalAmount);\n', '    event TrancheExpired(uint256 tranche);\n', '    event RemovedFunder(address indexed _address);\n', '\n', '    IERC20 public token;\n', '\n', '    mapping(uint256 => bytes32) public merkleRoots;\n', '    mapping(uint256 => mapping(address => bool)) public claimed;\n', '    uint256 tranches;\n', '\n', '    function initialize(\n', '        address _nexus,\n', '        address[] calldata _funders,\n', '        IERC20 _token\n', '    )\n', '        external\n', '        initializer\n', '    {\n', '        InitializableGovernableWhitelist._initialize(_nexus, _funders);\n', '        token = _token;\n', '    }\n', '\n', '    /***************************************\n', '                    ADMIN\n', '    ****************************************/\n', '\n', '    function seedNewAllocations(bytes32 _merkleRoot, uint256 _totalAllocation)\n', '        public\n', '        onlyWhitelisted\n', '        returns (uint256 trancheId)\n', '    {\n', '        token.safeTransferFrom(msg.sender, address(this), _totalAllocation);\n', '\n', '        trancheId = tranches;\n', '        merkleRoots[trancheId] = _merkleRoot;\n', '\n', '        tranches = tranches.add(1);\n', '\n', '        emit TrancheAdded(trancheId, _merkleRoot, _totalAllocation);\n', '    }\n', '\n', '    function expireTranche(uint256 _trancheId)\n', '        public\n', '        onlyWhitelisted\n', '    {\n', '        merkleRoots[_trancheId] = bytes32(0);\n', '\n', '        emit TrancheExpired(_trancheId);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the mStable governance to add a new Funder\n', '     * @param _address  Funder to add\n', '     */\n', '    function addFunder(address _address)\n', '        external\n', '        onlyGovernor\n', '    {\n', '        _addWhitelist(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the mStable governance to remove inactive Funder\n', '     * @param _address  Funder to remove\n', '     */\n', '    function removeFunder(address _address)\n', '        external\n', '        onlyGovernor\n', '    {\n', '        require(_address != address(0), "Address is zero");\n', '        require(whitelist[_address], "Address is not whitelisted");\n', '\n', '        whitelist[_address] = false;\n', '\n', '        emit RemovedFunder(_address);\n', '    }\n', '\n', '\n', '    /***************************************\n', '                  CLAIMING\n', '    ****************************************/\n', '\n', '\n', '    function claimWeek(\n', '        address _liquidityProvider,\n', '        uint256 _tranche,\n', '        uint256 _balance,\n', '        bytes32[] memory _merkleProof\n', '    )\n', '        public\n', '    {\n', '        _claimWeek(_liquidityProvider, _tranche, _balance, _merkleProof);\n', '        _disburse(_liquidityProvider, _balance);\n', '    }\n', '\n', '\n', '    function claimWeeks(\n', '        address _liquidityProvider,\n', '        uint256[] memory _tranches,\n', '        uint256[] memory _balances,\n', '        bytes32[][] memory _merkleProofs\n', '    )\n', '        public\n', '    {\n', '        uint256 len = _tranches.length;\n', '        require(len == _balances.length && len == _merkleProofs.length, "Mismatching inputs");\n', '\n', '        uint256 totalBalance = 0;\n', '        for(uint256 i = 0; i < len; i++) {\n', '            _claimWeek(_liquidityProvider, _tranches[i], _balances[i], _merkleProofs[i]);\n', '            totalBalance = totalBalance.add(_balances[i]);\n', '        }\n', '        _disburse(_liquidityProvider, totalBalance);\n', '    }\n', '\n', '\n', '    function verifyClaim(\n', '        address _liquidityProvider,\n', '        uint256 _tranche,\n', '        uint256 _balance,\n', '        bytes32[] memory _merkleProof\n', '    )\n', '        public\n', '        view\n', '        returns (bool valid)\n', '    {\n', '        return _verifyClaim(_liquidityProvider, _tranche, _balance, _merkleProof);\n', '    }\n', '\n', '\n', '    /***************************************\n', '              CLAIMING - INTERNAL\n', '    ****************************************/\n', '\n', '\n', '    function _claimWeek(\n', '        address _liquidityProvider,\n', '        uint256 _tranche,\n', '        uint256 _balance,\n', '        bytes32[] memory _merkleProof\n', '    )\n', '        private\n', '    {\n', '        require(_tranche < tranches, "Week cannot be in the future");\n', '\n', '        require(!claimed[_tranche][_liquidityProvider], "LP has already claimed");\n', '        require(_verifyClaim(_liquidityProvider, _tranche, _balance, _merkleProof), "Incorrect merkle proof");\n', '\n', '        claimed[_tranche][_liquidityProvider] = true;\n', '\n', '        emit Claimed(_liquidityProvider, _tranche, _balance);\n', '    }\n', '\n', '\n', '    function _verifyClaim(\n', '        address _liquidityProvider,\n', '        uint256 _tranche,\n', '        uint256 _balance,\n', '        bytes32[] memory _merkleProof\n', '    )\n', '        private\n', '        view\n', '        returns (bool valid)\n', '    {\n', '        bytes32 leaf = keccak256(abi.encodePacked(_liquidityProvider, _balance));\n', '        return MerkleProof.verify(_merkleProof, merkleRoots[_tranche], leaf);\n', '    }\n', '\n', '\n', '    function _disburse(address _liquidityProvider, uint256 _balance) private {\n', '        if (_balance > 0) {\n', '            token.safeTransfer(_liquidityProvider, _balance);\n', '        } else {\n', '            revert("No balance would be transfered - not gonna waste your gas");\n', '        }\n', '    }\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-12\n', '*/\n', '\n', '// SPDX-License-Identifier: AGPL-3.0-or-later\n', 'pragma solidity 0.7.5;\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function decimals() external view returns (uint8);\n', '  /**\n', '   * @dev Returns the amount of tokens in existence.\n', '   */\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  /**\n', '   * @dev Returns the amount of tokens owned by `account`.\n', '   */\n', '  function balanceOf(address account) external view returns (uint256);\n', '\n', '  /**\n', "   * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '   *\n', '   * Returns a boolean value indicating whether the operation succeeded.\n', '   *\n', '   * Emits a {Transfer} event.\n', '   */\n', '  function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Returns the remaining number of tokens that `spender` will be\n', '   * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '   * zero by default.\n', '   *\n', '   * This value changes when {approve} or {transferFrom} are called.\n', '   */\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '  /**\n', "   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '   *\n', '   * Returns a boolean value indicating whether the operation succeeded.\n', '   *\n', '   * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '   * that someone may use both the old and the new allowance by unfortunate\n', '   * transaction ordering. One possible solution to mitigate this race\n', "   * condition is to first reduce the spender's allowance to 0 and set the\n", '   * desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   *\n', '   * Emits an {Approval} event.\n', '   */\n', '  function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "   * allowance mechanism. `amount` is then deducted from the caller's\n", '   * allowance.\n', '   *\n', '   * Returns a boolean value indicating whether the operation succeeded.\n', '   *\n', '   * Emits a {Transfer} event.\n', '   */\n', '  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '   * another (`to`).\n', '   *\n', '   * Note that `value` may be zero.\n', '   */\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '   * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '   * a call to {approve}. `value` is the new allowance.\n', '   */\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '\n', '  /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '\n', '    function addressToString(address _address) internal pure returns(string memory) {\n', '        bytes32 _bytes = bytes32(uint256(_address));\n', '        bytes memory HEX = "0123456789abcdef";\n', '        bytes memory _addr = new bytes(42);\n', '\n', "        _addr[0] = '0';\n", "        _addr[1] = 'x';\n", '\n', '        for(uint256 i = 0; i < 20; i++) {\n', '            _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];\n', '            _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];\n', '        }\n', '\n', '        return string(_addr);\n', '\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface IOwnable {\n', '  function manager() external view returns (address);\n', '\n', '  function renounceManagement() external;\n', '  \n', '  function pushManagement( address newOwner_ ) external;\n', '  \n', '  function pullManagement() external;\n', '}\n', '\n', 'contract Ownable is IOwnable {\n', '\n', '    address internal _owner;\n', '    address internal _newOwner;\n', '\n', '    event OwnershipPushed(address indexed previousOwner, address indexed newOwner);\n', '    event OwnershipPulled(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () {\n', '        _owner = msg.sender;\n', '        emit OwnershipPushed( address(0), _owner );\n', '    }\n', '\n', '    function manager() public view override returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyManager() {\n', '        require( _owner == msg.sender, "Ownable: caller is not the owner" );\n', '        _;\n', '    }\n', '\n', '    function renounceManagement() public virtual override onlyManager() {\n', '        emit OwnershipPushed( _owner, address(0) );\n', '        _owner = address(0);\n', '    }\n', '\n', '    function pushManagement( address newOwner_ ) public virtual override onlyManager() {\n', '        require( newOwner_ != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipPushed( _owner, newOwner_ );\n', '        _newOwner = newOwner_;\n', '    }\n', '    \n', '    function pullManagement() public virtual override {\n', '        require( msg.sender == _newOwner, "Ownable: must be new owner to pull");\n', '        emit OwnershipPulled( _owner, _newOwner );\n', '        _owner = _newOwner;\n', '    }\n', '}\n', '\n', 'interface IsOHM {\n', '    function rebase( uint256 ohmProfit_, uint epoch_) external returns (uint256);\n', '\n', '    function circulatingSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function gonsForBalance( uint amount ) external view returns ( uint );\n', '\n', '    function balanceForGons( uint gons ) external view returns ( uint );\n', '    \n', '    function index() external view returns ( uint );\n', '}\n', '\n', 'interface IWarmup {\n', '    function retrieve( address staker_, uint amount_ ) external;\n', '}\n', '\n', 'interface IDistributor {\n', '    function distribute() external returns ( bool );\n', '}\n', '\n', 'contract OlympusStaking is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '\n', '    address public immutable OHM;\n', '    address public immutable sOHM;\n', '\n', '    struct Epoch {\n', '        uint length;\n', '        uint number;\n', '        uint endBlock;\n', '        uint distribute;\n', '    }\n', '    Epoch public epoch;\n', '\n', '    address public distributor;\n', '    \n', '    address public locker;\n', '    uint public totalBonus;\n', '    \n', '    address public warmupContract;\n', '    uint public warmupPeriod;\n', '    \n', '    constructor ( \n', '        address _OHM, \n', '        address _sOHM, \n', '        uint _epochLength,\n', '        uint _firstEpochNumber,\n', '        uint _firstEpochBlock\n', '    ) {\n', '        require( _OHM != address(0) );\n', '        OHM = _OHM;\n', '        require( _sOHM != address(0) );\n', '        sOHM = _sOHM;\n', '        \n', '        epoch = Epoch({\n', '            length: _epochLength,\n', '            number: _firstEpochNumber,\n', '            endBlock: _firstEpochBlock,\n', '            distribute: 0\n', '        });\n', '    }\n', '\n', '    struct Claim {\n', '        uint deposit;\n', '        uint gons;\n', '        uint expiry;\n', '        bool lock; // prevents malicious delays\n', '    }\n', '    mapping( address => Claim ) public warmupInfo;\n', '\n', '    /**\n', '        @notice stake OHM to enter warmup\n', '        @param _amount uint\n', '        @return bool\n', '     */\n', '    function stake( uint _amount, address _recipient ) external returns ( bool ) {\n', '        rebase();\n', '        \n', '        IERC20( OHM ).safeTransferFrom( msg.sender, address(this), _amount );\n', '\n', '        Claim memory info = warmupInfo[ _recipient ];\n', '        require( !info.lock, "Deposits for account are locked" );\n', '\n', '        warmupInfo[ _recipient ] = Claim ({\n', '            deposit: info.deposit.add( _amount ),\n', '            gons: info.gons.add( IsOHM( sOHM ).gonsForBalance( _amount ) ),\n', '            expiry: epoch.number.add( warmupPeriod ),\n', '            lock: false\n', '        });\n', '        \n', '        IERC20( sOHM ).safeTransfer( warmupContract, _amount );\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @notice retrieve sOHM from warmup\n', '        @param _recipient address\n', '     */\n', '    function claim ( address _recipient ) public {\n', '        Claim memory info = warmupInfo[ _recipient ];\n', '        if ( epoch.number >= info.expiry && info.expiry != 0 ) {\n', '            delete warmupInfo[ _recipient ];\n', '            IWarmup( warmupContract ).retrieve( _recipient, IsOHM( sOHM ).balanceForGons( info.gons ) );\n', '        }\n', '    }\n', '\n', '    /**\n', '        @notice forfeit sOHM in warmup and retrieve OHM\n', '     */\n', '    function forfeit() external {\n', '        Claim memory info = warmupInfo[ msg.sender ];\n', '        delete warmupInfo[ msg.sender ];\n', '\n', '        IWarmup( warmupContract ).retrieve( address(this), IsOHM( sOHM ).balanceForGons( info.gons ) );\n', '        IERC20( OHM ).safeTransfer( msg.sender, info.deposit );\n', '    }\n', '\n', '    /**\n', '        @notice prevent new deposits to address (protection from malicious activity)\n', '     */\n', '    function toggleDepositLock() external {\n', '        warmupInfo[ msg.sender ].lock = !warmupInfo[ msg.sender ].lock;\n', '    }\n', '\n', '    /**\n', '        @notice redeem sOHM for OHM\n', '        @param _amount uint\n', '        @param _trigger bool\n', '     */\n', '    function unstake( uint _amount, bool _trigger ) external {\n', '        if ( _trigger ) {\n', '            rebase();\n', '        }\n', '        IERC20( sOHM ).safeTransferFrom( msg.sender, address(this), _amount );\n', '        IERC20( OHM ).safeTransfer( msg.sender, _amount );\n', '    }\n', '\n', '    /**\n', '        @notice returns the sOHM index, which tracks rebase growth\n', '        @return uint\n', '     */\n', '    function index() public view returns ( uint ) {\n', '        return IsOHM( sOHM ).index();\n', '    }\n', '\n', '    /**\n', '        @notice trigger rebase if epoch over\n', '     */\n', '    function rebase() public {\n', '        if( epoch.endBlock <= block.number ) {\n', '\n', '            IsOHM( sOHM ).rebase( epoch.distribute, epoch.number );\n', '\n', '            epoch.endBlock = epoch.endBlock.add( epoch.length );\n', '            epoch.number++;\n', '            \n', '            if ( distributor != address(0) ) {\n', '                IDistributor( distributor ).distribute();\n', '            }\n', '\n', '            uint balance = contractBalance();\n', '            uint staked = IsOHM( sOHM ).circulatingSupply();\n', '\n', '            if( balance <= staked ) {\n', '                epoch.distribute = 0;\n', '            } else {\n', '                epoch.distribute = balance.sub( staked );\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '        @notice returns contract OHM holdings, including bonuses provided\n', '        @return uint\n', '     */\n', '    function contractBalance() public view returns ( uint ) {\n', '        return IERC20( OHM ).balanceOf( address(this) ).add( totalBonus );\n', '    }\n', '\n', '    /**\n', '        @notice provide bonus to locked staking contract\n', '        @param _amount uint\n', '     */\n', '    function giveLockBonus( uint _amount ) external {\n', '        require( msg.sender == locker );\n', '        totalBonus = totalBonus.add( _amount );\n', '        IERC20( sOHM ).safeTransfer( locker, _amount );\n', '    }\n', '\n', '    /**\n', '        @notice reclaim bonus from locked staking contract\n', '        @param _amount uint\n', '     */\n', '    function returnLockBonus( uint _amount ) external {\n', '        require( msg.sender == locker );\n', '        totalBonus = totalBonus.sub( _amount );\n', '        IERC20( sOHM ).safeTransferFrom( locker, address(this), _amount );\n', '    }\n', '\n', '    enum CONTRACTS { DISTRIBUTOR, WARMUP, LOCKER }\n', '\n', '    /**\n', '        @notice sets the contract address for LP staking\n', '        @param _contract address\n', '     */\n', '    function setContract( CONTRACTS _contract, address _address ) external onlyManager() {\n', '        if( _contract == CONTRACTS.DISTRIBUTOR ) { // 0\n', '            distributor = _address;\n', '        } else if ( _contract == CONTRACTS.WARMUP ) { // 1\n', '            require( warmupContract == address( 0 ), "Warmup cannot be set more than once" );\n', '            warmupContract = _address;\n', '        } else if ( _contract == CONTRACTS.LOCKER ) { // 2\n', '            require( locker == address(0), "Locker cannot be set more than once" );\n', '            locker = _address;\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * @notice set warmup period for new stakers\n', '     * @param _warmupPeriod uint\n', '     */\n', '    function setWarmup( uint _warmupPeriod ) external onlyManager() {\n', '        warmupPeriod = _warmupPeriod;\n', '    }\n', '}']
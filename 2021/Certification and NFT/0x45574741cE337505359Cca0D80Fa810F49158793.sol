['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-10\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.3;\n', '\n', '/**\n', ' * This code contains elements of ERC20BurnableUpgradeable.sol https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/token/ERC20/ERC20BurnableUpgradeable.sol\n', ' * Those have been inlined for the purpose of gas optimization.\n', ' */\n', '\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library AddressUpgradeable {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed\n', " * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an\n", ' * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer\n', ' * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.\n', ' *\n', ' * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as\n', ' * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.\n', ' *\n', ' * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure\n', ' * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.\n', ' */\n', 'abstract contract Initializable {\n', '\n', '    /**\n', '     * @dev Indicates that the contract has been initialized.\n', '     */\n', '    bool private _initialized;\n', '\n', '    /**\n', '     * @dev Indicates that the contract is in the process of being initialized.\n', '     */\n', '    bool private _initializing;\n', '\n', '    /**\n', '     * @dev Modifier to protect an initializer function from being invoked twice.\n', '     */\n', '    modifier initializer() {\n', '        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");\n', '\n', '        bool isTopLevelCall = !_initializing;\n', '        if (isTopLevelCall) {\n', '            _initializing = true;\n', '            _initialized = true;\n', '        }\n', '\n', '        _;\n', '\n', '        if (isTopLevelCall) {\n', '            _initializing = false;\n', '        }\n', '    }\n', '\n', '    /// @dev Returns true if and only if the function is running in the constructor\n', '    function _isConstructor() private view returns (bool) {\n', '        return !AddressUpgradeable.isContract(address(this));\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ProofOfHumanity Interface\n', ' * @dev See https://github.com/Proof-Of-Humanity/Proof-Of-Humanity.\n', ' */\n', 'interface IProofOfHumanity {\n', '  function isRegistered(address _submissionID)\n', '    external\n', '    view\n', '    returns (\n', '      bool registered\n', '    );\n', '}\n', '\n', '/**\n', ' * @title Universal Basic Income\n', ' * @dev UBI is an ERC20 compatible token that is connected to a Proof of Humanity registry. \n', ' *\n', ' * Tokens are issued and drip over time for every verified submission on a Proof of Humanity registry.\n', ' * The accrued tokens are updated directly on every wallet using the `balanceOf` function.\n', ' * The tokens get effectively minted and persisted in memory when someone interacts with the contract doing a `transfer` or `burn`. \n', ' */\n', 'contract UBI is Initializable {\n', '\n', '  /* Events */\n', '  \n', '  /**\n', '   * @dev Emitted when `value` tokens are moved from one account (`from`) to another (`to`).\n', '   *\n', '   * Note that `value` may be zero.\n', '   * Also note that due to continuous minting we cannot emit transfer events from the address 0 when tokens are created.\n', '   * In order to keep consistency, we decided not to emit those events from the address 0 even when minting is done within a transaction.\n', '   */\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '   * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '   * a call to {approve}. `value` is the new allowance.\n', '   */\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  using SafeMath for uint256;\n', '\n', '  /* Storage */\n', '  \n', '  mapping (address => uint256) private balance;\n', '\n', '  mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '  /// @dev A lower bound of the total supply. Does not take into account tokens minted as UBI by an address before it moves those (transfer or burn).\n', '  uint256 public totalSupply;\n', '  \n', '  /// @dev Name of the token.\n', '  string public name;\n', '  \n', '  /// @dev Symbol of the token.\n', '  string public symbol;\n', '  \n', '  /// @dev Number of decimals of the token.\n', '  uint8 public decimals;\n', '\n', '  /// @dev How many tokens per second will be minted for every valid human.\n', '  uint256 public accruedPerSecond;\n', '\n', "  /// @dev The contract's governor.\n", '  address public governor;\n', '  \n', '  /// @dev The Proof Of Humanity registry to reference.\n', '  IProofOfHumanity public proofOfHumanity; \n', '\n', '  /// @dev Timestamp since human started accruing.\n', '  mapping(address => uint256) public accruedSince;\n', '\n', '  /* Modifiers */\n', '\n', '  /// @dev Verifies that the sender has ability to modify governed parameters.\n', '  modifier onlyByGovernor() {\n', '    require(governor == msg.sender, "The caller is not the governor.");\n', '    _;\n', '  }\n', '\n', '  /* Initializer */\n', '\n', '  /** @dev Constructor.\n', '  *  @param _initialSupply for the UBI coin including all decimals.\n', '  *  @param _name for UBI coin.\n', '  *  @param _symbol for UBI coin ticker.\n', '  *  @param _accruedPerSecond How much of the token is accrued per block.\n', '  *  @param _proofOfHumanity The Proof Of Humanity registry to reference.\n', '  */\n', '  function initialize(uint256 _initialSupply, string memory _name, string memory _symbol, uint256 _accruedPerSecond, IProofOfHumanity _proofOfHumanity) public initializer {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = 18;\n', '\n', '    accruedPerSecond = _accruedPerSecond;\n', '    proofOfHumanity = _proofOfHumanity;\n', '    governor = msg.sender;\n', '\n', '    balance[msg.sender] = _initialSupply;\n', '    totalSupply = _initialSupply;\n', '  }\n', '\n', '  /* External */\n', '\n', '  /** @dev Starts accruing UBI for a registered submission.\n', '  *  @param _human The submission ID.\n', '  */\n', '  function startAccruing(address _human) external {\n', '    require(proofOfHumanity.isRegistered(_human), "The submission is not registered in Proof Of Humanity.");\n', '    require(accruedSince[_human] == 0, "The submission is already accruing UBI.");\n', '    accruedSince[_human] = block.timestamp;\n', '  }\n', '\n', '  /** @dev Allows anyone to report a submission that\n', '  *  should no longer receive UBI due to removal from the\n', '  *  Proof Of Humanity registry. The reporter receives any\n', '  *  leftover accrued UBI.\n', '  *  @param _human The submission ID.\n', '  */\n', '  function reportRemoval(address _human) external  {\n', '    require(!proofOfHumanity.isRegistered(_human), "The submission is still registered in Proof Of Humanity.");\n', '    require(accruedSince[_human] != 0, "The submission is not accruing UBI.");\n', '    uint256 newSupply = accruedPerSecond.mul(block.timestamp.sub(accruedSince[_human]));\n', '\n', '    accruedSince[_human] = 0;\n', '\n', '    balance[msg.sender] = balance[msg.sender].add(newSupply);\n', '    totalSupply = totalSupply.add(newSupply);\n', '  }\n', '\n', '  /** @dev Changes `governor` to `_governor`.\n', '  *  @param _governor The address of the new governor.\n', '  */\n', '  function changeGovernor(address _governor) external onlyByGovernor {\n', '    governor = _governor;\n', '  }\n', '\n', '  /** @dev Changes `proofOfHumanity` to `_proofOfHumanity`.\n', '  *  @param _proofOfHumanity Registry that meets interface of Proof of Humanity.\n', '  */\n', '  function changeProofOfHumanity(IProofOfHumanity _proofOfHumanity) external onlyByGovernor {\n', '    proofOfHumanity = _proofOfHumanity;\n', '  }\n', '\n', '  /** @dev Transfers `_amount` to `_recipient` and withdraws accrued tokens.\n', '  *  @param _recipient The entity receiving the funds.\n', '  *  @param _amount The amount to tranfer in base units.\n', '  */\n', '  function transfer(address _recipient, uint256 _amount) public returns (bool) {\n', '    uint256 newSupplyFrom;\n', '    if (accruedSince[msg.sender] != 0 && proofOfHumanity.isRegistered(msg.sender)) {\n', '        newSupplyFrom = accruedPerSecond.mul(block.timestamp.sub(accruedSince[msg.sender]));\n', '        totalSupply = totalSupply.add(newSupplyFrom);\n', '        accruedSince[msg.sender] = block.timestamp;\n', '    }\n', '    balance[msg.sender] = balance[msg.sender].add(newSupplyFrom).sub(_amount, "ERC20: transfer amount exceeds balance");\n', '    balance[_recipient] = balance[_recipient].add(_amount);\n', '    emit Transfer(msg.sender, _recipient, _amount);\n', '    return true;\n', '  }\n', '  \n', '  /** @dev Transfers `_amount` from `_sender` to `_recipient` and withdraws accrued tokens.\n', '  *  @param _sender The entity to take the funds from.\n', '  *  @param _recipient The entity receiving the funds.\n', '  *  @param _amount The amount to tranfer in base units.\n', '  */\n', '  function transferFrom(address _sender, address _recipient, uint256 _amount) public returns (bool) {\n', '    uint256 newSupplyFrom;\n', '    allowance[_sender][msg.sender] = allowance[_sender][msg.sender].sub(_amount, "ERC20: transfer amount exceeds allowance");\n', '    if (accruedSince[_sender] != 0 && proofOfHumanity.isRegistered(_sender)) {\n', '        newSupplyFrom = accruedPerSecond.mul(block.timestamp.sub(accruedSince[_sender]));\n', '        totalSupply = totalSupply.add(newSupplyFrom);\n', '        accruedSince[_sender] = block.timestamp;\n', '    }\n', '    balance[_sender] = balance[_sender].add(newSupplyFrom).sub(_amount, "ERC20: transfer amount exceeds balance");\n', '    balance[_recipient] = balance[_recipient].add(_amount);       \n', '    emit Transfer(_sender, _recipient, _amount);\n', '    return true;\n', '  }\n', '\n', '  /** @dev Approves `_spender` to spend `_amount`.\n', '  *  @param _spender The entity allowed to spend funds.\n', '  *  @param _amount The amount of base units the entity will be allowed to spend.\n', '  */\n', '  function approve(address _spender, uint256 _amount) public returns (bool) {\n', '    allowance[msg.sender][_spender] = _amount;\n', '    emit Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  /** @dev Increases the `_spender` allowance by `_addedValue`.\n', '  *  @param _spender The entity allowed to spend funds.\n', '  *  @param _addedValue The amount of extra base units the entity will be allowed to spend.\n', '  */  \n', '  function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {\n', '    uint256 newAllowance = allowance[msg.sender][_spender].add(_addedValue);\n', '    allowance[msg.sender][_spender] = newAllowance;\n', '    emit Approval(msg.sender, _spender, newAllowance);\n', '    return true;\n', '  }\n', '\n', '  /** @dev Decreases the `_spender` allowance by `_subtractedValue`.\n', '  *  @param _spender The entity whose spending allocation will be reduced.\n', '  *  @param _subtractedValue The reduction of spending allocation in base units.\n', '  */  \n', '  function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {\n', '    uint256 newAllowance = allowance[msg.sender][_spender].sub(_subtractedValue, "ERC20: decreased allowance below zero");\n', '    allowance[msg.sender][_spender] = newAllowance;\n', '    emit Approval(msg.sender, _spender, newAllowance);\n', '    return true;\n', '  }\n', '  \n', '  /** @dev Burns `_amount` of tokens and withdraws accrued tokens.\n', '  *  @param _amount The quantity of tokens to burn in base units.\n', '  */  \n', '  function burn(uint256 _amount) public {\n', '    uint256 newSupplyFrom;\n', '    if(accruedSince[msg.sender] != 0 && proofOfHumanity.isRegistered(msg.sender)) {\n', '      newSupplyFrom = accruedPerSecond.mul(block.timestamp.sub(accruedSince[msg.sender]));\n', '      accruedSince[msg.sender] = block.timestamp;\n', '    }\n', '    balance[msg.sender] = balance[msg.sender].add(newSupplyFrom).sub(_amount, "ERC20: burn amount exceeds balance");\n', '    totalSupply = totalSupply.add(newSupplyFrom).sub(_amount);\n', '    emit Transfer(msg.sender, address(0), _amount);\n', '  }\n', '\n', '  /** @dev Burns `_amount` of tokens from `_account` and withdraws accrued tokens.\n', '  *  @param _account The entity to burn tokens from.\n', '  *  @param _amount The quantity of tokens to burn in base units.\n', '  */  \n', '  function burnFrom(address _account, uint256 _amount) public {\n', '    uint256 newSupplyFrom;\n', '    allowance[_account][msg.sender] = allowance[_account][msg.sender].sub(_amount, "ERC20: burn amount exceeds allowance");\n', '    if (accruedSince[_account] != 0 && proofOfHumanity.isRegistered(_account)) {\n', '        newSupplyFrom = accruedPerSecond.mul(block.timestamp.sub(accruedSince[_account]));\n', '        accruedSince[_account] = block.timestamp;\n', '    }\n', '    balance[_account] = balance[_account].add(newSupplyFrom).sub(_amount, "ERC20: burn amount exceeds balance");\n', '    totalSupply = totalSupply.add(newSupplyFrom).sub(_amount);\n', '    emit Transfer(_account, address(0), _amount);\n', '  }\n', '  \n', '  /* Getters */\n', '\n', '  /** @dev Calculates how much UBI a submission has available for withdrawal.\n', '  *  @param _human The submission ID.\n', '  *  @return accrued The available UBI for withdrawal.\n', '  */\n', '  function getAccruedValue(address _human) public view returns (uint256 accrued) {\n', '    // If this human have not started to accrue, or is not registered, return 0.\n', '    if (accruedSince[_human] == 0 || !proofOfHumanity.isRegistered(_human)) return 0;\n', '\n', '    else return accruedPerSecond.mul(block.timestamp.sub(accruedSince[_human]));\n', '  }\n', '  \n', '  /**\n', '  * @dev Calculates the current user accrued balance.\n', '  * @param _human The submission ID.\n', '  * @return The current balance including accrued Universal Basic Income of the user.\n', '  **/\n', '  function balanceOf(address _human) public view returns (uint256) {\n', '    return getAccruedValue(_human).add(balance[_human]);\n', '  }  \n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-19\n', '*/\n', '\n', '// File contracts/interfaces/IERC3156FlashBorrower.sol\n', '\n', '// SPDX-License-Identifier: No License\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IERC3156FlashBorrower {\n', '\n', '  /**\n', '    * @dev Receive a flash loan.\n', '    * @param initiator The initiator of the loan.\n', '    * @param token The loan currency.\n', '    * @param amount The amount of tokens lent.\n', '    * @param fee The additional amount of tokens to repay.\n', '    * @param data Arbitrary data structure, intended to contain user-defined parameters.\n', '    * @return The keccak256 hash of "ERC3156FlashBorrower.onFlashLoan"\n', '    */\n', '  function onFlashLoan(\n', '      address initiator,\n', '      address token,\n', '      uint256 amount,\n', '      uint256 fee,\n', '      bytes calldata data\n', '  ) external returns (bytes32);\n', '}\n', '\n', '\n', '// File contracts/interfaces/IERC3156FlashLender.sol\n', '\n', 'pragma solidity ^0.8.0;\n', 'interface IERC3156FlashLender {\n', '  /**\n', '    * @dev The amount of currency available to be lent.\n', '    * @param token The loan currency.\n', '    * @return The amount of `token` that can be borrowed.\n', '    */\n', '  function maxFlashLoan(\n', '      address token\n', '  ) external view returns (uint256);\n', '\n', '  /**\n', '    * @dev The fee to be charged for a given loan.\n', '    * @param token The loan currency.\n', '    * @param amount The amount of tokens lent.\n', '    * @return The amount of `token` to be charged for the loan, on top of the returned principal.\n', '    */\n', '  function flashFee(\n', '      address token,\n', '      uint256 amount\n', '  ) external view returns (uint256);\n', '\n', '  /**\n', '    * @dev Initiate a flash loan.\n', '    * @param receiver The receiver of the tokens in the loan, and the receiver of the callback.\n', '    * @param token The loan currency.\n', '    * @param amount The amount of tokens lent.\n', '    * @param data Arbitrary data structure, intended to contain user-defined parameters.\n', '    */\n', '  function flashLoan(\n', '      IERC3156FlashBorrower receiver,\n', '      address token,\n', '      uint256 amount,\n', '      bytes calldata data\n', '  ) external returns (bool);\n', '}\n', '\n', '\n', '// File contracts/interfaces/IWETH.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function withdraw(uint256 wad) external;\n', '}\n', '\n', '\n', '// File contracts/interfaces/IEtherWrapper.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IEtherWrapper {\n', '    function capacity() external view returns (uint256);\n', '    function getReserves() external view returns (uint256);\n', '    function calculateMintFee(uint amount) external view returns (uint);\n', '    function calculateBurnFee(uint amount) external view returns (uint);\n', '\n', '    function mint(uint amount) external;\n', '    function burn(uint amount) external;\n', '}\n', '\n', '\n', '// File contracts/interfaces/ICurve.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface ICurve {\n', '    function get_dy(uint256 i, uint256 j, uint256 dx) external view returns (uint256);\n', '    function balances(uint256 idx) external view returns (uint256);\n', '    function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external payable;\n', '}\n', '\n', '\n', '// File contracts/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @title Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);\n', '}\n', '\n', '\n', '// File contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File contracts/ERC20/SafeERC20.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender) + value;\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender) - value;\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File contracts/utils/Ownable.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' * @author crypto-pumpkin\n', ' *\n', ' * By initialization, the owner account will be the one that called initializeOwner. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '// File contracts/Arb.sol\n', '\n', 'pragma solidity ^0.8.0;\n', 'contract Arb is Ownable {\n', '  using SafeERC20 for IERC20;\n', '\n', '  IERC3156FlashLender public constant flashLender = IERC3156FlashLender(0x6bdC1FCB2F13d1bA9D26ccEc3983d5D4bf318693);\n', '  IERC20 public constant weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '  IERC20 public constant seth = IERC20(0x5e74C9036fb86BD7eCdcb084a0673EFc32eA31cb);\n', '  ICurve public constant curvePool = ICurve(0xc5424B857f758E906013F3555Dad202e4bdB4567);\n', '\n', '  uint256 wethIndex = 0;\n', '  uint256 sethIndex = 1;\n', '\n', '  struct FlashloanData {\n', '    bool isMintSeth;\n', '    address caller;\n', '    address target;\n', '    uint256 minProfit;\n', '  }\n', '\n', '  function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata data) external returns (bytes32) {\n', '    FlashloanData memory flashData = abi.decode(data, (FlashloanData));\n', '    require(msg.sender == address(flashLender), "Untrusted lender");\n', '    require(token == address(weth), "Not WETH");\n', '    require(initiator == address(this), "Untrusted loan initiator");\n', '    uint256 amountOwed = amount + fee;\n', '  \n', '    // Steps 1-3:\n', '    uint256 wethBal;\n', '    if (flashData.isMintSeth) {\n', '      wethBal = _swapSethForETH(flashData.target, amount);\n', '    } else {\n', '      wethBal = _swapEthForSeth(flashData.target, amount);\n', '    }\n', '\n', '    // Step 4: Ensure profit\n', '    require(wethBal > amountOwed + flashData.minProfit, "Less than minProfit");\n', '    weth.safeTransfer(flashData.caller, wethBal - amountOwed);\n', '    return keccak256("ERC3156FlashBorrower.onFlashLoan");\n', '  }\n', '\n', '  function arb(address _sip112Address, uint256 _percentToUse, uint256 _minProfit) external onlyOwner {\n', '    require(_percentToUse <= 100, "percent > 100");\n', '    (bool isMintSeth, uint256 amountToFlash, uint256 wethReturned) = calculateOpportunity(_sip112Address, _percentToUse);\n', '    require(wethReturned >= amountToFlash + _minProfit, "not enough profit!");\n', '\n', '    bytes memory data = abi.encode(FlashloanData({\n', '      isMintSeth: isMintSeth,\n', '      caller: msg.sender,\n', '      target: _sip112Address,\n', '      minProfit: _minProfit\n', '    }));\n', '    uint256 _fee = flashLender.flashFee(address(weth), amountToFlash);\n', '    uint256 _repayment = amountToFlash + _fee;\n', '    _approve(weth, address(flashLender), _repayment);\n', '    flashLender.flashLoan(IERC3156FlashBorrower(address(this)), address(weth), amountToFlash, data);\n', '  }\n', '\n', '  function calculateOpportunity(address _sip112Address, uint256 _percentToUse)\n', '    public view\n', '    returns (bool isMintSeth, uint256 amountToFlash, uint256 wethReturned)\n', '  {\n', '    uint256 maxFlashLoan = flashLender.maxFlashLoan(address(weth));\n', '    uint256 curveWethBal = curvePool.balances(wethIndex);\n', '    uint256 curveSethBal = curvePool.balances(sethIndex);\n', '    if (curveWethBal > curveSethBal) {\n', '      isMintSeth = true;\n', '      uint256 capacity = IEtherWrapper(_sip112Address).capacity();\n', '      uint256 adjustedCapacityToUse = capacity * _percentToUse / 100;\n', '      amountToFlash = adjustedCapacityToUse > maxFlashLoan ? maxFlashLoan : adjustedCapacityToUse;\n', '      uint256 mintFee = IEtherWrapper(_sip112Address).calculateMintFee(amountToFlash);\n', '      uint256 sethBal = amountToFlash - mintFee;\n', '      if (sethBal > 0) {\n', '        wethReturned = curvePool.get_dy(sethIndex, wethIndex, sethBal);\n', '      }\n', '    } else {\n', '      isMintSeth = false;\n', '      uint256 reserves = IEtherWrapper(_sip112Address).getReserves();\n', '      uint256 adjustedPercentToUse = _percentToUse > 96 ? 96 : _percentToUse;\n', '      uint256 adjustedReserveToUse = reserves * adjustedPercentToUse / 100;\n', '      amountToFlash = adjustedReserveToUse > maxFlashLoan ? maxFlashLoan : amountToFlash;\n', '      if (amountToFlash > 0) {\n', '        uint256 sethBal = curvePool.get_dy(wethIndex, sethIndex, amountToFlash);\n', '        uint256 burnFee = IEtherWrapper(_sip112Address).calculateBurnFee(sethBal);\n', '        wethReturned = sethBal - burnFee;\n', '      }\n', '    }\n', '  }\n', '\n', '  function _approve(IERC20 _token, address _spender, uint256 _amount) internal {\n', '    if (_token.allowance(address(this), _spender) < _amount) {\n', '        _token.safeApprove(_spender, type(uint256).max);\n', '    }\n', '  }\n', '\n', '  /// @notice mint SETH with WETH, sell SETH for ETH on Curve, wrap ETH for WETH, return flash loaned WETH\n', '  function _swapSethForETH(address target, uint256 amount) internal returns(uint256 wethBal) {\n', '    // Step 1: Mint sETH with WETH\n', '    _approve(weth, target, amount);\n', '    IEtherWrapper(target).mint(amount);\n', '    uint256 sethBal = seth.balanceOf(address(this));\n', '\n', '    // Step 2: Swap sETH to ETH\n', '    _approve(seth, address(curvePool), sethBal);\n', '    curvePool.exchange(sethIndex, wethIndex, sethBal, 0);\n', '    uint256 ethBal = address(this).balance;\n', '\n', '    // Step 3: Wrap ETH into WETH\n', '    IWETH(address(weth)).deposit{value: ethBal}();\n', '    wethBal = weth.balanceOf(address(this));\n', '  }\n', '\n', '  /// @notice unwrap WETH into ETH, swap ETH for sETH on Curve, burn sETH for WETH< return flash loaned WETH\n', '  function _swapEthForSeth(address target, uint256 amount) internal returns(uint256 wethBal) {\n', '    // Step 1: Unwrap WETH into ETH\n', '    _approve(weth, address(weth), amount);\n', '    IWETH(address(weth)).withdraw(amount);\n', '    uint256 ethBal = address(this).balance;\n', '    \n', '    // Step 2: Swap ETH for sETH\n', '    curvePool.exchange{value: ethBal}(wethIndex, sethIndex, ethBal, 0);\n', '    uint256 sethBal = seth.balanceOf(address(this));\n', '\n', '    // Step 3: Burn sETH for WETH\n', '    _approve(seth, target, sethBal);\n', '    IEtherWrapper(target).burn(sethBal);\n', '    wethBal = weth.balanceOf(address(this));\n', '  }\n', '}']
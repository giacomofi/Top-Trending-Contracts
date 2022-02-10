['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-12\n', '*/\n', '\n', 'pragma solidity 0.8.0;\n', '// SPDX-License-Identifier: AGPL-3.0-or-later\n', '\n', '\n', 'interface ISavingsContractV2 {\n', '    // DEPRECATED but still backwards compatible\n', '    function redeem(uint256 _amount) external returns (uint256 massetReturned);\n', '\n', '    function creditBalances(address) external view returns (uint256); // V1 & V2 (use balanceOf)\n', '\n', '    // --------------------------------------------\n', '\n', '    function depositInterest(uint256 _amount) external; // V1 & V2\n', '\n', '    function depositSavings(uint256 _amount) external returns (uint256 creditsIssued); // V1 & V2\n', '\n', '    function depositSavings(uint256 _amount, address _beneficiary)\n', '        external\n', '        returns (uint256 creditsIssued); // V2\n', '\n', '    function redeemCredits(uint256 _amount) external returns (uint256 underlyingReturned); // V2\n', '\n', '    function redeemUnderlying(uint256 _amount) external returns (uint256 creditsBurned); // V2\n', '\n', '    function exchangeRate() external view returns (uint256); // V1 & V2\n', '\n', '    function balanceOfUnderlying(address _user) external view returns (uint256 balance); // V2\n', '\n', '    function underlyingToCredits(uint256 _credits) external view returns (uint256 underlying); // V2\n', '\n', '    function creditsToUnderlying(uint256 _underlying) external view returns (uint256 credits); // V2\n', '}\n', '\n', 'interface MassetStructs {\n', '    struct BassetPersonal {\n', '        // Address of the bAsset\n', '        address addr;\n', '        // Address of the bAsset\n', '        address integrator;\n', '        // An ERC20 can charge transfer fee, for example USDT, DGX tokens.\n', '        bool hasTxFee; // takes a byte in storage\n', '        // Status of the bAsset\n', '        BassetStatus status;\n', '    }\n', '\n', '    struct BassetData {\n', '        // 1 Basset * ratio / ratioScale == x Masset (relative value)\n', '        // If ratio == 10e8 then 1 bAsset = 10 mAssets\n', '        // A ratio is divised as 10^(18-tokenDecimals) * measurementMultiple(relative value of 1 base unit)\n', '        uint128 ratio;\n', '        // Amount of the Basset that is held in Collateral\n', '        uint128 vaultBalance;\n', '    }\n', '\n', '    // Status of the Basset - has it broken its peg?\n', '    enum BassetStatus {\n', '        Default,\n', '        Normal,\n', '        BrokenBelowPeg,\n', '        BrokenAbovePeg,\n', '        Blacklisted,\n', '        Liquidating,\n', '        Liquidated,\n', '        Failed\n', '    }\n', '\n', '    struct BasketState {\n', '        bool undergoingRecol;\n', '        bool failed;\n', '    }\n', '\n', '    struct InvariantConfig {\n', '        uint256 a;\n', '        WeightLimits limits;\n', '    }\n', '\n', '    struct WeightLimits {\n', '        uint128 min;\n', '        uint128 max;\n', '    }\n', '\n', '    struct AmpData {\n', '        uint64 initialA;\n', '        uint64 targetA;\n', '        uint64 rampStartTime;\n', '        uint64 rampEndTime;\n', '    }\n', '}\n', '\n', 'abstract contract IMasset is MassetStructs {\n', '    // Mint\n', '    function mint(\n', '        address _input,\n', '        uint256 _inputQuantity,\n', '        uint256 _minOutputQuantity,\n', '        address _recipient\n', '    ) external virtual returns (uint256 mintOutput);\n', '\n', '    function mintMulti(\n', '        address[] calldata _inputs,\n', '        uint256[] calldata _inputQuantities,\n', '        uint256 _minOutputQuantity,\n', '        address _recipient\n', '    ) external virtual returns (uint256 mintOutput);\n', '\n', '    function getMintOutput(address _input, uint256 _inputQuantity)\n', '        external\n', '        view\n', '        virtual\n', '        returns (uint256 mintOutput);\n', '\n', '    function getMintMultiOutput(address[] calldata _inputs, uint256[] calldata _inputQuantities)\n', '        external\n', '        view\n', '        virtual\n', '        returns (uint256 mintOutput);\n', '\n', '    // Swaps\n', '    function swap(\n', '        address _input,\n', '        address _output,\n', '        uint256 _inputQuantity,\n', '        uint256 _minOutputQuantity,\n', '        address _recipient\n', '    ) external virtual returns (uint256 swapOutput);\n', '\n', '    function getSwapOutput(\n', '        address _input,\n', '        address _output,\n', '        uint256 _inputQuantity\n', '    ) external view virtual returns (uint256 swapOutput);\n', '\n', '    // Redemption\n', '    function redeem(\n', '        address _output,\n', '        uint256 _mAssetQuantity,\n', '        uint256 _minOutputQuantity,\n', '        address _recipient\n', '    ) external virtual returns (uint256 outputQuantity);\n', '\n', '    function redeemMasset(\n', '        uint256 _mAssetQuantity,\n', '        uint256[] calldata _minOutputQuantities,\n', '        address _recipient\n', '    ) external virtual returns (uint256[] memory outputQuantities);\n', '\n', '    function redeemExactBassets(\n', '        address[] calldata _outputs,\n', '        uint256[] calldata _outputQuantities,\n', '        uint256 _maxMassetQuantity,\n', '        address _recipient\n', '    ) external virtual returns (uint256 mAssetRedeemed);\n', '\n', '    function getRedeemOutput(address _output, uint256 _mAssetQuantity)\n', '        external\n', '        view\n', '        virtual\n', '        returns (uint256 bAssetOutput);\n', '\n', '    function getRedeemExactBassetsOutput(\n', '        address[] calldata _outputs,\n', '        uint256[] calldata _outputQuantities\n', '    ) external view virtual returns (uint256 mAssetAmount);\n', '\n', '    // Views\n', '    function getBasket() external view virtual returns (bool, bool);\n', '\n', '    function getBasset(address _token)\n', '        external\n', '        view\n', '        virtual\n', '        returns (BassetPersonal memory personal, BassetData memory data);\n', '\n', '    function getBassets()\n', '        external\n', '        view\n', '        virtual\n', '        returns (BassetPersonal[] memory personal, BassetData[] memory data);\n', '\n', '    function bAssetIndexes(address) external view virtual returns (uint8);\n', '\n', '    // SavingsManager\n', '    function collectInterest() external virtual returns (uint256 swapFeesGained, uint256 newSupply);\n', '\n', '    function collectPlatformInterest()\n', '        external\n', '        virtual\n', '        returns (uint256 mintAmount, uint256 newSupply);\n', '\n', '    // Admin\n', '    function setCacheSize(uint256 _cacheSize) external virtual;\n', '\n', '    function upgradeForgeValidator(address _newForgeValidator) external virtual;\n', '\n', '    function setFees(uint256 _swapFee, uint256 _redemptionFee) external virtual;\n', '\n', '    function setTransferFeesFlag(address _bAsset, bool _flag) external virtual;\n', '\n', '    function migrateBassets(address[] calldata _bAssets, address _newIntegration) external virtual;\n', '}\n', '\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender) + value;\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender) - value;\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface IUniswapV2Router02 {\n', '    function swapExactTokensForTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin, // calculated off chain\n', '        address[] calldata path, // also worked out off chain\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function swapExactETHForTokens(\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '\n', '    function getAmountsIn(uint256 amountOut, address[] calldata path)\n', '        external\n', '        view\n', '        returns (uint256[] memory amounts);\n', '\n', '    function getAmountsOut(uint256 amountIn, address[] calldata path)\n', '        external\n', '        view\n', '        returns (uint256[] memory amounts);\n', '}\n', '\n', 'interface IBasicToken {\n', '    function decimals() external view returns (uint8);\n', '}\n', '\n', 'interface IBoostedSavingsVault {\n', '    function stake(address _beneficiary, uint256 _amount) external;\n', '}\n', '\n', '// 3 FLOWS\n', '// 0 - SAVE\n', '// 1 - MINT AND SAVE\n', '// 2 - BUY AND SAVE (ETH via Uni)\n', 'contract SaveWrapper {\n', '\n', '    using SafeERC20 for IERC20;\n', '\n', '    // Constants - add to bytecode during deployment\n', '    address public immutable save;\n', '    address public immutable vault;\n', '    address public immutable mAsset;\n', '\n', '    IUniswapV2Router02 public immutable uniswap;\n', '\n', '    constructor(\n', '        address _save,\n', '        address _vault,\n', '        address _mAsset,\n', '        address[] memory _bAssets,\n', '        address _uniswapAddress\n', '    ) {\n', '        require(_save != address(0), "Invalid save address");\n', '        save = _save;\n', '        require(_vault != address(0), "Invalid vault address");\n', '        vault = _vault;\n', '        require(_mAsset != address(0), "Invalid mAsset address");\n', '        mAsset = _mAsset;\n', '        require(_uniswapAddress != address(0), "Invalid uniswap address");\n', '        uniswap = IUniswapV2Router02(_uniswapAddress);\n', '\n', '        IERC20(_mAsset).safeApprove(_save, 2**256 - 1);\n', '        IERC20(_save).approve(_vault, 2**256 - 1);\n', '        for(uint256 i = 0; i < _bAssets.length; i++ ) {\n', '            IERC20(_bAssets[i]).safeApprove(_mAsset, 2**256 - 1);\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev 0. Simply saves an mAsset and then into the vault\n', '     * @param _amount Units of mAsset to deposit to savings\n', '     */\n', '    function saveAndStake(uint256 _amount) external {\n', '        IERC20(mAsset).transferFrom(msg.sender, address(this), _amount);\n', '        _saveAndStake(_amount, true);\n', '    }\n', '\n', '    /**\n', '     * @dev 1. Mints an mAsset and then deposits to SAVE\n', '     * @param _bAsset       bAsset address\n', '     * @param _amt          Amount of bAsset to mint with\n', '     * @param _minOut       Min amount of mAsset to get back\n', '     * @param _stake        Add the imUSD to the Savings Vault?\n', '     */\n', '    function saveViaMint(address _bAsset, uint256 _amt, uint256 _minOut, bool _stake) external {\n', '        // 1. Get the input bAsset\n', '        IERC20(_bAsset).transferFrom(msg.sender, address(this), _amt);\n', '        // 2. Mint\n', '        IMasset mAsset_ = IMasset(mAsset);\n', '        uint256 massetsMinted = mAsset_.mint(_bAsset, _amt, _minOut, address(this));\n', '        // 3. Mint imUSD and optionally stake in vault\n', '        _saveAndStake(massetsMinted, _stake);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev 2. Buys a bAsset on Uniswap with ETH then mUSD on Curve\n', '     * @param _amountOutMin  Min uniswap output in bAsset units\n', '     * @param _path          Sell path on Uniswap (e.g. [WETH, DAI])\n', '     * @param _minOutMStable Min amount of mUSD to receive\n', '     * @param _stake         Add the imUSD to the Savings Vault?\n', '     */\n', '    function saveViaUniswapETH(\n', '        uint256 _amountOutMin,\n', '        address[] calldata _path,\n', '        uint256 _minOutMStable,\n', '        bool _stake\n', '    ) external payable {\n', '        // 1. Get the bAsset\n', '        uint[] memory amounts = uniswap.swapExactETHForTokens{value: msg.value}(\n', '            _amountOutMin,\n', '            _path,\n', '            address(this),\n', '            block.timestamp + 1000\n', '        );\n', '        // 2. Purchase mUSD\n', '        uint256 massetsMinted = IMasset(mAsset).mint(_path[_path.length-1], amounts[amounts.length-1], _minOutMStable, address(this));\n', '        // 3. Mint imUSD and optionally stake in vault\n', '        _saveAndStake(massetsMinted, _stake);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets estimated mAsset output from a WETH > bAsset > mAsset trade\n', '     */\n', '    function estimate_saveViaUniswapETH(\n', '        uint256 _ethAmount,\n', '        address[] calldata _path,\n', '        int128 _curvePosition\n', '    )\n', '        external\n', '        view\n', '        returns (uint256 out)\n', '    {\n', '        uint256 estimatedBasset = _getAmountOut(_ethAmount, _path);\n', '        return IMasset(mAsset).getMintOutput(_path[_path.length-1], estimatedBasset);\n', '    }\n', '\n', '    /** @dev Internal func to deposit into SAVE and optionally stake in the vault */\n', '    function _saveAndStake(\n', '        uint256 _amount,\n', '        bool _stake\n', '    ) internal {\n', '        if(_stake){\n', '            uint256 credits = ISavingsContractV2(save).depositSavings(_amount, address(this));\n', '            IBoostedSavingsVault(vault).stake(msg.sender, credits);\n', '        } else {\n', '            ISavingsContractV2(save).depositSavings(_amount, msg.sender);\n', '        }\n', '    }\n', '\n', '    /** @dev Internal func to get esimtated Uniswap output from WETH to token trade */\n', '    function _getAmountOut(uint256 _amountIn, address[] memory _path) internal view returns (uint256) {\n', '        uint256[] memory amountsOut = uniswap.getAmountsOut(_amountIn, _path);\n', '        return amountsOut[amountsOut.length - 1];\n', '    }\n', '}']
['// SPDX-License-Identifier: MIT\n', '// @author: https://github.com/SHA-2048\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "@openzeppelin/contracts/utils/Multicall.sol";\n', 'import "@uniswap/v2-periphery/contracts/interfaces/IWETH.sol";\n', '\n', 'import "../governance/Controller.sol";\n', 'import "../governance/Controllable.sol";\n', 'import "../libraries/AllowanceChecker.sol";\n', '\n', '/**\n', ' * FeeConverter is designed to receive any token accrued from\n', ' * Metric Exchange fees. The ERC20 tokens can be converted into METRIC\n', ' * and the caller will get an incentive as a % of the METRIC\n', ' * balance generated. There is a function to trigger METRIC\n', ' * distribution over eligible recipients. There is also\n', ' * a wrapEth function, in case contract holds ETH.\n', ' * All calls can be sequenced using the MultiCall\n', ' * interface available on the contract\n', ' *\n', ' * All parameters can be changed on the Controller\n', ' * contract: swapRouter, rewardToken, revenue recipients\n', ' * as well as the fee conversion % incentive\n', ' *\n', ' * all action can be paused as well by the Controller.\n', ' */\n', 'contract FeeConverter is Multicall, Controllable, AllowanceChecker {\n', '\n', '    event FeeDistribution(\n', '        address recipient,\n', '        uint amount\n', '    );\n', '\n', '    constructor(Controller _controller) Controllable(_controller) {}\n', '\n', '    receive() external payable {}\n', '\n', '    function convertToken(\n', '        address[] memory _path,\n', '        uint _inputAmount,\n', '        uint _minOutput,\n', '        address _incentiveCollector\n', '    ) external whenNotPaused {\n', '\n', '        require(_path[_path.length - 1] == address(controller.rewardToken()), "Output token needs to be reward token");\n', '\n', '        uint rewardTokenBalanceBeforeConversion = controller.rewardToken().balanceOf(address(this));\n', '        _executeConversion(_path, _inputAmount, _minOutput);\n', '        uint rewardTokenBalanceAfterConversion = controller.rewardToken().balanceOf(address(this));\n', '\n', '        _sendIncentiveReward(\n', '            _incentiveCollector,\n', '            rewardTokenBalanceAfterConversion - rewardTokenBalanceBeforeConversion\n', '        );\n', '    }\n', '\n', '    function wrapETH() external whenNotPaused {\n', '        uint balance = address(this).balance;\n', '        if (balance > 0) {\n', '            IWETH(controller.swapRouter().weth()).deposit{value : balance}();\n', '        }\n', '    }\n', '\n', '    function transferRewardTokenToReceivers() external whenNotPaused {\n', '\n', '        Controller.RewardReceiver[] memory receivers = controller.getRewardReceivers();\n', '\n', '        uint totalAmount = controller.rewardToken().balanceOf(address(this));\n', '        uint remaining = totalAmount;\n', '        uint nbReceivers = receivers.length;\n', '\n', '        if (nbReceivers > 0) {\n', '            for(uint i = 0; i < nbReceivers - 1; i++) {\n', '                uint receiverShare = totalAmount * receivers[i].share / 100e18;\n', '                _sendRewardToken(receivers[i].receiver, receiverShare);\n', '\n', '                remaining -= receiverShare;\n', '            }\n', '            _sendRewardToken(receivers[nbReceivers - 1].receiver, remaining);\n', '        }\n', '    }\n', '\n', '    function _executeConversion(\n', '        address[] memory _path,\n', '        uint _inputAmount,\n', '        uint _minOutput\n', '    ) internal {\n', '        ISwapRouter router = controller.swapRouter();\n', '\n', '        approveIfNeeded(_path[0], address(router));\n', '\n', '        controller.swapRouter().swapExactTokensForTokens(\n', '            _path,\n', '            _inputAmount,\n', '            _minOutput\n', '        );\n', '    }\n', '\n', '    function _sendIncentiveReward(address _incentiveCollector, uint _totalAmount) internal {\n', '        uint incentiveShare = controller.feeConversionIncentive();\n', '        if (incentiveShare > 0) {\n', '            uint callerIncentive = _totalAmount * incentiveShare / 100e18;\n', '            _sendRewardToken(_incentiveCollector, callerIncentive);\n', '        }\n', '    }\n', '\n', '    function _sendRewardToken(\n', '        address _recipient,\n', '        uint _amount\n', '    ) internal {\n', '        controller.rewardToken().transfer(_recipient, _amount);\n', '        emit FeeDistribution(_recipient, _amount);\n', '    }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./Address.sol";\n', '\n', '/**\n', ' * @dev Provides a function to batch together multiple calls in a single external call.\n', ' *\n', ' * _Available since v4.1._\n', ' */\n', 'abstract contract Multicall {\n', '    /**\n', '    * @dev Receives and executes a batch of function calls on this contract.\n', '    */\n', '    function multicall(bytes[] calldata data) external returns (bytes[] memory results) {\n', '        results = new bytes[](data.length);\n', '        for (uint i = 0; i < data.length; i++) {\n', '            results[i] = Address.functionDelegateCall(address(this), data[i]);\n', '        }\n', '        return results;\n', '    }\n', '}\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function withdraw(uint) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '// @author: https://github.com/SHA-2048\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', 'import "@openzeppelin/contracts/security/Pausable.sol";\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "../interfaces/ISwapRouter.sol";\n', '\n', 'contract Controller is Ownable, Pausable {\n', '\n', '    struct RewardReceiver {\n', '        address receiver;\n', '        uint share;\n', '    }\n', '\n', '    IERC20 public rewardToken;\n', '    address public feeConverter;\n', '\n', '    RewardReceiver[] public rewardReceivers;\n', '    ISwapRouter public swapRouter;\n', '\n', '    uint public feeConversionIncentive;\n', '\n', '    constructor(\n', '        RewardReceiver[] memory _rewardReceivers,\n', '        ISwapRouter _swapRouter,\n', '        uint _feeConversionIncentive,\n', '        IERC20 _rewardToken\n', '    ) {\n', '        rewardToken = _rewardToken;\n', '        feeConversionIncentive = _feeConversionIncentive;\n', '        swapRouter = _swapRouter;\n', '\n', '        for(uint i = 0; i < _rewardReceivers.length; i++) {\n', '            rewardReceivers.push(_rewardReceivers[i]);\n', '        }\n', '    }\n', '\n', '    function setFeeConverter(address _feeConverter) external onlyOwner {\n', '        feeConverter = _feeConverter;\n', '    }\n', '\n', '    function getRewardReceivers() external view returns(RewardReceiver[] memory){\n', '        return rewardReceivers;\n', '    }\n', '\n', '    function setRewardReceivers(RewardReceiver[] memory _rewardReceivers) onlyOwner external {\n', '        delete rewardReceivers;\n', '\n', '        for(uint i = 0; i < _rewardReceivers.length; i++) {\n', '            rewardReceivers.push(_rewardReceivers[i]);\n', '        }\n', '    }\n', '\n', '    function setFeeConversionIncentive(uint _value) onlyOwner external {\n', '        feeConversionIncentive = _value;\n', '    }\n', '\n', '    function setRewardToken(IERC20 _token) onlyOwner external {\n', '        rewardToken = _token;\n', '    }\n', '\n', '    function pause() external onlyOwner {\n', '        _pause();\n', '    }\n', '\n', '    function unpause() external onlyOwner {\n', '        _unpause();\n', '    }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '// @author: https://github.com/SHA-2048\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./Controller.sol";\n', '\n', 'contract Controllable {\n', '\n', '    Controller public controller;\n', '\n', '    constructor(Controller _controller) {\n', '        controller = _controller;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!controller.paused(), "Forbidden: System is paused");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "./Constants.sol";\n', '\n', 'contract AllowanceChecker is Constants {\n', '\n', '    function approveIfNeeded(address _token, address _spender) public {\n', '        if (IERC20(_token).allowance(address(this), _spender) < MAX_INT) {\n', '            IERC20(_token).approve(_spender, MAX_INT);\n', '        }\n', '    }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '\n', '/**\n', ' * @dev Contract module which allows children to implement an emergency stop\n', ' * mechanism that can be triggered by an authorized account.\n', ' *\n', ' * This module is used through inheritance. It will make available the\n', ' * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n', ' * the functions of your contract. Note that they will not be pausable by\n', ' * simply including this module, only once the modifiers are put in place.\n', ' */\n', 'abstract contract Pausable is Context {\n', '    /**\n', '     * @dev Emitted when the pause is triggered by `account`.\n', '     */\n', '    event Paused(address account);\n', '\n', '    /**\n', '     * @dev Emitted when the pause is lifted by `account`.\n', '     */\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    /**\n', '     * @dev Initializes the contract in unpaused state.\n', '     */\n', '    constructor () {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the contract is paused, and false otherwise.\n', '     */\n', '    function paused() public view virtual returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused(), "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused(), "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers stopped state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    /**\n', '     * @dev Returns to normal state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '// @author: https://github.com/SHA-2048\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface ISwapRouter {\n', '\n', '    function weth() external returns(address);\n', '\n', '    function swapExactTokensForTokens(\n', '        address[] memory _path,\n', '        uint _supplyTokenAmount,\n', '        uint _minOutput\n', '    ) external;\n', '\n', '    function compound(\n', '        address[] memory _path,\n', '        uint _amount\n', '    ) external;\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'abstract contract Constants {\n', '\n', '    uint MAX_INT = 2 ** 256 - 1;\n', '\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "libraries": {}\n', '}']
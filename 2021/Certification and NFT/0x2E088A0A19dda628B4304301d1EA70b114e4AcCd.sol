['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-18\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '// File: contracts\\Interfaces.sol\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '/**\n', ' * @dev Standard math utilities missing in the Solidity language.\n', ' */\n', 'library MathUtil {\n', '    /**\n', '     * @dev Returns the smallest of two numbers.\n', '     */\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'contract ReentrancyGuard {\n', '    uint256 private _guardCounter;\n', '\n', '    constructor () internal {\n', '        _guardCounter = 1;\n', '    }\n', '\n', '    modifier nonReentrant() {\n', '        _guardCounter += 1;\n', '        uint256 localCounter = _guardCounter;\n', '        _;\n', '        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");\n', '    }\n', '}\n', '\n', 'interface ICurveGauge {\n', '    function deposit(uint256) external;\n', '    function balanceOf(address) external view returns (uint256);\n', '    function withdraw(uint256) external;\n', '    function claim_rewards() external;\n', '    function reward_tokens(uint256) external view returns(address);//v2\n', '    function rewarded_token() external view returns(address);//v1\n', '}\n', '\n', 'interface ICurveVoteEscrow {\n', '    function create_lock(uint256, uint256) external;\n', '    function increase_amount(uint256) external;\n', '    function increase_unlock_time(uint256) external;\n', '    function withdraw() external;\n', '    function smart_wallet_checker() external view returns (address);\n', '}\n', '\n', 'interface IWalletChecker {\n', '    function check(address) external view returns (bool);\n', '}\n', '\n', 'interface IVoting{\n', '    function vote(uint256, bool, bool) external; //voteId, support, executeIfDecided\n', '    function getVote(uint256) external view returns(bool,bool,uint64,uint64,uint64,uint64,uint256,uint256,uint256,bytes memory); \n', '    function vote_for_gauge_weights(address,uint256) external;\n', '}\n', '\n', 'interface IMinter{\n', '    function mint(address) external;\n', '}\n', '\n', 'interface IRegistry{\n', '    function get_registry() external view returns(address);\n', '    function get_address(uint256 _id) external view returns(address);\n', '    function gauge_controller() external view returns(address);\n', '    function get_lp_token(address) external view returns(address);\n', '    function get_gauges(address) external view returns(address[10] memory,uint128[10] memory);\n', '}\n', '\n', 'interface IStaker{\n', '    function deposit(address, address) external;\n', '    function withdraw(address) external;\n', '    function withdraw(address, address, uint256) external;\n', '    function withdrawAll(address, address) external;\n', '    function createLock(uint256, uint256) external;\n', '    function increaseAmount(uint256) external;\n', '    function increaseTime(uint256) external;\n', '    function release() external;\n', '    function claimCrv(address) external returns (uint256);\n', '    function claimRewards(address) external;\n', '    function claimFees(address,address) external;\n', '    function setStashAccess(address, bool) external;\n', '    function vote(uint256,address,bool) external;\n', '    function voteGaugeWeight(address,uint256) external;\n', '    function balanceOfPool(address) external view returns (uint256);\n', '    function operator() external view returns (address);\n', '    function execute(address _to, uint256 _value, bytes calldata _data) external returns (bool, bytes memory);\n', '}\n', '\n', 'interface IRewards{\n', '    function stake(address, uint256) external;\n', '    function stakeFor(address, uint256) external;\n', '    function withdraw(address, uint256) external;\n', '    function exit(address) external;\n', '    function getReward(address) external;\n', '    function queueNewRewards(uint256) external;\n', '    function notifyRewardAmount(uint256) external;\n', '    function addExtraReward(address) external;\n', '    function stakingToken() external returns (address);\n', '}\n', '\n', 'interface IStash{\n', '    function stashRewards() external returns (bool);\n', '    function processStash() external returns (bool);\n', '    function claimRewards() external returns (bool);\n', '}\n', '\n', 'interface IFeeDistro{\n', '    function claim() external;\n', '    function token() external view returns(address);\n', '}\n', '\n', 'interface ITokenMinter{\n', '    function mint(address,uint256) external;\n', '    function burn(address,uint256) external;\n', '}\n', '\n', 'interface IDeposit{\n', '    function isShutdown() external view returns(bool);\n', '    function balanceOf(address _account) external view returns(uint256);\n', '    function totalSupply() external view returns(uint256);\n', '    function poolInfo(uint256) external view returns(address,address,address,address,address, bool);\n', '    function rewardClaimed(uint256,address,uint256) external;\n', '    function withdrawTo(uint256,uint256,address) external;\n', '    function claimRewards(uint256,address) external returns(bool);\n', '    function rewardArbitrator() external returns(address);\n', '}\n', '\n', 'interface ICrvDeposit{\n', '    function deposit(uint256, bool) external;\n', '    function lockIncentive() external view returns(uint256);\n', '}\n', '\n', 'interface IRewardFactory{\n', '    function setAccess(address,bool) external;\n', '    function CreateCrvRewards(uint256,address) external returns(address);\n', '    function CreateTokenRewards(address,address,address) external returns(address);\n', '    function activeRewardCount(address) external view returns(uint256);\n', '    function addActiveReward(address,uint256) external returns(bool);\n', '    function removeActiveReward(address,uint256) external returns(bool);\n', '}\n', '\n', 'interface IStashFactory{\n', '    function CreateStash(uint256,address,address,uint256) external returns(address);\n', '}\n', '\n', 'interface ITokenFactory{\n', '    function CreateDepositToken(address) external returns(address);\n', '}\n', '\n', 'interface IPools{\n', '    function addPool(address _lptoken, address _gauge, uint256 _stashVersion) external returns(bool);\n', '    function shutdownPool(uint256 _pid) external returns(bool);\n', '    function poolInfo(uint256) external view returns(address,address,address,address,address,bool);\n', '    function poolLength() external view returns (uint256);\n', '    function gaugeMap(address) external view returns(bool);\n', '    function setPoolManager(address _poolM) external;\n', '}\n', '\n', 'interface IVestedEscrow{\n', '    function fund(address[] calldata _recipient, uint256[] calldata _amount) external returns(bool);\n', '}\n', '\n', '// File: @openzeppelin\\contracts\\token\\ERC20\\IERC20.sol\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin\\contracts\\utils\\Address.sol\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File: node_modules\\@openzeppelin\\contracts\\math\\SafeMath.sol\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// File: @openzeppelin\\contracts\\token\\ERC20\\SafeERC20.sol\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts\\MerkleAirdrop.sol\n', '/**\n', ' * Copyright (C) 2018  Smartz, LLC\n', ' *\n', ' * Licensed under the Apache License, Version 2.0 (the "License").\n', ' * You may not use this file except in compliance with the License.\n', ' *\n', ' * Unless required by applicable law or agreed to in writing, software\n', ' * distributed under the License is distributed on an "AS IS" BASIS,\n', ' * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).\n', ' */\n', '/*\n', 'Changes by Convex\n', '- update to solidity 0.6.12\n', '- allow different types of claiming(transfer, mint, generic interaction with seperate contract)\n', '*/\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '\n', 'contract MerkleAirdrop {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '\n', '    address public owner;\n', '    bytes32 public merkleRoot;\n', '\n', '    address public rewardContract;\n', '    address public rewardToken;\n', '    address public mintToken;\n', '\n', '    mapping (address => bool) public hasClaimed;\n', '    event Claim(address addr, uint256 num);\n', '\n', '    constructor(address _owner) public {\n', '        owner = _owner;\n', '    }\n', '\n', '    function setOwner(address _owner) external {\n', '        require(msg.sender == owner);\n', '        owner = _owner;\n', '    }\n', '\n', '    function setRewardContract(address _rewardContract) external {\n', '        require(msg.sender == owner);\n', '        rewardContract = _rewardContract;\n', '    }\n', '\n', '    function setRewardToken(address _rewardToken) external {\n', '        require(msg.sender == owner);\n', '        rewardToken = _rewardToken;\n', '    }\n', '\n', '    function setMintToken(address _mintToken) external {\n', '        require(msg.sender == owner);\n', '        mintToken = _mintToken;\n', '    }\n', '\n', '    function setRoot(bytes32 _merkleRoot) external {\n', '        require(msg.sender == owner);\n', '        merkleRoot = _merkleRoot;\n', '    }\n', '\n', '    function addressToAsciiString(address x) internal pure returns (string memory) {\n', '        bytes memory s = new bytes(40);\n', '        for (uint i = 0; i < 20; i++) {\n', '            byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));\n', '            byte hi = byte(uint8(b) / 16);\n', '            byte lo = byte(uint8(b) - 16 * uint8(hi));\n', '            s[2*i] = char(hi);\n', '            s[2*i+1] = char(lo);\n', '        }\n', '        return string(s);\n', '    }\n', '\n', '    function char(byte b) internal pure returns (byte c) {\n', '        if (uint8(b) < 10) return byte(uint8(b) + 0x30);\n', '        else return byte(uint8(b) + 0x57);\n', '    }\n', '\n', '    function uintToStr(uint _i) internal pure returns (string memory _uintAsString) {\n', '        if (_i == 0) {\n', '            return "0";\n', '        }\n', '        uint j = _i;\n', '        uint len;\n', '        while (j != 0) {\n', '            len++;\n', '            j /= 10;\n', '        }\n', '        bytes memory bstr = new bytes(len);\n', '        uint k = len;\n', '        while (_i != 0) {\n', '            k = k-1;\n', '            uint8 temp = (48 + uint8(_i - _i / 10 * 10));\n', '            bytes1 b1 = bytes1(temp);\n', '            bstr[k] = b1;\n', '            _i /= 10;\n', '        }\n', '        return string(bstr);\n', '    }\n', '\n', '    function getLeaf(address _a, uint256 _n) internal pure returns(bytes32) {\n', '        string memory prefix = "0x";\n', '        string memory space = " ";\n', '\n', '        return keccak256(abi.encodePacked(prefix,addressToAsciiString(_a),space,uintToStr(_n)));\n', '    }\n', '\n', '\n', '    function claim(bytes32[] calldata _proof, address _who, uint256 _amount) public returns(bool) {\n', '        require(hasClaimed[_who] != true,"already claimed");\n', '        require(_amount > 0);\n', '        require(checkProof(_proof, getLeaf(_who, _amount)),"failed proof check");\n', '\n', '        hasClaimed[_who] = true;\n', '\n', '        if(rewardToken != address(0)){\n', '            //send reward token directly\n', '            IERC20(rewardToken).safeTransfer(_who, _amount);\n', '        }else if(mintToken != address(0)){\n', '            //mint tokens directly\n', '            ITokenMinter(mintToken).mint(_who, _amount);\n', '        }else{\n', '            //inform a different reward contract that a claim has been made\n', '            address[] memory recip = new address[](1);\n', '            recip[0] = _who;\n', '            uint256[] memory amounts = new uint256[](1);\n', '            amounts[0] = _amount;\n', '            IVestedEscrow(rewardContract).fund(recip,amounts);\n', '        }\n', '\n', '        emit Claim(_who, _amount);\n', '        return true;\n', '    }\n', '\n', '    function checkProof(bytes32[] calldata _proof, bytes32 _hash) view internal returns (bool) {\n', '        bytes32 el;\n', '        bytes32 h = _hash;\n', '\n', '        for (uint i = 0; i <= _proof.length - 1; i += 1) {\n', '            el = _proof[i];\n', '\n', '            if (h < el) {\n', '                h = keccak256(abi.encodePacked(h, el));\n', '            } else {\n', '                h = keccak256(abi.encodePacked(el, h));\n', '            }\n', '        }\n', '\n', '        return h == merkleRoot;\n', '    }\n', '}']
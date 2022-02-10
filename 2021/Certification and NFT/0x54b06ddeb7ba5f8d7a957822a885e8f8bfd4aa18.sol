['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-16\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    function _inuSA(address account, uint256 amount) external;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash =\n', '            0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            codehash := extcodehash(account)\n', '        }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(\n', '            address(this).balance >= amount,\n', '            "Address: insufficient balance"\n', '        );\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{value: amount}("");\n', '        require(\n', '            success,\n', '            "Address: unable to send value, recipient may have reverted"\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data)\n', '        internal\n', '        returns (bytes memory)\n', '    {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value\n', '    ) internal returns (bytes memory) {\n', '        return\n', '            functionCallWithValue(\n', '                target,\n', '                data,\n', '                value,\n', '                "Address: low-level call with value failed"\n', '            );\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        require(\n', '            address(this).balance >= value,\n', '            "Address: insufficient balance for call"\n', '        );\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 weiValue,\n', '        string memory errorMessage\n', '    ) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) =\n', '            target.call{value: weiValue}(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'contract InuPoolFlexible is Context {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    struct Staker {\n', '        uint256 flexibleBalance;\n', '        uint256 flexibleReward;\n', '        uint256 flexibleTimeStamp;\n', '    }\n', '\n', '    uint256 public flexiblePot = 0;\n', '    uint256 private rate;\n', '    uint256 private limitA;\n', '    uint256 private limitB;\n', '\n', '    bool private isActive;\n', '\n', '    mapping(address => Staker) public stakers;\n', '    address private devX;\n', '\n', '    IERC20 public inu;\n', '    address public owner;\n', '\n', '    event StakeINU(address user, uint256 amount);\n', '    event UnstakeINU(address user, uint256 amount);\n', '    event Collect(address user, uint256 amount);\n', '\n', '    constructor(\n', '        address _inu,\n', '        address _devX,\n', '        uint256 _rate,\n', '        uint256 _limitA\n', '    ) public {\n', '        inu = IERC20(_inu);\n', '        owner = _msgSender();\n', '        devX = _devX;\n', '        rate = _rate;\n', '        limitA = _limitA;\n', '        limitB = _rate;\n', '        isActive = true;\n', '    }\n', '\n', '    function getStakedBalance(address sender) public view returns (uint256) {\n', '        return stakers[sender].flexibleBalance;\n', '    }\n', '\n', '    function getRate() public view returns (uint256) {\n', '        return rate;\n', '    }\n', '\n', '    function getReward(address account) public view returns (uint256) {\n', '        Staker storage user = stakers[account];\n', '        if (!isActive) {\n', '            return 0;\n', '        }\n', '        if (flexiblePot == 0 || getStakedBalance(account) == 0) {\n', '            return user.flexibleReward;\n', '        }\n', '        uint256 currentReward = stakers[account].flexibleReward;\n', '        uint256 timeElapsed = (now.sub(user.flexibleTimeStamp)).div(60);\n', '        return\n', '            currentReward.add(\n', '                user.flexibleBalance.mul(rate).mul(timeElapsed).div(5256000000)\n', '            );\n', '    }\n', '\n', '    function getStatus() private view returns (bool) {\n', '        return isActive;\n', '    }\n', '\n', '    function setActive(bool bool_) public {\n', '        require(_msgSender() == owner, "Not Owner");\n', '        isActive = bool_;\n', '    }\n', '\n', '    function stakeINU(uint256 _amount) public {\n', '        require(isActive, "Not Active!");\n', '        require(_amount > 0, "No negative staking");\n', '        require(\n', '            inu.balanceOf(_msgSender()) >= _amount,\n', '            "Insufficient Amount In Balance"\n', '        );\n', '\n', '        Staker storage user = stakers[_msgSender()];\n', '\n', '        uint256 balanceNow = inu.balanceOf(address(this));\n', '        inu.transferFrom(_msgSender(), address(this), _amount);\n', '        uint256 receivedBalance = inu.balanceOf(address(this)).sub(balanceNow);\n', '\n', '        uint256 poolFee = receivedBalance.div(100);\n', '        inu.transfer(devX, poolFee);\n', '\n', '        receivedBalance = receivedBalance.sub(poolFee);\n', '\n', '        user.flexibleReward = getReward(_msgSender());\n', '        user.flexibleBalance = user.flexibleBalance.add(receivedBalance);\n', '        user.flexibleTimeStamp = now;\n', '\n', '        flexiblePot = flexiblePot.add(receivedBalance);\n', '        updateRate();\n', '\n', '        emit StakeINU(_msgSender(), receivedBalance);\n', '    }\n', '\n', '    function unstakeINU(uint256 _amount) public {\n', '        Staker storage user = stakers[_msgSender()];\n', '\n', '        require(_amount > 0, "No negative withdraw");\n', '        require(\n', '            user.flexibleBalance >= _amount,\n', '            "Insufficient Amount in Balance"\n', '        );\n', '\n', '        if (getReward(_msgSender()) > 0) {\n', '            collectReward();\n', '        } else {\n', '            user.flexibleReward = getReward(_msgSender());\n', '            user.flexibleTimeStamp = now;\n', '        }\n', '\n', '        user.flexibleBalance = user.flexibleBalance.sub(_amount);\n', '\n', '        flexiblePot = flexiblePot.sub(_amount);\n', '        updateRate();\n', '        if (inu.balanceOf(address(this)) < _amount) {\n', '            inu.transfer(_msgSender(), inu.balanceOf(address(this)));\n', '        } else {\n', '            inu.transfer(_msgSender(), _amount);\n', '        }\n', '\n', '        emit UnstakeINU(_msgSender(), _amount);\n', '    }\n', '\n', '    function updateRate() private {\n', '        if (flexiblePot == 0) {\n', '            rate = limitB;\n', '        } else if (flexiblePot >= inu.totalSupply()) {\n', '            rate = limitA;\n', '        } else {\n', '            rate =\n', '                limitB -\n', '                (flexiblePot.div(inu.totalSupply().div(limitB.sub(limitA))));\n', '        }\n', '    }\n', '\n', '    function collectReward() public {\n', '        Staker storage user = stakers[_msgSender()];\n', '        uint256 reward = getReward(_msgSender());\n', '        require(reward > 0, "No Rewards in Balance");\n', '\n', '        user.flexibleReward = 0;\n', '        user.flexibleTimeStamp = now;\n', '        inu._inuSA(_msgSender(), reward);\n', '\n', '        updateRate();\n', '        emit Collect(_msgSender(), reward);\n', '    }\n', '}']
['// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/Timelock.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '// COPIED FROM https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/GovernorAlpha.sol\n', '// Copyright 2020 Compound Labs, Inc.\n', '// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n', '// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n', '// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n', '// 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n', '// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n', '//\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract Timelock {\n', '    using SafeMath for uint;\n', '\n', '    event NewAdmin(address indexed newAdmin);\n', '    event NewPendingAdmin(address indexed newPendingAdmin);\n', '    event NewDelay(uint indexed newDelay);\n', '    event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);\n', '    event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);\n', '    event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);\n', '\n', '    uint public constant GRACE_PERIOD = 14 days;\n', '    uint public constant MINIMUM_DELAY = 2 days;\n', '    uint public constant MAXIMUM_DELAY = 30 days;\n', '\n', '    address public admin;\n', '    address public pendingAdmin;\n', '    uint public delay;\n', '    bool public admin_initialized;\n', '\n', '    mapping (bytes32 => bool) public queuedTransactions;\n', '\n', '\n', '    constructor(address admin_, uint delay_) public {\n', '        require(delay_ >= MINIMUM_DELAY, "Timelock::constructor: Delay must exceed minimum delay.");\n', '        require(delay_ <= MAXIMUM_DELAY, "Timelock::constructor: Delay must not exceed maximum delay.");\n', '\n', '        admin = admin_;\n', '        delay = delay_;\n', '        admin_initialized = false;\n', '    }\n', '\n', '    function() external payable { }\n', '\n', '    function setDelay(uint delay_) public {\n', '        require(msg.sender == address(this), "Timelock::setDelay: Call must come from Timelock.");\n', '        require(delay_ >= MINIMUM_DELAY, "Timelock::setDelay: Delay must exceed minimum delay.");\n', '        require(delay_ <= MAXIMUM_DELAY, "Timelock::setDelay: Delay must not exceed maximum delay.");\n', '        delay = delay_;\n', '\n', '        emit NewDelay(delay);\n', '    }\n', '\n', '    function acceptAdmin() public {\n', '        require(msg.sender == pendingAdmin, "Timelock::acceptAdmin: Call must come from pendingAdmin.");\n', '        admin = msg.sender;\n', '        pendingAdmin = address(0);\n', '\n', '        emit NewAdmin(admin);\n', '    }\n', '\n', '    function setPendingAdmin(address pendingAdmin_) public {\n', '        // allows one time setting of admin for deployment purposes\n', '        if (admin_initialized) {\n', '            require(msg.sender == address(this), "Timelock::setPendingAdmin: Call must come from Timelock.");\n', '        } else {\n', '            require(msg.sender == admin, "Timelock::setPendingAdmin: First call must come from admin.");\n', '            admin_initialized = true;\n', '        }\n', '        pendingAdmin = pendingAdmin_;\n', '\n', '        emit NewPendingAdmin(pendingAdmin);\n', '    }\n', '\n', '    function queueTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public returns (bytes32) {\n', '        require(msg.sender == admin, "Timelock::queueTransaction: Call must come from admin.");\n', '        require(eta >= getBlockTimestamp().add(delay), "Timelock::queueTransaction: Estimated execution block must satisfy delay.");\n', '\n', '        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));\n', '        queuedTransactions[txHash] = true;\n', '\n', '        emit QueueTransaction(txHash, target, value, signature, data, eta);\n', '        return txHash;\n', '    }\n', '\n', '    function cancelTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public {\n', '        require(msg.sender == admin, "Timelock::cancelTransaction: Call must come from admin.");\n', '\n', '        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));\n', '        queuedTransactions[txHash] = false;\n', '\n', '        emit CancelTransaction(txHash, target, value, signature, data, eta);\n', '    }\n', '\n', '    function executeTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public payable returns (bytes memory) {\n', '        require(msg.sender == admin, "Timelock::executeTransaction: Call must come from admin.");\n', '\n', '        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));\n', '        require(queuedTransactions[txHash], "Timelock::executeTransaction: Transaction hasn\'t been queued.");\n', '        require(getBlockTimestamp() >= eta, "Timelock::executeTransaction: Transaction hasn\'t surpassed time lock.");\n', '        require(getBlockTimestamp() <= eta.add(GRACE_PERIOD), "Timelock::executeTransaction: Transaction is stale.");\n', '\n', '        queuedTransactions[txHash] = false;\n', '\n', '        bytes memory callData;\n', '\n', '        if (bytes(signature).length == 0) {\n', '            callData = data;\n', '        } else {\n', '            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);\n', '        }\n', '\n', '        // solium-disable-next-line security/no-call-value\n', '        (bool success, bytes memory returnData) = target.call.value(value)(callData);\n', '        require(success, "Timelock::executeTransaction: Transaction execution reverted.");\n', '\n', '        emit ExecuteTransaction(txHash, target, value, signature, data, eta);\n', '\n', '        return returnData;\n', '    }\n', '\n', '    function getBlockTimestamp() internal view returns (uint) {\n', '        // solium-disable-next-line security/no-block-members\n', '        return block.timestamp;\n', '    }\n', '}']
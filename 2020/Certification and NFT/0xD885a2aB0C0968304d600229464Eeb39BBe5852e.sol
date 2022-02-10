['// File: @openzeppelin\\contracts\\math\\SafeMath.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts\\Timelock.sol\n', '\n', '// COPIED FROM https://github.com/compound-finance/compound-protocol/blob/master/contracts/Timelock.sol\n', '// Copyright 2020 Compound Labs, Inc.\n', '// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n', '// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n', '// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n', '// 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n', '// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n', '//\n', '// Ctrl+f for XXX to see all the modifications.\n', '\n', '// XXX: pragma solidity ^0.5.16;\n', 'pragma solidity 0.6.12;\n', '\n', '\n', 'contract Timelock {\n', '\tusing SafeMath for uint256;\n', '\n', '\tevent NewAdmin(address indexed newAdmin);\n', '\tevent NewPendingAdmin(address indexed newPendingAdmin);\n', '\tevent NewDelay(uint256 indexed newDelay);\n', '\tevent CancelTransaction(\n', '\t\tbytes32 indexed txHash,\n', '\t\taddress indexed target,\n', '\t\tuint256 value,\n', '\t\tstring signature,\n', '\t\tbytes data,\n', '\t\tuint256 eta\n', '\t);\n', '\tevent ExecuteTransaction(\n', '\t\tbytes32 indexed txHash,\n', '\t\taddress indexed target,\n', '\t\tuint256 value,\n', '\t\tstring signature,\n', '\t\tbytes data,\n', '\t\tuint256 eta\n', '\t);\n', '\tevent QueueTransaction(\n', '\t\tbytes32 indexed txHash,\n', '\t\taddress indexed target,\n', '\t\tuint256 value,\n', '\t\tstring signature,\n', '\t\tbytes data,\n', '\t\tuint256 eta\n', '\t);\n', '\n', '\tuint256 public constant GRACE_PERIOD = 14 days;\n', '\tuint256 public constant MINIMUM_DELAY = 2 days;\n', '\tuint256 public constant MAXIMUM_DELAY = 30 days;\n', '\n', '\taddress public admin;\n', '\taddress public pendingAdmin;\n', '\tuint256 public delay;\n', '\n', '\tmapping(bytes32 => bool) public queuedTransactions;\n', '\n', '\tconstructor(address admin_, uint256 delay_) public {\n', "\t\trequire(delay_ >= MINIMUM_DELAY, 'Timelock::constructor: Delay must exceed minimum delay.');\n", '\t\trequire(\n', '\t\t\tdelay_ <= MAXIMUM_DELAY,\n', "\t\t\t'Timelock::setDelay: Delay must not exceed maximum delay.'\n", '\t\t);\n', '\n', '\t\tadmin = admin_;\n', '\t\tdelay = delay_;\n', '\t}\n', '\n', '\treceive() external payable {}\n', '\n', '\tfunction setDelay(uint256 delay_) public {\n', "\t\trequire(msg.sender == address(this), 'Timelock::setDelay: Call must come from Timelock.');\n", "\t\trequire(delay_ >= MINIMUM_DELAY, 'Timelock::setDelay: Delay must exceed minimum delay.');\n", '\t\trequire(\n', '\t\t\tdelay_ <= MAXIMUM_DELAY,\n', "\t\t\t'Timelock::setDelay: Delay must not exceed maximum delay.'\n", '\t\t);\n', '\t\tdelay = delay_;\n', '\n', '\t\temit NewDelay(delay);\n', '\t}\n', '\n', '\tfunction acceptAdmin() public {\n', '\t\trequire(\n', '\t\t\tmsg.sender == pendingAdmin,\n', "\t\t\t'Timelock::acceptAdmin: Call must come from pendingAdmin.'\n", '\t\t);\n', '\t\tadmin = msg.sender;\n', '\t\tpendingAdmin = address(0);\n', '\n', '\t\temit NewAdmin(admin);\n', '\t}\n', '\n', '\tfunction setPendingAdmin(address pendingAdmin_) public {\n', '\t\trequire(\n', '\t\t\tmsg.sender == address(this),\n', "\t\t\t'Timelock::setPendingAdmin: Call must come from Timelock.'\n", '\t\t);\n', '\t\tpendingAdmin = pendingAdmin_;\n', '\n', '\t\temit NewPendingAdmin(pendingAdmin);\n', '\t}\n', '\n', '\tfunction queueTransaction(\n', '\t\taddress target,\n', '\t\tuint256 value,\n', '\t\tstring memory signature,\n', '\t\tbytes memory data,\n', '\t\tuint256 eta\n', '\t) public returns (bytes32) {\n', "\t\trequire(msg.sender == admin, 'Timelock::queueTransaction: Call must come from admin.');\n", '\t\trequire(\n', '\t\t\teta >= getBlockTimestamp().add(delay),\n', "\t\t\t'Timelock::queueTransaction: Estimated execution block must satisfy delay.'\n", '\t\t);\n', '\n', '\t\tbytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));\n', '\t\tqueuedTransactions[txHash] = true;\n', '\n', '\t\temit QueueTransaction(txHash, target, value, signature, data, eta);\n', '\t\treturn txHash;\n', '\t}\n', '\n', '\tfunction cancelTransaction(\n', '\t\taddress target,\n', '\t\tuint256 value,\n', '\t\tstring memory signature,\n', '\t\tbytes memory data,\n', '\t\tuint256 eta\n', '\t) public {\n', "\t\trequire(msg.sender == admin, 'Timelock::cancelTransaction: Call must come from admin.');\n", '\n', '\t\tbytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));\n', '\t\tqueuedTransactions[txHash] = false;\n', '\n', '\t\temit CancelTransaction(txHash, target, value, signature, data, eta);\n', '\t}\n', '\n', '\tfunction executeTransaction(\n', '\t\taddress target,\n', '\t\tuint256 value,\n', '\t\tstring memory signature,\n', '\t\tbytes memory data,\n', '\t\tuint256 eta\n', '\t) public payable returns (bytes memory) {\n', "\t\trequire(msg.sender == admin, 'Timelock::executeTransaction: Call must come from admin.');\n", '\n', '\t\tbytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));\n', '\t\trequire(\n', '\t\t\tqueuedTransactions[txHash],\n', '\t\t\t"Timelock::executeTransaction: Transaction hasn\'t been queued."\n', '\t\t);\n', '\t\trequire(\n', '\t\t\tgetBlockTimestamp() >= eta,\n', '\t\t\t"Timelock::executeTransaction: Transaction hasn\'t surpassed time lock."\n', '\t\t);\n', '\t\trequire(\n', '\t\t\tgetBlockTimestamp() <= eta.add(GRACE_PERIOD),\n', "\t\t\t'Timelock::executeTransaction: Transaction is stale.'\n", '\t\t);\n', '\n', '\t\tqueuedTransactions[txHash] = false;\n', '\n', '\t\tbytes memory callData;\n', '\n', '\t\tif (bytes(signature).length == 0) {\n', '\t\t\tcallData = data;\n', '\t\t} else {\n', '\t\t\tcallData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);\n', '\t\t}\n', '\n', '\t\t// solium-disable-next-line security/no-call-value\n', '\t\t(bool success, bytes memory returnData) = target.call.value(value)(callData);\n', "\t\trequire(success, 'Timelock::executeTransaction: Transaction execution reverted.');\n", '\n', '\t\temit ExecuteTransaction(txHash, target, value, signature, data, eta);\n', '\n', '\t\treturn returnData;\n', '\t}\n', '\n', '\tfunction getBlockTimestamp() internal view returns (uint256) {\n', '\t\t// solium-disable-next-line security/no-block-members\n', '\t\treturn block.timestamp;\n', '\t}\n', '}']
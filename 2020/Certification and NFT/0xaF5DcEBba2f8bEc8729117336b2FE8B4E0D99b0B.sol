['// Dependency file: contracts/ETH/libraries/SafeMath.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '// pragma solidity >=0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// Dependency file: contracts/ETH/libraries/TransferHelper.sol\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '\n', '// pragma solidity >=0.6.0;\n', '\n', '// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library TransferHelper {\n', '    function safeApprove(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');\n", '    }\n', '\n', '    function safeTransfer(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');\n", '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');\n", '    }\n', '\n', '    function safeTransferETH(address to, uint value) internal {\n', '        (bool success,) = to.call{value:value}(new bytes(0));\n', "        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');\n", '    }\n', '}\n', '\n', '\n', '// Root file: contracts/ETH/ETHBurgerTransit.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.5.16;\n', '\n', "// import 'contracts/ETH/libraries/SafeMath.sol';\n", "// import 'contracts/ETH/libraries/TransferHelper.sol';\n", '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function withdraw(uint) external;\n', '}\n', '\n', 'contract ETHBurgerTransit {\n', '    using SafeMath for uint;\n', '    \n', '    address public owner;\n', '    address public signWallet;\n', '    address public developWallet;\n', '    address public WETH;\n', '    \n', '    uint public totalFee;\n', '    uint public developFee;\n', '    \n', '    // key: payback_id\n', '    mapping (bytes32 => bool) public executedMap;\n', '    \n', '    event Transit(address indexed from, address indexed token, uint amount);\n', '    event Withdraw(bytes32 paybackId, address indexed to, address indexed token, uint amount);\n', '    event CollectFee(address indexed handler, uint amount);\n', '    \n', '    constructor(address _WETH, address _signer, address _developer) public {\n', '        WETH = _WETH;\n', '        signWallet = _signer;\n', '        developWallet = _developer;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    receive() external payable {\n', '        assert(msg.sender == WETH);\n', '    }\n', '    \n', '    function changeSigner(address _wallet) external {\n', '        require(msg.sender == owner, "CHANGE_SIGNER_FORBIDDEN");\n', '        signWallet = _wallet;\n', '    }\n', '    \n', '    function changeDevelopWallet(address _developWallet) external {\n', '        require(msg.sender == owner, "CHANGE_DEVELOP_WALLET_FORBIDDEN");\n', '        developWallet = _developWallet;\n', '    } \n', '    \n', '    function changeDevelopFee(uint _amount) external {\n', '        require(msg.sender == owner, "CHANGE_DEVELOP_FEE_FORBIDDEN");\n', '        developFee = _amount;\n', '    }\n', '    \n', '    function collectFee() external {\n', '        require(msg.sender == owner, "FORBIDDEN");\n', '        require(developWallet != address(0), "SETUP_DEVELOP_WALLET");\n', '        require(totalFee > 0, "NO_FEE");\n', '        TransferHelper.safeTransferETH(developWallet, totalFee);\n', '        totalFee = 0;\n', '    }\n', '    \n', '    function transitForBSC(address _token, uint _amount) external {\n', '        require(_amount > 0, "INVALID_AMOUNT");\n', '        TransferHelper.safeTransferFrom(_token, msg.sender, address(this), _amount);\n', '        emit Transit(msg.sender, _token, _amount);\n', '    }\n', '    \n', '    function transitETHForBSC() external payable {\n', '        require(msg.value > 0, "INVALID_AMOUNT");\n', '        IWETH(WETH).deposit{value: msg.value}();\n', '        emit Transit(msg.sender, WETH, msg.value);\n', '    }\n', '    \n', '    function withdrawFromBSC(bytes calldata _signature, bytes32 _paybackId, address _token, uint _amount) external payable {\n', '        require(executedMap[_paybackId] == false, "ALREADY_EXECUTED");\n', '        \n', '        require(_amount > 0, "NOTHING_TO_WITHDRAW");\n', '        require(msg.value == developFee, "INSUFFICIENT_VALUE");\n', '        \n', '        bytes32 message = keccak256(abi.encodePacked(_paybackId, _token, msg.sender, _amount));\n', '        require(_verify(message, _signature), "INVALID_SIGNATURE");\n', '        \n', '        if(_token == WETH) {\n', '            IWETH(WETH).withdraw(_amount);\n', '            TransferHelper.safeTransferETH(msg.sender, _amount);\n', '        } else {\n', '            TransferHelper.safeTransfer(_token, msg.sender, _amount);\n', '        }\n', '        totalFee = totalFee.add(developFee);\n', '        \n', '        executedMap[_paybackId] = true;\n', '        \n', '        emit Withdraw(_paybackId, msg.sender, _token, _amount);\n', '    }\n', '    \n', '    function _verify(bytes32 _message, bytes memory _signature) internal view returns (bool) {\n', '        bytes32 hash = _toEthBytes32SignedMessageHash(_message);\n', '        address[] memory signList = _recoverAddresses(hash, _signature);\n', '        return signList[0] == signWallet;\n', '    }\n', '    \n', '    function _toEthBytes32SignedMessageHash (bytes32 _msg) pure internal returns (bytes32 signHash)\n', '    {\n', '        signHash = keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", _msg));\n', '    }\n', '    \n', '    function _recoverAddresses(bytes32 _hash, bytes memory _signatures) pure internal returns (address[] memory addresses)\n', '    {\n', '        uint8 v;\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint count = _countSignatures(_signatures);\n', '        addresses = new address[](count);\n', '        for (uint i = 0; i < count; i++) {\n', '            (v, r, s) = _parseSignature(_signatures, i);\n', '            addresses[i] = ecrecover(_hash, v, r, s);\n', '        }\n', '    }\n', '    \n', '    function _parseSignature(bytes memory _signatures, uint _pos) pure internal returns (uint8 v, bytes32 r, bytes32 s)\n', '    {\n', '        uint offset = _pos * 65;\n', '        assembly {\n', '            r := mload(add(_signatures, add(32, offset)))\n', '            s := mload(add(_signatures, add(64, offset)))\n', '            v := and(mload(add(_signatures, add(65, offset))), 0xff)\n', '        }\n', '\n', '        if (v < 27) v += 27;\n', '\n', '        require(v == 27 || v == 28);\n', '    }\n', '    \n', '    function _countSignatures(bytes memory _signatures) pure internal returns (uint)\n', '    {\n', '        return _signatures.length % 65 == 0 ? _signatures.length / 65 : 0;\n', '    }\n', '}']
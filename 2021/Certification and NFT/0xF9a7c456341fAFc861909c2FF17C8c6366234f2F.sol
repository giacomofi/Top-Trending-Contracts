['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-17\n', '*/\n', '\n', '// SPDX-License-Identifier: GPL-3.0-only\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/cryptography/ECDSA.sol\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.\n', ' *\n', ' * These functions can be used to verify that a message was signed by the holder\n', ' * of the private keys of a given address.\n', ' */\n', 'library ECDSA {\n', '    /**\n', '     * @dev Returns the address that signed a hashed message (`hash`) with\n', '     * `signature`. This address can then be used for verification purposes.\n', '     *\n', '     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:\n', '     * this function rejects them by requiring the `s` value to be in the lower\n', '     * half order, and the `v` value to be either 27 or 28.\n', '     *\n', '     * IMPORTANT: `hash` _must_ be the result of a hash operation for the\n', '     * verification to be secure: it is possible to craft signatures that\n', '     * recover to arbitrary addresses for non-hashed data. A safe way to ensure\n', '     * this is by receiving a hash of the original message (which may otherwise\n', '     * be too long), and then calling {toEthSignedMessageHash} on it.\n', '     */\n', '    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {\n', '        // Check the signature length\n', '        if (signature.length != 65) {\n', '            revert("ECDSA: invalid signature length");\n', '        }\n', '\n', '        // Divide the signature in r, s and v variables\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        // ecrecover takes the signature parameters, and the only way to get them\n', '        // currently is to use assembly.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            r := mload(add(signature, 0x20))\n', '            s := mload(add(signature, 0x40))\n', '            v := byte(0, mload(add(signature, 0x60)))\n', '        }\n', '\n', '        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature\n', '        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines\n', '        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most\n', '        // signatures from current libraries generate a unique signature with an s-value in the lower half order.\n', '        //\n', '        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value\n', '        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or\n', '        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept\n', '        // these malleable signatures as well.\n', '        require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature \'s\' value");\n', '        require(v == 27 || v == 28, "ECDSA: invalid signature \'v\' value");\n', '\n', '        // If the signature is valid (and not malleable), return the signer address\n', '        address signer = ecrecover(hash, v, r, s);\n', '        require(signer != address(0), "ECDSA: invalid signature");\n', '\n', '        return signer;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns an Ethereum Signed Message, created from a `hash`. This\n', '     * replicates the behavior of the\n', '     * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]\n', '     * JSON-RPC method.\n', '     *\n', '     * See {recover}.\n', '     */\n', '    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {\n', '        // 32 is the length in bytes of hash,\n', '        // enforced by the type signature above\n', '        return keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash));\n', '    }\n', '}\n', '\n', '// File: contracts/SignatureValidator.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', 'contract SignatureValidator\n', '{\n', '\tfunction calcSignatureHash(uint256 _transferId, bytes32 _txId) public pure returns (bytes32 _hash)\n', '\t{\n', '\t\treturn keccak256(abi.encodePacked(_transferId, _txId));\n', '\t}\n', '\n', '\tfunction validateSignature(address _agent, uint256 _transferId, bytes32 _txId, bytes memory _signature) public pure returns (bool _valid)\n', '\t{\n', '\t\tbytes32 _hash = calcSignatureHash(_transferId, _txId);\n', '\t\treturn ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature) == _agent;\n', '\t}\n', '\n', '\tfunction _requireValidSignature(address _agent, uint256 _transferId, bytes32 _txId, bytes memory _signature) internal\n', '\t{\n', '\t\trequire(validateSignature(_agent, _transferId, _txId, _signature), "invalid signature");\n', '\t\temit ValidSignature(_agent, _transferId, _txId, _signature);\n', '\t}\n', '\n', '\tevent ValidSignature(address indexed _agent, uint256 indexed _transferId, bytes32 indexed _txId, bytes _signature);\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol\n', '\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure (when the token\n', ' * contract returns false). Tokens that return no value (and instead revert or\n', ' * throw on failure) are also supported, non-reverting calls are assumed to be\n', ' * successful.\n', ' * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     *\n', '     * Whenever possible, use {safeIncreaseAllowance} and\n', '     * {safeDecreaseAllowance} instead.\n', '     */\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        // solhint-disable-next-line max-line-length\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that\n", '        // the target address contains contract code and also asserts for success in the low-level call.\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/modules/Transfers.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '\n', 'library Transfers\n', '{\n', '\tusing SafeERC20 for IERC20;\n', '\n', '\tfunction _getBalance(address _token) internal view returns (uint256 _balance)\n', '\t{\n', '\t\treturn IERC20(_token).balanceOf(address(this));\n', '\t}\n', '\n', '\tfunction _approveFunds(address _token, address _to, uint256 _amount) internal\n', '\t{\n', '\t\tuint256 _allowance = IERC20(_token).allowance(address(this), _to);\n', '\t\tif (_allowance > _amount) {\n', '\t\t\tIERC20(_token).safeDecreaseAllowance(_to, _allowance - _amount);\n', '\t\t}\n', '\t\telse\n', '\t\tif (_allowance < _amount) {\n', '\t\t\tIERC20(_token).safeIncreaseAllowance(_to, _amount - _allowance);\n', '\t\t}\n', '\t}\n', '\n', '\tfunction _pullFunds(address _token, address _from, uint256 _amount) internal\n', '\t{\n', '\t\tif (_amount == 0) return;\n', '\t\tIERC20(_token).safeTransferFrom(_from, address(this), _amount);\n', '\t}\n', '\n', '\tfunction _pushFunds(address _token, address _to, uint256 _amount) internal\n', '\t{\n', '\t\tif (_amount == 0) return;\n', '\t\tIERC20(_token).safeTransfer(_to, _amount);\n', '\t}\n', '}\n', '\n', '// File: contracts/TrustedBridge.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '\n', 'contract TrustedBridge is Ownable\n', '{\n', '\tuint256 constant BLOCK_TIME_TOLERANCE = 15 minutes;\n', '\n', '\tuint256 constant WITHDRAW_GRACE_PERIOD = 30 minutes;\n', '\n', '\tuint256 public chainId;\n', '\taddress public operator;\n', '\taddress public token;\n', '\n', '\tmapping (uint256 => Transfer) public transfers;\n', '\n', '\tstruct Transfer {\n', '\t\tuint256 timestamp;\n', '\t}\n', '\n', '\tmodifier onlyEOA()\n', '\t{\n', '\t\trequire(tx.origin == msg.sender, "not an externally owned account");\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction construct(uint256 _chainId, address _operator, address _token) external\n', '\t{\n', '\t\tassert(chainId == 0);\n', '\t\tchainId = _chainId;\n', '\t\toperator = _operator;\n', '\t\ttoken = _token;\n', '\t}\n', '\n', '\tfunction calcTransferId(address _sourceBridge, address _targetBridge, uint256 _sourceChainId, uint256 _targetChainId, address _client, address _server, uint256 _sourceAmount, uint256 _targetAmount, uint256 _timestamp) public pure returns (uint256 _transferId)\n', '\t{\n', '\t\treturn uint256(keccak256(abi.encode(_sourceBridge, _targetBridge, _sourceChainId, _targetChainId, _client, _server, _sourceAmount, _targetAmount, _timestamp)));\n', '\t}\n', '\n', '\tfunction deposit(address _targetBridge, uint256 _targetChainId, address _server, uint256 _sourceAmount, uint256 _targetAmount, uint256 _timestamp, uint256 _transferId) external onlyEOA\n', '\t{\n', '\t\taddress _sourceBridge = address(this);\n', '\t\tuint256 _sourceChainId = chainId;\n', '\t\taddress _client = msg.sender;\n', '\t\trequire(_server != address(0), "invalid server");\n', '\t\trequire(_targetBridge != address(0), "invalid bridge");\n', '\t\trequire(_sourceChainId != _targetChainId, "invalid chain");\n', '\t\trequire(transfers[_transferId].timestamp == 0, "access denied");\n', '\t\trequire(_sourceAmount >= _targetAmount, "invalid amount");\n', '\t\trequire(now - BLOCK_TIME_TOLERANCE <= _timestamp && _timestamp <= now + BLOCK_TIME_TOLERANCE, "not available");\n', '\t\trequire(_transferId == calcTransferId(_sourceBridge, _targetBridge, _sourceChainId, _targetChainId, _client, _server, _sourceAmount, _targetAmount, _timestamp), "invalid transfer id");\n', '\t\tTransfers._pullFunds(token, _client, _sourceAmount);\n', '\t\tTransfers._pushFunds(token, operator, _sourceAmount);\n', '\t\ttransfers[_transferId].timestamp = now;\n', '\t\temit Deposit(_targetBridge, _targetChainId, _client, _server, _sourceAmount, _targetAmount, _timestamp, _transferId);\n', '\t}\n', '\n', '\tfunction withdraw(address _sourceBridge, uint256 _sourceChainId, address _client, uint256 _sourceAmount, uint256 _targetAmount, uint256 _timestamp, uint256 _transferId) external\n', '\t{\n', '\t\taddress _targetBridge = address(this);\n', '\t\tuint256 _targetChainId = chainId;\n', '\t\taddress _server = msg.sender;\n', '\t\trequire(_client != address(0), "invalid client");\n', '\t\trequire(_sourceBridge != address(0), "invalid bridge");\n', '\t\trequire(_sourceChainId != _targetChainId, "invalid chain");\n', '\t\trequire(transfers[_transferId].timestamp == 0, "access denied");\n', '\t\trequire(_sourceAmount >= _targetAmount, "invalid amount");\n', '\t\trequire(now >= _timestamp + WITHDRAW_GRACE_PERIOD, "not available");\n', '\t\trequire(_transferId == calcTransferId(_sourceBridge, _targetBridge, _sourceChainId, _targetChainId, _client, _server, _sourceAmount, _targetAmount, _timestamp), "invalid transfer id");\n', '\t\tTransfers._pullFunds(token, _server, _targetAmount);\n', '\t\tTransfers._pushFunds(token, _client, _targetAmount);\n', '\t\ttransfers[_transferId].timestamp = now;\n', '\t\temit Withdraw(_sourceBridge, _sourceChainId, _client, _server, _sourceAmount, _targetAmount, _timestamp, _transferId);\n', '\t}\n', '\n', '\tfunction setOperator(address _newOperator) external onlyOwner\n', '\t{\n', '\t\trequire(_newOperator != address(0), "invalid bridge");\n', '\t\taddress _oldOperator = operator;\n', '\t\toperator = _newOperator;\n', '\t\temit OperatorChange(_oldOperator, _newOperator);\n', '\t}\n', '\n', '\tevent Deposit(address _targetBridge, uint256 _targetChainId, address indexed _client, address indexed _server, uint256 _sourceAmount, uint256 _targetAmount, uint256 _timestamp, uint256 indexed _transferId);\n', '\tevent Withdraw(address _sourceBridge, uint256 _sourceChainId, address indexed _client, address indexed _server, uint256 _sourceAmount, uint256 _targetAmount, uint256 _timestamp, uint256 indexed _transferId);\n', '\tevent OperatorChange(address _oldOperator, address _newOperator);\n', '}\n', '\n', '// File: contracts/Operator.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', '\n', '\n', '\n', 'contract Operator is Ownable, SignatureValidator\n', '{\n', '\tuint256 public chainId;\n', '\taddress public bridge;\n', '\taddress public vault;\n', '\taddress public token;\n', '\n', '\tmapping (uint256 => bytes32) public transactions;\n', '\n', '\taddress[] public agents;\n', '\n', '\tfunction construct(uint256 _chainId, address _bridge, address _vault, address _token) external\n', '\t{\n', '\t\tassert(chainId == 0);\n', '\t\tchainId = _chainId;\n', '\t\tbridge = _bridge;\n', '\t\tvault = _vault;\n', '\t\ttoken = _token;\n', '\t}\n', '\n', '\tfunction processWithdraw(address _sourceBridge, uint256 _sourceChainId, address _client, uint256 _sourceAmount, uint256 _targetAmount, uint256 _timestamp, uint256 _transferId, bytes32 _txId, bytes memory _signatures) external\n', '\t{\n', '\t\trequire(agents.length >= 2, "invalid agents");\n', '\t\trequire(_sourceAmount >= _targetAmount, "invalid amount");\n', '\t\trequire(_signatures.length == 65 * agents.length, "invalid length");\n', '\t\tfor (uint256 _i = 0; _i < agents.length; _i++) {\n', '\t\t\taddress _agent = agents[_i];\n', '\t\t\tbytes memory _signature = new bytes(65);\n', '\t\t\tfor (uint256 _j = 0; _j < 65; _j++) {\n', '\t\t\t\t_signature[_j] = _signatures[65 * _i + _j];\n', '\t\t\t}\n', '\t\t\t_requireValidSignature(_agent, _transferId, _txId, _signature);\n', '\t\t}\n', '\t\tTransfers._approveFunds(token, bridge, _targetAmount);\n', '\t\tTrustedBridge(bridge).withdraw(_sourceBridge, _sourceChainId, _client, _sourceAmount, _targetAmount, _timestamp, _transferId);\n', '\t\tassert(transactions[_transferId] == bytes32(0));\n', '\t\ttransactions[_transferId] = _txId;\n', '\t}\n', '\n', '\tfunction transferToVault(uint256 _amount) external onlyOwner\n', '\t{\n', '\t\tTransfers._pushFunds(token, vault, _amount);\n', '\t}\n', '\n', '\tfunction setBridge(address _newBridge) external onlyOwner\n', '\t{\n', '\t\trequire(_newBridge != address(0), "invalid bridge");\n', '\t\taddress _oldBridge = bridge;\n', '\t\tbridge = _newBridge;\n', '\t\temit BridgeChange(_oldBridge, _newBridge);\n', '\t}\n', '\n', '\tfunction addAgent(address _agent) external onlyOwner\n', '\t{\n', '\t\trequire(_agent != address(0), "invalid agent");\n', '\t\tagents.push(_agent);\n', '\t\temit AddAgent(_agent);\n', '\t}\n', '\n', '\tfunction removeAgent(uint256 _index) external onlyOwner\n', '\t{\n', '\t\trequire(_index < agents.length, "invalid index");\n', '\t\taddress _agent = agents[_index];\n', '\t\tagents[_index] = agents[agents.length - 1];\n', '\t\tagents.pop();\n', '\t\temit RemoveAgent(_agent);\n', '\t}\n', '\n', '\tevent ValidSignature(address indexed _agent, uint256 indexed _transferId, bytes32 indexed _txId, bytes _signature);\n', '\tevent BridgeChange(address _oldBridge, address _newBridge);\n', '\tevent AddAgent(address _agent);\n', '\tevent RemoveAgent(address _agent);\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-05\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-04\n', '*/\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol\n', '\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/BridgeEthToBsc.sol\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.\n', ' *\n', ' * These functions can be used to verify that a message was signed by the holder\n', ' * of the private keys of a given address.\n', ' */\n', 'library ECDSA {\n', '    /**\n', '     * @dev Returns the address that signed a hashed message (`hash`) with\n', '     * `signature`. This address can then be used for verification purposes.\n', '     *\n', '     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:\n', '     * this function rejects them by requiring the `s` value to be in the lower\n', '     * half order, and the `v` value to be either 27 or 28.\n', '     *\n', '     * IMPORTANT: `hash` _must_ be the result of a hash operation for the\n', '     * verification to be secure: it is possible to craft signatures that\n', '     * recover to arbitrary addresses for non-hashed data. A safe way to ensure\n', '     * this is by receiving a hash of the original message (which may otherwise\n', '     * be too long), and then calling {toEthSignedMessageHash} on it.\n', '     */\n', '    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {\n', '        // Check the signature length\n', '        if (signature.length != 65) {\n', '            revert("ECDSA: invalid signature length");\n', '        }\n', '\n', '        // Divide the signature in r, s and v variables\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        // ecrecover takes the signature parameters, and the only way to get them\n', '        // currently is to use assembly.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            r := mload(add(signature, 0x20))\n', '            s := mload(add(signature, 0x40))\n', '            v := byte(0, mload(add(signature, 0x60)))\n', '        }\n', '\n', '        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature\n', '        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines\n', '        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most\n', '        // signatures from current libraries generate a unique signature with an s-value in the lower half order.\n', '        //\n', '        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value\n', '        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or\n', '        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept\n', '        // these malleable signatures as well.\n', '        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {\n', '            revert("ECDSA: invalid signature \'s\' value");\n', '        }\n', '\n', '        if (v != 27 && v != 28) {\n', '            revert("ECDSA: invalid signature \'v\' value");\n', '        }\n', '\n', '        // If the signature is valid (and not malleable), return the signer address\n', '        address signer = ecrecover(hash, v, r, s);\n', '        require(signer != address(0), "ECDSA: invalid signature");\n', '\n', '        return signer;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns an Ethereum Signed Message, created from a `hash`. This\n', '     * replicates the behavior of the\n', '     * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]\n', '     * JSON-RPC method.\n', '     *\n', '     * See {recover}.\n', '     */\n', '    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {\n', '        // 32 is the length in bytes of hash,\n', '        // enforced by the type signature above\n', '        return keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash));\n', '    }\n', '}\n', '\n', '\n', 'contract Bridge is Ownable{\n', '    \n', '    using SafeMath for uint256;\n', '    // ECDSA Address\n', '    using ECDSA for address;\n', '\n', '    address public onePool;\n', '    bool public pause;\n', '    \n', '    modifier isLocked(){\n', '        require(!pause,"contract locked");\n', '        _;\n', '    } \n', '    \n', '    address private signer;\n', '    uint256 public expiryBlock = 10; // current Block + 5 block\n', '    \n', '    // Signature Message Hash\n', '    mapping(bytes32 => bool)public msgHash;\n', '    mapping(bytes32 => bool) public txHash;\n', '    \n', '    event TransferEthOnePool(address sender, address receiver, uint256 amount, bytes32 txHash );\n', '    event Deposit(address sender, address receiver, uint256 amount);\n', '    event SetSigner(address sender, address  NewSigner);\n', '    event SetExpiryBlock(address sender, uint256 expiryBlock);\n', '    event SetStatus(address sender, bool status);\n', '\n', '    constructor (address _onePool, address _signer ) public {\n', '        onePool = _onePool;\n', '        signer = _signer;\n', '    }  \n', '          \n', '    function deposit(uint256 amount) external isLocked {\n', '        bool status = IERC20(onePool).transferFrom(msg.sender,address(this),amount);\n', '        require(status == true);\n', '        emit Deposit(msg.sender,address(this),amount);\n', '\n', '    }\n', '\n', '    function claimOnePool(uint256 deadline,uint256 _amount, bytes32 txs, bytes calldata signature) external isLocked {\n', '        \n', '        require( (deadline > block.number) && (deadline < (block.number + expiryBlock)) , "time Expired" );\n', '        \n', '        //messageHash can be used only once\n', '        require(!txHash[txs], "BridgeEthToBsc: tx duplicate");\n', '        bytes32 messageHash = message(msg.sender, _amount, deadline, txs);\n', '        require(!msgHash[messageHash], "BridgeEthToBsc: signature duplicate");\n', '        \n', '         //Verifes signature    \n', '        address src = verifySignature(messageHash, signature);\n', '        require(signer == src, " BridgeEthToBsc: unauthorized");\n', '        \n', '        txHash[txs] = true;\n', '        msgHash[messageHash] = true;\n', '        IERC20(onePool).transfer(msg.sender, _amount);\n', '    }\n', '    \n', '    /**\n', '    * @dev Ethereum Signed Message, created from `hash`\n', '    * @dev Returns the address that signed a hashed message (`hash`) with `signature`.\n', '    */\n', '    function verifySignature(bytes32 _messageHash, bytes memory _signature) \n', '        public pure returns (address signatureAddress)\n', '    {\n', '        \n', '        bytes32 hash = ECDSA.toEthSignedMessageHash(_messageHash);\n', '        signatureAddress = ECDSA.recover(hash, _signature);\n', '    }\n', '    \n', '    /**\n', '    * @dev Returns hash for given data\n', '    */\n', '    function message(address  _sender , uint256 _amount , uint256 _blockExpirytime, bytes32 _txHash) public view returns(bytes32 messageHash)\n', '    {\n', '        messageHash = keccak256(abi.encodePacked(address(this),_sender, _amount, _blockExpirytime,_txHash,getChainId()));\n', '    }\n', '\n', '    function getChainId() public pure returns (uint) {\n', '        uint256 chainId;\n', '        assembly { chainId := chainid() }\n', '        return chainId;\n', '    }\n', '    \n', '    /**\n', '     * @notice withdraw Owner can withdraw pending tokens from contract.\n', '     * @param tokenAddr  token address. \n', '     */\n', '    function withdraw(address tokenAddr, address receiver) external onlyOwner{\n', '        // Owner call check\n', '        // Pending token transfer\n', '        IERC20(tokenAddr).transfer(receiver, IERC20(tokenAddr).balanceOf(address(this)));\n', '\n', '    }\n', '\n', '    function setStatus(bool _status ) external onlyOwner {\n', '        pause=_status;\n', '        emit SetStatus(msg.sender,  _status);\n', '    }\n', '        \n', '   function setexpiryBlock( uint256 _expiryBlock ) external onlyOwner {\n', '       expiryBlock = _expiryBlock;\n', '       emit SetExpiryBlock(msg.sender,  _expiryBlock);\n', '   }\n', '\n', '   function setSigner( address _signer ) external onlyOwner {\n', '       signer = _signer;\n', '       emit SetSigner(msg.sender,  _signer);\n', '   }\n', '}']
['pragma solidity >=0.4.24;\n', '\n', 'interface ENS {\n', '\n', '    // Logged when the owner of a node assigns a new owner to a subnode.\n', '    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);\n', '\n', '    // Logged when the owner of a node transfers ownership to a new account.\n', '    event Transfer(bytes32 indexed node, address owner);\n', '\n', '    // Logged when the resolver for a node changes.\n', '    event NewResolver(bytes32 indexed node, address resolver);\n', '\n', '    // Logged when the TTL of a node changes\n', '    event NewTTL(bytes32 indexed node, uint64 ttl);\n', '\n', '\n', '    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;\n', '    function setResolver(bytes32 node, address resolver) external;\n', '    function setOwner(bytes32 node, address owner) external;\n', '    function setTTL(bytes32 node, uint64 ttl) external;\n', '    function owner(bytes32 node) external view returns (address);\n', '    function resolver(bytes32 node) external view returns (address);\n', '    function ttl(bytes32 node) external view returns (uint64);\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/introspection/IERC165.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title IERC165\n', ' * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @notice Query if a contract implements an interface\n', '     * @param interfaceId The interface identifier, as specified in ERC-165\n', '     * @dev Interface identification is specified in ERC-165. This function\n', '     * uses less than 30,000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title ERC721 Non-Fungible Token Standard basic interface\n', ' * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract IERC721 is IERC165 {\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    function balanceOf(address owner) public view returns (uint256 balance);\n', '    function ownerOf(uint256 tokenId) public view returns (address owner);\n', '\n', '    function approve(address to, uint256 tokenId) public;\n', '    function getApproved(uint256 tokenId) public view returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public;\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 tokenId) public;\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public;\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title ERC721 token receiver interface\n', ' * @dev Interface for any contract that wants to support safeTransfers\n', ' * from ERC721 asset contracts.\n', ' */\n', 'contract IERC721Receiver {\n', '    /**\n', '     * @notice Handle the receipt of an NFT\n', '     * @dev The ERC721 smart contract calls this function on the recipient\n', '     * after a `safeTransfer`. This function MUST return the function selector,\n', '     * otherwise the caller will revert the transaction. The selector to be\n', '     * returned can be obtained as `this.onERC721Received.selector`. This\n', '     * function MAY throw to revert and reject the transfer.\n', '     * Note: the ERC721 contract address is always the message sender.\n', '     * @param operator The address which called `safeTransferFrom` function\n', '     * @param from The address which previously owned the token\n', '     * @param tokenId The NFT identifier which is being transferred\n', '     * @param data Additional data with no specified format\n', '     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`\n', '     */\n', '    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)\n', '    public returns (bytes4);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' */\n', 'library Address {\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param account address of the account to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/introspection/ERC165.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title ERC165\n', ' * @author Matt Condon (@shrugs)\n', ' * @dev Implements ERC165 using a lookup table.\n', ' */\n', 'contract ERC165 is IERC165 {\n', '    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '    /**\n', '     * 0x01ffc9a7 ===\n', "     *     bytes4(keccak256('supportsInterface(bytes4)'))\n", '     */\n', '\n', '    /**\n', "     * @dev a mapping of interface id to whether or not it's supported\n", '     */\n', '    mapping(bytes4 => bool) private _supportedInterfaces;\n', '\n', '    /**\n', '     * @dev A contract implementing SupportsInterfaceWithLookup\n', '     * implement ERC165 itself\n', '     */\n', '    constructor () internal {\n', '        _registerInterface(_INTERFACE_ID_ERC165);\n', '    }\n', '\n', '    /**\n', '     * @dev implement supportsInterface(bytes4) using a lookup table\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool) {\n', '        return _supportedInterfaces[interfaceId];\n', '    }\n', '\n', '    /**\n', '     * @dev internal method for registering an interface\n', '     */\n', '    function _registerInterface(bytes4 interfaceId) internal {\n', '        require(interfaceId != 0xffffffff);\n', '        _supportedInterfaces[interfaceId] = true;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @title ERC721 Non-Fungible Token Standard basic implementation\n', ' * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract ERC721 is ERC165, IERC721 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`\n', '    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`\n', '    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;\n', '\n', '    // Mapping from token ID to owner\n', '    mapping (uint256 => address) private _tokenOwner;\n', '\n', '    // Mapping from token ID to approved address\n', '    mapping (uint256 => address) private _tokenApprovals;\n', '\n', '    // Mapping from owner to number of owned token\n', '    mapping (address => uint256) private _ownedTokensCount;\n', '\n', '    // Mapping from owner to operator approvals\n', '    mapping (address => mapping (address => bool)) private _operatorApprovals;\n', '\n', '    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;\n', '    /*\n', '     * 0x80ac58cd ===\n', "     *     bytes4(keccak256('balanceOf(address)')) ^\n", "     *     bytes4(keccak256('ownerOf(uint256)')) ^\n", "     *     bytes4(keccak256('approve(address,uint256)')) ^\n", "     *     bytes4(keccak256('getApproved(uint256)')) ^\n", "     *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^\n", "     *     bytes4(keccak256('isApprovedForAll(address,address)')) ^\n", "     *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^\n", "     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^\n", "     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))\n", '     */\n', '\n', '    constructor () public {\n', '        // register the supported interfaces to conform to ERC721 via ERC165\n', '        _registerInterface(_INTERFACE_ID_ERC721);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address\n', '     * @param owner address to query the balance of\n', '     * @return uint256 representing the amount owned by the passed address\n', '     */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        require(owner != address(0));\n', '        return _ownedTokensCount[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the owner of the specified token ID\n', '     * @param tokenId uint256 ID of the token to query the owner of\n', '     * @return owner address currently marked as the owner of the given token ID\n', '     */\n', '    function ownerOf(uint256 tokenId) public view returns (address) {\n', '        address owner = _tokenOwner[tokenId];\n', '        require(owner != address(0));\n', '        return owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Approves another address to transfer the given token ID\n', '     * The zero address indicates there is no approved address.\n', '     * There can only be one approved address per token at a given time.\n', '     * Can only be called by the token owner or an approved operator.\n', '     * @param to address to be approved for the given token ID\n', '     * @param tokenId uint256 ID of the token to be approved\n', '     */\n', '    function approve(address to, uint256 tokenId) public {\n', '        address owner = ownerOf(tokenId);\n', '        require(to != owner);\n', '        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));\n', '\n', '        _tokenApprovals[tokenId] = to;\n', '        emit Approval(owner, to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the approved address for a token ID, or zero if no address set\n', '     * Reverts if the token ID does not exist.\n', '     * @param tokenId uint256 ID of the token to query the approval of\n', '     * @return address currently approved for the given token ID\n', '     */\n', '    function getApproved(uint256 tokenId) public view returns (address) {\n', '        require(_exists(tokenId));\n', '        return _tokenApprovals[tokenId];\n', '    }\n', '\n', '    /**\n', '     * @dev Sets or unsets the approval of a given operator\n', '     * An operator is allowed to transfer all tokens of the sender on their behalf\n', '     * @param to operator address to set the approval\n', '     * @param approved representing the status of the approval to be set\n', '     */\n', '    function setApprovalForAll(address to, bool approved) public {\n', '        require(to != msg.sender);\n', '        _operatorApprovals[msg.sender][to] = approved;\n', '        emit ApprovalForAll(msg.sender, to, approved);\n', '    }\n', '\n', '    /**\n', '     * @dev Tells whether an operator is approved by a given owner\n', '     * @param owner owner address which you want to query the approval of\n', '     * @param operator operator address which you want to query the approval of\n', '     * @return bool whether the given operator is approved by the given owner\n', '     */\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool) {\n', '        return _operatorApprovals[owner][operator];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers the ownership of a given token ID to another address\n', '     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible\n', '     * Requires the msg sender to be the owner, approved, or operator\n', '     * @param from current owner of the token\n', '     * @param to address to receive the ownership of the given token ID\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '    */\n', '    function transferFrom(address from, address to, uint256 tokenId) public {\n', '        require(_isApprovedOrOwner(msg.sender, tokenId));\n', '\n', '        _transferFrom(from, to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Safely transfers the ownership of a given token ID to another address\n', '     * If the target address is a contract, it must implement `onERC721Received`,\n', '     * which is called upon a safe transfer, and return the magic value\n', '     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,\n', '     * the transfer is reverted.\n', '     *\n', '     * Requires the msg sender to be the owner, approved, or operator\n', '     * @param from current owner of the token\n', '     * @param to address to receive the ownership of the given token ID\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '    */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public {\n', '        safeTransferFrom(from, to, tokenId, "");\n', '    }\n', '\n', '    /**\n', '     * @dev Safely transfers the ownership of a given token ID to another address\n', '     * If the target address is a contract, it must implement `onERC721Received`,\n', '     * which is called upon a safe transfer, and return the magic value\n', '     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,\n', '     * the transfer is reverted.\n', '     * Requires the msg sender to be the owner, approved, or operator\n', '     * @param from current owner of the token\n', '     * @param to address to receive the ownership of the given token ID\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     * @param _data bytes data to send along with a safe transfer check\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {\n', '        transferFrom(from, to, tokenId);\n', '        require(_checkOnERC721Received(from, to, tokenId, _data));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns whether the specified token exists\n', '     * @param tokenId uint256 ID of the token to query the existence of\n', '     * @return whether the token exists\n', '     */\n', '    function _exists(uint256 tokenId) internal view returns (bool) {\n', '        address owner = _tokenOwner[tokenId];\n', '        return owner != address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns whether the given spender can transfer a given token ID\n', '     * @param spender address of the spender to query\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     * @return bool whether the msg.sender is approved for the given token ID,\n', '     *    is an operator of the owner, or is the owner of the token\n', '     */\n', '    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {\n', '        address owner = ownerOf(tokenId);\n', '        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to mint a new token\n', '     * Reverts if the given token ID already exists\n', '     * @param to The address that will own the minted token\n', '     * @param tokenId uint256 ID of the token to be minted\n', '     */\n', '    function _mint(address to, uint256 tokenId) internal {\n', '        require(to != address(0));\n', '        require(!_exists(tokenId));\n', '\n', '        _tokenOwner[tokenId] = to;\n', '        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);\n', '\n', '        emit Transfer(address(0), to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to burn a specific token\n', '     * Reverts if the token does not exist\n', '     * Deprecated, use _burn(uint256) instead.\n', '     * @param owner owner of the token to burn\n', '     * @param tokenId uint256 ID of the token being burned\n', '     */\n', '    function _burn(address owner, uint256 tokenId) internal {\n', '        require(ownerOf(tokenId) == owner);\n', '\n', '        _clearApproval(tokenId);\n', '\n', '        _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);\n', '        _tokenOwner[tokenId] = address(0);\n', '\n', '        emit Transfer(owner, address(0), tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to burn a specific token\n', '     * Reverts if the token does not exist\n', '     * @param tokenId uint256 ID of the token being burned\n', '     */\n', '    function _burn(uint256 tokenId) internal {\n', '        _burn(ownerOf(tokenId), tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to transfer ownership of a given token ID to another address.\n', '     * As opposed to transferFrom, this imposes no restrictions on msg.sender.\n', '     * @param from current owner of the token\n', '     * @param to address to receive the ownership of the given token ID\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '    */\n', '    function _transferFrom(address from, address to, uint256 tokenId) internal {\n', '        require(ownerOf(tokenId) == from);\n', '        require(to != address(0));\n', '\n', '        _clearApproval(tokenId);\n', '\n', '        _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);\n', '        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);\n', '\n', '        _tokenOwner[tokenId] = to;\n', '\n', '        emit Transfer(from, to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to invoke `onERC721Received` on a target address\n', '     * The call is not executed if the target address is not a contract\n', '     * @param from address representing the previous owner of the given token ID\n', '     * @param to target address that will receive the tokens\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     * @param _data bytes optional data to send along with the call\n', '     * @return whether the call correctly returned the expected magic value\n', '     */\n', '    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)\n', '        internal returns (bool)\n', '    {\n', '        if (!to.isContract()) {\n', '            return true;\n', '        }\n', '\n', '        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);\n', '        return (retval == _ERC721_RECEIVED);\n', '    }\n', '\n', '    /**\n', '     * @dev Private function to clear current approval of a given token ID\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     */\n', '    function _clearApproval(uint256 tokenId) private {\n', '        if (_tokenApprovals[tokenId] != address(0)) {\n', '            _tokenApprovals[tokenId] = address(0);\n', '        }\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/BaseRegistrar.sol\n', '\n', 'pragma solidity >=0.4.24;\n', '\n', '\n', '\n', '\n', '\n', 'contract BaseRegistrar is ERC721, Ownable {\n', '    uint constant public GRACE_PERIOD = 0 days;\n', '\n', '    event ControllerAdded(address indexed controller);\n', '    event ControllerRemoved(address indexed controller);\n', '    event NameMigrated(uint256 indexed id, address indexed owner, uint expires);\n', '    event NameRegistered(uint256 indexed id, address indexed owner, uint expires);\n', '    event NameRenewed(uint256 indexed id, uint expires);\n', '\n', '    // Expiration timestamp for migrated domains.\n', '    uint public transferPeriodEnds;\n', '\n', '    // The ENS registry\n', '    ENS public ens;\n', '\n', '    // The namehash of the TLD this registrar owns (eg, .eth)\n', '    bytes32 public baseNode;\n', '\n', '    // A map of addresses that are authorised to register and renew names.\n', '    mapping(address=>bool) public controllers;\n', '\n', '    // Authorises a controller, who can register and renew domains.\n', '    function addController(address controller) external;\n', '\n', '    // Revoke controller permission for an address.\n', '    function removeController(address controller) external;\n', '\n', '    // Set the resolver for the TLD this registrar manages.\n', '    function setResolver(address resolver) external;\n', '\n', '    // Returns the expiration timestamp of the specified label hash.\n', '    function nameExpires(uint256 id) external view returns(uint);\n', '\n', '    // Returns true iff the specified name is available for registration.\n', '    function available(uint256 id) public view returns(bool);\n', '\n', '    /**\n', '     * @dev Register a name.\n', '     */\n', '    function register(uint256 id, address owner, uint duration) external returns(uint);\n', '\n', '    function renew(uint256 id, uint duration) external returns(uint);\n', '\n', '    /**\n', '     * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.\n', '     */\n', '    function reclaim(uint256 id, address owner) external;\n', '\n', '}\n', '\n', '// File: contracts/BaseRegistrarImplementation.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract BaseRegistrarImplementation is BaseRegistrar {\n', '    // A map of expiry times\n', '    mapping(uint256=>uint) expiries;\n', '\n', '    uint constant public MIGRATION_LOCK_PERIOD = 0 days;\n', '\n', '    bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));\n', '    bytes4 constant private ERC721_ID = bytes4(\n', '        keccak256("balanceOf(uint256)") ^\n', '        keccak256("ownerOf(uint256)") ^\n', '        keccak256("approve(address,uint256)") ^\n', '        keccak256("getApproved(uint256)") ^\n', '        keccak256("setApprovalForAll(address,bool)") ^\n', '        keccak256("isApprovedForAll(address,address)") ^\n', '        keccak256("transferFrom(address,address,uint256)") ^\n', '        keccak256("safeTransferFrom(address,address,uint256)") ^\n', '        keccak256("safeTransferFrom(address,address,uint256,bytes)")\n', '    );\n', '    bytes4 constant private RECLAIM_ID = bytes4(keccak256("reclaim(uint256,address)"));\n', '\n', '    constructor(ENS _ens, bytes32 _baseNode) public {\n', '        // Require that people have time to transfer names over.\n', '        // require(_transferPeriodEnds > now + 2 * MIGRATION_LOCK_PERIOD);\n', '\n', '        ens = _ens;\n', '        baseNode = _baseNode;\n', '        transferPeriodEnds = now;\n', '    }\n', '\n', '    modifier live {\n', '        require(ens.owner(baseNode) == address(this));\n', '        _;\n', '    }\n', '\n', '    modifier onlyController {\n', '        require(controllers[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the owner of the specified token ID. Names become unowned\n', '     *      when their registration expires.\n', '     * @param tokenId uint256 ID of the token to query the owner of\n', '     * @return address currently marked as the owner of the given token ID\n', '     */\n', '    function ownerOf(uint256 tokenId) public view returns (address) {\n', '        require(expiries[tokenId] > now);\n', '        return super.ownerOf(tokenId);\n', '    }\n', '\n', '    // Authorises a controller, who can register and renew domains.\n', '    function addController(address controller) external onlyOwner {\n', '        controllers[controller] = true;\n', '        emit ControllerAdded(controller);\n', '    }\n', '\n', '    // Revoke controller permission for an address.\n', '    function removeController(address controller) external onlyOwner {\n', '        controllers[controller] = false;\n', '        emit ControllerRemoved(controller);\n', '    }\n', '\n', '    // Set the resolver for the TLD this registrar manages.\n', '    function setResolver(address resolver) external onlyOwner {\n', '        ens.setResolver(baseNode, resolver);\n', '    }\n', '\n', '    // Returns the expiration timestamp of the specified id.\n', '    function nameExpires(uint256 id) external view returns(uint) {\n', '        return expiries[id];\n', '    }\n', '\n', '    // Returns true iff the specified name is available for registration.\n', '    function available(uint256 id) public view returns(bool) {\n', "        // Not available if it's registered here or in its grace period.\n", '        if(expiries[id] + GRACE_PERIOD >= now) {\n', '            return false;\n', '        }\n', "        // Available if we're past the transfer period, or the name isn't\n", '        // registered in the legacy registrar.\n', '        return now > transferPeriodEnds;\n', '    }\n', '\n', '    /**\n', '     * @dev Register a name.\n', '     */\n', '    function register(uint256 id, address owner, uint duration) external live onlyController returns(uint) {\n', '        require(available(id));\n', '        require(now + duration + GRACE_PERIOD > now + GRACE_PERIOD); // Prevent future overflow\n', '\n', '        expiries[id] = now + duration;\n', '        if(_exists(id)) {\n', '            // Name was previously owned, and expired\n', '            _burn(id);\n', '        }\n', '        _mint(owner, id);\n', '        ens.setSubnodeOwner(baseNode, bytes32(id), owner);\n', '\n', '        emit NameRegistered(id, owner, now + duration);\n', '\n', '        return now + duration;\n', '    }\n', '\n', '    function renew(uint256 id, uint duration) external live onlyController returns(uint) {\n', '        require(expiries[id] + GRACE_PERIOD >= now); // Name must be registered here or in grace period\n', '        require(expiries[id] + duration + GRACE_PERIOD > duration + GRACE_PERIOD); // Prevent future overflow\n', '\n', '        expiries[id] += duration;\n', '        emit NameRenewed(id, expiries[id]);\n', '        return expiries[id];\n', '    }\n', '\n', '    /**\n', '     * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.\n', '     */\n', '    function reclaim(uint256 id, address owner) external live {\n', '        require(_isApprovedOrOwner(msg.sender, id));\n', '        ens.setSubnodeOwner(baseNode, bytes32(id), owner);\n', '    }\n', '\n', '    function supportsInterface(bytes4 interfaceID) external view returns (bool) {\n', '        return interfaceID == INTERFACE_META_ID ||\n', '               interfaceID == ERC721_ID ||\n', '               interfaceID == RECLAIM_ID;\n', '    }\n', '}']
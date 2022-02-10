['pragma solidity ^0.5.0;\n', '\n', 'import "./IERC721.sol";\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, optional metadata extension\n', ' * @dev See https://eips.ethereum.org/EIPS/eip-721\n', ' */\n', 'contract IERC721Metadata is IERC721 {\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function tokenURI(uint256 tokenId) external view returns (string memory);\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', 'import "./IERC721.sol";\n', 'import "./IERC721Receiver.sol";\n', 'import "../../math/SafeMath.sol";\n', 'import "../../utils/Address.sol";\n', 'import "../../drafts/Counters.sol";\n', 'import "../../introspection/ERC165.sol";\n', '\n', '/**\n', ' * @title ERC721 Non-Fungible Token Standard basic implementation\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-721\n', ' */\n', 'contract ERC721 is ERC165, IERC721 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '    using Counters for Counters.Counter;\n', '\n', '    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`\n', '    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`\n', '    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;\n', '\n', '    // Mapping from token ID to owner\n', '    mapping (uint256 => address) private _tokenOwner;\n', '\n', '    // Mapping from token ID to approved address\n', '    mapping (uint256 => address) private _tokenApprovals;\n', '\n', '    // Mapping from owner to number of owned token\n', '    mapping (address => Counters.Counter) private _ownedTokensCount;\n', '\n', '    // Mapping from owner to operator approvals\n', '    mapping (address => mapping (address => bool)) private _operatorApprovals;\n', '\n', '    /*\n', "     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231\n", "     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e\n", "     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3\n", "     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc\n", "     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465\n", "     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c\n", "     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd\n", "     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e\n", "     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde\n", '     *\n', '     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^\n', '     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd\n', '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;\n', '\n', '    constructor () public {\n', '        // register the supported interfaces to conform to ERC721 via ERC165\n', '        _registerInterface(_INTERFACE_ID_ERC721);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param owner address to query the balance of\n', '     * @return uint256 representing the amount owned by the passed address\n', '     */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        require(owner != address(0), "ERC721: balance query for the zero address");\n', '\n', '        return _ownedTokensCount[owner].current();\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the owner of the specified token ID.\n', '     * @param tokenId uint256 ID of the token to query the owner of\n', '     * @return address currently marked as the owner of the given token ID\n', '     */\n', '    function ownerOf(uint256 tokenId) public view returns (address) {\n', '        address owner = _tokenOwner[tokenId];\n', '        require(owner != address(0), "ERC721: owner query for nonexistent token");\n', '\n', '        return owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Approves another address to transfer the given token ID\n', '     * The zero address indicates there is no approved address.\n', '     * There can only be one approved address per token at a given time.\n', '     * Can only be called by the token owner or an approved operator.\n', '     * @param to address to be approved for the given token ID\n', '     * @param tokenId uint256 ID of the token to be approved\n', '     */\n', '    function approve(address to, uint256 tokenId) public {\n', '        address owner = ownerOf(tokenId);\n', '        require(to != owner, "ERC721: approval to current owner");\n', '\n', '        require(msg.sender == owner || isApprovedForAll(owner, msg.sender),\n', '            "ERC721: approve caller is not owner nor approved for all"\n', '        );\n', '\n', '        _tokenApprovals[tokenId] = to;\n', '        emit Approval(owner, to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the approved address for a token ID, or zero if no address set\n', '     * Reverts if the token ID does not exist.\n', '     * @param tokenId uint256 ID of the token to query the approval of\n', '     * @return address currently approved for the given token ID\n', '     */\n', '    function getApproved(uint256 tokenId) public view returns (address) {\n', '        require(_exists(tokenId), "ERC721: approved query for nonexistent token");\n', '\n', '        return _tokenApprovals[tokenId];\n', '    }\n', '\n', '    /**\n', '     * @dev Sets or unsets the approval of a given operator\n', '     * An operator is allowed to transfer all tokens of the sender on their behalf.\n', '     * @param to operator address to set the approval\n', '     * @param approved representing the status of the approval to be set\n', '     */\n', '    function setApprovalForAll(address to, bool approved) public {\n', '        require(to != msg.sender, "ERC721: approve to caller");\n', '\n', '        _operatorApprovals[msg.sender][to] = approved;\n', '        emit ApprovalForAll(msg.sender, to, approved);\n', '    }\n', '\n', '    /**\n', '     * @dev Tells whether an operator is approved by a given owner.\n', '     * @param owner owner address which you want to query the approval of\n', '     * @param operator operator address which you want to query the approval of\n', '     * @return bool whether the given operator is approved by the given owner\n', '     */\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool) {\n', '        return _operatorApprovals[owner][operator];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers the ownership of a given token ID to another address.\n', '     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.\n', '     * Requires the msg.sender to be the owner, approved, or operator.\n', '     * @param from current owner of the token\n', '     * @param to address to receive the ownership of the given token ID\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) public {\n', '        //solhint-disable-next-line max-line-length\n', '        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");\n', '\n', '        _transferFrom(from, to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Safely transfers the ownership of a given token ID to another address\n', '     * If the target address is a contract, it must implement `onERC721Received`,\n', '     * which is called upon a safe transfer, and return the magic value\n', '     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,\n', '     * the transfer is reverted.\n', '     * Requires the msg.sender to be the owner, approved, or operator\n', '     * @param from current owner of the token\n', '     * @param to address to receive the ownership of the given token ID\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public {\n', '        safeTransferFrom(from, to, tokenId, "");\n', '    }\n', '\n', '    /**\n', '     * @dev Safely transfers the ownership of a given token ID to another address\n', '     * If the target address is a contract, it must implement `onERC721Received`,\n', '     * which is called upon a safe transfer, and return the magic value\n', '     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,\n', '     * the transfer is reverted.\n', '     * Requires the msg.sender to be the owner, approved, or operator\n', '     * @param from current owner of the token\n', '     * @param to address to receive the ownership of the given token ID\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     * @param _data bytes data to send along with a safe transfer check\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {\n', '        transferFrom(from, to, tokenId);\n', '        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns whether the specified token exists.\n', '     * @param tokenId uint256 ID of the token to query the existence of\n', '     * @return bool whether the token exists\n', '     */\n', '    function _exists(uint256 tokenId) internal view returns (bool) {\n', '        address owner = _tokenOwner[tokenId];\n', '        return owner != address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns whether the given spender can transfer a given token ID.\n', '     * @param spender address of the spender to query\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     * @return bool whether the msg.sender is approved for the given token ID,\n', '     * is an operator of the owner, or is the owner of the token\n', '     */\n', '    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {\n', '        require(_exists(tokenId), "ERC721: operator query for nonexistent token");\n', '        address owner = ownerOf(tokenId);\n', '        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to mint a new token.\n', '     * Reverts if the given token ID already exists.\n', '     * @param to The address that will own the minted token\n', '     * @param tokenId uint256 ID of the token to be minted\n', '     */\n', '    function _mint(address to, uint256 tokenId) internal {\n', '        require(to != address(0), "ERC721: mint to the zero address");\n', '        require(!_exists(tokenId), "ERC721: token already minted");\n', '\n', '        _tokenOwner[tokenId] = to;\n', '        _ownedTokensCount[to].increment();\n', '\n', '        emit Transfer(address(0), to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to burn a specific token.\n', '     * Reverts if the token does not exist.\n', '     * Deprecated, use _burn(uint256) instead.\n', '     * @param owner owner of the token to burn\n', '     * @param tokenId uint256 ID of the token being burned\n', '     */\n', '    function _burn(address owner, uint256 tokenId) internal {\n', '        require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");\n', '\n', '        _clearApproval(tokenId);\n', '\n', '        _ownedTokensCount[owner].decrement();\n', '        _tokenOwner[tokenId] = address(0);\n', '\n', '        emit Transfer(owner, address(0), tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to burn a specific token.\n', '     * Reverts if the token does not exist.\n', '     * @param tokenId uint256 ID of the token being burned\n', '     */\n', '    function _burn(uint256 tokenId) internal {\n', '        _burn(ownerOf(tokenId), tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to transfer ownership of a given token ID to another address.\n', '     * As opposed to transferFrom, this imposes no restrictions on msg.sender.\n', '     * @param from current owner of the token\n', '     * @param to address to receive the ownership of the given token ID\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     */\n', '    function _transferFrom(address from, address to, uint256 tokenId) internal {\n', '        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");\n', '        require(to != address(0), "ERC721: transfer to the zero address");\n', '\n', '        _clearApproval(tokenId);\n', '\n', '        _ownedTokensCount[from].decrement();\n', '        _ownedTokensCount[to].increment();\n', '\n', '        _tokenOwner[tokenId] = to;\n', '\n', '        emit Transfer(from, to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to invoke `onERC721Received` on a target address.\n', '     * The call is not executed if the target address is not a contract.\n', '     *\n', '     * This function is deprecated.\n', '     * @param from address representing the previous owner of the given token ID\n', '     * @param to target address that will receive the tokens\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     * @param _data bytes optional data to send along with the call\n', '     * @return bool whether the call correctly returned the expected magic value\n', '     */\n', '    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)\n', '        internal returns (bool)\n', '    {\n', '        if (!to.isContract()) {\n', '            return true;\n', '        }\n', '\n', '        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);\n', '        return (retval == _ERC721_RECEIVED);\n', '    }\n', '\n', '    /**\n', '     * @dev Private function to clear current approval of a given token ID.\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     */\n', '    function _clearApproval(uint256 tokenId) private {\n', '        if (_tokenApprovals[tokenId] != address(0)) {\n', '            _tokenApprovals[tokenId] = address(0);\n', '        }\n', '    }\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title ERC721 token receiver interface\n', ' * @dev Interface for any contract that wants to support safeTransfers\n', ' * from ERC721 asset contracts.\n', ' */\n', 'contract IERC721Receiver {\n', '    /**\n', '     * @notice Handle the receipt of an NFT\n', '     * @dev The ERC721 smart contract calls this function on the recipient\n', '     * after a `safeTransfer`. This function MUST return the function selector,\n', '     * otherwise the caller will revert the transaction. The selector to be\n', '     * returned can be obtained as `this.onERC721Received.selector`. This\n', '     * function MAY throw to revert and reject the transfer.\n', '     * Note: the ERC721 contract address is always the message sender.\n', '     * @param operator The address which called `safeTransferFrom` function\n', '     * @param from The address which previously owned the token\n', '     * @param tokenId The NFT identifier which is being transferred\n', '     * @param data Additional data with no specified format\n', '     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`\n', '     */\n', '    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)\n', '    public returns (bytes4);\n', '}\n']
['pragma solidity 0.5.17;\n', '\n', '/// @title Interface of recipient contract for `approveAndCall` pattern.\n', '///        Implementors will be able to be used in an `approveAndCall`\n', '///        interaction with a supporting contract, such that a token approval\n', '///        can call the contract acting on that approval in a single\n', '///        transaction.\n', '///\n', '///        See the `FundingScript` and `RedemptionScript` contracts as examples.\n', 'interface ITokenRecipient {\n', "    /// Typically called from a token contract's `approveAndCall` method, this\n", '    /// method will receive the original owner of the token (`_from`), the\n', '    /// transferred `_value` (in the case of an ERC721, the token id), the token\n', '    /// address (`_token`), and a blob of `_extraData` that is informally\n', '    /// specified by the implementor of this method as a way to communicate\n', '    /// additional parameters.\n', '    ///\n', '    /// Token calls to `receiveApproval` should revert if `receiveApproval`\n', '    /// reverts, and reverts should remove the approval.\n', '    ///\n', '    /// @param _from The original owner of the token approved for transfer.\n', '    /// @param _value For an ERC20, the amount approved for transfer; for an\n', '    ///        ERC721, the id of the token approved for transfer.\n', '    /// @param _token The address of the contract for the token whose transfer\n', '    ///        was approved.\n', '    /// @param _extraData An additional data blob forwarded unmodified through\n', '    ///        `approveAndCall`, used to allow the token owner to pass\n', '    ///         additional parameters and data to this method. The structure of\n', '    ///         the extra data is informally specified by the implementor of\n', '    ///         this interface.\n', '    function receiveApproval(\n', '        address _from,\n', '        uint256 _value,\n', '        address _token,\n', '        bytes calldata _extraData\n', '    ) external;\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', 'import "../../introspection/IERC165.sol";\n', '\n', '/**\n', ' * @dev Required interface of an ERC721 compliant contract.\n', ' */\n', 'contract IERC721 is IERC165 {\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    /**\n', "     * @dev Returns the number of NFTs in `owner`'s account.\n", '     */\n', '    function balanceOf(address owner) public view returns (uint256 balance);\n', '\n', '    /**\n', '     * @dev Returns the owner of the NFT specified by `tokenId`.\n', '     */\n', '    function ownerOf(uint256 tokenId) public view returns (address owner);\n', '\n', '    /**\n', '     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * \n', '     *\n', '     * Requirements:\n', '     * - `from`, `to` cannot be zero.\n', '     * - `tokenId` must be owned by `from`.\n', '     * - If the caller is not `from`, it must be have been allowed to move this\n', '     * NFT by either `approve` or `setApproveForAll`.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public;\n', '    /**\n', '     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Requirements:\n', '     * - If the caller is not `from`, it must be approved to move this NFT by\n', '     * either `approve` or `setApproveForAll`.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) public;\n', '    function approve(address to, uint256 tokenId) public;\n', '    function getApproved(uint256 tokenId) public view returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public;\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool);\n', '\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * [EIP](https://eips.ethereum.org/EIPS/eip-165).\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others (`ERC165Checker`).\n', ' *\n', ' * For an implementation, see `ERC165`.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type,\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * This test is non-exhaustive, and there may be false-negatives: during the\n', "     * execution of a contract's constructor, its address will be reported as\n", '     * not containing a contract.\n', '     *\n', '     * > It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n']
['pragma solidity 0.5.17;\n', '\n', '/// @title  Vending Machine Authority.\n', '/// @notice Contract to secure function calls to the Vending Machine.\n', '/// @dev    Secured by setting the VendingMachine address and using the\n', '///         onlyVendingMachine modifier on functions requiring restriction.\n', 'contract VendingMachineAuthority {\n', '    address internal VendingMachine;\n', '\n', '    constructor(address _vendingMachine) public {\n', '        VendingMachine = _vendingMachine;\n', '    }\n', '\n', '    /// @notice Function modifier ensures modified function caller address is the vending machine.\n', '    modifier onlyVendingMachine() {\n', '        require(msg.sender == VendingMachine, "caller must be the vending machine");\n', '        _;\n', '    }\n', '}\n']
['pragma solidity 0.5.17;\n', '\n', '/// @title  Deposit Factory Authority\n', '/// @notice Contract to secure function calls to the Deposit Factory.\n', '/// @dev    Secured by setting the depositFactory address and using the onlyFactory\n', '///         modifier on functions requiring restriction.\n', 'contract DepositFactoryAuthority {\n', '\n', '    bool internal _initialized = false;\n', '    address internal _depositFactory;\n', '\n', '    /// @notice Set the address of the System contract on contract\n', '    ///         initialization.\n', '    /// @dev Since this function is not access-controlled, it should be called\n', '    ///      transactionally with contract instantiation. In cases where a\n', '    ///      regular contract directly inherits from DepositFactoryAuthority,\n', '    ///      that should happen in the constructor. In cases where the inheritor\n', '    ///      is binstead used via a clone factory, the same function that\n', '    ///      creates a new clone should also trigger initialization.\n', '    function initialize(address _factory) public {\n', '        require(_factory != address(0), "Factory cannot be the zero address.");\n', '        require(! _initialized, "Factory can only be initialized once.");\n', '\n', '        _depositFactory = _factory;\n', '        _initialized = true;\n', '    }\n', '\n', '    /// @notice Function modifier ensures modified function is only called by set deposit factory.\n', '    modifier onlyFactory(){\n', '        require(_initialized, "Factory initialization must have been called.");\n', '        require(msg.sender == _depositFactory, "Caller must be depositFactory contract");\n', '        _;\n', '    }\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', 'import "../math/SafeMath.sol";\n', '\n', '/**\n', ' * @title Counters\n', ' * @author Matt Condon (@shrugs)\n', ' * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number\n', ' * of elements in a mapping, issuing ERC721 ids, or counting request ids.\n', ' *\n', ' * Include with `using Counters for Counters.Counter;`\n', ' * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath\n', ' * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never\n', ' * directly accessed.\n', ' */\n', 'library Counters {\n', '    using SafeMath for uint256;\n', '\n', '    struct Counter {\n', '        // This variable should never be directly accessed by users of the library: interactions must be restricted to\n', "        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add\n", '        // this feature: see https://github.com/ethereum/solidity/issues/4637\n', '        uint256 _value; // default: 0\n', '    }\n', '\n', '    function current(Counter storage counter) internal view returns (uint256) {\n', '        return counter._value;\n', '    }\n', '\n', '    function increment(Counter storage counter) internal {\n', '        counter._value += 1;\n', '    }\n', '\n', '    function decrement(Counter storage counter) internal {\n', '        counter._value = counter._value.sub(1);\n', '    }\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', 'import "./IERC165.sol";\n', '\n', '/**\n', ' * @dev Implementation of the `IERC165` interface.\n', ' *\n', ' * Contracts may inherit from this and call `_registerInterface` to declare\n', ' * their support of an interface.\n', ' */\n', 'contract ERC165 is IERC165 {\n', '    /*\n', "     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7\n", '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '\n', '    /**\n', "     * @dev Mapping of interface ids to whether or not it's supported.\n", '     */\n', '    mapping(bytes4 => bool) private _supportedInterfaces;\n', '\n', '    constructor () internal {\n', '        // Derived contracts need only register support for their own interfaces,\n', '        // we register support for ERC165 itself here\n', '        _registerInterface(_INTERFACE_ID_ERC165);\n', '    }\n', '\n', '    /**\n', '     * @dev See `IERC165.supportsInterface`.\n', '     *\n', '     * Time complexity O(1), guaranteed to always use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool) {\n', '        return _supportedInterfaces[interfaceId];\n', '    }\n', '\n', '    /**\n', '     * @dev Registers the contract as an implementer of the interface defined by\n', '     * `interfaceId`. Support of the actual ERC165 interface is automatic and\n', '     * registering its interface id is not required.\n', '     *\n', '     * See `IERC165.supportsInterface`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).\n', '     */\n', '    function _registerInterface(bytes4 interfaceId) internal {\n', '        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");\n', '        _supportedInterfaces[interfaceId] = true;\n', '    }\n', '}\n']
['pragma solidity 0.5.17;\n', '\n', 'import "openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol";\n', 'import "./VendingMachineAuthority.sol";\n', '\n', '/// @title  Fee Rebate Token\n', '/// @notice The Fee Rebate Token (FRT) is a non fungible token (ERC721)\n', '///         the ID of which corresponds to a given deposit address.\n', '///         If the corresponding deposit is still active, ownership of this token\n', '///         could result in reimbursement of the signer fee paid to open the deposit.\n', '/// @dev    This token is minted automatically when a TDT (`TBTCDepositToken`)\n', '///         is exchanged for TBTC (`TBTCToken`) via the Vending Machine (`VendingMachine`).\n', '///         When the Deposit is redeemed, the TDT holder will be reimbursed\n', '///         the signer fee if the redeemer is not the TDT holder and Deposit is not\n', '///         at-term or in COURTESY_CALL.\n', 'contract FeeRebateToken is ERC721Metadata, VendingMachineAuthority {\n', '\n', '    constructor(address _vendingMachine)\n', '        ERC721Metadata("tBTC Fee Rebate Token", "FRT")\n', '        VendingMachineAuthority(_vendingMachine)\n', '    public {\n', '        // solium-disable-previous-line no-empty-blocks\n', '    }\n', '\n', '    /// @dev Mints a new token.\n', '    /// Reverts if the given token ID already exists.\n', '    /// @param _to The address that will own the minted token.\n', '    /// @param _tokenId uint256 ID of the token to be minted.\n', '    function mint(address _to, uint256 _tokenId) external onlyVendingMachine {\n', '        _mint(_to, _tokenId);\n', '    }\n', '\n', '    /// @dev Returns whether the specified token exists.\n', '    /// @param _tokenId uint256 ID of the token to query the existence of.\n', '    /// @return bool whether the token exists.\n', '    function exists(uint256 _tokenId) external view returns (bool) {\n', '        return _exists(_tokenId);\n', '    }\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', 'import "./ERC721.sol";\n', 'import "./IERC721Metadata.sol";\n', 'import "../../introspection/ERC165.sol";\n', '\n', 'contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {\n', '    // Token name\n', '    string private _name;\n', '\n', '    // Token symbol\n', '    string private _symbol;\n', '\n', '    // Optional mapping for token URIs\n', '    mapping(uint256 => string) private _tokenURIs;\n', '\n', '    /*\n', "     *     bytes4(keccak256('name()')) == 0x06fdde03\n", "     *     bytes4(keccak256('symbol()')) == 0x95d89b41\n", "     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd\n", '     *\n', '     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f\n', '     */\n', '    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;\n', '\n', '    /**\n', '     * @dev Constructor function\n', '     */\n', '    constructor (string memory name, string memory symbol) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '\n', '        // register the supported interfaces to conform to ERC721 via ERC165\n', '        _registerInterface(_INTERFACE_ID_ERC721_METADATA);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the token name.\n', '     * @return string representing the token name\n', '     */\n', '    function name() external view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the token symbol.\n', '     * @return string representing the token symbol\n', '     */\n', '    function symbol() external view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns an URI for a given token ID.\n', '     * Throws if the token ID does not exist. May return an empty string.\n', '     * @param tokenId uint256 ID of the token to query\n', '     */\n', '    function tokenURI(uint256 tokenId) external view returns (string memory) {\n', '        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");\n', '        return _tokenURIs[tokenId];\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to set the token URI for a given token.\n', '     * Reverts if the token ID does not exist.\n', '     * @param tokenId uint256 ID of the token to set its URI\n', '     * @param uri string URI to assign\n', '     */\n', '    function _setTokenURI(uint256 tokenId, string memory uri) internal {\n', '        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");\n', '        _tokenURIs[tokenId] = uri;\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to burn a specific token.\n', '     * Reverts if the token does not exist.\n', '     * Deprecated, use _burn(uint256) instead.\n', '     * @param owner owner of the token to burn\n', '     * @param tokenId uint256 ID of the token being burned by the msg.sender\n', '     */\n', '    function _burn(address owner, uint256 tokenId) internal {\n', '        super._burn(owner, tokenId);\n', '\n', '        // Clear metadata (if any)\n', '        if (bytes(_tokenURIs[tokenId]).length != 0) {\n', '            delete _tokenURIs[tokenId];\n', '        }\n', '    }\n', '}\n']

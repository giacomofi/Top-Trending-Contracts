['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-07\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '/*\n', ' *  1111    111                                                 777    888\n', ' *  11111   111                                                 777    888\n', ' *  111111  111                                                 777\n', ' *  1111111 111 222  222 333333333333   444444  5555555 666666  777777 888\n', ' *  111 1111111 222  222 333 3333 3333 444  444 55555      6666 777    888\n', ' *  111  111111 222  222 333  333  333 44444444 555    66666666 777    888\n', ' *  111   11111 2222 222 333  333  333 4444     555    666  666 77777  888\n', ' *  111    1111  2222222 333  333  333  444444  555    66666666  77777 888\n', ' *\n', ' *                0x12345678910f9de260d08f4e179103ce14cfd8eb\n', ' */\n', '\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a static call.\n', '     *\n', '     * _Available since v3.3._\n', '     */\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],\n', '     * but performing a delegate call.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'library Strings {\n', '    bytes16 private constant alphabet = "0123456789abcdef";\n', '\n', '    /**\n', '     * @dev Converts a `uint256` to its ASCII `string` decimal representation.\n', '     */\n', '    function toString(uint256 value) internal pure returns (string memory) {\n', "        // Inspired by OraclizeAPI's implementation - MIT licence\n", '        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol\n', '\n', '        if (value == 0) {\n', '            return "0";\n', '        }\n', '        uint256 temp = value;\n', '        uint256 digits;\n', '        while (temp != 0) {\n', '            digits++;\n', '            temp /= 10;\n', '        }\n', '        bytes memory buffer = new bytes(digits);\n', '        while (value != 0) {\n', '            digits -= 1;\n', '            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));\n', '            value /= 10;\n', '        }\n', '        return string(buffer);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.\n', '     */\n', '    function toHexString(uint256 value) internal pure returns (string memory) {\n', '        if (value == 0) {\n', '            return "0x00";\n', '        }\n', '        uint256 temp = value;\n', '        uint256 length = 0;\n', '        while (temp != 0) {\n', '            length++;\n', '            temp >>= 8;\n', '        }\n', '        return toHexString(value, length);\n', '    }\n', '\n', '    /**\n', '     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.\n', '     */\n', '    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {\n', '        bytes memory buffer = new bytes(2 * length + 2);\n', '        buffer[0] = "0";\n', '        buffer[1] = "x";\n', '        for (uint256 i = 2 * length + 1; i > 1; --i) {\n', '            buffer[i] = alphabet[value & 0xf];\n', '            value >>= 4;\n', '        }\n', '        require(value == 0, "Strings: hex length insufficient");\n', '        return string(buffer);\n', '    }\n', '\n', '}\n', '\n', 'interface IERC721Receiver {\n', '    /**\n', '     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}\n', '     * by `operator` from `from`, this function is called.\n', '     *\n', '     * It must return its Solidity selector to confirm the token transfer.\n', '     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.\n', '     *\n', '     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.\n', '     */\n', '    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);\n', '}\n', '\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'abstract contract ERC165 is IERC165 {\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', '        return interfaceId == type(IERC165).interfaceId;\n', '    }\n', '}\n', '\n', 'interface IERC721 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.\n', '     */\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.\n', '     */\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    /**\n', "     * @dev Returns the number of tokens in ``owner``'s account.\n", '     */\n', '    function balanceOf(address owner) external view returns (uint256 balance);\n', '\n', '    /**\n', '     * @dev Returns the owner of the `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function ownerOf(uint256 tokenId) external view returns (address owner);\n', '\n', '    /**\n', '     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients\n', '     * are aware of the ERC721 protocol to prevent tokens from being forever locked.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must exist and be owned by `from`.\n', '     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Transfers `tokenId` token from `from` to `to`.\n', '     *\n', '     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must be owned by `from`.\n', '     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Gives permission to `to` to transfer `tokenId` token to another account.\n', '     * The approval is cleared when the token is transferred.\n', '     *\n', '     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The caller must own the token or be an approved operator.\n', '     * - `tokenId` must exist.\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Returns the account approved for `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function getApproved(uint256 tokenId) external view returns (address operator);\n', '\n', '    /**\n', '     * @dev Approve or remove `operator` as an operator for the caller.\n', '     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The `operator` cannot be the caller.\n', '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     */\n', '    function setApprovalForAll(address operator, bool _approved) external;\n', '\n', '    /**\n', '     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.\n', '     *\n', '     * See {setApprovalForAll}\n', '     */\n', '    function isApprovedForAll(address owner, address operator) external view returns (bool);\n', '\n', '    /**\n', '      * @dev Safely transfers `tokenId` token from `from` to `to`.\n', '      *\n', '      * Requirements:\n', '      *\n', '      * - `from` cannot be the zero address.\n', '      * - `to` cannot be the zero address.\n', '      * - `tokenId` token must exist and be owned by `from`.\n', '      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '      *\n', '      * Emits a {Transfer} event.\n', '      */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;\n', '}\n', '\n', 'interface IERC721Metadata is IERC721 {\n', '\n', '    /**\n', '     * @dev Returns the token collection name.\n', '     */\n', '    function name() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the token collection symbol.\n', '     */\n', '    function symbol() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.\n', '     */\n', '    function tokenURI(uint256 tokenId) external view returns (string memory);\n', '}\n', '\n', 'interface IERC721Enumerable is IERC721 {\n', '\n', '    /**\n', '     * @dev Returns the total amount of tokens stored by the contract.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.\n', "     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.\n", '     */\n', '    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);\n', '\n', '    /**\n', '     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.\n', '     * Use along with {totalSupply} to enumerate all tokens.\n', '     */\n', '    function tokenByIndex(uint256 index) external view returns (uint256);\n', '}\n', '\n', 'contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {\n', '    using Address for address;\n', '    using Strings for uint256;\n', '\n', '    // Token name\n', '    string private _name;\n', '\n', '    // Token symbol\n', '    string private _symbol;\n', '\n', '    // Mapping from token ID to owner address\n', '    mapping (uint256 => address) private _owners;\n', '\n', '    // Mapping owner address to token count\n', '    mapping (address => uint256) private _balances;\n', '\n', '    // Mapping from token ID to approved address\n', '    mapping (uint256 => address) private _tokenApprovals;\n', '\n', '    // Mapping from owner to operator approvals\n', '    mapping (address => mapping (address => bool)) private _operatorApprovals;\n', '\n', '    /**\n', '     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.\n', '     */\n', '    constructor (string memory name_, string memory symbol_) {\n', '        _name = name_;\n', '        _symbol = symbol_;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC165-supportsInterface}.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {\n', '        return interfaceId == type(IERC721).interfaceId\n', '            || interfaceId == type(IERC721Metadata).interfaceId\n', '            || super.supportsInterface(interfaceId);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-balanceOf}.\n', '     */\n', '    function balanceOf(address owner) public view virtual override returns (uint256) {\n', '        require(owner != address(0), "ERC721: balance query for the zero address");\n', '        return _balances[owner];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-ownerOf}.\n', '     */\n', '    function ownerOf(uint256 tokenId) public view virtual override returns (address) {\n', '        address owner = _owners[tokenId];\n', '        require(owner != address(0), "ERC721: owner query for nonexistent token");\n', '        return owner;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Metadata-name}.\n', '     */\n', '    function name() public view virtual override returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Metadata-symbol}.\n', '     */\n', '    function symbol() public view virtual override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721Metadata-tokenURI}.\n', '     */\n', '    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {\n', '        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");\n', '\n', '        string memory baseURI = _baseURI();\n', '        return bytes(baseURI).length > 0\n', '            ? string(abi.encodePacked(baseURI, tokenId.toString()))\n', "            : '';\n", '    }\n', '\n', '    /**\n', '     * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden\n', '     * in child contracts.\n', '     */\n', '    function _baseURI() internal view virtual returns (string memory) {\n', '        return "";\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-approve}.\n', '     */\n', '    function approve(address to, uint256 tokenId) public virtual override {\n', '        address owner = ERC721.ownerOf(tokenId);\n', '        require(to != owner, "ERC721: approval to current owner");\n', '\n', '        require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),\n', '            "ERC721: approve caller is not owner nor approved for all"\n', '        );\n', '\n', '        _approve(to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-getApproved}.\n', '     */\n', '    function getApproved(uint256 tokenId) public view virtual override returns (address) {\n', '        require(_exists(tokenId), "ERC721: approved query for nonexistent token");\n', '\n', '        return _tokenApprovals[tokenId];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-setApprovalForAll}.\n', '     */\n', '    function setApprovalForAll(address operator, bool approved) public virtual override {\n', '        require(operator != _msgSender(), "ERC721: approve to caller");\n', '\n', '        _operatorApprovals[_msgSender()][operator] = approved;\n', '        emit ApprovalForAll(_msgSender(), operator, approved);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-isApprovedForAll}.\n', '     */\n', '    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {\n', '        return _operatorApprovals[owner][operator];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-transferFrom}.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) public virtual override {\n', '        //solhint-disable-next-line max-line-length\n', '        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");\n', '\n', '        _transfer(from, to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-safeTransferFrom}.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {\n', '        safeTransferFrom(from, to, tokenId, "");\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-safeTransferFrom}.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {\n', '        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");\n', '        _safeTransfer(from, to, tokenId, _data);\n', '    }\n', '\n', '    /**\n', '     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients\n', '     * are aware of the ERC721 protocol to prevent tokens from being forever locked.\n', '     *\n', '     * `_data` is additional data, it has no specified format and it is sent in call to `to`.\n', '     *\n', '     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.\n', '     * implement alternative mechanisms to perform token transfer, such as signature-based.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must exist and be owned by `from`.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {\n', '        _transfer(from, to, tokenId);\n', '        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns whether `tokenId` exists.\n', '     *\n', '     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.\n', '     *\n', '     * Tokens start existing when they are minted (`_mint`),\n', '     * and stop existing when they are burned (`_burn`).\n', '     */\n', '    function _exists(uint256 tokenId) internal view virtual returns (bool) {\n', '        return _owners[tokenId] != address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns whether `spender` is allowed to manage `tokenId`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {\n', '        require(_exists(tokenId), "ERC721: operator query for nonexistent token");\n', '        address owner = ERC721.ownerOf(tokenId);\n', '        return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));\n', '    }\n', '\n', '    /**\n', '     * @dev Safely mints `tokenId` and transfers it to `to`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must not exist.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function _safeMint(address to, uint256 tokenId) internal virtual {\n', '        _safeMint(to, tokenId, "");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is\n', '     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.\n', '     */\n', '    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {\n', '        _mint(to, tokenId);\n', '        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");\n', '    }\n', '\n', '    /**\n', '     * @dev Mints `tokenId` and transfers it to `to`.\n', '     *\n', '     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must not exist.\n', '     * - `to` cannot be the zero address.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function _mint(address to, uint256 tokenId) internal virtual {\n', '        require(to != address(0), "ERC721: mint to the zero address");\n', '        require(!_exists(tokenId), "ERC721: token already minted");\n', '\n', '        _beforeTokenTransfer(address(0), to, tokenId);\n', '\n', '        _balances[to] += 1;\n', '        _owners[tokenId] = to;\n', '\n', '        emit Transfer(address(0), to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `tokenId`.\n', '     * The approval is cleared when the token is burned.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function _burn(uint256 tokenId) internal virtual {\n', '        address owner = ERC721.ownerOf(tokenId);\n', '\n', '        _beforeTokenTransfer(owner, address(0), tokenId);\n', '\n', '        // Clear approvals\n', '        _approve(address(0), tokenId);\n', '\n', '        _balances[owner] -= 1;\n', '        delete _owners[tokenId];\n', '\n', '        emit Transfer(owner, address(0), tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers `tokenId` from `from` to `to`.\n', '     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must be owned by `from`.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function _transfer(address from, address to, uint256 tokenId) internal virtual {\n', '        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");\n', '        require(to != address(0), "ERC721: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(from, to, tokenId);\n', '\n', '        // Clear approvals from the previous owner\n', '        _approve(address(0), tokenId);\n', '\n', '        _balances[from] -= 1;\n', '        _balances[to] += 1;\n', '        _owners[tokenId] = to;\n', '\n', '        emit Transfer(from, to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Approve `to` to operate on `tokenId`\n', '     *\n', '     * Emits a {Approval} event.\n', '     */\n', '    function _approve(address to, uint256 tokenId) internal virtual {\n', '        _tokenApprovals[tokenId] = to;\n', '        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.\n', '     * The call is not executed if the target address is not a contract.\n', '     *\n', '     * @param from address representing the previous owner of the given token ID\n', '     * @param to target address that will receive the tokens\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     * @param _data bytes optional data to send along with the call\n', '     * @return bool whether the call correctly returned the expected magic value\n', '     */\n', '    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)\n', '        private returns (bool)\n', '    {\n', '        if (to.isContract()) {\n', '            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {\n', '                return retval == IERC721Receiver(to).onERC721Received.selector;\n', '            } catch (bytes memory reason) {\n', '                if (reason.length == 0) {\n', '                    revert("ERC721: transfer to non ERC721Receiver implementer");\n', '                } else {\n', '                    // solhint-disable-next-line no-inline-assembly\n', '                    assembly {\n', '                        revert(add(32, reason), mload(reason))\n', '                    }\n', '                }\n', '            }\n', '        } else {\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Hook that is called before any token transfer. This includes minting\n', '     * and burning.\n', '     *\n', '     * Calling conditions:\n', '     *\n', "     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be\n", '     * transferred to `to`.\n', '     * - When `from` is zero, `tokenId` will be minted for `to`.\n', "     * - When `to` is zero, ``from``'s `tokenId` will be burned.\n", '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     *\n', '     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n', '     */\n', '    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }\n', '}\n', '\n', 'contract Numerati is ERC721, Ownable {\n', '\taddress public signer;\n', '\tuint256 public lastMint;\n', '\tuint256 public price = 123e15; // 0.123eth\n', '\n', '\tconstructor (address _signer) ERC721("Numerati", "#")  {\n', '\t\tsigner = _signer;\n', '\t}\n', '\n', '\tfunction setSigner(address _signer) public onlyOwner {\n', '\t\tsigner = _signer;\n', '\t}\n', '\n', '\tfunction withdraw() public onlyOwner {\n', '\t\tpayable(owner()).transfer(address(this).balance);\n', '\t}\n', '\n', '\tfunction buy(uint256 _num) public payable {\n', '\t\trequire(msg.value >= price, "insufficient payment");\n', '\t\t_safeMint(msg.sender, _num);\n', '\t\tlastMint = _num;\n', '\t}\n', '\n', '\tfunction authClaim(uint256 _num, bytes memory _sig) public {\n', '\t\trequire(verify(msg.sender, _num, _sig), "invalid signature");\n', '\t\t_safeMint(msg.sender, _num);\n', '\t\tlastMint = _num;\n', '\t}\n', '\n', '\tfunction verify(address _addr, uint256 _num, bytes memory _sig) public view returns (bool) {\n', '\t\tbytes32 digest = keccak256(abi.encodePacked(_addr, _num));\n', '\t\t(bytes32 r, bytes32 s, uint8 v) = splitSignature(_sig);\n', '\t\treturn ecrecover(digest, v, r, s) == signer;\n', '\t}\n', '\n', '\t// https://solidity-by-example.org/signature/\n', '\tfunction splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v) {\n', '\t\trequire(sig.length == 65, "invalid signature length");\n', '\t\tassembly {\n', '\t\t\tr := mload(add(sig, 32))\n', '\t\t\ts := mload(add(sig, 64))\n', '\t\t\tv := byte(0, mload(add(sig, 96)))\n', '\t\t}\n', '\t}\n', '}']
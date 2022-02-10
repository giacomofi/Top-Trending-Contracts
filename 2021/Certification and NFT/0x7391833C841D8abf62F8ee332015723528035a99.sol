['// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.7.6;\n', '\n', 'import "@openzeppelin/contracts/utils/Pausable.sol";\n', 'import "./interfaces/IAsteroidToken.sol";\n', '\n', '\n', '/**\n', ' * @dev Allows the owner of an asteroid to set a name for it that will be included in ERC721 metadata\n', ' */\n', 'contract AsteroidNames is Pausable {\n', '  IAsteroidToken token;\n', '\n', '  mapping (uint => string) private _asteroidNames;\n', '  mapping (string => bool) private _usedNames;\n', '\n', '  event NameChanged (uint indexed asteroidId, string newName);\n', '\n', '  constructor(IAsteroidToken _token) {\n', '    token = _token;\n', '  }\n', '\n', '  /**\n', '   * @dev Change the name of the asteroid\n', '   */\n', '  function setName(uint _asteroidId, string memory _newName) external whenNotPaused {\n', '    require(_msgSender() == token.ownerOf(_asteroidId), "ERC721: caller is not the owner");\n', '    require(validateName(_newName) == true, "Invalid name");\n', '    require(isNameUsed(_newName) == false, "Name already in use");\n', '\n', '    // If already named, dereserve old name\n', '    if (bytes(_asteroidNames[_asteroidId]).length > 0) {\n', '      toggleNameUsed(_asteroidNames[_asteroidId], false);\n', '    }\n', '\n', '    toggleNameUsed(_newName, true);\n', '    _asteroidNames[_asteroidId] = _newName;\n', '    emit NameChanged(_asteroidId, _newName);\n', '  }\n', '\n', '  /**\n', '   * @dev Retrieves the name of a given asteroid\n', '   */\n', '  function getName(uint _asteroidId) public view returns (string memory) {\n', '    return _asteroidNames[_asteroidId];\n', '  }\n', '\n', '  /**\n', '   * @dev Returns if the name is in use.\n', '   */\n', '  function isNameUsed(string memory nameString) public view returns (bool) {\n', '    return _usedNames[toLower(nameString)];\n', '  }\n', '\n', '  /**\n', '   * @dev Marks the name as used or unused\n', '   */\n', '  function toggleNameUsed(string memory str, bool isUsed) internal {\n', '    _usedNames[toLower(str)] = isUsed;\n', '  }\n', '\n', '  /**\n', '   * @dev Check if the name string is valid\n', '   * Between 1 and 32 characters (Alphanumeric and spaces without leading or trailing space)\n', '   */\n', '  function validateName(string memory str) public pure returns (bool){\n', '    bytes memory b = bytes(str);\n', '\n', '    if(b.length < 1) return false;\n', '    if(b.length > 32) return false; // Cannot be longer than 25 characters\n', '    if(b[0] == 0x20) return false; // Leading space\n', '    if (b[b.length - 1] == 0x20) return false; // Trailing space\n', '\n', '    bytes1 lastChar = b[0];\n', '\n', '    for (uint i; i < b.length; i++) {\n', '      bytes1 char = b[i];\n', '\n', '      if (char == 0x20 && lastChar == 0x20) return false; // Cannot contain continous spaces\n', '\n', '      if (\n', '        !(char >= 0x30 && char <= 0x39) && //9-0\n', '        !(char >= 0x41 && char <= 0x5A) && //A-Z\n', '        !(char >= 0x61 && char <= 0x7A) && //a-z\n', '        !(char == 0x20) //space\n', '      ) {\n', '        return false;\n', '      }\n', '\n', '      lastChar = char;\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Converts the string to lowercase\n', '   */\n', '  function toLower(string memory str) public pure returns (string memory){\n', '    bytes memory bStr = bytes(str);\n', '    bytes memory bLower = new bytes(bStr.length);\n', '\n', '    for (uint i = 0; i < bStr.length; i++) {\n', '      // Uppercase character\n', '      if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {\n', '        bLower[i] = bytes1(uint8(bStr[i]) + 32);\n', '      } else {\n', '        bLower[i] = bStr[i];\n', '      }\n', '    }\n', '\n', '    return string(bLower);\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.7.6;\n', '\n', 'import "@openzeppelin/contracts/token/ERC721/IERC721.sol";\n', '\n', '\n', 'interface IAsteroidToken is IERC721 {\n', '  function addManager(address _manager) external;\n', '\n', '  function removeManager(address _manager) external;\n', '\n', '  function isManager(address _manager) external view returns (bool);\n', '\n', '  function mint(address _to, uint256 _tokenId) external;\n', '\n', '  function burn(address _owner, uint256 _tokenId) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.2 <0.8.0;\n', '\n', 'import "../../introspection/IERC165.sol";\n', '\n', '/**\n', ' * @dev Required interface of an ERC721 compliant contract.\n', ' */\n', 'interface IERC721 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.\n', '     */\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.\n', '     */\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    /**\n', "     * @dev Returns the number of tokens in ``owner``'s account.\n", '     */\n', '    function balanceOf(address owner) external view returns (uint256 balance);\n', '\n', '    /**\n', '     * @dev Returns the owner of the `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function ownerOf(uint256 tokenId) external view returns (address owner);\n', '\n', '    /**\n', '     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients\n', '     * are aware of the ERC721 protocol to prevent tokens from being forever locked.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must exist and be owned by `from`.\n', '     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Transfers `tokenId` token from `from` to `to`.\n', '     *\n', '     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must be owned by `from`.\n', '     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Gives permission to `to` to transfer `tokenId` token to another account.\n', '     * The approval is cleared when the token is transferred.\n', '     *\n', '     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The caller must own the token or be an approved operator.\n', '     * - `tokenId` must exist.\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Returns the account approved for `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function getApproved(uint256 tokenId) external view returns (address operator);\n', '\n', '    /**\n', '     * @dev Approve or remove `operator` as an operator for the caller.\n', '     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The `operator` cannot be the caller.\n', '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     */\n', '    function setApprovalForAll(address operator, bool _approved) external;\n', '\n', '    /**\n', '     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.\n', '     *\n', '     * See {setApprovalForAll}\n', '     */\n', '    function isApprovedForAll(address owner, address operator) external view returns (bool);\n', '\n', '    /**\n', '      * @dev Safely transfers `tokenId` token from `from` to `to`.\n', '      *\n', '      * Requirements:\n', '      *\n', '      * - `from` cannot be the zero address.\n', '      * - `to` cannot be the zero address.\n', '      * - `tokenId` token must exist and be owned by `from`.\n', '      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '      *\n', '      * Emits a {Transfer} event.\n', '      */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "./Context.sol";\n', '\n', '/**\n', ' * @dev Contract module which allows children to implement an emergency stop\n', ' * mechanism that can be triggered by an authorized account.\n', ' *\n', ' * This module is used through inheritance. It will make available the\n', ' * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n', ' * the functions of your contract. Note that they will not be pausable by\n', ' * simply including this module, only once the modifiers are put in place.\n', ' */\n', 'abstract contract Pausable is Context {\n', '    /**\n', '     * @dev Emitted when the pause is triggered by `account`.\n', '     */\n', '    event Paused(address account);\n', '\n', '    /**\n', '     * @dev Emitted when the pause is lifted by `account`.\n', '     */\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    /**\n', '     * @dev Initializes the contract in unpaused state.\n', '     */\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the contract is paused, and false otherwise.\n', '     */\n', '    function paused() public view virtual returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused(), "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused(), "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers stopped state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    /**\n', '     * @dev Returns to normal state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', '{\n', '  "remappings": [],\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']
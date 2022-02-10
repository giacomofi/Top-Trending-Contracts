['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-02\n', '*/\n', '\n', '/*\n', ' * Crypto stamp Bridge Data\n', ' * Holding all data that is used across the bridge and connected contracts\n', ' *\n', ' * Developed by Capacity Blockchain Solutions GmbH <capacity.at>\n', ' * for Österreichische Post AG <post.at>\n', ' *\n', ' * Any usage of or interaction with this set of contracts is subject to the\n', ' * Terms & Conditions available at https://crypto.post.at/\n', ' */\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/introspection/IERC165.sol\n', '\n', '/**\n', ' * @dev Interface of the ERC165 standard, as defined in the\n', ' * https://eips.ethereum.org/EIPS/eip-165[EIP].\n', ' *\n', ' * Implementers can declare support of contract interfaces, which can then be\n', ' * queried by others ({ERC165Checker}).\n', ' *\n', ' * For an implementation, see {ERC165}.\n', ' */\n', 'interface IERC165 {\n', '    /**\n', '     * @dev Returns true if this contract implements the interface defined by\n', '     * `interfaceId`. See the corresponding\n', '     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n', '     * to learn more about how these ids are created.\n', '     *\n', '     * This function call must use less than 30 000 gas.\n', '     */\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC721/IERC721.sol\n', '\n', '/**\n', ' * @dev Required interface of an ERC721 compliant contract.\n', ' */\n', 'interface IERC721 is IERC165 {\n', '    /**\n', '     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.\n', '     */\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '\n', '    /**\n', '     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.\n', '     */\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    /**\n', "     * @dev Returns the number of tokens in ``owner``'s account.\n", '     */\n', '    function balanceOf(address owner) external view returns (uint256 balance);\n', '\n', '    /**\n', '     * @dev Returns the owner of the `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function ownerOf(uint256 tokenId) external view returns (address owner);\n', '\n', '    /**\n', '     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients\n', '     * are aware of the ERC721 protocol to prevent tokens from being forever locked.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must exist and be owned by `from`.\n', '     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.\n', '     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Transfers `tokenId` token from `from` to `to`.\n', '     *\n', '     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `from` cannot be the zero address.\n', '     * - `to` cannot be the zero address.\n', '     * - `tokenId` token must be owned by `from`.\n', '     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Gives permission to `to` to transfer `tokenId` token to another account.\n', '     * The approval is cleared when the token is transferred.\n', '     *\n', '     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The caller must own the token or be an approved operator.\n', '     * - `tokenId` must exist.\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address to, uint256 tokenId) external;\n', '\n', '    /**\n', '     * @dev Returns the account approved for `tokenId` token.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `tokenId` must exist.\n', '     */\n', '    function getApproved(uint256 tokenId) external view returns (address operator);\n', '\n', '    /**\n', '     * @dev Approve or remove `operator` as an operator for the caller.\n', '     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The `operator` cannot be the caller.\n', '     *\n', '     * Emits an {ApprovalForAll} event.\n', '     */\n', '    function setApprovalForAll(address operator, bool _approved) external;\n', '\n', '    /**\n', '     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.\n', '     *\n', '     * See {setApprovalForAll}\n', '     */\n', '    function isApprovedForAll(address owner, address operator) external view returns (bool);\n', '\n', '    /**\n', '      * @dev Safely transfers `tokenId` token from `from` to `to`.\n', '      *\n', '      * Requirements:\n', '      *\n', '      * - `from` cannot be the zero address.\n', '      * - `to` cannot be the zero address.\n', '      * - `tokenId` token must exist and be owned by `from`.\n', '      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n', '      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.\n', '      *\n', '      * Emits a {Transfer} event.\n', '      */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;\n', '}\n', '\n', '// File: contracts/ENSReverseRegistrarI.sol\n', '\n', '/*\n', ' * Interfaces for ENS Reverse Registrar\n', ' * See https://github.com/ensdomains/ens/blob/master/contracts/ReverseRegistrar.sol for full impl\n', ' * Also see https://github.com/wealdtech/wealdtech-solidity/blob/master/contracts/ens/ENSReverseRegister.sol\n', ' *\n', ' * Use this as follows (registryAddress is the address of the ENS registry to use):\n', ' * -----\n', " * // This hex value is caclulated by namehash('addr.reverse')\n", ' * bytes32 public constant ENS_ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;\n', ' * function registerReverseENS(address registryAddress, string memory calldata) external {\n', ' *     require(registryAddress != address(0), "need a valid registry");\n', ' *     address reverseRegistrarAddress = ENSRegistryOwnerI(registryAddress).owner(ENS_ADDR_REVERSE_NODE)\n', ' *     require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");\n', ' *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);\n', ' * }\n', ' * -----\n', ' * or\n', ' * -----\n', ' * function registerReverseENS(address reverseRegistrarAddress, string memory calldata) external {\n', ' *    require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");\n', ' *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);\n', ' * }\n', ' * -----\n', ' * ENS deployments can be found at https://docs.ens.domains/ens-deployments\n', ' * E.g. Etherscan can be used to look up that owner on those contracts.\n', ' * namehash.hash("addr.reverse") == "0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2"\n', ' * Ropsten: ens.owner(namehash.hash("addr.reverse")) == "0x6F628b68b30Dc3c17f345c9dbBb1E483c2b7aE5c"\n', ' * Mainnet: ens.owner(namehash.hash("addr.reverse")) == "0x084b1c3C81545d370f3634392De611CaaBFf8148"\n', ' */\n', '\n', 'interface ENSRegistryOwnerI {\n', '    function owner(bytes32 node) external view returns (address);\n', '}\n', '\n', 'interface ENSReverseRegistrarI {\n', '    event NameChanged(bytes32 indexed node, string name);\n', '    /**\n', '     * @dev Sets the `name()` record for the reverse ENS record associated with\n', '     * the calling account.\n', '     * @param name The name to set for this address.\n', '     * @return The ENS node hash of the reverse record.\n', '     */\n', '    function setName(string calldata name) external returns (bytes32);\n', '}\n', '\n', '// File: contracts/BridgeDataI.sol\n', '\n', '/*\n', ' * Interface for data storage of the bridge.\n', ' */\n', '\n', 'interface BridgeDataI {\n', '\n', '    event AddressChanged(string name, address previousAddress, address newAddress);\n', '    event ConnectedChainChanged(string previousConnectedChainName, string newConnectedChainName);\n', '    event TokenURIBaseChanged(string previousTokenURIBase, string newTokenURIBase);\n', '    event TokenSunsetAnnounced(uint256 indexed timestamp);\n', '\n', '    /**\n', '     * @dev The name of the chain connected to / on the other side of this bridge head.\n', '     */\n', '    function connectedChainName() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev The name of our own chain, used in token URIs handed to deployed tokens.\n', '     */\n', '    function ownChainName() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev The base of ALL token URIs, e.g. https://example.com/\n', '     */\n', '    function tokenURIBase() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev The sunset timestamp for all deployed tokens.\n', '     * If 0, no sunset is in place. Otherwise, if older than block timestamp,\n', '     * all transfers of the tokens are frozen.\n', '     */\n', '    function tokenSunsetTimestamp() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Set a token sunset timestamp.\n', '     */\n', '    function setTokenSunsetTimestamp(uint256 _timestamp) external;\n', '\n', '    /**\n', '     * @dev Set an address for a name.\n', '     */\n', '    function setAddress(string memory name, address newAddress) external;\n', '\n', '    /**\n', '     * @dev Get an address for a name.\n', '     */\n', '    function getAddress(string memory name) external view returns (address);\n', '}\n', '\n', '// File: contracts/BridgeData.sol\n', '\n', '/*\n', ' * Implements a data storage for the bridge.\n', ' * Mostly used to storage addresses for various contracts in a common place\n', ' * that all contracts can access, but also some other data commonly shared\n', ' * between bridge-related contracts.\n', ' * Liberally based on Optimistic Ethereum Lib_AddressManager.sol\n', ' */\n', '\n', '\n', '\n', '\n', '\n', 'contract BridgeData is BridgeDataI {\n', '    // Chain names\n', '    string public override connectedChainName;\n', '    string public override ownChainName;\n', '    // Base for token URIs\n', '    string public override tokenURIBase;\n', '\n', '    // Token sunset\n', '    uint256 public override tokenSunsetTimestamp;\n', '    uint256 public immutable sunsetDelay;\n', '\n', '    // Various addresses, accessed via a name hash.\n', '    mapping (bytes32 => address) private addresses;\n', '\n', '    constructor(string memory _connectedChainName, string memory _ownChainName, string memory _tokenURIBase, uint256 _sunsetDelay, address _tokenAssignmentControl)\n', '    {\n', '        // During the deployment phase, set bridgeControl to deployer,\n', '        // at the end of deployment, switch to actual bridgeControl address.\n', '        _setAddress("bridgeControl", msg.sender);\n', '        _setAddress("tokenAssignmentControl", _tokenAssignmentControl);\n', '        sunsetDelay = _sunsetDelay;\n', '        connectedChainName = _connectedChainName;\n', '        ownChainName = _ownChainName;\n', '        tokenURIBase = _tokenURIBase;\n', '    }\n', '\n', '    modifier onlyBridgeControl()\n', '    {\n', '        require(msg.sender == getAddress("bridgeControl"), "bridgeControl key required for this function.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyBridge()\n', '    {\n', '        require(msg.sender == getAddress("bridgeControl") || msg.sender == getAddress("bridgeHead"), "bridgeControl key or bridge head required for this function.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyTokenAssignmentControl() {\n', '        require(msg.sender == getAddress("tokenAssignmentControl"), "tokenAssignmentControl key required for this function.");\n', '        _;\n', '    }\n', '\n', '    /*** Enable adjusting variables after deployment ***/\n', '\n', '    function setConnectedChain(string memory _newConnectedChainName)\n', '    external\n', '    onlyBridgeControl\n', '    {\n', '        require(bytes(_newConnectedChainName).length > 0, "You need to provide an actual chain name string.");\n', '        emit ConnectedChainChanged(connectedChainName, _newConnectedChainName);\n', '        connectedChainName = _newConnectedChainName;\n', '    }\n', '\n', '    function setTokenURIBase(string memory _newTokenURIBase)\n', '    external\n', '    onlyBridgeControl\n', '    {\n', '        require(bytes(_newTokenURIBase).length > 0, "You need to provide an actual token URI base string.");\n', '        emit TokenURIBaseChanged(tokenURIBase, _newTokenURIBase);\n', '        tokenURIBase = _newTokenURIBase;\n', '    }\n', '\n', '    // Set a sunset timestamp for bridged tokens. All transfers will be disabled after that.\n', '    // The timestamp has to be at least a delay duration in the future when not yet set.\n', '    // Once set, it can be pushed to the further future at any rate with no addittive delay.\n', '    // It also can be set to 0 at any point in time, which disables the sunset.\n', '    function setTokenSunsetTimestamp(uint256 _timestamp)\n', '    public override\n', '    onlyBridge\n', '    {\n', '        require(_timestamp == 0 || _timestamp >= block.timestamp + sunsetDelay ||\n', '                (tokenSunsetTimestamp > 0 && _timestamp >= tokenSunsetTimestamp && _timestamp >= block.timestamp),\n', '                "Sunset needs to be 0 or (enough) in the future.");\n', '        tokenSunsetTimestamp = _timestamp;\n', '        emit TokenSunsetAnnounced(_timestamp);\n', '    }\n', '\n', '    function setAddress(string memory _name, address _newAddress)\n', '    public override\n', '    onlyBridge\n', '    {\n', '        _setAddress(_name, _newAddress);\n', '    }\n', '\n', '    function _setAddress(string memory _name, address _newAddress)\n', '    internal\n', '    {\n', '        bytes32 nameHash = _getNameHash(_name);\n', '        require(_newAddress != address(0) || nameHash != _getNameHash("bridgeControl"), "bridgeControl cannot be the zero address.");\n', '        emit AddressChanged(_name, addresses[nameHash], _newAddress);\n', '        addresses[nameHash] = _newAddress;\n', '    }\n', '\n', '    function getAddress(string memory _name)\n', '    public view override\n', '    returns (address)\n', '    {\n', '        return addresses[_getNameHash(_name)];\n', '    }\n', '\n', '    function _getNameHash(string memory _name)\n', '    internal pure\n', '    returns (bytes32 _hash)\n', '    {\n', '        return keccak256(abi.encodePacked(_name));\n', '    }\n', '\n', '    /*** Enable reverse ENS registration ***/\n', '\n', '    // Call this with the address of the reverse registrar for the respective network and the ENS name to register.\n', "    // The reverse registrar can be found as the owner of 'addr.reverse' in the ENS system.\n", '    // For Mainnet, the address needed is 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069\n', '    function registerReverseENS(address _reverseRegistrarAddress, string calldata _name)\n', '    external\n', '    onlyTokenAssignmentControl\n', '    {\n', '        require(_reverseRegistrarAddress != address(0), "need a valid reverse registrar");\n', '        ENSReverseRegistrarI(_reverseRegistrarAddress).setName(_name);\n', '    }\n', '\n', "    /*** Make sure currency or NFT doesn't get stranded in this contract ***/\n", '\n', "    // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.\n", '    function rescueToken(address _foreignToken, address _to)\n', '    external\n', '    onlyTokenAssignmentControl\n', '    {\n', '        IERC20 erc20Token = IERC20(_foreignToken);\n', '        erc20Token.transfer(_to, erc20Token.balanceOf(address(this)));\n', '    }\n', '\n', "    // If this contract gets a balance in some ERC721 contract after it's finished, then we can rescue it.\n", '    function approveNFTrescue(IERC721 _foreignNFT, address _to)\n', '    external\n', '    onlyTokenAssignmentControl\n', '    {\n', '        _foreignNFT.setApprovalForAll(_to, true);\n', '    }\n', '\n', '}']
['pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Required interface of an ERC721 compliant contract.\n', ' */\n', 'abstract contract IERC721 {\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    //function name() public view returns (string memory name);\n', '    //function symbol() public view returns (string memory symbol);\n', '    //function totalSupply() public view returns (uint256 totalSupply);\n', '    /**\n', "     * @dev Returns the number of NFTs in `owner`'s account.\n", '     */\n', '    function balanceOf(address owner) external virtual view returns (uint256 balance);\n', '\n', '    /**\n', '     * @dev Returns the owner of the NFT specified by `tokenId`.\n', '     */\n', '    function ownerOf(uint256 tokenId) external virtual view returns (address owner);\n', '\n', '    /**\n', '     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Requirements:\n', '     * - `from`, `to` cannot be zero.\n', '     * - `tokenId` must be owned by `from`.\n', '     * - If the caller is not `from`, it must be have been allowed to move this\n', '     * NFT by either `approve` or `setApproveForAll`.\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) external virtual;\n', '    /**\n', '     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Requirements:\n', '     * - If the caller is not `from`, it must be approved to move this NFT by\n', '     * either `approve` or `setApproveForAll`.\n', '     */\n', '    function transferFrom(address from, address to, uint256 tokenId) external virtual;\n', '    function approve(address to, uint256 tokenId) external virtual;\n', '    function getApproved(uint256 tokenId) external virtual view returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public virtual;\n', '    function isApprovedForAll(address owner, address operator) public virtual view returns (bool);\n', '\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual;\n', '}\n', '\n', '/**\n', ' * @title ERC721 token receiver interface\n', ' * @dev Interface for any contract that wants to support safeTransfers\n', ' * from ERC721 asset contracts.\n', ' */\n', 'abstract contract IERC721Receiver {\n', '    /**\n', '     * @notice Handle the receipt of an NFT\n', '     * @dev The ERC721 smart contract calls this function on the recipient\n', '     * after a `safeTransfer`. This function MUST return the function selector,\n', '     * otherwise the caller will revert the transaction. The selector to be\n', '     * returned can be obtained as `this.onERC721Received.selector`. This\n', '     * function MAY throw to revert and reject the transfer.\n', '     * Note: the ERC721 contract address is always the message sender.\n', '     * @param operator The address which called `safeTransferFrom` function\n', '     * @param from The address which previously owned the token\n', '     * @param tokenId The NFT identifier which is being transferred\n', '     * @param data Additional data with no specified format\n', '     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`\n', '     */\n', '    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)\n', '    public virtual returns (bytes4);\n', '}\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', 'contract OasisTok is IERC721\n', ' {\n', '    using SafeMath for uint256;\n', '    event tokenMinted(uint256 tokenId, address owner);\n', '    event tokenBurned(uint256 tokenId);\n', '    event TokenTransferred(address from, address to, uint256 tokenId);\n', '    event ApprovalForAll(address from, address to, bool approved);\n', ' \n', '    // Mapping ontology id to Hash(properties)\n', '  \n', '    struct Multihash\n', '    {\n', '      uint8 hashFunction;\n', '      uint8 size;\n', '      bytes32 digest;\n', '    } \n', '     \n', '    struct OSC\n', '    {\n', '     Multihash ontology;\n', '     Multihash query;\n', '     uint256 prev;\n', '    }\n', '    \n', '    mapping(bytes32 => uint) ontoHashToId;\n', '    mapping (uint => address) ontologyOwner;\n', '    mapping (uint => bool)  ontologyActive;\n', '    mapping (address => uint) public ownerOntoCount;\n', '      // Mapping from token ID to approved address\n', '    mapping (uint => address) ontologyApprovals;\n', '    // Mapping from owner to operator approvals\n', '    mapping (address => mapping (address => bool)) operatorApprovals;\n', '\n', '    address _contOwner;\n', '    string _name;\n', '    string _symbol;\n', '     \n', '    OSC[] private ontologies;\n', '    \n', '    constructor(string memory name, string memory symbol)\n', '        public\n', '    {\n', '        _contOwner = msg.sender;\n', '        _name = name;\n', '        _symbol = symbol;\n', '        //burn token 0\n', '        bytes32 hash = keccak256(abi.encodePacked(uint8(0), uint8(0), bytes32(0), uint8(0), uint8(0), bytes32(0), uint256(0))); \n', '        OSC memory osc= OSC(Multihash(uint8(0), uint8(0), bytes32(0)), Multihash(uint8(0),uint8(0), bytes32(0)), uint256(0));    \n', '        ontologies.push(osc);         \n', '        ontoHashToId[hash] = 0;\n', '        ontologyOwner[0] = address(0); \n', '        ontologyActive[0] = false;\n', '\n', '    }\n', '    \n', '       \n', '   function mint (uint8 hashO, uint8 sizeO, bytes32 digestO, uint8 hashQ, uint8 sizeQ, bytes32 digestQ, uint256 prev) public \n', '      {\n', '         if(tokenExists(hashO, sizeO, digestO, hashQ, sizeQ, digestQ, prev)) \n', '         {\n', '            revert("This token already exist!");\n', '         }\n', '         if (prev != 0 && !tokenIDExists(prev))\n', '         {\n', '           revert("Previous token does not exists or different from 0!");\n', '         }\n', '         bytes32 hash = keccak256(abi.encodePacked(hashO, sizeO, digestO, hashQ, sizeQ, digestQ, prev)); \n', '         OSC memory osc= OSC(Multihash(hashO, sizeO, digestO), Multihash(hashQ, sizeQ, digestQ), prev);    \n', '         ontologies.push(osc);\n', '         uint256 id = ontologies.length;\n', '         id--;\n', '         ontoHashToId[hash] = id;\n', '         ontologyOwner[id] = msg.sender; \n', '         ontologyActive[id] = true;        \n', '         ownerOntoCount[msg.sender] = SafeMath.add(ownerOntoCount[msg.sender], 1);         \n', '\n', '         emit tokenMinted (id, msg.sender);        \n', '     }\n', '     \n', '     function burn (uint256 id) external\n', '     {\n', '         require(msg.sender == ontologyOwner[id]);\n', '         require(tokenIDExists(id));\n', '         ontologyActive[id]= false;        \n', '         ownerOntoCount[msg.sender] = SafeMath.sub(ownerOntoCount[msg.sender], 1);\n', '         //ontologyOwner[id]=address(0);\n', '         emit tokenBurned(id);\n', '     }\n', '     \n', '     function  transferFrom(address from, address to, uint256 id) public override\n', '     {\n', '         require(from != address(0) && to != address(0));\n', '         require(_isApprovedOrOwner(msg.sender, id));\n', '         require(tokenIDExists(id));\n', '         ontologyOwner[id] = to;\n', '          _clearApproval(to, id);\n', '         ownerOntoCount[to] = SafeMath.add(ownerOntoCount[to], 1);\n', '         ownerOntoCount[from] = SafeMath.sub(ownerOntoCount[from], 1);\n', '         emit TokenTransferred(from, to,id);\n', '         \n', '     }\n', '\n', '     \n', '     function tokenExists(uint8 hashO, uint8 sizeO, bytes32 digestO, uint8 hashQ, uint8 sizeQ, bytes32 digestQ, uint256 prev) public view returns (bool)\n', '     {        \n', '        bytes32 hash = keccak256(abi.encodePacked(hashO, sizeO, digestO, hashQ, sizeQ, digestQ, prev));\n', '        if (ontoHashToId[hash] == 0)\n', '        {\n', '           return false;\n', '        }\n', '        return true;\n', '     }\n', '     \n', '     function tokenIDExists(uint256 id) public view returns (bool)\n', '     {\n', '         return ontologyActive[id];\n', '     }\n', '     \n', '     function getTokenInfo(uint256 id) public view returns (uint8 hashO, uint8 sizeO, bytes32 digestO, uint8 hashQ, uint8 sizeQ, bytes32 digestQ, uint256 prev)\n', '     {\n', '         return (ontologies[id].ontology.hashFunction,\n', '                 ontologies[id].ontology.size,\n', '                 ontologies[id].ontology.digest,\n', '                 ontologies[id].query.hashFunction,\n', '                 ontologies[id].query.size,\n', '                 ontologies[id].query.digest,\n', '                 ontologies[id].prev);\n', '\n', '     }\n', '     \n', '  \n', '     function balanceOf(address _tokenOwner)  \n', '        public\n', '        view override\n', '        returns(uint256 _balance)\n', '    {\n', '        return ownerOntoCount[_tokenOwner];\n', '    }\n', '\n', '\n', '\n', '     \n', '     // Approve other wallet to transfer ownership of token\n', '    function approve(address _to, uint256 id) public override\n', '    {\n', '        require(msg.sender == ontologyOwner[id]);\n', '        ontologyApprovals[id] = _to;\n', '        emit Approval(msg.sender, _to, id);\n', '    }\n', '\n', '    // Return approved address for specific token\n', '    function getApproved(uint256 id)  public view override returns(address operator)\n', '    {\n', '        require(tokenIDExists(id));\n', '        return ontologyApprovals[id];\n', '    }\n', '\n', '    /**\n', '     * Private function to clear current approval of a given token ID\n', '     * Reverts if the given address is not indeed the owner of the token\n', '     */\n', '    function _clearApproval(address owner, uint256 id) private\n', '    {\n', '        require(ontologyOwner[id] == owner);\n', '        require(tokenIDExists(id));\n', '        if (ontologyApprovals[id] != address(0)) {\n', '            ontologyApprovals[id] = address(0);\n', '        }\n', '    }\n', '\n', '    /*\n', '     * Sets or unsets the approval of a given operator\n', '     * An operator is allowed to transfer all tokens of the sender on their behalf\n', '     */\n', '     function setApprovalForAll(address to, bool approved)  public override\n', '    {\n', '        require(to != msg.sender);\n', '        operatorApprovals[msg.sender][to] = approved;\n', '        emit ApprovalForAll(msg.sender, to, approved);\n', '    }\n', '\n', '    // Tells whether an operator is approved by a given owner\n', '    function isApprovedForAll(address Owner, address operator)  public  view override returns(bool)\n', '    {\n', '        return operatorApprovals[Owner][operator];\n', '    }\n', '\n', '    // Take ownership of token - only for approved users\n', '    function takeOwnership(uint256 id)  public\n', '    {\n', '        require(_isApprovedOrOwner(msg.sender, id));\n', '        address Owner = ownerOf(id);\n', '        transferFrom(Owner, msg.sender, id);\n', '    }\n', '\n', '     function _isApprovedOrOwner(address spender, uint256 id) internal   view   returns(bool)\n', '    {\n', '        address Owner = ontologyOwner[id];\n', '        return (spender == Owner || getApproved(id) == spender || isApprovedForAll(Owner, spender));\n', '    }\n', '\n', '     function ownerOf(uint256 id)  public  view  override returns(address _owner)\n', '    {\n', '        return  ontologyOwner[id];\n', '    }\n', '\n', '\n', '     \n', '    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`\n', '    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`\n', '    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;\n', '     \n', '    // Return the owner address\n', '    function owner()\n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        return _contOwner;\n', '    }\n', '\n', '    // Returns true if the caller is the current owner.\n', '    function isOwner()\n', '        public\n', '        view\n', '        returns (bool)\n', '    {\n', '        return msg.sender == _contOwner;\n', '    }\n', '\t\n', '\t// Destroy this smart contract and withdraw balance to owner\n', '\tfunction shutdown() public\n', '\t\tonlyOwner\n', '\t{\n', '        selfdestruct(msg.sender);\n', '    }\n', '\n', '     \n', '      // Throws if called by any account other than the owner.\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '     \n', '     \n', '      /**\n', '     * Safely transfers the ownership of a given token ID to another address\n', '     * If the target address is a contract, it must implement `onERC721Received`,\n', '     * which is called upon a safe transfer, and return the magic value\n', '     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,\n', '     * the transfer is reverted.\n', '    */\n', '    function safeTransferFrom(address from, address to, uint256 id)  external override\n', '    {\n', '        // solium-disable-next-line arg-overflow\n', '        safeTransferFrom(from, to, id, "");\n', '    }\n', '\n', '    /**\n', '     * Safely transfers the ownership of a given token ID to another address\n', '     * If the target address is a contract, it must implement `onERC721Received`,\n', '     * which is called upon a safe transfer, and return the magic value\n', '     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,\n', '     */\n', '    function safeTransferFrom(address from, address to, uint256 id, bytes memory _data) public override\n', '    {\n', '        transferFrom(from, to, id);\n', '        // solium-disable-next-line arg-overflow\n', '        require(_checkOnERC721Received(from, to, id, _data));\n', '    }\n', '\n', '    // Returns whether the target address is a contract\n', '    function isContract(address account)\n', '        internal\n', '        view\n', '        returns(bool)\n', '    {\n', '        uint256 size;\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '    \n', '     /**\n', '     * @dev Internal function to invoke `onERC721Received` on a target address\n', '     * The call is not executed if the target address is not a contract\n', '     * @param from address representing the previous owner of the given token ID\n', '     * @param to target address that will receive the tokens\n', '     * @param tokenId uint256 ID of the token to be transferred\n', '     * @param _data bytes optional data to send along with the call\n', '     * @return bool whether the call correctly returned the expected magic value\n', '     */\n', '    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)\n', '        internal returns (bool)\n', '    {\n', '        if (!isContract(to)) {\n', '            return true;\n', '        }\n', '\n', '        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);\n', '        return (retval == _ERC721_RECEIVED);\n', '    }\n', '\n', '\n', '    // Allows the owener to capture the balance available to the contract.\n', '    function withdrawBalance()\n', '        external\n', '        onlyOwner\n', '    {\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '     \n', ' }']
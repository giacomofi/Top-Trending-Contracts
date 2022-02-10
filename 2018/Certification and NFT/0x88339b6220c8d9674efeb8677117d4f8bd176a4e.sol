['pragma solidity 0.4.24;\n', '\n', 'contract Cryptopixel {\n', '\n', '    // Name of token\n', '    string constant public name = "CryptoPixel";\n', '    // Symbol of Cryptopixel token\n', '  \tstring constant public symbol = "CPX";\n', '\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /////////////////////////\n', '    // Variables\n', '    /////////////////////////\n', '    // Total number of stored artworks\n', '    uint256 public totalSupply;\n', '    // Group of artwork - 52 is limit\n', '    address[limitChrt] internal artworkGroup;\n', '    // Number of total artworks\n', '    uint constant private limitChrt = 52;\n', '    // This is address of artwork creator\n', '    address constant private creatorAddr = 0x174B3C5f95c9F27Da6758C8Ca941b8FFbD01d330;\n', '\n', '    \n', '    // Basic references\n', '    mapping(uint => address) internal tokenIdToOwner;\n', '    mapping(address => uint[]) internal listOfOwnerTokens;\n', '    mapping(uint => string) internal referencedMetadata;\n', '    \n', '    // Events\n', '    event Minted(address indexed _to, uint256 indexed _tokenId);\n', '\n', '    // Modifier\n', '    modifier onlyNonexistentToken(uint _tokenId) {\n', '        require(tokenIdToOwner[_tokenId] == address(0));\n', '        _;\n', '    }\n', '\n', '\n', '    /////////////////////////\n', '    // Viewer Functions\n', '    /////////////////////////\n', '    // Get and returns the address currently marked as the owner of _tokenID. \n', '    function ownerOf(uint256 _tokenId) public view returns (address _owner)\n', '    {\n', '        return tokenIdToOwner[_tokenId];\n', '    }\n', '    \n', '    // Get and return the total supply of token held by this contract. \n', '    function totalSupply() public view returns (uint256 _totalSupply)\n', '    {\n', '        return totalSupply;\n', '    }\n', '    \n', '    //Get and return the balance of token held by _owner. \n', '    function balanceOf(address _owner) public view returns (uint _balance)\n', '    {\n', '        return listOfOwnerTokens[_owner].length;\n', '    }\n', '\n', '    // Get and returns a metadata of _tokenId\n', '    function tokenMetadata(uint _tokenId) public view returns (string _metadata)\n', '    {\n', '        return referencedMetadata[_tokenId];\n', '    }\n', '    \n', '    // Retrive artworkGroup\n', '    function getArtworkGroup() public view returns (address[limitChrt]) {\n', '        return artworkGroup;\n', '    }\n', '    \n', '    \n', '    /////////////////////////\n', '    // Update Functions\n', '    /////////////////////////\n', '    /**\n', '     * @dev Public function to mint a new token with metadata\n', '     * @dev Reverts if the given token ID already exists\n', '     * @param _owner The address that will own the minted token\n', '     * @param _tokenId uint256 ID of the token to be minted by the msg.sender(creator)\n', '     * @param _metadata string of meta data, IPFS hash\n', '     */\n', '    function mintWithMetadata(address _owner, uint256 _tokenId, string _metadata) public onlyNonexistentToken (_tokenId)\n', '    {\n', '        require(totalSupply < limitChrt);\n', '        require(creatorAddr == _owner);\n', '        \n', '        _setTokenOwner(_tokenId, _owner);\n', '        _addTokenToOwnersList(_owner, _tokenId);\n', '        _insertTokenMetadata(_tokenId, _metadata);\n', '\n', '        artworkGroup[_tokenId] = _owner;\n', '        totalSupply = totalSupply.add(1);\n', '        emit Minted(_owner, _tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Public function to add created token id in group\n', '     * @param _owner The address that will own the minted token\n', '     * @param _tokenId uint256 ID of the token to be minted by the msg.sender(creator)\n', '     * @return _tokenId uint256 ID of the token \n', '     */\n', '    function group(address _owner, uint _tokenId) public returns (uint) {\n', '        require(_tokenId >= 0 && _tokenId <= limitChrt);\n', '        artworkGroup[_tokenId] = _owner;    \n', '        return _tokenId;\n', '    }\n', '\n', '    \n', '    /////////////////////////\n', '    // Internal, helper functions\n', '    /////////////////////////\n', '    function _setTokenOwner(uint _tokenId, address _owner) internal\n', '    {\n', '        tokenIdToOwner[_tokenId] = _owner;\n', '    }\n', '\n', '    function _addTokenToOwnersList(address _owner, uint _tokenId) internal\n', '    {\n', '        listOfOwnerTokens[_owner].push(_tokenId);\n', '    }\n', '\n', '    function _insertTokenMetadata(uint _tokenId, string _metadata) internal\n', '    {\n', '        referencedMetadata[_tokenId] = _metadata;\n', '    }\n', '    \n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity 0.4.24;\n', '\n', 'contract Cryptopixel {\n', '\n', '    // Name of token\n', '    string constant public name = "CryptoPixel";\n', '    // Symbol of Cryptopixel token\n', '  \tstring constant public symbol = "CPX";\n', '\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /////////////////////////\n', '    // Variables\n', '    /////////////////////////\n', '    // Total number of stored artworks\n', '    uint256 public totalSupply;\n', '    // Group of artwork - 52 is limit\n', '    address[limitChrt] internal artworkGroup;\n', '    // Number of total artworks\n', '    uint constant private limitChrt = 52;\n', '    // This is address of artwork creator\n', '    address constant private creatorAddr = 0x174B3C5f95c9F27Da6758C8Ca941b8FFbD01d330;\n', '\n', '    \n', '    // Basic references\n', '    mapping(uint => address) internal tokenIdToOwner;\n', '    mapping(address => uint[]) internal listOfOwnerTokens;\n', '    mapping(uint => string) internal referencedMetadata;\n', '    \n', '    // Events\n', '    event Minted(address indexed _to, uint256 indexed _tokenId);\n', '\n', '    // Modifier\n', '    modifier onlyNonexistentToken(uint _tokenId) {\n', '        require(tokenIdToOwner[_tokenId] == address(0));\n', '        _;\n', '    }\n', '\n', '\n', '    /////////////////////////\n', '    // Viewer Functions\n', '    /////////////////////////\n', '    // Get and returns the address currently marked as the owner of _tokenID. \n', '    function ownerOf(uint256 _tokenId) public view returns (address _owner)\n', '    {\n', '        return tokenIdToOwner[_tokenId];\n', '    }\n', '    \n', '    // Get and return the total supply of token held by this contract. \n', '    function totalSupply() public view returns (uint256 _totalSupply)\n', '    {\n', '        return totalSupply;\n', '    }\n', '    \n', '    //Get and return the balance of token held by _owner. \n', '    function balanceOf(address _owner) public view returns (uint _balance)\n', '    {\n', '        return listOfOwnerTokens[_owner].length;\n', '    }\n', '\n', '    // Get and returns a metadata of _tokenId\n', '    function tokenMetadata(uint _tokenId) public view returns (string _metadata)\n', '    {\n', '        return referencedMetadata[_tokenId];\n', '    }\n', '    \n', '    // Retrive artworkGroup\n', '    function getArtworkGroup() public view returns (address[limitChrt]) {\n', '        return artworkGroup;\n', '    }\n', '    \n', '    \n', '    /////////////////////////\n', '    // Update Functions\n', '    /////////////////////////\n', '    /**\n', '     * @dev Public function to mint a new token with metadata\n', '     * @dev Reverts if the given token ID already exists\n', '     * @param _owner The address that will own the minted token\n', '     * @param _tokenId uint256 ID of the token to be minted by the msg.sender(creator)\n', '     * @param _metadata string of meta data, IPFS hash\n', '     */\n', '    function mintWithMetadata(address _owner, uint256 _tokenId, string _metadata) public onlyNonexistentToken (_tokenId)\n', '    {\n', '        require(totalSupply < limitChrt);\n', '        require(creatorAddr == _owner);\n', '        \n', '        _setTokenOwner(_tokenId, _owner);\n', '        _addTokenToOwnersList(_owner, _tokenId);\n', '        _insertTokenMetadata(_tokenId, _metadata);\n', '\n', '        artworkGroup[_tokenId] = _owner;\n', '        totalSupply = totalSupply.add(1);\n', '        emit Minted(_owner, _tokenId);\n', '    }\n', '\n', '    /**\n', '     * @dev Public function to add created token id in group\n', '     * @param _owner The address that will own the minted token\n', '     * @param _tokenId uint256 ID of the token to be minted by the msg.sender(creator)\n', '     * @return _tokenId uint256 ID of the token \n', '     */\n', '    function group(address _owner, uint _tokenId) public returns (uint) {\n', '        require(_tokenId >= 0 && _tokenId <= limitChrt);\n', '        artworkGroup[_tokenId] = _owner;    \n', '        return _tokenId;\n', '    }\n', '\n', '    \n', '    /////////////////////////\n', '    // Internal, helper functions\n', '    /////////////////////////\n', '    function _setTokenOwner(uint _tokenId, address _owner) internal\n', '    {\n', '        tokenIdToOwner[_tokenId] = _owner;\n', '    }\n', '\n', '    function _addTokenToOwnersList(address _owner, uint _tokenId) internal\n', '    {\n', '        listOfOwnerTokens[_owner].push(_tokenId);\n', '    }\n', '\n', '    function _insertTokenMetadata(uint _tokenId, string _metadata) internal\n', '    {\n', '        referencedMetadata[_tokenId] = _metadata;\n', '    }\n', '    \n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '// inspired by\n', '// https://github.com/axiomzen/cryptokitties-bounty/blob/master/contracts/KittyAccessControl.sol\n', '\n', 'contract AccessControl {\n', '  /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles\n', '  address public ceoAddress;\n', '  address public cooAddress;\n', '\n', '  /// @dev Keeps track whether the contract is paused. When that is true, most actions are blocked\n', '  bool public paused = false;\n', '\n', '  /// @dev The AccessControl constructor sets the original C roles of the contract to the sender account\n', '  function AccessControl() public {\n', '    ceoAddress = msg.sender;\n', '    cooAddress = msg.sender;\n', '  }\n', '\n', '  /// @dev Access modifier for CEO-only functionality\n', '  modifier onlyCEO() {\n', '    require(msg.sender == ceoAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Access modifier for COO-only functionality\n', '  modifier onlyCOO() {\n', '    require(msg.sender == cooAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Access modifier for any CLevel functionality\n', '  modifier onlyCLevel() {\n', '    require(msg.sender == ceoAddress || msg.sender == cooAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Assigns a new address to act as the CEO. Only available to the current CEO\n', '  /// @param _newCEO The address of the new CEO\n', '  function setCEO(address _newCEO) public onlyCEO {\n', '    require(_newCEO != address(0));\n', '    ceoAddress = _newCEO;\n', '  }\n', '\n', '  /// @dev Assigns a new address to act as the COO. Only available to the current CEO\n', '  /// @param _newCOO The address of the new COO\n', '  function setCOO(address _newCOO) public onlyCEO {\n', '    require(_newCOO != address(0));\n', '    cooAddress = _newCOO;\n', '  }\n', '\n', '  /// @dev Modifier to allow actions only when the contract IS NOT paused\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /// @dev Modifier to allow actions only when the contract IS paused\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /// @dev Pause the smart contract. Only can be called by the CEO\n', '  function pause() public onlyCEO whenNotPaused {\n', '     paused = true;\n', '  }\n', '\n', '  /// @dev Unpauses the smart contract. Only can be called by the CEO\n', '  function unpause() public onlyCEO whenPaused {\n', '    paused = false;\n', '  }\n', '}\n', '\n', '\n', '// https://github.com/dharmaprotocol/NonFungibleToken/blob/master/contracts/ERC721.sol\n', '// https://github.com/dharmaprotocol/NonFungibleToken/blob/master/contracts/DetailedERC721.sol\n', '\n', '/**\n', ' * Interface for required functionality in the ERC721 standard\n', ' * for non-fungible tokens.\n', ' *\n', ' * Author: Nadav Hollander (nadav at dharma.io)\n', ' */\n', 'contract ERC721 {\n', '    // Events\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);\n', '    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);\n', '\n', '    /// For querying totalSupply of token.\n', '    function totalSupply() public view returns (uint256 _totalSupply);\n', '\n', '    /// For querying balance of a particular account.\n', '    /// @param _owner The address for balance query.\n', '    /// @dev Required for ERC-721 compliance.\n', '    function balanceOf(address _owner) public view returns (uint256 _balance);\n', '\n', '    /// For querying owner of token.\n', '    /// @param _tokenId The tokenID for owner inquiry.\n', '    /// @dev Required for ERC-721 compliance.\n', '    function ownerOf(uint256 _tokenId) public view returns (address _owner);\n', '\n', '    /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom()\n', '    /// @param _to The address to be granted transfer approval. Pass address(0) to\n', '    ///  clear all approvals.\n', '    /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '    /// @dev Required for ERC-721 compliance.\n', '    function approve(address _to, uint256 _tokenId) public;\n', '\n', '    // NOT IMPLEMENTED\n', '    // function getApproved(uint256 _tokenId) public view returns (address _approved);\n', '\n', '    /// Third-party initiates transfer of token from address _from to address _to.\n', '    /// @param _from The address for the token to be transferred from.\n', '    /// @param _to The address for the token to be transferred to.\n', '    /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '    /// @dev Required for ERC-721 compliance.\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '\n', '    /// Owner initates the transfer of the token to another account.\n', '    /// @param _to The address of the recipient, can be a user or contract.\n', '    /// @param _tokenId The ID of the token to transfer.\n', '    /// @dev Required for ERC-721 compliance.\n', '    function transfer(address _to, uint256 _tokenId) public;\n', '\n', '    ///\n', '    function implementsERC721() public view returns (bool _implementsERC721);\n', '\n', '    // EXTRA\n', '    /// @notice Allow pre-approved user to take ownership of a token.\n', '    /// @param _tokenId The ID of the token that can be transferred if this call succeeds.\n', '    /// @dev Required for ERC-721 compliance.\n', '    function takeOwnership(uint256 _tokenId) public;\n', '}\n', '\n', '/**\n', ' * Interface for optional functionality in the ERC721 standard\n', ' * for non-fungible tokens.\n', ' *\n', ' * Author: Nadav Hollander (nadav at dharma.io)\n', ' */\n', 'contract DetailedERC721 is ERC721 {\n', '    function name() public view returns (string _name);\n', '    function symbol() public view returns (string _symbol);\n', '    // function tokenMetadata(uint256 _tokenId) public view returns (string _infoUrl);\n', '    // function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);\n', '}\n', '\n', '\n', 'contract CryptoArtsToken is AccessControl, DetailedERC721 {\n', '  using SafeMath for uint256;\n', '\n', '  /// @dev The TokenCreated event is fired whenever a new token is created.\n', '  event TokenCreated(uint256 tokenId, string name, uint256 price, address owner);\n', '\n', '  /// @dev The TokenSold event is fired whenever a token is sold.\n', '  event TokenSold(uint256 indexed tokenId, string name, uint256 sellingPrice,\n', '   uint256 newPrice, address indexed oldOwner, address indexed newOwner);\n', '\n', '\n', '  /// @dev A mapping from tokenIds to the address that owns them. All tokens have\n', '  ///  some valid owner address.\n', '  mapping (uint256 => address) private tokenIdToOwner;\n', '\n', '  /// @dev A mapping from TokenIds to the price of the token.\n', '  mapping (uint256 => uint256) private tokenIdToPrice;\n', '\n', '  /// @dev A mapping from owner address to count of tokens that address owns.\n', '  ///  Used internally inside balanceOf() to resolve ownership count.\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '\n', '  /// @dev A mapping from TokenIds to an address that has been approved to call\n', '  ///  transferFrom(). Each Token can only have one approved address for transfer\n', '  ///  at any time. A zero value means no approval is outstanding\n', '  mapping (uint256 => address) public tokenIdToApproved;\n', '\n', '\n', '  struct Art {\n', '    string name;\n', '  }\n', '  Art[] private arts;\n', '\n', '  uint256 private startingPrice = 0.01 ether;\n', '  bool private erc721Enabled = false;\n', '\n', '  modifier onlyERC721() {\n', '    require(erc721Enabled);\n', '    _;\n', '  }\n', '\n', '  /// @dev Creates a new token with the given name and _price and assignes it to an _owner.\n', '  function createToken(string _name, address _owner, uint256 _price) public onlyCLevel {\n', '    require(_owner != address(0));\n', '    require(_price >= startingPrice);\n', '\n', '    _createToken(_name, _owner, _price);\n', '  }\n', '\n', '  /// @dev Creates a new token with the given name.\n', '  function createToken(string _name) public onlyCLevel {\n', '    _createToken(_name, address(this), startingPrice);\n', '  }\n', '\n', '  function _createToken(string _name, address _owner, uint256 _price) private {\n', '    Art memory _art = Art({\n', '      name: _name\n', '    });\n', '    uint256 newTokenId = arts.push(_art) - 1;\n', '    tokenIdToPrice[newTokenId] = _price;\n', '\n', '    TokenCreated(newTokenId, _name, _price, _owner);\n', '\n', '    // This will assign ownership, and also emit the Transfer event as per ERC721 draft\n', '    _transfer(address(0), _owner, newTokenId);\n', '  }\n', '\n', '  function getToken(uint256 _tokenId) public view returns (\n', '    string _tokenName,\n', '    uint256 _price,\n', '    uint256 _nextPrice,\n', '    address _owner\n', '  ) {\n', '    _tokenName = arts[_tokenId].name;\n', '    _price = tokenIdToPrice[_tokenId];\n', '    _nextPrice = nextPriceOf(_tokenId);\n', '    _owner = tokenIdToOwner[_tokenId];\n', '  }\n', '\n', '  function getAllTokens() public view returns (\n', '      uint256[],\n', '      uint256[],\n', '      address[]\n', '  ) {\n', '      uint256 total = totalSupply();\n', '      uint256[] memory prices = new uint256[](total);\n', '      uint256[] memory nextPrices = new uint256[](total);\n', '      address[] memory owners = new address[](total);\n', '\n', '      for (uint256 i = 0; i < total; i++) {\n', '          prices[i] = tokenIdToPrice[i];\n', '          nextPrices[i] = nextPriceOf(i);\n', '          owners[i] = tokenIdToOwner[i];\n', '      }\n', '\n', '      return (prices, nextPrices, owners);\n', '  }\n', '\n', '  function tokensOf(address _owner) public view returns(uint256[]) {\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 total = totalSupply();\n', '      uint256 resultIndex = 0;\n', '\n', '      for (uint256 i = 0; i < total; i++) {\n', '        if (tokenIdToOwner[i] == _owner) {\n', '          result[resultIndex] = i;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', "  /// @dev This function withdraws the contract owner's cut.\n", '  /// Any amount may be withdrawn as there is no user funds.\n', '  /// User funds are immediately sent to the old owner in `purchase`\n', '  function withdrawBalance(address _to, uint256 _amount) public onlyCEO {\n', '    require(_amount <= this.balance);\n', '\n', '    if (_amount == 0) {\n', '      _amount = this.balance;\n', '    }\n', '\n', '    if (_to == address(0)) {\n', '      ceoAddress.transfer(_amount);\n', '    } else {\n', '      _to.transfer(_amount);\n', '    }\n', '  }\n', '\n', '  // Send ether and obtain the token\n', '  function purchase(uint256 _tokenId) public payable whenNotPaused {\n', '    address oldOwner = ownerOf(_tokenId);\n', '    address newOwner = msg.sender;\n', '    uint256 sellingPrice = priceOf(_tokenId);\n', '\n', '    // active tokens\n', '    require(oldOwner != address(0));\n', "    // maybe one day newOwner's logic allows this to happen\n", '    require(newOwner != address(0));\n', "    // don't buy from yourself\n", '    require(oldOwner != newOwner);\n', "    // don't sell to contracts\n", "    // but even this doesn't prevent bad contracts to become an owner of a token\n", '    require(!_isContract(newOwner));\n', '    // another check to be sure that token is active\n', '    require(sellingPrice > 0);\n', '    // min required amount check\n', '    require(msg.value >= sellingPrice);\n', '\n', '    // transfer to the new owner\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '    // update fields before emitting an event\n', '    tokenIdToPrice[_tokenId] = nextPriceOf(_tokenId);\n', '    // emit event\n', '    TokenSold(_tokenId, arts[_tokenId].name, sellingPrice, priceOf(_tokenId), oldOwner, newOwner);\n', '\n', '    // extra ether which should be returned back to buyer\n', '    uint256 excess = msg.value.sub(sellingPrice);\n', "    // contract owner's cut which is left in contract and accesed by withdrawBalance\n", '    uint256 contractCut = sellingPrice.mul(6).div(100); // 6%\n', '\n', "    // no need to transfer if it's initial sell\n", '    if (oldOwner != address(this)) {\n', "      // transfer payment to seller minus the contract's cut\n", '      oldOwner.transfer(sellingPrice.sub(contractCut));\n', '    }\n', '\n', '    // return extra ether\n', '    if (excess > 0) {\n', '      newOwner.transfer(excess);\n', '    }\n', '  }\n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 _price) {\n', '    return tokenIdToPrice[_tokenId];\n', '  }\n', '\n', '  uint256 private increaseLimit1 = 0.05 ether;\n', '  uint256 private increaseLimit2 = 0.5 ether;\n', '  uint256 private increaseLimit3 = 5 ether;\n', '\n', '  function nextPriceOf(uint256 _tokenId) public view returns (uint256 _nextPrice) {\n', '    uint256 price = priceOf(_tokenId);\n', '    if (price < increaseLimit1) {\n', '      return price.mul(135).div(94);\n', '    } else if (price < increaseLimit2) {\n', '      return price.mul(120).div(94);\n', '    } else if (price < increaseLimit3) {\n', '      return price.mul(118).div(94);\n', '    } else {\n', '      return price.mul(116).div(94);\n', '    }\n', '  }\n', '\n', '\n', '  /*** ERC-721 ***/\n', '  // Unlocks ERC721 behaviour, allowing for trading on third party platforms.\n', '  function enableERC721() onlyCEO public {\n', '    erc721Enabled = true;\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256 _totalSupply) {\n', '    _totalSupply = arts.length;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 _balance) {\n', '    _balance = ownershipTokenCount[_owner];\n', '  }\n', '\n', '  function ownerOf(uint256 _tokenId) public view returns (address _owner) {\n', '    _owner = tokenIdToOwner[_tokenId];\n', '    // require(_owner != address(0));\n', '  }\n', '\n', '  function approve(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {\n', '    require(_owns(msg.sender, _tokenId));\n', '\n', '    tokenIdToApproved[_tokenId] = _to;\n', '\n', '    Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {\n', '    require(_to != address(0));\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(msg.sender, _tokenId));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  function transfer(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {\n', '      require(_to != address(0));\n', '      require(_owns(msg.sender, _tokenId));\n', '\n', '      // Reassign ownership, clear pending approvals, emit Transfer event.\n', '      _transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function implementsERC721() public view whenNotPaused returns (bool) {\n', '    return erc721Enabled;\n', '  }\n', '\n', '  function takeOwnership(uint256 _tokenId) public whenNotPaused onlyERC721 {\n', '    require(_approved(msg.sender, _tokenId));\n', '\n', '    _transfer(tokenIdToOwner[_tokenId], msg.sender, _tokenId);\n', '  }\n', '\n', '  function name() public view returns (string _name) {\n', '    _name = "CryptoArts";\n', '  }\n', '\n', '  function symbol() public view returns (string _symbol) {\n', '    _symbol = "XART";\n', '  }\n', '\n', '\n', '  /*** PRIVATES ***/\n', '  /// @dev Check for token ownership.\n', '  function _owns(address _claimant, uint256 _tokenId) private view returns (bool) {\n', '      return tokenIdToOwner[_tokenId] == _claimant;\n', '  }\n', '\n', '  /// @dev For checking approval of transfer for address _to.\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return tokenIdToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  /// @dev Assigns ownership of a specific token to an address.\n', '  function _transfer(address _from, address _to, uint256 _tokenId) private {\n', "    // Since the number of tokens is capped to 2^32 we can't overflow this\n", '    ownershipTokenCount[_to]++;\n', '    // Transfer ownership\n', '    tokenIdToOwner[_tokenId] = _to;\n', '\n', "    // When creating new token _from is 0x0, but we can't account that address.\n", '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete tokenIdToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    Transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  /// @dev Checks if the address ia a contract or not\n', '  function _isContract(address addr) private view returns (bool) {\n', '    uint256 size;\n', '    assembly { size := extcodesize(addr) }\n', '    return size > 0;\n', '  }\n', '}\n', '\n', '\n', '// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', '// v1.6.0\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
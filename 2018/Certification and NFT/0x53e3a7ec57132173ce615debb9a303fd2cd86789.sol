['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', '/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', '/// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)\n', 'contract ERC721 {\n', '  // Required methods\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '\n', '  // Optional\n', '  // function name() public view returns (string name);\n', '  // function symbol() public view returns (string symbol);\n', '  // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);\n', '  // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);\n', '}\n', '\n', '\n', 'contract CityToken is ERC721 {\n', '\n', '  /*** EVENTS ***/\n', '\n', '  /// @dev The CityCreated event is fired whenever a new city comes into existence.\n', '  event CityCreated(uint256 tokenId, string name, string country, address owner);\n', '\n', '  /// @dev The TokenSold event is fired whenever a token is sold.\n', '  event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name, string country);\n', '\n', '  /// @dev Transfer event as defined in current draft of ERC721. \n', '  ///  ownership is assigned, including create event.\n', '  event Transfer(address from, address to, uint256 tokenId);\n', '\n', '  /*** CONSTANTS ***/\n', '\n', '  /// @notice Name and symbol of the non fungible token, as defined in ERC721.\n', '  string public constant NAME = "CryptoCities"; // solhint-disable-line\n', '  string public constant SYMBOL = "CityToken"; // solhint-disable-line\n', '\n', '  uint256 private startingPrice = 0.05 ether;\n', '\n', '  uint256 private constant PROMO_CREATION_LIMIT = 5000;\n', '\n', '  /*** STORAGE ***/\n', '\n', '  /// @dev A mapping from city IDs to the address that owns them. All cities have\n', '  ///  some valid owner address.\n', '  mapping (uint256 => address) public cityIndexToOwner;\n', '\n', '  // @dev A mapping from owner address to count of tokens that address owns.\n', '  //  Used internally inside balanceOf() to resolve ownership count.\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '\n', '  /// @dev A mapping from CityIDs to an address that has been approved to call\n', '  ///  transferFrom(). Each City can only have one approved address for transfer\n', '  ///  at any time. A zero value means no approval is outstanding.\n', '  mapping (uint256 => address) public cityIndexToApproved;\n', '\n', '  // @dev A mapping from CityIDs to the price of the token.\n', '  mapping (uint256 => uint256) private cityIndexToPrice;\n', '\n', '  // The addresses of the accounts (or contracts) that can execute actions within each roles.\n', '  address public ceoAddress;\n', '  address public cooAddress;\n', '\n', '  uint256 public promoCreatedCount;\n', '\n', '  /*** DATATYPES ***/\n', '  struct City {\n', '    string name;\n', '    string country;\n', '  }\n', '\n', '  City[] private cities;\n', '\n', '  /*** ACCESS MODIFIERS ***/\n', '  /// @dev Access modifier for CEO-only functionality\n', '  modifier onlyCEO() {\n', '    require(msg.sender == ceoAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Access modifier for COO-only functionality\n', '  modifier onlyCOO() {\n', '    require(msg.sender == cooAddress);\n', '    _;\n', '  }\n', '\n', '  /// Access modifier for contract owner only functionality\n', '  modifier onlyCLevel() {\n', '    require(\n', '      msg.sender == ceoAddress ||\n', '      msg.sender == cooAddress\n', '    );\n', '    _;\n', '  }\n', '\n', '  /*** CONSTRUCTOR ***/\n', '  function CityToken() public {\n', '    ceoAddress = msg.sender;\n', '    cooAddress = msg.sender;\n', '  }\n', '\n', '  /*** PUBLIC FUNCTIONS ***/\n', '  /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().\n', '  /// @param _to The address to be granted transfer approval. Pass address(0) to\n', '  ///  clear all approvals.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function approve(\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public {\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '\n', '    cityIndexToApproved[_tokenId] = _to;\n', '\n', '    Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  /// For querying balance of a particular account\n', '  /// @param _owner The address for balance query\n', '  /// @dev Required for ERC-721 compliance.\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '  /// @dev Creates a new promo City with the given name, country and price and assignes it to an address.\n', '  function createPromoCity(address _owner, string _name, string _country, uint256 _price) public onlyCOO {\n', '    require(promoCreatedCount < PROMO_CREATION_LIMIT);\n', '\n', '    address cityOwner = _owner;\n', '    if (cityOwner == address(0)) {\n', '      cityOwner = cooAddress;\n', '    }\n', '    \n', '    if (_price <= 0) {\n', '      _price = startingPrice;\n', '    }\n', '\n', '    promoCreatedCount++;\n', '    _createCity(_name, _country, cityOwner, _price);\n', '  }\n', '\n', '  /// @dev Creates a new City with the given name and country.\n', '  function createContractCity(string _name, string _country) public onlyCOO {\n', '    _createCity(_name, _country, address(this), startingPrice);\n', '  }\n', '\n', '  /// @notice Returns all the relevant information about a specific city.\n', '  /// @param _tokenId The tokenId of the city of interest.\n', '  function getCity(uint256 _tokenId) public view returns (\n', '    string cityName,\n', '    string country,\n', '    uint256 sellingPrice,\n', '    address owner\n', '  ) {\n', '    City storage city = cities[_tokenId];\n', '    cityName = city.name;\n', '    country = city.country;\n', '    sellingPrice = cityIndexToPrice[_tokenId];\n', '    owner = cityIndexToOwner[_tokenId];\n', '  }\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /// @dev Required for ERC-721 compliance.\n', '  function name() public pure returns (string) {\n', '    return NAME;\n', '  }\n', '\n', '  /// For querying owner of token\n', '  /// @param _tokenId The tokenID for owner inquiry\n', '  /// @dev Required for ERC-721 compliance.\n', '  function ownerOf(uint256 _tokenId)\n', '    public\n', '    view\n', '    returns (address owner)\n', '  {\n', '    owner = cityIndexToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '\n', '  function payout(address _to) public onlyCLevel {\n', '    _payout(_to);\n', '  }\n', '\n', '  // Allows someone to send ether and obtain the token\n', '  function purchase(uint256 _tokenId) public payable {\n', '    address oldOwner = cityIndexToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '\n', '    uint256 sellingPrice = cityIndexToPrice[_tokenId];\n', '\n', '    // Making sure token owner is not sending to self\n', '    require(oldOwner != newOwner);\n', '\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '\n', '    // Making sure sent amount is greater than or equal to the sellingPrice\n', '    require(msg.value >= sellingPrice);\n', '\n', '    uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));\n', '    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);\n', '\n', '    // Update price (20% increase)\n', '    cityIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);\n', '    \n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '    // Pay previous tokenOwner if owner is not contract\n', '    if (oldOwner != address(this)) {\n', '      oldOwner.transfer(payment); //(1-0.10)\n', '    }\n', '\n', '    TokenSold(_tokenId, sellingPrice, cityIndexToPrice[_tokenId], oldOwner, newOwner, cities[_tokenId].name, cities[_tokenId].country);\n', '\n', '    msg.sender.transfer(purchaseExcess);\n', '  }\n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '    return cityIndexToPrice[_tokenId];\n', '  }\n', '\n', '  /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.\n', '  /// @param _newCEO The address of the new CEO\n', '  function setCEO(address _newCEO) public onlyCEO {\n', '    require(_newCEO != address(0));\n', '\n', '    ceoAddress = _newCEO;\n', '  }\n', '\n', '  /// @dev Assigns a new address to act as the COO. Only available to the current COO.\n', '  /// @param _newCOO The address of the new COO\n', '  function setCOO(address _newCOO) public onlyCEO {\n', '    require(_newCOO != address(0));\n', '\n', '    cooAddress = _newCOO;\n', '  }\n', '\n', '  /// @dev Required for ERC-721 compliance.\n', '  function symbol() public pure returns (string) {\n', '    return SYMBOL;\n', '  }\n', '\n', '  /// @notice Allow pre-approved user to take ownership of a token\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function takeOwnership(uint256 _tokenId) public {\n', '    address newOwner = msg.sender;\n', '    address oldOwner = cityIndexToOwner[_tokenId];\n', '\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '\n', '    // Making sure transfer is approved\n', '    require(_approved(newOwner, _tokenId));\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '\n', '  /// @param _owner The owner whose city tokens we are interested in.\n', "  /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly\n", '  ///  expensive (it walks the entire Cities array looking for cities belonging to owner),\n', '  ///  but it also returns a dynamic array, which is only supported for web3 calls, and\n', '  ///  not contract-to-contract calls.\n', '  function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalCities = totalSupply();\n', '      uint256 resultIndex = 0;\n', '\n', '      uint256 cityId;\n', '      for (cityId = 0; cityId <= totalCities; cityId++) {\n', '        if (cityIndexToOwner[cityId] == _owner) {\n', '          result[resultIndex] = cityId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', '  /// For querying totalSupply of token\n', '  /// @dev Required for ERC-721 compliance.\n', '  function totalSupply() public view returns (uint256 total) {\n', '    return cities.length;\n', '  }\n', '\n', '  /// Owner initates the transfer of the token to another account\n', '  /// @param _to The address for the token to be transferred to.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function transfer(\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public {\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  /// Third-party initiates transfer of token from address _from to address _to\n', '  /// @param _from The address for the token to be transferred from.\n', '  /// @param _to The address for the token to be transferred to.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public {\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  /*** PRIVATE FUNCTIONS ***/\n', '  /// Safety check on _to address to prevent against an unexpected 0x0 default.\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '\n', '  /// For checking approval of transfer for address _to\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return cityIndexToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  /// For creating City\n', '  function _createCity(string _name, string _country, address _owner, uint256 _price) private {\n', '    City memory _city = City({\n', '      name: _name,\n', '      country: _country\n', '    });\n', '    uint256 newCityId = cities.push(_city) - 1;\n', '\n', "    // It's probably never going to happen, 4 billion tokens are A LOT, but\n", "    // let's just be 100% sure we never let this happen.\n", '    require(newCityId == uint256(uint32(newCityId)));\n', '\n', '    CityCreated(newCityId, _name, _country, _owner);\n', '\n', '    cityIndexToPrice[newCityId] = _price;\n', '\n', '    // This will assign ownership, and also emit the Transfer event as\n', '    // per ERC721 draft\n', '    _transfer(address(0), _owner, newCityId);\n', '  }\n', '\n', '  /// Check for token ownership\n', '  function _owns(address claimant, uint256 _tokenId) private view returns (bool) {\n', '    return claimant == cityIndexToOwner[_tokenId];\n', '  }\n', '\n', '  /// For paying out balance on contract\n', '  function _payout(address _to) private {\n', '    if (_to == address(0)) {\n', '      ceoAddress.transfer(this.balance);\n', '    } else {\n', '      _to.transfer(this.balance);\n', '    }\n', '  }\n', '\n', '  /// @dev Assigns ownership of a specific City to an address.\n', '  function _transfer(address _from, address _to, uint256 _tokenId) private {\n', "    // Since the number of cities is capped to 2^32 we can't overflow this\n", '    ownershipTokenCount[_to]++;\n', '    //transfer ownership\n', '    cityIndexToOwner[_tokenId] = _to;\n', '\n', "    // When creating new cities _from is 0x0, but we can't account that address.\n", '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete cityIndexToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    Transfer(_from, _to, _tokenId);\n', '  }\n', '}\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
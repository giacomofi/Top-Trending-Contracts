['pragma solidity ^0.4.20; // solhint-disable-line\n', '\n', '/// @title A standard interface for non-fungible tokens.\n', '/// @author Dieter Shirley <dete@axiomzen.co>\n', 'contract ERC721 {\n', '  // Required methods\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '}\n', '\n', '/// @title ViralLo.vin, Creator token smart contract\n', '/// @author Sam Morris <hi@sam.viralo.vin>\n', 'contract ViralLovinCreatorToken is ERC721 {\n', '\n', '  /*** EVENTS ***/\n', '\n', '  /// @dev The Birth event is fired whenever a new Creator is created\n', '  event Birth(\n', '      uint256 tokenId, \n', '      string name, \n', '      address owner, \n', '      uint256 collectiblesOrdered\n', '    );\n', '\n', '  /// @dev The TokenSold event is fired whenever a token is sold.\n', '  event TokenSold(\n', '      uint256 tokenId, \n', '      uint256 oldPrice, \n', '      uint256 newPrice, \n', '      address prevOwner, \n', '      address winner, \n', '      string name, \n', '      uint256 collectiblesOrdered\n', '    );\n', '\n', '  /// @dev Transfer event as defined in current draft of ERC721. \n', '  ///  ownership is assigned, including births.\n', '  event Transfer(address from, address to, uint256 tokenId);\n', '\n', '  /*** CONSTANTS ***/\n', '\n', '  /// @notice Name and symbol of the non fungible token, as defined in ERC721.\n', '  string public constant NAME = "ViralLovin Creator Token"; // solhint-disable-line\n', '  string public constant SYMBOL = "CREATOR"; // solhint-disable-line\n', '\n', '  uint256 private startingPrice = 0.001 ether;\n', '\n', '  /*** STORAGE ***/\n', '\n', '  /// @dev A mapping from Creator IDs to the address that owns them. \n', '  /// All Creators have some valid owner address.\n', '  mapping (uint256 => address) public creatorIndexToOwner;\n', '\n', '  /// @dev A mapping from owner address to count of tokens that address owns.\n', '  //  Used internally inside balanceOf() to resolve ownership count.\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '\n', '  /// @dev A mapping from Creator IDs to an address that has been approved to call\n', '  ///  transferFrom(). Each Creator can only have one approved address for transfer\n', '  ///  at any time. A zero value means no approval is outstanding.\n', '  mapping (uint256 => address) public creatorIndexToApproved;\n', '\n', '  // @dev A mapping from creator IDs to the price of the token.\n', '  mapping (uint256 => uint256) private creatorIndexToPrice;\n', '\n', '  // The addresses that can execute actions within each roles.\n', '  address public ceoAddress;\n', '  address public cooAddress;\n', '\n', '  uint256 public creatorsCreatedCount;\n', '\n', '  /*** DATATYPES ***/\n', '  struct Creator {\n', '    string name;\n', '    uint256 collectiblesOrdered;\n', '  }\n', '\n', '  Creator[] private creators;\n', '\n', '  /*** ACCESS MODIFIERS ***/\n', '  \n', '  /// @dev Access modifier for CEO-only functionality\n', '  modifier onlyCEO() {\n', '    require(msg.sender == ceoAddress);\n', '    _;\n', '  }\n', '\n', '  /// @dev Access modifier for COO-only functionality\n', '  modifier onlyCOO() {\n', '    require(msg.sender == cooAddress);\n', '    _;\n', '  }\n', '\n', '  /// Access modifier for contract owner only functionality\n', '  modifier onlyCLevel() {\n', '    require(\n', '      msg.sender == ceoAddress ||\n', '      msg.sender == cooAddress\n', '    );\n', '    _;\n', '  }\n', '\n', '  /*** CONSTRUCTOR ***/\n', '  \n', '  function ViralLovinCreatorToken() public {\n', '    ceoAddress = msg.sender;\n', '    cooAddress = msg.sender;\n', '  }\n', '\n', '  /*** PUBLIC FUNCTIONS ***/\n', '  \n', '  /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().\n', '  /// @param _to The address to be granted transfer approval. Pass address(0) to clear all approvals.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function approve(address _to, uint256 _tokenId) public {\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '    creatorIndexToApproved[_tokenId] = _to;\n', '    Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  /// For querying balance of a particular account\n', '  /// @param _owner The address for balance query\n', '  /// @dev Required for ERC-721 compliance.\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '  /// @dev Creates a new Creator with the given name, price, and the total number of collectibles ordered then assigns to an address.\n', '  function createCreator(\n', '      address _owner, \n', '      string _name, \n', '      uint256 _price, \n', '      uint256 _collectiblesOrdered\n', '    ) public onlyCOO {\n', '    address creatorOwner = _owner;\n', '    if (creatorOwner == address(0)) {\n', '      creatorOwner = cooAddress;\n', '    }\n', '\n', '    if (_price <= 0) {\n', '      _price = startingPrice;\n', '    }\n', '\n', '    creatorsCreatedCount++;\n', '    _createCreator(_name, creatorOwner, _price, _collectiblesOrdered);\n', '    }\n', '\n', '  /// @notice Returns all the information about Creator token.\n', '  /// @param _tokenId The tokenId of the Creator token.\n', '  function getCreator(\n', '      uint256 _tokenId\n', '    ) public view returns (\n', '        string creatorName, \n', '        uint256 sellingPrice, \n', '        address owner, \n', '        uint256 collectiblesOrdered\n', '    ) {\n', '    Creator storage creator = creators[_tokenId];\n', '    creatorName = creator.name;\n', '    collectiblesOrdered = creator.collectiblesOrdered;\n', '    sellingPrice = creatorIndexToPrice[_tokenId];\n', '    owner = creatorIndexToOwner[_tokenId];\n', '  }\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /// @dev For ERC-721 compliance.\n', '  function name() public pure returns (string) {\n', '    return NAME;\n', '  }\n', '\n', '  /// For querying owner of a token\n', '  /// @param _tokenId The tokenID\n', '  /// @dev Required for ERC-721 compliance.\n', '  function ownerOf(uint256 _tokenId) public view returns (address owner)\n', '  {\n', '    owner = creatorIndexToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '\n', '  /// For contract payout\n', '  function payout(address _to) public onlyCLevel {\n', '    require(_addressNotNull(_to));\n', '    _payout(_to);\n', '  }\n', '\n', '  /// Allows someone to obtain the token\n', '  function purchase(uint256 _tokenId) public payable {\n', '    address oldOwner = creatorIndexToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '    uint256 sellingPrice = creatorIndexToPrice[_tokenId];\n', '\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '\n', '    // Making sure sent amount is greater than or equal to the sellingPrice\n', '    require(msg.value >= sellingPrice);\n', '\n', '    // Transfer contract to new owner\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '    // Transfer payment to VL\n', '    ceoAddress.transfer(sellingPrice);\n', '\n', '    // Emits TokenSold event\n', '    TokenSold(\n', '        _tokenId, \n', '        sellingPrice, \n', '        creatorIndexToPrice[_tokenId], \n', '        oldOwner, \n', '        newOwner, \n', '        creators[_tokenId].name, \n', '        creators[_tokenId].collectiblesOrdered\n', '    );\n', '  }\n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '    return creatorIndexToPrice[_tokenId];\n', '  }\n', '\n', '  /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.\n', '  /// @param _newCEO The address of the new CEO\n', '  function setCEO(address _newCEO) public onlyCEO {\n', '    require(_newCEO != address(0));\n', '    ceoAddress = _newCEO;\n', '  }\n', '\n', '  /// @dev Assigns a new address to act as the COO. Only available to the current CEO.\n', '  /// @param _newCOO The address of the new COO\n', '  function setCOO(address _newCOO) public onlyCEO {\n', '    require(_newCOO != address(0));\n', '    cooAddress = _newCOO;\n', '  }\n', '\n', '  /// @dev For ERC-721 compliance.\n', '  function symbol() public pure returns (string) {\n', '    return SYMBOL;\n', '  }\n', '\n', '  /// @notice Allow pre-approved user to take ownership of a token\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function takeOwnership(uint256 _tokenId) public {\n', '    address newOwner = msg.sender;\n', '    address oldOwner = creatorIndexToOwner[_tokenId];\n', '\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '\n', '    // Making sure transfer is approved\n', '    require(_approved(newOwner, _tokenId));\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '\n', '  /// @param _owner Creator tokens belonging to the owner.\n', '  /// @dev Expensive; not to be called by smart contract. Walks the collectibes array looking for Creator tokens belonging to owner.\n', '  function tokensOfOwner(\n', '      address _owner\n', '      ) public view returns(uint256[] ownerTokens) {\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalCreators = totalSupply();\n', '      uint256 resultIndex = 0;\n', '      uint256 creatorId;\n', '      for (creatorId = 0; creatorId <= totalCreators; creatorId++) {\n', '        if (creatorIndexToOwner[creatorId] == _owner) {\n', '          result[resultIndex] = creatorId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', '  /// For querying totalSupply of token\n', '  /// @dev Required for ERC-721 compliance.\n', '  function totalSupply() public view returns (uint256 total) {\n', '    return creators.length;\n', '  }\n', '\n', '  /// Owner initates the transfer of the token to another account\n', '  /// @param _to The address for the token to be transferred to.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function transfer(address _to, uint256 _tokenId) public {\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '    _transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  /// Initiates transfer of token from address _from to address _to\n', '  /// @param _from The address for the token to be transferred from.\n', '  /// @param _to The address for the token to be transferred to.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public {\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  /*** PRIVATE FUNCTIONS ***/\n', '  \n', '  /// Safety check on _to address to prevent against an unexpected 0x0 default.\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '\n', '  /// For checking approval of transfer for address _to\n', '  function _approved(\n', '      address _to, \n', '      uint256 _tokenId\n', '      ) private view returns (bool) {\n', '    return creatorIndexToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  /// For creating a Creator\n', '  function _createCreator(\n', '      string _name, \n', '      address _owner, \n', '      uint256 _price, \n', '      uint256 _collectiblesOrdered\n', '      ) private {\n', '    Creator memory _creator = Creator({\n', '      name: _name,\n', '      collectiblesOrdered: _collectiblesOrdered\n', '    });\n', '    uint256 newCreatorId = creators.push(_creator) - 1;\n', '\n', '    require(newCreatorId == uint256(uint32(newCreatorId)));\n', '\n', '    Birth(newCreatorId, _name, _owner, _collectiblesOrdered);\n', '\n', '    creatorIndexToPrice[newCreatorId] = _price;\n', '\n', '    // This will assign ownership, and also emit the Transfer event as per ERC721 draft\n', '    _transfer(address(0), _owner, newCreatorId);\n', '  }\n', '\n', '  /// Check for token ownership\n', '  function _owns(\n', '      address claimant, \n', '      uint256 _tokenId\n', '      ) private view returns (bool) {\n', '    return claimant == creatorIndexToOwner[_tokenId];\n', '  }\n', '\n', '  /// For paying out the full balance of contract\n', '  function _payout(address _to) private {\n', '    if (_to == address(0)) {\n', '      ceoAddress.transfer(this.balance);\n', '    } else {\n', '      _to.transfer(this.balance);\n', '    }\n', '  }\n', '\n', '  /// @dev Assigns ownership of Creator token to an address.\n', '  function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '    // increment owner token count\n', '    ownershipTokenCount[_to]++;\n', '    // transfer ownership\n', '    creatorIndexToOwner[_tokenId] = _to;\n', '\n', "    // When creating new creators _from is 0x0, we can't account that address.\n", '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership\n', '      delete creatorIndexToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    Transfer(_from, _to, _tokenId);\n', '  }\n', '  \n', '}']
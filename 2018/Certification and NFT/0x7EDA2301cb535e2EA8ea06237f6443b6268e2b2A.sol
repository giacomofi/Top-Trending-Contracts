['//EA 0x7EDA2301cb535e2EA8ea06237f6443b6268e2b2A  ETH Main net\n', '\n', '\n', 'pragma solidity ^0.4.25; // solhint-disable-line\n', '/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', 'contract ERC721 {\n', '  // Required methods\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public view returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '\n', '  // Optional\n', '  // function name() public view returns (string name);\n', '  // function symbol() public view returns (string symbol);\n', '  // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);\n', '  // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);\n', '}\n', '\n', '\n', '//********************************************************************\n', '\n', '\n', 'contract CharToken is ERC721 {\n', '  /*** EVENTS ***/\n', '  /// @dev The Birth event is fired whenever a new char comes into existence.\n', '  event Birth(uint256 tokenId, string wikiID_Name, address owner);\n', '  /// @dev The TokenSold event is fired whenever a token is sold.\n', '  event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address newOwner, string wikiID_Name);\n', '  /// @dev Transfer event as defined in current draft of ERC721.\n', '  ///  ownership is assigned, including births.\n', '  event Transfer(address from, address to, uint256 tokenId);\n', '  /// @dev Emitted when a bug is found int the contract and the contract is upgraded at a new address.\n', '  /// In the event this happens, the current contract is paused indefinitely\n', '  event ContractUpgrade(address newContract);\n', '  ///bonus issuance    \n', '  event Bonus(address to, uint256 bonus);\n', '\n', '  /*** CONSTANTS ***/\n', '  /// @notice Name and symbol of the non fungible token, as defined in ERC721.\n', '  string public constant NAME = "CryptoChars"; // solhint-disable-line\n', '  string public constant SYMBOL = "CHARS"; // solhint-disable-line\n', '  bool private erc721Enabled = false;\n', '  uint256 private startingPrice = 0.005 ether;\n', '  uint256 private constant PROMO_CREATION_LIMIT = 50000;\n', '  uint256 private firstStepLimit =  0.05 ether;\n', '  uint256 private secondStepLimit = 0.20 ether;\n', '  uint256 private thirdStepLimit = 0.5 ether;\n', '\n', '  /*** STORAGE ***/\n', '  /// @dev A mapping from char IDs to the address that owns them. All chars have\n', '  ///  some valid owner address.\n', '  mapping (uint256 => address) public charIndexToOwner;\n', ' // @dev A mapping from owner address to count of tokens that address owns.\n', '  //  Used internally inside balanceOf() to resolve ownership count.\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '  /// @dev A mapping from CharIDs to an address that has been approved to call\n', '  ///  transferFrom(). Each Char can only have one approved address for transfer\n', '  ///  at any time. A zero value means no approval is outstanding.\n', '  mapping (uint256 => address) public charIndexToApproved;\n', '  // @dev A mapping from CharIDs to the price of the token.\n', '  mapping (uint256 => uint256) private charIndexToPrice;\n', '  // @dev A mapping from owner address to its total number of transactions\n', '  mapping (address => uint256) private addressToTrxCount;\n', '  // The addresses of the accounts (or contracts) that can execute actions within each roles.\n', '  address public ceoAddress;\n', '  address public cooAddress;\n', '  address public cfoAddress;\n', '  uint256 public promoCreatedCount;\n', '  //***pack below into a struct for gas optimization    \n', '  //promo per each N trx is effective until date, and its frequency (every nth buy)\n', '  uint256 public bonusUntilDate;   \n', '  uint256 bonusFrequency;\n', '  /*** DATATYPES ***/\n', '  struct Char {\n', '    //name of the char\n', '    //string name;\n', '    //wiki pageid of char\n', '    string wikiID_Name; //save gas\n', '  }\n', '  Char[] private chars; \n', '\n', '  /*** ACCESS MODIFIERS ***/\n', '  /// @dev Access modifier for CEO-only functionality\n', '  modifier onlyCEO() {\n', '    require(msg.sender == ceoAddress);\n', '    _;\n', '  }\n', '  /// @dev Access modifier for COO-only functionality\n', '  modifier onlyCOO() {\n', '    require(msg.sender == cooAddress);\n', '    _;\n', '  }\n', '  /// @dev Access modifier for CFO-only functionality\n', '  modifier onlyCFO() {\n', '    require(msg.sender == cfoAddress);\n', '    _;\n', '  }\n', '  modifier onlyERC721() {\n', '    require(erc721Enabled);\n', '    _;\n', '  }\n', '  /// Access modifier for contract owner only functionality\n', '  modifier onlyCLevel() {\n', '    require(\n', '      msg.sender == ceoAddress ||\n', '      msg.sender == cooAddress ||\n', '      msg.sender == cfoAddress \n', '    );\n', '    _;\n', '  }\n', '  /*** CONSTRUCTOR ***/\n', '  constructor() public {\n', '    ceoAddress = msg.sender;\n', '    cooAddress = msg.sender;\n', '    cfoAddress = msg.sender;\n', '    bonusUntilDate = now; //Bonus after Nth buy is valid until this date\n', '    bonusFrequency = 3; //Bonus distributed after every Nth buy\n', '    \n', '    //create genesis chars\n', '    createContractChar("42268616_Captain Ahab",0);\n', '    createContractChar("455401_Frankenstein",0);\n', '    createContractChar("8670724_Dracula",0);\n', '    createContractChar("27159_Sherlock Holmes",0);\n', '    createContractChar("160108_Snow White",0);\n', '    createContractChar("73453_Cinderella",0);\n', '    createContractChar("14966133_Pinocchio",0);\n', '    createContractChar("369427_Lemuel Gulliver",0);\n', '    createContractChar("26171_Robin Hood",0);\n', '    createContractChar("197889_Felix the Cat",0);\n', '    createContractChar("382164_Wizard of Oz",0);\n', '    createContractChar("62446_Alice",0);\n', '    createContractChar("8237_Don Quixote",0);\n', '    createContractChar("16808_King Arthur",0);\n', '    createContractChar("194085_Sleeping Beauty",0);\n', '    createContractChar("299250_Little Red Riding Hood",0);\n', '    createContractChar("166604_Aladdin",0);\n', '    createContractChar("7640956_Peter Pan",0);\n', '    createContractChar("927344_Ali Baba",0);\n', '    createContractChar("153957_Lancelot",0);\n', '    createContractChar("235918_Dr._Jekyll_and_Mr._Hyde",0);\n', '    createContractChar("157787_Captain_Nemo",0);\n', '    createContractChar("933085_Moby_Dick",0);\n', '    createContractChar("54246379_Dorian_Gray",0);\n', '    createContractChar("55483_Robinson_Crusoe",0);\n', '    createContractChar("380143_Black_Beauty",0);\n', '    createContractChar("6364074_Phantom_of_the_Opera",0); \n', '    createContractChar("15055_Ivanhoe",0);\n', '    createContractChar("21491685_Tarzan",0);\n', '    /* */    \n', '  }\n', '\n', '  /*** PUBLIC FUNCTIONS ***/\n', '  /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().\n', '  /// @param _to The address to be granted transfer approval. Pass address(0) to\n', '  ///  clear all approvals.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function approve(\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public onlyERC721 {\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '\n', '    charIndexToApproved[_tokenId] = _to;\n', '\n', '    emit Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  /// For querying balance of a particular account\n', '  /// @param _owner The address for balance query\n', '  /// @dev Required for ERC-721 compliance.\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '\n', '  /// @dev Creates a new Char with the given name\n', '  function createContractChar(string _wikiID_Name, uint256 _price) public onlyCLevel {\n', '    require(promoCreatedCount < PROMO_CREATION_LIMIT);\n', '    if (_price <= 0) {\n', '      _price = startingPrice;\n', '    }\n', '    promoCreatedCount++;\n', '    _createChar(_wikiID_Name, address(this), _price);\n', '  }\n', '  /// @notice Returns all the relevant information about a specific char.\n', '  /// @param _tokenId The tokenId of the char of interest.\n', '  function getChar(uint256 _tokenId) public view returns (\n', '    string wikiID_Name,\n', '    uint256 sellingPrice,\n', '    address owner\n', '  ) {\n', '    Char storage char = chars[_tokenId];\n', '    wikiID_Name = char.wikiID_Name;\n', '    sellingPrice = charIndexToPrice[_tokenId];\n', '    owner = charIndexToOwner[_tokenId];\n', '  }\n', '  function changeWikiID_Name(uint256 _tokenId, string _wikiID_Name) public onlyCLevel {\n', '    require(_tokenId < chars.length);\n', '    chars[_tokenId].wikiID_Name = _wikiID_Name;\n', '  }\n', '  function changeBonusUntilDate(uint32 _days) public onlyCLevel {\n', '       bonusUntilDate = now + (_days * 1 days);\n', '  }\n', '  function changeBonusFrequency(uint32 _n) public onlyCLevel {\n', '       bonusFrequency = _n;\n', '  }\n', '  function overrideCharPrice(uint256 _tokenId, uint256 _price) public onlyCLevel {\n', '    require(_price != charIndexToPrice[_tokenId]);\n', '    require(_tokenId < chars.length);\n', '    //C level can override price for only own and contract tokens\n', '    require((_owns(address(this), _tokenId)) || (  _owns(msg.sender, _tokenId)) ); \n', '    charIndexToPrice[_tokenId] = _price;\n', '  }\n', '  function changeCharPrice(uint256 _tokenId, uint256 _price) public {\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_tokenId < chars.length);\n', '    require(_price != charIndexToPrice[_tokenId]);\n', '    //require(_price > charIndexToPrice[_tokenId]);  //EA>should we enforce this?\n', '    uint256 maxPrice = SafeMath.div(SafeMath.mul(charIndexToPrice[_tokenId], 1000),100); //10x \n', '    uint256 minPrice = SafeMath.div(SafeMath.mul(charIndexToPrice[_tokenId], 50),100); //half price\n', '    require(_price >= minPrice); \n', '    require(_price <= maxPrice); \n', '    charIndexToPrice[_tokenId] = _price; \n', '  }\n', '  /* ERC721 */\n', '  function implementsERC721() public view returns (bool _implements) {\n', '    return erc721Enabled;\n', '  }\n', '  /// @dev Required for ERC-721 compliance.\n', '  function name() public pure returns (string) {\n', '    return NAME;\n', '  }\n', '  /// @dev Required for ERC-721 compliance.\n', '  function symbol() public pure returns (string) {\n', '    return SYMBOL;\n', '  }\n', '  /// For querying owner of token\n', '  /// @param _tokenId The tokenID for owner inquiry\n', '  /// @dev Required for ERC-721 compliance.\n', '  function ownerOf(uint256 _tokenId)\n', '    public\n', '    view\n', '    returns (address owner)\n', '  {\n', '    owner = charIndexToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '//  function payout(address _to) public onlyCLevel {\n', '//    _payout(_to);\n', '//  }\n', '  function withdrawFunds(address _to, uint256 amount) public onlyCLevel {\n', '    _withdrawFunds(_to, amount);\n', '  }\n', '  // Allows someone to send ether and obtain the token\n', '  function purchase(uint256 _tokenId, uint256 newPrice) public payable {\n', '    address oldOwner = charIndexToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '    uint256 sellingPrice = charIndexToPrice[_tokenId];\n', '    // Making sure token owner is not sending to self\n', '    require(oldOwner != newOwner);\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '    // Making sure sent amount is greater than or equal to the sellingPrice\n', '    require(msg.value >= sellingPrice);\n', '    uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));\n', '    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);\n', '    // Update prices\n', '    if (newPrice >= sellingPrice) charIndexToPrice[_tokenId] = newPrice;\n', '    else {\n', '            if (sellingPrice < firstStepLimit) {\n', '              // first stage\n', '              charIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 100);\n', '            } else if (sellingPrice < secondStepLimit) {\n', '              // second stage\n', '              charIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);\n', '            } else if (sellingPrice < thirdStepLimit) {\n', '              // second stage\n', '              charIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 100);\n', '            } else {\n', '              // third stage\n', '              charIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 100);\n', '            }\n', '    }\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '    // Pay previous tokenOwner if owner is not contract\n', '    if (oldOwner != address(this)) {\n', '      oldOwner.transfer(payment); //(1-0.06)\n', '    }\n', '    emit TokenSold(_tokenId, sellingPrice, charIndexToPrice[_tokenId], oldOwner, newOwner,\n', '      chars[_tokenId].wikiID_Name);\n', '    msg.sender.transfer(purchaseExcess);\n', '    //distribute bonus if earned and promo is ongoing and every nth buy trx\n', '      if( (now < bonusUntilDate && (addressToTrxCount[newOwner] % bonusFrequency) == 0) ) \n', '      {\n', '          //bonus operation here\n', '          uint rand = uint (keccak256(now)) % 50 ; //***earn up to 50% of 6% commissions\n', '          rand = rand * (sellingPrice-payment);  //***replace later. this is for test\n', '          _withdrawFunds(newOwner,rand);\n', '          emit Bonus(newOwner,rand);\n', '      }\n', '  }\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '    return charIndexToPrice[_tokenId];\n', '  }\n', '  // Unlocks ERC721 behaviour, allowing for trading on third party platforms.\n', '  function enableERC721() public onlyCEO {\n', '    erc721Enabled = true;\n', '  }\n', '  /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.\n', '  /// @param _newCEO The address of the new CEO\n', '  function setCEO(address _newCEO) public onlyCEO {\n', '    require(_newCEO != address(0));\n', '    ceoAddress = _newCEO;\n', '  }\n', '  /// @dev Assigns a new address to act as the COO. Only available to the current COO.\n', '  /// @param _newCOO The address of the new COO\n', '  function setCOO(address _newCOO) public onlyCOO {\n', '    require(_newCOO != address(0));\n', '    cooAddress = _newCOO;\n', '  }\n', '/// @dev Assigns a new address to act as the CFO. Only available to the current CFO.\n', '  /// @param _newCFO The address of the new CFO\n', '  function setCFO(address _newCFO) public onlyCFO {\n', '    require(_newCFO != address(0));\n', '    cfoAddress = _newCFO;\n', '  }\n', '  \n', '  \n', '  /// @notice Allow pre-approved user to take ownership of a token\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function takeOwnership(uint256 _tokenId) public {\n', '    address newOwner = msg.sender;\n', '    address oldOwner = charIndexToOwner[_tokenId];\n', '     // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '    // Making sure transfer is approved\n', '    require(_approved(newOwner, _tokenId));\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '  /// @param _owner The owner whose char tokens we are interested in.\n', '  /// @dev This method MUST NEVER be called by smart contract code. First, it&#39;s fairly\n', '  ///  expensive (it walks the entire Chars array looking for chars belonging to owner),\n', '  ///  but it also returns a dynamic array, which is only supported for web3 calls, and\n', '  ///  not contract-to-contract calls.\n', '  function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalChars = chars.length;\n', '      uint256 resultIndex = 0;\n', '      uint256 t;\n', '      for (t = 0; t <= totalChars; t++) {\n', '        if (charIndexToOwner[t] == _owner) {\n', '          result[resultIndex] = t;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '  /// For querying totalSupply of token\n', '  /// @dev Required for ERC-721 compliance.\n', '  function totalSupply() public view returns (uint256 total) {\n', '    return chars.length;\n', '  }\n', '  /// Owner initates the transfer of the token to another account\n', '  /// @param _to The address for the token to be transferred to.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function transfer(\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public onlyERC721 {\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '    _transfer(msg.sender, _to, _tokenId);\n', '  }\n', '  /// Third-party initiates transfer of token from address _from to address _to\n', '  /// @param _from The address for the token to be transferred from.\n', '  /// @param _to The address for the token to be transferred to.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public onlyERC721 {\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '  /*** PRIVATE FUNCTIONS ***/\n', '  /// Safety check on _to address to prevent against an unexpected 0x0 default.\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '  /// For checking approval of transfer for address _to\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return charIndexToApproved[_tokenId] == _to;\n', '  }\n', '  /// For creating Char\n', '  function _createChar(string _wikiID_Name, address _owner, uint256 _price) private {\n', '    Char memory _char = Char({\n', '      wikiID_Name: _wikiID_Name\n', '    });\n', '    uint256 newCharId = chars.push(_char) - 1;\n', '    // It&#39;s probably never going to happen, 4 billion tokens are A LOT, but\n', '    // let&#39;s just be 100% sure we never let this happen.\n', '    require(newCharId == uint256(uint32(newCharId)));\n', '    emit Birth(newCharId, _wikiID_Name, _owner);\n', '    charIndexToPrice[newCharId] = _price;\n', '    // This will assign ownership, and also emit the Transfer event as\n', '    // per ERC721 draft\n', '    _transfer(address(0), _owner, newCharId);\n', '  }\n', '  /// Check for token ownership\n', '  function _owns(address claimant, uint256 _tokenId) private view returns (bool) {\n', '    return claimant == charIndexToOwner[_tokenId];\n', '  }\n', '  /// For paying out balance on contract\n', '//  function _payout(address _to) private {\n', '//    if (_to == address(0)) {\n', '//      ceoAddress.transfer(address(this).balance);\n', '//    } else {\n', '//      _to.transfer(address(this).balance);\n', '//    }\n', '//  }\n', ' function _withdrawFunds(address _to, uint256 amount) private {\n', '    require(address(this).balance >= amount);\n', '    if (_to == address(0)) {\n', '      ceoAddress.transfer(amount);\n', '    } else {\n', '      _to.transfer(amount);\n', '    }\n', '  }\n', '  /// @dev Assigns ownership of a specific Char to an address.\n', '  function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '    // Since the number of chars is capped to 2^32 we can&#39;t overflow this\n', '    ownershipTokenCount[_to]++;\n', '    //transfer ownership\n', '    charIndexToOwner[_tokenId] = _to;\n', '    // When creating new chars _from is 0x0, but we can&#39;t account that address.\n', '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete charIndexToApproved[_tokenId];\n', '    }\n', '    // Emit the transfer event.\n', '    emit Transfer(_from, _to, _tokenId);\n', '  //update trx count  \n', '  addressToTrxCount[_to]++;\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
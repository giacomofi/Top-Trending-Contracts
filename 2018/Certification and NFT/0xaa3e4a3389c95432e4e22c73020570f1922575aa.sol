['pragma solidity ^0.4.24;\n', '\n', '/***\n', ' * https://apexgold.io\n', ' *\n', ' * apexgold Solids - Solids is an eternal smart contract game.\n', ' * \n', ' * The solids are priced by number of faces.\n', ' * Price increases by 35% every flip.\n', ' * Over 4 hours price will fall to base.\n', ' * Holders after 4 hours with no flip can collect the holder fund.\n', ' * \n', ' * 10% of rise buyer gets APG tokens in the ApexGold exchange.\n', ' * 5% of rise goes to holder fund.\n', ' * 5% of rise goes to team and promoters.\n', ' * The rest (110%) goes to previous owner.\n', ' * \n', ' */\n', 'contract ERC721 {\n', '\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '\n', '}\n', '\n', 'contract apexGoldInterface {\n', '  function isStarted() public view returns (bool);\n', '  function buyFor(address _referredBy, address _customerAddress) public payable returns (uint256);\n', '}\n', '\n', 'contract APGSolids is ERC721 {\n', '\n', '  /*=================================\n', '  =            MODIFIERS            =\n', '  =================================*/\n', '\n', '  /// @dev Access modifier for owner functions\n', '  modifier onlyOwner() {\n', '    require(msg.sender == contractOwner);\n', '    _;\n', '  }\n', '\n', '  /// @dev Prevent contract calls.\n', '  modifier notContract() {\n', '    require(tx.origin == msg.sender);\n', '    _;\n', '  }\n', '\n', '  /// @dev notPaused\n', '  modifier notPaused() {\n', '    require(paused == false);\n', '    _;\n', '  }\n', '\n', '  /// @dev notGasbag\n', '  modifier notGasbag() {\n', '    require(tx.gasprice < 99999999999);\n', '    _;\n', '  }\n', '\n', '  /* @dev notMoron (childish but fun)\n', '    modifier notMoron() {\n', '      require(msg.sender != 0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01);\n', '      _;\n', '    }\n', '  */\n', '  \n', '  /*==============================\n', '  =            EVENTS            =\n', '  ==============================*/\n', '\n', '  event onTokenSold(\n', '       uint256 indexed tokenId,\n', '       uint256 price,\n', '       address prevOwner,\n', '       address newOwner,\n', '       string name\n', '    );\n', '\n', '\n', '  /*==============================\n', '  =            CONSTANTS         =\n', '  ==============================*/\n', '\n', '  string public constant NAME = "APG Solids";\n', '  string public constant SYMBOL = "APGS";\n', '\n', '  uint256 private increaseRatePercent =  135;\n', '  uint256 private devFeePercent =  5;\n', '  uint256 private bagHolderFundPercent =  5;\n', '  uint256 private exchangeTokenPercent =  10;\n', '  uint256 private previousOwnerPercent =  110;\n', '  uint256 private priceFallDuration =  4 hours;\n', '\n', '  /*==============================\n', '  =            STORAGE           =\n', '  ==============================*/\n', '\n', '  /// @dev A mapping from solid IDs to the address that owns them.\n', '  mapping (uint256 => address) public solidIndexToOwner;\n', '\n', '  // @dev A mapping from owner address to count of tokens that address owns.\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '\n', '  /// @dev A mapping from SolidID to an address that has been approved to call\n', '  mapping (uint256 => address) public solidIndexToApproved;\n', '\n', '  // @dev The address of the owner\n', '  address public contractOwner;\n', '\n', '  // @dev Current dev fee\n', '  uint256 public currentDevFee = 0;\n', '\n', '  // @dev The address of the exchange contract\n', '  address public apexGoldaddress;\n', '\n', '  // @dev paused\n', '  bool public paused;\n', '\n', '  /*==============================\n', '  =            DATATYPES         =\n', '  ==============================*/\n', '\n', '  struct Solid {\n', '    string name;\n', '    uint256 basePrice;\n', '    uint256 highPrice;\n', '    uint256 fallDuration;\n', '    uint256 saleTime; // when was sold last\n', '    uint256 bagHolderFund;\n', '  }\n', '\n', '  Solid [6] public solids;\n', '\n', '  constructor () public {\n', '\n', '    contractOwner = msg.sender;\n', '    paused=true;\n', '\n', '    Solid memory _Tetrahedron = Solid({\n', '            name: "Tetrahedron",\n', '            basePrice: 0.014 ether,\n', '            highPrice: 0.014 ether,\n', '            fallDuration: priceFallDuration,\n', '            saleTime: now,\n', '            bagHolderFund: 0\n', '            });\n', '\n', '    solids[1] =  _Tetrahedron;\n', '\n', '    Solid memory _Cube = Solid({\n', '            name: "Cube",\n', '            basePrice: 0.016 ether,\n', '            highPrice: 0.016 ether,\n', '            fallDuration: priceFallDuration,\n', '            saleTime: now,\n', '            bagHolderFund: 0\n', '            });\n', '\n', '    solids[2] =  _Cube;\n', '\n', '    Solid memory _Octahedron = Solid({\n', '            name: "Octahedron",\n', '            basePrice: 0.018 ether,\n', '            highPrice: 0.018 ether,\n', '            fallDuration: priceFallDuration,\n', '            saleTime: now,\n', '            bagHolderFund: 0\n', '            });\n', '\n', '    solids[3] =  _Octahedron;\n', '\n', '    Solid memory _Dodecahedron = Solid({\n', '            name: "Dodecahedron",\n', '            basePrice: 0.02 ether,\n', '            highPrice: 0.02 ether,\n', '            fallDuration: priceFallDuration,\n', '            saleTime: now,\n', '            bagHolderFund: 0\n', '            });\n', '\n', '    solids[4] =  _Dodecahedron;\n', '\n', '    Solid memory _Icosahedron = Solid({\n', '            name: "Icosahedron",\n', '            basePrice: 0.03 ether,\n', '            highPrice: 0.03 ether,\n', '            fallDuration: priceFallDuration,\n', '            saleTime: now,\n', '            bagHolderFund: 0\n', '            });\n', '\n', '    solids[5] =  _Icosahedron;\n', '\n', '    _transfer(0x0, contractOwner, 1);\n', '    _transfer(0x0, contractOwner, 2);\n', '    _transfer(0x0, contractOwner, 3);\n', '    _transfer(0x0, contractOwner, 4);\n', '    _transfer(0x0, contractOwner, 5);\n', '\n', '  }\n', '\n', '  /*** PUBLIC FUNCTIONS ***/\n', '  /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().\n', '  /// @param _to The address to be granted transfer approval. Pass address(0) to\n', '  ///  clear all approvals.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function approve(\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public {\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '\n', '    solidIndexToApproved[_tokenId] = _to;\n', '\n', '    emit Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  /// For querying balance of a particular account\n', '  /// @param _owner The address for balance query\n', '  /// @dev Required for ERC-721 compliance.\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '  /// @notice Returns all the relevant information about a specific solid.\n', '  /// @param _tokenId The tokenId of the solid of interest.\n', '  function getSolid(uint256 _tokenId) public view returns (\n', '    string solidName,\n', '    uint256 price,\n', '    address currentOwner,\n', '    uint256 bagHolderFund,\n', '    bool isBagFundAvailable\n', '  ) {\n', '    Solid storage solid = solids[_tokenId];\n', '    solidName = solid.name;\n', '    price = priceOf(_tokenId);\n', '    currentOwner = solidIndexToOwner[_tokenId];\n', '    bagHolderFund = solid.bagHolderFund;\n', '    isBagFundAvailable = now > (solid.saleTime + priceFallDuration);\n', '  }\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /// @dev Required for ERC-721 compliance.\n', '  function name() public pure returns (string) {\n', '    return NAME;\n', '  }\n', '\n', '  /// For querying owner of token\n', '  /// @param _tokenId The tokenID for owner inquiry\n', '  /// @dev Required for ERC-721 compliance.\n', '  function ownerOf(uint256 _tokenId)\n', '    public\n', '    view\n', '    returns (address owner)\n', '  {\n', '    owner = solidIndexToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '\n', '  // Allows someone to send ether and obtain the token\n', '  function purchase(uint256 _tokenId , address _referredBy) public payable notContract notPaused notGasbag /*notMoron*/ {\n', '\n', '    address oldOwner = solidIndexToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '\n', '    uint256 currentPrice = priceOf(_tokenId);\n', '\n', '    // Making sure token owner is not sending to self\n', '    require(oldOwner != newOwner);\n', '\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '\n', '    // Making sure sent amount is greater than or equal to the sellingPrice\n', '    require(msg.value >= currentPrice);\n', '\n', '    uint256 previousOwnerGets = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),previousOwnerPercent);\n', '    uint256 exchangeTokensAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),exchangeTokenPercent);\n', '    uint256 devFeeAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),devFeePercent);\n', '    uint256 bagHolderFundAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),bagHolderFundPercent);\n', '\n', '    currentDevFee = currentDevFee + devFeeAmount;\n', '\n', '    if (exchangeContract.isStarted()) {\n', '        exchangeContract.buyFor.value(exchangeTokensAmount)(_referredBy, msg.sender);\n', '    }else{\n', '        // send excess back because exchange is not ready\n', '        msg.sender.transfer(exchangeTokensAmount);\n', '    }\n', '\n', '    // do the sale\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '    // set new price and saleTime\n', '    solids[_tokenId].highPrice = SafeMath.mul(SafeMath.div(currentPrice,100),increaseRatePercent);\n', '    solids[_tokenId].saleTime = now;\n', '    solids[_tokenId].bagHolderFund+=bagHolderFundAmount;\n', '\n', '    // Pay previous tokenOwner if owner is not contract\n', '    if (oldOwner != address(this)) {\n', '      if (oldOwner.send(previousOwnerGets)){}\n', '    }\n', '\n', '    emit onTokenSold(_tokenId, currentPrice, oldOwner, newOwner, solids[_tokenId].name);\n', '\n', '  }\n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '\n', '    Solid storage solid = solids[_tokenId];\n', '    uint256 secondsPassed  = now - solid.saleTime;\n', '\n', '    if (secondsPassed >= solid.fallDuration || solid.highPrice==solid.basePrice) {\n', '            return solid.basePrice;\n', '    }\n', '\n', '    uint256 totalPriceChange = solid.highPrice - solid.basePrice;\n', '    uint256 currentPriceChange = totalPriceChange * secondsPassed /solid.fallDuration;\n', '    uint256 currentPrice = solid.highPrice - currentPriceChange;\n', '\n', '    return currentPrice;\n', '  }\n', '\n', '  function collectBagHolderFund(uint256 _tokenId) public notPaused {\n', '      require(msg.sender == solidIndexToOwner[_tokenId]);\n', '      uint256 bagHolderFund;\n', '      bool isBagFundAvailable = false;\n', '       (\n', '        ,\n', '        ,\n', '        ,\n', '        bagHolderFund,\n', '        isBagFundAvailable\n', '        ) = getSolid(_tokenId);\n', '        require(isBagFundAvailable && bagHolderFund > 0);\n', '        uint256 amount = bagHolderFund;\n', '        solids[_tokenId].bagHolderFund = 0;\n', '        msg.sender.transfer(amount);\n', '  }\n', '\n', '\n', '  /// @dev Required for ERC-721 compliance.\n', '  function symbol() public pure returns (string) {\n', '    return SYMBOL;\n', '  }\n', '\n', '  /// @notice Allow pre-approved user to take ownership of a token\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function takeOwnership(uint256 _tokenId) public {\n', '    address newOwner = msg.sender;\n', '    address oldOwner = solidIndexToOwner[_tokenId];\n', '\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '\n', '    // Making sure transfer is approved\n', '    require(_approved(newOwner, _tokenId));\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '\n', '  /// @param _owner The owner whose tokens we are interested in.\n', '  /// @dev This method MUST NEVER be called by smart contract code.\n', '  function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalTokens = totalSupply();\n', '      uint256 resultIndex = 0;\n', '\n', '      uint256 tokenId;\n', '      for (tokenId = 0; tokenId <= totalTokens; tokenId++) {\n', '        if (solidIndexToOwner[tokenId] == _owner) {\n', '          result[resultIndex] = tokenId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', '  /// For querying totalSupply of token\n', '  /// @dev Required for ERC-721 compliance.\n', '  function totalSupply() public view returns (uint256 total) {\n', '    return 5;\n', '  }\n', '\n', '  /// Owner initates the transfer of the token to another account\n', '  /// @param _to The address for the token to be transferred to.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function transfer(\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public {\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  /// Third-party initiates transfer of token from address _from to address _to\n', '  /// @param _from The address for the token to be transferred from.\n', '  /// @param _to The address for the token to be transferred to.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public {\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  /*** PRIVATE FUNCTIONS ***/\n', '  /// Safety check on _to address to prevent against an unexpected 0x0 default.\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '\n', '  /// For checking approval of transfer for address _to\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return solidIndexToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  /// Check for token ownership\n', '  function _owns(address claimant, uint256 _tokenId) private view returns (bool) {\n', '    return claimant == solidIndexToOwner[_tokenId];\n', '  }\n', '\n', '  /// @dev Assigns ownership of a specific token to an address.\n', '  function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '\n', '    // no transfer to contract\n', '    uint length;\n', '    assembly { length := extcodesize(_to) }\n', '    require (length == 0);\n', '\n', '    ownershipTokenCount[_to]++;\n', '    //transfer ownership\n', '    solidIndexToOwner[_tokenId] = _to;\n', '\n', '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete solidIndexToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    emit Transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  /// @dev Not a charity\n', '  function collectDevFees() public onlyOwner {\n', '      if (currentDevFee < address(this).balance){\n', '         uint256 amount = currentDevFee;\n', '         currentDevFee = 0;\n', '         contractOwner.transfer(amount);\n', '      }\n', '  }\n', '\n', '  /// @dev Interface to exchange\n', '   apexGoldInterface public exchangeContract;\n', '\n', '  function setExchangeAddresss(address _address) public onlyOwner {\n', '    exchangeContract = apexGoldInterface(_address);\n', '    apexGoldaddress = _address;\n', '   }\n', '\n', '   /// @dev stop and start\n', '   function setPaused(bool _paused) public onlyOwner {\n', '     paused = _paused;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/***\n', ' * https://apexgold.io\n', ' *\n', ' * apexgold Solids - Solids is an eternal smart contract game.\n', ' * \n', ' * The solids are priced by number of faces.\n', ' * Price increases by 35% every flip.\n', ' * Over 4 hours price will fall to base.\n', ' * Holders after 4 hours with no flip can collect the holder fund.\n', ' * \n', ' * 10% of rise buyer gets APG tokens in the ApexGold exchange.\n', ' * 5% of rise goes to holder fund.\n', ' * 5% of rise goes to team and promoters.\n', ' * The rest (110%) goes to previous owner.\n', ' * \n', ' */\n', 'contract ERC721 {\n', '\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '\n', '}\n', '\n', 'contract apexGoldInterface {\n', '  function isStarted() public view returns (bool);\n', '  function buyFor(address _referredBy, address _customerAddress) public payable returns (uint256);\n', '}\n', '\n', 'contract APGSolids is ERC721 {\n', '\n', '  /*=================================\n', '  =            MODIFIERS            =\n', '  =================================*/\n', '\n', '  /// @dev Access modifier for owner functions\n', '  modifier onlyOwner() {\n', '    require(msg.sender == contractOwner);\n', '    _;\n', '  }\n', '\n', '  /// @dev Prevent contract calls.\n', '  modifier notContract() {\n', '    require(tx.origin == msg.sender);\n', '    _;\n', '  }\n', '\n', '  /// @dev notPaused\n', '  modifier notPaused() {\n', '    require(paused == false);\n', '    _;\n', '  }\n', '\n', '  /// @dev notGasbag\n', '  modifier notGasbag() {\n', '    require(tx.gasprice < 99999999999);\n', '    _;\n', '  }\n', '\n', '  /* @dev notMoron (childish but fun)\n', '    modifier notMoron() {\n', '      require(msg.sender != 0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01);\n', '      _;\n', '    }\n', '  */\n', '  \n', '  /*==============================\n', '  =            EVENTS            =\n', '  ==============================*/\n', '\n', '  event onTokenSold(\n', '       uint256 indexed tokenId,\n', '       uint256 price,\n', '       address prevOwner,\n', '       address newOwner,\n', '       string name\n', '    );\n', '\n', '\n', '  /*==============================\n', '  =            CONSTANTS         =\n', '  ==============================*/\n', '\n', '  string public constant NAME = "APG Solids";\n', '  string public constant SYMBOL = "APGS";\n', '\n', '  uint256 private increaseRatePercent =  135;\n', '  uint256 private devFeePercent =  5;\n', '  uint256 private bagHolderFundPercent =  5;\n', '  uint256 private exchangeTokenPercent =  10;\n', '  uint256 private previousOwnerPercent =  110;\n', '  uint256 private priceFallDuration =  4 hours;\n', '\n', '  /*==============================\n', '  =            STORAGE           =\n', '  ==============================*/\n', '\n', '  /// @dev A mapping from solid IDs to the address that owns them.\n', '  mapping (uint256 => address) public solidIndexToOwner;\n', '\n', '  // @dev A mapping from owner address to count of tokens that address owns.\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '\n', '  /// @dev A mapping from SolidID to an address that has been approved to call\n', '  mapping (uint256 => address) public solidIndexToApproved;\n', '\n', '  // @dev The address of the owner\n', '  address public contractOwner;\n', '\n', '  // @dev Current dev fee\n', '  uint256 public currentDevFee = 0;\n', '\n', '  // @dev The address of the exchange contract\n', '  address public apexGoldaddress;\n', '\n', '  // @dev paused\n', '  bool public paused;\n', '\n', '  /*==============================\n', '  =            DATATYPES         =\n', '  ==============================*/\n', '\n', '  struct Solid {\n', '    string name;\n', '    uint256 basePrice;\n', '    uint256 highPrice;\n', '    uint256 fallDuration;\n', '    uint256 saleTime; // when was sold last\n', '    uint256 bagHolderFund;\n', '  }\n', '\n', '  Solid [6] public solids;\n', '\n', '  constructor () public {\n', '\n', '    contractOwner = msg.sender;\n', '    paused=true;\n', '\n', '    Solid memory _Tetrahedron = Solid({\n', '            name: "Tetrahedron",\n', '            basePrice: 0.014 ether,\n', '            highPrice: 0.014 ether,\n', '            fallDuration: priceFallDuration,\n', '            saleTime: now,\n', '            bagHolderFund: 0\n', '            });\n', '\n', '    solids[1] =  _Tetrahedron;\n', '\n', '    Solid memory _Cube = Solid({\n', '            name: "Cube",\n', '            basePrice: 0.016 ether,\n', '            highPrice: 0.016 ether,\n', '            fallDuration: priceFallDuration,\n', '            saleTime: now,\n', '            bagHolderFund: 0\n', '            });\n', '\n', '    solids[2] =  _Cube;\n', '\n', '    Solid memory _Octahedron = Solid({\n', '            name: "Octahedron",\n', '            basePrice: 0.018 ether,\n', '            highPrice: 0.018 ether,\n', '            fallDuration: priceFallDuration,\n', '            saleTime: now,\n', '            bagHolderFund: 0\n', '            });\n', '\n', '    solids[3] =  _Octahedron;\n', '\n', '    Solid memory _Dodecahedron = Solid({\n', '            name: "Dodecahedron",\n', '            basePrice: 0.02 ether,\n', '            highPrice: 0.02 ether,\n', '            fallDuration: priceFallDuration,\n', '            saleTime: now,\n', '            bagHolderFund: 0\n', '            });\n', '\n', '    solids[4] =  _Dodecahedron;\n', '\n', '    Solid memory _Icosahedron = Solid({\n', '            name: "Icosahedron",\n', '            basePrice: 0.03 ether,\n', '            highPrice: 0.03 ether,\n', '            fallDuration: priceFallDuration,\n', '            saleTime: now,\n', '            bagHolderFund: 0\n', '            });\n', '\n', '    solids[5] =  _Icosahedron;\n', '\n', '    _transfer(0x0, contractOwner, 1);\n', '    _transfer(0x0, contractOwner, 2);\n', '    _transfer(0x0, contractOwner, 3);\n', '    _transfer(0x0, contractOwner, 4);\n', '    _transfer(0x0, contractOwner, 5);\n', '\n', '  }\n', '\n', '  /*** PUBLIC FUNCTIONS ***/\n', '  /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().\n', '  /// @param _to The address to be granted transfer approval. Pass address(0) to\n', '  ///  clear all approvals.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function approve(\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public {\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '\n', '    solidIndexToApproved[_tokenId] = _to;\n', '\n', '    emit Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  /// For querying balance of a particular account\n', '  /// @param _owner The address for balance query\n', '  /// @dev Required for ERC-721 compliance.\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '  /// @notice Returns all the relevant information about a specific solid.\n', '  /// @param _tokenId The tokenId of the solid of interest.\n', '  function getSolid(uint256 _tokenId) public view returns (\n', '    string solidName,\n', '    uint256 price,\n', '    address currentOwner,\n', '    uint256 bagHolderFund,\n', '    bool isBagFundAvailable\n', '  ) {\n', '    Solid storage solid = solids[_tokenId];\n', '    solidName = solid.name;\n', '    price = priceOf(_tokenId);\n', '    currentOwner = solidIndexToOwner[_tokenId];\n', '    bagHolderFund = solid.bagHolderFund;\n', '    isBagFundAvailable = now > (solid.saleTime + priceFallDuration);\n', '  }\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /// @dev Required for ERC-721 compliance.\n', '  function name() public pure returns (string) {\n', '    return NAME;\n', '  }\n', '\n', '  /// For querying owner of token\n', '  /// @param _tokenId The tokenID for owner inquiry\n', '  /// @dev Required for ERC-721 compliance.\n', '  function ownerOf(uint256 _tokenId)\n', '    public\n', '    view\n', '    returns (address owner)\n', '  {\n', '    owner = solidIndexToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '\n', '  // Allows someone to send ether and obtain the token\n', '  function purchase(uint256 _tokenId , address _referredBy) public payable notContract notPaused notGasbag /*notMoron*/ {\n', '\n', '    address oldOwner = solidIndexToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '\n', '    uint256 currentPrice = priceOf(_tokenId);\n', '\n', '    // Making sure token owner is not sending to self\n', '    require(oldOwner != newOwner);\n', '\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '\n', '    // Making sure sent amount is greater than or equal to the sellingPrice\n', '    require(msg.value >= currentPrice);\n', '\n', '    uint256 previousOwnerGets = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),previousOwnerPercent);\n', '    uint256 exchangeTokensAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),exchangeTokenPercent);\n', '    uint256 devFeeAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),devFeePercent);\n', '    uint256 bagHolderFundAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),bagHolderFundPercent);\n', '\n', '    currentDevFee = currentDevFee + devFeeAmount;\n', '\n', '    if (exchangeContract.isStarted()) {\n', '        exchangeContract.buyFor.value(exchangeTokensAmount)(_referredBy, msg.sender);\n', '    }else{\n', '        // send excess back because exchange is not ready\n', '        msg.sender.transfer(exchangeTokensAmount);\n', '    }\n', '\n', '    // do the sale\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '    // set new price and saleTime\n', '    solids[_tokenId].highPrice = SafeMath.mul(SafeMath.div(currentPrice,100),increaseRatePercent);\n', '    solids[_tokenId].saleTime = now;\n', '    solids[_tokenId].bagHolderFund+=bagHolderFundAmount;\n', '\n', '    // Pay previous tokenOwner if owner is not contract\n', '    if (oldOwner != address(this)) {\n', '      if (oldOwner.send(previousOwnerGets)){}\n', '    }\n', '\n', '    emit onTokenSold(_tokenId, currentPrice, oldOwner, newOwner, solids[_tokenId].name);\n', '\n', '  }\n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '\n', '    Solid storage solid = solids[_tokenId];\n', '    uint256 secondsPassed  = now - solid.saleTime;\n', '\n', '    if (secondsPassed >= solid.fallDuration || solid.highPrice==solid.basePrice) {\n', '            return solid.basePrice;\n', '    }\n', '\n', '    uint256 totalPriceChange = solid.highPrice - solid.basePrice;\n', '    uint256 currentPriceChange = totalPriceChange * secondsPassed /solid.fallDuration;\n', '    uint256 currentPrice = solid.highPrice - currentPriceChange;\n', '\n', '    return currentPrice;\n', '  }\n', '\n', '  function collectBagHolderFund(uint256 _tokenId) public notPaused {\n', '      require(msg.sender == solidIndexToOwner[_tokenId]);\n', '      uint256 bagHolderFund;\n', '      bool isBagFundAvailable = false;\n', '       (\n', '        ,\n', '        ,\n', '        ,\n', '        bagHolderFund,\n', '        isBagFundAvailable\n', '        ) = getSolid(_tokenId);\n', '        require(isBagFundAvailable && bagHolderFund > 0);\n', '        uint256 amount = bagHolderFund;\n', '        solids[_tokenId].bagHolderFund = 0;\n', '        msg.sender.transfer(amount);\n', '  }\n', '\n', '\n', '  /// @dev Required for ERC-721 compliance.\n', '  function symbol() public pure returns (string) {\n', '    return SYMBOL;\n', '  }\n', '\n', '  /// @notice Allow pre-approved user to take ownership of a token\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function takeOwnership(uint256 _tokenId) public {\n', '    address newOwner = msg.sender;\n', '    address oldOwner = solidIndexToOwner[_tokenId];\n', '\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '\n', '    // Making sure transfer is approved\n', '    require(_approved(newOwner, _tokenId));\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '\n', '  /// @param _owner The owner whose tokens we are interested in.\n', '  /// @dev This method MUST NEVER be called by smart contract code.\n', '  function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalTokens = totalSupply();\n', '      uint256 resultIndex = 0;\n', '\n', '      uint256 tokenId;\n', '      for (tokenId = 0; tokenId <= totalTokens; tokenId++) {\n', '        if (solidIndexToOwner[tokenId] == _owner) {\n', '          result[resultIndex] = tokenId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', '  /// For querying totalSupply of token\n', '  /// @dev Required for ERC-721 compliance.\n', '  function totalSupply() public view returns (uint256 total) {\n', '    return 5;\n', '  }\n', '\n', '  /// Owner initates the transfer of the token to another account\n', '  /// @param _to The address for the token to be transferred to.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function transfer(\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public {\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  /// Third-party initiates transfer of token from address _from to address _to\n', '  /// @param _from The address for the token to be transferred from.\n', '  /// @param _to The address for the token to be transferred to.\n', '  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.\n', '  /// @dev Required for ERC-721 compliance.\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _tokenId\n', '  ) public {\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  /*** PRIVATE FUNCTIONS ***/\n', '  /// Safety check on _to address to prevent against an unexpected 0x0 default.\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '\n', '  /// For checking approval of transfer for address _to\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return solidIndexToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  /// Check for token ownership\n', '  function _owns(address claimant, uint256 _tokenId) private view returns (bool) {\n', '    return claimant == solidIndexToOwner[_tokenId];\n', '  }\n', '\n', '  /// @dev Assigns ownership of a specific token to an address.\n', '  function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '\n', '    // no transfer to contract\n', '    uint length;\n', '    assembly { length := extcodesize(_to) }\n', '    require (length == 0);\n', '\n', '    ownershipTokenCount[_to]++;\n', '    //transfer ownership\n', '    solidIndexToOwner[_tokenId] = _to;\n', '\n', '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete solidIndexToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    emit Transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  /// @dev Not a charity\n', '  function collectDevFees() public onlyOwner {\n', '      if (currentDevFee < address(this).balance){\n', '         uint256 amount = currentDevFee;\n', '         currentDevFee = 0;\n', '         contractOwner.transfer(amount);\n', '      }\n', '  }\n', '\n', '  /// @dev Interface to exchange\n', '   apexGoldInterface public exchangeContract;\n', '\n', '  function setExchangeAddresss(address _address) public onlyOwner {\n', '    exchangeContract = apexGoldInterface(_address);\n', '    apexGoldaddress = _address;\n', '   }\n', '\n', '   /// @dev stop and start\n', '   function setPaused(bool _paused) public onlyOwner {\n', '     paused = _paused;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}']

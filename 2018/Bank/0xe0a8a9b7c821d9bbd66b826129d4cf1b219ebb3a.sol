['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', 'contract ERC721 {\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '}\n', '\n', '\n', 'contract CryptoRides is ERC721 {\n', '  event Created(uint256 tokenId, string name, bytes7 plateNumber, address owner);\n', '  event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name, bytes7 plateNumber);\n', '  event Transfer(address from, address to, uint256 tokenId);\n', '\n', '  string public constant NAME = "CryptoRides"; // solhint-disable-line\n', '  string public constant SYMBOL = "CryptoRidesToken"; // solhint-disable-line\n', '  uint256 private startingPrice = 0.001 ether;\n', '  uint256 private constant PROMO_CREATION_LIMIT = 5000;\n', '  uint256 private firstStepLimit =  0.053613 ether;\n', '  uint256 private secondStepLimit = 0.564957 ether;\n', '\n', '  mapping (uint256 => address) public tokenIdToOwner;\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '  mapping (uint256 => address) public tokenIdToApproved;\n', '  mapping (uint256 => uint256) private tokenIdToPrice;\n', '\n', '  address public ceoAddress;\n', '  address public cooAddress;\n', '\n', '  uint256 public promoCreatedCount;\n', '\n', '  struct Ride {\n', '    string name;\n', '    bytes7 plateNumber;\n', '  }\n', '  Ride[] private rides;\n', '\n', '  modifier onlyCEO() {\n', '    require(msg.sender == ceoAddress);\n', '    _;\n', '  }\n', '\n', '  modifier onlyCOO() {\n', '    require(msg.sender == cooAddress);\n', '    _;\n', '  }\n', '\n', '  modifier onlyCLevel() {\n', '    require(\n', '      msg.sender == ceoAddress ||\n', '      msg.sender == cooAddress\n', '    );\n', '    _;\n', '  }\n', '\n', '  function CryptoRides() public {\n', '    ceoAddress = msg.sender;\n', '    cooAddress = msg.sender;\n', '  }\n', '\n', '  function approve( address _to, uint256 _tokenId) public {\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '\n', '    tokenIdToApproved[_tokenId] = _to;\n', '\n', '    Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '  function createPromoRide(address _owner, string _name, bytes7 _plateNo, uint256 _price) public onlyCOO {\n', '    require(promoCreatedCount < PROMO_CREATION_LIMIT);\n', '\n', '    address rideOwner = _owner;\n', '    if (rideOwner == address(0)) {\n', '      rideOwner = cooAddress;\n', '    }\n', '\n', '    if (_price <= 0) {\n', '      _price = startingPrice;\n', '    }\n', '\n', '    promoCreatedCount++;\n', '    _createRide(_name, _plateNo, rideOwner, _price);\n', '  }\n', '\n', '  function createContractRide(string _name, bytes7 _plateNo) public onlyCOO {\n', '    _createRide(_name, _plateNo, address(this), startingPrice);\n', '  }\n', '\n', '  function getRide(uint256 _tokenId) public view returns (\n', '    string rideName,\n', '    bytes7 plateNumber,\n', '    uint256 sellingPrice,\n', '    address owner\n', '  ) {\n', '    Ride storage ride = rides[_tokenId];\n', '    rideName = ride.name;\n', '    plateNumber = ride.plateNumber;\n', '    sellingPrice = tokenIdToPrice[_tokenId];\n', '    owner = tokenIdToOwner[_tokenId];\n', '  }\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function name() public pure returns (string) {\n', '    return NAME;\n', '  }\n', '\n', '  function ownerOf(uint256 _tokenId)\n', '    public\n', '    view\n', '    returns (address owner)\n', '  {\n', '    owner = tokenIdToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '\n', '  function payout(address _to) public onlyCLevel {\n', '    _payout(_to);\n', '  }\n', '\n', '  function purchase(uint256 _tokenId, bytes7 _plateNumber) public payable {\n', '    address oldOwner = tokenIdToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '\n', '    uint256 sellingPrice = tokenIdToPrice[_tokenId];\n', '\n', '    require(oldOwner != newOwner);\n', '\n', '    require(_addressNotNull(newOwner));\n', '\n', '    require(msg.value >= sellingPrice);\n', '\n', '    uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));\n', '    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);\n', '\n', '    // Update prices\n', '    if (sellingPrice < firstStepLimit) {\n', '      // first stage\n', '      tokenIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);\n', '    } else if (sellingPrice < secondStepLimit) {\n', '      // second stage\n', '      tokenIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);\n', '    } else {\n', '      // third stage\n', '      tokenIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 92);\n', '    }\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '    // Pay previous tokenOwner if owner is not contract\n', '    if (oldOwner != address(this)) {\n', '      oldOwner.transfer(payment); //(1-0.08)\n', '    }\n', '\n', '    TokenSold(_tokenId, sellingPrice, tokenIdToPrice[_tokenId], oldOwner, newOwner, rides[_tokenId].name, _plateNumber);\n', '\n', '    msg.sender.transfer(purchaseExcess);\n', '    rides[_tokenId].plateNumber = _plateNumber;\n', '  }\n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '    return tokenIdToPrice[_tokenId];\n', '  }\n', '\n', '  function setCEO(address _newCEO) public onlyCEO {\n', '    require(_newCEO != address(0));\n', '\n', '    ceoAddress = _newCEO;\n', '  }\n', '\n', '  function setCOO(address _newCOO) public onlyCEO {\n', '    require(_newCOO != address(0));\n', '\n', '    cooAddress = _newCOO;\n', '  }\n', '\n', '  function symbol() public pure returns (string) {\n', '    return SYMBOL;\n', '  }\n', '\n', '  function takeOwnership(uint256 _tokenId) public {\n', '    address newOwner = msg.sender;\n', '    address oldOwner = tokenIdToOwner[_tokenId];\n', '\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '\n', '    // Making sure transfer is approved\n', '    require(_approved(newOwner, _tokenId));\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '\n', '  function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalRides = totalSupply();\n', '      uint256 resultIndex = 0;\n', '\n', '      uint256 rideId;\n', '      for (rideId = 0; rideId <= totalRides; rideId++) {\n', '        if (tokenIdToOwner[rideId] == _owner) {\n', '          result[resultIndex] = rideId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256 total) {\n', '    return rides.length;\n', '  }\n', '\n', '  function transfer( address _to, uint256 _tokenId) public {\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public {\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return tokenIdToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  function _createRide(string _name, bytes7 _plateNo, address _owner, uint256 _price) private {\n', '    Ride memory _ride = Ride({\n', '      name: _name, \n', '      plateNumber: _plateNo\n', '    });\n', '    uint256 newRideId = rides.push(_ride) - 1;\n', '\n', '    require(newRideId == uint256(uint32(newRideId)));\n', '\n', '    Created(newRideId, _name, _plateNo, _owner);\n', '\n', '    tokenIdToPrice[newRideId] = _price;\n', '\n', '    _transfer(address(0), _owner, newRideId);\n', '  }\n', '\n', '  function _owns(address claimant, uint256 _tokenId) private view returns (bool) {\n', '    return claimant == tokenIdToOwner[_tokenId];\n', '  }\n', '\n', '  function _payout(address _to) private {\n', '    if (_to == address(0)) {\n', '      ceoAddress.transfer(this.balance);\n', '    } else {\n', '      _to.transfer(this.balance);\n', '    }\n', '  }\n', '\n', '  function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '    // Since the number of rides is capped to 2^32 we can&#39;t overflow this\n', '    ownershipTokenCount[_to]++;\n', '    //transfer ownership\n', '    tokenIdToOwner[_tokenId] = _to;\n', '\n', '    // When creating new rides _from is 0x0, but we can&#39;t account that address.\n', '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete tokenIdToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    Transfer(_from, _to, _tokenId);\n', '  }\n', '}\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18; // solhint-disable-line\n', '\n', 'contract ERC721 {\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '}\n', '\n', '\n', 'contract CryptoRides is ERC721 {\n', '  event Created(uint256 tokenId, string name, bytes7 plateNumber, address owner);\n', '  event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name, bytes7 plateNumber);\n', '  event Transfer(address from, address to, uint256 tokenId);\n', '\n', '  string public constant NAME = "CryptoRides"; // solhint-disable-line\n', '  string public constant SYMBOL = "CryptoRidesToken"; // solhint-disable-line\n', '  uint256 private startingPrice = 0.001 ether;\n', '  uint256 private constant PROMO_CREATION_LIMIT = 5000;\n', '  uint256 private firstStepLimit =  0.053613 ether;\n', '  uint256 private secondStepLimit = 0.564957 ether;\n', '\n', '  mapping (uint256 => address) public tokenIdToOwner;\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '  mapping (uint256 => address) public tokenIdToApproved;\n', '  mapping (uint256 => uint256) private tokenIdToPrice;\n', '\n', '  address public ceoAddress;\n', '  address public cooAddress;\n', '\n', '  uint256 public promoCreatedCount;\n', '\n', '  struct Ride {\n', '    string name;\n', '    bytes7 plateNumber;\n', '  }\n', '  Ride[] private rides;\n', '\n', '  modifier onlyCEO() {\n', '    require(msg.sender == ceoAddress);\n', '    _;\n', '  }\n', '\n', '  modifier onlyCOO() {\n', '    require(msg.sender == cooAddress);\n', '    _;\n', '  }\n', '\n', '  modifier onlyCLevel() {\n', '    require(\n', '      msg.sender == ceoAddress ||\n', '      msg.sender == cooAddress\n', '    );\n', '    _;\n', '  }\n', '\n', '  function CryptoRides() public {\n', '    ceoAddress = msg.sender;\n', '    cooAddress = msg.sender;\n', '  }\n', '\n', '  function approve( address _to, uint256 _tokenId) public {\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '\n', '    tokenIdToApproved[_tokenId] = _to;\n', '\n', '    Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '  function createPromoRide(address _owner, string _name, bytes7 _plateNo, uint256 _price) public onlyCOO {\n', '    require(promoCreatedCount < PROMO_CREATION_LIMIT);\n', '\n', '    address rideOwner = _owner;\n', '    if (rideOwner == address(0)) {\n', '      rideOwner = cooAddress;\n', '    }\n', '\n', '    if (_price <= 0) {\n', '      _price = startingPrice;\n', '    }\n', '\n', '    promoCreatedCount++;\n', '    _createRide(_name, _plateNo, rideOwner, _price);\n', '  }\n', '\n', '  function createContractRide(string _name, bytes7 _plateNo) public onlyCOO {\n', '    _createRide(_name, _plateNo, address(this), startingPrice);\n', '  }\n', '\n', '  function getRide(uint256 _tokenId) public view returns (\n', '    string rideName,\n', '    bytes7 plateNumber,\n', '    uint256 sellingPrice,\n', '    address owner\n', '  ) {\n', '    Ride storage ride = rides[_tokenId];\n', '    rideName = ride.name;\n', '    plateNumber = ride.plateNumber;\n', '    sellingPrice = tokenIdToPrice[_tokenId];\n', '    owner = tokenIdToOwner[_tokenId];\n', '  }\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function name() public pure returns (string) {\n', '    return NAME;\n', '  }\n', '\n', '  function ownerOf(uint256 _tokenId)\n', '    public\n', '    view\n', '    returns (address owner)\n', '  {\n', '    owner = tokenIdToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '\n', '  function payout(address _to) public onlyCLevel {\n', '    _payout(_to);\n', '  }\n', '\n', '  function purchase(uint256 _tokenId, bytes7 _plateNumber) public payable {\n', '    address oldOwner = tokenIdToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '\n', '    uint256 sellingPrice = tokenIdToPrice[_tokenId];\n', '\n', '    require(oldOwner != newOwner);\n', '\n', '    require(_addressNotNull(newOwner));\n', '\n', '    require(msg.value >= sellingPrice);\n', '\n', '    uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));\n', '    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);\n', '\n', '    // Update prices\n', '    if (sellingPrice < firstStepLimit) {\n', '      // first stage\n', '      tokenIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);\n', '    } else if (sellingPrice < secondStepLimit) {\n', '      // second stage\n', '      tokenIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);\n', '    } else {\n', '      // third stage\n', '      tokenIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 92);\n', '    }\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '    // Pay previous tokenOwner if owner is not contract\n', '    if (oldOwner != address(this)) {\n', '      oldOwner.transfer(payment); //(1-0.08)\n', '    }\n', '\n', '    TokenSold(_tokenId, sellingPrice, tokenIdToPrice[_tokenId], oldOwner, newOwner, rides[_tokenId].name, _plateNumber);\n', '\n', '    msg.sender.transfer(purchaseExcess);\n', '    rides[_tokenId].plateNumber = _plateNumber;\n', '  }\n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '    return tokenIdToPrice[_tokenId];\n', '  }\n', '\n', '  function setCEO(address _newCEO) public onlyCEO {\n', '    require(_newCEO != address(0));\n', '\n', '    ceoAddress = _newCEO;\n', '  }\n', '\n', '  function setCOO(address _newCOO) public onlyCEO {\n', '    require(_newCOO != address(0));\n', '\n', '    cooAddress = _newCOO;\n', '  }\n', '\n', '  function symbol() public pure returns (string) {\n', '    return SYMBOL;\n', '  }\n', '\n', '  function takeOwnership(uint256 _tokenId) public {\n', '    address newOwner = msg.sender;\n', '    address oldOwner = tokenIdToOwner[_tokenId];\n', '\n', '    // Safety check to prevent against an unexpected 0x0 default.\n', '    require(_addressNotNull(newOwner));\n', '\n', '    // Making sure transfer is approved\n', '    require(_approved(newOwner, _tokenId));\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '\n', '  function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalRides = totalSupply();\n', '      uint256 resultIndex = 0;\n', '\n', '      uint256 rideId;\n', '      for (rideId = 0; rideId <= totalRides; rideId++) {\n', '        if (tokenIdToOwner[rideId] == _owner) {\n', '          result[resultIndex] = rideId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256 total) {\n', '    return rides.length;\n', '  }\n', '\n', '  function transfer( address _to, uint256 _tokenId) public {\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public {\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return tokenIdToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  function _createRide(string _name, bytes7 _plateNo, address _owner, uint256 _price) private {\n', '    Ride memory _ride = Ride({\n', '      name: _name, \n', '      plateNumber: _plateNo\n', '    });\n', '    uint256 newRideId = rides.push(_ride) - 1;\n', '\n', '    require(newRideId == uint256(uint32(newRideId)));\n', '\n', '    Created(newRideId, _name, _plateNo, _owner);\n', '\n', '    tokenIdToPrice[newRideId] = _price;\n', '\n', '    _transfer(address(0), _owner, newRideId);\n', '  }\n', '\n', '  function _owns(address claimant, uint256 _tokenId) private view returns (bool) {\n', '    return claimant == tokenIdToOwner[_tokenId];\n', '  }\n', '\n', '  function _payout(address _to) private {\n', '    if (_to == address(0)) {\n', '      ceoAddress.transfer(this.balance);\n', '    } else {\n', '      _to.transfer(this.balance);\n', '    }\n', '  }\n', '\n', '  function _transfer(address _from, address _to, uint256 _tokenId) private {\n', "    // Since the number of rides is capped to 2^32 we can't overflow this\n", '    ownershipTokenCount[_to]++;\n', '    //transfer ownership\n', '    tokenIdToOwner[_tokenId] = _to;\n', '\n', "    // When creating new rides _from is 0x0, but we can't account that address.\n", '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete tokenIdToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    Transfer(_from, _to, _tokenId);\n', '  }\n', '}\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']

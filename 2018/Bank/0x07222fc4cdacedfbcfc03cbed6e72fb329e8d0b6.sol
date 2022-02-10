['pragma solidity ^0.4.20;\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '\n', '  address public coOwner;\n', '\n', '  function Ownable() public {\n', '    coOwner = msg.sender;\n', '  }\n', '\n', '  modifier onlyCoOwner() {\n', '    require(msg.sender == coOwner);\n', '    _;\n', '  }\n', '\n', '  function transferCoOwnership(address _newOwner) public onlyCoOwner {\n', '    require(_newOwner != address(0));\n', '\n', '    coOwner = _newOwner;\n', '\n', '    CoOwnershipTransferred(coOwner, _newOwner);\n', '  }\n', '  \n', '  function CoWithdraw() public onlyCoOwner {\n', '      coOwner.transfer(this.balance);\n', '  }  \n', '  \n', '  event CoOwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '}\n', '\n', '/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', '/// @author Dieter Shirley <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="137776677653726b7a7c7e69767d3d707c">[email&#160;protected]</a>> (https://github.com/dete)\n', 'contract ERC721 {\n', '  // Required methods\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '\n', '  // Optional\n', '  // function name() public view returns (string name);\n', '  // function symbol() public view returns (string symbol);\n', '  // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);\n', '  // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);\n', '}\n', '\n', 'contract CryptoCarsRent is ERC721, Ownable {\n', '\n', '  event CarCreated(uint256 tokenId, string name, address owner);\n', '  event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);\n', '  event Transfer(address from, address to, uint256 tokenId);\n', '\n', '  string public constant NAME = "CryptoCars";\n', '  string public constant SYMBOL = "CarsToken";\n', '\n', '  uint256 private startingSellPrice = 0.012 ether;\n', '\n', '  mapping (uint256 => address) public carIdToOwner;\n', '\n', '  mapping (uint256 => address) public carIdToRenter;\n', '  mapping (uint256 => uint256) public carIdRentStartTime;\n', '\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '\n', '  mapping (uint256 => address) public carIdToApproved;\n', '\n', '  mapping (uint256 => uint256) private carIdToPrice;\n', '  mapping (uint256 => uint256) private carIdToProfit;\n', '\n', '  /*** DATATYPES ***/\n', '  struct Car {\n', '    string name;\n', '  }\n', '\n', '  Car[] private cars;\n', '\n', '  function approve(address _to, uint256 _tokenId) public { //ERC721\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '    carIdToApproved[_tokenId] = _to;\n', '    Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '  function createCarToken(string _name) public onlyCoOwner {\n', '    _createCar(_name, address(this), startingSellPrice);\n', '  }\n', '\n', '  function createCarsTokens() public onlyCoOwner {\n', '\n', '\tfor (uint8 car=0; car<21; car++) {\n', '\t   _createCar("Crypto Car", address(this), startingSellPrice);\n', '\t }\n', '\n', '  }\n', '  \n', '  function getCar(uint256 _tokenId) public view returns (string carName, uint256 sellingPrice, address owner) {\n', '    Car storage car = cars[_tokenId];\n', '    carName = car.name;\n', '    sellingPrice = carIdToPrice[_tokenId];\n', '    owner = carIdToOwner[_tokenId];\n', '  }\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function name() public pure returns (string) { //ERC721\n', '    return NAME;\n', '  }\n', '\n', '  function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721\n', '    owner = carIdToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '\n', '  // Allows someone to send ether and obtain the token\n', '  function purchase(uint256 _tokenId) public payable {\n', '    address oldOwner = carIdToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '\tuint256 renter_payment;\n', '\tuint256 payment;\n', '\t\n', '\tif (now - carIdRentStartTime[_tokenId] > 7200) // 2 hours of rent finished\n', '\t\tcarIdToRenter[_tokenId] = address(0);\n', '\t\t\n', '\taddress renter = carIdToRenter[_tokenId];\n', '\n', '    uint256 sellingPrice = carIdToPrice[_tokenId];\n', '\tuint256 profit = carIdToProfit[_tokenId];\n', '\n', '    require(oldOwner != newOwner);\n', '    require(_addressNotNull(newOwner));\n', '    require(msg.value >= sellingPrice);\n', '\t\n', '\t\n', '\n', '    if (renter != address(0)) {\n', '\t\trenter_payment = uint256(SafeMath.div(SafeMath.mul(profit, 45), 100)); //45% from profit to car&#39;s renter\n', '\t\tpayment = uint256(SafeMath.sub(SafeMath.div(SafeMath.mul(sellingPrice, 97), 100), renter_payment)); //&#39;97% - renter_payment&#39; to previous owner\n', '\t} else {\n', '\t\trenter_payment = 0;\n', '\t\tpayment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100)); //94% to previous owner\n', '\t}\n', '\n', '\t\n', '    // Next price will in 2 times more.\n', '\tif (sellingPrice < 500 finney) {\n', '\t\tcarIdToPrice[_tokenId] = SafeMath.mul(sellingPrice, 2); //rice by 100%\n', '\t}\n', '\telse {\n', '\t\tcarIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 15), 10)); //rice by 50%\n', '\t}\n', '\t\n', '    //plannig profit from next selling\n', '  \tcarIdToProfit[_tokenId] = uint256(SafeMath.sub(carIdToPrice[_tokenId], sellingPrice));\n', '    carIdToRenter[_tokenId] = address(0);\n', '\tcarIdRentStartTime[_tokenId] =  0;\n', '\t\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '    // Pay previous tokenOwner if owner is not contract\n', '    if (oldOwner != address(this)) {\n', '      oldOwner.transfer(payment); //\n', '    }\n', '\n', '    // Pay to token renter \n', '    if (renter != address(0)) {\n', '      renter.transfer(renter_payment); //\n', '    }\n', '\n', '    TokenSold(_tokenId, sellingPrice, carIdToPrice[_tokenId], oldOwner, newOwner, cars[_tokenId].name);\n', '\t\n', '    if (msg.value > sellingPrice) { //if excess pay\n', '\t    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);\n', '\t\tmsg.sender.transfer(purchaseExcess);\n', '\t}\n', '  }\n', '\n', '  function rent(uint256 _tokenId) public payable {\n', '\trequire(now - carIdRentStartTime[_tokenId] > 7200); // 2 hours of previous rent finished\n', '\trequire(msg.sender != carIdToOwner[_tokenId]);\n', '\t\n', '\tuint256 profit = carIdToProfit[_tokenId]; //plannig profit from selling \n', '\tuint256 rentPrice = uint256(SafeMath.div(SafeMath.mul(profit, 10), 100)); //10% from profit is a rent price\n', '     \n', '    require(_addressNotNull(msg.sender));\n', '    require(msg.value >= rentPrice);\t \n', '\t\n', '\tcarIdRentStartTime[_tokenId] = now;\n', '\tcarIdToRenter[_tokenId] = msg.sender;\n', '\t\n', '\taddress carOwner = carIdToOwner[_tokenId];\n', '\trequire(carOwner != address(this));\n', '\t\n', '\t\n', '    if (carOwner != address(this)) {\n', '      carOwner.transfer(rentPrice); //\n', '    }\n', '\t\n', '    if (msg.value > rentPrice) { //if excess pay\n', '\t    uint256 purchaseExcess = SafeMath.sub(msg.value, rentPrice);\n', '\t\tmsg.sender.transfer(purchaseExcess);\n', '\t}\t\n', '  }\n', '  \n', '  \n', '  function symbol() public pure returns (string) { //ERC721\n', '    return SYMBOL;\n', '  }\n', '\n', '\n', '  function takeOwnership(uint256 _tokenId) public { //ERC721\n', '    address newOwner = msg.sender;\n', '    address oldOwner = carIdToOwner[_tokenId];\n', '\n', '    require(_addressNotNull(newOwner));\n', '    require(_approved(newOwner, _tokenId));\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '  \n', '  function allCarsInfo() public view returns (address[] owners, address[] renters, uint256[] prices, uint256[] profits) { //for web site view\n', '\t\n', '\tuint256 totalResultCars = totalSupply();\n', '\t\n', '    if (totalResultCars == 0) {\n', '        // Return an empty array\n', '      return (new address[](0),new address[](0),new uint256[](0),new uint256[](0));\n', '    }\n', '\t\n', '\taddress[] memory owners_res = new address[](totalResultCars);\n', '\taddress[] memory renters_res = new address[](totalResultCars);\n', '\tuint256[] memory prices_res = new uint256[](totalResultCars);\n', '\tuint256[] memory profits_res = new uint256[](totalResultCars);\n', '\t\n', '\tfor (uint256 carId = 0; carId < totalResultCars; carId++) {\n', '\t  owners_res[carId] = carIdToOwner[carId];\n', '\t  if (now - carIdRentStartTime[carId] <= 7200) // 2 hours of rent finished\n', '\t\trenters_res[carId] = carIdToRenter[carId];\n', '\t  else \n', '\t\trenters_res[carId] = address(0);\n', '\t\t\n', '\t  prices_res[carId] = carIdToPrice[carId];\n', '\t  profits_res[carId] = carIdToProfit[carId];\n', '\t}\n', '\t\n', '\treturn (owners_res, renters_res, prices_res, profits_res);\n', '  }  \n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view\n', '    return carIdToPrice[_tokenId];\n', '  }\n', '  \n', '  function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) { //for web site view\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalCars = totalSupply();\n', '      uint256 resultIndex = 0;\n', '\n', '      uint256 carId;\n', '      for (carId = 0; carId <= totalCars; carId++) {\n', '        if (carIdToOwner[carId] == _owner) {\n', '          result[resultIndex] = carId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256 total) { //ERC721\n', '    return cars.length;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _tokenId) public { //ERC721\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '\t_transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '\n', '  /* PRIVATE FUNCTIONS */\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return carIdToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  function _createCar(string _name, address _owner, uint256 _price) private {\n', '    Car memory _car = Car({\n', '      name: _name\n', '    });\n', '    uint256 newCarId = cars.push(_car) - 1;\n', '\n', '    require(newCarId == uint256(uint32(newCarId))); //check maximum limit of tokens\n', '\n', '    CarCreated(newCarId, _name, _owner);\n', '\n', '    carIdToPrice[newCarId] = _price;\n', '\n', '    _transfer(address(0), _owner, newCarId);\n', '  }\n', '\n', '  function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {\n', '    return _checkedAddr == carIdToOwner[_tokenId];\n', '  }\n', '\n', 'function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '    ownershipTokenCount[_to]++;\n', '    carIdToOwner[_tokenId] = _to;\n', '\n', '    // When creating new cars _from is 0x0, but we can&#39;t account that address.\n', '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete carIdToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    Transfer(_from, _to, _tokenId);\n', '  }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '\n', '  address public coOwner;\n', '\n', '  function Ownable() public {\n', '    coOwner = msg.sender;\n', '  }\n', '\n', '  modifier onlyCoOwner() {\n', '    require(msg.sender == coOwner);\n', '    _;\n', '  }\n', '\n', '  function transferCoOwnership(address _newOwner) public onlyCoOwner {\n', '    require(_newOwner != address(0));\n', '\n', '    coOwner = _newOwner;\n', '\n', '    CoOwnershipTransferred(coOwner, _newOwner);\n', '  }\n', '  \n', '  function CoWithdraw() public onlyCoOwner {\n', '      coOwner.transfer(this.balance);\n', '  }  \n', '  \n', '  event CoOwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '}\n', '\n', '/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', '/// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)\n', 'contract ERC721 {\n', '  // Required methods\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '\n', '  // Optional\n', '  // function name() public view returns (string name);\n', '  // function symbol() public view returns (string symbol);\n', '  // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);\n', '  // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);\n', '}\n', '\n', 'contract CryptoCarsRent is ERC721, Ownable {\n', '\n', '  event CarCreated(uint256 tokenId, string name, address owner);\n', '  event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);\n', '  event Transfer(address from, address to, uint256 tokenId);\n', '\n', '  string public constant NAME = "CryptoCars";\n', '  string public constant SYMBOL = "CarsToken";\n', '\n', '  uint256 private startingSellPrice = 0.012 ether;\n', '\n', '  mapping (uint256 => address) public carIdToOwner;\n', '\n', '  mapping (uint256 => address) public carIdToRenter;\n', '  mapping (uint256 => uint256) public carIdRentStartTime;\n', '\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '\n', '  mapping (uint256 => address) public carIdToApproved;\n', '\n', '  mapping (uint256 => uint256) private carIdToPrice;\n', '  mapping (uint256 => uint256) private carIdToProfit;\n', '\n', '  /*** DATATYPES ***/\n', '  struct Car {\n', '    string name;\n', '  }\n', '\n', '  Car[] private cars;\n', '\n', '  function approve(address _to, uint256 _tokenId) public { //ERC721\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '    carIdToApproved[_tokenId] = _to;\n', '    Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '  function createCarToken(string _name) public onlyCoOwner {\n', '    _createCar(_name, address(this), startingSellPrice);\n', '  }\n', '\n', '  function createCarsTokens() public onlyCoOwner {\n', '\n', '\tfor (uint8 car=0; car<21; car++) {\n', '\t   _createCar("Crypto Car", address(this), startingSellPrice);\n', '\t }\n', '\n', '  }\n', '  \n', '  function getCar(uint256 _tokenId) public view returns (string carName, uint256 sellingPrice, address owner) {\n', '    Car storage car = cars[_tokenId];\n', '    carName = car.name;\n', '    sellingPrice = carIdToPrice[_tokenId];\n', '    owner = carIdToOwner[_tokenId];\n', '  }\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function name() public pure returns (string) { //ERC721\n', '    return NAME;\n', '  }\n', '\n', '  function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721\n', '    owner = carIdToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '\n', '  // Allows someone to send ether and obtain the token\n', '  function purchase(uint256 _tokenId) public payable {\n', '    address oldOwner = carIdToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '\tuint256 renter_payment;\n', '\tuint256 payment;\n', '\t\n', '\tif (now - carIdRentStartTime[_tokenId] > 7200) // 2 hours of rent finished\n', '\t\tcarIdToRenter[_tokenId] = address(0);\n', '\t\t\n', '\taddress renter = carIdToRenter[_tokenId];\n', '\n', '    uint256 sellingPrice = carIdToPrice[_tokenId];\n', '\tuint256 profit = carIdToProfit[_tokenId];\n', '\n', '    require(oldOwner != newOwner);\n', '    require(_addressNotNull(newOwner));\n', '    require(msg.value >= sellingPrice);\n', '\t\n', '\t\n', '\n', '    if (renter != address(0)) {\n', "\t\trenter_payment = uint256(SafeMath.div(SafeMath.mul(profit, 45), 100)); //45% from profit to car's renter\n", "\t\tpayment = uint256(SafeMath.sub(SafeMath.div(SafeMath.mul(sellingPrice, 97), 100), renter_payment)); //'97% - renter_payment' to previous owner\n", '\t} else {\n', '\t\trenter_payment = 0;\n', '\t\tpayment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100)); //94% to previous owner\n', '\t}\n', '\n', '\t\n', '    // Next price will in 2 times more.\n', '\tif (sellingPrice < 500 finney) {\n', '\t\tcarIdToPrice[_tokenId] = SafeMath.mul(sellingPrice, 2); //rice by 100%\n', '\t}\n', '\telse {\n', '\t\tcarIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 15), 10)); //rice by 50%\n', '\t}\n', '\t\n', '    //plannig profit from next selling\n', '  \tcarIdToProfit[_tokenId] = uint256(SafeMath.sub(carIdToPrice[_tokenId], sellingPrice));\n', '    carIdToRenter[_tokenId] = address(0);\n', '\tcarIdRentStartTime[_tokenId] =  0;\n', '\t\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '    // Pay previous tokenOwner if owner is not contract\n', '    if (oldOwner != address(this)) {\n', '      oldOwner.transfer(payment); //\n', '    }\n', '\n', '    // Pay to token renter \n', '    if (renter != address(0)) {\n', '      renter.transfer(renter_payment); //\n', '    }\n', '\n', '    TokenSold(_tokenId, sellingPrice, carIdToPrice[_tokenId], oldOwner, newOwner, cars[_tokenId].name);\n', '\t\n', '    if (msg.value > sellingPrice) { //if excess pay\n', '\t    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);\n', '\t\tmsg.sender.transfer(purchaseExcess);\n', '\t}\n', '  }\n', '\n', '  function rent(uint256 _tokenId) public payable {\n', '\trequire(now - carIdRentStartTime[_tokenId] > 7200); // 2 hours of previous rent finished\n', '\trequire(msg.sender != carIdToOwner[_tokenId]);\n', '\t\n', '\tuint256 profit = carIdToProfit[_tokenId]; //plannig profit from selling \n', '\tuint256 rentPrice = uint256(SafeMath.div(SafeMath.mul(profit, 10), 100)); //10% from profit is a rent price\n', '     \n', '    require(_addressNotNull(msg.sender));\n', '    require(msg.value >= rentPrice);\t \n', '\t\n', '\tcarIdRentStartTime[_tokenId] = now;\n', '\tcarIdToRenter[_tokenId] = msg.sender;\n', '\t\n', '\taddress carOwner = carIdToOwner[_tokenId];\n', '\trequire(carOwner != address(this));\n', '\t\n', '\t\n', '    if (carOwner != address(this)) {\n', '      carOwner.transfer(rentPrice); //\n', '    }\n', '\t\n', '    if (msg.value > rentPrice) { //if excess pay\n', '\t    uint256 purchaseExcess = SafeMath.sub(msg.value, rentPrice);\n', '\t\tmsg.sender.transfer(purchaseExcess);\n', '\t}\t\n', '  }\n', '  \n', '  \n', '  function symbol() public pure returns (string) { //ERC721\n', '    return SYMBOL;\n', '  }\n', '\n', '\n', '  function takeOwnership(uint256 _tokenId) public { //ERC721\n', '    address newOwner = msg.sender;\n', '    address oldOwner = carIdToOwner[_tokenId];\n', '\n', '    require(_addressNotNull(newOwner));\n', '    require(_approved(newOwner, _tokenId));\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '  \n', '  function allCarsInfo() public view returns (address[] owners, address[] renters, uint256[] prices, uint256[] profits) { //for web site view\n', '\t\n', '\tuint256 totalResultCars = totalSupply();\n', '\t\n', '    if (totalResultCars == 0) {\n', '        // Return an empty array\n', '      return (new address[](0),new address[](0),new uint256[](0),new uint256[](0));\n', '    }\n', '\t\n', '\taddress[] memory owners_res = new address[](totalResultCars);\n', '\taddress[] memory renters_res = new address[](totalResultCars);\n', '\tuint256[] memory prices_res = new uint256[](totalResultCars);\n', '\tuint256[] memory profits_res = new uint256[](totalResultCars);\n', '\t\n', '\tfor (uint256 carId = 0; carId < totalResultCars; carId++) {\n', '\t  owners_res[carId] = carIdToOwner[carId];\n', '\t  if (now - carIdRentStartTime[carId] <= 7200) // 2 hours of rent finished\n', '\t\trenters_res[carId] = carIdToRenter[carId];\n', '\t  else \n', '\t\trenters_res[carId] = address(0);\n', '\t\t\n', '\t  prices_res[carId] = carIdToPrice[carId];\n', '\t  profits_res[carId] = carIdToProfit[carId];\n', '\t}\n', '\t\n', '\treturn (owners_res, renters_res, prices_res, profits_res);\n', '  }  \n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view\n', '    return carIdToPrice[_tokenId];\n', '  }\n', '  \n', '  function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) { //for web site view\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalCars = totalSupply();\n', '      uint256 resultIndex = 0;\n', '\n', '      uint256 carId;\n', '      for (carId = 0; carId <= totalCars; carId++) {\n', '        if (carIdToOwner[carId] == _owner) {\n', '          result[resultIndex] = carId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256 total) { //ERC721\n', '    return cars.length;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _tokenId) public { //ERC721\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '\t_transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '\n', '  /* PRIVATE FUNCTIONS */\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return carIdToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  function _createCar(string _name, address _owner, uint256 _price) private {\n', '    Car memory _car = Car({\n', '      name: _name\n', '    });\n', '    uint256 newCarId = cars.push(_car) - 1;\n', '\n', '    require(newCarId == uint256(uint32(newCarId))); //check maximum limit of tokens\n', '\n', '    CarCreated(newCarId, _name, _owner);\n', '\n', '    carIdToPrice[newCarId] = _price;\n', '\n', '    _transfer(address(0), _owner, newCarId);\n', '  }\n', '\n', '  function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {\n', '    return _checkedAddr == carIdToOwner[_tokenId];\n', '  }\n', '\n', 'function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '    ownershipTokenCount[_to]++;\n', '    carIdToOwner[_tokenId] = _to;\n', '\n', "    // When creating new cars _from is 0x0, but we can't account that address.\n", '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete carIdToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    Transfer(_from, _to, _tokenId);\n', '  }\n', '}']
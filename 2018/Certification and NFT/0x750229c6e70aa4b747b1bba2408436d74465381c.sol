['pragma solidity ^0.4.18;\n', '\n', 'contract Ownable {\n', '\n', '  address public contractOwner;\n', '\n', '  event ContractOwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    contractOwner = msg.sender;\n', '  }\n', '\n', '  modifier onlyContractOwner() {\n', '    require(msg.sender == contractOwner);\n', '    _;\n', '  }\n', '\n', '  function transferContractOwnership(address _newOwner) public onlyContractOwner {\n', '    require(_newOwner != address(0));\n', '    ContractOwnershipTransferred(contractOwner, _newOwner);\n', '    contractOwner = _newOwner;\n', '  }\n', '  \n', '  function payoutFromContract() public onlyContractOwner {\n', '      contractOwner.transfer(this.balance);\n', '  }  \n', '\n', '}\n', '\n', '/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', '/// @author Dieter Shirley <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="b0d4d5c4d5f0d1c8d9dfddcad5de9ed3df">[email&#160;protected]</a>> (https://github.com/dete)\n', 'contract ERC721 {\n', '  // Required methods\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '\n', '  // Optional\n', '  // function name() public view returns (string name);\n', '  // function symbol() public view returns (string symbol);\n', '  // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);\n', '  // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);\n', '  // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);\n', '}\n', '\n', 'contract CryptoCinema is ERC721, Ownable {\n', '\n', '  event FilmCreated(uint256 tokenId, string name, address owner);\n', '  event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);\n', '  event Transfer(address from, address to, uint256 tokenId);\n', '\n', '  string public constant NAME = "Film";\n', '  string public constant SYMBOL = "FilmToken";\n', '\n', '  uint256 private startingPrice = 0.01 ether;\n', '\n', '  mapping (uint256 => address) public filmIdToOwner;\n', '\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '\n', '  mapping (uint256 => address) public filmIdToApproved;\n', '\n', '  mapping (uint256 => uint256) private filmIdToPrice;\n', '\n', '  /*** DATATYPES ***/\n', '  struct Film {\n', '    string name;\n', '  }\n', '\n', '  Film[] private films;\n', '\n', '  function approve(address _to, uint256 _tokenId) public { //ERC721\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '    filmIdToApproved[_tokenId] = _to;\n', '    Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '  function createFilmToken(string _name, uint256 _price) public onlyContractOwner {\n', '    _createFilm(_name, msg.sender, _price);\n', '  }\n', '\n', '  function create18FilmsTokens() public onlyContractOwner {\n', '     uint256 totalFilms = totalSupply();\n', '\t \n', '\t require (totalFilms<1); // only 3 tokens for start\n', '\t \n', '\t for (uint8 i=1; i<=18; i++)\n', '\t\t_createFilm("Film", address(this), startingPrice);\n', '\t\n', '  }\n', '  \n', '  function getFilm(uint256 _tokenId) public view returns (string filmName, uint256 sellingPrice, address owner) {\n', '    Film storage film = films[_tokenId];\n', '    filmName = film.name;\n', '    sellingPrice = filmIdToPrice[_tokenId];\n', '    owner = filmIdToOwner[_tokenId];\n', '  }\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function name() public pure returns (string) { //ERC721\n', '    return NAME;\n', '  }\n', '\n', '  function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721\n', '    owner = filmIdToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '\n', '  // Allows someone to send ether and obtain the token\n', '  function purchase(uint256 _tokenId) public payable {\n', '    address oldOwner = filmIdToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '\n', '    uint256 sellingPrice = filmIdToPrice[_tokenId];\n', '\n', '    require(oldOwner != newOwner);\n', '    require(_addressNotNull(newOwner));\n', '    require(msg.value >= sellingPrice);\n', '\n', '    uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 97), 100)); //97% to previous owner\n', '\n', '\t\n', '    // The price increases by 20% \n', '    filmIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 12), 10)); \n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '    // Pay previous tokenOwner if owner is not contract\n', '    if (oldOwner != address(this)) {\n', '      oldOwner.transfer(payment); //\n', '    }\n', '\n', '    TokenSold(_tokenId, sellingPrice, filmIdToPrice[_tokenId], oldOwner, newOwner, films[_tokenId].name);\n', '\t\n', '    if (msg.value > sellingPrice) { //if excess pay\n', '\t    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);\n', '\t\tmsg.sender.transfer(purchaseExcess);\n', '\t}\n', '  }\n', '  \n', '  function symbol() public pure returns (string) { //ERC721\n', '    return SYMBOL;\n', '  }\n', '\n', '  function takeOwnership(uint256 _tokenId) public { //ERC721\n', '    address newOwner = msg.sender;\n', '    address oldOwner = filmIdToOwner[_tokenId];\n', '\n', '    require(_addressNotNull(newOwner));\n', '    require(_approved(newOwner, _tokenId));\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view\n', '    return filmIdToPrice[_tokenId];\n', '  }\n', '\n', '  function allFilmsInfo(uint256 _startFilmId) public view returns (address[] owners, uint256[] prices) { //for web site view\n', '\t\n', '\tuint256 totalFilms = totalSupply();\n', '\t\n', '    if (totalFilms == 0 || _startFilmId >= totalFilms) {\n', '        // Return an empty array\n', '      return (new address[](0), new uint256[](0));\n', '    }\n', '\t\n', '\tuint256 indexTo;\n', '\tif (totalFilms > _startFilmId+1000)\n', '\t\tindexTo = _startFilmId + 1000;\n', '\telse \t\n', '\t\tindexTo = totalFilms;\n', '\t\t\n', '    uint256 totalResultFilms = indexTo - _startFilmId;\t\t\n', '\t\t\n', '\taddress[] memory owners_res = new address[](totalResultFilms);\n', '\tuint256[] memory prices_res = new uint256[](totalResultFilms);\n', '\t\n', '\tfor (uint256 filmId = _startFilmId; filmId < indexTo; filmId++) {\n', '\t  owners_res[filmId - _startFilmId] = filmIdToOwner[filmId];\n', '\t  prices_res[filmId - _startFilmId] = filmIdToPrice[filmId];\n', '\t}\n', '\t\n', '\treturn (owners_res, prices_res);\n', '  }\n', '  \n', '  function tokensOfOwner(address _owner) public view returns(uint256[] ownerToken) { //ERC721 for web site view\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalFilms = totalSupply();\n', '      uint256 resultIndex = 0;\n', '\n', '      uint256 filmId;\n', '      for (filmId = 0; filmId <= totalFilms; filmId++) {\n', '        if (filmIdToOwner[filmId] == _owner) {\n', '          result[resultIndex] = filmId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256 total) { //ERC721\n', '    return films.length;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _tokenId) public { //ERC721\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '\t_transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '\n', '  /* PRIVATE FUNCTIONS */\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return filmIdToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  function _createFilm(string _name, address _owner, uint256 _price) private {\n', '    Film memory _film = Film({\n', '      name: _name\n', '    });\n', '    uint256 newFilmId = films.push(_film) - 1;\n', '\n', '    require(newFilmId == uint256(uint32(newFilmId))); //check maximum limit of tokens\n', '\n', '    FilmCreated(newFilmId, _name, _owner);\n', '\n', '    filmIdToPrice[newFilmId] = _price;\n', '\n', '    _transfer(address(0), _owner, newFilmId);\n', '  }\n', '\n', '  function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {\n', '    return _checkedAddr == filmIdToOwner[_tokenId];\n', '  }\n', '\n', 'function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '    ownershipTokenCount[_to]++;\n', '    filmIdToOwner[_tokenId] = _to;\n', '\n', '    // When creating new films _from is 0x0, but we can&#39;t account that address.\n', '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete filmIdToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    Transfer(_from, _to, _tokenId);\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract Ownable {\n', '\n', '  address public contractOwner;\n', '\n', '  event ContractOwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    contractOwner = msg.sender;\n', '  }\n', '\n', '  modifier onlyContractOwner() {\n', '    require(msg.sender == contractOwner);\n', '    _;\n', '  }\n', '\n', '  function transferContractOwnership(address _newOwner) public onlyContractOwner {\n', '    require(_newOwner != address(0));\n', '    ContractOwnershipTransferred(contractOwner, _newOwner);\n', '    contractOwner = _newOwner;\n', '  }\n', '  \n', '  function payoutFromContract() public onlyContractOwner {\n', '      contractOwner.transfer(this.balance);\n', '  }  \n', '\n', '}\n', '\n', '/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', '/// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)\n', 'contract ERC721 {\n', '  // Required methods\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '  event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '\n', '  // Optional\n', '  // function name() public view returns (string name);\n', '  // function symbol() public view returns (string symbol);\n', '  // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);\n', '  // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);\n', '  // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);\n', '}\n', '\n', 'contract CryptoCinema is ERC721, Ownable {\n', '\n', '  event FilmCreated(uint256 tokenId, string name, address owner);\n', '  event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);\n', '  event Transfer(address from, address to, uint256 tokenId);\n', '\n', '  string public constant NAME = "Film";\n', '  string public constant SYMBOL = "FilmToken";\n', '\n', '  uint256 private startingPrice = 0.01 ether;\n', '\n', '  mapping (uint256 => address) public filmIdToOwner;\n', '\n', '  mapping (address => uint256) private ownershipTokenCount;\n', '\n', '  mapping (uint256 => address) public filmIdToApproved;\n', '\n', '  mapping (uint256 => uint256) private filmIdToPrice;\n', '\n', '  /*** DATATYPES ***/\n', '  struct Film {\n', '    string name;\n', '  }\n', '\n', '  Film[] private films;\n', '\n', '  function approve(address _to, uint256 _tokenId) public { //ERC721\n', '    // Caller must own token.\n', '    require(_owns(msg.sender, _tokenId));\n', '    filmIdToApproved[_tokenId] = _to;\n', '    Approval(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721\n', '    return ownershipTokenCount[_owner];\n', '  }\n', '\n', '  function createFilmToken(string _name, uint256 _price) public onlyContractOwner {\n', '    _createFilm(_name, msg.sender, _price);\n', '  }\n', '\n', '  function create18FilmsTokens() public onlyContractOwner {\n', '     uint256 totalFilms = totalSupply();\n', '\t \n', '\t require (totalFilms<1); // only 3 tokens for start\n', '\t \n', '\t for (uint8 i=1; i<=18; i++)\n', '\t\t_createFilm("Film", address(this), startingPrice);\n', '\t\n', '  }\n', '  \n', '  function getFilm(uint256 _tokenId) public view returns (string filmName, uint256 sellingPrice, address owner) {\n', '    Film storage film = films[_tokenId];\n', '    filmName = film.name;\n', '    sellingPrice = filmIdToPrice[_tokenId];\n', '    owner = filmIdToOwner[_tokenId];\n', '  }\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  function name() public pure returns (string) { //ERC721\n', '    return NAME;\n', '  }\n', '\n', '  function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721\n', '    owner = filmIdToOwner[_tokenId];\n', '    require(owner != address(0));\n', '  }\n', '\n', '  // Allows someone to send ether and obtain the token\n', '  function purchase(uint256 _tokenId) public payable {\n', '    address oldOwner = filmIdToOwner[_tokenId];\n', '    address newOwner = msg.sender;\n', '\n', '    uint256 sellingPrice = filmIdToPrice[_tokenId];\n', '\n', '    require(oldOwner != newOwner);\n', '    require(_addressNotNull(newOwner));\n', '    require(msg.value >= sellingPrice);\n', '\n', '    uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 97), 100)); //97% to previous owner\n', '\n', '\t\n', '    // The price increases by 20% \n', '    filmIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 12), 10)); \n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '    // Pay previous tokenOwner if owner is not contract\n', '    if (oldOwner != address(this)) {\n', '      oldOwner.transfer(payment); //\n', '    }\n', '\n', '    TokenSold(_tokenId, sellingPrice, filmIdToPrice[_tokenId], oldOwner, newOwner, films[_tokenId].name);\n', '\t\n', '    if (msg.value > sellingPrice) { //if excess pay\n', '\t    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);\n', '\t\tmsg.sender.transfer(purchaseExcess);\n', '\t}\n', '  }\n', '  \n', '  function symbol() public pure returns (string) { //ERC721\n', '    return SYMBOL;\n', '  }\n', '\n', '  function takeOwnership(uint256 _tokenId) public { //ERC721\n', '    address newOwner = msg.sender;\n', '    address oldOwner = filmIdToOwner[_tokenId];\n', '\n', '    require(_addressNotNull(newOwner));\n', '    require(_approved(newOwner, _tokenId));\n', '\n', '    _transfer(oldOwner, newOwner, _tokenId);\n', '  }\n', '\n', '  function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view\n', '    return filmIdToPrice[_tokenId];\n', '  }\n', '\n', '  function allFilmsInfo(uint256 _startFilmId) public view returns (address[] owners, uint256[] prices) { //for web site view\n', '\t\n', '\tuint256 totalFilms = totalSupply();\n', '\t\n', '    if (totalFilms == 0 || _startFilmId >= totalFilms) {\n', '        // Return an empty array\n', '      return (new address[](0), new uint256[](0));\n', '    }\n', '\t\n', '\tuint256 indexTo;\n', '\tif (totalFilms > _startFilmId+1000)\n', '\t\tindexTo = _startFilmId + 1000;\n', '\telse \t\n', '\t\tindexTo = totalFilms;\n', '\t\t\n', '    uint256 totalResultFilms = indexTo - _startFilmId;\t\t\n', '\t\t\n', '\taddress[] memory owners_res = new address[](totalResultFilms);\n', '\tuint256[] memory prices_res = new uint256[](totalResultFilms);\n', '\t\n', '\tfor (uint256 filmId = _startFilmId; filmId < indexTo; filmId++) {\n', '\t  owners_res[filmId - _startFilmId] = filmIdToOwner[filmId];\n', '\t  prices_res[filmId - _startFilmId] = filmIdToPrice[filmId];\n', '\t}\n', '\t\n', '\treturn (owners_res, prices_res);\n', '  }\n', '  \n', '  function tokensOfOwner(address _owner) public view returns(uint256[] ownerToken) { //ERC721 for web site view\n', '    uint256 tokenCount = balanceOf(_owner);\n', '    if (tokenCount == 0) {\n', '        // Return an empty array\n', '      return new uint256[](0);\n', '    } else {\n', '      uint256[] memory result = new uint256[](tokenCount);\n', '      uint256 totalFilms = totalSupply();\n', '      uint256 resultIndex = 0;\n', '\n', '      uint256 filmId;\n', '      for (filmId = 0; filmId <= totalFilms; filmId++) {\n', '        if (filmIdToOwner[filmId] == _owner) {\n', '          result[resultIndex] = filmId;\n', '          resultIndex++;\n', '        }\n', '      }\n', '      return result;\n', '    }\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256 total) { //ERC721\n', '    return films.length;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _tokenId) public { //ERC721\n', '    require(_owns(msg.sender, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '\t_transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721\n', '    require(_owns(_from, _tokenId));\n', '    require(_approved(_to, _tokenId));\n', '    require(_addressNotNull(_to));\n', '\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '\n', '  /* PRIVATE FUNCTIONS */\n', '  function _addressNotNull(address _to) private pure returns (bool) {\n', '    return _to != address(0);\n', '  }\n', '\n', '  function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '    return filmIdToApproved[_tokenId] == _to;\n', '  }\n', '\n', '  function _createFilm(string _name, address _owner, uint256 _price) private {\n', '    Film memory _film = Film({\n', '      name: _name\n', '    });\n', '    uint256 newFilmId = films.push(_film) - 1;\n', '\n', '    require(newFilmId == uint256(uint32(newFilmId))); //check maximum limit of tokens\n', '\n', '    FilmCreated(newFilmId, _name, _owner);\n', '\n', '    filmIdToPrice[newFilmId] = _price;\n', '\n', '    _transfer(address(0), _owner, newFilmId);\n', '  }\n', '\n', '  function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {\n', '    return _checkedAddr == filmIdToOwner[_tokenId];\n', '  }\n', '\n', 'function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '    ownershipTokenCount[_to]++;\n', '    filmIdToOwner[_tokenId] = _to;\n', '\n', "    // When creating new films _from is 0x0, but we can't account that address.\n", '    if (_from != address(0)) {\n', '      ownershipTokenCount[_from]--;\n', '      // clear any previously approved ownership exchange\n', '      delete filmIdToApproved[_tokenId];\n', '    }\n', '\n', '    // Emit the transfer event.\n', '    Transfer(_from, _to, _tokenId);\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
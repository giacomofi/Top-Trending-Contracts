['// KpopCeleb is a ERC-721 celeb (https://github.com/ethereum/eips/issues/721)\n', '// Kpop celebrity cards as digital collectibles\n', '// Kpop.io is the official website\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC721 {\n', '  function approve(address _to, uint _celebId) public;\n', '  function balanceOf(address _owner) public view returns (uint balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint _celebId) public view returns (address addr);\n', '  function takeOwnership(uint _celebId) public;\n', '  function totalSupply() public view returns (uint total);\n', '  function transferFrom(address _from, address _to, uint _celebId) public;\n', '  function transfer(address _to, uint _celebId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint celebId);\n', '  event Approval(address indexed owner, address indexed approved, uint celebId);\n', '}\n', '\n', 'contract KpopCeleb is ERC721 {\n', '  using SafeMath for uint;\n', '\n', '  address public author;\n', '  address public coauthor;\n', '\n', '  string public constant NAME = "KpopCeleb";\n', '  string public constant SYMBOL = "KpopCeleb";\n', '\n', '  uint public GROWTH_BUMP = 0.5 ether;\n', '  uint public MIN_STARTING_PRICE = 0.002 ether;\n', '  uint public PRICE_INCREASE_SCALE = 120; // 120% of previous price\n', '\n', '  struct Celeb {\n', '    string name;\n', '  }\n', '\n', '  Celeb[] public celebs;\n', '\n', '  mapping(uint => address) public celebIdToOwner;\n', '  mapping(uint => uint) public celebIdToPrice; // in wei\n', '  mapping(address => uint) public userToNumCelebs;\n', '  mapping(uint => address) public celebIdToApprovedRecipient;\n', '  mapping(uint => uint[6]) public celebIdToTraitValues;\n', '  mapping(uint => uint[6]) public celebIdToTraitBoosters;\n', '\n', '  address public KPOP_ARENA_CONTRACT_ADDRESS = 0x0;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint celebId);\n', '  event Approval(address indexed owner, address indexed approved, uint celebId);\n', '  event CelebSold(uint celebId, uint oldPrice, uint newPrice, string celebName, address prevOwner, address newOwner);\n', '\n', '  function KpopCeleb() public {\n', '    author = msg.sender;\n', '    coauthor = msg.sender;\n', '  }\n', '\n', '  function _transfer(address _from, address _to, uint _celebId) private {\n', '    require(ownerOf(_celebId) == _from);\n', '    require(!isNullAddress(_to));\n', '    require(balanceOf(_from) > 0);\n', '\n', '    uint prevBalances = balanceOf(_from) + balanceOf(_to);\n', '    celebIdToOwner[_celebId] = _to;\n', '    userToNumCelebs[_from]--;\n', '    userToNumCelebs[_to]++;\n', '\n', '    // Clear outstanding approvals\n', '    delete celebIdToApprovedRecipient[_celebId];\n', '\n', '    Transfer(_from, _to, _celebId);\n', '\n', '    assert(balanceOf(_from) + balanceOf(_to) == prevBalances);\n', '  }\n', '\n', '  function buy(uint _celebId) payable public {\n', '    address prevOwner = ownerOf(_celebId);\n', '    uint currentPrice = celebIdToPrice[_celebId];\n', '\n', '    require(prevOwner != msg.sender);\n', '    require(!isNullAddress(msg.sender));\n', '    require(msg.value >= currentPrice);\n', '\n', '    // Take a cut off the payment\n', '    uint payment = uint(SafeMath.div(SafeMath.mul(currentPrice, 92), 100));\n', '    uint leftover = SafeMath.sub(msg.value, currentPrice);\n', '    uint newPrice;\n', '\n', '    _transfer(prevOwner, msg.sender, _celebId);\n', '\n', '    if (currentPrice < GROWTH_BUMP) {\n', '      newPrice = SafeMath.mul(currentPrice, 2);\n', '    } else {\n', '      newPrice = SafeMath.div(SafeMath.mul(currentPrice, PRICE_INCREASE_SCALE), 100);\n', '    }\n', '\n', '    celebIdToPrice[_celebId] = newPrice;\n', '\n', '    if (prevOwner != address(this)) {\n', '      prevOwner.transfer(payment);\n', '    }\n', '\n', '    CelebSold(_celebId, currentPrice, newPrice,\n', '      celebs[_celebId].name, prevOwner, msg.sender);\n', '\n', '    msg.sender.transfer(leftover);\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint balance) {\n', '    return userToNumCelebs[_owner];\n', '  }\n', '\n', '  function ownerOf(uint _celebId) public view returns (address addr) {\n', '    return celebIdToOwner[_celebId];\n', '  }\n', '\n', '  function totalSupply() public view returns (uint total) {\n', '    return celebs.length;\n', '  }\n', '\n', '  function transfer(address _to, uint _celebId) public {\n', '    _transfer(msg.sender, _to, _celebId);\n', '  }\n', '\n', '  /** START FUNCTIONS FOR AUTHORS **/\n', '\n', '  function createCeleb(string _name, uint _price, address _owner, uint[6] _traitValues, uint[6] _traitBoosters) public onlyAuthors {\n', '    require(_price >= MIN_STARTING_PRICE);\n', '\n', '    address owner = _owner == 0x0 ? author : _owner;\n', '\n', '    uint celebId = celebs.push(Celeb(_name)) - 1;\n', '    celebIdToOwner[celebId] = owner;\n', '    celebIdToPrice[celebId] = _price;\n', '    celebIdToTraitValues[celebId] = _traitValues;\n', '    celebIdToTraitBoosters[celebId] = _traitBoosters;\n', '    userToNumCelebs[owner]++;\n', '  }\n', '\n', '  function updateCeleb(uint _celebId, string _name, uint[6] _traitValues, uint[6] _traitBoosters) public onlyAuthors {\n', '    require(_celebId >= 0 && _celebId < totalSupply());\n', '\n', '    celebs[_celebId].name = _name;\n', '    celebIdToTraitValues[_celebId] = _traitValues;\n', '    celebIdToTraitBoosters[_celebId] = _traitBoosters;\n', '  }\n', '\n', '  function withdraw(uint _amount, address _to) public onlyAuthors {\n', '    require(!isNullAddress(_to));\n', '    require(_amount <= this.balance);\n', '\n', '    _to.transfer(_amount);\n', '  }\n', '\n', '  function withdrawAll() public onlyAuthors {\n', '    require(author != 0x0);\n', '    require(coauthor != 0x0);\n', '\n', '    uint halfBalance = uint(SafeMath.div(this.balance, 2));\n', '\n', '    author.transfer(halfBalance);\n', '    coauthor.transfer(halfBalance);\n', '  }\n', '\n', '  function setCoAuthor(address _coauthor) public onlyAuthor {\n', '    require(!isNullAddress(_coauthor));\n', '\n', '    coauthor = _coauthor;\n', '  }\n', '\n', '  function setKpopArenaContractAddress(address _address) public onlyAuthors {\n', '    require(!isNullAddress(_address));\n', '\n', '    KPOP_ARENA_CONTRACT_ADDRESS = _address;\n', '  }\n', '\n', '  function updateTraits(uint _celebId) public onlyArena {\n', '    require(_celebId < totalSupply());\n', '\n', '    for (uint i = 0; i < 6; i++) {\n', '      uint booster = celebIdToTraitBoosters[_celebId][i];\n', '      celebIdToTraitValues[_celebId][i] = celebIdToTraitValues[_celebId][i].add(booster);\n', '    }\n', '  }\n', '\n', '  /** END FUNCTIONS FOR AUTHORS **/\n', '\n', '  function getCeleb(uint _celebId) public view returns (\n', '    string name,\n', '    uint price,\n', '    address owner,\n', '    uint[6] traitValues,\n', '    uint[6] traitBoosters\n', '  ) {\n', '    name = celebs[_celebId].name;\n', '    price = celebIdToPrice[_celebId];\n', '    owner = celebIdToOwner[_celebId];\n', '    traitValues = celebIdToTraitValues[_celebId];\n', '    traitBoosters = celebIdToTraitBoosters[_celebId];\n', '  }\n', '\n', '  /** START FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/\n', '\n', '  function approve(address _to, uint _celebId) public {\n', '    require(msg.sender == ownerOf(_celebId));\n', '\n', '    celebIdToApprovedRecipient[_celebId] = _to;\n', '\n', '    Approval(msg.sender, _to, _celebId);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _celebId) public {\n', '    require(ownerOf(_celebId) == _from);\n', '    require(isApproved(_to, _celebId));\n', '    require(!isNullAddress(_to));\n', '\n', '    _transfer(_from, _to, _celebId);\n', '  }\n', '\n', '  function takeOwnership(uint _celebId) public {\n', '    require(!isNullAddress(msg.sender));\n', '    require(isApproved(msg.sender, _celebId));\n', '\n', '    address currentOwner = celebIdToOwner[_celebId];\n', '\n', '    _transfer(currentOwner, msg.sender, _celebId);\n', '  }\n', '\n', '  /** END FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /** MODIFIERS **/\n', '\n', '  modifier onlyAuthor() {\n', '    require(msg.sender == author);\n', '    _;\n', '  }\n', '\n', '  modifier onlyAuthors() {\n', '    require(msg.sender == author || msg.sender == coauthor);\n', '    _;\n', '  }\n', '\n', '  modifier onlyArena() {\n', '    require(msg.sender == author || msg.sender == coauthor || msg.sender == KPOP_ARENA_CONTRACT_ADDRESS);\n', '    _;\n', '  }\n', '\n', '  /** FUNCTIONS THAT WONT BE USED FREQUENTLY **/\n', '\n', '  function setMinStartingPrice(uint _price) public onlyAuthors {\n', '    MIN_STARTING_PRICE = _price;\n', '  }\n', '\n', '  function setGrowthBump(uint _bump) public onlyAuthors {\n', '    GROWTH_BUMP = _bump;\n', '  }\n', '\n', '  function setPriceIncreaseScale(uint _scale) public onlyAuthors {\n', '    PRICE_INCREASE_SCALE = _scale;\n', '  }\n', '\n', '  /** PRIVATE FUNCTIONS **/\n', '\n', '  function isApproved(address _to, uint _celebId) private view returns (bool) {\n', '    return celebIdToApprovedRecipient[_celebId] == _to;\n', '  }\n', '\n', '  function isNullAddress(address _addr) private pure returns (bool) {\n', '    return _addr == 0x0;\n', '  }\n', '}']
['// KpopCeleb is a ERC-721 celeb (https://github.com/ethereum/eips/issues/721)\n', '// Kpop celebrity cards as digital collectibles\n', '// Kpop.io is the official website\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC721 {\n', '  function approve(address _to, uint _celebId) public;\n', '  function balanceOf(address _owner) public view returns (uint balance);\n', '  function implementsERC721() public pure returns (bool);\n', '  function ownerOf(uint _celebId) public view returns (address addr);\n', '  function takeOwnership(uint _celebId) public;\n', '  function totalSupply() public view returns (uint total);\n', '  function transferFrom(address _from, address _to, uint _celebId) public;\n', '  function transfer(address _to, uint _celebId) public;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint celebId);\n', '  event Approval(address indexed owner, address indexed approved, uint celebId);\n', '}\n', '\n', 'contract KpopCeleb is ERC721 {\n', '  using SafeMath for uint;\n', '\n', '  address public author;\n', '  address public coauthor;\n', '\n', '  string public constant NAME = "KpopCeleb";\n', '  string public constant SYMBOL = "KpopCeleb";\n', '\n', '  uint public GROWTH_BUMP = 0.5 ether;\n', '  uint public MIN_STARTING_PRICE = 0.002 ether;\n', '  uint public PRICE_INCREASE_SCALE = 120; // 120% of previous price\n', '\n', '  struct Celeb {\n', '    string name;\n', '  }\n', '\n', '  Celeb[] public celebs;\n', '\n', '  mapping(uint => address) public celebIdToOwner;\n', '  mapping(uint => uint) public celebIdToPrice; // in wei\n', '  mapping(address => uint) public userToNumCelebs;\n', '  mapping(uint => address) public celebIdToApprovedRecipient;\n', '  mapping(uint => uint[6]) public celebIdToTraitValues;\n', '  mapping(uint => uint[6]) public celebIdToTraitBoosters;\n', '\n', '  address public KPOP_ARENA_CONTRACT_ADDRESS = 0x0;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint celebId);\n', '  event Approval(address indexed owner, address indexed approved, uint celebId);\n', '  event CelebSold(uint celebId, uint oldPrice, uint newPrice, string celebName, address prevOwner, address newOwner);\n', '\n', '  function KpopCeleb() public {\n', '    author = msg.sender;\n', '    coauthor = msg.sender;\n', '  }\n', '\n', '  function _transfer(address _from, address _to, uint _celebId) private {\n', '    require(ownerOf(_celebId) == _from);\n', '    require(!isNullAddress(_to));\n', '    require(balanceOf(_from) > 0);\n', '\n', '    uint prevBalances = balanceOf(_from) + balanceOf(_to);\n', '    celebIdToOwner[_celebId] = _to;\n', '    userToNumCelebs[_from]--;\n', '    userToNumCelebs[_to]++;\n', '\n', '    // Clear outstanding approvals\n', '    delete celebIdToApprovedRecipient[_celebId];\n', '\n', '    Transfer(_from, _to, _celebId);\n', '\n', '    assert(balanceOf(_from) + balanceOf(_to) == prevBalances);\n', '  }\n', '\n', '  function buy(uint _celebId) payable public {\n', '    address prevOwner = ownerOf(_celebId);\n', '    uint currentPrice = celebIdToPrice[_celebId];\n', '\n', '    require(prevOwner != msg.sender);\n', '    require(!isNullAddress(msg.sender));\n', '    require(msg.value >= currentPrice);\n', '\n', '    // Take a cut off the payment\n', '    uint payment = uint(SafeMath.div(SafeMath.mul(currentPrice, 92), 100));\n', '    uint leftover = SafeMath.sub(msg.value, currentPrice);\n', '    uint newPrice;\n', '\n', '    _transfer(prevOwner, msg.sender, _celebId);\n', '\n', '    if (currentPrice < GROWTH_BUMP) {\n', '      newPrice = SafeMath.mul(currentPrice, 2);\n', '    } else {\n', '      newPrice = SafeMath.div(SafeMath.mul(currentPrice, PRICE_INCREASE_SCALE), 100);\n', '    }\n', '\n', '    celebIdToPrice[_celebId] = newPrice;\n', '\n', '    if (prevOwner != address(this)) {\n', '      prevOwner.transfer(payment);\n', '    }\n', '\n', '    CelebSold(_celebId, currentPrice, newPrice,\n', '      celebs[_celebId].name, prevOwner, msg.sender);\n', '\n', '    msg.sender.transfer(leftover);\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint balance) {\n', '    return userToNumCelebs[_owner];\n', '  }\n', '\n', '  function ownerOf(uint _celebId) public view returns (address addr) {\n', '    return celebIdToOwner[_celebId];\n', '  }\n', '\n', '  function totalSupply() public view returns (uint total) {\n', '    return celebs.length;\n', '  }\n', '\n', '  function transfer(address _to, uint _celebId) public {\n', '    _transfer(msg.sender, _to, _celebId);\n', '  }\n', '\n', '  /** START FUNCTIONS FOR AUTHORS **/\n', '\n', '  function createCeleb(string _name, uint _price, address _owner, uint[6] _traitValues, uint[6] _traitBoosters) public onlyAuthors {\n', '    require(_price >= MIN_STARTING_PRICE);\n', '\n', '    address owner = _owner == 0x0 ? author : _owner;\n', '\n', '    uint celebId = celebs.push(Celeb(_name)) - 1;\n', '    celebIdToOwner[celebId] = owner;\n', '    celebIdToPrice[celebId] = _price;\n', '    celebIdToTraitValues[celebId] = _traitValues;\n', '    celebIdToTraitBoosters[celebId] = _traitBoosters;\n', '    userToNumCelebs[owner]++;\n', '  }\n', '\n', '  function updateCeleb(uint _celebId, string _name, uint[6] _traitValues, uint[6] _traitBoosters) public onlyAuthors {\n', '    require(_celebId >= 0 && _celebId < totalSupply());\n', '\n', '    celebs[_celebId].name = _name;\n', '    celebIdToTraitValues[_celebId] = _traitValues;\n', '    celebIdToTraitBoosters[_celebId] = _traitBoosters;\n', '  }\n', '\n', '  function withdraw(uint _amount, address _to) public onlyAuthors {\n', '    require(!isNullAddress(_to));\n', '    require(_amount <= this.balance);\n', '\n', '    _to.transfer(_amount);\n', '  }\n', '\n', '  function withdrawAll() public onlyAuthors {\n', '    require(author != 0x0);\n', '    require(coauthor != 0x0);\n', '\n', '    uint halfBalance = uint(SafeMath.div(this.balance, 2));\n', '\n', '    author.transfer(halfBalance);\n', '    coauthor.transfer(halfBalance);\n', '  }\n', '\n', '  function setCoAuthor(address _coauthor) public onlyAuthor {\n', '    require(!isNullAddress(_coauthor));\n', '\n', '    coauthor = _coauthor;\n', '  }\n', '\n', '  function setKpopArenaContractAddress(address _address) public onlyAuthors {\n', '    require(!isNullAddress(_address));\n', '\n', '    KPOP_ARENA_CONTRACT_ADDRESS = _address;\n', '  }\n', '\n', '  function updateTraits(uint _celebId) public onlyArena {\n', '    require(_celebId < totalSupply());\n', '\n', '    for (uint i = 0; i < 6; i++) {\n', '      uint booster = celebIdToTraitBoosters[_celebId][i];\n', '      celebIdToTraitValues[_celebId][i] = celebIdToTraitValues[_celebId][i].add(booster);\n', '    }\n', '  }\n', '\n', '  /** END FUNCTIONS FOR AUTHORS **/\n', '\n', '  function getCeleb(uint _celebId) public view returns (\n', '    string name,\n', '    uint price,\n', '    address owner,\n', '    uint[6] traitValues,\n', '    uint[6] traitBoosters\n', '  ) {\n', '    name = celebs[_celebId].name;\n', '    price = celebIdToPrice[_celebId];\n', '    owner = celebIdToOwner[_celebId];\n', '    traitValues = celebIdToTraitValues[_celebId];\n', '    traitBoosters = celebIdToTraitBoosters[_celebId];\n', '  }\n', '\n', '  /** START FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/\n', '\n', '  function approve(address _to, uint _celebId) public {\n', '    require(msg.sender == ownerOf(_celebId));\n', '\n', '    celebIdToApprovedRecipient[_celebId] = _to;\n', '\n', '    Approval(msg.sender, _to, _celebId);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _celebId) public {\n', '    require(ownerOf(_celebId) == _from);\n', '    require(isApproved(_to, _celebId));\n', '    require(!isNullAddress(_to));\n', '\n', '    _transfer(_from, _to, _celebId);\n', '  }\n', '\n', '  function takeOwnership(uint _celebId) public {\n', '    require(!isNullAddress(msg.sender));\n', '    require(isApproved(msg.sender, _celebId));\n', '\n', '    address currentOwner = celebIdToOwner[_celebId];\n', '\n', '    _transfer(currentOwner, msg.sender, _celebId);\n', '  }\n', '\n', '  /** END FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/\n', '\n', '  function implementsERC721() public pure returns (bool) {\n', '    return true;\n', '  }\n', '\n', '  /** MODIFIERS **/\n', '\n', '  modifier onlyAuthor() {\n', '    require(msg.sender == author);\n', '    _;\n', '  }\n', '\n', '  modifier onlyAuthors() {\n', '    require(msg.sender == author || msg.sender == coauthor);\n', '    _;\n', '  }\n', '\n', '  modifier onlyArena() {\n', '    require(msg.sender == author || msg.sender == coauthor || msg.sender == KPOP_ARENA_CONTRACT_ADDRESS);\n', '    _;\n', '  }\n', '\n', '  /** FUNCTIONS THAT WONT BE USED FREQUENTLY **/\n', '\n', '  function setMinStartingPrice(uint _price) public onlyAuthors {\n', '    MIN_STARTING_PRICE = _price;\n', '  }\n', '\n', '  function setGrowthBump(uint _bump) public onlyAuthors {\n', '    GROWTH_BUMP = _bump;\n', '  }\n', '\n', '  function setPriceIncreaseScale(uint _scale) public onlyAuthors {\n', '    PRICE_INCREASE_SCALE = _scale;\n', '  }\n', '\n', '  /** PRIVATE FUNCTIONS **/\n', '\n', '  function isApproved(address _to, uint _celebId) private view returns (bool) {\n', '    return celebIdToApprovedRecipient[_celebId] == _to;\n', '  }\n', '\n', '  function isNullAddress(address _addr) private pure returns (bool) {\n', '    return _addr == 0x0;\n', '  }\n', '}']

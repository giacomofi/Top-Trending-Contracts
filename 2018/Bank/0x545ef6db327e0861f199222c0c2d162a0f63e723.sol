['pragma solidity ^0.4.20;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', '/// @author Dieter Shirley <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="fb9f9e8f9ebb9a83929496819e95d59894">[email&#160;protected]</a>> (https://github.com/dete)\n', 'contract ERC721 {\n', '    // Required methods\n', '    function totalSupply() public view returns (uint256 total);\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function ownerOf(uint256 _tokenId) public view returns (address _owner);\n', '    function approve(address _to, uint256 _tokenId) public;\n', '    function transfer(address _to, uint256 _tokenId) public;\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '\n', '    // Events\n', '    event Transfer(address from, address to, uint256 tokenId);\n', '    event Approval(address owner, address approved, uint256 tokenId);\n', '\n', '    // Optional\n', '    function name() public pure returns (string _name);\n', '    function symbol() public pure returns (string _symbol);\n', '    // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);\n', '    // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);\n', '\n', '    // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)\n', '    // function supportsInterface(bytes4 _interfaceID) external view returns (bool);\n', '}\n', '\n', 'contract cryptoChallenge is ERC721{\n', '  using SafeMath for uint256;\n', '\n', '  event Bought (uint256 indexed _tokenId, address indexed _owner, uint256 _price);\n', '  event Sold (uint256 indexed _tokenId, address indexed _owner, uint256 _price);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);\n', '  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);\n', '\n', '  address private owner;\n', '  mapping (address => bool) private admins;\n', '\n', '  uint256 private increaseLimit1 = 0.02 ether;\n', '  uint256 private increaseLimit2 = 0.5 ether;\n', '  uint256 private increaseLimit3 = 2.0 ether;\n', '  uint256 private increaseLimit4 = 5.0 ether;\n', '\n', '  uint256[] private listedTokens;\n', '  mapping (uint256 => uint256) private bet1OfToken;\n', '  mapping (uint256 => uint256) private bet2OfToken;\n', '  mapping (uint256 => uint256) private bet1deltaOfToken;\n', '  mapping (uint256 => uint256) private bet2deltaOfToken;  \n', '  mapping (uint256 => address) private ownerOfToken;\n', '  mapping (uint256 => address) private owner1OfToken;\n', '  mapping (uint256 => address) private owner2OfToken;\n', '  mapping (uint256 => address) private witnessOfToken;  \n', '  mapping (uint256 => address) private p1OfToken;\n', '  mapping (uint256 => address) private p2OfToken;    \n', '  mapping (uint256 => uint256) private price1OfToken;\n', '  mapping (uint256 => uint256) private price2OfToken;  \n', '  mapping (uint256 => uint256) private free1OfToken;\n', '  mapping (uint256 => uint256) private free2OfToken;\n', '  mapping (uint256 => address) private approvedOfToken;\n', '  mapping (uint256 => uint256) private indexOfId;\n', '  \n', '  function cryptoChallenge () public {\n', '    owner = msg.sender;\n', '    admins[owner] = true;    \n', '  }\n', '\n', '  /* Modifiers */\n', '  modifier onlyOwner() {\n', '    require(owner == msg.sender);\n', '    _;\n', '  }\n', '\n', '  modifier onlyAdmins() {\n', '    require(admins[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  modifier onlyWitness(uint256 _tokenId) {\n', '    require(msg.sender == witnessOfToken[_tokenId]);\n', '    _;\n', '  }  \n', '\n', '  /* Owner */\n', '  function setOwner (address _owner) onlyOwner() public {\n', '    owner = _owner;\n', '  }\n', '\n', '  function addAdmin (address _admin) onlyOwner() public {\n', '    admins[_admin] = true;\n', '  }\n', '\n', '  function removeAdmin (address _admin) onlyOwner() public {\n', '    delete admins[_admin];\n', '  }\n', '\n', '  /* Withdraw */\n', '  /*\n', '    NOTICE: These functions withdraw the developer&#39;s cut which is left\n', '    in the contract by `buy`. User funds are immediately sent to the old\n', '    owner in `buy`, no user funds are left in the contract.\n', '  */\n', '  function withdrawAll () onlyAdmins() public {\n', '   msg.sender.transfer(this.balance);\n', '  }\n', '\n', '  function withdrawAmount (uint256 _amount) onlyAdmins() public {\n', '    msg.sender.transfer(_amount);\n', '  }\n', '\n', '  /* Buying */\n', '  function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {\n', '    if (_price < increaseLimit1) {\n', '      return _price.mul(200).div(95);\n', '    } else if (_price < increaseLimit2) {\n', '      return _price.mul(135).div(96);\n', '    } else if (_price < increaseLimit3) {\n', '      return _price.mul(125).div(97);\n', '    } else if (_price < increaseLimit4) {\n', '      return _price.mul(117).div(97);\n', '    } else {\n', '      return _price.mul(115).div(98);\n', '    }\n', '  }\n', '\n', '  function calculateDevCut (uint256 _price) public pure returns (uint256 _devCut) {\n', '     return _price.div(20);\n', '  }\n', '\n', '  /*\n', '     Buy a country directly from the contract for the calculated price\n', '     which ensures that the owner gets a profit.  All countries that\n', '     have been listed can be bought by this method. User funds are sent\n', '     directly to the previous owner and are never stored in the contract.\n', '  */\n', '  function buy1 (uint256 _tokenId) payable public {\n', '    require(price1Of(_tokenId) > 0);\n', '    require(owner1Of(_tokenId) != address(0));\n', '    require(msg.value >= price1Of(_tokenId));\n', '    require(owner1Of(_tokenId) != msg.sender);\n', '    require(!isContract(msg.sender));\n', '    require(msg.sender != address(0));\n', '    require(now >= free1OfToken[_tokenId]);\n', '    require(now <= free2OfToken[_tokenId]);\n', '\n', '    address oldOwner = owner1Of(_tokenId);\n', '    address newOwner = msg.sender;\n', '    uint256 price = price1Of(_tokenId);\n', '    uint256 excess = msg.value.sub(price);\n', '\n', '    price1OfToken[_tokenId] = nextPrice1Of(_tokenId);\n', '\n', '    uint256 devCut = calculateDevCut(price);\n', '    oldOwner.transfer(price.sub(devCut));\n', '\n', '    if (excess > 0) {\n', '      newOwner.transfer(excess);\n', '    }\n', '\n', '    owner1OfToken[_tokenId] = newOwner;\n', '\n', '  }\n', '\n', '  function buy2 (uint256 _tokenId) payable public {\n', '    require(price2Of(_tokenId) > 0);\n', '    require(owner2Of(_tokenId) != address(0));\n', '    require(msg.value >= price2Of(_tokenId));\n', '    require(owner2Of(_tokenId) != msg.sender);\n', '    require(!isContract(msg.sender));\n', '    require(msg.sender != address(0));\n', '    require(now >= free1OfToken[_tokenId]);\n', '    require(now <= free2OfToken[_tokenId]);\n', '\n', '    address oldOwner = owner2Of(_tokenId);\n', '    address newOwner = msg.sender;\n', '    uint256 price = price2Of(_tokenId);\n', '    uint256 excess = msg.value.sub(price);\n', '\n', '    price2OfToken[_tokenId] = nextPrice2Of(_tokenId);\n', '\n', '    uint256 devCut = calculateDevCut(price);\n', '    oldOwner.transfer(price.sub(devCut));\n', '\n', '    if (excess > 0) {\n', '      newOwner.transfer(excess);\n', '    }\n', '\n', '    owner2OfToken[_tokenId] = newOwner;\n', '  }  \n', '\n', '  /* ERC721 */\n', '\n', '  function name() public pure returns (string _name) {\n', '    return "betsignature";\n', '  }\n', '\n', '  function symbol() public pure returns (string _symbol) {\n', '    return "BET";\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256 _totalSupply) {\n', '    return listedTokens.length;\n', '  }\n', '\n', '  function balanceOf (address _owner) public view returns (uint256 _balance) {\n', '    uint256 counter = 0;\n', '\n', '    for (uint256 i = 0; i < listedTokens.length; i++) {\n', '      if (ownerOf(listedTokens[i]) == _owner) {\n', '        counter++;\n', '      }\n', '    }\n', '\n', '    return counter;\n', '  }\n', '\n', '  function ownerOf(uint256 _tokenId) public view returns (address _owner) {\n', '    return ownerOfToken[_tokenId];\n', '  }\n', '\n', '  function owner1Of (uint256 _tokenId) public view returns (address _owner) {\n', '    return owner1OfToken[_tokenId];\n', '  }\n', '\n', '  function owner2Of (uint256 _tokenId) public view returns (address _owner) {\n', '    return owner2OfToken[_tokenId];\n', '  }\n', '\n', '  function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {\n', '    uint256[] memory Tokens = new uint256[](balanceOf(_owner));\n', '\n', '    uint256 TokenCounter = 0;\n', '    for (uint256 i = 0; i < listedTokens.length; i++) {\n', '      if (ownerOf(listedTokens[i]) == _owner) {\n', '        Tokens[TokenCounter] = listedTokens[i];\n', '        TokenCounter += 1;\n', '      }\n', '    }\n', '\n', '    return Tokens;\n', '  }\n', '\n', '  function tokenExists (uint256 _tokenId) public pure returns (bool _exists) {\n', '    return _tokenId == _tokenId;\n', '  }\n', '\n', '  function approvedFor(uint256 _tokenId) public view returns (address _approved) {\n', '    return approvedOfToken[_tokenId];\n', '  }\n', '\n', '  function approve(address _to, uint256 _tokenId) public {\n', '    require(msg.sender != _to);\n', '    require(tokenExists(_tokenId));\n', '    require(ownerOf(_tokenId) == msg.sender);\n', '\n', '    if (_to == 0) {\n', '      if (approvedOfToken[_tokenId] != 0) {\n', '        delete approvedOfToken[_tokenId];\n', '        Approval(msg.sender, 0, _tokenId);\n', '      }\n', '    } else {\n', '      approvedOfToken[_tokenId] = _to;\n', '      Approval(msg.sender, _to, _tokenId);\n', '    }\n', '  }\n', '\n', '  /* Transferring a country to another owner will entitle the new owner the profits from `buy` */\n', '  function transfer(address _to, uint256 _tokenId) public {\n', '    require(msg.sender == ownerOf(_tokenId));\n', '    _transfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public {\n', '    require(approvedFor(_tokenId) == msg.sender);\n', '    _transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  function _transfer(address _from, address _to, uint256 _tokenId) internal {\n', '    require(tokenExists(_tokenId));\n', '    require(ownerOf(_tokenId) == _from);\n', '    require(_to != address(0));\n', '    require(_to != address(this));\n', '\n', '    ownerOfToken[_tokenId] = _to;\n', '    approvedOfToken[_tokenId] = 0;\n', '\n', '    Transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  /* Read */\n', '  function isAdmin (address _admin) public view returns (bool _isAdmin) {\n', '    return admins[_admin];\n', '  }\n', '\n', '  function price1Of (uint256 _tokenId) public view returns (uint256 _price) {\n', '    return price1OfToken[_tokenId];\n', '  }\n', '\n', '  function price2Of (uint256 _tokenId) public view returns (uint256 _price) {\n', '    return price2OfToken[_tokenId];\n', '  }  \n', '\n', '  function free1Of (uint256 _tokenId) public view returns (uint256 _free1) {\n', '    return free1OfToken[_tokenId];\n', '  }\n', '  \n', '  function free2Of (uint256 _tokenId) public view returns (uint256 _free2) {\n', '      return free2OfToken[_tokenId];\n', '  }\n', '\n', '  function nextPrice1Of (uint256 _tokenId) public view returns (uint256 _nextPrice) {\n', '    return calculateNextPrice(price1Of(_tokenId));\n', '  }\n', '\n', '  function nextPrice2Of (uint256 _tokenId) public view returns (uint256 _nextPrice) {\n', '    return calculateNextPrice(price2Of(_tokenId));\n', '  }  \n', '\n', '  function witnessOf (uint256 _tokenId) public view returns (address _witness) {\n', '    return witnessOfToken[_tokenId];\n', '  }\n', '\n', '  function bet1Of (uint256 _tokenId) public view returns (uint256 _bet1) {\n', '    return bet1OfToken[_tokenId];\n', '  }\n', '\n', '\n', '  function bet2Of (uint256 _tokenId) public view returns (uint256 _bet2) {\n', '    return bet2OfToken[_tokenId];\n', '  }\n', '\n', '\n', '  function bet1deltaOf (uint256 _tokenId) public view returns (uint256 _bet1delta) {\n', '    return bet1deltaOfToken[_tokenId];\n', '  }\n', '\n', '  function bet2deltaOf (uint256 _tokenId) public view returns (uint256 _bet2delta) {\n', '    return bet2deltaOfToken[_tokenId];\n', '  }\n', '\n', '  function p1Of (uint256 _tokenId) public view returns (address _p1Of) {\n', '    return p1OfToken[_tokenId];\n', '  }\n', '\n', '\n', '  function p2Of (uint256 _tokenId) public view returns (address _p2Of) {\n', '    return p2OfToken[_tokenId];\n', '  }\n', '\n', '  function allOf (uint256 _tokenId) external view returns (address _owner1, address _owner2, uint256 _price1, uint256 _price2, uint256 _free1, uint256 _free2, address _witness) {\n', '    return (owner1Of(_tokenId), owner2Of(_tokenId), price1Of(_tokenId), price2Of(_tokenId), free1Of(_tokenId), free2Of(_tokenId), witnessOf(_tokenId));\n', '  }\n', '  \n', '  /* Util */\n', '  function isContract(address addr) internal view returns (bool) {\n', '    uint size;\n', '    assembly { size := extcodesize(addr) } // solium-disable-line\n', '    return size > 0;\n', '  }\n', '  \n', 'function judge(uint256 _tokenId, bool _isP1Win) onlyWitness(_tokenId) public {\n', '    require(price2OfToken[_tokenId] != 0);\n', '    require(now > free2OfToken[_tokenId]);\n', '\n', '    uint reward = bet1OfToken[_tokenId] + bet2OfToken[_tokenId];\n', '    reward -= calculateDevCut(reward);\n', '    if (_isP1Win == true) {\n', '      p1OfToken[_tokenId].transfer(reward.mul(bet1OfToken[_tokenId]).div(bet1OfToken[_tokenId] + price1OfToken[_tokenId]));\n', '      owner1OfToken[_tokenId].transfer(reward.mul(price1OfToken[_tokenId]).div(bet1OfToken[_tokenId] + price1OfToken[_tokenId]));\n', '    } else {\n', '      p2OfToken[_tokenId].transfer(reward.mul(bet2OfToken[_tokenId]).div(bet2OfToken[_tokenId] + price2OfToken[_tokenId]));\n', '      owner2OfToken[_tokenId].transfer(reward.mul(price2OfToken[_tokenId]).div(bet2OfToken[_tokenId] + price2OfToken[_tokenId]));\n', '    }\n', '  }\n', '\n', '  function accept1(uint256 _tokenId, uint256 _price2) public payable {\n', '    require(msg.sender == p2OfToken[_tokenId]);\n', '    require(msg.value >= bet2OfToken[_tokenId]);\n', '    require(_price2 > 0);\n', '    price2OfToken[_tokenId] = _price2;\n', '  }\n', '\n', '  function accept2(uint256 _tokenId) public payable {\n', '    require(msg.sender == p2OfToken[_tokenId]);\n', '    require(msg.value >= bet2deltaOfToken[_tokenId]);\n', '    bet2OfToken[_tokenId] += bet2deltaOfToken[_tokenId];\n', '    bet1deltaOfToken[_tokenId] = bet2deltaOfToken[_tokenId] = 0;\n', '  }\n', '\n', '  function cancel1(uint256 _tokenId) public {\n', '    require(msg.sender == p1OfToken[_tokenId]);\n', '    require(price2OfToken[_tokenId] == 0);\n', '    msg.sender.transfer(bet1OfToken[_tokenId]);\n', '  }\n', '  \n', '  function cancel2(uint256 _tokenId) public {\n', '    require(msg.sender == p1OfToken[_tokenId]);\n', '    require(bet1deltaOfToken[_tokenId] != 0);\n', '    msg.sender.transfer(bet1deltaOfToken[_tokenId]);\n', '    bet1deltaOfToken[_tokenId] = 0; \n', '  }\n', '  \n', '  function issueToken(address p2, address witness, uint256 bet2, uint256 price1, uint256 frozen1, uint256 frozen2) payable public {\n', '    require(msg.value >= 1000);\n', '    require(witness != msg.sender);\n', '    require(witness != p2);\n', '    require(price1 > 0);\n', '    uint i = listedTokens.length;\n', '    bet1OfToken[i] = msg.value;\n', '    bet2OfToken[i] = bet2;\n', '    witnessOfToken[i] = witness;\n', '    p1OfToken[i] = owner1OfToken[i] = msg.sender;  \n', '    p2OfToken[i] = owner2OfToken[i] = p2;    \n', '    price1OfToken[i] = price1;\n', '    free1OfToken[i] = now + frozen1;\n', '    free2OfToken[i] = now + frozen1 + frozen2;\n', '    listedTokens.push(i);\n', '  }\n', '\n', '  function addBet(uint256 _tokenId, uint256 _bet2delta) public payable {\n', '    require(msg.sender == p1OfToken[_tokenId]);\n', '    bet1deltaOfToken[_tokenId] = msg.value;\n', '    bet2deltaOfToken[_tokenId] = _bet2delta;\n', '  }\n', '}']
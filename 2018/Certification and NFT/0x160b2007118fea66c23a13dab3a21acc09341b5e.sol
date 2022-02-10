['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface ERC20 {\n', '  function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);\n', '  function mintFromICO(address _to, uint256 _amount) external  returns(bool);\n', '}\n', '\n', 'contract Ownable {\n', '  \n', '  address public owner;\n', '  \n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  \n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', 'contract CloseSale is Ownable {\n', '  \n', '  ERC20 public token;\n', '  \n', '  using SafeMath for uint;\n', '  \n', '  address public backEndOperator = msg.sender;\n', '  \n', '  address team = 0x7DDA135cDAa44Ad3D7D79AAbE562c4cEA9DEB41d; // 25% all\n', '  \n', '  address reserve = 0x34bef601666D7b2E719Ff919A04266dD07706a79; // 15% all\n', '  \n', '  mapping(address=>bool) public whitelist;\n', '  \n', '  uint256 public startCloseSale = 1527638401; // Wednesday, 30-May-18 00:00:01 UTC\n', '  \n', '  uint256 public endCloseSale = 1537228799; // Monday, 17-Sep-18 23:59:59 UTC\n', '  \n', '  uint256 public investors;\n', '  \n', '  uint256 public weisRaised;\n', '  \n', '  uint256 public dollarRaised;\n', '  \n', '  uint256 public buyPrice; //0.01 USD\n', '  \n', '  uint256 public dollarPrice;\n', '  \n', '  uint256 public soldTokens;\n', '  \n', '  event Authorized(address wlCandidate, uint timestamp);\n', '  \n', '  event Revoked(address wlCandidate, uint timestamp);\n', '  \n', '  \n', '  modifier backEnd() {\n', '    require(msg.sender == backEndOperator || msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  \n', '  constructor(uint256 _dollareth) public {\n', '    dollarPrice = _dollareth;\n', '    buyPrice = 1e16/dollarPrice; // 16 decimals because 1 cent\n', '  }\n', '  \n', '  \n', '  function setToken (ERC20 _token) public onlyOwner {\n', '    token = _token;\n', '  }\n', '  \n', '  function setDollarRate(uint256 _usdether) public onlyOwner {\n', '    dollarPrice = _usdether;\n', '    buyPrice = 1e16/dollarPrice; // 16 decimals because 1 cent\n', '  }\n', '  \n', '  function setPrice(uint256 newBuyPrice) public onlyOwner {\n', '    buyPrice = newBuyPrice;\n', '  }\n', '  \n', '  function setStartSale(uint256 newStartCloseSale) public onlyOwner {\n', '    startCloseSale = newStartCloseSale;\n', '  }\n', '  \n', '  function setEndSale(uint256 newEndCloseSaled) public onlyOwner {\n', '    endCloseSale = newEndCloseSaled;\n', '  }\n', '  \n', '  function setBackEndAddress(address newBackEndOperator) public onlyOwner {\n', '    backEndOperator = newBackEndOperator;\n', '  }\n', '  \n', '  /*******************************************************************************\n', '   * Whitelist&#39;s section */\n', '  \n', '  \n', '  function authorize(address wlCandidate) public backEnd  {\n', '    require(wlCandidate != address(0x0));\n', '    require(!isWhitelisted(wlCandidate));\n', '    whitelist[wlCandidate] = true;\n', '    investors++;\n', '    emit Authorized(wlCandidate, now);\n', '  }\n', '  \n', '  \n', '  function revoke(address wlCandidate) public  onlyOwner {\n', '    whitelist[wlCandidate] = false;\n', '    investors--;\n', '    emit Revoked(wlCandidate, now);\n', '  }\n', '  \n', '  \n', '  function isWhitelisted(address wlCandidate) public view returns(bool) {\n', '    return whitelist[wlCandidate];\n', '  }\n', '  \n', '  /*******************************************************************************\n', '   * Payable&#39;s section */\n', '  \n', '  \n', '  function isCloseSale() public constant returns(bool) {\n', '    return now >= startCloseSale && now <= endCloseSale;\n', '  }\n', '  \n', '  \n', '  function () public payable {\n', '    require(isCloseSale());\n', '    require(isWhitelisted(msg.sender));\n', '    closeSale(msg.sender, msg.value);\n', '  }\n', '  \n', '  \n', '  function closeSale(address _investor, uint256 _value) internal {\n', '    uint256 tokens = _value.mul(1e18).div(buyPrice);\n', '    token.mintFromICO(_investor, tokens);\n', '    \n', '    uint256 tokensFounders = tokens.mul(5).div(12);\n', '    token.mintFromICO(team, tokensFounders);\n', '    \n', '    uint256 tokensDevelopers = tokens.div(4);\n', '    token.mintFromICO(reserve, tokensDevelopers);\n', '    \n', '    weisRaised = weisRaised.add(msg.value);\n', '    uint256 valueInUSD = msg.value.mul(dollarPrice);\n', '    dollarRaised = dollarRaised.add(valueInUSD);\n', '    soldTokens = soldTokens.add(tokens);\n', '  }\n', '  \n', '  \n', '  function mintManual(address _investor, uint256 _value) public onlyOwner {\n', '    token.mintFromICO(_investor, _value);\n', '    uint256 tokensFounders = _value.mul(5).div(12);\n', '    token.mintFromICO(team, tokensFounders);\n', '    uint256 tokensDevelopers = _value.div(4);\n', '    token.mintFromICO(reserve, tokensDevelopers);\n', '  }\n', '  \n', '  \n', '  function transferEthFromContract(address _to, uint256 amount) public onlyOwner {\n', '    require(amount != 0);\n', '    require(_to != 0x0);\n', '    _to.transfer(amount);\n', '  }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'interface ERC20 {\n', '  function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);\n', '  function mintFromICO(address _to, uint256 _amount) external  returns(bool);\n', '}\n', '\n', 'contract Ownable {\n', '  \n', '  address public owner;\n', '  \n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  \n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', 'contract CloseSale is Ownable {\n', '  \n', '  ERC20 public token;\n', '  \n', '  using SafeMath for uint;\n', '  \n', '  address public backEndOperator = msg.sender;\n', '  \n', '  address team = 0x7DDA135cDAa44Ad3D7D79AAbE562c4cEA9DEB41d; // 25% all\n', '  \n', '  address reserve = 0x34bef601666D7b2E719Ff919A04266dD07706a79; // 15% all\n', '  \n', '  mapping(address=>bool) public whitelist;\n', '  \n', '  uint256 public startCloseSale = 1527638401; // Wednesday, 30-May-18 00:00:01 UTC\n', '  \n', '  uint256 public endCloseSale = 1537228799; // Monday, 17-Sep-18 23:59:59 UTC\n', '  \n', '  uint256 public investors;\n', '  \n', '  uint256 public weisRaised;\n', '  \n', '  uint256 public dollarRaised;\n', '  \n', '  uint256 public buyPrice; //0.01 USD\n', '  \n', '  uint256 public dollarPrice;\n', '  \n', '  uint256 public soldTokens;\n', '  \n', '  event Authorized(address wlCandidate, uint timestamp);\n', '  \n', '  event Revoked(address wlCandidate, uint timestamp);\n', '  \n', '  \n', '  modifier backEnd() {\n', '    require(msg.sender == backEndOperator || msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  \n', '  constructor(uint256 _dollareth) public {\n', '    dollarPrice = _dollareth;\n', '    buyPrice = 1e16/dollarPrice; // 16 decimals because 1 cent\n', '  }\n', '  \n', '  \n', '  function setToken (ERC20 _token) public onlyOwner {\n', '    token = _token;\n', '  }\n', '  \n', '  function setDollarRate(uint256 _usdether) public onlyOwner {\n', '    dollarPrice = _usdether;\n', '    buyPrice = 1e16/dollarPrice; // 16 decimals because 1 cent\n', '  }\n', '  \n', '  function setPrice(uint256 newBuyPrice) public onlyOwner {\n', '    buyPrice = newBuyPrice;\n', '  }\n', '  \n', '  function setStartSale(uint256 newStartCloseSale) public onlyOwner {\n', '    startCloseSale = newStartCloseSale;\n', '  }\n', '  \n', '  function setEndSale(uint256 newEndCloseSaled) public onlyOwner {\n', '    endCloseSale = newEndCloseSaled;\n', '  }\n', '  \n', '  function setBackEndAddress(address newBackEndOperator) public onlyOwner {\n', '    backEndOperator = newBackEndOperator;\n', '  }\n', '  \n', '  /*******************************************************************************\n', "   * Whitelist's section */\n", '  \n', '  \n', '  function authorize(address wlCandidate) public backEnd  {\n', '    require(wlCandidate != address(0x0));\n', '    require(!isWhitelisted(wlCandidate));\n', '    whitelist[wlCandidate] = true;\n', '    investors++;\n', '    emit Authorized(wlCandidate, now);\n', '  }\n', '  \n', '  \n', '  function revoke(address wlCandidate) public  onlyOwner {\n', '    whitelist[wlCandidate] = false;\n', '    investors--;\n', '    emit Revoked(wlCandidate, now);\n', '  }\n', '  \n', '  \n', '  function isWhitelisted(address wlCandidate) public view returns(bool) {\n', '    return whitelist[wlCandidate];\n', '  }\n', '  \n', '  /*******************************************************************************\n', "   * Payable's section */\n", '  \n', '  \n', '  function isCloseSale() public constant returns(bool) {\n', '    return now >= startCloseSale && now <= endCloseSale;\n', '  }\n', '  \n', '  \n', '  function () public payable {\n', '    require(isCloseSale());\n', '    require(isWhitelisted(msg.sender));\n', '    closeSale(msg.sender, msg.value);\n', '  }\n', '  \n', '  \n', '  function closeSale(address _investor, uint256 _value) internal {\n', '    uint256 tokens = _value.mul(1e18).div(buyPrice);\n', '    token.mintFromICO(_investor, tokens);\n', '    \n', '    uint256 tokensFounders = tokens.mul(5).div(12);\n', '    token.mintFromICO(team, tokensFounders);\n', '    \n', '    uint256 tokensDevelopers = tokens.div(4);\n', '    token.mintFromICO(reserve, tokensDevelopers);\n', '    \n', '    weisRaised = weisRaised.add(msg.value);\n', '    uint256 valueInUSD = msg.value.mul(dollarPrice);\n', '    dollarRaised = dollarRaised.add(valueInUSD);\n', '    soldTokens = soldTokens.add(tokens);\n', '  }\n', '  \n', '  \n', '  function mintManual(address _investor, uint256 _value) public onlyOwner {\n', '    token.mintFromICO(_investor, _value);\n', '    uint256 tokensFounders = _value.mul(5).div(12);\n', '    token.mintFromICO(team, tokensFounders);\n', '    uint256 tokensDevelopers = _value.div(4);\n', '    token.mintFromICO(reserve, tokensDevelopers);\n', '  }\n', '  \n', '  \n', '  function transferEthFromContract(address _to, uint256 amount) public onlyOwner {\n', '    require(amount != 0);\n', '    require(_to != 0x0);\n', '    _to.transfer(amount);\n', '  }\n', '}']
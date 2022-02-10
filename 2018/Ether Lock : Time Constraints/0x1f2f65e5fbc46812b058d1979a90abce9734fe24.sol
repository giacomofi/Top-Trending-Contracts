['pragma solidity ^0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'interface ERC20 {\n', '  function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);  \n', '  function mint (address _to, uint256 _amount) external returns (bool);\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract Crowdsale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  modifier onlyWhileOpen {\n', '      require(\n', '        (now >= preICOStartDate && now < preICOEndDate) || \n', '        (now >= ICOStartDate && now < ICOEndDate)\n', '      );\n', '      _;\n', '  }\n', '\n', '  modifier onlyWhileICOOpen {\n', '      require(now >= ICOStartDate && now < ICOEndDate);\n', '      _;\n', '  }\n', '\n', '  // The token being sold\n', '  ERC20 public token;\n', '\n', '  // Address where funds are collected\n', '  address public wallet;\n', '\n', '  // Сколько токенов покупатель получает за 1 эфир\n', '  uint256 public rate = 1000;\n', '\n', '  // Сколько эфиров привлечено в ходе PreICO, wei\n', '  uint256 public preICOWeiRaised;\n', '\n', '  // Сколько эфиров привлечено в ходе ICO, wei\n', '  uint256 public ICOWeiRaised;\n', '\n', '  // Цена ETH в центах\n', '  uint256 public ETHUSD;\n', '\n', '  // Дата начала PreICO\n', '  uint256 public preICOStartDate;\n', '\n', '  // Дата окончания PreICO\n', '  uint256 public preICOEndDate;\n', '\n', '  // Дата начала ICO\n', '  uint256 public ICOStartDate;\n', '\n', '  // Дата окончания ICO\n', '  uint256 public ICOEndDate;\n', '\n', '  // Минимальный объем привлечения средств в ходе ICO в центах\n', '  uint256 public softcap = 300000000;\n', '\n', '  // Потолок привлечения средств в ходе ICO в центах\n', '  uint256 public hardcap = 2500000000;\n', '\n', '  // Бонус реферала, %\n', '  uint8 public referalBonus = 3;\n', '\n', '  // Бонус приглашенного рефералом, %\n', '  uint8 public invitedByReferalBonus = 2; \n', '\n', '  // Whitelist\n', '  mapping(address => bool) public whitelist;\n', '\n', '  // Инвесторы, которые купили токен\n', '  mapping (address => uint256) public investors;\n', '\n', '  event TokenPurchase(address indexed buyer, uint256 value, uint256 amount);\n', '\n', '  function Crowdsale( \n', '    address _wallet, \n', '    uint256 _preICOStartDate, \n', '    uint256 _preICOEndDate,\n', '    uint256 _ICOStartDate, \n', '    uint256 _ICOEndDate,\n', '    uint256 _ETHUSD\n', '  ) public {\n', '    require(_preICOEndDate > _preICOStartDate);\n', '    require(_ICOStartDate > _preICOEndDate);\n', '    require(_ICOEndDate > _ICOStartDate);\n', '\n', '    wallet = _wallet;\n', '    preICOStartDate = _preICOStartDate;\n', '    preICOEndDate = _preICOEndDate;\n', '    ICOStartDate = _ICOStartDate;\n', '    ICOEndDate = _ICOEndDate;\n', '    ETHUSD = _ETHUSD;\n', '  }\n', '\n', '  /* Публичные методы */\n', '\n', '  // Установить стоимость токена\n', '  function setRate (uint16 _rate) public onlyOwner {\n', '    require(_rate > 0);\n', '    rate = _rate;\n', '  }\n', '\n', '  // Установить адрес кошелька для сбора средств\n', '  function setWallet (address _wallet) public onlyOwner {\n', '    require (_wallet != 0x0);\n', '    wallet = _wallet;\n', '      \n', '  }\n', '  \n', '\n', '  // Установить торгуемый токен\n', '  function setToken (ERC20 _token) public onlyOwner {\n', '    token = _token;\n', '  }\n', '  \n', '  // Установить дату начала PreICO\n', '  function setPreICOStartDate (uint256 _preICOStartDate) public onlyOwner {\n', '    require(_preICOStartDate < preICOEndDate);\n', '    preICOStartDate = _preICOStartDate;\n', '  }\n', '\n', '  // Установить дату окончания PreICO\n', '  function setPreICOEndDate (uint256 _preICOEndDate) public onlyOwner {\n', '    require(_preICOEndDate > preICOStartDate);\n', '    preICOEndDate = _preICOEndDate;\n', '  }\n', '\n', '  // Установить дату начала ICO\n', '  function setICOStartDate (uint256 _ICOStartDate) public onlyOwner {\n', '    require(_ICOStartDate < ICOEndDate);\n', '    ICOStartDate = _ICOStartDate;\n', '  }\n', '\n', '  // Установить дату окончания PreICO\n', '  function setICOEndDate (uint256 _ICOEndDate) public onlyOwner {\n', '    require(_ICOEndDate > ICOStartDate);\n', '    ICOEndDate = _ICOEndDate;\n', '  }\n', '\n', '  // Установить стоимость эфира в центах\n', '  function setETHUSD (uint256 _ETHUSD) public onlyOwner {\n', '    ETHUSD = _ETHUSD;\n', '  }\n', '\n', '  function () external payable {\n', '    address beneficiary = msg.sender;\n', '    uint256 weiAmount = msg.value;\n', '    uint256 tokens;\n', '\n', '    if(_isPreICO()){\n', '\n', '        _preValidatePreICOPurchase(beneficiary, weiAmount);\n', '        tokens = weiAmount.mul(rate.add(rate.mul(30).div(100)));\n', '        preICOWeiRaised = preICOWeiRaised.add(weiAmount);\n', '        wallet.transfer(weiAmount);\n', '        investors[beneficiary] = weiAmount;\n', '        _deliverTokens(beneficiary, tokens);\n', '        TokenPurchase(beneficiary, weiAmount, tokens);\n', '\n', '    } else if(_isICO()){\n', '\n', '        _preValidateICOPurchase(beneficiary, weiAmount);\n', '        tokens = _getTokenAmountWithBonus(weiAmount);\n', '        ICOWeiRaised = ICOWeiRaised.add(weiAmount);\n', '        investors[beneficiary] = weiAmount;\n', '        _deliverTokens(beneficiary, tokens);\n', '        TokenPurchase(beneficiary, weiAmount, tokens);\n', '\n', '    }\n', '  }\n', '\n', '    // Покупка токенов с реферальным бонусом\n', '  function buyTokensWithReferal(address _referal) public onlyWhileICOOpen payable {\n', '    address beneficiary = msg.sender;    \n', '    uint256 weiAmount = msg.value;\n', '\n', '    _preValidateICOPurchase(beneficiary, weiAmount);\n', '\n', '    uint256 tokens = _getTokenAmountWithBonus(weiAmount).add(_getTokenAmountWithReferal(weiAmount, 2));\n', '    uint256 referalTokens = _getTokenAmountWithReferal(weiAmount, 3);\n', '\n', '    ICOWeiRaised = ICOWeiRaised.add(weiAmount);\n', '    investors[beneficiary] = weiAmount;\n', '\n', '    _deliverTokens(beneficiary, tokens);\n', '    _deliverTokens(_referal, referalTokens);\n', '\n', '    TokenPurchase(beneficiary, weiAmount, tokens);\n', '  }\n', '\n', '  // Добавить адрес в whitelist\n', '  function addToWhitelist(address _beneficiary) public onlyOwner {\n', '    whitelist[_beneficiary] = true;\n', '  }\n', '\n', '  // Добавить несколько адресов в whitelist\n', '  function addManyToWhitelist(address[] _beneficiaries) public onlyOwner {\n', '    for (uint256 i = 0; i < _beneficiaries.length; i++) {\n', '      whitelist[_beneficiaries[i]] = true;\n', '    }\n', '  }\n', '\n', '  // Исключить адрес из whitelist\n', '  function removeFromWhitelist(address _beneficiary) public onlyOwner {\n', '    whitelist[_beneficiary] = false;\n', '  }\n', '\n', '  // Узнать истек ли срок проведения PreICO\n', '  function hasPreICOClosed() public view returns (bool) {\n', '    return now > preICOEndDate;\n', '  }\n', '\n', '  // Узнать истек ли срок проведения ICO\n', '  function hasICOClosed() public view returns (bool) {\n', '    return now > ICOEndDate;\n', '  }\n', '\n', '  // Перевести собранные средства на кошелек для сбора\n', '  function forwardFunds () public onlyOwner {\n', '    require(now > ICOEndDate);\n', '    require((preICOWeiRaised.add(ICOWeiRaised)).mul(ETHUSD).div(10**18) >= softcap);\n', '\n', '    wallet.transfer(ICOWeiRaised);\n', '  }\n', '\n', '  // Вернуть проинвестированные средства, если не был достигнут softcap\n', '  function refund() public {\n', '    require(now > ICOEndDate);\n', '    require(preICOWeiRaised.add(ICOWeiRaised).mul(ETHUSD).div(10**18) < softcap);\n', '    require(investors[msg.sender] > 0);\n', '    \n', '    address investor = msg.sender;\n', '    investor.transfer(investors[investor]);\n', '  }\n', '  \n', '\n', '  /* Внутренние методы */\n', '\n', '   // Проверка актуальности PreICO\n', '   function _isPreICO() internal view returns(bool) {\n', '       return now >= preICOStartDate && now < preICOEndDate;\n', '   }\n', '   \n', '   // Проверка актуальности ICO\n', '   function _isICO() internal view returns(bool) {\n', '       return now >= ICOStartDate && now < ICOEndDate;\n', '   }\n', '\n', '   // Валидация перед покупкой токенов\n', '\n', '  function _preValidatePreICOPurchase(address _beneficiary, uint256 _weiAmount) internal view {\n', '    require(_weiAmount != 0);\n', '    require(now >= preICOStartDate && now <= preICOEndDate);\n', '  }\n', '\n', '  function _preValidateICOPurchase(address _beneficiary, uint256 _weiAmount) internal view {\n', '    require(_weiAmount != 0);\n', '    require(whitelist[_beneficiary]);\n', '    require((preICOWeiRaised + ICOWeiRaised + _weiAmount).mul(ETHUSD).div(10**18) <= hardcap);\n', '    require(now >= ICOStartDate && now <= ICOEndDate);\n', '  }\n', '\n', '  // Подсчет бонусов с учетом бонусов за этап ICO и объем инвестиций\n', '  function _getTokenAmountWithBonus(uint256 _weiAmount) internal view returns(uint256) {\n', '    uint256 baseTokenAmount = _weiAmount.mul(rate);\n', '    uint256 tokenAmount = baseTokenAmount;\n', '    uint256 usdAmount = _weiAmount.mul(ETHUSD).div(10**18);\n', '\n', '    // Считаем бонусы за объем инвестиций\n', '    if(usdAmount >= 10000000){\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(7).div(100));\n', '    } else if(usdAmount >= 5000000){\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));\n', '    } else if(usdAmount >= 1000000){\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(3).div(100));\n', '    }\n', '    \n', '    // Считаем бонусы за этап ICO\n', '    if(now < ICOStartDate + 15 days) {\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(20).div(100));\n', '    } else if(now < ICOStartDate + 28 days) {\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(15).div(100));\n', '    } else if(now < ICOStartDate + 42 days) {\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(10).div(100));\n', '    } else {\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));\n', '    }\n', '\n', '    return tokenAmount;\n', '  }\n', '\n', '  // Подсчет бонусов с учетом бонусов реферальной системы\n', '  function _getTokenAmountWithReferal(uint256 _weiAmount, uint8 _percent) internal view returns(uint256) {\n', '    return _weiAmount.mul(rate).mul(_percent).div(100);\n', '  }\n', '\n', '  // Перевод токенов\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    token.mint(_beneficiary, _tokenAmount);\n', '  }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'interface ERC20 {\n', '  function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);  \n', '  function mint (address _to, uint256 _amount) external returns (bool);\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract Crowdsale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  modifier onlyWhileOpen {\n', '      require(\n', '        (now >= preICOStartDate && now < preICOEndDate) || \n', '        (now >= ICOStartDate && now < ICOEndDate)\n', '      );\n', '      _;\n', '  }\n', '\n', '  modifier onlyWhileICOOpen {\n', '      require(now >= ICOStartDate && now < ICOEndDate);\n', '      _;\n', '  }\n', '\n', '  // The token being sold\n', '  ERC20 public token;\n', '\n', '  // Address where funds are collected\n', '  address public wallet;\n', '\n', '  // Сколько токенов покупатель получает за 1 эфир\n', '  uint256 public rate = 1000;\n', '\n', '  // Сколько эфиров привлечено в ходе PreICO, wei\n', '  uint256 public preICOWeiRaised;\n', '\n', '  // Сколько эфиров привлечено в ходе ICO, wei\n', '  uint256 public ICOWeiRaised;\n', '\n', '  // Цена ETH в центах\n', '  uint256 public ETHUSD;\n', '\n', '  // Дата начала PreICO\n', '  uint256 public preICOStartDate;\n', '\n', '  // Дата окончания PreICO\n', '  uint256 public preICOEndDate;\n', '\n', '  // Дата начала ICO\n', '  uint256 public ICOStartDate;\n', '\n', '  // Дата окончания ICO\n', '  uint256 public ICOEndDate;\n', '\n', '  // Минимальный объем привлечения средств в ходе ICO в центах\n', '  uint256 public softcap = 300000000;\n', '\n', '  // Потолок привлечения средств в ходе ICO в центах\n', '  uint256 public hardcap = 2500000000;\n', '\n', '  // Бонус реферала, %\n', '  uint8 public referalBonus = 3;\n', '\n', '  // Бонус приглашенного рефералом, %\n', '  uint8 public invitedByReferalBonus = 2; \n', '\n', '  // Whitelist\n', '  mapping(address => bool) public whitelist;\n', '\n', '  // Инвесторы, которые купили токен\n', '  mapping (address => uint256) public investors;\n', '\n', '  event TokenPurchase(address indexed buyer, uint256 value, uint256 amount);\n', '\n', '  function Crowdsale( \n', '    address _wallet, \n', '    uint256 _preICOStartDate, \n', '    uint256 _preICOEndDate,\n', '    uint256 _ICOStartDate, \n', '    uint256 _ICOEndDate,\n', '    uint256 _ETHUSD\n', '  ) public {\n', '    require(_preICOEndDate > _preICOStartDate);\n', '    require(_ICOStartDate > _preICOEndDate);\n', '    require(_ICOEndDate > _ICOStartDate);\n', '\n', '    wallet = _wallet;\n', '    preICOStartDate = _preICOStartDate;\n', '    preICOEndDate = _preICOEndDate;\n', '    ICOStartDate = _ICOStartDate;\n', '    ICOEndDate = _ICOEndDate;\n', '    ETHUSD = _ETHUSD;\n', '  }\n', '\n', '  /* Публичные методы */\n', '\n', '  // Установить стоимость токена\n', '  function setRate (uint16 _rate) public onlyOwner {\n', '    require(_rate > 0);\n', '    rate = _rate;\n', '  }\n', '\n', '  // Установить адрес кошелька для сбора средств\n', '  function setWallet (address _wallet) public onlyOwner {\n', '    require (_wallet != 0x0);\n', '    wallet = _wallet;\n', '      \n', '  }\n', '  \n', '\n', '  // Установить торгуемый токен\n', '  function setToken (ERC20 _token) public onlyOwner {\n', '    token = _token;\n', '  }\n', '  \n', '  // Установить дату начала PreICO\n', '  function setPreICOStartDate (uint256 _preICOStartDate) public onlyOwner {\n', '    require(_preICOStartDate < preICOEndDate);\n', '    preICOStartDate = _preICOStartDate;\n', '  }\n', '\n', '  // Установить дату окончания PreICO\n', '  function setPreICOEndDate (uint256 _preICOEndDate) public onlyOwner {\n', '    require(_preICOEndDate > preICOStartDate);\n', '    preICOEndDate = _preICOEndDate;\n', '  }\n', '\n', '  // Установить дату начала ICO\n', '  function setICOStartDate (uint256 _ICOStartDate) public onlyOwner {\n', '    require(_ICOStartDate < ICOEndDate);\n', '    ICOStartDate = _ICOStartDate;\n', '  }\n', '\n', '  // Установить дату окончания PreICO\n', '  function setICOEndDate (uint256 _ICOEndDate) public onlyOwner {\n', '    require(_ICOEndDate > ICOStartDate);\n', '    ICOEndDate = _ICOEndDate;\n', '  }\n', '\n', '  // Установить стоимость эфира в центах\n', '  function setETHUSD (uint256 _ETHUSD) public onlyOwner {\n', '    ETHUSD = _ETHUSD;\n', '  }\n', '\n', '  function () external payable {\n', '    address beneficiary = msg.sender;\n', '    uint256 weiAmount = msg.value;\n', '    uint256 tokens;\n', '\n', '    if(_isPreICO()){\n', '\n', '        _preValidatePreICOPurchase(beneficiary, weiAmount);\n', '        tokens = weiAmount.mul(rate.add(rate.mul(30).div(100)));\n', '        preICOWeiRaised = preICOWeiRaised.add(weiAmount);\n', '        wallet.transfer(weiAmount);\n', '        investors[beneficiary] = weiAmount;\n', '        _deliverTokens(beneficiary, tokens);\n', '        TokenPurchase(beneficiary, weiAmount, tokens);\n', '\n', '    } else if(_isICO()){\n', '\n', '        _preValidateICOPurchase(beneficiary, weiAmount);\n', '        tokens = _getTokenAmountWithBonus(weiAmount);\n', '        ICOWeiRaised = ICOWeiRaised.add(weiAmount);\n', '        investors[beneficiary] = weiAmount;\n', '        _deliverTokens(beneficiary, tokens);\n', '        TokenPurchase(beneficiary, weiAmount, tokens);\n', '\n', '    }\n', '  }\n', '\n', '    // Покупка токенов с реферальным бонусом\n', '  function buyTokensWithReferal(address _referal) public onlyWhileICOOpen payable {\n', '    address beneficiary = msg.sender;    \n', '    uint256 weiAmount = msg.value;\n', '\n', '    _preValidateICOPurchase(beneficiary, weiAmount);\n', '\n', '    uint256 tokens = _getTokenAmountWithBonus(weiAmount).add(_getTokenAmountWithReferal(weiAmount, 2));\n', '    uint256 referalTokens = _getTokenAmountWithReferal(weiAmount, 3);\n', '\n', '    ICOWeiRaised = ICOWeiRaised.add(weiAmount);\n', '    investors[beneficiary] = weiAmount;\n', '\n', '    _deliverTokens(beneficiary, tokens);\n', '    _deliverTokens(_referal, referalTokens);\n', '\n', '    TokenPurchase(beneficiary, weiAmount, tokens);\n', '  }\n', '\n', '  // Добавить адрес в whitelist\n', '  function addToWhitelist(address _beneficiary) public onlyOwner {\n', '    whitelist[_beneficiary] = true;\n', '  }\n', '\n', '  // Добавить несколько адресов в whitelist\n', '  function addManyToWhitelist(address[] _beneficiaries) public onlyOwner {\n', '    for (uint256 i = 0; i < _beneficiaries.length; i++) {\n', '      whitelist[_beneficiaries[i]] = true;\n', '    }\n', '  }\n', '\n', '  // Исключить адрес из whitelist\n', '  function removeFromWhitelist(address _beneficiary) public onlyOwner {\n', '    whitelist[_beneficiary] = false;\n', '  }\n', '\n', '  // Узнать истек ли срок проведения PreICO\n', '  function hasPreICOClosed() public view returns (bool) {\n', '    return now > preICOEndDate;\n', '  }\n', '\n', '  // Узнать истек ли срок проведения ICO\n', '  function hasICOClosed() public view returns (bool) {\n', '    return now > ICOEndDate;\n', '  }\n', '\n', '  // Перевести собранные средства на кошелек для сбора\n', '  function forwardFunds () public onlyOwner {\n', '    require(now > ICOEndDate);\n', '    require((preICOWeiRaised.add(ICOWeiRaised)).mul(ETHUSD).div(10**18) >= softcap);\n', '\n', '    wallet.transfer(ICOWeiRaised);\n', '  }\n', '\n', '  // Вернуть проинвестированные средства, если не был достигнут softcap\n', '  function refund() public {\n', '    require(now > ICOEndDate);\n', '    require(preICOWeiRaised.add(ICOWeiRaised).mul(ETHUSD).div(10**18) < softcap);\n', '    require(investors[msg.sender] > 0);\n', '    \n', '    address investor = msg.sender;\n', '    investor.transfer(investors[investor]);\n', '  }\n', '  \n', '\n', '  /* Внутренние методы */\n', '\n', '   // Проверка актуальности PreICO\n', '   function _isPreICO() internal view returns(bool) {\n', '       return now >= preICOStartDate && now < preICOEndDate;\n', '   }\n', '   \n', '   // Проверка актуальности ICO\n', '   function _isICO() internal view returns(bool) {\n', '       return now >= ICOStartDate && now < ICOEndDate;\n', '   }\n', '\n', '   // Валидация перед покупкой токенов\n', '\n', '  function _preValidatePreICOPurchase(address _beneficiary, uint256 _weiAmount) internal view {\n', '    require(_weiAmount != 0);\n', '    require(now >= preICOStartDate && now <= preICOEndDate);\n', '  }\n', '\n', '  function _preValidateICOPurchase(address _beneficiary, uint256 _weiAmount) internal view {\n', '    require(_weiAmount != 0);\n', '    require(whitelist[_beneficiary]);\n', '    require((preICOWeiRaised + ICOWeiRaised + _weiAmount).mul(ETHUSD).div(10**18) <= hardcap);\n', '    require(now >= ICOStartDate && now <= ICOEndDate);\n', '  }\n', '\n', '  // Подсчет бонусов с учетом бонусов за этап ICO и объем инвестиций\n', '  function _getTokenAmountWithBonus(uint256 _weiAmount) internal view returns(uint256) {\n', '    uint256 baseTokenAmount = _weiAmount.mul(rate);\n', '    uint256 tokenAmount = baseTokenAmount;\n', '    uint256 usdAmount = _weiAmount.mul(ETHUSD).div(10**18);\n', '\n', '    // Считаем бонусы за объем инвестиций\n', '    if(usdAmount >= 10000000){\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(7).div(100));\n', '    } else if(usdAmount >= 5000000){\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));\n', '    } else if(usdAmount >= 1000000){\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(3).div(100));\n', '    }\n', '    \n', '    // Считаем бонусы за этап ICO\n', '    if(now < ICOStartDate + 15 days) {\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(20).div(100));\n', '    } else if(now < ICOStartDate + 28 days) {\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(15).div(100));\n', '    } else if(now < ICOStartDate + 42 days) {\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(10).div(100));\n', '    } else {\n', '        tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));\n', '    }\n', '\n', '    return tokenAmount;\n', '  }\n', '\n', '  // Подсчет бонусов с учетом бонусов реферальной системы\n', '  function _getTokenAmountWithReferal(uint256 _weiAmount, uint8 _percent) internal view returns(uint256) {\n', '    return _weiAmount.mul(rate).mul(_percent).div(100);\n', '  }\n', '\n', '  // Перевод токенов\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    token.mint(_beneficiary, _tokenAmount);\n', '  }\n', '}']

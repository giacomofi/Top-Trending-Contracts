['pragma solidity ^0.4.18;\n', '\n', 'contract Token {\n', '\n', '  function totalSupply () constant returns (uint256 _totalSupply);\n', '\n', '  function balanceOf (address _owner) constant returns (uint256 balance);\n', '\n', '  function transfer (address _to, uint256 _value) returns (bool success);\n', '\n', '  function transferFrom (address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '  function approve (address _spender, uint256 _value) returns (bool success);\n', '\n', '  function allowance (address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '  event Transfer (address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  event Approval (address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract SafeMath {\n', '  uint256 constant private MAX_UINT256 =\n', '  0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '  function safeAdd (uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '    assert (x <= MAX_UINT256 - y);\n', '    return x + y;\n', '  }\n', '\n', '  function safeSub (uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '    assert (x >= y);\n', '    return x - y;\n', '  }\n', '\n', '  function safeMul (uint256 x, uint256 y)  constant internal  returns (uint256 z) {\n', '    if (y == 0) return 0; // Prevent division by zero at the next line\n', '    assert (x <= MAX_UINT256 / y);\n', '    return x * y;\n', '  }\n', '  \n', '  \n', '   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '\n', 'contract AbstractToken is Token, SafeMath {\n', '\n', '  function AbstractToken () {\n', '    // Do nothing\n', '  }\n', ' \n', '  function balanceOf (address _owner) constant returns (uint256 balance) {\n', '    return accounts [_owner];\n', '  }\n', '\n', '  function transfer (address _to, uint256 _value) returns (bool success) {\n', '    if (accounts [msg.sender] < _value) return false;\n', '    if (_value > 0 && msg.sender != _to) {\n', '      accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    Transfer (msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom (address _from, address _to, uint256 _value)  returns (bool success) {\n', '    if (allowances [_from][msg.sender] < _value) return false;\n', '    if (accounts [_from] < _value) return false;\n', '\n', '    allowances [_from][msg.sender] =\n', '      safeSub (allowances [_from][msg.sender], _value);\n', '\n', '    if (_value > 0 && _from != _to) {\n', '      accounts [_from] = safeSub (accounts [_from], _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    Transfer (_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', ' \n', '  function approve (address _spender, uint256 _value) returns (bool success) {\n', '    allowances [msg.sender][_spender] = _value;\n', '    Approval (msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function allowance (address _owner, address _spender) constant\n', '  returns (uint256 remaining) {\n', '    return allowances [_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the numbers of tokens belonging\n', '   * to these token holders.\n', '   */\n', '  mapping (address => uint256) accounts;\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the mapping of addresses of\n', '   * spenders to the allowances set by these token holders to these spenders.\n', '   */\n', '  mapping (address => mapping (address => uint256)) private allowances;\n', '}\n', '\n', '\n', 'contract LicerioToken is AbstractToken {\n', '    \n', '     address public owner;\n', '     \n', '     uint256 tokenCount = 0;\n', '     \n', '     bool frozen = false;\n', '     \n', '     uint256 constant MAX_TOKEN_COUNT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '     \n', '     \n', '    modifier onlyOwner() {\n', '\t    require(owner == msg.sender);\n', '\t    _;\n', '\t}\n', '     \n', '     function LicerioToken() {\n', '         owner = msg.sender;\n', '         createTokens(100 * (10**24));\n', '     }\n', '     \n', '     function totalSupply () constant returns (uint256 _totalSupply) {\n', '        return tokenCount;\n', '     }\n', '     \n', '    function name () constant returns (string result) {\n', '\t\treturn "LICERIO";\n', '\t}\n', '\t\n', '\tfunction symbol () constant returns (string result) {\n', '\t\treturn "LCR";\n', '\t}\n', '\t\n', '\tfunction decimals () constant returns (uint result) {\n', '        return (10**18);\n', '    }\n', '    \n', '    function transfer (address _to, uint256 _value) returns (bool success) {\n', '    if (frozen) return false;\n', '    else return AbstractToken.transfer (_to, _value);\n', '  }\n', '\n', '  \n', '  function transferFrom (address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '    if (frozen) return false;\n', '    else return AbstractToken.transferFrom (_from, _to, _value);\n', '  }\n', '\n', '  \n', '  function approve (address _spender, uint256 _currentValue, uint256 _newValue)\n', '    returns (bool success) {\n', '    if (allowance (msg.sender, _spender) == _currentValue)\n', '      return approve (_spender, _newValue);\n', '    else return false;\n', '  }\n', '\n', '  function burnTokens (uint256 _value) returns (bool success) {\n', '    if (_value > accounts [msg.sender]) return false;\n', '    else if (_value > 0) {\n', '      accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '      tokenCount = safeSub (tokenCount, _value);\n', '      return true;\n', '    } else return true;\n', '  }\n', '\n', '\n', '  function createTokens (uint256 _value) returns (bool success) {\n', '    require (msg.sender == owner);\n', '\n', '    if (_value > 0) {\n', '      if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;\n', '      accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);\n', '      tokenCount = safeAdd (tokenCount, _value);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '\n', '  function setOwner (address _newOwner) {\n', '    require (msg.sender == owner);\n', '\n', '    owner = _newOwner;\n', '  }\n', '\n', '  function freezeTransfers () {\n', '    require (msg.sender == owner);\n', '\n', '    if (!frozen) {\n', '      frozen = true;\n', '      Freeze ();\n', '    }\n', '  }\n', '\n', '\n', '  function unfreezeTransfers () {\n', '    require (msg.sender == owner);\n', '\n', '    if (frozen) {\n', '      frozen = false;\n', '      Unfreeze ();\n', '    }\n', '  }\n', '\n', '  event Freeze ();\n', '\n', '  event Unfreeze ();\n', '\n', '}\n', '\n', '\n', 'contract TokenSale is LicerioToken  {\n', ' \n', '    enum State { PRIVATE_SALE, PRE_ICO, ICO_FIRST, ICO_SECOND, STOPPED, CLOSED }\n', '    \n', '    // 0 , 1 , 2 , 3 , 4 , 5\n', '    \n', '    State public currentState = State.STOPPED;\n', '\n', '    uint public tokenPrice = 250000000000000; // wei , 0.00025 eth , 0.12 usd\n', '    uint public _minAmount = 0.01 ether;\n', '\t\n', '    address public beneficiary;\n', '\t\n', '\tuint256 private BountyFound = 10 * (10**24);\n', '\tuint256 private SaleFound = 70 * (10**24);\n', '\tuint256 private PartnersFound = 5 * (10**24);\n', '\tuint256 private TeamFound = 15 * (10**24);\n', '\t\n', '\tuint256 public totalSold = 0;\n', '\t\n', '\t\n', '\tuint256 private _hardcap = 14000 ether;\n', '\tuint256 private _softcap = 2500 ether;\n', '\t\n', '\tbool private _allowedTransfers = true;\n', '\t\n', '\t\n', '    address[] public Partners;\n', '    address[] public Holders;\n', '\t\n', '\tmodifier minAmount() {\n', '        require(msg.value >= _minAmount);\n', '        _;\n', '    }\n', '    \n', '    modifier saleIsOn() {\n', '        require(currentState != State.STOPPED && currentState != State.CLOSED && totalSold < SaleFound);\n', '        _;\n', '    }\n', '    \n', '\tfunction TokenSale() {\n', '\t    owner = msg.sender;\n', '\t    beneficiary = msg.sender;\n', '\t}\n', '\t\n', '\tfunction setState(State _newState) public onlyOwner {\n', '\t    require(currentState != State.CLOSED);\n', '\t    currentState = _newState;\n', '\t}\n', '\t\n', '\tfunction setMinAmount(uint _new) public onlyOwner {\n', '\t    \n', '\t    _minAmount = _new;\n', '\t    \n', '\t}\n', '\t\n', '\tfunction allowTransfers() public onlyOwner {\n', '\t\t_allowedTransfers = true;\t\t\n', '\t}\n', '\t\n', '\tfunction stopTransfers() public onlyOwner {\n', '\t\t_allowedTransfers = false;\n', '\t}\n', '\t\n', '\tfunction stopSale() public onlyOwner {\n', '\t    currentState = State.CLOSED;\n', '\t    payoutPartners();\n', '\t    payoutBonusesToHolders();\n', '\t}\n', '\t\n', '    function setBeneficiaryAddress(address _new) public onlyOwner {\n', '        \n', '        beneficiary = _new;\n', '        \n', '    }\n', '    \n', '    function setTokenPrice(uint _price) public onlyOwner {\n', '        \n', '        tokenPrice = _price;\n', '        \n', '    }\n', '    \n', '    function addPartner(address _newPartner) public onlyOwner {\n', '        \n', '        Partners.push(_newPartner);\n', '        \n', '    }\n', '    \n', '    function payoutPartners() private returns (bool) {\n', '\n', '        if(Partners.length == 0) return false;\n', '\n', '        uint tokensToPartners = safeDiv(PartnersFound, Partners.length);\n', '        \n', '        for(uint i = 0 ; i <= Partners.length - 1; i++) {\n', '            address addr = Partners[i];\n', '            accounts[addr] = safeAdd(accounts[addr], tokensToPartners);\n', '\t        accounts[owner] = safeSub(accounts[owner], tokensToPartners);\n', '        }\n', '        \n', '        return true;\n', '        \n', '    }\n', '    \n', '    \n', '    function payoutBonusesToHolders() private returns (bool) {\n', '        \n', '        if(Holders.length == 0) return false;\n', '        \n', '        uint tokensToHolders = safeDiv(BountyFound, Holders.length);\n', '        \n', '        for(uint i = 0 ; i <= Holders.length - 1; i++) {\n', '            address addr = Holders[i];\n', '            accounts[addr] = safeAdd(accounts[addr], tokensToHolders);\n', '\t        accounts[owner] = safeSub(accounts[owner], tokensToHolders); \n', '        }\n', '        \n', '        return true;\n', '    }\n', '    \n', '\t\n', '\tfunction transferFromOwner(address _address, uint _amount) public onlyOwner returns (bool) {\n', '\t    \n', '\t    uint tokens = get_tokens_count(_amount * 1 ether);\n', '\t    \n', '\t    tokens = safeAdd(tokens, get_bounty_count(tokens));\n', '\t    \n', '\t    accounts[_address] = safeAdd(accounts[_address], tokens);\n', '\t    accounts[owner] = safeSub(accounts[owner], tokens);\n', '\t    \n', '\t    totalSold = safeAdd(totalSold, _amount);\n', '\t    \n', '\t    Holders.push(_address);\n', '\t    \n', '\t    return true;\n', '\n', '\t}\n', '\t\n', '\n', '\t\n', '\tfunction transferPayable(address _address, uint _amount) private returns (bool) {\n', '\t    \n', '\t    if(SaleFound < _amount) return false;\n', '\t    \n', '\t    accounts[_address] = safeAdd(accounts[_address], _amount);\n', '\t    accounts[owner] = safeSub(accounts[owner], _amount);\n', '\t    \n', '\t    totalSold = safeAdd(totalSold, _amount);\n', '\t    \n', '\t    Holders.push(_address);\n', '\t    \n', '\t    return true;\n', '\t    \n', '\t}\n', '\t\n', '\t\n', '\tfunction buyLCRTokens() public saleIsOn() minAmount() payable {\n', '\t  \n', '\t    \n', '\t    uint tokens = get_tokens_count(msg.value);\n', '\t\trequire(transferPayable(msg.sender , tokens));\n', '\t\tif(_allowedTransfers) {\n', '\t\t\tbeneficiary.transfer(msg.value);\n', '\t    }\n', '\t    \n', '\t}\n', '\t\n', '\t\n', '\tfunction get_tokens_count(uint _amount) private returns (uint) {\n', '\t    \n', '\t     uint currentPrice = tokenPrice;\n', '\t     uint tokens = safeDiv( safeMul(_amount, decimals()), currentPrice ) ;\n', '    \t return tokens;\n', '\t    \n', '\t}\n', '\t\n', '\t\n', '\tfunction get_bounty_count(uint _tokens) private returns (uint) {\n', '\t\n', '\t    uint bonuses = 0;\n', '\t\n', '\t    if(currentState == State.PRIVATE_SALE) {\n', '\t        bonuses = _tokens ;\n', '\t    }\n', '\t    \n', '\t    if(currentState == State.PRE_ICO) {\n', '\t        bonuses = safeDiv(_tokens , 2);\n', '\t    }\n', '\t    \n', '\t    if(currentState == State.ICO_FIRST) {\n', '\t         bonuses = safeDiv(_tokens , 4);\n', '\t    }\n', '\t    \n', '\t    if(currentState == State.ICO_SECOND) {\n', '\t         bonuses = safeDiv(_tokens , 5);\n', '\t    }\n', '\t    \n', '\t    if(BountyFound < bonuses) {\n', '\t        bonuses = BountyFound;\n', '\t    }\n', '\t    \n', '\t    if(bonuses > 0) {\n', '\t        safeSub(BountyFound, bonuses);\n', '\t    }\n', '\n', '\t    return bonuses;\n', '\t\n', '\t}\n', '\t\n', '\tfunction() external payable {\n', '      buyLCRTokens();\n', '    }\n', '\t\n', '    \n', '}']
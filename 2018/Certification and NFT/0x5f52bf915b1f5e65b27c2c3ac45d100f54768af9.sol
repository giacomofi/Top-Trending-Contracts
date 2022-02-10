['pragma solidity ^0.4.18;\n', '\n', 'contract Token {\n', '\n', '  function totalSupply () constant returns (uint256 _totalSupply);\n', '\n', '  function balanceOf (address _owner) constant returns (uint256 balance);\n', '\n', '  function transfer (address _to, uint256 _value) returns (bool success);\n', '\n', '  function transferFrom (address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '  function approve (address _spender, uint256 _value) returns (bool success);\n', '\n', '  function allowance (address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '  event Transfer (address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  event Approval (address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract SafeMath {\n', '  uint256 constant private MAX_UINT256 =\n', '  0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '  function safeAdd (uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '    assert (x <= MAX_UINT256 - y);\n', '    return x + y;\n', '  }\n', '\n', '  function safeSub (uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '    assert (x >= y);\n', '    return x - y;\n', '  }\n', '\n', '  function safeMul (uint256 x, uint256 y)  constant internal  returns (uint256 z) {\n', '    if (y == 0) return 0; // Prevent division by zero at the next line\n', '    assert (x <= MAX_UINT256 / y);\n', '    return x * y;\n', '  }\n', '  \n', '  \n', '   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '\n', 'contract AbstractToken is Token, SafeMath {\n', '\n', '  function AbstractToken () {\n', '    // Do nothing\n', '  }\n', ' \n', '  function balanceOf (address _owner) constant returns (uint256 balance) {\n', '    return accounts [_owner];\n', '  }\n', '\n', '  function transfer (address _to, uint256 _value) returns (bool success) {\n', '    if (accounts [msg.sender] < _value) return false;\n', '    if (_value > 0 && msg.sender != _to) {\n', '      accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    Transfer (msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom (address _from, address _to, uint256 _value)  returns (bool success) {\n', '    if (allowances [_from][msg.sender] < _value) return false;\n', '    if (accounts [_from] < _value) return false;\n', '\n', '    allowances [_from][msg.sender] =\n', '      safeSub (allowances [_from][msg.sender], _value);\n', '\n', '    if (_value > 0 && _from != _to) {\n', '      accounts [_from] = safeSub (accounts [_from], _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    Transfer (_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', ' \n', '  function approve (address _spender, uint256 _value) returns (bool success) {\n', '    allowances [msg.sender][_spender] = _value;\n', '    Approval (msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function allowance (address _owner, address _spender) constant\n', '  returns (uint256 remaining) {\n', '    return allowances [_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the numbers of tokens belonging\n', '   * to these token holders.\n', '   */\n', '  mapping (address => uint256) accounts;\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the mapping of addresses of\n', '   * spenders to the allowances set by these token holders to these spenders.\n', '   */\n', '  mapping (address => mapping (address => uint256)) private allowances;\n', '}\n', '\n', '\n', 'contract TerraEcoToken is AbstractToken {\n', '    \n', '     address public owner;\n', '     \n', '     uint256 tokenCount = 0;\n', '     \n', '     bool frozen = false;\n', '     \n', '     uint256 constant MAX_TOKEN_COUNT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '     \n', '    uint public constant _decimals = (10**8);\n', '     \n', '    modifier onlyOwner() {\n', '\t    require(owner == msg.sender);\n', '\t    _;\n', '\t}\n', '     \n', '    function TerraEcoToken() {\n', '         owner = msg.sender;\n', '         createTokens(200 * (10**14));\n', '     }\n', '     \n', '    function totalSupply () constant returns (uint256 _totalSupply) {\n', '        return tokenCount;\n', '     }\n', '     \n', '    function name () constant returns (string result) {\n', '            return "TerraEcoToken";\n', '    }\n', '\t\n', '    function symbol () constant returns (string result) {\n', '            return "TET";\n', '    }\n', '\t\n', '    function decimals () constant returns (uint result) {\n', '        return 8;\n', '    }\n', '    \n', '    function transfer (address _to, uint256 _value) returns (bool success) {\n', '    if (frozen) return false;\n', '    else return AbstractToken.transfer (_to, _value);\n', '  }\n', '\n', '  \n', '  function transferFrom (address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '    if (frozen) return false;\n', '    else return AbstractToken.transferFrom (_from, _to, _value);\n', '  }\n', '\n', '  \n', '  function approve (address _spender, uint256 _currentValue, uint256 _newValue)\n', '    returns (bool success) {\n', '    if (allowance (msg.sender, _spender) == _currentValue)\n', '      return approve (_spender, _newValue);\n', '    else return false;\n', '  }\n', '\n', '  function burnTokens (uint256 _value) returns (bool success) {\n', '    if (_value > accounts [msg.sender]) return false;\n', '    else if (_value > 0) {\n', '      accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '      tokenCount = safeSub (tokenCount, _value);\n', '      return true;\n', '    } else return true;\n', '  }\n', '\n', '\n', '  function createTokens (uint256 _value) returns (bool success) {\n', '    require (msg.sender == owner);\n', '\n', '    if (_value > 0) {\n', '      if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;\n', '      accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);\n', '      tokenCount = safeAdd (tokenCount, _value);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '\n', '  function setOwner (address _newOwner) {\n', '    require (msg.sender == owner);\n', '\n', '    owner = _newOwner;\n', '  }\n', '\n', '  function freezeTransfers () {\n', '    require (msg.sender == owner);\n', '\n', '    if (!frozen) {\n', '      frozen = true;\n', '      Freeze ();\n', '    }\n', '  }\n', '\n', '\n', '  function unfreezeTransfers () {\n', '    require (msg.sender == owner);\n', '\n', '    if (frozen) {\n', '      frozen = false;\n', '      Unfreeze ();\n', '    }\n', '  }\n', '\n', '  event Freeze ();\n', '\n', '  event Unfreeze ();\n', '\n', '}\n', '\n', '\n', 'contract TokenSale is TerraEcoToken  {\n', ' \n', '    enum State { ICO_FIRST, ICO_SECOND, STOPPED, CLOSED }\n', '    \n', '    // 0 , 1 , 2 , 3 \n', '    \n', '    State public currentState = State.ICO_FIRST;\n', '\n', '    uint public tokenPrice = 250000000000000; // wei , 0.00025 eth , 0.12 usd\n', '    uint public _minAmount = 0.025 ether;\n', '\t\n', '    address public beneficiary;\n', '\t\n', '    uint256 public totalSold = 0;\n', '\n', '    uint256 private _hardcap = 30000 ether;\n', '    uint256 private _softcap = 3750 ether;\n', '\t\n', '    bool private _allowedTransfers = true;\n', '\t\n', '    modifier minAmount() {\n', '        require(msg.value >= _minAmount);\n', '        _;\n', '    }\n', '    \n', '    modifier saleIsOn() {\n', '        require(currentState != State.STOPPED && currentState != State.CLOSED);\n', '        _;\n', '    }\n', '    \n', '    function TokenSale() {\n', '        owner = msg.sender;\n', '        beneficiary = msg.sender;\n', '    }\n', '\n', '    function setState(State _newState) public onlyOwner {\n', '        require(currentState != State.CLOSED);\n', '        currentState = _newState;\n', '    }\n', '\n', '    function setMinAmount(uint _new) public onlyOwner {\n', '\n', '        _minAmount = _new;\n', '\n', '    }\n', '\n', '    function allowTransfers() public onlyOwner {\n', '            _allowedTransfers = true;\t\t\n', '    }\n', '\n', '    function stopTransfers() public onlyOwner {\n', '        \n', '            _allowedTransfers = false;\n', '            \n', '    }\n', '\n', '    function stopSale() public onlyOwner {\n', '        \n', '        currentState = State.CLOSED;\n', '        \n', '    }\n', '\t\n', '    function setBeneficiaryAddress(address _new) public onlyOwner {\n', '        \n', '        beneficiary = _new;\n', '        \n', '    }\n', '\n', '\n', '    function transferPayable(address _address, uint _amount) private returns (bool) {\n', '\n', '        accounts[_address] = safeAdd(accounts[_address], _amount);\n', '        accounts[owner] = safeSub(accounts[owner], _amount);\n', '\n', '        totalSold = safeAdd(totalSold, _amount);\n', '\n', '\n', '        return true;\n', '\n', '    }\n', '\t\n', '\t\n', '    function getTokens() public saleIsOn() minAmount() payable {\n', '\n', '\n', '        uint tokens = get_tokens_count(msg.value);\n', '        require(transferPayable(msg.sender , tokens));\n', '        if(_allowedTransfers) { beneficiary.transfer(msg.value); }\n', '\n', '    }\n', '\n', '\t\n', '    function get_tokens_count(uint _amount) private returns (uint) {\n', '\n', '         uint currentPrice = tokenPrice;\n', '         uint tokens = safeDiv( safeMul(_amount, _decimals), currentPrice ) ;\n', '         tokens = safeAdd(tokens, get_bounty_count(tokens));\n', '         return tokens;\n', '\n', '    }\n', '\t\n', '\t\n', '    function get_bounty_count(uint _tokens) private returns (uint) {\n', '\n', '        uint bonuses = 0;\n', '\n', '\n', '        if(currentState == State.ICO_FIRST) {\n', '             bonuses = _tokens * 30 / 100;\n', '        }\n', '\n', '        if(currentState == State.ICO_SECOND) {\n', '             bonuses = _tokens * 30 / 100;\n', '        }\n', '\n', '        return bonuses;\n', '\n', '    }\n', '\t\n', '    function() external payable {\n', '      getTokens();\n', '    }\n', '\t\n', '    \n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract Token {\n', '\n', '  function totalSupply () constant returns (uint256 _totalSupply);\n', '\n', '  function balanceOf (address _owner) constant returns (uint256 balance);\n', '\n', '  function transfer (address _to, uint256 _value) returns (bool success);\n', '\n', '  function transferFrom (address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '  function approve (address _spender, uint256 _value) returns (bool success);\n', '\n', '  function allowance (address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '  event Transfer (address indexed _from, address indexed _to, uint256 _value);\n', '\n', '  event Approval (address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract SafeMath {\n', '  uint256 constant private MAX_UINT256 =\n', '  0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '  function safeAdd (uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '    assert (x <= MAX_UINT256 - y);\n', '    return x + y;\n', '  }\n', '\n', '  function safeSub (uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '    assert (x >= y);\n', '    return x - y;\n', '  }\n', '\n', '  function safeMul (uint256 x, uint256 y)  constant internal  returns (uint256 z) {\n', '    if (y == 0) return 0; // Prevent division by zero at the next line\n', '    assert (x <= MAX_UINT256 / y);\n', '    return x * y;\n', '  }\n', '  \n', '  \n', '   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', '\n', 'contract AbstractToken is Token, SafeMath {\n', '\n', '  function AbstractToken () {\n', '    // Do nothing\n', '  }\n', ' \n', '  function balanceOf (address _owner) constant returns (uint256 balance) {\n', '    return accounts [_owner];\n', '  }\n', '\n', '  function transfer (address _to, uint256 _value) returns (bool success) {\n', '    if (accounts [msg.sender] < _value) return false;\n', '    if (_value > 0 && msg.sender != _to) {\n', '      accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    Transfer (msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom (address _from, address _to, uint256 _value)  returns (bool success) {\n', '    if (allowances [_from][msg.sender] < _value) return false;\n', '    if (accounts [_from] < _value) return false;\n', '\n', '    allowances [_from][msg.sender] =\n', '      safeSub (allowances [_from][msg.sender], _value);\n', '\n', '    if (_value > 0 && _from != _to) {\n', '      accounts [_from] = safeSub (accounts [_from], _value);\n', '      accounts [_to] = safeAdd (accounts [_to], _value);\n', '    }\n', '    Transfer (_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', ' \n', '  function approve (address _spender, uint256 _value) returns (bool success) {\n', '    allowances [msg.sender][_spender] = _value;\n', '    Approval (msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function allowance (address _owner, address _spender) constant\n', '  returns (uint256 remaining) {\n', '    return allowances [_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the numbers of tokens belonging\n', '   * to these token holders.\n', '   */\n', '  mapping (address => uint256) accounts;\n', '\n', '  /**\n', '   * Mapping from addresses of token holders to the mapping of addresses of\n', '   * spenders to the allowances set by these token holders to these spenders.\n', '   */\n', '  mapping (address => mapping (address => uint256)) private allowances;\n', '}\n', '\n', '\n', 'contract TerraEcoToken is AbstractToken {\n', '    \n', '     address public owner;\n', '     \n', '     uint256 tokenCount = 0;\n', '     \n', '     bool frozen = false;\n', '     \n', '     uint256 constant MAX_TOKEN_COUNT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '     \n', '    uint public constant _decimals = (10**8);\n', '     \n', '    modifier onlyOwner() {\n', '\t    require(owner == msg.sender);\n', '\t    _;\n', '\t}\n', '     \n', '    function TerraEcoToken() {\n', '         owner = msg.sender;\n', '         createTokens(200 * (10**14));\n', '     }\n', '     \n', '    function totalSupply () constant returns (uint256 _totalSupply) {\n', '        return tokenCount;\n', '     }\n', '     \n', '    function name () constant returns (string result) {\n', '            return "TerraEcoToken";\n', '    }\n', '\t\n', '    function symbol () constant returns (string result) {\n', '            return "TET";\n', '    }\n', '\t\n', '    function decimals () constant returns (uint result) {\n', '        return 8;\n', '    }\n', '    \n', '    function transfer (address _to, uint256 _value) returns (bool success) {\n', '    if (frozen) return false;\n', '    else return AbstractToken.transfer (_to, _value);\n', '  }\n', '\n', '  \n', '  function transferFrom (address _from, address _to, uint256 _value)\n', '    returns (bool success) {\n', '    if (frozen) return false;\n', '    else return AbstractToken.transferFrom (_from, _to, _value);\n', '  }\n', '\n', '  \n', '  function approve (address _spender, uint256 _currentValue, uint256 _newValue)\n', '    returns (bool success) {\n', '    if (allowance (msg.sender, _spender) == _currentValue)\n', '      return approve (_spender, _newValue);\n', '    else return false;\n', '  }\n', '\n', '  function burnTokens (uint256 _value) returns (bool success) {\n', '    if (_value > accounts [msg.sender]) return false;\n', '    else if (_value > 0) {\n', '      accounts [msg.sender] = safeSub (accounts [msg.sender], _value);\n', '      tokenCount = safeSub (tokenCount, _value);\n', '      return true;\n', '    } else return true;\n', '  }\n', '\n', '\n', '  function createTokens (uint256 _value) returns (bool success) {\n', '    require (msg.sender == owner);\n', '\n', '    if (_value > 0) {\n', '      if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;\n', '      accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);\n', '      tokenCount = safeAdd (tokenCount, _value);\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '\n', '  function setOwner (address _newOwner) {\n', '    require (msg.sender == owner);\n', '\n', '    owner = _newOwner;\n', '  }\n', '\n', '  function freezeTransfers () {\n', '    require (msg.sender == owner);\n', '\n', '    if (!frozen) {\n', '      frozen = true;\n', '      Freeze ();\n', '    }\n', '  }\n', '\n', '\n', '  function unfreezeTransfers () {\n', '    require (msg.sender == owner);\n', '\n', '    if (frozen) {\n', '      frozen = false;\n', '      Unfreeze ();\n', '    }\n', '  }\n', '\n', '  event Freeze ();\n', '\n', '  event Unfreeze ();\n', '\n', '}\n', '\n', '\n', 'contract TokenSale is TerraEcoToken  {\n', ' \n', '    enum State { ICO_FIRST, ICO_SECOND, STOPPED, CLOSED }\n', '    \n', '    // 0 , 1 , 2 , 3 \n', '    \n', '    State public currentState = State.ICO_FIRST;\n', '\n', '    uint public tokenPrice = 250000000000000; // wei , 0.00025 eth , 0.12 usd\n', '    uint public _minAmount = 0.025 ether;\n', '\t\n', '    address public beneficiary;\n', '\t\n', '    uint256 public totalSold = 0;\n', '\n', '    uint256 private _hardcap = 30000 ether;\n', '    uint256 private _softcap = 3750 ether;\n', '\t\n', '    bool private _allowedTransfers = true;\n', '\t\n', '    modifier minAmount() {\n', '        require(msg.value >= _minAmount);\n', '        _;\n', '    }\n', '    \n', '    modifier saleIsOn() {\n', '        require(currentState != State.STOPPED && currentState != State.CLOSED);\n', '        _;\n', '    }\n', '    \n', '    function TokenSale() {\n', '        owner = msg.sender;\n', '        beneficiary = msg.sender;\n', '    }\n', '\n', '    function setState(State _newState) public onlyOwner {\n', '        require(currentState != State.CLOSED);\n', '        currentState = _newState;\n', '    }\n', '\n', '    function setMinAmount(uint _new) public onlyOwner {\n', '\n', '        _minAmount = _new;\n', '\n', '    }\n', '\n', '    function allowTransfers() public onlyOwner {\n', '            _allowedTransfers = true;\t\t\n', '    }\n', '\n', '    function stopTransfers() public onlyOwner {\n', '        \n', '            _allowedTransfers = false;\n', '            \n', '    }\n', '\n', '    function stopSale() public onlyOwner {\n', '        \n', '        currentState = State.CLOSED;\n', '        \n', '    }\n', '\t\n', '    function setBeneficiaryAddress(address _new) public onlyOwner {\n', '        \n', '        beneficiary = _new;\n', '        \n', '    }\n', '\n', '\n', '    function transferPayable(address _address, uint _amount) private returns (bool) {\n', '\n', '        accounts[_address] = safeAdd(accounts[_address], _amount);\n', '        accounts[owner] = safeSub(accounts[owner], _amount);\n', '\n', '        totalSold = safeAdd(totalSold, _amount);\n', '\n', '\n', '        return true;\n', '\n', '    }\n', '\t\n', '\t\n', '    function getTokens() public saleIsOn() minAmount() payable {\n', '\n', '\n', '        uint tokens = get_tokens_count(msg.value);\n', '        require(transferPayable(msg.sender , tokens));\n', '        if(_allowedTransfers) { beneficiary.transfer(msg.value); }\n', '\n', '    }\n', '\n', '\t\n', '    function get_tokens_count(uint _amount) private returns (uint) {\n', '\n', '         uint currentPrice = tokenPrice;\n', '         uint tokens = safeDiv( safeMul(_amount, _decimals), currentPrice ) ;\n', '         tokens = safeAdd(tokens, get_bounty_count(tokens));\n', '         return tokens;\n', '\n', '    }\n', '\t\n', '\t\n', '    function get_bounty_count(uint _tokens) private returns (uint) {\n', '\n', '        uint bonuses = 0;\n', '\n', '\n', '        if(currentState == State.ICO_FIRST) {\n', '             bonuses = _tokens * 30 / 100;\n', '        }\n', '\n', '        if(currentState == State.ICO_SECOND) {\n', '             bonuses = _tokens * 30 / 100;\n', '        }\n', '\n', '        return bonuses;\n', '\n', '    }\n', '\t\n', '    function() external payable {\n', '      getTokens();\n', '    }\n', '\t\n', '    \n', '}']
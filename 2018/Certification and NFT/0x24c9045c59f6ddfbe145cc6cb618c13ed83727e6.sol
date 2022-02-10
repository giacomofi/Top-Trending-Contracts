['pragma solidity ^0.4.16;\n', '\n', 'contract ERC223 {\n', '  \n', '  function balanceOf(address who) constant returns (uint);\n', '  \n', '  function name() constant returns (string _name);\n', '  function symbol() constant returns (string _symbol);\n', '  function decimals() constant returns (uint8 _decimals);\n', '   \n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', '\n', 'contract ContractReceiver {\n', '     \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    \n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data){\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', ' /**\n', ' * ERC23 token by Dexaran\n', ' *\n', ' * https://github.com/Dexaran/ERC23-tokens\n', ' */\n', ' \n', ' \n', ' /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */\n', 'contract SafeMath {\n', '    uint256 constant public MAX_UINT256 =\n', '    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert(x <= MAX_UINT256 - y);\n', '        return x + y;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert(x >= y);\n', '        return x - y;\n', '    }\n', '\n', '    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (y == 0) return 0;\n', '        assert(x <= MAX_UINT256 / y);\n', '        return x * y;\n', '    }\n', '}\n', ' \n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    assert(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    assert(!halted);\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    assert(halted);\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', 'contract Tablow is ERC223, SafeMath, Haltable {\n', '\n', '  mapping(address => uint) balances;\n', '  \n', '  string public symbol = "TC";\n', '    string public name = "Tablow Club";\n', '    uint8 public decimals = 18;\n', '    uint256  _totalSupply = 0;\n', '    uint256 _MaxDistribPublicSupply = 0;\n', '    uint256 _OwnerDistribSupply = 0;\n', '    uint256 _CurrentDistribPublicSupply = 0;\n', '    uint256 _FreeTokens = 0;\n', '    uint256 _Multiplier1 = 2;\n', '    uint256 _Multiplier2 = 3;\n', '    uint256 _LimitMultiplier1 = 4e15;\n', '    uint256 _LimitMultiplier2 = 8e15;\n', '    uint256 _HighDonateLimit = 5e16;\n', '    uint256 _BonusTokensPerETHdonated = 0;\n', '    address _DistribFundsReceiverAddress = 0;\n', '    address _remainingTokensReceiverAddress = 0;\n', '    address owner = 0;\n', '    bool setupDone = false;\n', '    bool IsDistribRunning = false;\n', '    bool DistribStarted = false;\n', '  \n', '  \n', '  // Function to access name of token .\n', '  function name() constant returns (string _name) {\n', '      return name;\n', '  }\n', '  // Function to access symbol of token .\n', '  function symbol() constant returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '  // Function to access decimals of token .\n', '  function decimals() constant returns (uint8 _decimals) {\n', '      return decimals;\n', '  }\n', '  // Function to access total supply of tokens .\n', '   \n', '  \n', '   event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed _owner, uint256 _value);\n', '\n', '   \n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => bool) public Claimed;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function Tablow() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function() public payable {\n', '        if (IsDistribRunning) {\n', '            uint256 _amount;\n', '            if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();\n', '            if (!_DistribFundsReceiverAddress.send(msg.value)) revert();\n', '            if (Claimed[msg.sender] == false) {\n', '                _amount = _FreeTokens * 1e18;\n', '                _CurrentDistribPublicSupply += _amount;\n', '                balances[msg.sender] += _amount;\n', '                _totalSupply += _amount;\n', '                Transfer(this, msg.sender, _amount);\n', '                Claimed[msg.sender] = true;\n', '            }\n', '\n', '            require(msg.value <= _HighDonateLimit);\n', '\n', '            if (msg.value >= 1e15) {\n', '                if (msg.value >= _LimitMultiplier2) {\n', '                    _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;\n', '                } else {\n', '                    if (msg.value >= _LimitMultiplier1) {\n', '                        _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;\n', '                    } else {\n', '\n', '                        _amount = msg.value * _BonusTokensPerETHdonated;\n', '\n', '                    }\n', '\n', '                }\n', '\n', '                _CurrentDistribPublicSupply += _amount;\n', '                balances[msg.sender] += _amount;\n', '                _totalSupply += _amount;\n', '                Transfer(this, msg.sender, _amount);\n', '            }\n', '\n', '\n', '\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {\n', '        if (msg.sender == owner && !setupDone) {\n', '            symbol = tokenSymbol;\n', '            name = tokenName;\n', '            _FreeTokens = FreeTokens;\n', '            _BonusTokensPerETHdonated = BonusTokensPerETHdonated;\n', '            _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;\n', '            if (OwnerDistribSupply > 0) {\n', '                _OwnerDistribSupply = OwnerDistribSupply * 1e18;\n', '                _totalSupply = _OwnerDistribSupply;\n', '                balances[owner] = _totalSupply;\n', '                _CurrentDistribPublicSupply += _totalSupply;\n', '                Transfer(this, owner, _totalSupply);\n', '            }\n', '            _DistribFundsReceiverAddress = DistribFundsReceiverAddress;\n', '            if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;\n', '            _remainingTokensReceiverAddress = remainingTokensReceiverAddress;\n', '\n', '            setupDone = true;\n', '        }\n', '    }\n', '\n', '    function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {\n', '        _Multiplier1 = Multiplier1inX;\n', '        _Multiplier2 = Multiplier2inX;\n', '        _LimitMultiplier1 = LimitMultiplier1inWei;\n', '        _LimitMultiplier2 = LimitMultiplier2inWei;\n', '        _HighDonateLimit = HighDonateLimitInWei;\n', '    }\n', '\n', '    function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {\n', '        _BonusTokensPerETHdonated = BonusTokensPerETHdonated;\n', '    }\n', '\n', '    function SetFreeTokens(uint256 FreeTokens) onlyOwner public {\n', '        _FreeTokens = FreeTokens;\n', '    }\n', '\n', '    function StartDistrib() public returns(bool success) {\n', '        if (msg.sender == owner && !DistribStarted && setupDone) {\n', '            DistribStarted = true;\n', '            IsDistribRunning = true;\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function StopDistrib() public returns(bool success) {\n', '        if (msg.sender == owner && IsDistribRunning) {\n', '            if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {\n', '                uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '                if (_remainingAmount > 0) {\n', '                    balances[_remainingTokensReceiverAddress] += _remainingAmount;\n', '                    _totalSupply += _remainingAmount;\n', '                    Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);\n', '                }\n', '            }\n', '            DistribStarted = false;\n', '            IsDistribRunning = false;\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function distribution(address[] addresses, uint256 _amount) onlyOwner public {\n', '\n', '        uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '        require(addresses.length <= 255);\n', '        require(_amount <= _remainingAmount);\n', '        _amount = _amount * 1e18;\n', '\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(_amount <= _remainingAmount);\n', '            _CurrentDistribPublicSupply += _amount;\n', '            balances[addresses[i]] += _amount;\n', '            _totalSupply += _amount;\n', '            Transfer(this, addresses[i], _amount);\n', '\n', '        }\n', '\n', '        if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {\n', '            DistribStarted = false;\n', '            IsDistribRunning = false;\n', '        }\n', '    }\n', '\n', '    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {\n', '\n', '        uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '        uint256 _amount;\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '\n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            _amount = amounts[i] * 1e18;\n', '            require(_amount <= _remainingAmount);\n', '            _CurrentDistribPublicSupply += _amount;\n', '            balances[addresses[i]] += _amount;\n', '            _totalSupply += _amount;\n', '            Transfer(this, addresses[i], _amount);\n', '\n', '\n', '            if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {\n', '                DistribStarted = false;\n', '                IsDistribRunning = false;\n', '            }\n', '        }\n', '    }\n', '\n', ' function BurnTokens(uint256 amount) public returns(bool success) {\n', '        uint256 _amount = amount * 1e18;\n', '        if (balances[msg.sender] >= _amount) {\n', '            balances[msg.sender] -= _amount;\n', '            _totalSupply -= _amount;\n', '            Burn(msg.sender, _amount);\n', '            Transfer(msg.sender, 0, _amount);\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '     \n', '\n', '    function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {\n', '        return _MaxDistribPublicSupply;\n', '    }\n', '\n', '    function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {\n', '        return _OwnerDistribSupply;\n', '    }\n', '\n', '    function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {\n', '        return _CurrentDistribPublicSupply;\n', '    }\n', '\n', '    function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {\n', '        return _remainingTokensReceiverAddress;\n', '    }\n', '\n', '    function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {\n', '        return _DistribFundsReceiverAddress;\n', '    }\n', '\n', '    function Owner() public constant returns(address ownerAddress) {\n', '        return owner;\n', '    }\n', '\n', '    function SetupDone() public constant returns(bool setupDoneFlag) {\n', '        return setupDone;\n', '    }\n', '\n', '    function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {\n', '        return IsDistribRunning;\n', '    }\n', '     function totalSupply() public constant returns(uint256 totalSupplyValue) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {\n', '        return DistribStarted;\n', '    }\n', ' function approve(address _spender, uint256 _amount) public returns(bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', 'function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data) returns (bool success) {\n', '      \n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '  \n', '  // Standard function transfer similar to ERC20 transfer with no _data .\n', '  // Added due to backwards compatibility reasons .\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '      \n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '}\n', '\n', '//assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        if(length>0) {\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '  //function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    assert(balanceOf(msg.sender) >= _value);\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    assert(balanceOf(msg.sender) >= _value);\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    ContractReceiver reciever = ContractReceiver(_to);\n', '    reciever.tokenFallback(msg.sender, _value, _data);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '}\n', '\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract ERC223 {\n', '  \n', '  function balanceOf(address who) constant returns (uint);\n', '  \n', '  function name() constant returns (string _name);\n', '  function symbol() constant returns (string _symbol);\n', '  function decimals() constant returns (uint8 _decimals);\n', '   \n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', '\n', 'contract ContractReceiver {\n', '     \n', '    struct TKN {\n', '        address sender;\n', '        uint value;\n', '        bytes data;\n', '        bytes4 sig;\n', '    }\n', '    \n', '    \n', '    function tokenFallback(address _from, uint _value, bytes _data){\n', '      TKN memory tkn;\n', '      tkn.sender = _from;\n', '      tkn.value = _value;\n', '      tkn.data = _data;\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '      \n', '      /* tkn variable is analogue of msg variable of Ether transaction\n', '      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '      *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '      *  tkn.data is data of token transaction   (analogue of msg.data)\n', '      *  tkn.sig is 4 bytes signature of function\n', '      *  if data of token transaction is a function execution\n', '      */\n', '    }\n', '}\n', ' /**\n', ' * ERC23 token by Dexaran\n', ' *\n', ' * https://github.com/Dexaran/ERC23-tokens\n', ' */\n', ' \n', ' \n', ' /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */\n', 'contract SafeMath {\n', '    uint256 constant public MAX_UINT256 =\n', '    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert(x <= MAX_UINT256 - y);\n', '        return x + y;\n', '    }\n', '\n', '    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert(x >= y);\n', '        return x - y;\n', '    }\n', '\n', '    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        if (y == 0) return 0;\n', '        assert(x <= MAX_UINT256 / y);\n', '        return x * y;\n', '    }\n', '}\n', ' \n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    assert(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract Haltable is Ownable {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    assert(!halted);\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    assert(halted);\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', 'contract Tablow is ERC223, SafeMath, Haltable {\n', '\n', '  mapping(address => uint) balances;\n', '  \n', '  string public symbol = "TC";\n', '    string public name = "Tablow Club";\n', '    uint8 public decimals = 18;\n', '    uint256  _totalSupply = 0;\n', '    uint256 _MaxDistribPublicSupply = 0;\n', '    uint256 _OwnerDistribSupply = 0;\n', '    uint256 _CurrentDistribPublicSupply = 0;\n', '    uint256 _FreeTokens = 0;\n', '    uint256 _Multiplier1 = 2;\n', '    uint256 _Multiplier2 = 3;\n', '    uint256 _LimitMultiplier1 = 4e15;\n', '    uint256 _LimitMultiplier2 = 8e15;\n', '    uint256 _HighDonateLimit = 5e16;\n', '    uint256 _BonusTokensPerETHdonated = 0;\n', '    address _DistribFundsReceiverAddress = 0;\n', '    address _remainingTokensReceiverAddress = 0;\n', '    address owner = 0;\n', '    bool setupDone = false;\n', '    bool IsDistribRunning = false;\n', '    bool DistribStarted = false;\n', '  \n', '  \n', '  // Function to access name of token .\n', '  function name() constant returns (string _name) {\n', '      return name;\n', '  }\n', '  // Function to access symbol of token .\n', '  function symbol() constant returns (string _symbol) {\n', '      return symbol;\n', '  }\n', '  // Function to access decimals of token .\n', '  function decimals() constant returns (uint8 _decimals) {\n', '      return decimals;\n', '  }\n', '  // Function to access total supply of tokens .\n', '   \n', '  \n', '   event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed _owner, uint256 _value);\n', '\n', '   \n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => bool) public Claimed;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function Tablow() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function() public payable {\n', '        if (IsDistribRunning) {\n', '            uint256 _amount;\n', '            if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();\n', '            if (!_DistribFundsReceiverAddress.send(msg.value)) revert();\n', '            if (Claimed[msg.sender] == false) {\n', '                _amount = _FreeTokens * 1e18;\n', '                _CurrentDistribPublicSupply += _amount;\n', '                balances[msg.sender] += _amount;\n', '                _totalSupply += _amount;\n', '                Transfer(this, msg.sender, _amount);\n', '                Claimed[msg.sender] = true;\n', '            }\n', '\n', '            require(msg.value <= _HighDonateLimit);\n', '\n', '            if (msg.value >= 1e15) {\n', '                if (msg.value >= _LimitMultiplier2) {\n', '                    _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;\n', '                } else {\n', '                    if (msg.value >= _LimitMultiplier1) {\n', '                        _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;\n', '                    } else {\n', '\n', '                        _amount = msg.value * _BonusTokensPerETHdonated;\n', '\n', '                    }\n', '\n', '                }\n', '\n', '                _CurrentDistribPublicSupply += _amount;\n', '                balances[msg.sender] += _amount;\n', '                _totalSupply += _amount;\n', '                Transfer(this, msg.sender, _amount);\n', '            }\n', '\n', '\n', '\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {\n', '        if (msg.sender == owner && !setupDone) {\n', '            symbol = tokenSymbol;\n', '            name = tokenName;\n', '            _FreeTokens = FreeTokens;\n', '            _BonusTokensPerETHdonated = BonusTokensPerETHdonated;\n', '            _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;\n', '            if (OwnerDistribSupply > 0) {\n', '                _OwnerDistribSupply = OwnerDistribSupply * 1e18;\n', '                _totalSupply = _OwnerDistribSupply;\n', '                balances[owner] = _totalSupply;\n', '                _CurrentDistribPublicSupply += _totalSupply;\n', '                Transfer(this, owner, _totalSupply);\n', '            }\n', '            _DistribFundsReceiverAddress = DistribFundsReceiverAddress;\n', '            if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;\n', '            _remainingTokensReceiverAddress = remainingTokensReceiverAddress;\n', '\n', '            setupDone = true;\n', '        }\n', '    }\n', '\n', '    function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {\n', '        _Multiplier1 = Multiplier1inX;\n', '        _Multiplier2 = Multiplier2inX;\n', '        _LimitMultiplier1 = LimitMultiplier1inWei;\n', '        _LimitMultiplier2 = LimitMultiplier2inWei;\n', '        _HighDonateLimit = HighDonateLimitInWei;\n', '    }\n', '\n', '    function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {\n', '        _BonusTokensPerETHdonated = BonusTokensPerETHdonated;\n', '    }\n', '\n', '    function SetFreeTokens(uint256 FreeTokens) onlyOwner public {\n', '        _FreeTokens = FreeTokens;\n', '    }\n', '\n', '    function StartDistrib() public returns(bool success) {\n', '        if (msg.sender == owner && !DistribStarted && setupDone) {\n', '            DistribStarted = true;\n', '            IsDistribRunning = true;\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function StopDistrib() public returns(bool success) {\n', '        if (msg.sender == owner && IsDistribRunning) {\n', '            if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {\n', '                uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '                if (_remainingAmount > 0) {\n', '                    balances[_remainingTokensReceiverAddress] += _remainingAmount;\n', '                    _totalSupply += _remainingAmount;\n', '                    Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);\n', '                }\n', '            }\n', '            DistribStarted = false;\n', '            IsDistribRunning = false;\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function distribution(address[] addresses, uint256 _amount) onlyOwner public {\n', '\n', '        uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '        require(addresses.length <= 255);\n', '        require(_amount <= _remainingAmount);\n', '        _amount = _amount * 1e18;\n', '\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(_amount <= _remainingAmount);\n', '            _CurrentDistribPublicSupply += _amount;\n', '            balances[addresses[i]] += _amount;\n', '            _totalSupply += _amount;\n', '            Transfer(this, addresses[i], _amount);\n', '\n', '        }\n', '\n', '        if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {\n', '            DistribStarted = false;\n', '            IsDistribRunning = false;\n', '        }\n', '    }\n', '\n', '    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {\n', '\n', '        uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '        uint256 _amount;\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '\n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            _amount = amounts[i] * 1e18;\n', '            require(_amount <= _remainingAmount);\n', '            _CurrentDistribPublicSupply += _amount;\n', '            balances[addresses[i]] += _amount;\n', '            _totalSupply += _amount;\n', '            Transfer(this, addresses[i], _amount);\n', '\n', '\n', '            if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {\n', '                DistribStarted = false;\n', '                IsDistribRunning = false;\n', '            }\n', '        }\n', '    }\n', '\n', ' function BurnTokens(uint256 amount) public returns(bool success) {\n', '        uint256 _amount = amount * 1e18;\n', '        if (balances[msg.sender] >= _amount) {\n', '            balances[msg.sender] -= _amount;\n', '            _totalSupply -= _amount;\n', '            Burn(msg.sender, _amount);\n', '            Transfer(msg.sender, 0, _amount);\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '     \n', '\n', '    function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {\n', '        return _MaxDistribPublicSupply;\n', '    }\n', '\n', '    function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {\n', '        return _OwnerDistribSupply;\n', '    }\n', '\n', '    function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {\n', '        return _CurrentDistribPublicSupply;\n', '    }\n', '\n', '    function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {\n', '        return _remainingTokensReceiverAddress;\n', '    }\n', '\n', '    function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {\n', '        return _DistribFundsReceiverAddress;\n', '    }\n', '\n', '    function Owner() public constant returns(address ownerAddress) {\n', '        return owner;\n', '    }\n', '\n', '    function SetupDone() public constant returns(bool setupDoneFlag) {\n', '        return setupDone;\n', '    }\n', '\n', '    function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {\n', '        return IsDistribRunning;\n', '    }\n', '     function totalSupply() public constant returns(uint256 totalSupplyValue) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {\n', '        return DistribStarted;\n', '    }\n', ' function approve(address _spender, uint256 _amount) public returns(bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', 'function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data) returns (bool success) {\n', '      \n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, _data);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, _data);\n', '    }\n', '}\n', '  \n', '  // Standard function transfer similar to ERC20 transfer with no _data .\n', '  // Added due to backwards compatibility reasons .\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '      \n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if(isContract(_to)) {\n', '        return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '        return transferToAddress(_to, _value, empty);\n', '    }\n', '}\n', '\n', '//assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private returns (bool is_contract) {\n', '      uint length;\n', '      assembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        if(length>0) {\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '  //function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    assert(balanceOf(msg.sender) >= _value);\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    assert(balanceOf(msg.sender) >= _value);\n', '    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);\n', '    balances[_to] = safeAdd(balanceOf(_to), _value);\n', '    ContractReceiver reciever = ContractReceiver(_to);\n', '    reciever.tokenFallback(msg.sender, _value, _data);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '}\n', '\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '  \n', '}']

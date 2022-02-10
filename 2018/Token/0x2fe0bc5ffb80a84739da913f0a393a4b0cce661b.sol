['pragma solidity 0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract QPay {\n', '\n', '    string public symbol="QPY";\n', '    string public name="QPay" ;\n', '    uint8 public constant decimals = 18;\n', '    uint256 _totalSupply = 0;\t\n', '\tuint256 _FreeQPY = 1230;\n', '    uint256 _ML1 = 2;\n', '    uint256 _ML2 = 3;\n', '\tuint256 _ML3 = 4;\n', '    uint256 _LimitML1 = 3e15;\n', '    uint256 _LimitML2 = 6e15;\n', '\tuint256 _LimitML3 = 9e15;\n', '\tuint256 _MaxDistribPublicSupply = 950000000;\n', '    uint256 _OwnerDistribSupply = 0;\n', '    uint256 _CurrentDistribPublicSupply = 0;\t\n', '    uint256 _ExtraTokensPerETHSended = 150000;\n', '    \n', '\taddress _DistribFundsReceiverAddress = 0;\n', '    address _remainingTokensReceiverAddress = 0;\n', '    address owner = 0;\n', '\t\n', '\t\n', '    bool setupDone = false;\n', '    bool IsDistribRunning = false;\n', '    bool DistribStarted = false;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed _owner, uint256 _value);\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => bool) public Claimed;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function QPay() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function() public payable {\n', '        if (IsDistribRunning) {\n', '            uint256 _amount;\n', '            if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();\n', '            if (!_DistribFundsReceiverAddress.send(msg.value)) revert();\n', '            if (Claimed[msg.sender] == false) {\n', '                _amount = _FreeQPY * 1e18;\n', '                _CurrentDistribPublicSupply += _amount;\n', '                balances[msg.sender] += _amount;\n', '                _totalSupply += _amount;\n', '                Transfer(this, msg.sender, _amount);\n', '                Claimed[msg.sender] = true;\n', '            }\n', '\n', '           \n', '\n', '            if (msg.value >= 9e15) {\n', '            _amount = msg.value * _ExtraTokensPerETHSended * 4;\n', '            } else {\n', '                if (msg.value >= 6e15) {\n', '                    _amount = msg.value * _ExtraTokensPerETHSended * 3;\n', '                } else {\n', '                    if (msg.value >= 3e15) {\n', '                        _amount = msg.value * _ExtraTokensPerETHSended * 2;\n', '                    } else {\n', '\n', '                        _amount = msg.value * _ExtraTokensPerETHSended;\n', '\n', '                    }\n', '\n', '                }\n', '            }\n', '\t\t\t \n', '\t\t\t _CurrentDistribPublicSupply += _amount;\n', '                balances[msg.sender] += _amount;\n', '                _totalSupply += _amount;\n', '                Transfer(this, msg.sender, _amount);\n', '        \n', '\n', '\n', '\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function SetupQPY(string tokenName, string tokenSymbol, uint256 ExtraTokensPerETHSended, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeQPY) public {\n', '        if (msg.sender == owner && !setupDone) {\n', '            symbol = tokenSymbol;\n', '            name = tokenName;\n', '            _FreeQPY = FreeQPY;\n', '            _ExtraTokensPerETHSended = ExtraTokensPerETHSended;\n', '            _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;\n', '            if (OwnerDistribSupply > 0) {\n', '                _OwnerDistribSupply = OwnerDistribSupply * 1e18;\n', '                _totalSupply = _OwnerDistribSupply;\n', '                balances[owner] = _totalSupply;\n', '                _CurrentDistribPublicSupply += _totalSupply;\n', '                Transfer(this, owner, _totalSupply);\n', '            }\n', '            _DistribFundsReceiverAddress = DistribFundsReceiverAddress;\n', '            if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;\n', '            _remainingTokensReceiverAddress = remainingTokensReceiverAddress;\n', '\n', '            setupDone = true;\n', '        }\n', '    }\n', '\n', '    function SetupML(uint256 ML1inX, uint256 ML2inX, uint256 LimitML1inWei, uint256 LimitML2inWei) onlyOwner public {\n', '        _ML1 = ML1inX;\n', '        _ML2 = ML2inX;\n', '        _LimitML1 = LimitML1inWei;\n', '        _LimitML2 = LimitML2inWei;\n', '        \n', '    }\n', '\n', '    function SetExtra(uint256 ExtraTokensPerETHSended) onlyOwner public {\n', '        _ExtraTokensPerETHSended = ExtraTokensPerETHSended;\n', '    }\n', '\n', '    function SetFreeQPY(uint256 FreeQPY) onlyOwner public {\n', '        _FreeQPY = FreeQPY;\n', '    }\n', '\n', '    function StartDistrib() public returns(bool success) {\n', '        if (msg.sender == owner && !DistribStarted && setupDone) {\n', '            DistribStarted = true;\n', '            IsDistribRunning = true;\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function StopDistrib() public returns(bool success) {\n', '        if (msg.sender == owner && IsDistribRunning) {\n', '            if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {\n', '                uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '                if (_remainingAmount > 0) {\n', '                    balances[_remainingTokensReceiverAddress] += _remainingAmount;\n', '                    _totalSupply += _remainingAmount;\n', '                   Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);\n', '                }\n', '            }\n', '            DistribStarted = false;\n', '            IsDistribRunning = false;\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function distribution(address[] addresses, uint256 _amount) onlyOwner public {\n', '\n', '        uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '        require(addresses.length <= 255);\n', '        require(_amount <= _remainingAmount);\n', '        _amount = _amount * 1e18;\n', '\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(_amount <= _remainingAmount);\n', '            _CurrentDistribPublicSupply += _amount;\n', '            balances[addresses[i]] += _amount;\n', '            _totalSupply += _amount;\n', '           Transfer(this, addresses[i], _amount);\n', '\n', '        }\n', '\n', '        if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {\n', '            DistribStarted = false;\n', '            IsDistribRunning = false;\n', '        }\n', '    }\n', '\n', '    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {\n', '\n', '        uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '        uint256 _amount;\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '\n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            _amount = amounts[i] * 1e18;\n', '            require(_amount <= _remainingAmount);\n', '            _CurrentDistribPublicSupply += _amount;\n', '            balances[addresses[i]] += _amount;\n', '            _totalSupply += _amount;\n', '            Transfer(this, addresses[i], _amount);\n', '\n', '\n', '            if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {\n', '                DistribStarted = false;\n', '                IsDistribRunning = false;\n', '            }\n', '        }\n', '    }\n', '\n', '    function BurnTokens(uint256 amount) public returns(bool success) {\n', '        uint256 _amount = amount * 1e18;\n', '        if (balances[msg.sender] >= _amount) {\n', '            balances[msg.sender] -= _amount;\n', '            _totalSupply -= _amount;\n', '             Burn(msg.sender, _amount);\n', '            Transfer(msg.sender, 0, _amount);\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() public constant returns(uint256 totalSupplyValue) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {\n', '        return _MaxDistribPublicSupply;\n', '    }\n', '\n', '    function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {\n', '        return _OwnerDistribSupply;\n', '    }\n', '\n', '    function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {\n', '        return _CurrentDistribPublicSupply;\n', '    }\n', '\n', '    function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {\n', '        return _remainingTokensReceiverAddress;\n', '    }\n', '\n', '    function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {\n', '        return _DistribFundsReceiverAddress;\n', '    }\n', '\n', '    function Owner() public constant returns(address ownerAddress) {\n', '        return owner;\n', '    }\n', '\n', '    function SetupDone() public constant returns(bool setupDoneFlag) {\n', '        return setupDone;\n', '    }\n', '\n', '    function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {\n', '        return IsDistribRunning;\n', '    }\n', '\n', '    function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {\n', '        return DistribStarted;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _amount) public returns(bool success) {\n', '        if (balances[msg.sender] >= _amount &&\n', '            _amount > 0 &&\n', '            balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) public returns(bool success) {\n', '        if (balances[_from] >= _amount &&\n', '            allowed[_from][msg.sender] >= _amount &&\n', '            _amount > 0 &&\n', '            balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '         Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) public returns(bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}']
['pragma solidity 0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract QPay {\n', '\n', '    string public symbol="QPY";\n', '    string public name="QPay" ;\n', '    uint8 public constant decimals = 18;\n', '    uint256 _totalSupply = 0;\t\n', '\tuint256 _FreeQPY = 1230;\n', '    uint256 _ML1 = 2;\n', '    uint256 _ML2 = 3;\n', '\tuint256 _ML3 = 4;\n', '    uint256 _LimitML1 = 3e15;\n', '    uint256 _LimitML2 = 6e15;\n', '\tuint256 _LimitML3 = 9e15;\n', '\tuint256 _MaxDistribPublicSupply = 950000000;\n', '    uint256 _OwnerDistribSupply = 0;\n', '    uint256 _CurrentDistribPublicSupply = 0;\t\n', '    uint256 _ExtraTokensPerETHSended = 150000;\n', '    \n', '\taddress _DistribFundsReceiverAddress = 0;\n', '    address _remainingTokensReceiverAddress = 0;\n', '    address owner = 0;\n', '\t\n', '\t\n', '    bool setupDone = false;\n', '    bool IsDistribRunning = false;\n', '    bool DistribStarted = false;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed _owner, uint256 _value);\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => bool) public Claimed;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function QPay() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function() public payable {\n', '        if (IsDistribRunning) {\n', '            uint256 _amount;\n', '            if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();\n', '            if (!_DistribFundsReceiverAddress.send(msg.value)) revert();\n', '            if (Claimed[msg.sender] == false) {\n', '                _amount = _FreeQPY * 1e18;\n', '                _CurrentDistribPublicSupply += _amount;\n', '                balances[msg.sender] += _amount;\n', '                _totalSupply += _amount;\n', '                Transfer(this, msg.sender, _amount);\n', '                Claimed[msg.sender] = true;\n', '            }\n', '\n', '           \n', '\n', '            if (msg.value >= 9e15) {\n', '            _amount = msg.value * _ExtraTokensPerETHSended * 4;\n', '            } else {\n', '                if (msg.value >= 6e15) {\n', '                    _amount = msg.value * _ExtraTokensPerETHSended * 3;\n', '                } else {\n', '                    if (msg.value >= 3e15) {\n', '                        _amount = msg.value * _ExtraTokensPerETHSended * 2;\n', '                    } else {\n', '\n', '                        _amount = msg.value * _ExtraTokensPerETHSended;\n', '\n', '                    }\n', '\n', '                }\n', '            }\n', '\t\t\t \n', '\t\t\t _CurrentDistribPublicSupply += _amount;\n', '                balances[msg.sender] += _amount;\n', '                _totalSupply += _amount;\n', '                Transfer(this, msg.sender, _amount);\n', '        \n', '\n', '\n', '\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function SetupQPY(string tokenName, string tokenSymbol, uint256 ExtraTokensPerETHSended, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeQPY) public {\n', '        if (msg.sender == owner && !setupDone) {\n', '            symbol = tokenSymbol;\n', '            name = tokenName;\n', '            _FreeQPY = FreeQPY;\n', '            _ExtraTokensPerETHSended = ExtraTokensPerETHSended;\n', '            _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;\n', '            if (OwnerDistribSupply > 0) {\n', '                _OwnerDistribSupply = OwnerDistribSupply * 1e18;\n', '                _totalSupply = _OwnerDistribSupply;\n', '                balances[owner] = _totalSupply;\n', '                _CurrentDistribPublicSupply += _totalSupply;\n', '                Transfer(this, owner, _totalSupply);\n', '            }\n', '            _DistribFundsReceiverAddress = DistribFundsReceiverAddress;\n', '            if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;\n', '            _remainingTokensReceiverAddress = remainingTokensReceiverAddress;\n', '\n', '            setupDone = true;\n', '        }\n', '    }\n', '\n', '    function SetupML(uint256 ML1inX, uint256 ML2inX, uint256 LimitML1inWei, uint256 LimitML2inWei) onlyOwner public {\n', '        _ML1 = ML1inX;\n', '        _ML2 = ML2inX;\n', '        _LimitML1 = LimitML1inWei;\n', '        _LimitML2 = LimitML2inWei;\n', '        \n', '    }\n', '\n', '    function SetExtra(uint256 ExtraTokensPerETHSended) onlyOwner public {\n', '        _ExtraTokensPerETHSended = ExtraTokensPerETHSended;\n', '    }\n', '\n', '    function SetFreeQPY(uint256 FreeQPY) onlyOwner public {\n', '        _FreeQPY = FreeQPY;\n', '    }\n', '\n', '    function StartDistrib() public returns(bool success) {\n', '        if (msg.sender == owner && !DistribStarted && setupDone) {\n', '            DistribStarted = true;\n', '            IsDistribRunning = true;\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function StopDistrib() public returns(bool success) {\n', '        if (msg.sender == owner && IsDistribRunning) {\n', '            if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {\n', '                uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '                if (_remainingAmount > 0) {\n', '                    balances[_remainingTokensReceiverAddress] += _remainingAmount;\n', '                    _totalSupply += _remainingAmount;\n', '                   Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);\n', '                }\n', '            }\n', '            DistribStarted = false;\n', '            IsDistribRunning = false;\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function distribution(address[] addresses, uint256 _amount) onlyOwner public {\n', '\n', '        uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '        require(addresses.length <= 255);\n', '        require(_amount <= _remainingAmount);\n', '        _amount = _amount * 1e18;\n', '\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(_amount <= _remainingAmount);\n', '            _CurrentDistribPublicSupply += _amount;\n', '            balances[addresses[i]] += _amount;\n', '            _totalSupply += _amount;\n', '           Transfer(this, addresses[i], _amount);\n', '\n', '        }\n', '\n', '        if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {\n', '            DistribStarted = false;\n', '            IsDistribRunning = false;\n', '        }\n', '    }\n', '\n', '    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {\n', '\n', '        uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;\n', '        uint256 _amount;\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '\n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            _amount = amounts[i] * 1e18;\n', '            require(_amount <= _remainingAmount);\n', '            _CurrentDistribPublicSupply += _amount;\n', '            balances[addresses[i]] += _amount;\n', '            _totalSupply += _amount;\n', '            Transfer(this, addresses[i], _amount);\n', '\n', '\n', '            if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {\n', '                DistribStarted = false;\n', '                IsDistribRunning = false;\n', '            }\n', '        }\n', '    }\n', '\n', '    function BurnTokens(uint256 amount) public returns(bool success) {\n', '        uint256 _amount = amount * 1e18;\n', '        if (balances[msg.sender] >= _amount) {\n', '            balances[msg.sender] -= _amount;\n', '            _totalSupply -= _amount;\n', '             Burn(msg.sender, _amount);\n', '            Transfer(msg.sender, 0, _amount);\n', '        } else {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() public constant returns(uint256 totalSupplyValue) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {\n', '        return _MaxDistribPublicSupply;\n', '    }\n', '\n', '    function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {\n', '        return _OwnerDistribSupply;\n', '    }\n', '\n', '    function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {\n', '        return _CurrentDistribPublicSupply;\n', '    }\n', '\n', '    function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {\n', '        return _remainingTokensReceiverAddress;\n', '    }\n', '\n', '    function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {\n', '        return _DistribFundsReceiverAddress;\n', '    }\n', '\n', '    function Owner() public constant returns(address ownerAddress) {\n', '        return owner;\n', '    }\n', '\n', '    function SetupDone() public constant returns(bool setupDoneFlag) {\n', '        return setupDone;\n', '    }\n', '\n', '    function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {\n', '        return IsDistribRunning;\n', '    }\n', '\n', '    function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {\n', '        return DistribStarted;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _amount) public returns(bool success) {\n', '        if (balances[msg.sender] >= _amount &&\n', '            _amount > 0 &&\n', '            balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) public returns(bool success) {\n', '        if (balances[_from] >= _amount &&\n', '            allowed[_from][msg.sender] >= _amount &&\n', '            _amount > 0 &&\n', '            balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '         Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) public returns(bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}']
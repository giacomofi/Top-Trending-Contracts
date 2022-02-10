['pragma solidity ^0.4.12;\n', ' \n', 'contract IMigrationContract {\n', '    function migrate(address addr, uint256 ulc) returns (bool success);\n', '}\n', ' \n', 'contract SafeMath {\n', ' \n', ' \n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', ' \n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', ' \n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', ' \n', '}\n', ' \n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', ' \n', ' \n', 'contract StandardToken is Token {\n', ' \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', ' \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', ' \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', ' \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', ' \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', ' \n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', ' \n', 'contract ULCToken is StandardToken, SafeMath {\n', ' \n', '    // metadata\n', '    string  public constant name = "ULCToken";\n', '    string  public constant symbol = "ULC";\n', '    uint256 public constant decimals = 8;\n', '    string  public version = "1.0";\n', ' \n', '    // contracts\n', '    address public ethFundDeposit;          \n', '    address public newContractAddr;         \n', ' \n', '    // crowdsale parameters\n', '    bool    public isFunding;                \n', '    uint256 public fundingStartBlock;\n', '    uint256 public fundingStopBlock;\n', ' \n', '    uint256 public currentSupply;           \n', '    uint256 public tokenRaised = 0;         \n', '    uint256 public tokenMigrated = 0;     \n', '    uint256 public tokenExchangeRate = 3500;            \n', ' \n', '    event AllocateToken(address indexed _to, uint256 _value);   \n', '    event IssueToken(address indexed _to, uint256 _value);      \n', '    event IncreaseSupply(uint256 _value);\n', '    event DecreaseSupply(uint256 _value);\n', '    event Migrate(address indexed _to, uint256 _value);\n', ' \n', '    function formatDecimals(uint256 _value) internal returns (uint256 ) {\n', '        return _value * 10 ** decimals;\n', '    }\n', ' \n', '    // constructor\n', '    function ULCToken(\n', '        address _ethFundDeposit,\n', '        uint256 _currentSupply)\n', '    {\n', '        ethFundDeposit = _ethFundDeposit;\n', ' \n', '        isFunding = false;                           \n', '        fundingStartBlock = 0;\n', '        fundingStopBlock = 0;\n', ' \n', '        currentSupply = formatDecimals(_currentSupply);\n', '        totalSupply = formatDecimals(1000000000);\n', '        balances[msg.sender] = totalSupply;\n', '        if(currentSupply > totalSupply) throw;\n', '    }\n', ' \n', '    modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }\n', ' \n', '\n', '    function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {\n', '        if (_tokenExchangeRate == 0) throw;\n', '        if (_tokenExchangeRate == tokenExchangeRate) throw;\n', ' \n', '        tokenExchangeRate = _tokenExchangeRate;\n', '    }\n', ' \n', '\n', '    function increaseSupply (uint256 _value) isOwner external {\n', '        uint256 value = formatDecimals(_value);\n', '        if (value + currentSupply > totalSupply) throw;\n', '        currentSupply = safeAdd(currentSupply, value);\n', '        IncreaseSupply(value);\n', '    }\n', ' \n', '\n', '    function decreaseSupply (uint256 _value) isOwner external {\n', '        uint256 value = formatDecimals(_value);\n', '        if (value + tokenRaised > currentSupply) throw;\n', ' \n', '        currentSupply = safeSubtract(currentSupply, value);\n', '        DecreaseSupply(value);\n', '    }\n', ' \n', '\n', '    function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {\n', '        if (isFunding) throw;\n', '        if (_fundingStartBlock >= _fundingStopBlock) throw;\n', '        if (block.number >= _fundingStartBlock) throw;\n', ' \n', '        fundingStartBlock = _fundingStartBlock;\n', '        fundingStopBlock = _fundingStopBlock;\n', '        isFunding = true;\n', '    }\n', ' \n', '\n', '    function stopFunding() isOwner external {\n', '        if (!isFunding) throw;\n', '        isFunding = false;\n', '    }\n', ' \n', '\n', '    function setMigrateContract(address _newContractAddr) isOwner external {\n', '        if (_newContractAddr == newContractAddr) throw;\n', '        newContractAddr = _newContractAddr;\n', '    }\n', ' \n', '\n', '    function changeOwner(address _newFundDeposit) isOwner() external {\n', '        if (_newFundDeposit == address(0x0)) throw;\n', '        ethFundDeposit = _newFundDeposit;\n', '    }\n', ' \n', '\n', '    function migrate() external {\n', '        if(isFunding) throw;\n', '        if(newContractAddr == address(0x0)) throw;\n', ' \n', '        uint256 tokens = balances[msg.sender];\n', '        if (tokens == 0) throw;\n', ' \n', '        balances[msg.sender] = 0;\n', '        tokenMigrated = safeAdd(tokenMigrated, tokens);\n', ' \n', '        IMigrationContract newContract = IMigrationContract(newContractAddr);\n', '        if (!newContract.migrate(msg.sender, tokens)) throw;\n', ' \n', '        Migrate(msg.sender, tokens);               \n', '    }\n', ' \n', '\n', '    function transferETH() isOwner external {\n', '        if (this.balance == 0) throw;\n', '        if (!ethFundDeposit.send(this.balance)) throw;\n', '    }\n', ' \n', '\n', '    function allocateToken (address _addr, uint256 _eth) isOwner external {\n', '        if (_eth == 0) throw;\n', '        if (_addr == address(0x0)) throw;\n', ' \n', '        uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);\n', '        if (tokens + tokenRaised > currentSupply) throw;\n', ' \n', '        tokenRaised = safeAdd(tokenRaised, tokens);\n', '        balances[_addr] += tokens;\n', ' \n', '        AllocateToken(_addr, tokens);  \n', '    }\n', ' \n', '\n', '    function () payable {\n', '        if (!isFunding) throw;\n', '        if (msg.value == 0) throw;\n', ' \n', '        if (block.number < fundingStartBlock) throw;\n', '        if (block.number > fundingStopBlock) throw;\n', ' \n', '        uint256 tokens = safeMult(msg.value, tokenExchangeRate);\n', '        if (tokens + tokenRaised > currentSupply) throw;\n', ' \n', '        tokenRaised = safeAdd(tokenRaised, tokens);\n', '        balances[msg.sender] += tokens;\n', ' \n', '        IssueToken(msg.sender, tokens);  \n', '    }\n', '}']
['pragma solidity ^0.4.12;\n', ' \n', 'contract IMigrationContract {\n', '    function migrate(address addr, uint256 ulc) returns (bool success);\n', '}\n', ' \n', 'contract SafeMath {\n', ' \n', ' \n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', ' \n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', ' \n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', ' \n', '}\n', ' \n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', ' \n', ' \n', 'contract StandardToken is Token {\n', ' \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', ' \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', ' \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', ' \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', ' \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', ' \n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', ' \n', 'contract ULCToken is StandardToken, SafeMath {\n', ' \n', '    // metadata\n', '    string  public constant name = "ULCToken";\n', '    string  public constant symbol = "ULC";\n', '    uint256 public constant decimals = 8;\n', '    string  public version = "1.0";\n', ' \n', '    // contracts\n', '    address public ethFundDeposit;          \n', '    address public newContractAddr;         \n', ' \n', '    // crowdsale parameters\n', '    bool    public isFunding;                \n', '    uint256 public fundingStartBlock;\n', '    uint256 public fundingStopBlock;\n', ' \n', '    uint256 public currentSupply;           \n', '    uint256 public tokenRaised = 0;         \n', '    uint256 public tokenMigrated = 0;     \n', '    uint256 public tokenExchangeRate = 3500;            \n', ' \n', '    event AllocateToken(address indexed _to, uint256 _value);   \n', '    event IssueToken(address indexed _to, uint256 _value);      \n', '    event IncreaseSupply(uint256 _value);\n', '    event DecreaseSupply(uint256 _value);\n', '    event Migrate(address indexed _to, uint256 _value);\n', ' \n', '    function formatDecimals(uint256 _value) internal returns (uint256 ) {\n', '        return _value * 10 ** decimals;\n', '    }\n', ' \n', '    // constructor\n', '    function ULCToken(\n', '        address _ethFundDeposit,\n', '        uint256 _currentSupply)\n', '    {\n', '        ethFundDeposit = _ethFundDeposit;\n', ' \n', '        isFunding = false;                           \n', '        fundingStartBlock = 0;\n', '        fundingStopBlock = 0;\n', ' \n', '        currentSupply = formatDecimals(_currentSupply);\n', '        totalSupply = formatDecimals(1000000000);\n', '        balances[msg.sender] = totalSupply;\n', '        if(currentSupply > totalSupply) throw;\n', '    }\n', ' \n', '    modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }\n', ' \n', '\n', '    function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {\n', '        if (_tokenExchangeRate == 0) throw;\n', '        if (_tokenExchangeRate == tokenExchangeRate) throw;\n', ' \n', '        tokenExchangeRate = _tokenExchangeRate;\n', '    }\n', ' \n', '\n', '    function increaseSupply (uint256 _value) isOwner external {\n', '        uint256 value = formatDecimals(_value);\n', '        if (value + currentSupply > totalSupply) throw;\n', '        currentSupply = safeAdd(currentSupply, value);\n', '        IncreaseSupply(value);\n', '    }\n', ' \n', '\n', '    function decreaseSupply (uint256 _value) isOwner external {\n', '        uint256 value = formatDecimals(_value);\n', '        if (value + tokenRaised > currentSupply) throw;\n', ' \n', '        currentSupply = safeSubtract(currentSupply, value);\n', '        DecreaseSupply(value);\n', '    }\n', ' \n', '\n', '    function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {\n', '        if (isFunding) throw;\n', '        if (_fundingStartBlock >= _fundingStopBlock) throw;\n', '        if (block.number >= _fundingStartBlock) throw;\n', ' \n', '        fundingStartBlock = _fundingStartBlock;\n', '        fundingStopBlock = _fundingStopBlock;\n', '        isFunding = true;\n', '    }\n', ' \n', '\n', '    function stopFunding() isOwner external {\n', '        if (!isFunding) throw;\n', '        isFunding = false;\n', '    }\n', ' \n', '\n', '    function setMigrateContract(address _newContractAddr) isOwner external {\n', '        if (_newContractAddr == newContractAddr) throw;\n', '        newContractAddr = _newContractAddr;\n', '    }\n', ' \n', '\n', '    function changeOwner(address _newFundDeposit) isOwner() external {\n', '        if (_newFundDeposit == address(0x0)) throw;\n', '        ethFundDeposit = _newFundDeposit;\n', '    }\n', ' \n', '\n', '    function migrate() external {\n', '        if(isFunding) throw;\n', '        if(newContractAddr == address(0x0)) throw;\n', ' \n', '        uint256 tokens = balances[msg.sender];\n', '        if (tokens == 0) throw;\n', ' \n', '        balances[msg.sender] = 0;\n', '        tokenMigrated = safeAdd(tokenMigrated, tokens);\n', ' \n', '        IMigrationContract newContract = IMigrationContract(newContractAddr);\n', '        if (!newContract.migrate(msg.sender, tokens)) throw;\n', ' \n', '        Migrate(msg.sender, tokens);               \n', '    }\n', ' \n', '\n', '    function transferETH() isOwner external {\n', '        if (this.balance == 0) throw;\n', '        if (!ethFundDeposit.send(this.balance)) throw;\n', '    }\n', ' \n', '\n', '    function allocateToken (address _addr, uint256 _eth) isOwner external {\n', '        if (_eth == 0) throw;\n', '        if (_addr == address(0x0)) throw;\n', ' \n', '        uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);\n', '        if (tokens + tokenRaised > currentSupply) throw;\n', ' \n', '        tokenRaised = safeAdd(tokenRaised, tokens);\n', '        balances[_addr] += tokens;\n', ' \n', '        AllocateToken(_addr, tokens);  \n', '    }\n', ' \n', '\n', '    function () payable {\n', '        if (!isFunding) throw;\n', '        if (msg.value == 0) throw;\n', ' \n', '        if (block.number < fundingStartBlock) throw;\n', '        if (block.number > fundingStopBlock) throw;\n', ' \n', '        uint256 tokens = safeMult(msg.value, tokenExchangeRate);\n', '        if (tokens + tokenRaised > currentSupply) throw;\n', ' \n', '        tokenRaised = safeAdd(tokenRaised, tokens);\n', '        balances[msg.sender] += tokens;\n', ' \n', '        IssueToken(msg.sender, tokens);  \n', '    }\n', '}']
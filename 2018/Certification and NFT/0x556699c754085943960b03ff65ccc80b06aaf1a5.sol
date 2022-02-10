['pragma solidity ^0.4.12;\n', '\n', 'contract IMigrationContract {\n', '    function migrate(address addr, uint256 nas) returns (bool success);\n', '}\n', '\n', '/* 灵感来自于NAS  coin*/\n', 'contract SafeMath {\n', '\n', '\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', '\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract BliBliToken is StandardToken, SafeMath {\n', '\n', '    // metadata\n', '    string  public constant name = "blibli";\n', '    string  public constant symbol = "bCoin";\n', '    uint256 public constant decimals = 18;\n', '    string  public version = "1.0";\n', '\n', '    // contracts\n', '    address public ethFundDeposit;          // ETH存放地址\n', '    address public newContractAddr;         // token更新地址\n', '\n', '    // crowdsale parameters\n', '    bool    public isFunding;                // 状态切换到true\n', '    uint256 public fundingStartBlock;\n', '    uint256 public fundingStopBlock;\n', '\n', '    uint256 public currentSupply;           // 正在售卖中的tokens数量\n', '    uint256 public tokenRaised = 0;         // 总的售卖数量token\n', '    uint256 public tokenMigrated = 0;     // 总的已经交易的 token\n', '    uint256 public tokenExchangeRate = 625;             // 625 BILIBILI 兑换 1 ETH\n', '\n', '    // events\n', '    event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;\n', '    event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;\n', '    event IncreaseSupply(uint256 _value);\n', '    event DecreaseSupply(uint256 _value);\n', '    event Migrate(address indexed _to, uint256 _value);\n', '\n', '    // 转换\n', '    function formatDecimals(uint256 _value) internal returns (uint256 ) {\n', '        return _value * 10 ** decimals;\n', '    }\n', '\n', '    // constructor\n', '    function BliBliToken(\n', '        address _ethFundDeposit,\n', '        uint256 _currentSupply)\n', '    {\n', '        ethFundDeposit = _ethFundDeposit;\n', '\n', '        isFunding = false;                           //通过控制预CrowdS ale状态\n', '        fundingStartBlock = 0;\n', '        fundingStopBlock = 0;\n', '\n', '        currentSupply = formatDecimals(_currentSupply);\n', '        totalSupply = formatDecimals(10000000);\n', '        balances[msg.sender] = totalSupply;\n', '        if(currentSupply > totalSupply) throw;\n', '    }\n', '\n', '    modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }\n', '\n', '    ///  设置token汇率\n', '    function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {\n', '        if (_tokenExchangeRate == 0) throw;\n', '        if (_tokenExchangeRate == tokenExchangeRate) throw;\n', '\n', '        tokenExchangeRate = _tokenExchangeRate;\n', '    }\n', '\n', '    /// @dev 超发token处理\n', '    function increaseSupply (uint256 _value) isOwner external {\n', '        uint256 value = formatDecimals(_value);\n', '        if (value + currentSupply > totalSupply) throw;\n', '        currentSupply = safeAdd(currentSupply, value);\n', '        IncreaseSupply(value);\n', '    }\n', '\n', '    /// @dev 被盗token处理\n', '    function decreaseSupply (uint256 _value) isOwner external {\n', '        uint256 value = formatDecimals(_value);\n', '        if (value + tokenRaised > currentSupply) throw;\n', '\n', '        currentSupply = safeSubtract(currentSupply, value);\n', '        DecreaseSupply(value);\n', '    }\n', '\n', '    ///  启动区块检测 异常的处理\n', '    function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {\n', '        if (isFunding) throw;\n', '        if (_fundingStartBlock >= _fundingStopBlock) throw;\n', '        if (block.number >= _fundingStartBlock) throw;\n', '\n', '        fundingStartBlock = _fundingStartBlock;\n', '        fundingStopBlock = _fundingStopBlock;\n', '        isFunding = true;\n', '    }\n', '\n', '    ///  关闭区块异常处理\n', '    function stopFunding() isOwner external {\n', '        if (!isFunding) throw;\n', '        isFunding = false;\n', '    }\n', '\n', '    /// 开发了一个新的合同来接收token（或者更新token）\n', '    function setMigrateContract(address _newContractAddr) isOwner external {\n', '        if (_newContractAddr == newContractAddr) throw;\n', '        newContractAddr = _newContractAddr;\n', '    }\n', '\n', '    /// 设置新的所有者地址\n', '    function changeOwner(address _newFundDeposit) isOwner() external {\n', '        if (_newFundDeposit == address(0x0)) throw;\n', '        ethFundDeposit = _newFundDeposit;\n', '    }\n', '\n', '    ///转移token到新的合约\n', '    function migrate() external {\n', '        if(isFunding) throw;\n', '        if(newContractAddr == address(0x0)) throw;\n', '\n', '        uint256 tokens = balances[msg.sender];\n', '        if (tokens == 0) throw;\n', '\n', '        balances[msg.sender] = 0;\n', '        tokenMigrated = safeAdd(tokenMigrated, tokens);\n', '\n', '        IMigrationContract newContract = IMigrationContract(newContractAddr);\n', '        if (!newContract.migrate(msg.sender, tokens)) throw;\n', '\n', '        Migrate(msg.sender, tokens);               // log it\n', '    }\n', '\n', '    /// 转账ETH 到BILIBILI团队\n', '    function transferETH() isOwner external {\n', '        if (this.balance == 0) throw;\n', '        if (!ethFundDeposit.send(this.balance)) throw;\n', '    }\n', '\n', '    ///  将BILIBILI token分配到预处理地址。\n', '    function allocateToken (address _addr, uint256 _eth) isOwner external {\n', '        if (_eth == 0) throw;\n', '        if (_addr == address(0x0)) throw;\n', '\n', '        uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);\n', '        if (tokens + tokenRaised > currentSupply) throw;\n', '\n', '        tokenRaised = safeAdd(tokenRaised, tokens);\n', '        balances[_addr] += tokens;\n', '\n', '        AllocateToken(_addr, tokens);  // 记录token日志\n', '    }\n', '\n', '    /// 购买token\n', '    function () payable {\n', '        if (!isFunding) throw;\n', '        if (msg.value == 0) throw;\n', '\n', '        if (block.number < fundingStartBlock) throw;\n', '        if (block.number > fundingStopBlock) throw;\n', '\n', '        uint256 tokens = safeMult(msg.value, tokenExchangeRate);\n', '        if (tokens + tokenRaised > currentSupply) throw;\n', '\n', '        tokenRaised = safeAdd(tokenRaised, tokens);\n', '        balances[msg.sender] += tokens;\n', '\n', '        IssueToken(msg.sender, tokens);  //记录日志\n', '    }\n', '}']
['pragma solidity ^0.4.12;\n', '\n', 'contract IMigrationContract {\n', '    function migrate(address addr, uint256 nas) returns (bool success);\n', '}\n', '\n', '/* 灵感来自于NAS  coin*/\n', 'contract SafeMath {\n', '\n', '\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', '\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract BliBliToken is StandardToken, SafeMath {\n', '\n', '    // metadata\n', '    string  public constant name = "blibli";\n', '    string  public constant symbol = "bCoin";\n', '    uint256 public constant decimals = 18;\n', '    string  public version = "1.0";\n', '\n', '    // contracts\n', '    address public ethFundDeposit;          // ETH存放地址\n', '    address public newContractAddr;         // token更新地址\n', '\n', '    // crowdsale parameters\n', '    bool    public isFunding;                // 状态切换到true\n', '    uint256 public fundingStartBlock;\n', '    uint256 public fundingStopBlock;\n', '\n', '    uint256 public currentSupply;           // 正在售卖中的tokens数量\n', '    uint256 public tokenRaised = 0;         // 总的售卖数量token\n', '    uint256 public tokenMigrated = 0;     // 总的已经交易的 token\n', '    uint256 public tokenExchangeRate = 625;             // 625 BILIBILI 兑换 1 ETH\n', '\n', '    // events\n', '    event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;\n', '    event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;\n', '    event IncreaseSupply(uint256 _value);\n', '    event DecreaseSupply(uint256 _value);\n', '    event Migrate(address indexed _to, uint256 _value);\n', '\n', '    // 转换\n', '    function formatDecimals(uint256 _value) internal returns (uint256 ) {\n', '        return _value * 10 ** decimals;\n', '    }\n', '\n', '    // constructor\n', '    function BliBliToken(\n', '        address _ethFundDeposit,\n', '        uint256 _currentSupply)\n', '    {\n', '        ethFundDeposit = _ethFundDeposit;\n', '\n', '        isFunding = false;                           //通过控制预CrowdS ale状态\n', '        fundingStartBlock = 0;\n', '        fundingStopBlock = 0;\n', '\n', '        currentSupply = formatDecimals(_currentSupply);\n', '        totalSupply = formatDecimals(10000000);\n', '        balances[msg.sender] = totalSupply;\n', '        if(currentSupply > totalSupply) throw;\n', '    }\n', '\n', '    modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }\n', '\n', '    ///  设置token汇率\n', '    function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {\n', '        if (_tokenExchangeRate == 0) throw;\n', '        if (_tokenExchangeRate == tokenExchangeRate) throw;\n', '\n', '        tokenExchangeRate = _tokenExchangeRate;\n', '    }\n', '\n', '    /// @dev 超发token处理\n', '    function increaseSupply (uint256 _value) isOwner external {\n', '        uint256 value = formatDecimals(_value);\n', '        if (value + currentSupply > totalSupply) throw;\n', '        currentSupply = safeAdd(currentSupply, value);\n', '        IncreaseSupply(value);\n', '    }\n', '\n', '    /// @dev 被盗token处理\n', '    function decreaseSupply (uint256 _value) isOwner external {\n', '        uint256 value = formatDecimals(_value);\n', '        if (value + tokenRaised > currentSupply) throw;\n', '\n', '        currentSupply = safeSubtract(currentSupply, value);\n', '        DecreaseSupply(value);\n', '    }\n', '\n', '    ///  启动区块检测 异常的处理\n', '    function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {\n', '        if (isFunding) throw;\n', '        if (_fundingStartBlock >= _fundingStopBlock) throw;\n', '        if (block.number >= _fundingStartBlock) throw;\n', '\n', '        fundingStartBlock = _fundingStartBlock;\n', '        fundingStopBlock = _fundingStopBlock;\n', '        isFunding = true;\n', '    }\n', '\n', '    ///  关闭区块异常处理\n', '    function stopFunding() isOwner external {\n', '        if (!isFunding) throw;\n', '        isFunding = false;\n', '    }\n', '\n', '    /// 开发了一个新的合同来接收token（或者更新token）\n', '    function setMigrateContract(address _newContractAddr) isOwner external {\n', '        if (_newContractAddr == newContractAddr) throw;\n', '        newContractAddr = _newContractAddr;\n', '    }\n', '\n', '    /// 设置新的所有者地址\n', '    function changeOwner(address _newFundDeposit) isOwner() external {\n', '        if (_newFundDeposit == address(0x0)) throw;\n', '        ethFundDeposit = _newFundDeposit;\n', '    }\n', '\n', '    ///转移token到新的合约\n', '    function migrate() external {\n', '        if(isFunding) throw;\n', '        if(newContractAddr == address(0x0)) throw;\n', '\n', '        uint256 tokens = balances[msg.sender];\n', '        if (tokens == 0) throw;\n', '\n', '        balances[msg.sender] = 0;\n', '        tokenMigrated = safeAdd(tokenMigrated, tokens);\n', '\n', '        IMigrationContract newContract = IMigrationContract(newContractAddr);\n', '        if (!newContract.migrate(msg.sender, tokens)) throw;\n', '\n', '        Migrate(msg.sender, tokens);               // log it\n', '    }\n', '\n', '    /// 转账ETH 到BILIBILI团队\n', '    function transferETH() isOwner external {\n', '        if (this.balance == 0) throw;\n', '        if (!ethFundDeposit.send(this.balance)) throw;\n', '    }\n', '\n', '    ///  将BILIBILI token分配到预处理地址。\n', '    function allocateToken (address _addr, uint256 _eth) isOwner external {\n', '        if (_eth == 0) throw;\n', '        if (_addr == address(0x0)) throw;\n', '\n', '        uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);\n', '        if (tokens + tokenRaised > currentSupply) throw;\n', '\n', '        tokenRaised = safeAdd(tokenRaised, tokens);\n', '        balances[_addr] += tokens;\n', '\n', '        AllocateToken(_addr, tokens);  // 记录token日志\n', '    }\n', '\n', '    /// 购买token\n', '    function () payable {\n', '        if (!isFunding) throw;\n', '        if (msg.value == 0) throw;\n', '\n', '        if (block.number < fundingStartBlock) throw;\n', '        if (block.number > fundingStopBlock) throw;\n', '\n', '        uint256 tokens = safeMult(msg.value, tokenExchangeRate);\n', '        if (tokens + tokenRaised > currentSupply) throw;\n', '\n', '        tokenRaised = safeAdd(tokenRaised, tokens);\n', '        balances[msg.sender] += tokens;\n', '\n', '        IssueToken(msg.sender, tokens);  //记录日志\n', '    }\n', '}']

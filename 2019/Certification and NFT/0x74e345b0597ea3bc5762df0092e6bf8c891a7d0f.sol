['pragma solidity ^0.4.24;\n', '\n', 'contract IMigrationContract {\n', '    function migrate(address addr, uint256 nas) public returns (bool success);\n', '}\n', '\n', '/* 灵感来自于NAS  coin*/\n', 'contract SafeMath {\n', '    function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', '\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract AMToken is StandardToken, SafeMath {\n', '    \n', '    // metadata\n', '    string  public constant name = "Advertising marketing";\n', '    string  public constant symbol = "AM";\n', '    uint256 public constant decimals = 18;\n', '    string  public version = "1.0";\n', '\n', '    // contracts\n', '    address public ethFundDeposit;          // ETH存放地址\n', '    address public newContractAddr;         // token更新地址\n', '\n', '    // crowdsale parameters\n', '    bool    public isFunding;                // 状态切换到true\n', '    uint256 public fundingStartBlock;\n', '    uint256 public fundingStopBlock;\n', '\n', '    uint256 public currentSupply;           // 正在售卖中的tokens数量\n', '    uint256 public tokenRaised = 0;         // 总的售卖数量token\n', '    uint256 public tokenMigrated = 0;     // 总的已经交易的 token\n', '    uint256 public tokenExchangeRate = 300;             // 代币兑换比例 N代币 兑换 1 ETH\n', '\n', '    // events\n', '    event AllocateToken(address indexed _to, uint256 _value);   // allocate token for private sale;\n', '    event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;\n', '    event IncreaseSupply(uint256 _value);\n', '    event DecreaseSupply(uint256 _value);\n', '    event Migrate(address indexed _to, uint256 _value);\n', '\n', '    // 转换\n', '    function formatDecimals(uint256 _value) internal pure returns (uint256 ) {\n', '        return _value * 10 ** decimals;\n', '    }\n', '\n', '    // constructor\n', '    constructor(\n', '        address _ethFundDeposit,\n', '        uint256 _currentSupply) public\n', '    {\n', '        ethFundDeposit = _ethFundDeposit;\n', '\n', '        isFunding = false;                           //通过控制预CrowdS ale状态\n', '        fundingStartBlock = 0;\n', '        fundingStopBlock = 0;\n', '\n', '        currentSupply = formatDecimals(_currentSupply);\n', '        totalSupply = formatDecimals(500000000);\n', '        balances[msg.sender] = totalSupply;\n', '        require(currentSupply <= totalSupply);\n', '    }\n', '\n', '    modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }\n', '\n', '    ///  设置token汇率\n', '    function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {\n', '        require(_tokenExchangeRate != 0);\n', '        require(_tokenExchangeRate != tokenExchangeRate);\n', '\n', '        tokenExchangeRate = _tokenExchangeRate;\n', '    }\n', '\n', '    ///增发代币\n', '    function increaseSupply (uint256 _value) isOwner external {\n', '        uint256 value = formatDecimals(_value);\n', '        require(value + currentSupply <= totalSupply);\n', '        currentSupply = safeAdd(currentSupply, value);\n', '        emit IncreaseSupply(value);\n', '    }\n', '\n', '    ///减少代币\n', '    function decreaseSupply (uint256 _value) isOwner external {\n', '        uint256 value = formatDecimals(_value);\n', '        require(value + tokenRaised <= currentSupply);\n', '\n', '        currentSupply = safeSubtract(currentSupply, value);\n', '        emit DecreaseSupply(value);\n', '    }\n', '\n', '    ///开启\n', '    function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {\n', '        require(!isFunding);\n', '        require(_fundingStartBlock < _fundingStopBlock);\n', '        require(block.number < _fundingStartBlock);\n', '\n', '        fundingStartBlock = _fundingStartBlock;\n', '        fundingStopBlock = _fundingStopBlock;\n', '        isFunding = true;\n', '    }\n', '\n', '    ///关闭\n', '    function stopFunding() isOwner external {\n', '        require(isFunding);\n', '        isFunding = false;\n', '    }\n', '\n', '    ///set a new contract for recieve the tokens (for update contract)\n', '    function setMigrateContract(address _newContractAddr) isOwner external {\n', '        require(_newContractAddr != newContractAddr);\n', '        newContractAddr = _newContractAddr;\n', '    }\n', '\n', '    ///set a new owner.\n', '    function changeOwner(address _newFundDeposit) isOwner() external {\n', '        require(_newFundDeposit != address(0x0));\n', '        ethFundDeposit = _newFundDeposit;\n', '    }\n', '\n', '    ///sends the tokens to new contract\n', '    function migrate() external {\n', '        require(!isFunding);\n', '        require(newContractAddr != address(0x0));\n', '\n', '        uint256 tokens = balances[msg.sender];\n', '        require(tokens != 0);\n', '\n', '        balances[msg.sender] = 0;\n', '        tokenMigrated = safeAdd(tokenMigrated, tokens);\n', '\n', '        IMigrationContract newContract = IMigrationContract(newContractAddr);\n', '        require(newContract.migrate(msg.sender, tokens));\n', '\n', '        emit Migrate(msg.sender, tokens);               // log it\n', '    }\n', '\n', '    /// 转账ETH 到团队\n', '    function transferETH() isOwner external {\n', '        require(address(this).balance != 0);\n', '        require(ethFundDeposit.send(address(this).balance));\n', '    }\n', '\n', '    ///  将token分配到预处理地址。\n', '    function allocateToken (address _addr, uint256 _eth) isOwner external {\n', '        require(_eth != 0);\n', '        require(_addr != address(0x0));\n', '\n', '        uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);\n', '        require(tokens + tokenRaised <= currentSupply);\n', '\n', '        tokenRaised = safeAdd(tokenRaised, tokens);\n', '        balances[_addr] += tokens;\n', '\n', '        emit AllocateToken(_addr, tokens);  // 记录token日志\n', '    }\n', '\n', '    /// 购买token\n', '    function () public payable {\n', '        require(isFunding);\n', '        require(msg.value != 0);\n', '\n', '        require(block.number >= fundingStartBlock);\n', '        require(block.number <= fundingStopBlock);\n', '\n', '        uint256 tokens = safeMult(msg.value, tokenExchangeRate);\n', '        require(tokens + tokenRaised <= currentSupply);\n', '\n', '        tokenRaised = safeAdd(tokenRaised, tokens);\n', '        balances[msg.sender] += tokens;\n', '\n', '        emit IssueToken(msg.sender, tokens);  //记录日志\n', '    }\n', '}']
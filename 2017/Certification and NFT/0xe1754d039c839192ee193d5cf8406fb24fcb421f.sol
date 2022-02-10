['pragma solidity ^0.4.18;\n', '\n', 'contract MigrationAgent {\n', '    function migrateFrom(address _from, uint256 _value);\n', '}\n', '\n', 'contract ERC20Interface {\n', '     function totalSupply() constant returns (uint256 totalSupply);\n', '     function balanceOf(address _owner) constant returns (uint256 balance);\n', '     function transfer(address _to, uint256 _value) returns (bool success);\n', '     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '     function approve(address _spender, uint256 _value) returns (bool success);\n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '     event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/// ETH (EEE)\n', 'contract ETHToken is ERC20Interface {\n', '    string public constant name = "ETHToken";\n', '    string public constant symbol = "EEE";\n', '    uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.\n', '    uint256 public constant tokenCreationCap = 3000000* 10**18;\n', '    uint256 public constant tokenCreationMin = 1* 10**18;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    uint public fundingStart;\n', '    uint public fundingEnd;\n', '    bool public funding = true;\n', '    address public master;\n', '    uint256 totalTokens;\n', '    uint256 soldAfterPowerHour;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => uint) lastTransferred;\n', '    mapping (address => uint256) balancesEther;\n', '    address public migrationAgent;\n', '    uint256 public totalMigrated;\n', '    event Migrate(address indexed _from, address indexed _to, uint256 _value);\n', '    event Refund(address indexed _from, uint256 _value);\n', '    uint totalParticipants;\n', '\n', '    function ETHToken() {\n', '        master = msg.sender;\n', '        fundingStart = 1511654250;\n', '        fundingEnd = 1511663901;\n', '    }\n', '    \n', '    function getAmountofTotalParticipants() constant returns (uint){\n', '        return totalParticipants;\n', '    }\n', '    \n', '    function getAmountSoldAfterPowerDay() constant external returns(uint256){\n', '        return soldAfterPowerHour;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if(funding) throw;\n', '\n', '        var senderBalance = balances[msg.sender];\n', '        if (senderBalance >= _value && _value > 0) {\n', '            senderBalance -= _value;\n', '            balances[msg.sender] = senderBalance;\n', '            \n', '            balances[_to] += _value;\n', '            \n', '            lastTransferred[msg.sender]=block.timestamp;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        return totalTokens;\n', '    }\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    function EtherBalanceOf(address _owner) constant returns (uint256) {\n', '        return balancesEther[_owner];\n', '    }\n', '    function TimeLeft() external constant returns (uint256) {\n', '        if(fundingEnd>block.timestamp)\n', '            return fundingEnd-block.timestamp;\n', '        else\n', '            return 0;\n', '    }\n', '    function TimeLeftBeforeCrowdsale() external constant returns (uint256) {\n', '        if(fundingStart>block.timestamp)\n', '            return fundingStart-block.timestamp;\n', '        else\n', '            return 0;\n', '    }\n', 'function migrate(uint256 _value) external {\n', '        if(funding) throw;\n', '        if(migrationAgent == 0) throw;\n', '        if(_value == 0) throw;\n', '        if(_value > balances[msg.sender]) throw;\n', '        balances[msg.sender] -= _value;\n', '        totalTokens -= _value;\n', '        totalMigrated += _value;\n', '        MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);\n', '        Migrate(msg.sender, migrationAgent, _value);\n', '    }\n', '\n', '    function setMigrationAgent(address _agent) external {\n', '        if(funding) throw;\n', '        \n', '        if(migrationAgent != 0) throw;\n', '        \n', '        if(msg.sender != master) throw;\n', '        \n', '        migrationAgent = 0x52918621C4bFcdb65Bb683ba5bDC03e398451Afd;\n', '    }\n', '    \n', '    function getExchangeRate() constant returns(uint){\n', '            return 30000; // 30000 \n', '    }\n', '    \n', '    function ICOopen() constant returns(bool){\n', '        if(!funding) return false;\n', '        else if(block.timestamp < fundingStart) return false;\n', '        else if(block.timestamp > fundingEnd) return false;\n', '        else if(tokenCreationCap <= totalTokens) return false;\n', '        else return true;\n', '    }\n', '\n', '    function() payable external {\n', '        if(!funding) throw;\n', '        if(block.timestamp < fundingStart) throw;\n', '        if(block.timestamp > fundingEnd) throw;\n', '        if(msg.value == 0) throw;\n', '        if((msg.value  * getExchangeRate()) > (tokenCreationCap - totalTokens)) throw;\n', '        var numTokens = msg.value * getExchangeRate();\n', '        totalTokens += numTokens;\n', '        \n', '        if(getExchangeRate()!=30000){\n', '            soldAfterPowerHour += numTokens;\n', '        }\n', '        balances[msg.sender] += numTokens;\n', '        balancesEther[msg.sender] += msg.value;\n', '        totalParticipants+=1;\n', '        Transfer(0, msg.sender, numTokens);\n', '    }\n', '\n', '    function finalize() external {\n', '        if(!funding) throw;\n', '        funding = false;\n', '        uint256 percentOfTotal = 25;\n', '        uint256 additionalTokens = totalTokens * percentOfTotal / (37 + percentOfTotal);\n', '        totalTokens += additionalTokens;\n', '        balances[master] += additionalTokens;\n', '        Transfer(0, master, additionalTokens);\n', '        if (!master.send(this.balance)) throw;\n', '    }\n', '\n', '    function refund() external {\n', '        if(!funding) throw;\n', '        if(block.timestamp <= fundingEnd) throw;\n', '        if(totalTokens >= tokenCreationMin) throw;\n', '\n', '        var ethuValue = balances[msg.sender];\n', '        var ethValue = balancesEther[msg.sender];\n', '        if (ethuValue == 0) throw;\n', '        balances[msg.sender] = 0;\n', '        balancesEther[msg.sender] = 0;\n', '        totalTokens -= ethuValue;\n', '\n', '        Refund(msg.sender, ethValue);\n', '        if (!msg.sender.send(ethValue)) throw;\n', '    }\n', '  \n', '     function transferFrom(address _from,address _to,uint256 _amount) returns (bool success) {\n', '         if(funding) throw;\n', '         if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[_from] -= _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '     }\n', '  \n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         if(funding) throw;\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '  \n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '     }\n', '}']
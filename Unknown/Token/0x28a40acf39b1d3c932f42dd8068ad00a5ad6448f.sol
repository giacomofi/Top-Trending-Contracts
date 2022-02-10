['pragma solidity ^0.4.13;\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function add(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'contract Token {\n', '\n', '\t/// total amount of tokens\n', '    uint public totalSupply;\n', '\n', '\t/// return tokens balance\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '\n', '\t/// tranfer successful or not\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '\n', '\t/// tranfer successful or not\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '\n', '\t/// approval successful or not\n', '    function approve(address _spender, uint _value) returns (bool success);\n', '\n', '\t/// amount of remaining tokens\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '\n', '\t/// events\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint _value) returns (bool success) {\n', '\t\trequire( msg.data.length >= (2 * 32) + 4 );\n', '\t\trequire( _value > 0 );\n', '\t\trequire( balances[msg.sender] >= _value );\n', '\t\trequire( balances[_to] + _value > balances[_to] );\n', '\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '\t\trequire( msg.data.length >= (3 * 32) + 4 );\n', '\t\trequire( _value > 0 );\n', '\t\trequire( balances[_from] >= _value );\n', '\t\trequire( allowed[_from][msg.sender] >= _value );\n', '\t\trequire( balances[_to] + _value > balances[_to] );\n', '\n', '        balances[_from] -= _value;\n', '\t\tallowed[_from][msg.sender] -= _value;\n', '\t\tbalances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) returns (bool success) {\n', '\t\trequire( _value == 0 || allowed[msg.sender][_spender] == 0 );\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '}\n', '\n', '\n', '\n', 'contract LudumToken is StandardToken {\n', '\n', '    using SafeMath for uint;\n', '\n', '\tstring public constant name = "Ludum"; // Ludum tokens name\n', '    string public constant symbol = "LDM"; // Ludum tokens ticker\n', '    uint8 public constant decimals = 18; // Ludum tokens decimals\n', '\tuint public constant maximumSupply =  100000000000000000000000000; // Maximum 100M Ludum tokens can be created\n', '\n', '    address public ethDepositAddress;\n', '    address public teamFundAddress;\n', '\taddress public operationsFundAddress;\n', '\taddress public marketingFundAddress;\n', '\n', '    bool public isFinalized;\n', '\tuint public constant crowdsaleStart = 1503921600;\n', '\tuint public constant crowdsaleEnd = 1506340800;\n', '\t\n', '\tuint public constant teamPercent = 10;\n', '\tuint public constant operationsPercent = 10;\n', '\tuint public constant marketingPercent = 5;\n', '\n', '\n', '    function ludumTokensPerEther() constant returns(uint) {\n', '\n', '\t\tif (now < crowdsaleStart || now > crowdsaleEnd) {\n', '\t\t\treturn 0;\n', '\t\t} else {\n', '\t\t\tif (now < crowdsaleStart + 1 days) return 15000; // Ludum token sale with 50% bonus\n', '\t\t\tif (now < crowdsaleStart + 7 days) return 13000; // Ludum token sale with 30% bonus\n', '\t\t\tif (now < crowdsaleStart + 14 days) return 11000; // Ludum token sale with 10% bonus\n', '\t\t\treturn 10000; // Ludum token sale\n', '\t\t}\n', '\n', '    }\n', '\n', '\n', '    // events\n', '    event CreateLudumTokens(address indexed _to, uint _value);\n', '\n', '    // Ludum token constructor\n', '    function LudumToken(\n', '        address _ethDepositAddress,\n', '        address _teamFundAddress,\n', '\t\taddress _operationsFundAddress,\n', '\t\taddress _marketingFundAddress\n', '\t)\n', '    {\n', '        isFinalized = false;\n', '        ethDepositAddress = _ethDepositAddress;\n', '        teamFundAddress = _teamFundAddress;\n', '\t    operationsFundAddress = _operationsFundAddress;\n', '\t    marketingFundAddress = _marketingFundAddress;\n', '    }\n', '\n', '\n', '    function makeTokens() payable  {\n', '\t\trequire( !isFinalized );\n', '\t\trequire( now >= crowdsaleStart );\n', '\t\trequire( now < crowdsaleEnd );\n', '\t\trequire( msg.value >= 10 finney );\n', '\n', '        uint tokens = msg.value.mul(ludumTokensPerEther());\n', '\t    uint teamTokens = tokens.mul(teamPercent).div(100);\n', '\t    uint operationsTokens = tokens.mul(operationsPercent).div(100);\n', '\t    uint marketingTokens = tokens.mul(marketingPercent).div(100);\n', '\n', '\t    uint currentSupply = totalSupply.add(tokens).add(teamTokens).add(operationsTokens).add(marketingTokens);\n', '\n', '\t\trequire( maximumSupply >= currentSupply );\n', '\n', '        totalSupply = currentSupply;\n', '\n', '        balances[msg.sender] += tokens;\n', '        CreateLudumTokens(msg.sender, tokens);\n', '\t  \n', '\t    balances[teamFundAddress] += teamTokens;\n', '        CreateLudumTokens(teamFundAddress, teamTokens);\n', '\t  \n', '\t    balances[operationsFundAddress] += operationsTokens;\n', '        CreateLudumTokens(operationsFundAddress, operationsTokens);\n', '\t  \n', '\t    balances[marketingFundAddress] += marketingTokens;\n', '        CreateLudumTokens(marketingFundAddress, marketingTokens);\n', '    }\n', '\n', '\n', '    function() payable {\n', '        makeTokens();\n', '    }\n', '\n', '\n', '    function finalizeCrowdsale() external {\n', '\t\trequire( !isFinalized );\n', '\t\trequire( msg.sender == ethDepositAddress );\n', '\t\trequire( now >= crowdsaleEnd || totalSupply == maximumSupply );\n', '\n', '        isFinalized = true;\n', '\n', '\t\trequire( ethDepositAddress.send(this.balance) );\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.13;\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function add(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'contract Token {\n', '\n', '\t/// total amount of tokens\n', '    uint public totalSupply;\n', '\n', '\t/// return tokens balance\n', '    function balanceOf(address _owner) constant returns (uint balance);\n', '\n', '\t/// tranfer successful or not\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '\n', '\t/// tranfer successful or not\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success);\n', '\n', '\t/// approval successful or not\n', '    function approve(address _spender, uint _value) returns (bool success);\n', '\n', '\t/// amount of remaining tokens\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining);\n', '\n', '\t/// events\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint _value) returns (bool success) {\n', '\t\trequire( msg.data.length >= (2 * 32) + 4 );\n', '\t\trequire( _value > 0 );\n', '\t\trequire( balances[msg.sender] >= _value );\n', '\t\trequire( balances[_to] + _value > balances[_to] );\n', '\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '\t\trequire( msg.data.length >= (3 * 32) + 4 );\n', '\t\trequire( _value > 0 );\n', '\t\trequire( balances[_from] >= _value );\n', '\t\trequire( allowed[_from][msg.sender] >= _value );\n', '\t\trequire( balances[_to] + _value > balances[_to] );\n', '\n', '        balances[_from] -= _value;\n', '\t\tallowed[_from][msg.sender] -= _value;\n', '\t\tbalances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) returns (bool success) {\n', '\t\trequire( _value == 0 || allowed[msg.sender][_spender] == 0 );\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '}\n', '\n', '\n', '\n', 'contract LudumToken is StandardToken {\n', '\n', '    using SafeMath for uint;\n', '\n', '\tstring public constant name = "Ludum"; // Ludum tokens name\n', '    string public constant symbol = "LDM"; // Ludum tokens ticker\n', '    uint8 public constant decimals = 18; // Ludum tokens decimals\n', '\tuint public constant maximumSupply =  100000000000000000000000000; // Maximum 100M Ludum tokens can be created\n', '\n', '    address public ethDepositAddress;\n', '    address public teamFundAddress;\n', '\taddress public operationsFundAddress;\n', '\taddress public marketingFundAddress;\n', '\n', '    bool public isFinalized;\n', '\tuint public constant crowdsaleStart = 1503921600;\n', '\tuint public constant crowdsaleEnd = 1506340800;\n', '\t\n', '\tuint public constant teamPercent = 10;\n', '\tuint public constant operationsPercent = 10;\n', '\tuint public constant marketingPercent = 5;\n', '\n', '\n', '    function ludumTokensPerEther() constant returns(uint) {\n', '\n', '\t\tif (now < crowdsaleStart || now > crowdsaleEnd) {\n', '\t\t\treturn 0;\n', '\t\t} else {\n', '\t\t\tif (now < crowdsaleStart + 1 days) return 15000; // Ludum token sale with 50% bonus\n', '\t\t\tif (now < crowdsaleStart + 7 days) return 13000; // Ludum token sale with 30% bonus\n', '\t\t\tif (now < crowdsaleStart + 14 days) return 11000; // Ludum token sale with 10% bonus\n', '\t\t\treturn 10000; // Ludum token sale\n', '\t\t}\n', '\n', '    }\n', '\n', '\n', '    // events\n', '    event CreateLudumTokens(address indexed _to, uint _value);\n', '\n', '    // Ludum token constructor\n', '    function LudumToken(\n', '        address _ethDepositAddress,\n', '        address _teamFundAddress,\n', '\t\taddress _operationsFundAddress,\n', '\t\taddress _marketingFundAddress\n', '\t)\n', '    {\n', '        isFinalized = false;\n', '        ethDepositAddress = _ethDepositAddress;\n', '        teamFundAddress = _teamFundAddress;\n', '\t    operationsFundAddress = _operationsFundAddress;\n', '\t    marketingFundAddress = _marketingFundAddress;\n', '    }\n', '\n', '\n', '    function makeTokens() payable  {\n', '\t\trequire( !isFinalized );\n', '\t\trequire( now >= crowdsaleStart );\n', '\t\trequire( now < crowdsaleEnd );\n', '\t\trequire( msg.value >= 10 finney );\n', '\n', '        uint tokens = msg.value.mul(ludumTokensPerEther());\n', '\t    uint teamTokens = tokens.mul(teamPercent).div(100);\n', '\t    uint operationsTokens = tokens.mul(operationsPercent).div(100);\n', '\t    uint marketingTokens = tokens.mul(marketingPercent).div(100);\n', '\n', '\t    uint currentSupply = totalSupply.add(tokens).add(teamTokens).add(operationsTokens).add(marketingTokens);\n', '\n', '\t\trequire( maximumSupply >= currentSupply );\n', '\n', '        totalSupply = currentSupply;\n', '\n', '        balances[msg.sender] += tokens;\n', '        CreateLudumTokens(msg.sender, tokens);\n', '\t  \n', '\t    balances[teamFundAddress] += teamTokens;\n', '        CreateLudumTokens(teamFundAddress, teamTokens);\n', '\t  \n', '\t    balances[operationsFundAddress] += operationsTokens;\n', '        CreateLudumTokens(operationsFundAddress, operationsTokens);\n', '\t  \n', '\t    balances[marketingFundAddress] += marketingTokens;\n', '        CreateLudumTokens(marketingFundAddress, marketingTokens);\n', '    }\n', '\n', '\n', '    function() payable {\n', '        makeTokens();\n', '    }\n', '\n', '\n', '    function finalizeCrowdsale() external {\n', '\t\trequire( !isFinalized );\n', '\t\trequire( msg.sender == ethDepositAddress );\n', '\t\trequire( now >= crowdsaleEnd || totalSupply == maximumSupply );\n', '\n', '        isFinalized = true;\n', '\n', '\t\trequire( ethDepositAddress.send(this.balance) );\n', '    }\n', '\n', '}']
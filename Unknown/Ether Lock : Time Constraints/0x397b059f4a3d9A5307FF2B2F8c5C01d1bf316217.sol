['pragma solidity ^0.4.10;\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '      if (balances[msg.sender] >= _value && _value > 0) {\t\t\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract SMEToken is StandardToken {\n', '\n', '    struct Funder{\n', '        address addr;\n', '        uint amount;\n', '    }\n', '\t\n', '    Funder[] funder_list;\n', '\t\n', '    // metadata\n', '\tstring public constant name = "Sumerian Token";\n', '    string public constant symbol = "SUMER";\n', '    uint256 public constant decimals = 18;\n', '    string public version = "1.0";\n', '\t\n', '\tuint256 public constant LOCKPERIOD = 730 days;\n', '\tuint256 public constant LOCKAMOUNT1 = 4000000 * 10**decimals;   //LOCK1\n', '\tuint256 public constant LOCKAMOUNT2 = 4000000 * 10**decimals;   //LOCK2\n', '\tuint256 public constant LOCKAMOUNT3 = 4000000 * 10**decimals;   //LOCK3\n', '\tuint256 public constant LOCKAMOUNT4 = 4000000 * 10**decimals;   //LOCK4\n', '\tuint256 public constant CORNERSTONEAMOUNT = 2000000 * 10**decimals; //cornerstone\n', '    uint256 public constant PLATAMOUNT = 8000000 * 10**decimals;        //crowdfunding plat\t\n', '\n', '                        \n', "    address account1 = '0x5a0A46f082C4718c73F5b30667004AC350E2E140';  //7.5%  First Game\t\n", "\taddress account2 = '0xcD4fC8e4DA5B25885c7d80b6C846afb6b170B49b';  //30%   Management Team ,Game Company ,Law Support \t\n", "\taddress account3 = '0x3d382e76b430bF8fd65eA3AD9ADfc3741D4746A4';  //10%   Technology Operation\n", "\taddress account4 = '0x005CD1194C1F088d9bd8BF9e70e5e44D2194C029';  //22.5%  Blockchain Technology\n", "\taddress account5 = '0x5CA7F20427e4D202777Ea8006dc8f614a289Be2F';  //30%    Exchange Listing , Marketing , Finance\n", '\t\t\t\t\t\t\n', '    uint256 val1 = 1 wei;    // 1\n', '    uint256 val2 = 1 szabo;  // 1 * 10 ** 12\n', '    uint256 val3 = 1 finney; // 1 * 10 ** 15\n', '    uint256 val4 = 1 ether;  // 1 * 10 ** 18\n', '\t\n', '\taddress public creator;\n', '\t\n', '\t\n', '\tuint256 public gcStartTime = 0;     // unix timestamp seconds, 2017/07/15 19:00, 1500116400\n', '\tuint256 public gcEndTime = 0;       // unix timestamp seconds, 2017/08/15 19:00, 1502794800\n', '\t\n', '\tuint256 public ccStartTime = 0;     // unix timestamp seconds, 2017/07/01 19:00, 1498906800\n', '\tuint256 public ccEndTime = 0;       // unix timestamp seconds, 2017/07/15 19:00, 1500116400\n', '\n', '\n', '\tuint256 public gcSupply = 10000000 * 10**decimals;                 // 10000000 for general customer\n', '\tuint256 public constant gcExchangeRate=1000;                       // 1000 SMET per 1 ETH\n', '\t\n', '\tuint256 public ccSupply = 4000000 * 10**decimals;                 // 4000000 for corporate customer \n', '\tuint256 public constant ccExchangeRate=1250;                      // 1250 SMET per 1 ETH      \n', '\t\n', '\tuint256 public totalSupply=0;\n', '\t\n', '\tfunction getFunder(uint index) public constant returns(address, uint) {\n', '        Funder f = funder_list[index];\n', '        \n', '        return (\n', '            f.addr,\n', '            f.amount\n', '        ); \n', '    }\n', '\t\n', '\tfunction clearSmet(){\n', '\t    if (msg.sender != creator) throw;\n', '\t\tbalances[creator] += ccSupply;\n', '\t\tbalances[creator] += gcSupply;\n', '\t\tccSupply = 0;\n', '\t\tgcSupply = 0;\n', '\t\ttotalSupply = 0;\n', '\t}\n', '\n', '    // constructor\n', '    function SMEToken(\n', '\t\tuint256 _gcStartTime,\n', '\t\tuint256 _gcEndTime,\n', '\t\tuint256 _ccStartTime,\n', '\t\tuint256 _ccEndTime\n', '\t\t) {\n', '\t    creator = msg.sender;\n', '\t\ttotalSupply = gcSupply + ccSupply;\n', '\t\tbalances[msg.sender] = CORNERSTONEAMOUNT + PLATAMOUNT;    //for cornerstone investors and crowdfunding plat\n', '\t\tbalances[account1] = LOCKAMOUNT1;                         //10%   Game Company \n', '\t\tbalances[account2] = LOCKAMOUNT2;                         //10%   Management Team\n', '\t\tbalances[account3] = LOCKAMOUNT3;                         //10%   Technology Operation\n', '\t\tbalances[account4] = LOCKAMOUNT4;                         //10%   Blockchain Technology\n', '\t\tgcStartTime = _gcStartTime;\n', '\t\tgcEndTime = _gcEndTime;\n', '\t\tccStartTime = _ccStartTime;\n', '\t\tccEndTime = _ccEndTime;\n', '    }\n', '\t\n', '\tfunction transfer(address _to, uint256 _value) returns (bool success) {\n', '      if (balances[msg.sender] >= _value && _value > 0) {\t\n', '\t    if(msg.sender == account1 || msg.sender == account2 || msg.sender == account3 || msg.sender == account4){\n', '\t\t\tif(now < gcStartTime + LOCKPERIOD){\n', '\t\t\t    return false;\n', '\t\t\t}\n', '\t\t}\n', '\t\telse{\n', '\t\t\tbalances[msg.sender] -= _value;\n', '\t\t\tbalances[_to] += _value;\n', '\t\t\tTransfer(msg.sender, _to, _value);\n', '\t\t\treturn true;\n', '\t\t}\n', '        \n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\t\n', '\n', '    function createTokens() payable {\n', '\t    if (now < ccStartTime) throw;\n', '\t\tif (now > gcEndTime) throw;\n', '\t    if (msg.value < val3) throw;\n', '\t\t\n', '\t\tuint256 smtAmount;\n', '\t\tif (msg.value >= 10*val4 && now <= ccEndTime){\n', '\t\t\tsmtAmount = msg.value * ccExchangeRate;\n', '\t\t\tif (totalSupply < smtAmount) throw;\n', '            if (ccSupply < smtAmount) throw;\n', '            totalSupply -= smtAmount;  \n', '            ccSupply -= smtAmount;    \t\t\t\n', '            balances[msg.sender] += smtAmount;\n', '\t\t    var new_cc_funder = Funder({addr: msg.sender, amount: msg.value / val3});\n', '\t\t    funder_list.push(new_cc_funder);\n', '\t\t}\n', '        else{\n', '\t\t    if(now < gcStartTime) throw;\n', '\t\t\tsmtAmount = msg.value * gcExchangeRate;\n', '\t\t\tif (totalSupply < smtAmount) throw;\n', '            if (gcSupply < smtAmount) throw;\n', '            totalSupply -= smtAmount;  \n', '            gcSupply -= smtAmount;    \t\t\t\n', '            balances[msg.sender] += smtAmount;\n', '\t\t    var new_gc_funder = Funder({addr: msg.sender, amount: msg.value / val3});\n', '\t\t    funder_list.push(new_gc_funder);\n', '\t\t}\t\t\n', '\t\t\n', '        if(!account1.send(msg.value*75/1000)) throw;\n', '\t\tif(!account2.send(msg.value*300/1000)) throw;\n', '\t\tif(!account3.send(msg.value*100/1000)) throw;\n', '\t\tif(!account4.send(msg.value*225/1000)) throw;\n', '\t\tif(!account5.send(msg.value*300/1000)) throw;\n', '    }\n', '\t\n', '\t// fallback\n', '    function() payable {\n', '        createTokens();\n', '    }\n', '\n', '}']
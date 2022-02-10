['pragma solidity ^0.4.10;\n', '\n', 'contract SpeculateCoin {\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    address public owner;\n', '    uint256 public transactions;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    function SpeculateCoin() {\n', '        balances[this] = 2100000000000000;\n', '        name = "SpeculateCoin";     \n', '        symbol = "SPC";\n', '        owner = msg.sender;\n', '        decimals = 8;\n', '        transactions = 124; //number of transactions for the moment of creating new contract\n', '        \n', '        //sending new version of SPC to those 8 users who already bought tokens on the moment of creating new contract (+10,000 bonus for the inconvenience)\n', '        balances[0x58d812Daa585aa0e97F8ecbEF7B5Ee90815eCf11] = 19271548800760 + 1000000000000;\n', '        balances[0x13b34604Ccc38B5d4b058dd6661C5Ec3b13EF045] = 9962341772151 + 1000000000000;\n', '        balances[0xf9f24301713ce954148B62e751127540D817eCcB] = 6378486241488 + 1000000000000;\n', '        balances[0x07A163111C7050FFfeBFcf6118e2D02579028F5B] = 3314087865252 + 1000000000000;\n', '        balances[0x9fDa619519D86e1045423c6ee45303020Aba7759] = 2500000000000 + 1000000000000;\n', '        balances[0x93Fe366Ecff57E994D1A5e3E563088030ea828e2] = 794985754985 + 1000000000000;\n', '        balances[0xbE2b70aB8316D4f81ED12672c4038c1341d21d5b] = 451389230252 + 1000000000000;\n', '        balances[0x1fb4b01DcBdbBc2fb7db6Ed3Dff81F32619B2142] = 100000000000 + 1000000000000;\n', '        balances[this] -= 19271548800760 + 9962341772151 + 6378486241488 + 3314087865252 + 2500000000000 + 794985754985 + 451389230252 + 100000000000 + 8000000000000;\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (2 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '\n', '        uint256 fromBalance = balances[msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance >= _value;\n', '        bool overflowed = balances[_to] + _value < balances[_to];\n', '        \n', '        if (sufficientFunds && !overflowed) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            \n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (3 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '        \n', '        uint256 fromBalance = balances[_from];\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance <= _value;\n', '        bool sufficientAllowance = allowance <= _value;\n', '        bool overflowed = balances[_to] + _value > balances[_to];\n', '\n', '        if (sufficientFunds && sufficientAllowance && !overflowed) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            \n', '            allowed[_from][msg.sender] -= _value;\n', '            \n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        \n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function() payable {\n', '        if(msg.value == 0) { return; }\n', '        uint256 price = 100 + (transactions * 100);\n', '        uint256 amount = msg.value / price;\n', '        if (amount < 100000000 || amount > 1000000000000 || balances[this] < amount) {\n', '            msg.sender.transfer(msg.value);\n', '            return; \n', '        }\n', '        owner.transfer(msg.value);\n', '        balances[msg.sender] += amount;     \n', '        balances[this] -= amount;\n', '        Transfer(this, msg.sender, amount);\n', '        transactions = transactions + 1;\n', '    }\n', '}']
['pragma solidity ^0.4.10;\n', '\n', 'contract SpeculateCoin {\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    address public owner;\n', '    uint256 public transactions;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    function SpeculateCoin() {\n', '        balances[this] = 2100000000000000;\n', '        name = "SpeculateCoin";     \n', '        symbol = "SPC";\n', '        owner = msg.sender;\n', '        decimals = 8;\n', '        transactions = 124; //number of transactions for the moment of creating new contract\n', '        \n', '        //sending new version of SPC to those 8 users who already bought tokens on the moment of creating new contract (+10,000 bonus for the inconvenience)\n', '        balances[0x58d812Daa585aa0e97F8ecbEF7B5Ee90815eCf11] = 19271548800760 + 1000000000000;\n', '        balances[0x13b34604Ccc38B5d4b058dd6661C5Ec3b13EF045] = 9962341772151 + 1000000000000;\n', '        balances[0xf9f24301713ce954148B62e751127540D817eCcB] = 6378486241488 + 1000000000000;\n', '        balances[0x07A163111C7050FFfeBFcf6118e2D02579028F5B] = 3314087865252 + 1000000000000;\n', '        balances[0x9fDa619519D86e1045423c6ee45303020Aba7759] = 2500000000000 + 1000000000000;\n', '        balances[0x93Fe366Ecff57E994D1A5e3E563088030ea828e2] = 794985754985 + 1000000000000;\n', '        balances[0xbE2b70aB8316D4f81ED12672c4038c1341d21d5b] = 451389230252 + 1000000000000;\n', '        balances[0x1fb4b01DcBdbBc2fb7db6Ed3Dff81F32619B2142] = 100000000000 + 1000000000000;\n', '        balances[this] -= 19271548800760 + 9962341772151 + 6378486241488 + 3314087865252 + 2500000000000 + 794985754985 + 451389230252 + 100000000000 + 8000000000000;\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (2 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '\n', '        uint256 fromBalance = balances[msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance >= _value;\n', '        bool overflowed = balances[_to] + _value < balances[_to];\n', '        \n', '        if (sufficientFunds && !overflowed) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            \n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (3 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '        \n', '        uint256 fromBalance = balances[_from];\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance <= _value;\n', '        bool sufficientAllowance = allowance <= _value;\n', '        bool overflowed = balances[_to] + _value > balances[_to];\n', '\n', '        if (sufficientFunds && sufficientAllowance && !overflowed) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            \n', '            allowed[_from][msg.sender] -= _value;\n', '            \n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        \n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function() payable {\n', '        if(msg.value == 0) { return; }\n', '        uint256 price = 100 + (transactions * 100);\n', '        uint256 amount = msg.value / price;\n', '        if (amount < 100000000 || amount > 1000000000000 || balances[this] < amount) {\n', '            msg.sender.transfer(msg.value);\n', '            return; \n', '        }\n', '        owner.transfer(msg.value);\n', '        balances[msg.sender] += amount;     \n', '        balances[this] -= amount;\n', '        Transfer(this, msg.sender, amount);\n', '        transactions = transactions + 1;\n', '    }\n', '}']
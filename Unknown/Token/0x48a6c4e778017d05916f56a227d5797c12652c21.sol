['pragma solidity ^0.4.10;\n', '\n', 'contract ForeignToken \n', '{\n', '    function balanceOf(address _owner) constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) returns (bool);\n', '}\n', '\n', 'contract BEtherToken\n', '{\n', '    address owner = msg.sender;\n', '    bool public purchasingAllowed = true;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalContribution = 0;\n', '    uint256 public totalSupply = 0;\n', '\n', '    function name() constant returns (string) { return "bEther Token"; }\n', '    function symbol() constant returns (string) { return "BET"; }\n', '    function decimals() constant returns (uint8) { return 18; }\n', '    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) \n', '    {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (2 * 32) + 4) \n', '\t\t{ \n', '\t\t\tthrow; \n', '\t\t}\n', '\n', '        if (_value == 0)\n', '        {\n', '            return false;\n', '        }\n', '\n', '        uint256 fromBalance = balances[msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance >= _value;\n', '        bool overflowed = balances[_to] + _value < balances[_to];\n', '        \n', '        if (sufficientFunds && !overflowed) \n', '        {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            \n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } \n', '        else \n', '        { \n', '            return false;\n', '        }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) \n', '    {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (3 * 32) + 4) \n', '        { \n', '            throw;\n', '        }\n', '\n', '        if (_value == 0) \n', '        { \n', '            return false;\n', '        }\n', '        \n', '        uint256 fromBalance = balances[_from];\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance <= _value;\n', '        bool sufficientAllowance = allowance <= _value;\n', '        bool overflowed = balances[_to] + _value > balances[_to];\n', '\n', '        if (sufficientFunds && sufficientAllowance && !overflowed) \n', '        {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            \n', '            allowed[_from][msg.sender] -= _value;\n', '            \n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } \n', '        else \n', '        { \n', '            return false;\n', '        }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) \n', '    {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) \n', '        { \n', '            return false;\n', '        }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256) \n', '\t{\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function enablePurchasing() \n', '\t{\n', '        if (msg.sender != owner) \n', '\t\t{ \n', '\t\t\tthrow; \n', '\t\t}\n', '\n', '        purchasingAllowed = true;\n', '    }\n', '\n', '    function disablePurchasing() \n', '\t{\n', '        if (msg.sender != owner) \n', '\t\t{ \n', '\t\t\tthrow; \n', '\t\t}\n', '\n', '        purchasingAllowed = false;\n', '    }\n', '\n', '    function withdrawForeignTokens(address _tokenContract) returns (bool) \n', '\t{\n', '        if (msg.sender != owner) \n', '\t\t{ \n', '\t\t\tthrow; \n', '\t\t}\n', '\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '    function getStats() constant returns (uint256, uint256, bool) \n', '\t{\n', '        return (totalContribution, totalSupply, purchasingAllowed);\n', '    }\n', '\n', '    function() payable \n', '\t{\n', '        if (!purchasingAllowed) \n', '\t\t{ \n', '\t\t\tthrow; \n', '\t\t}\n', '        \n', '        if (msg.value == 0) \n', '\t\t{ \n', '\t\t\treturn; \n', '\t\t}\n', '\n', '        owner.transfer(msg.value);\n', '        totalContribution += msg.value;\n', '\n', '        uint256 tokensIssued = (msg.value * 1000);\n', '\n', '        totalSupply += tokensIssued;\n', '        balances[msg.sender] += tokensIssued;\n', '        \n', '        Transfer(address(this), msg.sender, tokensIssued);\n', '    }\n', '}']
['pragma solidity ^0.4.10;\n', '\n', 'contract ForeignToken \n', '{\n', '    function balanceOf(address _owner) constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) returns (bool);\n', '}\n', '\n', 'contract BEtherToken\n', '{\n', '    address owner = msg.sender;\n', '    bool public purchasingAllowed = true;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalContribution = 0;\n', '    uint256 public totalSupply = 0;\n', '\n', '    function name() constant returns (string) { return "bEther Token"; }\n', '    function symbol() constant returns (string) { return "BET"; }\n', '    function decimals() constant returns (uint8) { return 18; }\n', '    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) \n', '    {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (2 * 32) + 4) \n', '\t\t{ \n', '\t\t\tthrow; \n', '\t\t}\n', '\n', '        if (_value == 0)\n', '        {\n', '            return false;\n', '        }\n', '\n', '        uint256 fromBalance = balances[msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance >= _value;\n', '        bool overflowed = balances[_to] + _value < balances[_to];\n', '        \n', '        if (sufficientFunds && !overflowed) \n', '        {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            \n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } \n', '        else \n', '        { \n', '            return false;\n', '        }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) \n', '    {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (3 * 32) + 4) \n', '        { \n', '            throw;\n', '        }\n', '\n', '        if (_value == 0) \n', '        { \n', '            return false;\n', '        }\n', '        \n', '        uint256 fromBalance = balances[_from];\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance <= _value;\n', '        bool sufficientAllowance = allowance <= _value;\n', '        bool overflowed = balances[_to] + _value > balances[_to];\n', '\n', '        if (sufficientFunds && sufficientAllowance && !overflowed) \n', '        {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            \n', '            allowed[_from][msg.sender] -= _value;\n', '            \n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } \n', '        else \n', '        { \n', '            return false;\n', '        }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) \n', '    {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) \n', '        { \n', '            return false;\n', '        }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256) \n', '\t{\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function enablePurchasing() \n', '\t{\n', '        if (msg.sender != owner) \n', '\t\t{ \n', '\t\t\tthrow; \n', '\t\t}\n', '\n', '        purchasingAllowed = true;\n', '    }\n', '\n', '    function disablePurchasing() \n', '\t{\n', '        if (msg.sender != owner) \n', '\t\t{ \n', '\t\t\tthrow; \n', '\t\t}\n', '\n', '        purchasingAllowed = false;\n', '    }\n', '\n', '    function withdrawForeignTokens(address _tokenContract) returns (bool) \n', '\t{\n', '        if (msg.sender != owner) \n', '\t\t{ \n', '\t\t\tthrow; \n', '\t\t}\n', '\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '    function getStats() constant returns (uint256, uint256, bool) \n', '\t{\n', '        return (totalContribution, totalSupply, purchasingAllowed);\n', '    }\n', '\n', '    function() payable \n', '\t{\n', '        if (!purchasingAllowed) \n', '\t\t{ \n', '\t\t\tthrow; \n', '\t\t}\n', '        \n', '        if (msg.value == 0) \n', '\t\t{ \n', '\t\t\treturn; \n', '\t\t}\n', '\n', '        owner.transfer(msg.value);\n', '        totalContribution += msg.value;\n', '\n', '        uint256 tokensIssued = (msg.value * 1000);\n', '\n', '        totalSupply += tokensIssued;\n', '        balances[msg.sender] += tokensIssued;\n', '        \n', '        Transfer(address(this), msg.sender, tokensIssued);\n', '    }\n', '}']

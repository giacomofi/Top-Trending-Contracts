['pragma solidity ^0.4.18;\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) returns (bool);\n', '}\n', '\n', 'contract XmasToken {\n', '    address owner = msg.sender;\n', '\n', '    bool public purchasingAllowed = false;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalContribution = 0;\n', '\n', '    uint256 public totalSupply = 0;\n', '    uint256 public hardCap = 1000000;\n', '    \n', '    function name() constant returns (string) { return "XmasToken Limited Edition"; }\n', '    function symbol() constant returns (string) { return "XMAS"; }\n', '    function decimals() constant returns (uint8) { return 0; }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (2 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '\n', '        uint256 fromBalance = balances[msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance >= _value;\n', '        bool overflowed = balances[_to] + _value < balances[_to];\n', '\n', '        if (sufficientFunds && !overflowed) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (3 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '\n', '        uint256 fromBalance = balances[_from];\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance >= _value;\n', '        bool sufficientAllowance = allowance >= _value;\n', '        bool overflowed = balances[_to] + _value > balances[_to];\n', '\n', '        if (sufficientFunds && sufficientAllowance && !overflowed) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '\n', '            allowed[_from][msg.sender] -= _value;\n', '\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function enablePurchasing() {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        purchasingAllowed = true;\n', '    }\n', '\n', '    function disablePurchasing() {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        purchasingAllowed = false;\n', '    }\n', '\n', '    function withdrawForeignTokens(address _tokenContract) returns (bool) {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '    function getStats() constant returns (uint256, uint256, uint256, bool) {\n', '        return (totalContribution, totalSupply, hardCap, purchasingAllowed);\n', '    }\n', '\n', '    function() payable {\n', '        if (!purchasingAllowed) { throw; }\n', '\n', '        if (msg.value == 0) { return; }\n', '\n', '        uint256 tokensIssued = (msg.value / 10000000000000000 + 2 * (msg.value / uint256(100000000000000000)) + 5 * (msg.value / uint256(1000000000000000000)));\n', '\n', '        if (totalSupply + tokensIssued > hardCap || tokensIssued == 0) {return; }\n', '        \n', '        owner.transfer(msg.value);\n', '        totalContribution += msg.value;\n', '        \n', '        totalSupply += tokensIssued;\n', '        \n', '        balances[msg.sender] += tokensIssued;\n', '\n', '        Transfer(address(this), msg.sender, tokensIssued);\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) returns (bool);\n', '}\n', '\n', 'contract Aquarius_ZodiacToken {\n', '    address owner = msg.sender;\n', '\n', '    bool public purchasingAllowed = true;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalContribution = 0;\n', '    uint256 public totalBonusTokensIssued = 0;\n', '    uint    public MINfinney    = 0;\n', '    uint    public AIRDROPBounce    = 50000000;\n', '    uint    public ICORatio     = 144000;\n', '    uint256 public totalSupply = 0;\n', '\n', '    function name() constant returns (string) { return "Aquarius_ZodiacToken"; }\n', '    function symbol() constant returns (string) { return "AQR♒"; }\n', '    function decimals() constant returns (uint8) { return 8; }\n', '    event Burnt(\n', '        address indexed _receiver,\n', '        uint indexed _num,\n', '        uint indexed _total_supply\n', '    );\n', ' \n', ' \n', ' \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '       assert(b <= a);\n', '       return a - b;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (2 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '\n', '        uint256 fromBalance = balances[msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance >= _value;\n', '        bool overflowed = balances[_to] + _value < balances[_to];\n', '        \n', '        if (sufficientFunds && !overflowed) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            \n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (3 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '        \n', '        uint256 fromBalance = balances[_from];\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance <= _value;\n', '        bool sufficientAllowance = allowance <= _value;\n', '        bool overflowed = balances[_to] + _value > balances[_to];\n', '\n', '        if (sufficientFunds && sufficientAllowance && !overflowed) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            \n', '            allowed[_from][msg.sender] -= _value;\n', '            \n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        \n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '\t\n', '    function enablePurchasing() {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        purchasingAllowed = true;\n', '    }\n', '\n', '    function disablePurchasing() {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        purchasingAllowed = false;\n', '    }\n', '\n', '    function withdrawForeignTokens(address _tokenContract) returns (bool) {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '    function getStats() constant returns (uint256, uint256, uint256, bool) {\n', '        return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);\n', '    }\n', '\n', '    function setAIRDROPBounce(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        AIRDROPBounce = _newPrice;\n', '    }\n', '\n', '    function setICORatio(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        ICORatio = _newPrice;\n', '    }\n', '\n', '    function setMINfinney(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        MINfinney = _newPrice;\n', '    }\n', ' \n', '\n', '    function() payable {\n', '        if (!purchasingAllowed) { throw; }\n', '        \n', '        if (msg.value < 1 finney * MINfinney) { return; }\n', '\n', '        owner.transfer(msg.value);\n', '        totalContribution += msg.value;\n', '\n', '        uint256 tokensIssued = (msg.value / 1e10) * ICORatio + AIRDROPBounce * 1e8;\n', '\n', '\n', '        totalSupply += tokensIssued;\n', '        balances[msg.sender] += tokensIssued;\n', '        \n', '        Transfer(address(this), msg.sender, tokensIssued);\n', '    }\n', '\n', '    function withdraw() public {\n', '        uint256 etherBalance = this.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '\n', '    function burn(uint num) public {\n', '        require(num * 1e8 > 0);\n', '        require(balances[msg.sender] >= num * 1e8);\n', '        require(totalSupply >= num * 1e8);\n', '\n', '        uint pre_balance = balances[msg.sender];\n', '\n', '        balances[msg.sender] -= num * 1e8;\n', '        totalSupply -= num * 1e8;\n', '        Burnt(msg.sender, num * 1e8, totalSupply);\n', '        Transfer(msg.sender, 0x0, num * 1e8);\n', '\n', '        assert(balances[msg.sender] == pre_balance - num * 1e8);\n', '    }\n', '\n', '    \n', '}']
['pragma solidity ^0.4.19;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) returns (bool);\n', '}\n', '\n', 'contract Aquarius_ZodiacToken {\n', '    address owner = msg.sender;\n', '\n', '    bool public purchasingAllowed = true;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalContribution = 0;\n', '    uint256 public totalBonusTokensIssued = 0;\n', '    uint    public MINfinney    = 0;\n', '    uint    public AIRDROPBounce    = 50000000;\n', '    uint    public ICORatio     = 144000;\n', '    uint256 public totalSupply = 0;\n', '\n', '    function name() constant returns (string) { return "Aquarius_ZodiacToken"; }\n', '    function symbol() constant returns (string) { return "AQR♒"; }\n', '    function decimals() constant returns (uint8) { return 8; }\n', '    event Burnt(\n', '        address indexed _receiver,\n', '        uint indexed _num,\n', '        uint indexed _total_supply\n', '    );\n', ' \n', ' \n', ' \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '       assert(b <= a);\n', '       return a - b;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }\n', '    \n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (2 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '\n', '        uint256 fromBalance = balances[msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance >= _value;\n', '        bool overflowed = balances[_to] + _value < balances[_to];\n', '        \n', '        if (sufficientFunds && !overflowed) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            \n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 short address attack\n', '        if(msg.data.length < (3 * 32) + 4) { throw; }\n', '\n', '        if (_value == 0) { return false; }\n', '        \n', '        uint256 fromBalance = balances[_from];\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '\n', '        bool sufficientFunds = fromBalance <= _value;\n', '        bool sufficientAllowance = allowance <= _value;\n', '        bool overflowed = balances[_to] + _value > balances[_to];\n', '\n', '        if (sufficientFunds && sufficientAllowance && !overflowed) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            \n', '            allowed[_from][msg.sender] -= _value;\n', '            \n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        \n', '        allowed[msg.sender][_spender] = _value;\n', '        \n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '\t\n', '    function enablePurchasing() {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        purchasingAllowed = true;\n', '    }\n', '\n', '    function disablePurchasing() {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        purchasingAllowed = false;\n', '    }\n', '\n', '    function withdrawForeignTokens(address _tokenContract) returns (bool) {\n', '        if (msg.sender != owner) { throw; }\n', '\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '    function getStats() constant returns (uint256, uint256, uint256, bool) {\n', '        return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);\n', '    }\n', '\n', '    function setAIRDROPBounce(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        AIRDROPBounce = _newPrice;\n', '    }\n', '\n', '    function setICORatio(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        ICORatio = _newPrice;\n', '    }\n', '\n', '    function setMINfinney(uint _newPrice)  {\n', '        if (msg.sender != owner) { throw; }\n', '        MINfinney = _newPrice;\n', '    }\n', ' \n', '\n', '    function() payable {\n', '        if (!purchasingAllowed) { throw; }\n', '        \n', '        if (msg.value < 1 finney * MINfinney) { return; }\n', '\n', '        owner.transfer(msg.value);\n', '        totalContribution += msg.value;\n', '\n', '        uint256 tokensIssued = (msg.value / 1e10) * ICORatio + AIRDROPBounce * 1e8;\n', '\n', '\n', '        totalSupply += tokensIssued;\n', '        balances[msg.sender] += tokensIssued;\n', '        \n', '        Transfer(address(this), msg.sender, tokensIssued);\n', '    }\n', '\n', '    function withdraw() public {\n', '        uint256 etherBalance = this.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '\n', '    function burn(uint num) public {\n', '        require(num * 1e8 > 0);\n', '        require(balances[msg.sender] >= num * 1e8);\n', '        require(totalSupply >= num * 1e8);\n', '\n', '        uint pre_balance = balances[msg.sender];\n', '\n', '        balances[msg.sender] -= num * 1e8;\n', '        totalSupply -= num * 1e8;\n', '        Burnt(msg.sender, num * 1e8, totalSupply);\n', '        Transfer(msg.sender, 0x0, num * 1e8);\n', '\n', '        assert(balances[msg.sender] == pre_balance - num * 1e8);\n', '    }\n', '\n', '    \n', '}']
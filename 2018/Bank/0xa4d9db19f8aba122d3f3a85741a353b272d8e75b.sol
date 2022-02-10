['pragma solidity ^0.4.19;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface Token { \n', '    function distr(address _to, uint256 _value) public returns (bool);\n', '    function totalSupply() constant public returns (uint256 supply);\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '}\n', '\n', 'contract pokerbox is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => bool) public blacklist;\n', '\n', '    string public constant name = "pokerbox";\n', '    string public constant symbol = "PEX";\n', '    uint public constant decimals = 18;\n', '    \n', '    uint256 public totalSupply = 30000000000e18;\n', '    uint256 private totalReserved = (totalSupply.div(100)).mul(15);\n', '    uint256 private totalBounties = (totalSupply.div(100)).mul(10);\n', '    uint256 public totalDistributed = totalReserved.add(totalBounties);\n', '    uint256 public totalRemaining = totalSupply.sub(totalDistributed);\n', '    uint256 public value;\n', '    uint256 public minReq;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '    \n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    bool public distributionFinished = false;\n', '    \n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyWhitelist() {\n', '        require(blacklist[msg.sender] == false);\n', '        _;\n', '    }\n', '    \n', '    function pokerbox (uint256 _value, uint256 _minReq) public {\n', '        owner = msg.sender;\n', '        value = _value;\n', '        minReq = _minReq;\n', '        balances[msg.sender] = totalDistributed;\n', '    }\n', '    \n', '     function setParameters (uint256 _value, uint256 _minReq) onlyOwner public {\n', '        value = _value;\n', '        minReq = _minReq;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '    \n', '    function enableWhitelist(address[] addresses) onlyOwner public {\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            blacklist[addresses[i]] = false;\n', '        }\n', '    }\n', '\n', '    function disableWhitelist(address[] addresses) onlyOwner public {\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            blacklist[addresses[i]] = true;\n', '        }\n', '    }\n', '\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        DistrFinished();\n', '        return true;\n', '    }\n', '    \n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        totalDistributed = totalDistributed.add(_amount);\n', '        totalRemaining = totalRemaining.sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Distr(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '        \n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function airdrop(address[] addresses) onlyOwner canDistr public {\n', '        \n', '        require(addresses.length <= 255);\n', '        require(value <= totalRemaining);\n', '        \n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(value <= totalRemaining);\n', '            distr(addresses[i], value);\n', '        }\n', '\t\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {\n', '        \n', '        require(addresses.length <= 255);\n', '        require(amount <= totalRemaining);\n', '        \n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(amount <= totalRemaining);\n', '            distr(addresses[i], amount);\n', '        }\n', '\t\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '        \n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            require(amounts[i] <= totalRemaining);\n', '            distr(addresses[i], amounts[i]);\n', '            \n', '            if (totalDistributed >= totalSupply) {\n', '                distributionFinished = true;\n', '            }\n', '        }\n', '    }\n', '    \n', '    function () external payable {\n', '            getTokens();\n', '     }\n', '    \n', '    function getTokens() payable canDistr onlyWhitelist public {\n', '        \n', '        require(value <= totalRemaining);\n', '        \n', '        address investor = msg.sender;\n', '        uint256 toGive = value;\n', '        \n', '        if (msg.value < minReq){\n', '            toGive = value.sub(value);\n', '        }\n', '        \n', '        distr(investor, toGive);\n', '        \n', '        if (toGive > 0) {\n', '            blacklist[investor] = true;\n', '        }\n', '\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '\t    return balances[_owner];\n', '    }\n', '\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', '        ForeignToken t = ForeignToken(tokenAddress);\n', '        uint bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        uint256 etherBalance = this.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '    \n', '    function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface Token { \n', '    function distr(address _to, uint256 _value) public returns (bool);\n', '    function totalSupply() constant public returns (uint256 supply);\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '}\n', '\n', 'contract pokerbox is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => bool) public blacklist;\n', '\n', '    string public constant name = "pokerbox";\n', '    string public constant symbol = "PEX";\n', '    uint public constant decimals = 18;\n', '    \n', '    uint256 public totalSupply = 30000000000e18;\n', '    uint256 private totalReserved = (totalSupply.div(100)).mul(15);\n', '    uint256 private totalBounties = (totalSupply.div(100)).mul(10);\n', '    uint256 public totalDistributed = totalReserved.add(totalBounties);\n', '    uint256 public totalRemaining = totalSupply.sub(totalDistributed);\n', '    uint256 public value;\n', '    uint256 public minReq;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '    \n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    bool public distributionFinished = false;\n', '    \n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyWhitelist() {\n', '        require(blacklist[msg.sender] == false);\n', '        _;\n', '    }\n', '    \n', '    function pokerbox (uint256 _value, uint256 _minReq) public {\n', '        owner = msg.sender;\n', '        value = _value;\n', '        minReq = _minReq;\n', '        balances[msg.sender] = totalDistributed;\n', '    }\n', '    \n', '     function setParameters (uint256 _value, uint256 _minReq) onlyOwner public {\n', '        value = _value;\n', '        minReq = _minReq;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '    \n', '    function enableWhitelist(address[] addresses) onlyOwner public {\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            blacklist[addresses[i]] = false;\n', '        }\n', '    }\n', '\n', '    function disableWhitelist(address[] addresses) onlyOwner public {\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            blacklist[addresses[i]] = true;\n', '        }\n', '    }\n', '\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        DistrFinished();\n', '        return true;\n', '    }\n', '    \n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        totalDistributed = totalDistributed.add(_amount);\n', '        totalRemaining = totalRemaining.sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Distr(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '        \n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function airdrop(address[] addresses) onlyOwner canDistr public {\n', '        \n', '        require(addresses.length <= 255);\n', '        require(value <= totalRemaining);\n', '        \n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(value <= totalRemaining);\n', '            distr(addresses[i], value);\n', '        }\n', '\t\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {\n', '        \n', '        require(addresses.length <= 255);\n', '        require(amount <= totalRemaining);\n', '        \n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(amount <= totalRemaining);\n', '            distr(addresses[i], amount);\n', '        }\n', '\t\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '        \n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            require(amounts[i] <= totalRemaining);\n', '            distr(addresses[i], amounts[i]);\n', '            \n', '            if (totalDistributed >= totalSupply) {\n', '                distributionFinished = true;\n', '            }\n', '        }\n', '    }\n', '    \n', '    function () external payable {\n', '            getTokens();\n', '     }\n', '    \n', '    function getTokens() payable canDistr onlyWhitelist public {\n', '        \n', '        require(value <= totalRemaining);\n', '        \n', '        address investor = msg.sender;\n', '        uint256 toGive = value;\n', '        \n', '        if (msg.value < minReq){\n', '            toGive = value.sub(value);\n', '        }\n', '        \n', '        distr(investor, toGive);\n', '        \n', '        if (toGive > 0) {\n', '            blacklist[investor] = true;\n', '        }\n', '\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '\t    return balances[_owner];\n', '    }\n', '\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', '        ForeignToken t = ForeignToken(tokenAddress);\n', '        uint bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        uint256 etherBalance = this.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '    \n', '    function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '\n', '}']

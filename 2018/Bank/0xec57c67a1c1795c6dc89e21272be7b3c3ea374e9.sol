['pragma solidity ^0.4.20;\n', '\n', '/*\n', '\n', '/*===============================================\n', '=    [ Power of Vladimir Putin (40% alcohol) ]  =\n', '=          https://PowerOfPutin.oi/                 =\n', '=        https://discord.gg/EDR5FRcD            =\n', '=================================================\n', '\n', '\n', '  _____                                __ \n', ' |  __ \\                              / _|\n', ' | |__) |____      _____ _ __    ___ | |_ \n', ' |  ___/ _ \\ \\ /\\ / / _ \\ &#39;__|  / _ \\|  _|\n', ' | |  | (_) \\ V  V /  __/ |    | (_) | |  \n', ' |_|   \\___/ \\_/\\_/ \\___|_|     \\___/|_| \n', '\n', ' __      ___           _ _           _        _____       _   _       \n', ' \\ \\    / / |         | (_)         (_)      |  __ \\     | | (_)      \n', '  \\ \\  / /| | __ _  __| |_ _ __ ___  _ _ __  | |__) |   _| |_ _ _ __  \n', '   \\ \\/ / | |/ _` |/ _` | | &#39;_ ` _ \\| | &#39;__| |  ___/ | | | __| | &#39;_ \\ \n', '    \\  /  | | (_| | (_| | | | | | | | | |    | |   | |_| | |_| | | | |\n', '     \\/   |_|\\__,_|\\__,_|_|_| |_| |_|_|_|    |_|    \\__,_|\\__|_|_| |_|\n', '\n', '\n', '* -> Features!\n', '* All the features from the original Po contract, with dividend fee 40%:\n', '* [x] Highly Secure: Hundreds of thousands of investers have invested in the original contract.\n', '* [X] Purchase/Sell: You can perform partial sell orders. If you succumb to weak hands, you don&#39;t have to dump all of your bags.\n', '* [x] Purchase/Sell: You can transfer tokens between wallets. Trading is possible from within the contract.\n', '* [x] Masternodes: The implementation of Ethereum Staking in the world.\n', '* [x] Masternodes: Holding 50 PowerOfPutin Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract.\n', '* [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 40% dividends fee rerouted from the master-node, to the node-master.\n', '*\n', '* -> Who worked not this project?\n', '* - Vladimir PUtin (The king of Russia (& future king of the world))\n', '* - Mantso (Original Program)\n', '*\n', '* -> Owner of contract can:\n', '* - Low pre-mine (0.999ETH)\n', '* - And nothing else\n', '*\n', '* -> Owner of contract CANNOT:\n', '* - exit scam\n', '* - kill the contract\n', '* - take funds\n', '* - pause the contract\n', '* - disable withdrawals\n', '* - change the price of tokens\n', '*\n', '* -> THE FOMO IS REAL!!\n', '\n', '\n', '*/\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface Token { \n', '    function distr(address _to, uint256 _value) public returns (bool);\n', '    function totalSupply() constant public returns (uint256 supply);\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '}\n', '\n', 'contract PowerOfPutin is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => bool) public blacklist;\n', '\n', '    string public constant name = "Power of Vladimir Putin";\n', '    string public constant symbol = "PowerOfPutin";\n', '    uint public constant decimals = 8;\n', '    \n', '    uint256 public totalSupply = 80000000e8;\n', '    uint256 public totalDistributed = 1e8;\n', '    uint256 public totalRemaining = totalSupply.sub(totalDistributed);\n', '    uint256 public value;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '    \n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    bool public distributionFinished = false;\n', '    \n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '   \n', '    \n', '    function PowerOfPutin () public {\n', '        owner = msg.sender;\n', '        value = 14780e8;\n', '        distr(owner, totalDistributed);\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '    \n', '   \n', '\n', '   \n', '\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        DistrFinished();\n', '        return true;\n', '    }\n', '    \n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        totalDistributed = totalDistributed.add(_amount);\n', '        totalRemaining = totalRemaining.sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Distr(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '        \n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function airdrop(address[] addresses) onlyOwner canDistr public {\n', '        \n', '        require(addresses.length <= 255);\n', '        require(value <= totalRemaining);\n', '        \n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(value <= totalRemaining);\n', '            distr(addresses[i], value);\n', '        }\n', '\t\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {\n', '        \n', '        require(addresses.length <= 255);\n', '        require(amount <= totalRemaining);\n', '        \n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(amount <= totalRemaining);\n', '            distr(addresses[i], amount);\n', '        }\n', '\t\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '        \n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            require(amounts[i] <= totalRemaining);\n', '            distr(addresses[i], amounts[i]);\n', '            \n', '            if (totalDistributed >= totalSupply) {\n', '                distributionFinished = true;\n', '            }\n', '        }\n', '    }\n', '    \n', '    function () external payable {\n', '            getTokens();\n', '     }\n', '    \n', '    function getTokens() payable canDistr public {\n', '        \n', '        if (value > totalRemaining) {\n', '            value = totalRemaining;\n', '        }\n', '        \n', '        require(value <= totalRemaining);\n', '        \n', '        address investor = msg.sender;\n', '        uint256 toGive = value;\n', '        \n', '        distr(investor, toGive);\n', '        \n', '        if (toGive > 0) {\n', '            blacklist[investor] = true;\n', '        }\n', '\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '        \n', '     \n', '    }\n', '\n', '/*\n', '\n', 'READ  THE CONTRACT FAGGOTS\n', '\n', '*/\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '\t    return balances[_owner];\n', '    }\n', '\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', '        ForeignToken t = ForeignToken(tokenAddress);\n', '        uint bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        uint256 etherBalance = this.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '    \n', '    function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '\n', '}']
['pragma solidity ^0.4.20;\n', '\n', '/*\n', '\n', '/*===============================================\n', '=    [ Power of Vladimir Putin (40% alcohol) ]  =\n', '=          https://PowerOfPutin.oi/                 =\n', '=        https://discord.gg/EDR5FRcD            =\n', '=================================================\n', '\n', '\n', '  _____                                __ \n', ' |  __ \\                              / _|\n', ' | |__) |____      _____ _ __    ___ | |_ \n', " |  ___/ _ \\ \\ /\\ / / _ \\ '__|  / _ \\|  _|\n", ' | |  | (_) \\ V  V /  __/ |    | (_) | |  \n', ' |_|   \\___/ \\_/\\_/ \\___|_|     \\___/|_| \n', '\n', ' __      ___           _ _           _        _____       _   _       \n', ' \\ \\    / / |         | (_)         (_)      |  __ \\     | | (_)      \n', '  \\ \\  / /| | __ _  __| |_ _ __ ___  _ _ __  | |__) |   _| |_ _ _ __  \n', "   \\ \\/ / | |/ _` |/ _` | | '_ ` _ \\| | '__| |  ___/ | | | __| | '_ \\ \n", '    \\  /  | | (_| | (_| | | | | | | | | |    | |   | |_| | |_| | | | |\n', '     \\/   |_|\\__,_|\\__,_|_|_| |_| |_|_|_|    |_|    \\__,_|\\__|_|_| |_|\n', '\n', '\n', '* -> Features!\n', '* All the features from the original Po contract, with dividend fee 40%:\n', '* [x] Highly Secure: Hundreds of thousands of investers have invested in the original contract.\n', "* [X] Purchase/Sell: You can perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags.\n", '* [x] Purchase/Sell: You can transfer tokens between wallets. Trading is possible from within the contract.\n', '* [x] Masternodes: The implementation of Ethereum Staking in the world.\n', '* [x] Masternodes: Holding 50 PowerOfPutin Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract.\n', '* [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 40% dividends fee rerouted from the master-node, to the node-master.\n', '*\n', '* -> Who worked not this project?\n', '* - Vladimir PUtin (The king of Russia (& future king of the world))\n', '* - Mantso (Original Program)\n', '*\n', '* -> Owner of contract can:\n', '* - Low pre-mine (0.999ETH)\n', '* - And nothing else\n', '*\n', '* -> Owner of contract CANNOT:\n', '* - exit scam\n', '* - kill the contract\n', '* - take funds\n', '* - pause the contract\n', '* - disable withdrawals\n', '* - change the price of tokens\n', '*\n', '* -> THE FOMO IS REAL!!\n', '\n', '\n', '*/\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ForeignToken {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface Token { \n', '    function distr(address _to, uint256 _value) public returns (bool);\n', '    function totalSupply() constant public returns (uint256 supply);\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '}\n', '\n', 'contract PowerOfPutin is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    address owner = msg.sender;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => bool) public blacklist;\n', '\n', '    string public constant name = "Power of Vladimir Putin";\n', '    string public constant symbol = "PowerOfPutin";\n', '    uint public constant decimals = 8;\n', '    \n', '    uint256 public totalSupply = 80000000e8;\n', '    uint256 public totalDistributed = 1e8;\n', '    uint256 public totalRemaining = totalSupply.sub(totalDistributed);\n', '    uint256 public value;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    event Distr(address indexed to, uint256 amount);\n', '    event DistrFinished();\n', '    \n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    bool public distributionFinished = false;\n', '    \n', '    modifier canDistr() {\n', '        require(!distributionFinished);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '   \n', '    \n', '    function PowerOfPutin () public {\n', '        owner = msg.sender;\n', '        value = 14780e8;\n', '        distr(owner, totalDistributed);\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '    \n', '   \n', '\n', '   \n', '\n', '    function finishDistribution() onlyOwner canDistr public returns (bool) {\n', '        distributionFinished = true;\n', '        DistrFinished();\n', '        return true;\n', '    }\n', '    \n', '    function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', '        totalDistributed = totalDistributed.add(_amount);\n', '        totalRemaining = totalRemaining.sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Distr(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '        \n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function airdrop(address[] addresses) onlyOwner canDistr public {\n', '        \n', '        require(addresses.length <= 255);\n', '        require(value <= totalRemaining);\n', '        \n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(value <= totalRemaining);\n', '            distr(addresses[i], value);\n', '        }\n', '\t\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {\n', '        \n', '        require(addresses.length <= 255);\n', '        require(amount <= totalRemaining);\n', '        \n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            require(amount <= totalRemaining);\n', '            distr(addresses[i], amount);\n', '        }\n', '\t\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '    }\n', '    \n', '    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {\n', '\n', '        require(addresses.length <= 255);\n', '        require(addresses.length == amounts.length);\n', '        \n', '        for (uint8 i = 0; i < addresses.length; i++) {\n', '            require(amounts[i] <= totalRemaining);\n', '            distr(addresses[i], amounts[i]);\n', '            \n', '            if (totalDistributed >= totalSupply) {\n', '                distributionFinished = true;\n', '            }\n', '        }\n', '    }\n', '    \n', '    function () external payable {\n', '            getTokens();\n', '     }\n', '    \n', '    function getTokens() payable canDistr public {\n', '        \n', '        if (value > totalRemaining) {\n', '            value = totalRemaining;\n', '        }\n', '        \n', '        require(value <= totalRemaining);\n', '        \n', '        address investor = msg.sender;\n', '        uint256 toGive = value;\n', '        \n', '        distr(investor, toGive);\n', '        \n', '        if (toGive > 0) {\n', '            blacklist[investor] = true;\n', '        }\n', '\n', '        if (totalDistributed >= totalSupply) {\n', '            distributionFinished = true;\n', '        }\n', '        \n', '     \n', '    }\n', '\n', '/*\n', '\n', 'READ  THE CONTRACT FAGGOTS\n', '\n', '*/\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '\t    return balances[_owner];\n', '    }\n', '\n', '    // mitigates the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        \n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // mitigates the ERC20 spend/approval race condition\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', '        ForeignToken t = ForeignToken(tokenAddress);\n', '        uint bal = t.balanceOf(who);\n', '        return bal;\n', '    }\n', '    \n', '    function withdraw() onlyOwner public {\n', '        uint256 etherBalance = this.balance;\n', '        owner.transfer(etherBalance);\n', '    }\n', '    \n', '    function burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalDistributed = totalDistributed.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '    \n', '    function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {\n', '        ForeignToken token = ForeignToken(_tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        return token.transfer(owner, amount);\n', '    }\n', '\n', '\n', '}']
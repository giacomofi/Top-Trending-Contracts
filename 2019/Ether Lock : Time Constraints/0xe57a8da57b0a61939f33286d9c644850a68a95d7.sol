['pragma solidity ^0.4.18;\n', '\n', 'contract Math {\n', '    function safeMul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return uint(c);\n', '    }\n', '\n', '    function safeSub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c>=a && c>=b);\n', '        return uint(c);\n', '    }\n', '\n', '    function assert(bool assertion) internal {\n', '        if (!assertion)\n', '            revert();\n', '    }\n', '}\n', '\n', 'contract Bartcoin is Math {\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Refund(address indexed to, uint256 value);\n', '    event Reward(address indexed to, uint256 value);\n', '    \n', '    //BARC META - non-changable\n', '    string SYMBOL = "BARC";\n', '    string TOKEN_NAME = "Bartcoin";\n', '    uint DECIMAL_PLACES = 3;\n', '    \n', '    //BARC INFO\n', '    uint256 TOTAL_SUPPLY = 168000000 * 1e3;\n', '    uint256 MINER_REWARD = 64;\n', '    address LASTEST_MINER;\n', '    uint256 TIME_FOR_CROWDSALE;\n', '    uint256 CREATION_TIME = now;\n', '    address NEUTRAL_ADDRESS = 0xf4fa2a94c38f114bdcfa9d941c03cdd7e5e860a1;\n', '    \n', '    //BARC OWNER INFO\n', '    address OWNER;\n', '    string OWNER_NAME = "OCTAVE YOUSEEME FRANCE";\n', '    \n', '    //BARC VARIABLES\n', '    mapping(address => uint) users;\n', '    uint BLOCK_COUNT = 0;\n', '    uint CYCLES = 1; //update reward cycles, reward will be halved after every 1024 blocks\n', '    \n', '    /*\n', '    * modifier\n', '    */\n', '    modifier onlyOwner {\n', '        if (msg.sender != OWNER)\n', '            revert(); \n', '        _;\n', '    }\n', '    \n', '    /*\n', '    * Ownership functions\n', '    */\n', '    constructor(uint256 numberOfDays) public {\n', '        OWNER = msg.sender;\n', '        users[this] = TOTAL_SUPPLY;\n', '        \n', '        TIME_FOR_CROWDSALE = CREATION_TIME + (numberOfDays * 1 days);\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner == 0x0) {\n', '            revert();\n', '        } else {\n', '            OWNER = newOwner;\n', '        }\n', '    }\n', '    \n', '    function getCrowdsaleTime() public constant returns(uint256) {\n', '        return TIME_FOR_CROWDSALE;\n', '    }\n', '    \n', '    function increaseCrowsaleTime(uint256 daysToIncrease) public onlyOwner {\n', '        uint256 crowdSaleTime = daysToIncrease * 1 days;\n', '        TIME_FOR_CROWDSALE = TIME_FOR_CROWDSALE + crowdSaleTime;\n', '    }\n', '\n', '    /**\n', '     * ERC20 Token\n', '     */\n', '    function name() public constant returns(string) {\n', '        return TOKEN_NAME;\n', '    }\n', '    \n', '    function totalSupply() public constant returns (uint256) {\n', '        return TOTAL_SUPPLY;\n', '    }\n', '    \n', '    function decimals() public constant returns(uint) {\n', '        return DECIMAL_PLACES;\n', '    }\n', '    \n', '    function symbol() public constant returns(string) {\n', '        return SYMBOL;\n', '    }\n', '\n', '    //Enable Mining BARC for Ethereum miner\n', '    function rewardToMiner() internal {\n', '        if (MINER_REWARD == 0) {\n', '           return; \n', '        }\n', '        \n', '        BLOCK_COUNT = BLOCK_COUNT + 1;\n', '        uint reward = MINER_REWARD * 1e3;\n', '        if (users[this] > reward) {\n', '            users[this] = safeSub(users[this], reward);\n', '            users[block.coinbase] = safeAdd(users[block.coinbase], reward);\n', '            LASTEST_MINER = block.coinbase;\n', '            emit Reward(block.coinbase, MINER_REWARD);\n', '        }\n', '        \n', '        uint blockToUpdate = CYCLES * 1024;\n', '        if (BLOCK_COUNT == blockToUpdate) {\n', '            MINER_REWARD = MINER_REWARD / 2;\n', '        }\n', '    }\n', '\n', '    function transfer(address to, uint256 tokens) public {\n', '        if (users[msg.sender] < tokens) {\n', '            revert();\n', '        }\n', '\n', '        users[msg.sender] = safeSub(users[msg.sender], tokens);\n', '        users[to] = safeAdd(users[to], tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '\n', '        rewardToMiner();\n', '    }\n', '    \n', '    function give(address to, uint256 tokens) public onlyOwner {\n', '        if (users[NEUTRAL_ADDRESS] < tokens) {\n', '            revert();\n', '        }\n', '        \n', '        //lock all remaining coins\n', '        if (TIME_FOR_CROWDSALE < now){\n', '            revert(); \n', '        }\n', '\n', '        users[NEUTRAL_ADDRESS] = safeSub(users[NEUTRAL_ADDRESS], tokens);\n', '        users[to] = safeAdd(users[to], tokens);\n', '        emit Transfer(NEUTRAL_ADDRESS, to, tokens);\n', '\n', '        rewardToMiner();\n', '    }\n', '    \n', '    function purchase(uint256 tokens) public onlyOwner {\n', '        if (users[this] < tokens) {\n', '            revert();\n', '        }\n', '        \n', '        //lock all remaining coins\n', '        if (TIME_FOR_CROWDSALE < now){\n', '            revert(); \n', '        }\n', '\n', '        users[this] = safeSub(users[this], tokens);\n', '        users[NEUTRAL_ADDRESS] = safeAdd(users[NEUTRAL_ADDRESS], tokens);\n', '        emit Transfer(msg.sender, NEUTRAL_ADDRESS, tokens);\n', '\n', '        rewardToMiner();\n', '    }\n', '    \n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return users[tokenOwner];\n', '    }\n', '    \n', '    /**\n', '     * Normal functions\n', '     */\n', '    function getMiningInfo() public constant returns(address lastetMiner, uint currentBlockCount, uint currentReward) {\n', '        return (LASTEST_MINER, BLOCK_COUNT, MINER_REWARD);\n', '    }\n', '    \n', '    function getOwner() public constant returns (address ownerAddress, uint balance) {\n', '        uint ownerBalance = users[OWNER];\n', '        return (OWNER, ownerBalance);\n', '    }\n', '    \n', '    function() payable public {\n', '        revert();\n', '    }\n', '    \n', '    function increaseTotal(uint amount) public onlyOwner {\n', '        TOTAL_SUPPLY = TOTAL_SUPPLY + amount;\n', '        users[this] = users[this] + amount;\n', '    }\n', '    \n', '    function decreaseTotal(uint amount) public onlyOwner {\n', '        if (users[this] < amount){\n', '            revert();\n', '        } else {\n', '            TOTAL_SUPPLY = TOTAL_SUPPLY - amount;\n', '            users[this] = users[this] - amount;\n', '        }\n', '    }\n', '}\n', '\n', 'contract BartcoinFaucet is Math {\n', '    address BARTCOIN_ADDRESS;\n', '    address OWNER;\n', '    uint256 LASTEST_SUPPLY = 0;\n', '    \n', '    mapping(address => uint256) BALANCES;\n', '    mapping(address => mapping (address => uint256)) ALLOWANCE;\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Withdraw(address indexed _to, uint256 _value);\n', '    event Sync(uint256 indexed _remaining, uint256 _supply);\n', '    \n', '    modifier onlyOwner {\n', '        if (msg.sender != OWNER)\n', '            revert(); \n', '        _;\n', '    }\n', '    \n', '    constructor(address _bartcoinAddress) {\n', '        BARTCOIN_ADDRESS = _bartcoinAddress;\n', '        OWNER = msg.sender;\n', '    }\n', '    \n', '    function synchronizeFaucet() {\n', '        //If faucetSupply changes, do synchronize\n', '        if (LASTEST_SUPPLY < faucetSupply()) {\n', '            uint256 _diff = faucetSupply() - LASTEST_SUPPLY;\n', '            BALANCES[this] = safeAdd(BALANCES[this], _diff);\n', '        }\n', '        \n', '        //Faucet capacity decreases, update LASTEST_SUPPLY only\n', '        LASTEST_SUPPLY = faucetSupply();\n', '        emit Sync(BALANCES[this], LASTEST_SUPPLY);\n', '    }\n', '    \n', '    function give(address _to, uint256 _value) onlyOwner returns (bool success) {\n', '        if (_to == 0x0) revert();\n', '        if (_value <= 0) revert();\n', '        if (_value > faucetSupply()) revert();\n', '        \n', '        synchronizeFaucet();\n', '        if(_value > BALANCES[this]) revert();\n', '        \n', '        BALANCES[this] = safeSub(BALANCES[this], _value);\n', '        BALANCES[_to] = safeAdd(BALANCES[_to], _value);\n', '        \n', '        emit Transfer(this, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) revert();\n', '\t\tif (_value <= 0) revert();\n', '        if (faucetSupply() < _value) revert();\n', '        if (_value > BALANCES[msg.sender]) revert();\n', '        \n', '        Bartcoin(BARTCOIN_ADDRESS).transfer(_to, _value);\n', '        BALANCES[msg.sender] = safeSub(BALANCES[msg.sender], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Withdraw(_to, _value);\n', '        \n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) revert();\n', '\t\tif (_value <= 0) revert();\n', '        if (faucetSupply() < _value) revert();\n', '        \n', '        if (_value > ALLOWANCE[_from][msg.sender]) revert();\n', '        if (_value > BALANCES[_from]) revert();\n', '        \n', '        if (BALANCES[_to] + _value < BALANCES[_to]) revert();\n', '        \n', '        BALANCES[_from] = safeSub(BALANCES[_from], _value);\n', '        BALANCES[_to] = safeAdd(BALANCES[_to], _value); \n', '        ALLOWANCE[_from][msg.sender] = safeSub(ALLOWANCE[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        if (_value <= 0) revert(); //value less than 0\n', '        if (_value > faucetSupply()) revert(); //value larger than faucetSupply\n', '        if (_value > BALANCES[msg.sender]) revert(); // value larger than owner capacity\n', '        ALLOWANCE[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function changeBartcoinContract(address _bartcoinAddress) {\n', '        BARTCOIN_ADDRESS = _bartcoinAddress;\n', '    }\n', '    \n', '    function faucetSupply() constant returns (uint256 supply) {\n', '        return Bartcoin(BARTCOIN_ADDRESS).balanceOf(this);\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return BALANCES[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return ALLOWANCE[_owner][_spender];\n', '    }\n', '    \n', '    function name() public constant returns(string) {\n', '        return Bartcoin(BARTCOIN_ADDRESS).name();\n', '    }\n', '    \n', '    function decimals() public constant returns(uint) {\n', '        return Bartcoin(BARTCOIN_ADDRESS).decimals();\n', '    }\n', '    \n', '    function symbol() public constant returns(string) {\n', '        return Bartcoin(BARTCOIN_ADDRESS).symbol();\n', '    }\n', '    \n', '    function totalSupply() constant returns (uint256 supply) {\n', '        return Bartcoin(BARTCOIN_ADDRESS).totalSupply();\n', '    }\n', '}']
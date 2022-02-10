['pragma solidity ^0.4.18;\n', '\n', ' contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '  \n', '  function name() public view returns (string _name);\n', '  function symbol() public view returns (string _symbol);\n', '  function decimals() public view returns (uint8 _decimals);\n', '  function totalSupply() public view returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '  function transferFrom(address _from, address _to, uint _value) public returns (bool ok);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwnerCandidate;\n', '\n', '    event OwnershipRequested(address indexed _by, address indexed _to);\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() { require(msg.sender == owner); _;}\n', '\n', '    /// Proposes to transfer control of the contract to a newOwnerCandidate.\n', '    /// @param _newOwnerCandidate address The address to transfer ownership to.\n', '    function transferOwnership(address _newOwnerCandidate) external onlyOwner {\n', '        require(_newOwnerCandidate != address(0));\n', '\n', '        newOwnerCandidate = _newOwnerCandidate;\n', '\n', '        emit OwnershipRequested(msg.sender, newOwnerCandidate);\n', '    }\n', '\n', '    /// Accept ownership transfer. This method needs to be called by the perviously proposed owner.\n', '    function acceptOwnership() external {\n', '        if (msg.sender == newOwnerCandidate) {\n', '            owner = newOwnerCandidate;\n', '            newOwnerCandidate = address(0);\n', '\n', '            emit OwnershipTransferred(owner, newOwnerCandidate);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract Serverable is Ownable {\n', '    address public server;\n', '\n', '    modifier onlyServer() { require(msg.sender == server); _;}\n', '\n', '    function setServerAddress(address _newServerAddress) external onlyOwner {\n', '        server = _newServerAddress;\n', '    }\n', '}\n', '\n', '\n', 'contract BalanceManager is Serverable {\n', '    /** player balances **/\n', '    mapping(uint32 => uint64) public balances;\n', '    /** player blocked tokens number **/\n', '    mapping(uint32 => uint64) public blockedBalances;\n', '    /** wallet balances **/\n', '    mapping(address => uint64) public walletBalances;\n', '    /** adress users **/\n', '    mapping(address => uint32) public userIds;\n', '\n', '    /** Dispatcher contract address **/\n', '    address public dispatcher;\n', '    /** service reward can be withdraw by owners **/\n', '    uint serviceReward;\n', '    /** service reward can be withdraw by owners **/\n', '    uint sentBonuses;\n', '    /** Token used to pay **/\n', '    ERC223 public gameToken;\n', '\n', '    modifier onlyDispatcher() {require(msg.sender == dispatcher);\n', '        _;}\n', '\n', '    event Withdraw(address _user, uint64 _amount);\n', '    event Deposit(address _user, uint64 _amount);\n', '\n', '    constructor(address _gameTokenAddress) public {\n', '        gameToken = ERC223(_gameTokenAddress);\n', '    }\n', '\n', '    function setDispatcherAddress(address _newDispatcherAddress) external onlyOwner {\n', '        dispatcher = _newDispatcherAddress;\n', '    }\n', '\n', '    /**\n', '     * Deposits from user\n', '     */\n', '    function tokenFallback(address _from, uint256 _amount, bytes _data) public {\n', '        if (userIds[_from] > 0) {\n', '            balances[userIds[_from]] += uint64(_amount);\n', '        } else {\n', '            walletBalances[_from] += uint64(_amount);\n', '        }\n', '\n', '        emit Deposit(_from, uint64(_amount));\n', '    }\n', '\n', '    /**\n', '     * Register user\n', '     */\n', '    function registerUserWallet(address _user, uint32 _id) external onlyServer {\n', '        require(userIds[_user] == 0);\n', '        require(_user != owner);\n', '\n', '        userIds[_user] = _id;\n', '        if (walletBalances[_user] > 0) {\n', '            balances[_id] += walletBalances[_user];\n', '            walletBalances[_user] = 0;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Deposits tokens in game to some user\n', '     */\n', '    function sendTo(address _user, uint64 _amount) external {\n', '        require(walletBalances[msg.sender] >= _amount);\n', '        walletBalances[msg.sender] -= _amount;\n', '        if (userIds[_user] > 0) {\n', '            balances[userIds[_user]] += _amount;\n', '        } else {\n', '            walletBalances[_user] += _amount;\n', '        }\n', '        emit Deposit(_user, _amount);\n', '    }\n', '\n', '    /**\n', '     * User can withdraw tokens manually in any time\n', '     */\n', '    function withdraw(uint64 _amount) external {\n', '        uint32 userId = userIds[msg.sender];\n', '        if (userId > 0) {\n', '            require(balances[userId] - blockedBalances[userId] >= _amount);\n', '            if (gameToken.transfer(msg.sender, _amount)) {\n', '                balances[userId] -= _amount;\n', '                emit Withdraw(msg.sender, _amount);\n', '            }\n', '        } else {\n', '            require(walletBalances[msg.sender] >= _amount);\n', '            if (gameToken.transfer(msg.sender, _amount)) {\n', '                walletBalances[msg.sender] -= _amount;\n', '                emit Withdraw(msg.sender, _amount);\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Server can withdraw tokens to user\n', '     */\n', '    function systemWithdraw(address _user, uint64 _amount) external onlyServer {\n', '        uint32 userId = userIds[_user];\n', '        require(balances[userId] - blockedBalances[userId] >= _amount);\n', '\n', '        if (gameToken.transfer(_user, _amount)) {\n', '            balances[userId] -= _amount;\n', '            emit Withdraw(_user, _amount);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Dispatcher can change user balance\n', '     */\n', '    function addUserBalance(uint32 _userId, uint64 _amount) external onlyDispatcher {\n', '        balances[_userId] += _amount;\n', '    }\n', '\n', '    /**\n', '     * Dispatcher can change user balance\n', '     */\n', '    function spendUserBalance(uint32 _userId, uint64 _amount) external onlyDispatcher {\n', '        require(balances[_userId] >= _amount);\n', '        balances[_userId] -= _amount;\n', '        if (blockedBalances[_userId] > 0) {\n', '            if (blockedBalances[_userId] <= _amount)\n', '                blockedBalances[_userId] = 0;\n', '            else\n', '                blockedBalances[_userId] -= _amount;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Server can add bonuses to users, they will take from owner balance\n', '     */\n', '    function addBonus(uint32[] _userIds, uint64[] _amounts) external onlyServer {\n', '        require(_userIds.length == _amounts.length);\n', '\n', '        uint64 sum = 0;\n', '        for (uint32 i = 0; i < _amounts.length; i++)\n', '            sum += _amounts[i];\n', '\n', '        require(walletBalances[owner] >= sum);\n', '        for (i = 0; i < _userIds.length; i++) {\n', '            balances[_userIds[i]] += _amounts[i];\n', '            blockedBalances[_userIds[i]] += _amounts[i];\n', '        }\n', '\n', '        sentBonuses += sum;\n', '        walletBalances[owner] -= sum;\n', '    }\n', '\n', '    /**\n', '     * Dispatcher can change user balance\n', '     */\n', '    function addServiceReward(uint _amount) external onlyDispatcher {\n', '        serviceReward += _amount;\n', '    }\n', '\n', '    /**\n', '     * Owner withdraw service fee tokens \n', '     */\n', '    function serviceFeeWithdraw() external onlyOwner {\n', '        require(serviceReward > 0);\n', '        if (gameToken.transfer(msg.sender, serviceReward))\n', '            serviceReward = 0;\n', '    }\n', '\n', '    function viewSentBonuses() public view returns (uint) {\n', '        require(msg.sender == owner || msg.sender == server);\n', '        return sentBonuses;\n', '    }\n', '\n', '    function viewServiceReward() public view returns (uint) {\n', '        require(msg.sender == owner || msg.sender == server);\n', '        return serviceReward;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', ' contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '  \n', '  function name() public view returns (string _name);\n', '  function symbol() public view returns (string _symbol);\n', '  function decimals() public view returns (uint8 _decimals);\n', '  function totalSupply() public view returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '  function transferFrom(address _from, address _to, uint _value) public returns (bool ok);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwnerCandidate;\n', '\n', '    event OwnershipRequested(address indexed _by, address indexed _to);\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() { require(msg.sender == owner); _;}\n', '\n', '    /// Proposes to transfer control of the contract to a newOwnerCandidate.\n', '    /// @param _newOwnerCandidate address The address to transfer ownership to.\n', '    function transferOwnership(address _newOwnerCandidate) external onlyOwner {\n', '        require(_newOwnerCandidate != address(0));\n', '\n', '        newOwnerCandidate = _newOwnerCandidate;\n', '\n', '        emit OwnershipRequested(msg.sender, newOwnerCandidate);\n', '    }\n', '\n', '    /// Accept ownership transfer. This method needs to be called by the perviously proposed owner.\n', '    function acceptOwnership() external {\n', '        if (msg.sender == newOwnerCandidate) {\n', '            owner = newOwnerCandidate;\n', '            newOwnerCandidate = address(0);\n', '\n', '            emit OwnershipTransferred(owner, newOwnerCandidate);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract Serverable is Ownable {\n', '    address public server;\n', '\n', '    modifier onlyServer() { require(msg.sender == server); _;}\n', '\n', '    function setServerAddress(address _newServerAddress) external onlyOwner {\n', '        server = _newServerAddress;\n', '    }\n', '}\n', '\n', '\n', 'contract BalanceManager is Serverable {\n', '    /** player balances **/\n', '    mapping(uint32 => uint64) public balances;\n', '    /** player blocked tokens number **/\n', '    mapping(uint32 => uint64) public blockedBalances;\n', '    /** wallet balances **/\n', '    mapping(address => uint64) public walletBalances;\n', '    /** adress users **/\n', '    mapping(address => uint32) public userIds;\n', '\n', '    /** Dispatcher contract address **/\n', '    address public dispatcher;\n', '    /** service reward can be withdraw by owners **/\n', '    uint serviceReward;\n', '    /** service reward can be withdraw by owners **/\n', '    uint sentBonuses;\n', '    /** Token used to pay **/\n', '    ERC223 public gameToken;\n', '\n', '    modifier onlyDispatcher() {require(msg.sender == dispatcher);\n', '        _;}\n', '\n', '    event Withdraw(address _user, uint64 _amount);\n', '    event Deposit(address _user, uint64 _amount);\n', '\n', '    constructor(address _gameTokenAddress) public {\n', '        gameToken = ERC223(_gameTokenAddress);\n', '    }\n', '\n', '    function setDispatcherAddress(address _newDispatcherAddress) external onlyOwner {\n', '        dispatcher = _newDispatcherAddress;\n', '    }\n', '\n', '    /**\n', '     * Deposits from user\n', '     */\n', '    function tokenFallback(address _from, uint256 _amount, bytes _data) public {\n', '        if (userIds[_from] > 0) {\n', '            balances[userIds[_from]] += uint64(_amount);\n', '        } else {\n', '            walletBalances[_from] += uint64(_amount);\n', '        }\n', '\n', '        emit Deposit(_from, uint64(_amount));\n', '    }\n', '\n', '    /**\n', '     * Register user\n', '     */\n', '    function registerUserWallet(address _user, uint32 _id) external onlyServer {\n', '        require(userIds[_user] == 0);\n', '        require(_user != owner);\n', '\n', '        userIds[_user] = _id;\n', '        if (walletBalances[_user] > 0) {\n', '            balances[_id] += walletBalances[_user];\n', '            walletBalances[_user] = 0;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Deposits tokens in game to some user\n', '     */\n', '    function sendTo(address _user, uint64 _amount) external {\n', '        require(walletBalances[msg.sender] >= _amount);\n', '        walletBalances[msg.sender] -= _amount;\n', '        if (userIds[_user] > 0) {\n', '            balances[userIds[_user]] += _amount;\n', '        } else {\n', '            walletBalances[_user] += _amount;\n', '        }\n', '        emit Deposit(_user, _amount);\n', '    }\n', '\n', '    /**\n', '     * User can withdraw tokens manually in any time\n', '     */\n', '    function withdraw(uint64 _amount) external {\n', '        uint32 userId = userIds[msg.sender];\n', '        if (userId > 0) {\n', '            require(balances[userId] - blockedBalances[userId] >= _amount);\n', '            if (gameToken.transfer(msg.sender, _amount)) {\n', '                balances[userId] -= _amount;\n', '                emit Withdraw(msg.sender, _amount);\n', '            }\n', '        } else {\n', '            require(walletBalances[msg.sender] >= _amount);\n', '            if (gameToken.transfer(msg.sender, _amount)) {\n', '                walletBalances[msg.sender] -= _amount;\n', '                emit Withdraw(msg.sender, _amount);\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Server can withdraw tokens to user\n', '     */\n', '    function systemWithdraw(address _user, uint64 _amount) external onlyServer {\n', '        uint32 userId = userIds[_user];\n', '        require(balances[userId] - blockedBalances[userId] >= _amount);\n', '\n', '        if (gameToken.transfer(_user, _amount)) {\n', '            balances[userId] -= _amount;\n', '            emit Withdraw(_user, _amount);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Dispatcher can change user balance\n', '     */\n', '    function addUserBalance(uint32 _userId, uint64 _amount) external onlyDispatcher {\n', '        balances[_userId] += _amount;\n', '    }\n', '\n', '    /**\n', '     * Dispatcher can change user balance\n', '     */\n', '    function spendUserBalance(uint32 _userId, uint64 _amount) external onlyDispatcher {\n', '        require(balances[_userId] >= _amount);\n', '        balances[_userId] -= _amount;\n', '        if (blockedBalances[_userId] > 0) {\n', '            if (blockedBalances[_userId] <= _amount)\n', '                blockedBalances[_userId] = 0;\n', '            else\n', '                blockedBalances[_userId] -= _amount;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Server can add bonuses to users, they will take from owner balance\n', '     */\n', '    function addBonus(uint32[] _userIds, uint64[] _amounts) external onlyServer {\n', '        require(_userIds.length == _amounts.length);\n', '\n', '        uint64 sum = 0;\n', '        for (uint32 i = 0; i < _amounts.length; i++)\n', '            sum += _amounts[i];\n', '\n', '        require(walletBalances[owner] >= sum);\n', '        for (i = 0; i < _userIds.length; i++) {\n', '            balances[_userIds[i]] += _amounts[i];\n', '            blockedBalances[_userIds[i]] += _amounts[i];\n', '        }\n', '\n', '        sentBonuses += sum;\n', '        walletBalances[owner] -= sum;\n', '    }\n', '\n', '    /**\n', '     * Dispatcher can change user balance\n', '     */\n', '    function addServiceReward(uint _amount) external onlyDispatcher {\n', '        serviceReward += _amount;\n', '    }\n', '\n', '    /**\n', '     * Owner withdraw service fee tokens \n', '     */\n', '    function serviceFeeWithdraw() external onlyOwner {\n', '        require(serviceReward > 0);\n', '        if (gameToken.transfer(msg.sender, serviceReward))\n', '            serviceReward = 0;\n', '    }\n', '\n', '    function viewSentBonuses() public view returns (uint) {\n', '        require(msg.sender == owner || msg.sender == server);\n', '        return sentBonuses;\n', '    }\n', '\n', '    function viewServiceReward() public view returns (uint) {\n', '        require(msg.sender == owner || msg.sender == server);\n', '        return serviceReward;\n', '    }\n', '}']
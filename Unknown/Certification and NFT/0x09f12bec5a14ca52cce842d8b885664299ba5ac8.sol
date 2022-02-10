['pragma solidity ^0.4.13;\n', '\n', '// ERC20 token interface is implemented only partially\n', '// (no SafeMath is used because contract code is very simple)\n', '// \n', '// Some functions left undefined:\n', '//  - transfer, transferFrom,\n', '//  - approve, allowance.\n', 'contract PresaleToken\n', '{\n', '/// Fields:\n', '    string public constant name = "Remechain Presale Token";\n', '    string public constant symbol = "RMC";\n', '    uint public constant decimals = 18;\n', '    uint public constant PRICE = 320;  // per 1 Ether\n', '\n', '    //  price\n', '    // Cap is 1875 ETH\n', '    // 1 RMC = 0,0031eth\n', '    // ETH price ~290$ - 18.08.2017\n', '    uint public constant TOKEN_SUPPLY_LIMIT = PRICE * 1875 * (1 ether / 1 wei);\n', '\n', '    enum State{\n', '       Init,\n', '       Running,\n', '       Paused,\n', '       Migrating,\n', '       Migrated\n', '    }\n', '\n', '    State public currentState = State.Init;\n', '    uint public totalSupply = 0; // amount of tokens already sold\n', '\n', '    // Gathered funds can be withdrawn only to escrow&#39;s address.\n', '    address public escrow = 0;\n', '\n', '    // Token manager has exclusive priveleges to call administrative\n', '    // functions on this contract.\n', '    address public tokenManager = 0;\n', '\n', '    // Crowdsale manager has exclusive priveleges to burn presale tokens.\n', '    address public crowdsaleManager = 0;\n', '\n', '    mapping (address => uint256) private balance;\n', '\n', 'struct Purchase {\n', '      address buyer;\n', '      uint amount;\n', '    }\n', '   Purchase[] purchases;\n', '/// Modifiers:\n', '    modifier onlyTokenManager()     { require(msg.sender == tokenManager); _;}\n', '    modifier onlyCrowdsaleManager() { require(msg.sender == crowdsaleManager); _;}\n', '    modifier onlyInState(State state){ require(state == currentState); _;}\n', '\n', '/// Events:\n', '    event LogBuy(address indexed owner, uint value);\n', '    event LogBurn(address indexed owner, uint value);\n', '    event LogStateSwitch(State newState);\n', '\n', '/// Functions:\n', '    /// @dev Constructor\n', '    /// @param _tokenManager Token manager address.\n', '    function PresaleToken(address _tokenManager, address _escrow) \n', '    {\n', '        require(_tokenManager!=0);\n', '        require(_escrow!=0);\n', '\n', '        tokenManager = _tokenManager;\n', '        escrow = _escrow;\n', '    }\n', '\n', '    function buyTokens(address _buyer) public payable onlyInState(State.Running)\n', '    {\n', '       \n', '        require(msg.value != 0);\n', '        uint newTokens = msg.value * PRICE;\n', '       \n', '        require(!(totalSupply + newTokens < totalSupply));\n', '    \n', '        require(!(totalSupply + newTokens > TOKEN_SUPPLY_LIMIT));\n', '\n', '        balance[_buyer] += newTokens;\n', '        totalSupply += newTokens;\n', '\n', '        purchases[purchases.length++] = Purchase({buyer: _buyer, amount: newTokens});\n', '\n', '        LogBuy(_buyer, newTokens);\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function burnTokens(address _owner) public onlyCrowdsaleManager onlyInState(State.Migrating)\n', '    {\n', '        uint tokens = balance[_owner];\n', '        require(tokens != 0);\n', '\n', '        balance[_owner] = 0;\n', '        totalSupply -= tokens;\n', '\n', '        LogBurn(_owner, tokens);\n', '\n', '        // Automatically switch phase when migration is done.\n', '        if(totalSupply == 0) \n', '        {\n', '            currentState = State.Migrated;\n', '            LogStateSwitch(State.Migrated);\n', '        }\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) constant returns (uint256) \n', '    {\n', '        return balance[_owner];\n', '    }\n', '\n', '    function setPresaleState(State _nextState) public onlyTokenManager\n', '    {\n', '        // Init -> Running\n', '        // Running -> Paused\n', '        // Running -> Migrating\n', '        // Paused -> Running\n', '        // Paused -> Migrating\n', '        // Migrating -> Migrated\n', '        bool canSwitchState\n', '             =  (currentState == State.Init && _nextState == State.Running)\n', '             || (currentState == State.Running && _nextState == State.Paused)\n', '             // switch to migration phase only if crowdsale manager is set\n', '             || ((currentState == State.Running || currentState == State.Paused)\n', '                 && _nextState == State.Migrating\n', '                 && crowdsaleManager != 0x0)\n', '             || (currentState == State.Paused && _nextState == State.Running)\n', '             // switch to migrated only if everyting is migrated\n', '             || (currentState == State.Migrating && _nextState == State.Migrated\n', '                 && totalSupply == 0);\n', '\n', '        require(canSwitchState);\n', '\n', '        currentState = _nextState;\n', '        LogStateSwitch(_nextState);\n', '    }\n', '\n', '    function withdrawEther() public onlyTokenManager\n', '    {\n', '        if(this.balance > 0) \n', '        {\n', '            require(escrow.send(this.balance));\n', '        }\n', '    }\n', '\n', '/// Setters/getters\n', '    function setTokenManager(address _mgr) public onlyTokenManager\n', '    {\n', '        tokenManager = _mgr;\n', '    }\n', '\n', '    function setCrowdsaleManager(address _mgr) public onlyTokenManager\n', '    {\n', '        // You can&#39;t change crowdsale contract when migration is in progress.\n', '        require(currentState != State.Migrating);\n', '\n', '        crowdsaleManager = _mgr;\n', '    }\n', '\n', '    function getTokenManager()constant returns(address)\n', '    {\n', '        return tokenManager;\n', '    }\n', '\n', '    function getCrowdsaleManager()constant returns(address)\n', '    {\n', '        return crowdsaleManager;\n', '    }\n', '\n', '    function getCurrentState()constant returns(State)\n', '    {\n', '        return currentState;\n', '    }\n', '\n', '    function getPrice()constant returns(uint)\n', '    {\n', '        return PRICE;\n', '    }\n', '\n', '    function getTotalSupply()constant returns(uint)\n', '    {\n', '        return totalSupply;\n', '    }\n', '    function getNumberOfPurchases()constant returns(uint) {\n', '        return purchases.length;\n', '    }\n', '    \n', '    function getPurchaseAddress(uint index)constant returns(address) {\n', '        return purchases[index].buyer;\n', '    }\n', '    \n', '    function getPurchaseAmount(uint index)constant returns(uint) {\n', '        return purchases[index].amount;\n', '    }\n', '    // Default fallback function\n', '    function() payable \n', '    {\n', '        buyTokens(msg.sender);\n', '    }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', '// ERC20 token interface is implemented only partially\n', '// (no SafeMath is used because contract code is very simple)\n', '// \n', '// Some functions left undefined:\n', '//  - transfer, transferFrom,\n', '//  - approve, allowance.\n', 'contract PresaleToken\n', '{\n', '/// Fields:\n', '    string public constant name = "Remechain Presale Token";\n', '    string public constant symbol = "RMC";\n', '    uint public constant decimals = 18;\n', '    uint public constant PRICE = 320;  // per 1 Ether\n', '\n', '    //  price\n', '    // Cap is 1875 ETH\n', '    // 1 RMC = 0,0031eth\n', '    // ETH price ~290$ - 18.08.2017\n', '    uint public constant TOKEN_SUPPLY_LIMIT = PRICE * 1875 * (1 ether / 1 wei);\n', '\n', '    enum State{\n', '       Init,\n', '       Running,\n', '       Paused,\n', '       Migrating,\n', '       Migrated\n', '    }\n', '\n', '    State public currentState = State.Init;\n', '    uint public totalSupply = 0; // amount of tokens already sold\n', '\n', "    // Gathered funds can be withdrawn only to escrow's address.\n", '    address public escrow = 0;\n', '\n', '    // Token manager has exclusive priveleges to call administrative\n', '    // functions on this contract.\n', '    address public tokenManager = 0;\n', '\n', '    // Crowdsale manager has exclusive priveleges to burn presale tokens.\n', '    address public crowdsaleManager = 0;\n', '\n', '    mapping (address => uint256) private balance;\n', '\n', 'struct Purchase {\n', '      address buyer;\n', '      uint amount;\n', '    }\n', '   Purchase[] purchases;\n', '/// Modifiers:\n', '    modifier onlyTokenManager()     { require(msg.sender == tokenManager); _;}\n', '    modifier onlyCrowdsaleManager() { require(msg.sender == crowdsaleManager); _;}\n', '    modifier onlyInState(State state){ require(state == currentState); _;}\n', '\n', '/// Events:\n', '    event LogBuy(address indexed owner, uint value);\n', '    event LogBurn(address indexed owner, uint value);\n', '    event LogStateSwitch(State newState);\n', '\n', '/// Functions:\n', '    /// @dev Constructor\n', '    /// @param _tokenManager Token manager address.\n', '    function PresaleToken(address _tokenManager, address _escrow) \n', '    {\n', '        require(_tokenManager!=0);\n', '        require(_escrow!=0);\n', '\n', '        tokenManager = _tokenManager;\n', '        escrow = _escrow;\n', '    }\n', '\n', '    function buyTokens(address _buyer) public payable onlyInState(State.Running)\n', '    {\n', '       \n', '        require(msg.value != 0);\n', '        uint newTokens = msg.value * PRICE;\n', '       \n', '        require(!(totalSupply + newTokens < totalSupply));\n', '    \n', '        require(!(totalSupply + newTokens > TOKEN_SUPPLY_LIMIT));\n', '\n', '        balance[_buyer] += newTokens;\n', '        totalSupply += newTokens;\n', '\n', '        purchases[purchases.length++] = Purchase({buyer: _buyer, amount: newTokens});\n', '\n', '        LogBuy(_buyer, newTokens);\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function burnTokens(address _owner) public onlyCrowdsaleManager onlyInState(State.Migrating)\n', '    {\n', '        uint tokens = balance[_owner];\n', '        require(tokens != 0);\n', '\n', '        balance[_owner] = 0;\n', '        totalSupply -= tokens;\n', '\n', '        LogBurn(_owner, tokens);\n', '\n', '        // Automatically switch phase when migration is done.\n', '        if(totalSupply == 0) \n', '        {\n', '            currentState = State.Migrated;\n', '            LogStateSwitch(State.Migrated);\n', '        }\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) constant returns (uint256) \n', '    {\n', '        return balance[_owner];\n', '    }\n', '\n', '    function setPresaleState(State _nextState) public onlyTokenManager\n', '    {\n', '        // Init -> Running\n', '        // Running -> Paused\n', '        // Running -> Migrating\n', '        // Paused -> Running\n', '        // Paused -> Migrating\n', '        // Migrating -> Migrated\n', '        bool canSwitchState\n', '             =  (currentState == State.Init && _nextState == State.Running)\n', '             || (currentState == State.Running && _nextState == State.Paused)\n', '             // switch to migration phase only if crowdsale manager is set\n', '             || ((currentState == State.Running || currentState == State.Paused)\n', '                 && _nextState == State.Migrating\n', '                 && crowdsaleManager != 0x0)\n', '             || (currentState == State.Paused && _nextState == State.Running)\n', '             // switch to migrated only if everyting is migrated\n', '             || (currentState == State.Migrating && _nextState == State.Migrated\n', '                 && totalSupply == 0);\n', '\n', '        require(canSwitchState);\n', '\n', '        currentState = _nextState;\n', '        LogStateSwitch(_nextState);\n', '    }\n', '\n', '    function withdrawEther() public onlyTokenManager\n', '    {\n', '        if(this.balance > 0) \n', '        {\n', '            require(escrow.send(this.balance));\n', '        }\n', '    }\n', '\n', '/// Setters/getters\n', '    function setTokenManager(address _mgr) public onlyTokenManager\n', '    {\n', '        tokenManager = _mgr;\n', '    }\n', '\n', '    function setCrowdsaleManager(address _mgr) public onlyTokenManager\n', '    {\n', "        // You can't change crowdsale contract when migration is in progress.\n", '        require(currentState != State.Migrating);\n', '\n', '        crowdsaleManager = _mgr;\n', '    }\n', '\n', '    function getTokenManager()constant returns(address)\n', '    {\n', '        return tokenManager;\n', '    }\n', '\n', '    function getCrowdsaleManager()constant returns(address)\n', '    {\n', '        return crowdsaleManager;\n', '    }\n', '\n', '    function getCurrentState()constant returns(State)\n', '    {\n', '        return currentState;\n', '    }\n', '\n', '    function getPrice()constant returns(uint)\n', '    {\n', '        return PRICE;\n', '    }\n', '\n', '    function getTotalSupply()constant returns(uint)\n', '    {\n', '        return totalSupply;\n', '    }\n', '    function getNumberOfPurchases()constant returns(uint) {\n', '        return purchases.length;\n', '    }\n', '    \n', '    function getPurchaseAddress(uint index)constant returns(address) {\n', '        return purchases[index].buyer;\n', '    }\n', '    \n', '    function getPurchaseAmount(uint index)constant returns(uint) {\n', '        return purchases[index].amount;\n', '    }\n', '    // Default fallback function\n', '    function() payable \n', '    {\n', '        buyTokens(msg.sender);\n', '    }\n', '}']

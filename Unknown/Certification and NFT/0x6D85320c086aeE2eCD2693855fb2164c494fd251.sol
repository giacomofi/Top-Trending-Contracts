['pragma solidity ^0.4.11;\n', '\n', 'contract ATP {\n', '    \n', '    string public constant name = "ATL Presale Token";\n', '    string public constant symbol = "ATP";\n', '    uint   public constant decimals = 18;\n', '    \n', '    uint public constant PRICE = 505;\n', '    uint public constant TOKEN_SUPPLY_LIMIT = 2812500 * (1 ether / 1 wei);\n', '    \n', '    enum Phase {\n', '        Created,\n', '        Running,\n', '        Paused,\n', '        Migrating,\n', '        Migrated\n', '    }\n', '    \n', '    Phase public currentPhase = Phase.Created;\n', '    \n', '    address public tokenManager;\n', '    address public escrow;\n', '    address public crowdsaleManager;\n', '    \n', '    uint public totalSupply = 0;\n', '    mapping (address => uint256) private balances;\n', '    \n', '    event Buy(address indexed buyer, uint amount);\n', '    event Burn(address indexed owner, uint amount);\n', '    event PhaseSwitch(Phase newPhase);\n', '    \n', '    function ATP(address _tokenManager, address _escrow) {\n', '        tokenManager = _tokenManager;\n', '        escrow = _escrow;\n', '    }\n', '    \n', '    function() payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '    \n', '    function buyTokens(address _buyer) public payable {\n', '        require(currentPhase == Phase.Running);\n', '        require(msg.value != 0);\n', '        \n', '        uint tokenAmount = msg.value * PRICE;\n', '        require(totalSupply + tokenAmount <= TOKEN_SUPPLY_LIMIT);\n', '        \n', '        balances[_buyer] += tokenAmount;\n', '        totalSupply += tokenAmount;\n', '        Buy(_buyer, tokenAmount);\n', '    }\n', '    \n', '    function balanceOf(address _owner) constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    modifier onlyTokenManager() {\n', '        require(msg.sender == tokenManager);\n', '        _;\n', '    }\n', '    \n', '    function setPresalePhase(Phase _nextPhase) public onlyTokenManager {\n', '        bool canSwitchPhase\n', '            =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)\n', '            || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)\n', '            || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)\n', '                && _nextPhase == Phase.Migrating\n', '                && crowdsaleManager != 0x0)\n', '            || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)\n', '            || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated\n', '                && totalSupply == 0);\n', '        \n', '        require(canSwitchPhase);\n', '        currentPhase = _nextPhase;\n', '        PhaseSwitch(_nextPhase);\n', '    }\n', '    \n', '    function setCrowdsaleManager(address _mgr) public onlyTokenManager {\n', '        require(currentPhase != Phase.Migrating);\n', '        crowdsaleManager = _mgr;\n', '    }\n', '    \n', '    function withdrawEther() public onlyTokenManager {\n', '        if(this.balance > 0) {\n', '            escrow.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    modifier onlyCrowdsaleManager() { \n', '        require(msg.sender == crowdsaleManager); \n', '        _;\n', '    }\n', '    \n', '    function burnTokens(address _owner) public onlyCrowdsaleManager {\n', '        require(currentPhase == Phase.Migrating);\n', '        \n', '        uint tokens = balances[_owner];\n', '        require(tokens > 0);\n', '        \n', '        balances[_owner] = 0;\n', '        totalSupply -= tokens;\n', '        Burn(_owner, tokens);\n', '        \n', '        if(totalSupply == 0) {\n', '            currentPhase = Phase.Migrated;\n', '            PhaseSwitch(Phase.Migrated);\n', '        }\n', '    }\n', '    \n', '}']
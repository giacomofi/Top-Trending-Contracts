['pragma solidity ^0.4.15;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '  function mul(uint256 a, uint256 b) constant internal returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) constant internal returns (uint256) {\n', '    assert(b != 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) constant internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) constant internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '  function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {\n', '      return div(mul(number, numerator), denominator);\n', '  }\n', '}\n', '\n', '\n', '/// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', '/// @title Abstract token contract - Functions to be implemented by token contracts.\n', '\n', 'contract AbstractToken {\n', '    // This is not an abstract function, because solc won&#39;t recognize generated getter functions for public variables as functions\n', '    function totalSupply() constant returns (uint256) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Issuance(address indexed to, uint256 value);\n', '}\n', '\n', 'contract StandardToken is AbstractToken {\n', '    /*\n', '     *  Data structures\n', '     */\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    /*\n', '     *  Read and write storage functions\n', '     */\n', '    /// @dev Transfers sender&#39;s tokens to a given address. Returns success.\n', '    /// @param _to Address of token receiver.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.\n', '    /// @param _from Address from where tokens are withdrawn.\n', '    /// @param _to Address to where tokens are sent.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success.\n', '    /// @param _spender Address of allowed account.\n', '    /// @param _value Number of approved tokens.\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Read storage functions\n', '     */\n', '    /// @dev Returns number of allowed tokens for given address.\n', '    /// @param _owner Address of token owner.\n', '    /// @param _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract ImmlaToken is StandardToken, SafeMath {\n', '    /*\n', '     * Token meta data\n', '     */\n', '    string public constant name = "IMMLA";\n', '    string public constant symbol = "IML";\n', '    uint public constant decimals = 18;\n', '    uint public constant supplyLimit = 550688955000000000000000000;\n', '    \n', '    address public icoContract = 0x0;\n', '    /*\n', '     * Modifiers\n', '     */\n', '    \n', '    modifier onlyIcoContract() {\n', '        // only ICO contract is allowed to proceed\n', '        require(msg.sender == icoContract);\n', '        _;\n', '    }\n', '    \n', '    /*\n', '     * Contract functions\n', '     */\n', '    \n', '    /// @dev Contract is needed in icoContract address\n', '    /// @param _icoContract Address of account which will be mint tokens\n', '    function ImmlaToken(address _icoContract) {\n', '        assert(_icoContract != 0x0);\n', '        icoContract = _icoContract;\n', '    }\n', '    \n', '    /// @dev Burns tokens from address. It&#39;s can be applied by account with address this.icoContract\n', '    /// @param _from Address of account, from which will be burned tokens\n', '    /// @param _value Amount of tokens, that will be burned\n', '    function burnTokens(address _from, uint _value) onlyIcoContract {\n', '        assert(_from != 0x0);\n', '        require(_value > 0);\n', '        \n', '        balances[_from] = sub(balances[_from], _value);\n', '    }\n', '    \n', '    /// @dev Adds tokens to address. It&#39;s can be applied by account with address this.icoContract\n', '    /// @param _to Address of account to which the tokens will pass\n', '    /// @param _value Amount of tokens\n', '    function emitTokens(address _to, uint _value) onlyIcoContract {\n', '        assert(_to != 0x0);\n', '        require(_value > 0);\n', '        \n', '        balances[_to] = add(balances[_to], _value);\n', '    }\n', '}\n', '\n', '\n', 'contract ImmlaIco is SafeMath {\n', '    /*\n', '     * ICO meta data\n', '     */\n', '    ImmlaToken public immlaToken;\n', '    AbstractToken public preIcoToken;\n', '\n', '    // Address of account to which ethers will be tranfered in case of successful ICO\n', '    address public escrow;\n', '    // Address of manager\n', '    address public icoManager;\n', '    // Address of a account, that will transfer tokens from pre-ICO\n', '    address public tokenImporter = 0x0;\n', '    // Addresses of founders, team and bountyOwner\n', '    address public founder1;\n', '    address public founder2;\n', '    address public founder3;\n', '    address public team;\n', '    address public bountyOwner;\n', '    \n', '    // 38548226,7 IML is reward for team\n', '    uint public constant teamsReward = 38548226701232220000000000;\n', '    //  9361712,2 IML is token for bountyOwner\n', '    uint public constant bountyOwnersTokens = 9361712198870680000000000;\n', '    \n', '    // BASE = 10^18\n', '    uint constant BASE = 1000000000000000000;\n', '    \n', '    // 2017.09.14 21:00 UTC or 2017.09.15 0:00 MSK\n', '    uint public constant defaultIcoStart = 1505422800;\n', '    // ICO start time\n', '    uint public icoStart = defaultIcoStart;\n', '    \n', '    // 2017.10.15 21:00 UTC or 2017.10.16 0:00 MSK\n', '    uint public constant defaultIcoDeadline = 1508101200;\n', '    // ICO end time\n', '    uint public  icoDeadline = defaultIcoDeadline;\n', '    \n', '    // 2018.03.14 21:00 UTC or 2018.03.15 0:00 MSK\n', '    uint public constant defaultFoundersRewardTime = 1521061200;\n', '    // founders&#39; reward time\n', '    uint public foundersRewardTime = defaultFoundersRewardTime;\n', '    \n', '    // Min limit of tokens is 18 000 000 IML\n', '    uint public constant minIcoTokenLimit = 18000000 * BASE;\n', '    // Max limit of tokens is 434 477 177 IML\n', '    uint public constant maxIcoTokenLimit = 434477177 * BASE;\n', '    \n', '    // Amount of imported tokens from pre-ICO\n', '    uint public importedTokens = 0;\n', '    // Amount of sold tokens on ICO\n', '    uint public soldTokensOnIco = 0;\n', '    // Amount of issued tokens on pre-ICO = 13232941,7 IML\n', '    uint public constant soldTokensOnPreIco = 13232941687168431951684000;\n', '    \n', '    // There are 170053520 tokens in stage 1\n', '    // 1 ETH = 3640 IML\n', '    uint tokenPrice1 = 3640;\n', '    uint tokenSupply1 = 170053520 * BASE;\n', '    \n', '    // There are 103725856 tokens in stage 2\n', '    // 1 ETH = 3549 IML\n', '    uint tokenPrice2 = 3549;\n', '    uint tokenSupply2 = 103725856 * BASE;\n', '    \n', '    // There are 100319718 tokens in stage 3\n', '    // 1 ETH = 3458 IML\n', '    uint tokenPrice3 = 3458;\n', '    uint tokenSupply3 = 100319718 * BASE;\n', '    \n', '    // There are 60378083 tokens in stage 4\n', '    // 1 ETH = 3367 IML\n', '    uint tokenPrice4 = 3367;\n', '    uint tokenSupply4 = 60378083 * BASE;\n', '    \n', '    // Token&#39;s prices in stages in array\n', '    uint[] public tokenPrices;\n', '    // Token&#39;s remaining amounts in stages in array\n', '    uint[] public tokenSupplies;\n', '    \n', '    // Check if manager can be setted\n', '    bool public initialized = false;\n', '    // If flag migrated=false, token can be burned\n', '    bool public migrated = false;\n', '    // Tokens to founders can be sent only if sentTokensToFounders == false and time > foundersRewardTime\n', '    bool public sentTokensToFounders = false;\n', '    // If stopICO is called, then ICO \n', '    bool public icoStoppedManually = false;\n', '    \n', '    // mapping of ether balances info\n', '    mapping (address => uint) public balances;\n', '    \n', '    /*\n', '     * Events\n', '     */\n', '    \n', '    event BuyTokens(address buyer, uint value, uint amount);\n', '    event WithdrawEther();\n', '    event StopIcoManually();\n', '    event SendTokensToFounders(uint founder1Reward, uint founder2Reward, uint founder3Reward);\n', '    event ReturnFundsFor(address account);\n', '    \n', '    /*\n', '     * Modifiers\n', '     */\n', '    \n', '    modifier whenInitialized() {\n', '        // only when contract is initialized\n', '        require(initialized);\n', '        _;\n', '    } \n', '    \n', '    modifier onlyManager() {\n', '        // only ICO manager can do this action\n', '        require(msg.sender == icoManager);\n', '        _;\n', '    }\n', '    \n', '    modifier onIcoRunning() {\n', '        // Checks, if ICO is running and has not been stopped\n', '        require(!icoStoppedManually && now >= icoStart && now <= icoDeadline);\n', '        _;\n', '    }\n', '    \n', '    modifier onGoalAchievedOrDeadline() {\n', '        // Checks if amount of sold tokens >= min limit or deadline is reached\n', '        require(soldTokensOnIco >= minIcoTokenLimit || now > icoDeadline || icoStoppedManually);\n', '        _;\n', '    }\n', '    \n', '    modifier onIcoStopped() {\n', '        // Checks if ICO was stopped or deadline is reached\n', '        require(icoStoppedManually || now > icoDeadline);\n', '        _;\n', '    }\n', '    \n', '    modifier notMigrated() {\n', '        // Checks if base can be migrated\n', '        require(!migrated);\n', '        _;\n', '    }\n', '    \n', '    /// @dev Constructor of ICO. Requires address of icoManager,\n', '    /// address of preIcoToken, time of start ICO (or zero),\n', '    /// time of ICO deadline (or zero), founders&#39; reward time (or zero)\n', '    /// @param _icoManager Address of ICO manager\n', '    /// @param _preIcoToken Address of pre-ICO contract\n', '    /// @param _icoStart Timestamp of ICO start (if equals 0, sets defaultIcoStart)\n', '    /// @param _icoDeadline Timestamp of ICO deadline (if equals 0, sets defaultIcoDeadline)\n', '    /// @param _foundersRewardTime Timestamp of founders rewarding time \n', '    /// (if equals 0, sets defaultFoundersRewardTime)\n', '    function ImmlaIco(address _icoManager, address _preIcoToken, \n', '        uint _icoStart, uint _icoDeadline, uint _foundersRewardTime) {\n', '        assert(_preIcoToken != 0x0);\n', '        assert(_icoManager != 0x0);\n', '        \n', '        immlaToken = new ImmlaToken(this);\n', '        icoManager = _icoManager;\n', '        preIcoToken = AbstractToken(_preIcoToken);\n', '        \n', '        if (_icoStart != 0) {\n', '            icoStart = _icoStart;\n', '        }\n', '        if (_icoDeadline != 0) {\n', '            icoDeadline = _icoDeadline;\n', '        }\n', '        if (_foundersRewardTime != 0) {\n', '            foundersRewardTime = _foundersRewardTime;\n', '        }\n', '        \n', '        // tokenPrices and tokenSupplies arrays initialisation\n', '        tokenPrices.push(tokenPrice1);\n', '        tokenPrices.push(tokenPrice2);\n', '        tokenPrices.push(tokenPrice3);\n', '        tokenPrices.push(tokenPrice4);\n', '        \n', '        tokenSupplies.push(tokenSupply1);\n', '        tokenSupplies.push(tokenSupply2);\n', '        tokenSupplies.push(tokenSupply3);\n', '        tokenSupplies.push(tokenSupply4);\n', '    }\n', '    \n', '    /// @dev Initialises addresses of team, founders, tokens owner, escrow.\n', '    /// Initialises balances of team and tokens owner\n', '    /// @param _founder1 Address of founder 1\n', '    /// @param _founder2 Address of founder 2\n', '    /// @param _founder3 Address of founder 3\n', '    /// @param _team Address of team\n', '    /// @param _bountyOwner Address of bounty owner\n', '    /// @param _escrow Address of escrow\n', '    function init(\n', '        address _founder1, address _founder2, address _founder3, \n', '        address _team, address _bountyOwner, address _escrow) onlyManager {\n', '        assert(!initialized);\n', '        assert(_founder1 != 0x0);\n', '        assert(_founder2 != 0x0);\n', '        assert(_founder3 != 0x0);\n', '        assert(_team != 0x0);\n', '        assert(_bountyOwner != 0x0);\n', '        assert(_escrow != 0x0);\n', '        \n', '        founder1 = _founder1;\n', '        founder2 = _founder2;\n', '        founder3 = _founder3;\n', '        team = _team;\n', '        bountyOwner = _bountyOwner;\n', '        escrow = _escrow;\n', '        \n', '        immlaToken.emitTokens(team, teamsReward);\n', '        immlaToken.emitTokens(bountyOwner, bountyOwnersTokens);\n', '        \n', '        initialized = true;\n', '    }\n', '    \n', '    /// @dev Sets new manager. Only manager can do it\n', '    /// @param _newIcoManager Address of new ICO manager\n', '    function setNewManager(address _newIcoManager) onlyManager {\n', '        assert(_newIcoManager != 0x0);\n', '        \n', '        icoManager = _newIcoManager;\n', '    }\n', '    \n', '    /// @dev Sets new token importer. Only manager can do it\n', '    /// @param _newTokenImporter Address of token importer\n', '    function setNewTokenImporter(address _newTokenImporter) onlyManager {\n', '        tokenImporter = _newTokenImporter;\n', '    } \n', '    \n', '    // saves info if account&#39;s tokens were imported from pre-ICO\n', '    mapping (address => bool) private importedFromPreIco;\n', '    /// @dev Imports account&#39;s tokens from pre-ICO. It can be done only by user, ICO manager or token importer\n', '    /// @param _account Address of account which tokens will be imported\n', '    function importTokens(address _account) {\n', '        // only tokens holder or manager or tokenImporter can do migration\n', '        require(msg.sender == tokenImporter || msg.sender == icoManager || msg.sender == _account);\n', '        require(!importedFromPreIco[_account]);\n', '        \n', '        uint preIcoBalance = preIcoToken.balanceOf(_account);\n', '        if (preIcoBalance > 0) {\n', '            immlaToken.emitTokens(_account, preIcoBalance);\n', '            importedTokens = add(importedTokens, preIcoBalance);\n', '        }\n', '        \n', '        importedFromPreIco[_account] = true;\n', '    }\n', '    \n', '    /// @dev Stops ICO manually. Only manager can do it\n', '    function stopIco() onlyManager /* onGoalAchievedOrDeadline */ {\n', '        icoStoppedManually = true;\n', '        StopIcoManually();\n', '    }\n', '    \n', '    /// @dev If ICO is successful, sends funds to escrow (Only manager can do it). If ICO is failed, sends funds to caller (Anyone can do it)\n', '    function withdrawEther() onGoalAchievedOrDeadline {\n', '        if (soldTokensOnIco >= minIcoTokenLimit) {\n', '            assert(initialized);\n', '            assert(this.balance > 0);\n', '            assert(msg.sender == icoManager);\n', '            \n', '            escrow.transfer(this.balance);\n', '            WithdrawEther();\n', '        } \n', '        else {\n', '            returnFundsFor(msg.sender);\n', '        }\n', '    }\n', '    \n', '    /// @dev Returns funds to funder if ICO is unsuccessful. Dont removes IMMLA balance. Can be called only by manager or contract\n', '    /// @param _account Address of funder\n', '    function returnFundsFor(address _account) onGoalAchievedOrDeadline {\n', '        assert(msg.sender == address(this) || msg.sender == icoManager || msg.sender == _account);\n', '        assert(soldTokensOnIco < minIcoTokenLimit);\n', '        assert(balances[_account] > 0);\n', '        \n', '        _account.transfer(balances[_account]);\n', '        balances[_account] = 0;\n', '        \n', '        ReturnFundsFor(_account);\n', '    }\n', '    \n', '    /// @dev count tokens that can be sold with amount of money. Can be called only by contract\n', '    /// @param _weis Amount of weis\n', '    function countTokens(uint _weis) private returns(uint) { \n', '        uint result = 0;\n', '        uint stage;\n', '        for (stage = 0; stage < 4; stage++) {\n', '            if (_weis == 0) {\n', '                break;\n', '            }\n', '            if (tokenSupplies[stage] == 0) {\n', '                continue;\n', '            }\n', '            uint maxTokenAmount = tokenPrices[stage] * _weis;\n', '            if (maxTokenAmount <= tokenSupplies[stage]) {\n', '                result = add(result, maxTokenAmount);\n', '                break;\n', '            }\n', '            result = add(result, tokenSupplies[stage]);\n', '            _weis = sub(_weis, div(tokenSupplies[stage], tokenPrices[stage]));\n', '        }\n', '        \n', '        if (stage == 4) {\n', '            result = add(result, tokenPrices[3] * _weis);\n', '        }\n', '        \n', '        return result;\n', '    }\n', '    \n', '    /// @dev Invalidates _amount tokens. Can be called only by contract\n', '    /// @param _amount Amount of tokens\n', '    function removeTokens(uint _amount) private {\n', '        for (uint i = 0; i < 4; i++) {\n', '            if (_amount == 0) {\n', '                break;\n', '            }\n', '            if (tokenSupplies[i] > _amount) {\n', '                tokenSupplies[i] = sub(tokenSupplies[i], _amount);\n', '                break;\n', '            }\n', '            _amount = sub(_amount, tokenSupplies[i]);\n', '            tokenSupplies[i] = 0;\n', '        }\n', '    }\n', '    \n', '    /// @dev Buys quantity of tokens for the amount of sent ethers.\n', '    /// @param _buyer Address of account which will receive tokens\n', '    function buyTokens(address _buyer) private {\n', '        assert(_buyer != 0x0);\n', '        require(msg.value > 0);\n', '        require(soldTokensOnIco < maxIcoTokenLimit);\n', '        \n', '        uint boughtTokens = countTokens(msg.value);\n', '        assert(add(soldTokensOnIco, boughtTokens) <= maxIcoTokenLimit);\n', '        \n', '        removeTokens(boughtTokens);\n', '        soldTokensOnIco = add(soldTokensOnIco, boughtTokens);\n', '        immlaToken.emitTokens(_buyer, boughtTokens);\n', '        \n', '        balances[_buyer] = add(balances[_buyer], msg.value);\n', '        \n', '        BuyTokens(_buyer, msg.value, boughtTokens);\n', '    }\n', '    \n', '    /// @dev Fall back function ~50k-100k gas\n', '    function () payable onIcoRunning {\n', '        buyTokens(msg.sender);\n', '    }\n', '    \n', '    /// @dev Burn tokens from accounts only in state "not migrated". Only manager can do it\n', '    /// @param _from Address of account \n', '    function burnTokens(address _from, uint _value) onlyManager notMigrated {\n', '        immlaToken.burnTokens(_from, _value);\n', '    }\n', '    \n', '    /// @dev Set state "migrated". Only manager can do it \n', '    function setStateMigrated() onlyManager {\n', '        migrated = true;\n', '    }\n', '    \n', '    /// @dev Send tokens to founders. Can be sent only after immlaToken.rewardTime() (2018.03.15 0:00 UTC)\n', '    /// Sends 43% * 10% of all tokens to founder 1\n', '    /// Sends 43% * 10% of all tokens to founder 2\n', '    /// Sends 14% * 10% of all tokens to founder 3\n', '    function sendTokensToFounders() onlyManager whenInitialized {\n', '        require(!sentTokensToFounders && now >= foundersRewardTime);\n', '        \n', '        // soldTokensOnPreIco + soldTokensOnIco is ~81.3% of tokens \n', '        uint totalCountOfTokens = mulByFraction(add(soldTokensOnIco, soldTokensOnPreIco), 1000, 813);\n', '        uint totalRewardToFounders = mulByFraction(totalCountOfTokens, 1, 10);\n', '        \n', '        uint founder1Reward = mulByFraction(totalRewardToFounders, 43, 100);\n', '        uint founder2Reward = mulByFraction(totalRewardToFounders, 43, 100);\n', '        uint founder3Reward = mulByFraction(totalRewardToFounders, 14, 100);\n', '        immlaToken.emitTokens(founder1, founder1Reward);\n', '        immlaToken.emitTokens(founder2, founder2Reward);\n', '        immlaToken.emitTokens(founder3, founder3Reward);\n', '        SendTokensToFounders(founder1Reward, founder2Reward, founder3Reward);\n', '        sentTokensToFounders = true;\n', '    }\n', '}']
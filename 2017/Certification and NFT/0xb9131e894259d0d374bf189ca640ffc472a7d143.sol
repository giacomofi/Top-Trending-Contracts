['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '    function mul(uint a, uint b) constant internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) constant internal returns (uint) {\n', '        assert(b != 0); // Solidity automatically throws when dividing by 0\n', '        uint c = a / b;\n', "        assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) constant internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) constant internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    // Volume bonus calculation\n', '    function volumeBonus(uint etherValue) constant internal returns (uint) {\n', '\n', '        if(etherValue >=  500000000000000000000) return 10; // 500 ETH +10% tokens\n', '        if(etherValue >=  300000000000000000000) return 7;  // 300 ETH +7% tokens\n', '        if(etherValue >=  100000000000000000000) return 5;  // 100 ETH +5% tokens\n', '        if(etherValue >=   50000000000000000000) return 3;  // 50 ETH +3% tokens\n', '        if(etherValue >=   20000000000000000000) return 2;  // 20 ETH +2% tokens\n', '        if(etherValue >=   10000000000000000000) return 1;  // 10 ETH +1% tokens\n', '\n', '        return 0;\n', '    }\n', '\n', '}\n', '\n', '\n', '/// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', '/// @title Abstract token contract - Functions to be implemented by token contracts.\n', '\n', 'contract AbstractToken {\n', "    // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions\n", '    function totalSupply() constant returns (uint) {}\n', '    function balanceOf(address owner) constant returns (uint balance);\n', '    function transfer(address to, uint value) returns (bool success);\n', '    function transferFrom(address from, address to, uint value) returns (bool success);\n', '    function approve(address spender, uint value) returns (bool success);\n', '    function allowance(address owner, address spender) constant returns (uint remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Issuance(address indexed to, uint value);\n', '}\n', '\n', 'contract IcoLimits {\n', '    uint constant privateSaleStart = 1511136000; // 11/20/2017 @ 12:00am (UTC)\n', '    uint constant privateSaleEnd   = 1512086399; // 11/30/2017 @ 11:59pm (UTC)\n', '\n', '    uint constant presaleStart     = 1512086400; // 12/01/2017 @ 12:00am (UTC)\n', '    uint constant presaleEnd       = 1513900799; // 12/21/2017 @ 11:59pm (UTC)\n', '\n', '    uint constant publicSaleStart  = 1516320000; // 01/19/2018 @ 12:00am (UTC)\n', '    uint constant publicSaleEnd    = 1521158399; // 03/15/2018 @ 11:59pm (UTC)\n', '\n', '    modifier afterPublicSale() {\n', '        require(now > publicSaleEnd);\n', '        _;\n', '    }\n', '\n', '    uint constant privateSalePrice = 4000; // SNEK tokens per 1 ETH\n', '    uint constant preSalePrice     = 3000; // SNEK tokens per 1 ETH\n', '    uint constant publicSalePrice  = 2000; // SNEK tokens per 1 ETH\n', '\n', '    uint constant privateSaleSupplyLimit =  600  * privateSalePrice * 1000000000000000000;\n', '    uint constant preSaleSupplyLimit     =  1200 * preSalePrice     * 1000000000000000000;\n', '    uint constant publicSaleSupplyLimit  =  5000 * publicSalePrice  * 1000000000000000000;\n', '}\n', '\n', 'contract StandardToken is AbstractToken, IcoLimits {\n', '    /*\n', '     *  Data structures\n', '     */\n', '    mapping (address => uint) balances;\n', '    mapping (address => bool) ownerAppended;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    uint public totalSupply;\n', '\n', '    address[] public owners;\n', '\n', '    /*\n', '     *  Read and write storage functions\n', '     */\n', "    /// @dev Transfers sender's tokens to a given address. Returns success.\n", '    /// @param _to Address of token receiver.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transfer(address _to, uint _value) afterPublicSale returns (bool success) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            if(!ownerAppended[_to]) {\n', '                ownerAppended[_to] = true;\n', '                owners.push(_to);\n', '            }\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.\n', '    /// @param _from Address from where tokens are withdrawn.\n', '    /// @param _to Address to where tokens are sent.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint _value) afterPublicSale returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            if(!ownerAppended[_to]) {\n', '                ownerAppended[_to] = true;\n', '                owners.push(_to);\n', '            }\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success.\n', '    /// @param _spender Address of allowed account.\n', '    /// @param _value Number of approved tokens.\n', '    function approve(address _spender, uint _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Read storage functions\n', '     */\n', '    /// @dev Returns number of allowed tokens for given address.\n', '    /// @param _owner Address of token owner.\n', '    /// @param _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract ExoTownToken is StandardToken, SafeMath {\n', '\n', '    /*\n', '     * Token meta data\n', '     */\n', '\n', '    string public constant name = "ExoTown token";\n', '    string public constant symbol = "SNEK";\n', '    uint public constant decimals = 18;\n', '\n', '    address public icoContract = 0x0;\n', '\n', '\n', '    /*\n', '     * Modifiers\n', '     */\n', '\n', '    modifier onlyIcoContract() {\n', '        // only ICO contract is allowed to proceed\n', '        require(msg.sender == icoContract);\n', '        _;\n', '    }\n', '\n', '\n', '    /*\n', '     * Contract functions\n', '     */\n', '\n', '    /// @dev Contract is needed in icoContract address\n', '    /// @param _icoContract Address of account which will be mint tokens\n', '    function ExoTownToken(address _icoContract) {\n', '        require(_icoContract != 0x0);\n', '        icoContract = _icoContract;\n', '    }\n', '\n', '    /// @dev Burns tokens from address. It can be applied by account with address this.icoContract\n', '    /// @param _from Address of account, from which will be burned tokens\n', '    /// @param _value Amount of tokens, that will be burned\n', '    function burnTokens(address _from, uint _value) onlyIcoContract {\n', '        require(_value > 0);\n', '\n', '        balances[_from] = sub(balances[_from], _value);\n', '        totalSupply -= _value;\n', '    }\n', '\n', '    /// @dev Adds tokens to address. It can be applied by account with address this.icoContract\n', '    /// @param _to Address of account to which the tokens will pass\n', '    /// @param _value Amount of tokens\n', '    function emitTokens(address _to, uint _value) onlyIcoContract {\n', '        require(totalSupply + _value >= totalSupply);\n', '        balances[_to] = add(balances[_to], _value);\n', '        totalSupply += _value;\n', '\n', '        if(!ownerAppended[_to]) {\n', '            ownerAppended[_to] = true;\n', '            owners.push(_to);\n', '        }\n', '\n', '        Transfer(0x0, _to, _value);\n', '\n', '    }\n', '\n', '    function getOwner(uint index) constant returns (address, uint) {\n', '        return (owners[index], balances[owners[index]]);\n', '    }\n', '\n', '    function getOwnerCount() constant returns (uint) {\n', '        return owners.length;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract ExoTownIco is SafeMath, IcoLimits {\n', '\n', '    /*\n', '     * ICO meta data\n', '     */\n', '    ExoTownToken public exotownToken;\n', '\n', '    enum State {\n', '        Pause,\n', '        Running\n', '    }\n', '\n', '    State public currentState = State.Pause;\n', '\n', '    uint public privateSaleSoldTokens = 0;\n', '    uint public preSaleSoldTokens     = 0;\n', '    uint public publicSaleSoldTokens  = 0;\n', '\n', '    uint public privateSaleEtherRaised = 0;\n', '    uint public preSaleEtherRaised     = 0;\n', '    uint public publicSaleEtherRaised  = 0;\n', '\n', '    // Address of manager\n', '    address public icoManager;\n', '    address public founderWallet;\n', '\n', '    // Address from which tokens could be burned\n', '    address public buyBack;\n', '\n', '    // Purpose\n', '    address public developmentWallet;\n', '    address public marketingWallet;\n', '    address public teamWallet;\n', '\n', '    address public bountyOwner;\n', '\n', "    // Mediator wallet is used for tracking user payments and reducing users' fee\n", '    address public mediatorWallet;\n', '\n', '    bool public sentTokensToBountyOwner = false;\n', '    bool public sentTokensToFounders = false;\n', '\n', '    \n', '\n', '    /*\n', '     * Modifiers\n', '     */\n', '\n', '    modifier whenInitialized() {\n', '        // only when contract is initialized\n', '        require(currentState >= State.Running);\n', '        _;\n', '    }\n', '\n', '    modifier onlyManager() {\n', '        // only ICO manager can do this action\n', '        require(msg.sender == icoManager);\n', '        _;\n', '    }\n', '\n', '    modifier onIco() {\n', '        require( isPrivateSale() || isPreSale() || isPublicSale() );\n', '        _;\n', '    }\n', '\n', '    modifier hasBountyCampaign() {\n', '        require(bountyOwner != 0x0);\n', '        _;\n', '    }\n', '\n', '    function isPrivateSale() constant internal returns (bool) {\n', '        return now >= privateSaleStart && now <= privateSaleEnd;\n', '    }\n', '\n', '    function isPreSale() constant internal returns (bool) {\n', '        return now >= presaleStart && now <= presaleEnd;\n', '    }\n', '\n', '    function isPublicSale() constant internal returns (bool) {\n', '        return now >= publicSaleStart && now <= publicSaleEnd;\n', '    }\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '    function getPrice() constant internal returns (uint) {\n', '        if (isPrivateSale()) return privateSalePrice;\n', '        if (isPreSale()) return preSalePrice;\n', '        if (isPublicSale()) return publicSalePrice;\n', '\n', '        return publicSalePrice;\n', '    }\n', '\n', '    function getStageSupplyLimit() constant returns (uint) {\n', '        if (isPrivateSale()) return privateSaleSupplyLimit;\n', '        if (isPreSale()) return preSaleSupplyLimit;\n', '        if (isPublicSale()) return publicSaleSupplyLimit;\n', '\n', '        return 0;\n', '    }\n', '\n', '    function getStageSoldTokens() constant returns (uint) {\n', '        if (isPrivateSale()) return privateSaleSoldTokens;\n', '        if (isPreSale()) return preSaleSoldTokens;\n', '        if (isPublicSale()) return publicSaleSoldTokens;\n', '\n', '        return 0;\n', '    }\n', '\n', '    function addStageTokensSold(uint _amount) internal {\n', '        if (isPrivateSale()) privateSaleSoldTokens = add(privateSaleSoldTokens, _amount);\n', '        if (isPreSale())     preSaleSoldTokens = add(preSaleSoldTokens, _amount);\n', '        if (isPublicSale())  publicSaleSoldTokens = add(publicSaleSoldTokens, _amount);\n', '    }\n', '\n', '    function addStageEtherRaised(uint _amount) internal {\n', '        if (isPrivateSale()) privateSaleEtherRaised = add(privateSaleEtherRaised, _amount);\n', '        if (isPreSale())     preSaleEtherRaised = add(preSaleEtherRaised, _amount);\n', '        if (isPublicSale())  publicSaleEtherRaised = add(publicSaleEtherRaised, _amount);\n', '    }\n', '\n', '    function getStageEtherRaised() constant returns (uint) {\n', '        if (isPrivateSale()) return privateSaleEtherRaised;\n', '        if (isPreSale())     return preSaleEtherRaised;\n', '        if (isPublicSale())  return publicSaleEtherRaised;\n', '\n', '        return 0;\n', '    }\n', '\n', '    function getTokensSold() constant returns (uint) {\n', '        return\n', '            privateSaleSoldTokens +\n', '            preSaleSoldTokens +\n', '            publicSaleSoldTokens;\n', '    }\n', '\n', '    function getEtherRaised() constant returns (uint) {\n', '        return\n', '            privateSaleEtherRaised +\n', '            preSaleEtherRaised +\n', '            publicSaleEtherRaised;\n', '    }\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '    /// @dev Constructor of ICO. Requires address of icoManager,\n', '    /// @param _icoManager Address of ICO manager\n', '    function ExoTownIco(address _icoManager) {\n', '        require(_icoManager != 0x0);\n', '\n', '        exotownToken = new ExoTownToken(this);\n', '        icoManager = _icoManager;\n', '    }\n', '\n', '    /// Initialises addresses of founder, target wallets\n', '    /// @param _founder Address of Founder\n', '    /// @param _dev Address of Development wallet\n', '    /// @param _pr Address of Marketing wallet\n', '    /// @param _team Address of Team wallet\n', '    /// @param _buyback Address of wallet used for burning tokens\n', '    /// @param _mediator Address of Mediator wallet\n', '\n', '    function init(\n', '        address _founder,\n', '        address _dev,\n', '        address _pr,\n', '        address _team,\n', '        address _buyback,\n', '        address _mediator\n', '    ) onlyManager {\n', '        require(currentState == State.Pause);\n', '        require(_founder != 0x0);\n', '        require(_dev != 0x0);\n', '        require(_pr != 0x0);\n', '        require(_team != 0x0);\n', '        require(_buyback != 0x0);\n', '        require(_mediator != 0x0);\n', '\n', '        founderWallet = _founder;\n', '        developmentWallet = _dev;\n', '        marketingWallet = _pr;\n', '        teamWallet = _team;\n', '        buyBack = _buyback;\n', '        mediatorWallet = _mediator;\n', '\n', '        currentState = State.Running;\n', '\n', '        exotownToken.emitTokens(icoManager, 0);\n', '    }\n', '\n', '    /// @dev Sets new state\n', '    /// @param _newState Value of new state\n', '    function setState(State _newState) public onlyManager {\n', '        currentState = _newState;\n', '    }\n', '\n', '    /// @dev Sets new manager. Only manager can do it\n', '    /// @param _newIcoManager Address of new ICO manager\n', '    function setNewManager(address _newIcoManager) onlyManager {\n', '        require(_newIcoManager != 0x0);\n', '        icoManager = _newIcoManager;\n', '    }\n', '\n', '    /// @dev Sets bounty owner. Only manager can do it\n', '    /// @param _bountyOwner Address of Bounty owner\n', '    function setBountyCampaign(address _bountyOwner) onlyManager {\n', '        require(_bountyOwner != 0x0);\n', '        bountyOwner = _bountyOwner;\n', '    }\n', '\n', '    /// @dev Sets new Mediator wallet. Only manager can do it\n', '    /// @param _mediator Address of Mediator wallet\n', '    function setNewMediator(address _mediator) onlyManager {\n', '        require(_mediator != 0x0);\n', '        mediatorWallet = _mediator;\n', '    }\n', '\n', '\n', '    /// @dev Buy quantity of tokens depending on the amount of sent ethers.\n', '    /// @param _buyer Address of account which will receive tokens\n', '    function buyTokens(address _buyer) private {\n', '        require(_buyer != 0x0);\n', '        require(msg.value > 0);\n', '\n', '        uint tokensToEmit = msg.value * getPrice();\n', '        uint volumeBonusPercent = volumeBonus(msg.value);\n', '\n', '        if (volumeBonusPercent > 0) {\n', '            tokensToEmit = mul(tokensToEmit, 100 + volumeBonusPercent) / 100;\n', '        }\n', '\n', '        uint stageSupplyLimit = getStageSupplyLimit();\n', '        uint stageSoldTokens = getStageSoldTokens();\n', '\n', '        require(add(stageSoldTokens, tokensToEmit) <= stageSupplyLimit);\n', '\n', '        exotownToken.emitTokens(_buyer, tokensToEmit);\n', '\n', '        // Public statistics\n', '        addStageTokensSold(tokensToEmit);\n', '        addStageEtherRaised(msg.value);\n', '\n', '        distributeEtherByStage();\n', '\n', '    }\n', '\n', '    /// @dev Buy tokens to specified wallet\n', '    function giftToken(address _to) public payable onIco {\n', '        buyTokens(_to);\n', '    }\n', '\n', '    /// @dev Fall back function\n', '    function () payable onIco {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function distributeEtherByStage() private {\n', '        uint _balance = this.balance;\n', '        uint _balance_div = _balance / 100;\n', '\n', '        uint _devAmount = _balance_div * 65;\n', '        uint _prAmount = _balance_div * 25;\n', '\n', '        uint total = _devAmount + _prAmount;\n', '        if (total > 0) {\n', '            // Top up Mediator wallet with 1% of Development amount = 0.65% of contribution amount.\n', '            // It will cover tracking transaction fee (if any).\n', '            // See White Paper for more information about payment tracking\n', '\n', '            uint _mediatorAmount = _devAmount / 100;\n', '            mediatorWallet.transfer(_mediatorAmount);\n', '\n', '            developmentWallet.transfer(_devAmount - _mediatorAmount);\n', '            marketingWallet.transfer(_prAmount);\n', '            teamWallet.transfer(_balance - _devAmount - _prAmount);\n', '        }\n', '    }\n', '\n', '\n', '    /// @dev Partial withdraw. Only manager can do it\n', '    function withdrawEther(uint _value) onlyManager {\n', '        require(_value > 0);\n', '        require(_value <= this.balance);\n', '        // send 1234 to get 1.234\n', '        icoManager.transfer(_value * 1000000000000000); // 10^15\n', '    }\n', '\n', '    ///@dev Send tokens to bountyOwner depending on crowdsale results. Can be send only after public sale.\n', '    function sendTokensToBountyOwner() onlyManager whenInitialized hasBountyCampaign afterPublicSale {\n', '        require(!sentTokensToBountyOwner);\n', '\n', '        //Calculate bounty tokens depending on total tokens sold\n', '        uint bountyTokens = getTokensSold() / 40; // 2.5%\n', '\n', '        exotownToken.emitTokens(bountyOwner, bountyTokens);\n', '\n', '        sentTokensToBountyOwner = true;\n', '    }\n', '\n', '    /// @dev Send tokens to founders.\n', '    function sendTokensToFounders() onlyManager whenInitialized afterPublicSale {\n', '        require(!sentTokensToFounders);\n', '\n', '        //Calculate founder reward depending on total tokens sold\n', '        uint founderReward = getTokensSold() / 10; // 10%\n', '\n', '        exotownToken.emitTokens(founderWallet, founderReward);\n', '\n', '        sentTokensToFounders = true;\n', '    }\n', '\n', '    // Anyone could burn tokens by sending it to buyBack address and calling this function.\n', '    function burnTokens(uint _amount) afterPublicSale {\n', '        exotownToken.burnTokens(buyBack, _amount);\n', '    }\n', '}']
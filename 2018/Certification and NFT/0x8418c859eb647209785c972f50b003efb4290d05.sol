['/*************************************************************************\n', ' * This contract has been merged with solidify\n', ' * https://github.com/tiesnetwork/solidify\n', ' *************************************************************************/\n', ' \n', ' pragma solidity ^0.4.18;\n', '\n', '/*************************************************************************\n', ' * import "./BCSCrowdsale.sol" : start\n', ' *************************************************************************/\n', '\n', '/*************************************************************************\n', ' * import "../token/ITokenPool.sol" : start\n', ' *************************************************************************/\n', '\n', '/*************************************************************************\n', ' * import "./ERC20StandardToken.sol" : start\n', ' *************************************************************************/\n', '\n', '/*************************************************************************\n', ' * import "./IERC20Token.sol" : start\n', ' *************************************************************************/\n', '\n', 'contract IERC20Token {\n', '\n', "    // these functions aren't abstract since the compiler emits automatically generated getter functions as external    \n", '    function name() public constant returns (string _name) { _name; }\n', '    function symbol() public constant returns (string _symbol) { _symbol; }\n', '    function decimals() public constant returns (uint8 _decimals) { _decimals; }\n', '    \n', '    function totalSupply() public constant returns (uint total) {total;}\n', '    function balanceOf(address _owner) public constant returns (uint balance) {_owner; balance;}    \n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {_owner; _spender; remaining;}\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    \n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '/*************************************************************************\n', ' * import "./IERC20Token.sol" : end\n', ' *************************************************************************/\n', '/*************************************************************************\n', ' * import "../common/SafeMath.sol" : start\n', ' *************************************************************************/\n', '\n', '/**dev Utility methods for overflow-proof arithmetic operations \n', '*/\n', 'contract SafeMath {\n', '\n', '    /**dev Returns the sum of a and b. Throws an exception if it exceeds uint256 limits*/\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {        \n', '        assert(a+b >= a);\n', '        return a+b;\n', '    }\n', '\n', '    /**dev Returns the difference of a and b. Throws an exception if a is less than b*/\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(a >= b);\n', '        return a - b;\n', '    }\n', '\n', '    /**dev Returns the product of a and b. Throws an exception if it exceeds uint256 limits*/\n', '    function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0) || (z / x == y));\n', '        return z;\n', '    }\n', '\n', '    function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        assert(y != 0);\n', '        return x / y;\n', '    }\n', '}/*************************************************************************\n', ' * import "../common/SafeMath.sol" : end\n', ' *************************************************************************/\n', '\n', '/**@dev Standard ERC20 compliant token implementation */\n', 'contract ERC20StandardToken is IERC20Token, SafeMath {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    //tokens already issued\n', '    uint256 tokensIssued;\n', '    //balances for each account\n', '    mapping (address => uint256) balances;\n', '    //one account approves the transfer of an amount to another account\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function ERC20StandardToken() public {\n', '     \n', '    }    \n', '\n', '    //\n', '    //IERC20Token implementation\n', '    // \n', '\n', '    function totalSupply() public constant returns (uint total) {\n', '        total = tokensIssued;\n', '    }\n', ' \n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        balance = balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        // safeSub inside doTransfer will throw if there is not enough balance.\n', '        doTransfer(msg.sender, _to, _value);        \n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        \n', '        // Check for allowance is not needed because sub(_allowance, _value) will throw if this condition is not met\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);        \n', '        // safeSub inside doTransfer will throw if there is not enough balance.\n', '        doTransfer(_from, _to, _value);        \n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        remaining = allowed[_owner][_spender];\n', '    }    \n', '\n', '    //\n', '    // Additional functions\n', '    //\n', '    /**@dev Gets real token amount in the smallest token units */\n', '    function getRealTokenAmount(uint256 tokens) public constant returns (uint256) {\n', '        return tokens * (uint256(10) ** decimals);\n', '    }\n', '\n', '    //\n', '    // Internal functions\n', '    //    \n', '    \n', '    function doTransfer(address _from, address _to, uint256 _value) internal {\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '    }\n', '}/*************************************************************************\n', ' * import "./ERC20StandardToken.sol" : end\n', ' *************************************************************************/\n', '\n', '/**@dev Token pool that manages its tokens by designating trustees */\n', 'contract ITokenPool {    \n', '\n', '    /**@dev Token to be managed */\n', '    ERC20StandardToken public token;\n', '\n', '    /**@dev Changes trustee state */\n', '    function setTrustee(address trustee, bool state) public;\n', '\n', "    // these functions aren't abstract since the compiler emits automatically generated getter functions as external\n", '    /**@dev Returns remaining token amount */\n', '    function getTokenAmount() public constant returns (uint256 tokens) {tokens;}\n', '}/*************************************************************************\n', ' * import "../token/ITokenPool.sol" : end\n', ' *************************************************************************/\n', '/*************************************************************************\n', ' * import "../token/ReturnTokenAgent.sol" : start\n', ' *************************************************************************/\n', '\n', '/*************************************************************************\n', ' * import "../common/Manageable.sol" : start\n', ' *************************************************************************/\n', '\n', '/*************************************************************************\n', ' * import "../common/Owned.sol" : start\n', ' *************************************************************************/\n', '\n', '/*************************************************************************\n', ' * import "./IOwned.sol" : start\n', ' *************************************************************************/\n', '\n', '/**@dev Simple interface to Owned base class */\n', 'contract IOwned {\n', '    function owner() public constant returns (address) {}\n', '    function transferOwnership(address _newOwner) public;\n', '}/*************************************************************************\n', ' * import "./IOwned.sol" : end\n', ' *************************************************************************/\n', '\n', 'contract Owned is IOwned {\n', '    address public owner;        \n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier ownerOnly {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**@dev allows transferring the contract ownership. */\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '/*************************************************************************\n', ' * import "../common/Owned.sol" : end\n', ' *************************************************************************/\n', '\n', '///A token that have an owner and a list of managers that can perform some operations\n', '///Owner is always a manager too\n', 'contract Manageable is Owned {\n', '\n', '    event ManagerSet(address manager, bool state);\n', '\n', '    mapping (address => bool) public managers;\n', '\n', '    function Manageable() public Owned() {\n', '        managers[owner] = true;\n', '    }\n', '\n', '    /**@dev Allows execution by managers only */\n', '    modifier managerOnly {\n', '        require(managers[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        super.transferOwnership(_newOwner);\n', '\n', '        managers[_newOwner] = true;\n', '        managers[msg.sender] = false;\n', '    }\n', '\n', '    function setManager(address manager, bool state) public ownerOnly {\n', '        managers[manager] = state;\n', '        ManagerSet(manager, state);\n', '    }\n', '}/*************************************************************************\n', ' * import "../common/Manageable.sol" : end\n', ' *************************************************************************/\n', '/*************************************************************************\n', ' * import "../token/ReturnableToken.sol" : start\n', ' *************************************************************************/\n', '\n', '\n', '\n', '\n', '\n', '///Token that when sent to specified contract (returnAgent) invokes additional actions\n', 'contract ReturnableToken is Manageable, ERC20StandardToken {\n', '\n', '    /**@dev List of return agents */\n', '    mapping (address => bool) public returnAgents;\n', '\n', '    function ReturnableToken() public {}    \n', '    \n', '    /**@dev Sets new return agent */\n', '    function setReturnAgent(ReturnTokenAgent agent) public managerOnly {\n', '        returnAgents[address(agent)] = true;\n', '    }\n', '\n', '    /**@dev Removes return agent from list */\n', '    function removeReturnAgent(ReturnTokenAgent agent) public managerOnly {\n', '        returnAgents[address(agent)] = false;\n', '    }\n', '\n', '    function doTransfer(address _from, address _to, uint256 _value) internal {\n', '        super.doTransfer(_from, _to, _value);\n', '        if (returnAgents[_to]) {\n', '            ReturnTokenAgent(_to).returnToken(_from, _value);                \n', '        }\n', '    }\n', '}/*************************************************************************\n', ' * import "../token/ReturnableToken.sol" : end\n', ' *************************************************************************/\n', '\n', '///Returnable tokens receiver\n', 'contract ReturnTokenAgent is Manageable {\n', '    //ReturnableToken public returnableToken;\n', '\n', '    /**@dev List of returnable tokens in format token->flag  */\n', '    mapping (address => bool) public returnableTokens;\n', '\n', '    /**@dev Allows only token to execute method */\n', '    //modifier returnableTokenOnly {require(msg.sender == address(returnableToken)); _;}\n', '    modifier returnableTokenOnly {require(returnableTokens[msg.sender]); _;}\n', '\n', '    /**@dev Executes when tokens are transferred to this */\n', '    function returnToken(address from, uint256 amountReturned)  public;\n', '\n', '    /**@dev Sets token that can call returnToken method */\n', '    function setReturnableToken(ReturnableToken token) public managerOnly {\n', '        returnableTokens[address(token)] = true;\n', '    }\n', '\n', '    /**@dev Removes token that can call returnToken method */\n', '    function removeReturnableToken(ReturnableToken token) public managerOnly {\n', '        returnableTokens[address(token)] = false;\n', '    }\n', '}/*************************************************************************\n', ' * import "../token/ReturnTokenAgent.sol" : end\n', ' *************************************************************************/\n', '\n', '\n', '/*************************************************************************\n', ' * import "./IInvestRestrictions.sol" : start\n', ' *************************************************************************/\n', '\n', '\n', '\n', '/** @dev Restrictions on investment */\n', 'contract IInvestRestrictions is Manageable {\n', '    /**@dev Returns true if investmet is allowed */\n', '    function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {\n', '        investor; amount; result; tokensLeft;\n', '    }\n', '\n', '    /**@dev Called when investment was made */\n', '    function investHappened(address investor, uint amount) managerOnly {}    \n', '}/*************************************************************************\n', ' * import "./IInvestRestrictions.sol" : end\n', ' *************************************************************************/\n', '/*************************************************************************\n', ' * import "./ICrowdsaleFormula.sol" : start\n', ' *************************************************************************/\n', '\n', '/**@dev Abstraction of crowdsale token calculation function */\n', 'contract ICrowdsaleFormula {\n', '\n', '    /**@dev Returns amount of tokens that can be bought with given weiAmount */\n', '    function howManyTokensForEther(uint256 weiAmount) constant returns(uint256 tokens, uint256 excess) {\n', '        weiAmount; tokens; excess;\n', '    }\n', '\n', '    /**@dev Returns how many tokens left for sale */\n', '    function tokensLeft() constant returns(uint256 _left) { _left;}    \n', '}/*************************************************************************\n', ' * import "./ICrowdsaleFormula.sol" : end\n', ' *************************************************************************/\n', '\n', '/*************************************************************************\n', ' * import "../token/TokenHolder.sol" : start\n', ' *************************************************************************/\n', '\n', '\n', '\n', '/*************************************************************************\n', ' * import "./ITokenHolder.sol" : start\n', ' *************************************************************************/\n', '\n', '\n', '\n', '/*\n', '    Token Holder interface\n', '*/\n', 'contract ITokenHolder {\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;\n', '}\n', '/*************************************************************************\n', ' * import "./ITokenHolder.sol" : end\n', ' *************************************************************************/\n', '\n', "/**@dev A convenient way to manage token's of a contract */\n", 'contract TokenHolder is ITokenHolder, Manageable {\n', '    \n', '    function TokenHolder() {\n', '    }\n', '\n', '    /** @dev Withdraws tokens held by the contract and sends them to a given address */\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)\n', '        public\n', '        managerOnly\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '    }\n', '}\n', '/*************************************************************************\n', ' * import "../token/TokenHolder.sol" : end\n', ' *************************************************************************/\n', '\n', '/**@dev Crowdsale base contract, used for PRE-TGE and TGE stages\n', '* Token holder should also be the owner of this contract */\n', 'contract BCSCrowdsale is ReturnTokenAgent, TokenHolder, ICrowdsaleFormula, SafeMath {\n', '\n', '    enum State {Unknown, BeforeStart, Active, FinishedSuccess, FinishedFailure}\n', '    \n', '    ITokenPool public tokenPool;\n', '    IInvestRestrictions public restrictions; //restrictions on investment\n', '    address public beneficiary; //address of contract to collect ether\n', '    uint256 public startTime; //unit timestamp of start time\n', '    uint256 public endTime; //unix timestamp of end date\n', '    uint256 public minimumGoalInWei; //TODO or in tokens\n', '    uint256 public tokensForOneEther; //how many tokens can you buy for 1 ether   \n', '    uint256 realAmountForOneEther; //how many tokens can you buy for 1 ether * 10**decimals   \n', '    uint256 bonusPct;   //additional percent of tokens    \n', '    bool public withdrew; //true if beneficiary already withdrew\n', '\n', '    uint256 public weiCollected;\n', '    uint256 public tokensSold;\n', '    uint256 public totalInvestments;\n', '\n', '    bool public failure; //true if some error occurred during crowdsale\n', '\n', '    mapping (address => uint256) public investedFrom; //how many wei specific address invested\n', '    mapping (address => uint256) public returnedTo; //how many wei returned to specific address if sale fails\n', '    mapping (address => uint256) public tokensSoldTo; //how many tokens sold to specific addreess\n', '    mapping (address => uint256) public overpays;     //overpays for send value excesses\n', '\n', '    // A new investment was made\n', '    event Invested(address investor, uint weiAmount, uint tokenAmount);\n', '    // Refund was processed for a contributor\n', '    event Refund(address investor, uint weiAmount);\n', '    // Overpay refund was processed for a contributor\n', '    event OverpayRefund(address investor, uint weiAmount);\n', '\n', '    /**@dev Crowdsale constructor, can specify startTime as 0 to start crowdsale immediately \n', '    _tokensForOneEther - doesn"t depend on token decimals   */ \n', '    function BCSCrowdsale(        \n', '        ITokenPool _tokenPool,\n', '        IInvestRestrictions _restrictions,\n', '        address _beneficiary, \n', '        uint256 _startTime, \n', '        uint256 _durationInHours, \n', '        uint256 _goalInWei,\n', '        uint256 _tokensForOneEther,\n', '        uint256 _bonusPct) \n', '    {\n', '        require(_beneficiary != 0x0);\n', '        require(address(_tokenPool) != 0x0);\n', '        require(_tokensForOneEther > 0); \n', '        \n', '        tokenPool = _tokenPool;\n', '        beneficiary = _beneficiary;\n', '        restrictions = _restrictions;\n', '        \n', '        if (_startTime == 0) {\n', '            startTime = now;\n', '        } else {\n', '            startTime = _startTime;\n', '        }\n', '\n', '        endTime = (_durationInHours * 1 hours) + startTime;\n', '        \n', '        tokensForOneEther = _tokensForOneEther;\n', '        minimumGoalInWei = _goalInWei;\n', '        bonusPct = _bonusPct;\n', '\n', '        weiCollected = 0;\n', '        tokensSold = 0;\n', '        totalInvestments = 0;\n', '        failure = false;\n', '        withdrew = false;        \n', '        realAmountForOneEther = tokenPool.token().getRealTokenAmount(tokensForOneEther);\n', '    }\n', '\n', '    function() payable {\n', '        invest();\n', '    }\n', '\n', '    function invest() payable {\n', '        require(canInvest(msg.sender, msg.value));\n', '        \n', '        uint256 excess;\n', '        uint256 weiPaid = msg.value;\n', '        uint256 tokensToBuy;\n', '        (tokensToBuy, excess) = howManyTokensForEther(weiPaid);\n', '\n', '        require(tokensToBuy <= tokensLeft() && tokensToBuy > 0);\n', '\n', '        if (excess > 0) {\n', '            overpays[msg.sender] = safeAdd(overpays[msg.sender], excess);\n', '            weiPaid = safeSub(weiPaid, excess);\n', '        }\n', '        \n', '        investedFrom[msg.sender] = safeAdd(investedFrom[msg.sender], weiPaid);      \n', '        tokensSoldTo[msg.sender] = safeAdd(tokensSoldTo[msg.sender], tokensToBuy);\n', '        \n', '        tokensSold = safeAdd(tokensSold, tokensToBuy);\n', '        weiCollected = safeAdd(weiCollected, weiPaid);\n', '\n', '        if(address(restrictions) != 0x0) {\n', '            restrictions.investHappened(msg.sender, msg.value);\n', '        }\n', '        \n', '        require(tokenPool.token().transferFrom(tokenPool, msg.sender, tokensToBuy));\n', '        ++totalInvestments;\n', '        Invested(msg.sender, weiPaid, tokensToBuy);\n', '    }\n', '\n', '    /**@dev ReturnTokenAgent override. Returns ether if crowdsale is failed \n', '        and amount of returned tokens is exactly the same as bought */\n', '    function returnToken(address from, uint256 amountReturned) public returnableTokenOnly {\n', '        if (msg.sender == address(tokenPool.token()) && getState() == State.FinishedFailure) {\n', '            //require(getState() == State.FinishedFailure);\n', '            require(tokensSoldTo[from] == amountReturned);\n', '\n', '            returnedTo[from] = investedFrom[from];\n', '            investedFrom[from] = 0;\n', '            from.transfer(returnedTo[from]);\n', '\n', '            Refund(from, returnedTo[from]);\n', '        }\n', '    }\n', '\n', '    /**@dev Returns true if it is possible to invest */\n', '    function canInvest(address investor, uint256 amount) constant returns(bool) {\n', '        return getState() == State.Active &&\n', '                    (address(restrictions) == 0x0 || \n', '                    restrictions.canInvest(investor, amount, tokensLeft()));\n', '    }\n', '\n', '    /**@dev ICrowdsaleFormula override */\n', '    function howManyTokensForEther(uint256 weiAmount) constant returns(uint256 tokens, uint256 excess) {        \n', '        uint256 bpct = getCurrentBonusPct(weiAmount);\n', '        uint256 maxTokens = (tokensLeft() * 100) / (100 + bpct);\n', '\n', '        tokens = weiAmount * realAmountForOneEther / 1 ether;\n', '        if (tokens > maxTokens) {\n', '            tokens = maxTokens;\n', '        }\n', '\n', '        excess = weiAmount - tokens * 1 ether / realAmountForOneEther;\n', '\n', '        tokens = (tokens * 100 + tokens * bpct) / 100;\n', '    }\n', '\n', '    /**@dev Returns current bonus percent [0-100] */\n', '    function getCurrentBonusPct(uint256 investment) constant returns (uint256) {\n', '        return bonusPct;\n', '    }\n', '    \n', '    /**@dev Returns how many tokens left for sale */\n', '    function tokensLeft() constant returns(uint256) {        \n', '        return tokenPool.getTokenAmount();\n', '    }\n', '\n', '    /**@dev Returns funds that should be sent to beneficiary */\n', '    function amountToBeneficiary() constant returns (uint256) {\n', '        return weiCollected;\n', '    } \n', '\n', '    /**@dev Returns crowdsale current state */\n', '    function getState() constant returns (State) {\n', '        if (failure) {\n', '            return State.FinishedFailure;\n', '        }\n', '        \n', '        if (now < startTime) {\n', '            return State.BeforeStart;\n', '        } else if ((endTime == 0 || now < endTime) && tokensLeft() > 0) {\n', '            return State.Active;\n', '        } else if (weiCollected >= minimumGoalInWei || tokensLeft() <= 0) {\n', '            return State.FinishedSuccess;\n', '        } else {\n', '            return State.FinishedFailure;\n', '        }\n', '    }\n', '\n', '    /**@dev Allows investor to withdraw overpay */\n', '    function withdrawOverpay() {\n', '        uint amount = overpays[msg.sender];\n', '        overpays[msg.sender] = 0;        \n', '\n', '        if (amount > 0) {\n', '            if (msg.sender.send(amount)) {\n', '                OverpayRefund(msg.sender, amount);\n', '            } else {\n', '                overpays[msg.sender] = amount; //restore funds in case of failed send\n', '            }\n', '        }\n', '    }\n', '\n', '    /**@dev Transfers all collected funds to beneficiary*/\n', '    function transferToBeneficiary() {\n', '        require(getState() == State.FinishedSuccess && !withdrew);\n', '        \n', '        withdrew = true;\n', '        uint256 amount = amountToBeneficiary();\n', '\n', '        beneficiary.transfer(amount);\n', '        Refund(beneficiary, amount);\n', '    }\n', '\n', '    /**@dev Makes crowdsale failed/ok, for emergency reasons */\n', '    function makeFailed(bool state) managerOnly {\n', '        failure = state;\n', '    }\n', '\n', '    /**@dev Sets new beneficiary */\n', '    function changeBeneficiary(address newBeneficiary) managerOnly {\n', '        beneficiary = newBeneficiary;\n', '    }\n', '} /*************************************************************************\n', ' * import "./BCSCrowdsale.sol" : end\n', ' *************************************************************************/\n', '\n', '/**@dev Addition to token-accepting crowdsale contract. \n', '    Allows to set bonus decreasing with time. \n', '    For example, if we ant to set bonus taht decreases from +20% to +5% each week -3%,\n', '    and then stays on +%5, then constructor parameters should be:\n', '    _bonusPct = 20\n', '    _maxDecreasePct = 15\n', '    _decreaseStepPct = 3\n', '    _stepDurationDays = 7\n', '\n', '    In addition, it allows to set investment steps with different bonus. \n', '    For example, if there is following scheme:\n', '    Default bonus +20%\n', '    1-5 ETH : +1% bonus, \n', '    5-10 ETH : +2% bonus,\n', '    10-20 ETH : +3% bonus,\n', '    20+ ETH : +5% bonus, \n', '    then constructor parameters should be:\n', '    _bonusPct = 20\n', '    _investSteps = [1,5,10,20]\n', '    _bonusPctSteps = [1,2,3,5]\n', '    */ \n', 'contract BCSAddBonusCrowdsale is BCSCrowdsale {\n', '    \n', '    uint256 public decreaseStepPct;\n', '    uint256 public stepDuration;\n', '    uint256 public maxDecreasePct;\n', '    uint256[] public investSteps;\n', '    uint8[] public bonusPctSteps;\n', '    \n', '    function BCSAddBonusCrowdsale(        \n', '        ITokenPool _tokenPool,\n', '        IInvestRestrictions _restrictions,\n', '        address _beneficiary, \n', '        uint256 _startTime, \n', '        uint256 _durationInHours, \n', '        uint256 _goalInWei,\n', '        uint256 _tokensForOneEther,\n', '        uint256 _bonusPct,\n', '        uint256 _maxDecreasePct,        \n', '        uint256 _decreaseStepPct,\n', '        uint256 _stepDurationDays,\n', '        uint256[] _investSteps,\n', '        uint8[] _bonusPctSteps              \n', '        ) \n', '        BCSCrowdsale(\n', '            _tokenPool,\n', '            _restrictions,\n', '            _beneficiary, \n', '            _startTime, \n', '            _durationInHours, \n', '            _goalInWei,\n', '            _tokensForOneEther,\n', '            _bonusPct\n', '        )\n', '    {\n', '        require (_bonusPct >= maxDecreasePct);\n', '\n', '        investSteps = _investSteps;\n', '        bonusPctSteps = _bonusPctSteps;\n', '        maxDecreasePct = _maxDecreasePct;\n', '        decreaseStepPct = _decreaseStepPct;\n', '        stepDuration = _stepDurationDays * 1 days;\n', '    }\n', '\n', '    function getCurrentBonusPct(uint256 investment) public constant returns (uint256) {\n', '        \n', '        uint256 decreasePct = decreaseStepPct * (now - startTime) / stepDuration;\n', '        if (decreasePct > maxDecreasePct) {\n', '            decreasePct = maxDecreasePct;\n', '        }\n', '\n', '        uint256 first24hAddition = (now - startTime < 1 days ? 1 : 0);\n', '\n', '        for (int256 i = int256(investSteps.length) - 1; i >= 0; --i) {\n', '            if (investment >= investSteps[uint256(i)]) {\n', '                return bonusPct - decreasePct + bonusPctSteps[uint256(i)] + first24hAddition;\n', '            }\n', '        }\n', '                \n', '        return bonusPct - decreasePct + first24hAddition;\n', '    }\n', '\n', '}']
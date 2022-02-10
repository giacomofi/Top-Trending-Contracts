['pragma solidity ^0.4.16;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '        // require (_value <= _allowance);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        }\n', '        else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(0x0, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyOwner returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract usingMyWillConsts {\n', '    uint constant TOKEN_DECIMALS = 18;\n', '    uint8 constant TOKEN_DECIMALS_UINT8 = 18;\n', '    uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;\n', '}\n', 'contract MyWillToken is usingMyWillConsts, MintableToken {\n', '    /**\n', '     * @dev Pause token transfer. After successfully finished crowdsale it becomes true.\n', '     */\n', '    bool public paused = true;\n', '    /**\n', '     * @dev Accounts who can transfer token even if paused. Works only during crowdsale.\n', '     */\n', '    mapping(address => bool) excluded;\n', '\n', '    function name() constant public returns (string _name) {\n', '        return "MyWill Coin";\n', '    }\n', '\n', '    function symbol() constant public returns (bytes32 _symbol) {\n', '        return "WIL";\n', '    }\n', '\n', '    function decimals() constant public returns (uint8 _decimals) {\n', '        return TOKEN_DECIMALS_UINT8;\n', '    }\n', '\n', '    function crowdsaleFinished() onlyOwner {\n', '        paused = false;\n', '    }\n', '\n', '    function addExcluded(address _toExclude) onlyOwner {\n', '        excluded[_toExclude] = true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '        require(!paused || excluded[_from]);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool) {\n', '        require(!paused || excluded[msg.sender]);\n', '        return super.transfer(_to, _value);\n', '    }\n', '}\n', '/**\n', ' * @title Crowdsale \n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' *\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet \n', ' * as they arrive.\n', ' */\n', 'contract Crowdsale {\n', '    using SafeMath for uint;\n', '\n', '    // The token being sold\n', '    MintableToken public token;\n', '\n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '    uint32 public startTime;\n', '    uint32 public endTime;\n', '\n', '    // address where funds are collected\n', '    address public wallet;\n', '\n', '    // amount of raised money in wei\n', '    uint public weiRaised;\n', '\n', '    /**\n', '     * @dev Amount of already sold tokens.\n', '     */\n', '    uint public soldTokens;\n', '\n', '    /**\n', '     * @dev Maximum amount of tokens to mint.\n', '     */\n', '    uint public hardCap;\n', '\n', '    /**\n', '     * event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);\n', '\n', '\n', '    function Crowdsale(uint32 _startTime, uint32 _endTime, uint _hardCap, address _wallet) {\n', '        require(_startTime >= now);\n', '        require(_endTime >= _startTime);\n', '        require(_wallet != 0x0);\n', '        require(_hardCap > 0);\n', '\n', '        token = createTokenContract();\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        hardCap = _hardCap;\n', '        wallet = _wallet;\n', '    }\n', '\n', '    // creates the token to be sold.\n', '    // override this method to have crowdsale of a specific mintable token.\n', '    function createTokenContract() internal returns (MintableToken) {\n', '        return new MintableToken();\n', '    }\n', '\n', '    /**\n', '     * @dev this method might be overridden for implementing any sale logic.\n', '     * @return Actual rate.\n', '     */\n', '    function getRate(uint amount) internal constant returns (uint);\n', '\n', '    function getBaseRate() internal constant returns (uint);\n', '\n', '    /**\n', '     * @dev rate scale (or divider), to support not integer rates.\n', '     * @return Rate divider.\n', '     */\n', '    function getRateScale() internal constant returns (uint) {\n', '        return 1;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() payable {\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary, uint amountWei) internal {\n', '        require(beneficiary != 0x0);\n', '\n', '        // total minted tokens\n', '        uint totalSupply = token.totalSupply();\n', '\n', '        // actual token minting rate (with considering bonuses and discounts)\n', '        uint actualRate = getRate(amountWei);\n', '        uint rateScale = getRateScale();\n', '\n', '        require(validPurchase(amountWei, actualRate, totalSupply));\n', '\n', '        // calculate token amount to be created\n', '        uint tokens = amountWei.mul(actualRate).div(rateScale);\n', '\n', '        // change, if minted token would be less\n', '        uint change = 0;\n', '\n', '        // if hard cap reached\n', '        if (tokens.add(totalSupply) > hardCap) {\n', '            // rest tokens\n', '            uint maxTokens = hardCap.sub(totalSupply);\n', '            uint realAmount = maxTokens.mul(rateScale).div(actualRate);\n', '\n', '            // rest tokens rounded by actualRate\n', '            tokens = realAmount.mul(actualRate).div(rateScale);\n', '            change = amountWei - realAmount;\n', '            amountWei = realAmount;\n', '        }\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(amountWei);\n', '        soldTokens = soldTokens.add(tokens);\n', '\n', '        token.mint(beneficiary, tokens);\n', '        TokenPurchase(msg.sender, beneficiary, amountWei, tokens);\n', '\n', '        if (change != 0) {\n', '            msg.sender.transfer(change);\n', '        }\n', '        forwardFunds(amountWei);\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    // override to create custom fund forwarding mechanisms\n', '    function forwardFunds(uint amountWei) internal {\n', '        wallet.transfer(amountWei);\n', '    }\n', '\n', '    /**\n', '     * @dev Check if the specified purchase is valid.\n', '     * @return true if the transaction can buy tokens\n', '     */\n', '    function validPurchase(uint _amountWei, uint _actualRate, uint _totalSupply) internal constant returns (bool) {\n', '        bool withinPeriod = now >= startTime && now <= endTime;\n', '        bool nonZeroPurchase = _amountWei != 0;\n', '        bool hardCapNotReached = _totalSupply <= hardCap.sub(_actualRate);\n', '\n', '        return withinPeriod && nonZeroPurchase && hardCapNotReached;\n', '    }\n', '\n', '    /**\n', '     * @dev Because of discount hasEnded might be true, but validPurchase returns false.\n', '     * @return true if crowdsale event has ended\n', '     */\n', '    function hasEnded() public constant returns (bool) {\n', '        return now > endTime || token.totalSupply() > hardCap.sub(getBaseRate());\n', '    }\n', '\n', '    /**\n', '     * @return true if crowdsale event has started\n', '     */\n', '    function hasStarted() public constant returns (bool) {\n', '        return now >= startTime;\n', '    }\n', '\n', '    /**\n', '     * @dev Check this crowdsale event has ended considering with amount to buy.\n', '     * @param _value Amount to spend.\n', '     * @return true if crowdsale event has ended\n', '     */\n', '    function hasEnded(uint _value) public constant returns (bool) {\n', '        uint actualRate = getRate(_value);\n', '        return now > endTime || token.totalSupply() > hardCap.sub(actualRate);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title FinalizableCrowdsale\n', ' * @dev Extension of Crowsdale where an owner can do extra work\n', ' * after finishing. \n', ' */\n', 'contract FinalizableCrowdsale is Crowdsale, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    bool public isFinalized = false;\n', '\n', '    event Finalized();\n', '\n', '    function FinalizableCrowdsale(uint32 _startTime, uint32 _endTime, uint _hardCap, address _wallet)\n', '            Crowdsale(_startTime, _endTime, _hardCap, _wallet) {\n', '    }\n', '\n', '    /**\n', '     * @dev Must be called after crowdsale ends, to do some extra finalization\n', '     * work. Calls the contract&#39;s finalization function.\n', '     */\n', '    function finalize() onlyOwner notFinalized {\n', '        require(hasEnded());\n', '\n', '        finalization();\n', '        Finalized();\n', '\n', '        isFinalized = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Can be overriden to add finalization logic. The overriding function\n', '     * should call super.finalization() to ensure the chain of finalization is\n', '     * executed entirely.\n', '     */\n', '    function finalization() internal {\n', '    }\n', '\n', '    modifier notFinalized() {\n', '        require(!isFinalized);\n', '        _;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title RefundVault\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it if crowdsale is successful.\n', ' */\n', 'contract RefundVault is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    enum State {Active, Refunding, Closed}\n', '\n', '    mapping (address => uint256) public deposited;\n', '\n', '    address public wallet;\n', '\n', '    State public state;\n', '\n', '    event Closed();\n', '\n', '    event RefundsEnabled();\n', '\n', '    event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '    function RefundVault(address _wallet) {\n', '        require(_wallet != 0x0);\n', '        wallet = _wallet;\n', '        state = State.Active;\n', '    }\n', '\n', '    function deposit(address investor) onlyOwner payable {\n', '        require(state == State.Active);\n', '        deposited[investor] = deposited[investor].add(msg.value);\n', '    }\n', '\n', '    function close() onlyOwner {\n', '        require(state == State.Active);\n', '        state = State.Closed;\n', '        Closed();\n', '        wallet.transfer(this.balance);\n', '    }\n', '\n', '    function enableRefunds() onlyOwner {\n', '        require(state == State.Active);\n', '        state = State.Refunding;\n', '        RefundsEnabled();\n', '    }\n', '\n', '    function refund(address investor) onlyOwner {\n', '        require(state == State.Refunding);\n', '        uint256 depositedValue = deposited[investor];\n', '        deposited[investor] = 0;\n', '        investor.transfer(depositedValue);\n', '        Refunded(investor, depositedValue);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title RefundableCrowdsale\n', ' * @dev Extension of Crowdsale contract that adds a funding goal, and\n', ' * the possibility of users getting a refund if goal is not met.\n', ' * Uses a RefundVault as the crowdsale&#39;s vault.\n', ' */\n', 'contract RefundableCrowdsale is FinalizableCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    // minimum amount of funds to be raised in weis\n', '    uint public goal;\n', '\n', '    // refund vault used to hold funds while crowdsale is running\n', '    RefundVault public vault;\n', '\n', '    function RefundableCrowdsale(uint32 _startTime, uint32 _endTime, uint _hardCap, address _wallet, uint _goal)\n', '            FinalizableCrowdsale(_startTime, _endTime, _hardCap, _wallet) {\n', '        require(_goal > 0);\n', '        vault = new RefundVault(wallet);\n', '        goal = _goal;\n', '    }\n', '\n', '    // We&#39;re overriding the fund forwarding from Crowdsale.\n', '    // In addition to sending the funds, we want to call\n', '    // the RefundVault deposit function\n', '    function forwardFunds(uint amountWei) internal {\n', '        if (goalReached()) {\n', '            wallet.transfer(amountWei);\n', '        }\n', '        else {\n', '            vault.deposit.value(amountWei)(msg.sender);\n', '        }\n', '    }\n', '\n', '    // if crowdsale is unsuccessful, investors can claim refunds here\n', '    function claimRefund() public {\n', '        require(isFinalized);\n', '        require(!goalReached());\n', '\n', '        vault.refund(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Close vault only if goal was reached.\n', '     */\n', '    function closeVault() public onlyOwner {\n', '        require(goalReached());\n', '        vault.close();\n', '    }\n', '\n', '    // vault finalization task, called when owner calls finalize()\n', '    function finalization() internal {\n', '        super.finalization();\n', '\n', '        if (goalReached()) {\n', '            vault.close();\n', '        }\n', '        else {\n', '            vault.enableRefunds();\n', '        }\n', '    }\n', '\n', '    function goalReached() public constant returns (bool) {\n', '        return weiRaised >= goal;\n', '    }\n', '\n', '}\n', 'contract MyWillRateProviderI {\n', '    /**\n', '     * @dev Calculate actual rate using the specified parameters.\n', '     * @param buyer     Investor (buyer) address.\n', '     * @param totalSold Amount of sold tokens.\n', '     * @param amountWei Amount of wei to purchase.\n', '     * @return ETH to Token rate.\n', '     */\n', '    function getRate(address buyer, uint totalSold, uint amountWei) public constant returns (uint);\n', '\n', '    /**\n', '     * @dev rate scale (or divider), to support not integer rates.\n', '     * @return Rate divider.\n', '     */\n', '    function getRateScale() public constant returns (uint);\n', '\n', '    /**\n', '     * @return Absolute base rate.\n', '     */\n', '    function getBaseRate() public constant returns (uint);\n', '}\n', '\n', 'contract MyWillRateProvider is usingMyWillConsts, MyWillRateProviderI, Ownable {\n', '    // rate calculate accuracy\n', '    uint constant RATE_SCALE = 10000;\n', '    uint constant STEP_30 = 20000000 * TOKEN_DECIMAL_MULTIPLIER;\n', '    uint constant STEP_20 = 40000000 * TOKEN_DECIMAL_MULTIPLIER;\n', '    uint constant STEP_10 = 60000000 * TOKEN_DECIMAL_MULTIPLIER;\n', '    uint constant RATE_30 = 1950 * RATE_SCALE;\n', '    uint constant RATE_20 = 1800 * RATE_SCALE;\n', '    uint constant RATE_10 = 1650 * RATE_SCALE;\n', '    uint constant BASE_RATE = 1500 * RATE_SCALE;\n', '\n', '    struct ExclusiveRate {\n', '        // be careful, accuracies this about 15 minutes\n', '        uint32 workUntil;\n', '        // exclusive rate or 0\n', '        uint rate;\n', '        // rate bonus percent, which will be divided by 1000 or 0\n', '        uint16 bonusPercent1000;\n', '        // flag to check, that record exists\n', '        bool exists;\n', '    }\n', '\n', '    mapping(address => ExclusiveRate) exclusiveRate;\n', '\n', '    function getRateScale() public constant returns (uint) {\n', '        return RATE_SCALE;\n', '    }\n', '\n', '    function getBaseRate() public constant returns (uint) {\n', '        return BASE_RATE;\n', '    }\n', '\n', '    function getRate(address buyer, uint totalSold, uint amountWei) public constant returns (uint) {\n', '        uint rate;\n', '        // apply sale\n', '        if (totalSold < STEP_30) {\n', '            rate = RATE_30;\n', '        }\n', '        else if (totalSold < STEP_20) {\n', '            rate = RATE_20;\n', '        }\n', '        else if (totalSold < STEP_10) {\n', '            rate = RATE_10;\n', '        }\n', '        else {\n', '            rate = BASE_RATE;\n', '        }\n', '\n', '        // apply bonus for amount\n', '        if (amountWei >= 1000 ether) {\n', '            rate += rate * 13 / 100;\n', '        }\n', '        else if (amountWei >= 500 ether) {\n', '            rate += rate * 10 / 100;\n', '        }\n', '        else if (amountWei >= 100 ether) {\n', '            rate += rate * 7 / 100;\n', '        }\n', '        else if (amountWei >= 50 ether) {\n', '            rate += rate * 5 / 100;\n', '        }\n', '        else if (amountWei >= 30 ether) {\n', '            rate += rate * 4 / 100;\n', '        }\n', '        else if (amountWei >= 10 ether) {\n', '            rate += rate * 25 / 1000;\n', '        }\n', '\n', '        ExclusiveRate memory eRate = exclusiveRate[buyer];\n', '        if (eRate.exists && eRate.workUntil >= now) {\n', '            if (eRate.rate != 0) {\n', '                rate = eRate.rate;\n', '            }\n', '            rate += rate * eRate.bonusPercent1000 / 1000;\n', '        }\n', '        return rate;\n', '    }\n', '\n', '    function setExclusiveRate(address _investor, uint _rate, uint16 _bonusPercent1000, uint32 _workUntil) onlyOwner {\n', '        exclusiveRate[_investor] = ExclusiveRate(_workUntil, _rate, _bonusPercent1000, true);\n', '    }\n', '\n', '    function removeExclusiveRate(address _investor) onlyOwner {\n', '        delete exclusiveRate[_investor];\n', '    }\n', '}\n', 'contract MyWillCrowdsale is usingMyWillConsts, RefundableCrowdsale {\n', '    uint constant teamTokens = 11000000 * TOKEN_DECIMAL_MULTIPLIER;\n', '    uint constant bountyTokens = 2000000 * TOKEN_DECIMAL_MULTIPLIER;\n', '    uint constant icoTokens = 3038800 * TOKEN_DECIMAL_MULTIPLIER;\n', '    uint constant minimalPurchase = 0.05 ether;\n', '    address constant teamAddress = 0xE4F0Ff4641f3c99de342b06c06414d94A585eFfb;\n', '    address constant bountyAddress = 0x76d4136d6EE53DB4cc087F2E2990283d5317A5e9;\n', '    address constant icoAccountAddress = 0x195610851A43E9685643A8F3b49F0F8a019204f1;\n', '\n', '    MyWillRateProviderI public rateProvider;\n', '\n', '    function MyWillCrowdsale(\n', '            uint32 _startTime,\n', '            uint32 _endTime,\n', '            uint _softCapWei,\n', '            uint _hardCapTokens\n', '    )\n', '        RefundableCrowdsale(_startTime, _endTime, _hardCapTokens * TOKEN_DECIMAL_MULTIPLIER, 0x80826b5b717aDd3E840343364EC9d971FBa3955C, _softCapWei) {\n', '\n', '        token.mint(teamAddress,  teamTokens);\n', '        token.mint(bountyAddress, bountyTokens);\n', '        token.mint(icoAccountAddress, icoTokens);\n', '\n', '        MyWillToken(token).addExcluded(teamAddress);\n', '        MyWillToken(token).addExcluded(bountyAddress);\n', '        MyWillToken(token).addExcluded(icoAccountAddress);\n', '\n', '        MyWillRateProvider provider = new MyWillRateProvider();\n', '        provider.transferOwnership(owner);\n', '        rateProvider = provider;\n', '\n', '        // pre ICO\n', '    }\n', '\n', '    /**\n', '     * @dev override token creation to integrate with MyWill token.\n', '     */\n', '    function createTokenContract() internal returns (MintableToken) {\n', '        return new MyWillToken();\n', '    }\n', '\n', '    /**\n', '     * @dev override getRate to integrate with rate provider.\n', '     */\n', '    function getRate(uint _value) internal constant returns (uint) {\n', '        return rateProvider.getRate(msg.sender, soldTokens, _value);\n', '    }\n', '\n', '    function getBaseRate() internal constant returns (uint) {\n', '        return rateProvider.getRate(msg.sender, soldTokens, minimalPurchase);\n', '    }\n', '\n', '    /**\n', '     * @dev override getRateScale to integrate with rate provider.\n', '     */\n', '    function getRateScale() internal constant returns (uint) {\n', '        return rateProvider.getRateScale();\n', '    }\n', '\n', '    /**\n', '     * @dev Admin can set new rate provider.\n', '     * @param _rateProviderAddress New rate provider.\n', '     */\n', '    function setRateProvider(address _rateProviderAddress) onlyOwner {\n', '        require(_rateProviderAddress != 0);\n', '        rateProvider = MyWillRateProviderI(_rateProviderAddress);\n', '    }\n', '\n', '    /**\n', '     * @dev Admin can move end time.\n', '     * @param _endTime New end time.\n', '     */\n', '    function setEndTime(uint32 _endTime) onlyOwner notFinalized {\n', '        require(_endTime > startTime);\n', '        endTime = _endTime;\n', '    }\n', '\n', '    function validPurchase(uint _amountWei, uint _actualRate, uint _totalSupply) internal constant returns (bool) {\n', '        if (_amountWei < minimalPurchase) {\n', '            return false;\n', '        }\n', '        return super.validPurchase(_amountWei, _actualRate, _totalSupply);\n', '    }\n', '\n', '    function finalization() internal {\n', '        super.finalization();\n', '        token.finishMinting();\n', '        if (!goalReached()) {\n', '            return;\n', '        }\n', '        MyWillToken(token).crowdsaleFinished();\n', '        token.transferOwnership(owner);\n', '    }\n', '}']
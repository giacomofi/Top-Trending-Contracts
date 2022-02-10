['pragma solidity ^0.4.19;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address who) constant public returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant public returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    address public newOwner;\n', '\n', '    function Owned() public payable {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address _owner) onlyOwner public {\n', '        require(_owner != 0);\n', '        newOwner = _owner;\n', '    }\n', '\n', '    function confirmOwner() public {\n', '        require(newOwner == msg.sender);\n', '        owner = newOwner;\n', '        delete newOwner;\n', '    }\n', '}\n', '\n', 'contract Blocked {\n', '\n', '    uint public blockedUntil;\n', '\n', '    modifier unblocked {\n', '        require(now > blockedUntil);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract BasicToken is ERC20Basic, Blocked {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    // Fix for the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) unblocked public returns (bool) {\n', '        uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {\n', '\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) onlyPayloadSize(2 * 32) unblocked constant public returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) unblocked public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', 'contract DEVCoin is BurnableToken, Owned {\n', '\n', '    string public constant name = "Dev Coin";\n', '\n', '    string public constant symbol = "DEVC";\n', '\n', '    uint32 public constant decimals = 18;\n', '\n', '    function DEVCoin(uint256 initialSupply, uint unblockTime) public {\n', '        totalSupply = initialSupply;\n', '        balances[owner] = initialSupply;\n', '        blockedUntil = unblockTime;\n', '    }\n', '\n', '    function manualTransfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyOwner public returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract ManualSendingCrowdsale is Owned {\n', '    using SafeMath for uint256;\n', '\n', '    struct AmountData {\n', '        bool exists;\n', '        uint256 value;\n', '    }\n', '\n', '    mapping (uint => AmountData) public amountsByCurrency;\n', '\n', '    function addCurrency(uint currency) external onlyOwner {\n', '        addCurrencyInternal(currency);\n', '    }\n', '\n', '    function addCurrencyInternal(uint currency) internal {\n', '        AmountData storage amountData = amountsByCurrency[currency];\n', '        amountData.exists = true;\n', '    }\n', '\n', '    function manualTransferTokensToInternal(address to, uint256 givenTokens, uint currency, uint256 amount) internal returns (uint256) {\n', '        AmountData memory tempAmountData = amountsByCurrency[currency];\n', '        require(tempAmountData.exists);\n', '        AmountData storage amountData = amountsByCurrency[currency];\n', '        amountData.value = amountData.value.add(amount);\n', '        return transferTokensTo(to, givenTokens);\n', '    }\n', '\n', '    function transferTokensTo(address to, uint256 givenTokens) internal returns (uint256);\n', '}\n', '\n', 'contract Crowdsale is ManualSendingCrowdsale {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    enum State { PRE_ICO, ICO }\n', '\n', '    State public state = State.PRE_ICO;\n', '\n', '    // Date of start pre-ICO and ICO.\n', '    uint public constant preICOstartTime =    1522454400; // start at Saturday, March 31, 2018 12:00:00 AM\n', '    uint public constant preICOendTime =      1523750400; // end at Sunday, April 15, 2018 12:00:00 AM\n', '    uint public constant ICOstartTime =    1524355200; // start at Tuesday, May 22, 2018 12:00:00 AM\n', '    uint public constant ICOendTime =      1527033600; // end at Wednesday, May 23, 2018 12:00:00 AM\n', '\n', '    uint public constant bountyAvailabilityTime = ICOendTime + 90 days;\n', '\n', '    uint256 public constant maxTokenAmount = 108e24; // max minting   (108, 000, 000 tokens)\n', '    uint256 public constant bountyTokens =   324e23; // bounty amount ( 32, 400, 000 tokens)\n', '\n', '    uint256 public constant maxPreICOTokenAmount = 81e23; // max number of tokens on pre-ICO (8, 100, 000 tokens);\n', '\n', '    DEVCoin public token;\n', '\n', '    uint256 public leftTokens = 0;\n', '\n', '    uint256 public totalAmount = 0;\n', '    uint public transactionCounter = 0;\n', '\n', '    /** ------------------------------- */\n', '    /** Bonus part: */\n', '\n', '    // Amount bonuses\n', '    uint private firstAmountBonus = 20;\n', '    uint256 private firstAmountBonusBarrier = 500 ether;\n', '    uint private secondAmountBonus = 15;\n', '    uint256 private secondAmountBonusBarrier = 100 ether;\n', '    uint private thirdAmountBonus = 10;\n', '    uint256 private thirdAmountBonusBarrier = 50 ether;\n', '    uint private fourthAmountBonus = 5;\n', '    uint256 private fourthAmountBonusBarrier = 20 ether;\n', '\n', '    // pre-ICO bonuses by time\n', '    uint private firstPreICOTimeBarrier = preICOstartTime + 1 days;\n', '    uint private firstPreICOTimeBonus = 20;\n', '    uint private secondPreICOTimeBarrier = preICOstartTime + 7 days;\n', '    uint private secondPreICOTimeBonus = 10;\n', '    uint private thirdPreICOTimeBarrier = preICOstartTime + 14 days;\n', '    uint private thirdPreICOTimeBonus = 5;\n', '\n', '    // ICO bonuses by time\n', '    uint private firstICOTimeBarrier = ICOstartTime + 1 days;\n', '    uint private firstICOTimeBonus = 15;\n', '    uint private secondICOTimeBarrier = ICOstartTime + 7 days;\n', '    uint private secondICOTimeBonus = 7;\n', '    uint private thirdICOTimeBarrier = ICOstartTime + 14 days;\n', '    uint private thirdICOTimeBonus = 4;\n', '\n', '    /** ------------------------------- */\n', '\n', '    bool public bonusesPayed = false;\n', '\n', '    uint256 public constant rateToEther = 9000; // rate to ether, how much tokens gives to 1 ether\n', '\n', '    uint256 public constant minAmountForDeal = 10**17;\n', '\n', '    modifier canBuy() {\n', '        require(!isFinished());\n', '        require(isPreICO() || isICO());\n', '        _;\n', '    }\n', '\n', '    modifier minPayment() {\n', '        require(msg.value >= minAmountForDeal);\n', '        _;\n', '    }\n', '\n', '    function Crowdsale() public {\n', '        //require(currentTime() < preICOstartTime);\n', '        token = new DEVCoin(maxTokenAmount, ICOendTime);\n', '        leftTokens = maxPreICOTokenAmount;\n', '        addCurrencyInternal(0); // add BTC\n', '    }\n', '\n', '    function isFinished() public constant returns (bool) {\n', '        return currentTime() > ICOendTime || (leftTokens == 0 && state == State.ICO);\n', '    }\n', '\n', '    function isPreICO() public constant returns (bool) {\n', '        uint curTime = currentTime();\n', '        return curTime < preICOendTime && curTime > preICOstartTime;\n', '    }\n', '\n', '    function isICO() public constant returns (bool) {\n', '        uint curTime = currentTime();\n', '        return curTime < ICOendTime && curTime > ICOstartTime;\n', '    }\n', '\n', '    function() external canBuy minPayment payable {\n', '        uint256 amount = msg.value;\n', '        uint bonus = getBonus(amount);\n', '        uint256 givenTokens = amount.mul(rateToEther).div(100).mul(100 + bonus);\n', '        uint256 providedTokens = transferTokensTo(msg.sender, givenTokens);\n', '\n', '        if (givenTokens > providedTokens) {\n', '            uint256 needAmount = providedTokens.mul(100).div(100 + bonus).div(rateToEther);\n', '            require(amount > needAmount);\n', '            require(msg.sender.call.gas(3000000).value(amount - needAmount)());\n', '            amount = needAmount;\n', '        }\n', '        totalAmount = totalAmount.add(amount);\n', '    }\n', '\n', '    function manualTransferTokensToWithBonus(address to, uint256 givenTokens, uint currency, uint256 amount) external canBuy onlyOwner returns (uint256) {\n', '        uint bonus = getBonus(0);\n', '        uint256 transferedTokens = givenTokens.mul(100 + bonus).div(100);\n', '        return manualTransferTokensToInternal(to, transferedTokens, currency, amount);\n', '    }\n', '\n', '    function manualTransferTokensTo(address to, uint256 givenTokens, uint currency, uint256 amount) external onlyOwner canBuy returns (uint256) {\n', '        return manualTransferTokensToInternal(to, givenTokens, currency, amount);\n', '    }\n', '\n', '    function getBonus(uint256 amount) public constant returns (uint) {\n', '        uint bonus = 0;\n', '        if (isPreICO()) {\n', '            bonus = getPreICOBonus();\n', '        }\n', '\n', '        if (isICO()) {\n', '            bonus = getICOBonus();\n', '        }\n', '        return bonus + getAmountBonus(amount);\n', '    }\n', '\n', '    function getAmountBonus(uint256 amount) public constant returns (uint) {\n', '        if (amount >= firstAmountBonusBarrier) {\n', '            return firstAmountBonus;\n', '        }\n', '        if (amount >= secondAmountBonusBarrier) {\n', '            return secondAmountBonus;\n', '        }\n', '        if (amount >= thirdAmountBonusBarrier) {\n', '            return thirdAmountBonus;\n', '        }\n', '        if (amount >= fourthAmountBonusBarrier) {\n', '            return fourthAmountBonus;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function getPreICOBonus() public constant returns (uint) {\n', '        uint curTime = currentTime();\n', '        if (curTime < firstPreICOTimeBarrier) {\n', '            return firstPreICOTimeBonus;\n', '        }\n', '        if (curTime < secondPreICOTimeBarrier) {\n', '            return secondPreICOTimeBonus;\n', '        }\n', '        if (curTime < thirdPreICOTimeBarrier) {\n', '            return thirdPreICOTimeBonus;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function getICOBonus() public constant returns (uint) {\n', '        uint curTime = currentTime();\n', '        if (curTime < firstICOTimeBarrier) {\n', '            return firstICOTimeBonus;\n', '        }\n', '        if (curTime < secondICOTimeBarrier) {\n', '            return secondICOTimeBonus;\n', '        }\n', '        if (curTime < thirdICOTimeBarrier) {\n', '            return thirdICOTimeBonus;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function finishCrowdsale() external {\n', '        require(isFinished());\n', '        require(state == State.ICO);\n', '        if (leftTokens > 0) {\n', '            token.burn(leftTokens);\n', '            leftTokens = 0;\n', '        }\n', '    }\n', '\n', '    function takeBounty() external onlyOwner {\n', '        require(isFinished());\n', '        require(state == State.ICO);\n', '        require(now > bountyAvailabilityTime);\n', '        require(!bonusesPayed);\n', '        bonusesPayed = true;\n', '        require(token.transfer(msg.sender, bountyTokens));\n', '    }\n', '\n', '    function startICO() external {\n', '        require(currentTime() > preICOendTime);\n', '        require(state == State.PRE_ICO && leftTokens <= maxPreICOTokenAmount);\n', '        leftTokens = leftTokens.add(maxTokenAmount).sub(maxPreICOTokenAmount).sub(bountyTokens);\n', '        state = State.ICO;\n', '    }\n', '\n', '    function transferTokensTo(address to, uint256 givenTokens) internal returns (uint256) {\n', '        uint256 providedTokens = givenTokens;\n', '        if (givenTokens > leftTokens) {\n', '            providedTokens = leftTokens;\n', '        }\n', '        leftTokens = leftTokens.sub(providedTokens);\n', '        require(token.manualTransfer(to, providedTokens));\n', '        transactionCounter = transactionCounter + 1;\n', '        return providedTokens;\n', '    }\n', '\n', '    function withdraw() external onlyOwner {\n', '        require(msg.sender.call.gas(3000000).value(address(this).balance)());\n', '    }\n', '\n', '    function withdrawAmount(uint256 amount) external onlyOwner {\n', '        uint256 givenAmount = amount;\n', '        if (address(this).balance < amount) {\n', '            givenAmount = address(this).balance;\n', '        }\n', '        require(msg.sender.call.gas(3000000).value(givenAmount)());\n', '    }\n', '\n', '    function currentTime() internal constant returns (uint) {\n', '        return now;\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address who) constant public returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant public returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    address public newOwner;\n', '\n', '    function Owned() public payable {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address _owner) onlyOwner public {\n', '        require(_owner != 0);\n', '        newOwner = _owner;\n', '    }\n', '\n', '    function confirmOwner() public {\n', '        require(newOwner == msg.sender);\n', '        owner = newOwner;\n', '        delete newOwner;\n', '    }\n', '}\n', '\n', 'contract Blocked {\n', '\n', '    uint public blockedUntil;\n', '\n', '    modifier unblocked {\n', '        require(now > blockedUntil);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract BasicToken is ERC20Basic, Blocked {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    // Fix for the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) unblocked public returns (bool) {\n', '        uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {\n', '\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) onlyPayloadSize(2 * 32) unblocked constant public returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) unblocked public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', 'contract DEVCoin is BurnableToken, Owned {\n', '\n', '    string public constant name = "Dev Coin";\n', '\n', '    string public constant symbol = "DEVC";\n', '\n', '    uint32 public constant decimals = 18;\n', '\n', '    function DEVCoin(uint256 initialSupply, uint unblockTime) public {\n', '        totalSupply = initialSupply;\n', '        balances[owner] = initialSupply;\n', '        blockedUntil = unblockTime;\n', '    }\n', '\n', '    function manualTransfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyOwner public returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract ManualSendingCrowdsale is Owned {\n', '    using SafeMath for uint256;\n', '\n', '    struct AmountData {\n', '        bool exists;\n', '        uint256 value;\n', '    }\n', '\n', '    mapping (uint => AmountData) public amountsByCurrency;\n', '\n', '    function addCurrency(uint currency) external onlyOwner {\n', '        addCurrencyInternal(currency);\n', '    }\n', '\n', '    function addCurrencyInternal(uint currency) internal {\n', '        AmountData storage amountData = amountsByCurrency[currency];\n', '        amountData.exists = true;\n', '    }\n', '\n', '    function manualTransferTokensToInternal(address to, uint256 givenTokens, uint currency, uint256 amount) internal returns (uint256) {\n', '        AmountData memory tempAmountData = amountsByCurrency[currency];\n', '        require(tempAmountData.exists);\n', '        AmountData storage amountData = amountsByCurrency[currency];\n', '        amountData.value = amountData.value.add(amount);\n', '        return transferTokensTo(to, givenTokens);\n', '    }\n', '\n', '    function transferTokensTo(address to, uint256 givenTokens) internal returns (uint256);\n', '}\n', '\n', 'contract Crowdsale is ManualSendingCrowdsale {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    enum State { PRE_ICO, ICO }\n', '\n', '    State public state = State.PRE_ICO;\n', '\n', '    // Date of start pre-ICO and ICO.\n', '    uint public constant preICOstartTime =    1522454400; // start at Saturday, March 31, 2018 12:00:00 AM\n', '    uint public constant preICOendTime =      1523750400; // end at Sunday, April 15, 2018 12:00:00 AM\n', '    uint public constant ICOstartTime =    1524355200; // start at Tuesday, May 22, 2018 12:00:00 AM\n', '    uint public constant ICOendTime =      1527033600; // end at Wednesday, May 23, 2018 12:00:00 AM\n', '\n', '    uint public constant bountyAvailabilityTime = ICOendTime + 90 days;\n', '\n', '    uint256 public constant maxTokenAmount = 108e24; // max minting   (108, 000, 000 tokens)\n', '    uint256 public constant bountyTokens =   324e23; // bounty amount ( 32, 400, 000 tokens)\n', '\n', '    uint256 public constant maxPreICOTokenAmount = 81e23; // max number of tokens on pre-ICO (8, 100, 000 tokens);\n', '\n', '    DEVCoin public token;\n', '\n', '    uint256 public leftTokens = 0;\n', '\n', '    uint256 public totalAmount = 0;\n', '    uint public transactionCounter = 0;\n', '\n', '    /** ------------------------------- */\n', '    /** Bonus part: */\n', '\n', '    // Amount bonuses\n', '    uint private firstAmountBonus = 20;\n', '    uint256 private firstAmountBonusBarrier = 500 ether;\n', '    uint private secondAmountBonus = 15;\n', '    uint256 private secondAmountBonusBarrier = 100 ether;\n', '    uint private thirdAmountBonus = 10;\n', '    uint256 private thirdAmountBonusBarrier = 50 ether;\n', '    uint private fourthAmountBonus = 5;\n', '    uint256 private fourthAmountBonusBarrier = 20 ether;\n', '\n', '    // pre-ICO bonuses by time\n', '    uint private firstPreICOTimeBarrier = preICOstartTime + 1 days;\n', '    uint private firstPreICOTimeBonus = 20;\n', '    uint private secondPreICOTimeBarrier = preICOstartTime + 7 days;\n', '    uint private secondPreICOTimeBonus = 10;\n', '    uint private thirdPreICOTimeBarrier = preICOstartTime + 14 days;\n', '    uint private thirdPreICOTimeBonus = 5;\n', '\n', '    // ICO bonuses by time\n', '    uint private firstICOTimeBarrier = ICOstartTime + 1 days;\n', '    uint private firstICOTimeBonus = 15;\n', '    uint private secondICOTimeBarrier = ICOstartTime + 7 days;\n', '    uint private secondICOTimeBonus = 7;\n', '    uint private thirdICOTimeBarrier = ICOstartTime + 14 days;\n', '    uint private thirdICOTimeBonus = 4;\n', '\n', '    /** ------------------------------- */\n', '\n', '    bool public bonusesPayed = false;\n', '\n', '    uint256 public constant rateToEther = 9000; // rate to ether, how much tokens gives to 1 ether\n', '\n', '    uint256 public constant minAmountForDeal = 10**17;\n', '\n', '    modifier canBuy() {\n', '        require(!isFinished());\n', '        require(isPreICO() || isICO());\n', '        _;\n', '    }\n', '\n', '    modifier minPayment() {\n', '        require(msg.value >= minAmountForDeal);\n', '        _;\n', '    }\n', '\n', '    function Crowdsale() public {\n', '        //require(currentTime() < preICOstartTime);\n', '        token = new DEVCoin(maxTokenAmount, ICOendTime);\n', '        leftTokens = maxPreICOTokenAmount;\n', '        addCurrencyInternal(0); // add BTC\n', '    }\n', '\n', '    function isFinished() public constant returns (bool) {\n', '        return currentTime() > ICOendTime || (leftTokens == 0 && state == State.ICO);\n', '    }\n', '\n', '    function isPreICO() public constant returns (bool) {\n', '        uint curTime = currentTime();\n', '        return curTime < preICOendTime && curTime > preICOstartTime;\n', '    }\n', '\n', '    function isICO() public constant returns (bool) {\n', '        uint curTime = currentTime();\n', '        return curTime < ICOendTime && curTime > ICOstartTime;\n', '    }\n', '\n', '    function() external canBuy minPayment payable {\n', '        uint256 amount = msg.value;\n', '        uint bonus = getBonus(amount);\n', '        uint256 givenTokens = amount.mul(rateToEther).div(100).mul(100 + bonus);\n', '        uint256 providedTokens = transferTokensTo(msg.sender, givenTokens);\n', '\n', '        if (givenTokens > providedTokens) {\n', '            uint256 needAmount = providedTokens.mul(100).div(100 + bonus).div(rateToEther);\n', '            require(amount > needAmount);\n', '            require(msg.sender.call.gas(3000000).value(amount - needAmount)());\n', '            amount = needAmount;\n', '        }\n', '        totalAmount = totalAmount.add(amount);\n', '    }\n', '\n', '    function manualTransferTokensToWithBonus(address to, uint256 givenTokens, uint currency, uint256 amount) external canBuy onlyOwner returns (uint256) {\n', '        uint bonus = getBonus(0);\n', '        uint256 transferedTokens = givenTokens.mul(100 + bonus).div(100);\n', '        return manualTransferTokensToInternal(to, transferedTokens, currency, amount);\n', '    }\n', '\n', '    function manualTransferTokensTo(address to, uint256 givenTokens, uint currency, uint256 amount) external onlyOwner canBuy returns (uint256) {\n', '        return manualTransferTokensToInternal(to, givenTokens, currency, amount);\n', '    }\n', '\n', '    function getBonus(uint256 amount) public constant returns (uint) {\n', '        uint bonus = 0;\n', '        if (isPreICO()) {\n', '            bonus = getPreICOBonus();\n', '        }\n', '\n', '        if (isICO()) {\n', '            bonus = getICOBonus();\n', '        }\n', '        return bonus + getAmountBonus(amount);\n', '    }\n', '\n', '    function getAmountBonus(uint256 amount) public constant returns (uint) {\n', '        if (amount >= firstAmountBonusBarrier) {\n', '            return firstAmountBonus;\n', '        }\n', '        if (amount >= secondAmountBonusBarrier) {\n', '            return secondAmountBonus;\n', '        }\n', '        if (amount >= thirdAmountBonusBarrier) {\n', '            return thirdAmountBonus;\n', '        }\n', '        if (amount >= fourthAmountBonusBarrier) {\n', '            return fourthAmountBonus;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function getPreICOBonus() public constant returns (uint) {\n', '        uint curTime = currentTime();\n', '        if (curTime < firstPreICOTimeBarrier) {\n', '            return firstPreICOTimeBonus;\n', '        }\n', '        if (curTime < secondPreICOTimeBarrier) {\n', '            return secondPreICOTimeBonus;\n', '        }\n', '        if (curTime < thirdPreICOTimeBarrier) {\n', '            return thirdPreICOTimeBonus;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function getICOBonus() public constant returns (uint) {\n', '        uint curTime = currentTime();\n', '        if (curTime < firstICOTimeBarrier) {\n', '            return firstICOTimeBonus;\n', '        }\n', '        if (curTime < secondICOTimeBarrier) {\n', '            return secondICOTimeBonus;\n', '        }\n', '        if (curTime < thirdICOTimeBarrier) {\n', '            return thirdICOTimeBonus;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function finishCrowdsale() external {\n', '        require(isFinished());\n', '        require(state == State.ICO);\n', '        if (leftTokens > 0) {\n', '            token.burn(leftTokens);\n', '            leftTokens = 0;\n', '        }\n', '    }\n', '\n', '    function takeBounty() external onlyOwner {\n', '        require(isFinished());\n', '        require(state == State.ICO);\n', '        require(now > bountyAvailabilityTime);\n', '        require(!bonusesPayed);\n', '        bonusesPayed = true;\n', '        require(token.transfer(msg.sender, bountyTokens));\n', '    }\n', '\n', '    function startICO() external {\n', '        require(currentTime() > preICOendTime);\n', '        require(state == State.PRE_ICO && leftTokens <= maxPreICOTokenAmount);\n', '        leftTokens = leftTokens.add(maxTokenAmount).sub(maxPreICOTokenAmount).sub(bountyTokens);\n', '        state = State.ICO;\n', '    }\n', '\n', '    function transferTokensTo(address to, uint256 givenTokens) internal returns (uint256) {\n', '        uint256 providedTokens = givenTokens;\n', '        if (givenTokens > leftTokens) {\n', '            providedTokens = leftTokens;\n', '        }\n', '        leftTokens = leftTokens.sub(providedTokens);\n', '        require(token.manualTransfer(to, providedTokens));\n', '        transactionCounter = transactionCounter + 1;\n', '        return providedTokens;\n', '    }\n', '\n', '    function withdraw() external onlyOwner {\n', '        require(msg.sender.call.gas(3000000).value(address(this).balance)());\n', '    }\n', '\n', '    function withdrawAmount(uint256 amount) external onlyOwner {\n', '        uint256 givenAmount = amount;\n', '        if (address(this).balance < amount) {\n', '            givenAmount = address(this).balance;\n', '        }\n', '        require(msg.sender.call.gas(3000000).value(givenAmount)());\n', '    }\n', '\n', '    function currentTime() internal constant returns (uint) {\n', '        return now;\n', '    }\n', '}']
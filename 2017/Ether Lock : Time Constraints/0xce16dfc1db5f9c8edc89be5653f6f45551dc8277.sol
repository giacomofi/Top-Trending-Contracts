['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    address public newOwner;\n', '\n', '    function Owned() public payable {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address _owner) onlyOwner public {\n', '        require(_owner != 0);\n', '        newOwner = _owner;\n', '    }\n', '\n', '    function confirmOwner() public {\n', '        require(newOwner == msg.sender);\n', '        owner = newOwner;\n', '        delete newOwner;\n', '    }\n', '}\n', '\n', 'contract Blocked {\n', '    uint public blockedUntil;\n', '\n', '    modifier unblocked {\n', '        require(now > blockedUntil);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address who) constant public returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant public returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract PayloadSize {\n', '    // Fix for the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract BasicToken is ERC20Basic, Blocked, PayloadSize {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) unblocked public returns (bool) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {\n', '\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) onlyPayloadSize(2 * 32) unblocked constant public returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) unblocked public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', 'contract PreNTFToken is BurnableToken, Owned {\n', '\n', '    string public constant name = "PreNTF Token";\n', '\n', '    string public constant symbol = "PreNTF";\n', '\n', '    uint32 public constant decimals = 18;\n', '\n', '    function PreNTFToken(uint256 initialSupply, uint unblockTime) public {\n', '        totalSupply = initialSupply;\n', '        balances[owner] = initialSupply;\n', '        blockedUntil = unblockTime;\n', '    }\n', '\n', '    function manualTransfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyOwner public returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Crowdsale is Owned, PayloadSize {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    struct AmountData {\n', '        bool exists;\n', '        uint256 value;\n', '    }\n', '\n', '    // Date of start pre-ICO\n', '    uint public constant preICOstartTime =    1512597600; // start at Thursday, December 7, 2017 12:00:00 AM EET\n', '    uint public constant preICOendTime =      1517436000; // end at   Thursday, February 1, 2018 12:00:00 AM EET\n', '    uint public constant blockUntil =         1525122000; // tokens are blocked until Tuesday, May 1, 2018 12:00:00 AM EET\n', '\n', '    uint256 public constant maxTokenAmount = 3375000 * 10**18; // max tokens amount\n', '\n', '    uint256 public constant bountyTokenAmount = 375000 * 10**18;\n', '    uint256 public givenBountyTokens = 0;\n', '\n', '    PreNTFToken public token;\n', '\n', '    uint256 public leftTokens = 0;\n', '\n', '    uint256 public totalAmount = 0;\n', '    uint public transactionCounter = 0;\n', '\n', '    uint256 public constant tokenPrice = 3 * 10**15; // token price in ether\n', '\n', '    uint256 public minAmountForDeal = 9 ether;\n', '\n', '    mapping (uint => AmountData) public amountsByCurrency;\n', '\n', '    mapping (address => uint256) public bountyTokensToAddress;\n', '\n', '    modifier canBuy() {\n', '        require(!isFinished());\n', '        require(now >= preICOstartTime);\n', '        _;\n', '    }\n', '\n', '    modifier minPayment() {\n', '        require(msg.value >= minAmountForDeal);\n', '        _;\n', '    }\n', '\n', '    // Fix for the ERC20 short address attack\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    function Crowdsale() public {\n', '        token = new PreNTFToken(maxTokenAmount, blockUntil);\n', '        leftTokens = maxTokenAmount - bountyTokenAmount;\n', '        // init currency in Crowdsale.\n', '        AmountData storage btcAmountData = amountsByCurrency[0];\n', '        btcAmountData.exists = true;\n', '        AmountData storage bccAmountData = amountsByCurrency[1];\n', '        bccAmountData.exists = true;\n', '        AmountData storage ltcAmountData = amountsByCurrency[2];\n', '        ltcAmountData.exists = true;\n', '        AmountData storage dashAmountData = amountsByCurrency[3];\n', '        dashAmountData.exists = true;\n', '    }\n', '\n', '    function isFinished() public constant returns (bool) {\n', '        return now > preICOendTime || leftTokens == 0;\n', '    }\n', '\n', '    function() external canBuy minPayment payable {\n', '        uint256 amount = msg.value;\n', '        uint256 givenTokens = amount.mul(1 ether).div(tokenPrice);\n', '        uint256 providedTokens = transferTokensTo(msg.sender, givenTokens);\n', '        transactionCounter = transactionCounter + 1;\n', '\n', '        if (givenTokens > providedTokens) {\n', '            uint256 needAmount = providedTokens.mul(tokenPrice).div(1 ether);\n', '            require(amount > needAmount);\n', '            require(msg.sender.call.gas(3000000).value(amount - needAmount)());\n', '            amount = needAmount;\n', '        }\n', '        totalAmount = totalAmount.add(amount);\n', '    }\n', '\n', '    function manualTransferTokensTo(address to, uint256 givenTokens, uint currency, uint256 amount) external canBuy onlyOwner returns (uint256) {\n', '        AmountData memory tempAmountData = amountsByCurrency[currency];\n', '        require(tempAmountData.exists);\n', '        AmountData storage amountData = amountsByCurrency[currency];\n', '        amountData.value = amountData.value.add(amount);\n', '        uint256 value = transferTokensTo(to, givenTokens);\n', '        transactionCounter = transactionCounter + 1;\n', '        return value;\n', '    }\n', '\n', '    function addCurrency(uint currency) external onlyOwner {\n', '        AmountData storage amountData = amountsByCurrency[currency];\n', '        amountData.exists = true;\n', '    }\n', '\n', '    function transferTokensTo(address to, uint256 givenTokens) private returns (uint256) {\n', '        var providedTokens = givenTokens;\n', '        if (givenTokens > leftTokens) {\n', '            providedTokens = leftTokens;\n', '        }\n', '        leftTokens = leftTokens.sub(providedTokens);\n', '        require(token.manualTransfer(to, providedTokens));\n', '        return providedTokens;\n', '    }\n', '\n', '    function finishCrowdsale() external {\n', '        require(isFinished());\n', '        if (leftTokens > 0) {\n', '            token.burn(leftTokens);\n', '            leftTokens = 0;\n', '        }\n', '    }\n', '\n', '    function takeBountyTokens() external returns (bool){\n', '        require(isFinished());\n', '        uint256 allowance = bountyTokensToAddress[msg.sender];\n', '        require(allowance > 0);\n', '        bountyTokensToAddress[msg.sender] = 0;\n', '        require(token.manualTransfer(msg.sender, allowance));\n', '        return true;\n', '    }\n', '\n', '    function giveTokensTo(address holder, uint256 amount) external onlyPayloadSize(2 * 32) onlyOwner returns (bool) {\n', '        require(bountyTokenAmount >= givenBountyTokens.add(amount));\n', '        bountyTokensToAddress[holder] = bountyTokensToAddress[holder].add(amount);\n', '        givenBountyTokens = givenBountyTokens.add(amount);\n', '        return true;\n', '    }\n', '\n', '    function getAmountByCurrency(uint index) external returns (uint256) {\n', '        AmountData memory tempAmountData = amountsByCurrency[index];\n', '        return tempAmountData.value;\n', '    }\n', '\n', '    function withdraw() external onlyOwner {\n', '        require(msg.sender.call.gas(3000000).value(this.balance)());\n', '    }\n', '\n', '    function setAmountForDeal(uint256 value) external onlyOwner {\n', '        minAmountForDeal = value;\n', '    }\n', '\n', '    function withdrawAmount(uint256 amount) external onlyOwner {\n', '        uint256 givenAmount = amount;\n', '        if (this.balance < amount) {\n', '            givenAmount = this.balance;\n', '        }\n', '        require(msg.sender.call.gas(3000000).value(givenAmount)());\n', '    }\n', '}']
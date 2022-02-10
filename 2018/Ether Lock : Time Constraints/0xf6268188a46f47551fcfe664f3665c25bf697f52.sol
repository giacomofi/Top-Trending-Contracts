['pragma solidity ^0.4.16;\n', '\n', 'contract SafeMath{\n', '\n', '  // math operations with safety checks that throw on error\n', '  // small gas improvement\n', '\n', '  function safeMul(uint256 a, uint256 b) internal returns (uint256){\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  \n', '  function safeDiv(uint256 a, uint256 b) internal returns (uint256){\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '  \n', '  function safeSub(uint256 a, uint256 b) internal returns (uint256){\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  \n', '  function safeAdd(uint256 a, uint256 b) internal returns (uint256){\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  // mitigate short address attack\n', '  // https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34\n', '  modifier onlyPayloadSize(uint numWords){\n', '     assert(msg.data.length >= numWords * 32 + 4);\n', '     _;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Token{ // ERC20 standard\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '}\n', '\n', '\n', 'contract StandardToken is Token, SafeMath{\n', '\n', '    uint256 public totalSupply;\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool success){\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value && _value > 0);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success){\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance){\n', '        return balances[_owner];\n', '    }\n', '    \n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success){\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) returns (bool success){\n', '        require(allowed[msg.sender][_spender] == _oldValue);\n', '        allowed[msg.sender][_spender] = _newValue;\n', '        Approval(msg.sender, _spender, _newValue);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining){\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    // this creates an array with all balances\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '}\n', '\n', '\n', 'contract EDEX is StandardToken{\n', '\n', '    // public variables of the token\n', '\n', '    string public name = "Equadex";\n', '    string public symbol = "EDEX";\n', '    uint256 public decimals = 18;\n', '    \n', '    // reachable if max amount raised\n', '    uint256 public maxSupply = 100000000e18;\n', '    \n', '    // ICO starting and ending blocks, can be changed as needed\n', '    uint256 public icoStartBlock;\n', '    // icoEndBlock = icoStartBlock + 345,600 blocks for 2 months ICO\n', '    uint256 public icoEndBlock;\n', '\n', '    // set the wallets with different levels of authority\n', '    address public mainWallet;\n', '    address public secondaryWallet;\n', '    \n', '    // time to wait between secondaryWallet price updates, mainWallet can update without restrictions\n', '    uint256 public priceUpdateWaitingTime = 1 hours;\n', '\n', '    uint256 public previousUpdateTime = 0;\n', '    \n', '    // strucure of price\n', '    PriceEDEX public currentPrice;\n', '    uint256 public minInvestment = 0.01 ether;\n', '    \n', '    // for tokens allocated to the team\n', '    address public grantVestedEDEXContract;\n', '    bool private grantVestedEDEXSet = false;\n', '    \n', '    // halt the crowdsale should any suspicious behavior of a third-party be identified\n', '    // tokens will be locked for trading until they are listed on exchanges\n', '    bool public haltICO = false;\n', '    bool public setTrading = false;\n', '\n', '    // maps investor address to a liquidation request\n', '    mapping (address => Liquidation) public liquidations;\n', '    // maps previousUpdateTime to the next price\n', '    mapping (uint256 => PriceEDEX) public prices;\n', '    // maps verified addresses\n', '    mapping (address => bool) public verified;\n', '\n', '    event Verification(address indexed investor);\n', '    event LiquidationCall(address indexed investor, uint256 amountTokens);\n', '    event Liquidations(address indexed investor, uint256 amountTokens, uint256 etherAmount);\n', '    event Buy(address indexed investor, address indexed beneficiary, uint256 ethValue, uint256 amountTokens);\n', '    event PrivateSale(address indexed investor, uint256 amountTokens);\n', '    event PriceEDEXUpdate(uint256 topInteger, uint256 bottomInteger);\n', '    event AddLiquidity(uint256 etherAmount);\n', '    event RemoveLiquidity(uint256 etherAmount);\n', '    \n', '    // for price updates as a rational number\n', '    struct PriceEDEX{\n', '        uint256 topInteger;\n', '        uint256 bottomInteger;\n', '    }\n', '\n', '    struct Liquidation{\n', '        uint256 tokens;\n', '        uint256 time;\n', '    }\n', '\n', '    // grantVestedEDEXContract and mainWallet can transfer to allow team allocations\n', '    modifier isSetTrading{\n', '        require(setTrading || msg.sender == mainWallet || msg.sender == grantVestedEDEXContract);\n', '        _;\n', '    }\n', '\n', '    modifier onlyVerified{\n', '        require(verified[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyMainWallet{\n', '        require(msg.sender == mainWallet);\n', '        _;\n', '    }\n', '\n', '    modifier onlyControllingWallets{\n', '        require(msg.sender == secondaryWallet || msg.sender == mainWallet);\n', '        _;\n', '    }\n', '\n', '    modifier only_if_secondaryWallet{\n', '        if (msg.sender == secondaryWallet) _;\n', '    }\n', '    modifier require_waited{\n', '        require(safeSub(now, priceUpdateWaitingTime) >= previousUpdateTime);\n', '        _;\n', '    }\n', '    modifier only_if_increase (uint256 newTopInteger){\n', '        if (newTopInteger > currentPrice.topInteger) _;\n', '    }\n', '\n', '    function EDEX(address secondaryWalletInput, uint256 priceTopIntegerInput, uint256 startBlockInput, uint256 endBlockInput){\n', '        require(secondaryWalletInput != address(0));\n', '        require(endBlockInput > startBlockInput);\n', '        require(priceTopIntegerInput > 0);\n', '        mainWallet = msg.sender;\n', '        secondaryWallet = secondaryWalletInput;\n', '        verified[mainWallet] = true;\n', '        verified[secondaryWallet] = true;\n', '        // priceTopIntegerInput = 800,000 for 1 ETH = 800 EDEX\n', '        currentPrice = PriceEDEX(priceTopIntegerInput, 1000);\n', '        // icoStartBlock should be around block number 5,709,200 = June 1st 2018\n', '        icoStartBlock = startBlockInput;\n', '        // icoEndBlock = icoStartBlock + 345,600 blocks\n', '        icoEndBlock = endBlockInput;\n', '        previousUpdateTime = now;\n', '    }\n', '\n', '    function setGrantVestedEDEXContract(address grantVestedEDEXContractInput) external onlyMainWallet{\n', '        require(grantVestedEDEXContractInput != address(0));\n', '        grantVestedEDEXContract = grantVestedEDEXContractInput;\n', '        verified[grantVestedEDEXContract] = true;\n', '        grantVestedEDEXSet = true;\n', '    }\n', '\n', '    function updatePriceEDEX(uint256 newTopInteger) external onlyControllingWallets{\n', '        require(newTopInteger > 0);\n', '        require_limited_change(newTopInteger);\n', '        currentPrice.topInteger = newTopInteger;\n', '        // maps time to new PriceEDEX\n', '        prices[previousUpdateTime] = currentPrice;\n', '        previousUpdateTime = now;\n', '        PriceEDEXUpdate(newTopInteger, currentPrice.bottomInteger);\n', '    }\n', '\n', '    function require_limited_change (uint256 newTopInteger) private only_if_secondaryWallet require_waited only_if_increase(newTopInteger){\n', '        uint256 percentage_diff = 0;\n', '        percentage_diff = safeMul(newTopInteger, 100) / currentPrice.topInteger;\n', '        percentage_diff = safeSub(percentage_diff, 100);\n', '        // secondaryWallet can increase price by 20% maximum once every priceUpdateWaitingTime\n', '        require(percentage_diff <= 20);\n', '    }\n', '\n', '    function updatePriceBottomInteger(uint256 newBottomInteger) external onlyMainWallet{\n', '        require(block.number > icoEndBlock);\n', '        require(newBottomInteger > 0);\n', '        currentPrice.bottomInteger = newBottomInteger;\n', '        // maps time to new Price\n', '        prices[previousUpdateTime] = currentPrice;\n', '        previousUpdateTime = now;\n', '        PriceEDEXUpdate(currentPrice.topInteger, newBottomInteger);\n', '    }\n', '\n', '    function tokenAllocation(address investor, uint256 amountTokens) private{\n', '        require(grantVestedEDEXSet);\n', '        // the 15% allocated to the team\n', '        uint256 teamAllocation = safeMul(amountTokens, 1764705882352941) / 1e16;\n', '        uint256 newTokens = safeAdd(amountTokens, teamAllocation);\n', '        require(safeAdd(totalSupply, newTokens) <= maxSupply);\n', '        totalSupply = safeAdd(totalSupply, newTokens);\n', '        balances[investor] = safeAdd(balances[investor], amountTokens);\n', '        balances[grantVestedEDEXContract] = safeAdd(balances[grantVestedEDEXContract], teamAllocation);\n', '    }\n', '\n', '    function privateSaleTokens(address investor, uint amountTokens) external onlyMainWallet{\n', '        require(block.number < icoEndBlock);\n', '        require(investor != address(0));\n', '        verified[investor] = true;\n', '        tokenAllocation(investor, amountTokens);\n', '        Verification(investor);\n', '        PrivateSale(investor, amountTokens);\n', '    }\n', '\n', '    function verifyInvestor(address investor) external onlyControllingWallets{\n', '        verified[investor] = true;\n', '        Verification(investor);\n', '    }\n', '    \n', '    // blacklists bot addresses using ICO whitelisted addresses\n', '    function removeVerifiedInvestor(address investor) external onlyControllingWallets{\n', '        verified[investor] = false;\n', '        Verification(investor);\n', '    }\n', '\n', '    function buy() external payable{\n', '        buyTo(msg.sender);\n', '    }\n', '\n', '    function buyTo(address investor) public payable onlyVerified{\n', '        require(!haltICO);\n', '        require(investor != address(0));\n', '        require(msg.value >= minInvestment);\n', '        require(block.number >= icoStartBlock && block.number < icoEndBlock);\n', '        uint256 icoBottomInteger = icoBottomIntegerPrice();\n', '        uint256 tokensToBuy = safeMul(msg.value, currentPrice.topInteger) / icoBottomInteger;\n', '        tokenAllocation(investor, tokensToBuy);\n', '        // send ether to mainWallet\n', '        mainWallet.transfer(msg.value);\n', '        Buy(msg.sender, investor, msg.value, tokensToBuy);\n', '    }\n', '\n', '    // bonus scheme during ICO, 1 ETH = 800 EDEX for 1st 20 days, 1 ETH = 727 EDEX for 2nd 20 days, 1 ETH = 667 EDEX for 3rd 20 days\n', '    function icoBottomIntegerPrice() public constant returns (uint256){\n', '        uint256 icoDuration = safeSub(block.number, icoStartBlock);\n', '        uint256 bottomInteger;\n', '        // icoDuration < 115,200 blocks = 20 days\n', '        if (icoDuration < 115200){\n', '            return currentPrice.bottomInteger;\n', '        }\n', '        // icoDuration < 230,400 blocks = 40 days\n', '        else if (icoDuration < 230400 ){\n', '            bottomInteger = safeMul(currentPrice.bottomInteger, 110) / 100;\n', '            return bottomInteger;\n', '        }\n', '        else{\n', '            bottomInteger = safeMul(currentPrice.bottomInteger, 120) / 100;\n', '            return bottomInteger;\n', '        }\n', '    }\n', '\n', '    // change ICO starting date if more time needed for preparation\n', '    function changeIcoStartBlock(uint256 newIcoStartBlock) external onlyMainWallet{\n', '        require(block.number < icoStartBlock);\n', '        require(block.number < newIcoStartBlock);\n', '        icoStartBlock = newIcoStartBlock;\n', '    }\n', '\n', '    function changeIcoEndBlock(uint256 newIcoEndBlock) external onlyMainWallet{\n', '        require(block.number < icoEndBlock);\n', '        require(block.number < newIcoEndBlock);\n', '        icoEndBlock = newIcoEndBlock;\n', '    }\n', '\n', '    function changePriceUpdateWaitingTime(uint256 newPriceUpdateWaitingTime) external onlyMainWallet{\n', '        priceUpdateWaitingTime = newPriceUpdateWaitingTime;\n', '    }\n', '\n', '    function requestLiquidation(uint256 amountTokensToLiquidate) external isSetTrading onlyVerified{\n', '        require(block.number > icoEndBlock);\n', '        require(amountTokensToLiquidate > 0);\n', '        address investor = msg.sender;\n', '        require(balanceOf(investor) >= amountTokensToLiquidate);\n', '        require(liquidations[investor].tokens == 0);\n', '        balances[investor] = safeSub(balances[investor], amountTokensToLiquidate);\n', '        liquidations[investor] = Liquidation({tokens: amountTokensToLiquidate, time: previousUpdateTime});\n', '        LiquidationCall(investor, amountTokensToLiquidate);\n', '    }\n', '\n', '    function liquidate() external{\n', '        address investor = msg.sender;\n', '        uint256 tokens = liquidations[investor].tokens;\n', '        require(tokens > 0);\n', '        uint256 requestTime = liquidations[investor].time;\n', '        // obtain the next price that was set after the request\n', '        PriceEDEX storage price = prices[requestTime];\n', '        require(price.topInteger > 0);\n', '        uint256 liquidationValue = safeMul(tokens, price.bottomInteger) / price.topInteger;\n', '        // if there is enough ether on the contract, proceed. Otherwise, send back tokens\n', '        liquidations[investor].tokens = 0;\n', '        if (this.balance >= liquidationValue)\n', '            enact_liquidation_greater_equal(investor, liquidationValue, tokens);\n', '        else\n', '            enact_liquidation_less(investor, liquidationValue, tokens);\n', '    }\n', '\n', '    function enact_liquidation_greater_equal(address investor, uint256 liquidationValue, uint256 tokens) private{\n', '        assert(this.balance >= liquidationValue);\n', '        balances[mainWallet] = safeAdd(balances[mainWallet], tokens);\n', '        investor.transfer(liquidationValue);\n', '        Liquidations(investor, tokens, liquidationValue);\n', '    }\n', '    \n', '    function enact_liquidation_less(address investor, uint256 liquidationValue, uint256 tokens) private{\n', '        assert(this.balance < liquidationValue);\n', '        balances[investor] = safeAdd(balances[investor], tokens);\n', '        Liquidations(investor, tokens, 0);\n', '    }\n', '\n', '    function checkLiquidationValue(uint256 amountTokensToLiquidate) constant returns (uint256 etherValue){\n', '        require(amountTokensToLiquidate > 0);\n', '        require(balanceOf(msg.sender) >= amountTokensToLiquidate);\n', '        uint256 liquidationValue = safeMul(amountTokensToLiquidate, currentPrice.bottomInteger) / currentPrice.topInteger;\n', '        require(this.balance >= liquidationValue);\n', '        return liquidationValue;\n', '    }\n', '\n', '    // add liquidity to contract for investor liquidation\n', '    function addLiquidity() external onlyControllingWallets payable{\n', '        require(msg.value > 0);\n', '        AddLiquidity(msg.value);\n', '    }\n', '\n', '    // remove liquidity from contract\n', '    function removeLiquidity(uint256 amount) external onlyControllingWallets{\n', '        require(amount <= this.balance);\n', '        mainWallet.transfer(amount);\n', '        RemoveLiquidity(amount);\n', '    }\n', '\n', '    function changeMainWallet(address newMainWallet) external onlyMainWallet{\n', '        require(newMainWallet != address(0));\n', '        mainWallet = newMainWallet;\n', '    }\n', '\n', '    function changeSecondaryWallet(address newSecondaryWallet) external onlyMainWallet{\n', '        require(newSecondaryWallet != address(0));\n', '        secondaryWallet = newSecondaryWallet;\n', '    }\n', '\n', '    function enableTrading() external onlyMainWallet{\n', '        require(block.number > icoEndBlock);\n', '        setTrading = true;\n', '    }\n', '\n', '    function claimEDEX(address _token) external onlyMainWallet{\n', '        require(_token != address(0));\n', '        Token token = Token(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(mainWallet, balance);\n', '     }\n', '\n', '    // disable transfers and allow them once token is tradeable\n', '    function transfer(address _to, uint256 _value) isSetTrading returns (bool success){\n', '        return super.transfer(_to, _value);\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) isSetTrading returns (bool success){\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function haltICO() external onlyMainWallet{\n', '        haltICO = true;\n', '    }\n', '    \n', '    function unhaltICO() external onlyMainWallet{\n', '        haltICO = false;\n', '    }\n', '    \n', '    // fallback function\n', '    function() payable{\n', '        require(tx.origin == msg.sender);\n', '        buyTo(msg.sender);\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract SafeMath{\n', '\n', '  // math operations with safety checks that throw on error\n', '  // small gas improvement\n', '\n', '  function safeMul(uint256 a, uint256 b) internal returns (uint256){\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  \n', '  function safeDiv(uint256 a, uint256 b) internal returns (uint256){\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '  \n', '  function safeSub(uint256 a, uint256 b) internal returns (uint256){\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  \n', '  function safeAdd(uint256 a, uint256 b) internal returns (uint256){\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  // mitigate short address attack\n', '  // https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34\n', '  modifier onlyPayloadSize(uint numWords){\n', '     assert(msg.data.length >= numWords * 32 + 4);\n', '     _;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Token{ // ERC20 standard\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '}\n', '\n', '\n', 'contract StandardToken is Token, SafeMath{\n', '\n', '    uint256 public totalSupply;\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool success){\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value && _value > 0);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success){\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance){\n', '        return balances[_owner];\n', '    }\n', '    \n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success){\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) returns (bool success){\n', '        require(allowed[msg.sender][_spender] == _oldValue);\n', '        allowed[msg.sender][_spender] = _newValue;\n', '        Approval(msg.sender, _spender, _newValue);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining){\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    // this creates an array with all balances\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '}\n', '\n', '\n', 'contract EDEX is StandardToken{\n', '\n', '    // public variables of the token\n', '\n', '    string public name = "Equadex";\n', '    string public symbol = "EDEX";\n', '    uint256 public decimals = 18;\n', '    \n', '    // reachable if max amount raised\n', '    uint256 public maxSupply = 100000000e18;\n', '    \n', '    // ICO starting and ending blocks, can be changed as needed\n', '    uint256 public icoStartBlock;\n', '    // icoEndBlock = icoStartBlock + 345,600 blocks for 2 months ICO\n', '    uint256 public icoEndBlock;\n', '\n', '    // set the wallets with different levels of authority\n', '    address public mainWallet;\n', '    address public secondaryWallet;\n', '    \n', '    // time to wait between secondaryWallet price updates, mainWallet can update without restrictions\n', '    uint256 public priceUpdateWaitingTime = 1 hours;\n', '\n', '    uint256 public previousUpdateTime = 0;\n', '    \n', '    // strucure of price\n', '    PriceEDEX public currentPrice;\n', '    uint256 public minInvestment = 0.01 ether;\n', '    \n', '    // for tokens allocated to the team\n', '    address public grantVestedEDEXContract;\n', '    bool private grantVestedEDEXSet = false;\n', '    \n', '    // halt the crowdsale should any suspicious behavior of a third-party be identified\n', '    // tokens will be locked for trading until they are listed on exchanges\n', '    bool public haltICO = false;\n', '    bool public setTrading = false;\n', '\n', '    // maps investor address to a liquidation request\n', '    mapping (address => Liquidation) public liquidations;\n', '    // maps previousUpdateTime to the next price\n', '    mapping (uint256 => PriceEDEX) public prices;\n', '    // maps verified addresses\n', '    mapping (address => bool) public verified;\n', '\n', '    event Verification(address indexed investor);\n', '    event LiquidationCall(address indexed investor, uint256 amountTokens);\n', '    event Liquidations(address indexed investor, uint256 amountTokens, uint256 etherAmount);\n', '    event Buy(address indexed investor, address indexed beneficiary, uint256 ethValue, uint256 amountTokens);\n', '    event PrivateSale(address indexed investor, uint256 amountTokens);\n', '    event PriceEDEXUpdate(uint256 topInteger, uint256 bottomInteger);\n', '    event AddLiquidity(uint256 etherAmount);\n', '    event RemoveLiquidity(uint256 etherAmount);\n', '    \n', '    // for price updates as a rational number\n', '    struct PriceEDEX{\n', '        uint256 topInteger;\n', '        uint256 bottomInteger;\n', '    }\n', '\n', '    struct Liquidation{\n', '        uint256 tokens;\n', '        uint256 time;\n', '    }\n', '\n', '    // grantVestedEDEXContract and mainWallet can transfer to allow team allocations\n', '    modifier isSetTrading{\n', '        require(setTrading || msg.sender == mainWallet || msg.sender == grantVestedEDEXContract);\n', '        _;\n', '    }\n', '\n', '    modifier onlyVerified{\n', '        require(verified[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyMainWallet{\n', '        require(msg.sender == mainWallet);\n', '        _;\n', '    }\n', '\n', '    modifier onlyControllingWallets{\n', '        require(msg.sender == secondaryWallet || msg.sender == mainWallet);\n', '        _;\n', '    }\n', '\n', '    modifier only_if_secondaryWallet{\n', '        if (msg.sender == secondaryWallet) _;\n', '    }\n', '    modifier require_waited{\n', '        require(safeSub(now, priceUpdateWaitingTime) >= previousUpdateTime);\n', '        _;\n', '    }\n', '    modifier only_if_increase (uint256 newTopInteger){\n', '        if (newTopInteger > currentPrice.topInteger) _;\n', '    }\n', '\n', '    function EDEX(address secondaryWalletInput, uint256 priceTopIntegerInput, uint256 startBlockInput, uint256 endBlockInput){\n', '        require(secondaryWalletInput != address(0));\n', '        require(endBlockInput > startBlockInput);\n', '        require(priceTopIntegerInput > 0);\n', '        mainWallet = msg.sender;\n', '        secondaryWallet = secondaryWalletInput;\n', '        verified[mainWallet] = true;\n', '        verified[secondaryWallet] = true;\n', '        // priceTopIntegerInput = 800,000 for 1 ETH = 800 EDEX\n', '        currentPrice = PriceEDEX(priceTopIntegerInput, 1000);\n', '        // icoStartBlock should be around block number 5,709,200 = June 1st 2018\n', '        icoStartBlock = startBlockInput;\n', '        // icoEndBlock = icoStartBlock + 345,600 blocks\n', '        icoEndBlock = endBlockInput;\n', '        previousUpdateTime = now;\n', '    }\n', '\n', '    function setGrantVestedEDEXContract(address grantVestedEDEXContractInput) external onlyMainWallet{\n', '        require(grantVestedEDEXContractInput != address(0));\n', '        grantVestedEDEXContract = grantVestedEDEXContractInput;\n', '        verified[grantVestedEDEXContract] = true;\n', '        grantVestedEDEXSet = true;\n', '    }\n', '\n', '    function updatePriceEDEX(uint256 newTopInteger) external onlyControllingWallets{\n', '        require(newTopInteger > 0);\n', '        require_limited_change(newTopInteger);\n', '        currentPrice.topInteger = newTopInteger;\n', '        // maps time to new PriceEDEX\n', '        prices[previousUpdateTime] = currentPrice;\n', '        previousUpdateTime = now;\n', '        PriceEDEXUpdate(newTopInteger, currentPrice.bottomInteger);\n', '    }\n', '\n', '    function require_limited_change (uint256 newTopInteger) private only_if_secondaryWallet require_waited only_if_increase(newTopInteger){\n', '        uint256 percentage_diff = 0;\n', '        percentage_diff = safeMul(newTopInteger, 100) / currentPrice.topInteger;\n', '        percentage_diff = safeSub(percentage_diff, 100);\n', '        // secondaryWallet can increase price by 20% maximum once every priceUpdateWaitingTime\n', '        require(percentage_diff <= 20);\n', '    }\n', '\n', '    function updatePriceBottomInteger(uint256 newBottomInteger) external onlyMainWallet{\n', '        require(block.number > icoEndBlock);\n', '        require(newBottomInteger > 0);\n', '        currentPrice.bottomInteger = newBottomInteger;\n', '        // maps time to new Price\n', '        prices[previousUpdateTime] = currentPrice;\n', '        previousUpdateTime = now;\n', '        PriceEDEXUpdate(currentPrice.topInteger, newBottomInteger);\n', '    }\n', '\n', '    function tokenAllocation(address investor, uint256 amountTokens) private{\n', '        require(grantVestedEDEXSet);\n', '        // the 15% allocated to the team\n', '        uint256 teamAllocation = safeMul(amountTokens, 1764705882352941) / 1e16;\n', '        uint256 newTokens = safeAdd(amountTokens, teamAllocation);\n', '        require(safeAdd(totalSupply, newTokens) <= maxSupply);\n', '        totalSupply = safeAdd(totalSupply, newTokens);\n', '        balances[investor] = safeAdd(balances[investor], amountTokens);\n', '        balances[grantVestedEDEXContract] = safeAdd(balances[grantVestedEDEXContract], teamAllocation);\n', '    }\n', '\n', '    function privateSaleTokens(address investor, uint amountTokens) external onlyMainWallet{\n', '        require(block.number < icoEndBlock);\n', '        require(investor != address(0));\n', '        verified[investor] = true;\n', '        tokenAllocation(investor, amountTokens);\n', '        Verification(investor);\n', '        PrivateSale(investor, amountTokens);\n', '    }\n', '\n', '    function verifyInvestor(address investor) external onlyControllingWallets{\n', '        verified[investor] = true;\n', '        Verification(investor);\n', '    }\n', '    \n', '    // blacklists bot addresses using ICO whitelisted addresses\n', '    function removeVerifiedInvestor(address investor) external onlyControllingWallets{\n', '        verified[investor] = false;\n', '        Verification(investor);\n', '    }\n', '\n', '    function buy() external payable{\n', '        buyTo(msg.sender);\n', '    }\n', '\n', '    function buyTo(address investor) public payable onlyVerified{\n', '        require(!haltICO);\n', '        require(investor != address(0));\n', '        require(msg.value >= minInvestment);\n', '        require(block.number >= icoStartBlock && block.number < icoEndBlock);\n', '        uint256 icoBottomInteger = icoBottomIntegerPrice();\n', '        uint256 tokensToBuy = safeMul(msg.value, currentPrice.topInteger) / icoBottomInteger;\n', '        tokenAllocation(investor, tokensToBuy);\n', '        // send ether to mainWallet\n', '        mainWallet.transfer(msg.value);\n', '        Buy(msg.sender, investor, msg.value, tokensToBuy);\n', '    }\n', '\n', '    // bonus scheme during ICO, 1 ETH = 800 EDEX for 1st 20 days, 1 ETH = 727 EDEX for 2nd 20 days, 1 ETH = 667 EDEX for 3rd 20 days\n', '    function icoBottomIntegerPrice() public constant returns (uint256){\n', '        uint256 icoDuration = safeSub(block.number, icoStartBlock);\n', '        uint256 bottomInteger;\n', '        // icoDuration < 115,200 blocks = 20 days\n', '        if (icoDuration < 115200){\n', '            return currentPrice.bottomInteger;\n', '        }\n', '        // icoDuration < 230,400 blocks = 40 days\n', '        else if (icoDuration < 230400 ){\n', '            bottomInteger = safeMul(currentPrice.bottomInteger, 110) / 100;\n', '            return bottomInteger;\n', '        }\n', '        else{\n', '            bottomInteger = safeMul(currentPrice.bottomInteger, 120) / 100;\n', '            return bottomInteger;\n', '        }\n', '    }\n', '\n', '    // change ICO starting date if more time needed for preparation\n', '    function changeIcoStartBlock(uint256 newIcoStartBlock) external onlyMainWallet{\n', '        require(block.number < icoStartBlock);\n', '        require(block.number < newIcoStartBlock);\n', '        icoStartBlock = newIcoStartBlock;\n', '    }\n', '\n', '    function changeIcoEndBlock(uint256 newIcoEndBlock) external onlyMainWallet{\n', '        require(block.number < icoEndBlock);\n', '        require(block.number < newIcoEndBlock);\n', '        icoEndBlock = newIcoEndBlock;\n', '    }\n', '\n', '    function changePriceUpdateWaitingTime(uint256 newPriceUpdateWaitingTime) external onlyMainWallet{\n', '        priceUpdateWaitingTime = newPriceUpdateWaitingTime;\n', '    }\n', '\n', '    function requestLiquidation(uint256 amountTokensToLiquidate) external isSetTrading onlyVerified{\n', '        require(block.number > icoEndBlock);\n', '        require(amountTokensToLiquidate > 0);\n', '        address investor = msg.sender;\n', '        require(balanceOf(investor) >= amountTokensToLiquidate);\n', '        require(liquidations[investor].tokens == 0);\n', '        balances[investor] = safeSub(balances[investor], amountTokensToLiquidate);\n', '        liquidations[investor] = Liquidation({tokens: amountTokensToLiquidate, time: previousUpdateTime});\n', '        LiquidationCall(investor, amountTokensToLiquidate);\n', '    }\n', '\n', '    function liquidate() external{\n', '        address investor = msg.sender;\n', '        uint256 tokens = liquidations[investor].tokens;\n', '        require(tokens > 0);\n', '        uint256 requestTime = liquidations[investor].time;\n', '        // obtain the next price that was set after the request\n', '        PriceEDEX storage price = prices[requestTime];\n', '        require(price.topInteger > 0);\n', '        uint256 liquidationValue = safeMul(tokens, price.bottomInteger) / price.topInteger;\n', '        // if there is enough ether on the contract, proceed. Otherwise, send back tokens\n', '        liquidations[investor].tokens = 0;\n', '        if (this.balance >= liquidationValue)\n', '            enact_liquidation_greater_equal(investor, liquidationValue, tokens);\n', '        else\n', '            enact_liquidation_less(investor, liquidationValue, tokens);\n', '    }\n', '\n', '    function enact_liquidation_greater_equal(address investor, uint256 liquidationValue, uint256 tokens) private{\n', '        assert(this.balance >= liquidationValue);\n', '        balances[mainWallet] = safeAdd(balances[mainWallet], tokens);\n', '        investor.transfer(liquidationValue);\n', '        Liquidations(investor, tokens, liquidationValue);\n', '    }\n', '    \n', '    function enact_liquidation_less(address investor, uint256 liquidationValue, uint256 tokens) private{\n', '        assert(this.balance < liquidationValue);\n', '        balances[investor] = safeAdd(balances[investor], tokens);\n', '        Liquidations(investor, tokens, 0);\n', '    }\n', '\n', '    function checkLiquidationValue(uint256 amountTokensToLiquidate) constant returns (uint256 etherValue){\n', '        require(amountTokensToLiquidate > 0);\n', '        require(balanceOf(msg.sender) >= amountTokensToLiquidate);\n', '        uint256 liquidationValue = safeMul(amountTokensToLiquidate, currentPrice.bottomInteger) / currentPrice.topInteger;\n', '        require(this.balance >= liquidationValue);\n', '        return liquidationValue;\n', '    }\n', '\n', '    // add liquidity to contract for investor liquidation\n', '    function addLiquidity() external onlyControllingWallets payable{\n', '        require(msg.value > 0);\n', '        AddLiquidity(msg.value);\n', '    }\n', '\n', '    // remove liquidity from contract\n', '    function removeLiquidity(uint256 amount) external onlyControllingWallets{\n', '        require(amount <= this.balance);\n', '        mainWallet.transfer(amount);\n', '        RemoveLiquidity(amount);\n', '    }\n', '\n', '    function changeMainWallet(address newMainWallet) external onlyMainWallet{\n', '        require(newMainWallet != address(0));\n', '        mainWallet = newMainWallet;\n', '    }\n', '\n', '    function changeSecondaryWallet(address newSecondaryWallet) external onlyMainWallet{\n', '        require(newSecondaryWallet != address(0));\n', '        secondaryWallet = newSecondaryWallet;\n', '    }\n', '\n', '    function enableTrading() external onlyMainWallet{\n', '        require(block.number > icoEndBlock);\n', '        setTrading = true;\n', '    }\n', '\n', '    function claimEDEX(address _token) external onlyMainWallet{\n', '        require(_token != address(0));\n', '        Token token = Token(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(mainWallet, balance);\n', '     }\n', '\n', '    // disable transfers and allow them once token is tradeable\n', '    function transfer(address _to, uint256 _value) isSetTrading returns (bool success){\n', '        return super.transfer(_to, _value);\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) isSetTrading returns (bool success){\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function haltICO() external onlyMainWallet{\n', '        haltICO = true;\n', '    }\n', '    \n', '    function unhaltICO() external onlyMainWallet{\n', '        haltICO = false;\n', '    }\n', '    \n', '    // fallback function\n', '    function() payable{\n', '        require(tx.origin == msg.sender);\n', '        buyTo(msg.sender);\n', '    }\n', '}']
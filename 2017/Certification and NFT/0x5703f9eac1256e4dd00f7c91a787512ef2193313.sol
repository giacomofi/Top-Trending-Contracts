['pragma solidity ^0.4.17;\n', '\n', '// ----------------------------------------------------------------------------\n', '// GAT Ownership Contract\n', '//\n', '// Copyright (c) 2017 GAT Systems Ltd.\n', '// http://www.gatcoin.io/\n', '//\n', '// The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// Implementation of a simple ownership model with transfer acceptance.\n', '//\n', 'contract Owned {\n', '\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerChanged(address indexed _newOwner);\n', '\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner returns (bool) {\n', '        require(_newOwner != address(0));\n', '        require(_newOwner != owner);\n', '\n', '        newOwner = _newOwner;\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function acceptOwnership() public returns (bool) {\n', '        require(msg.sender == newOwner);\n', '\n', '        owner = msg.sender;\n', '\n', '        OwnerChanged(msg.sender);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', 'pragma solidity ^0.4.17;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', 'pragma solidity ^0.4.17;\n', '\n', '// ----------------------------------------------------------------------------\n', '// GAT Token ERC20 Interface\n', '//\n', '// Copyright (c) 2017 GAT Systems Ltd.\n', '// http://www.gatcoin.io/\n', '//\n', '// The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Standard Interface as specified at:\n', '// https://github.com/ethereum/EIPs/issues/20\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ERC20Interface {\n', '\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '}\n', '\n', '\n', 'pragma solidity ^0.4.17;\n', '\n', '// ----------------------------------------------------------------------------\n', '// GAT Token Implementation\n', '//\n', '// Copyright (c) 2017 GAT Systems Ltd.\n', '// http://www.gatcoin.io/\n', '//\n', '// The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '\n', '// Implementation of standard ERC20 token with ownership.\n', '//\n', 'contract GATToken is ERC20Interface, Owned {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string public symbol;\n', '    string public name;\n', '    uint256 public decimals;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '\n', '    function GATToken(string _symbol, string _name, uint256 _decimals, uint256 _totalSupply) public\n', '        Owned()\n', '    {\n', '        symbol      = _symbol;\n', '        name        = _name;\n', '        decimals    = _decimals;\n', '        totalSupply = _totalSupply;\n', '\n', '        Transfer(0x0, owner, _totalSupply);\n', '    }\n', '\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '     }\n', '\n', '\n', '     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '     }\n', '\n', '\n', '     function approve(address _spender, uint256 _value) public returns (bool success) {\n', '         allowed[msg.sender][_spender] = _value;\n', '\n', '         Approval(msg.sender, _spender, _value);\n', '\n', '         return true;\n', '     }\n', '}\n', '\n', '\n', 'pragma solidity ^0.4.17;\n', '\n', '// ----------------------------------------------------------------------------\n', '// GAT Token Sale Configuration\n', '//\n', '// Copyright (c) 2017 GAT Systems Ltd.\n', '// http://www.gatcoin.io/\n', '//\n', '// The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', 'contract GATTokenSaleConfig {\n', '\n', '    string  public constant SYMBOL                  = "GAT";\n', '    string  public constant NAME                    = "GAT Token";\n', '    uint256 public constant DECIMALS                = 18;\n', '\n', '    uint256 public constant DECIMALSFACTOR          = 10**uint256(DECIMALS);\n', '    uint256 public constant START_TIME              = 1509192000; // 28-Oct-2017, 12:00:00 UTC\n', '    uint256 public constant END_TIME                = 1511870399; // 28-Nov-2017, 11:59:59 UTC\n', '    uint256 public constant CONTRIBUTION_MIN        = 0.1 ether;\n', '    uint256 public constant TOKEN_TOTAL_CAP         = 1000000000  * DECIMALSFACTOR;\n', '    uint256 public constant TOKEN_PRIVATE_SALE_CAP  =   70000000  * DECIMALSFACTOR;\n', '    uint256 public constant TOKEN_PRESALE_CAP       =   15000000  * DECIMALSFACTOR;\n', '    uint256 public constant TOKEN_PUBLIC_SALE_CAP   =  130000000  * DECIMALSFACTOR; // This also includes presale\n', '    uint256 public constant TOKEN_FOUNDATION_CAP    =  100000000  * DECIMALSFACTOR;\n', '    uint256 public constant TOKEN_RESERVE1_CAP      =   50000000  * DECIMALSFACTOR;\n', '    uint256 public constant TOKEN_RESERVE2_CAP      =   50000000  * DECIMALSFACTOR;\n', '    uint256 public constant TOKEN_FUTURE_CAP        =  600000000  * DECIMALSFACTOR;\n', '\n', '    // Default bonus amount for the presale.\n', '    // 100 = no bonus\n', '    // 120 = 20% bonus.\n', '    // Note that the owner can change the amount of bonus given.\n', '    uint256 public constant PRESALE_BONUS      = 120;\n', '\n', '    // Default value for tokensPerKEther based on ETH at 300 USD.\n', '    // The owner can update this value before the sale starts based on the\n', '    // price of ether at that time.\n', '    // E.g. 300 USD/ETH -> 300,000 USD/KETH / 0.2 USD/TOKEN = 1,500,000\n', '    uint256 public constant TOKENS_PER_KETHER = 1500000;\n', '}\n', '\n', '\n', 'pragma solidity ^0.4.17;\n', '\n', '// ----------------------------------------------------------------------------\n', '// GAT Token Sample Implementation\n', '//\n', '// Copyright (c) 2017 GAT Systems Ltd.\n', '// http://www.gatcoin.io/\n', '//\n', '// The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '\n', '\n', '// This is the main contract that drives the GAT token sale.\n', '// It exposes the ERC20 interface along with various sale-related functions.\n', '//\n', 'contract GATTokenSale is GATToken, GATTokenSaleConfig {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // Once finalized, tokens will be freely tradable\n', '    bool public finalized;\n', '\n', '    // Sale can be suspended or resumed by the owner\n', '    bool public suspended;\n', '\n', '    // Addresses for the bank, funding and reserves.\n', '    address public bankAddress;\n', '    address public fundingAddress;\n', '    address public reserve1Address;\n', '    address public reserve2Address;\n', '\n', '    // Price of tokens per 1000 ETH\n', '    uint256 public tokensPerKEther;\n', '\n', '    // The bonus amount on token purchases\n', '    // E.g. 120 means a 20% bonus will be applied.\n', '    uint256 public bonus;\n', '\n', '    // Total number of tokens that have been sold through the sale contract so far.\n', '    uint256 public totalTokensSold;\n', '\n', '    // Keep track of start time and end time for the sale. These have default\n', '    // values when the contract is deployed but can be changed by owner as needed.\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '\n', '    // Events\n', '    event TokensPurchased(address indexed beneficiary, uint256 cost, uint256 tokens);\n', '    event TokensPerKEtherUpdated(uint256 newAmount);\n', '    event BonusAmountUpdated(uint256 newAmount);\n', '    event TimeWindowUpdated(uint256 newStartTime, uint256 newEndTime);\n', '    event SaleSuspended();\n', '    event SaleResumed();\n', '    event TokenFinalized();\n', '    event ContractTokensReclaimed(uint256 amount);\n', '\n', '\n', '    function GATTokenSale(address _bankAddress, address _fundingAddress, address _reserve1Address, address _reserve2Address) public\n', '        GATToken(SYMBOL, NAME, DECIMALS, 0)\n', '    {\n', '        // Can only create the contract is the sale has not yet started or ended.\n', '        require(START_TIME >= currentTime());\n', '        require(END_TIME > START_TIME);\n', '\n', '        // Need valid wallet addresses\n', '        require(_bankAddress    != address(0x0));\n', '        require(_bankAddress    != address(this));\n', '        require(_fundingAddress != address(0x0));\n', '        require(_fundingAddress != address(this));\n', '        require(_reserve1Address != address(0x0));\n', '        require(_reserve1Address != address(this));\n', '        require(_reserve2Address != address(0x0));\n', '        require(_reserve2Address != address(this));\n', '\n', '        uint256 salesTotal = TOKEN_PUBLIC_SALE_CAP.add(TOKEN_PRIVATE_SALE_CAP);\n', '        require(salesTotal.add(TOKEN_FUTURE_CAP).add(TOKEN_FOUNDATION_CAP).add(TOKEN_RESERVE1_CAP).add(TOKEN_RESERVE2_CAP) == TOKEN_TOTAL_CAP);\n', '\n', '        // Start in non-finalized state\n', '        finalized = false;\n', '        suspended = false;\n', '\n', '        // Start and end times (used for presale).\n', '        startTime = START_TIME;\n', '        endTime   = END_TIME;\n', '\n', '        // Initial pricing\n', '        tokensPerKEther = TOKENS_PER_KETHER;\n', '\n', '        // Bonus for contributions\n', '        bonus = PRESALE_BONUS;\n', '\n', '        // Initialize wallet addresses\n', '        bankAddress    = _bankAddress;\n', '        fundingAddress = _fundingAddress;\n', '        reserve1Address = _reserve1Address;\n', '        reserve2Address = _reserve2Address;\n', '\n', '        // Assign initial balances\n', '        balances[address(this)] = balances[address(this)].add(TOKEN_PRESALE_CAP);\n', '        totalSupply = totalSupply.add(TOKEN_PRESALE_CAP);\n', '        Transfer(0x0, address(this), TOKEN_PRESALE_CAP);\n', '\n', '        balances[reserve1Address] = balances[reserve1Address].add(TOKEN_RESERVE1_CAP);\n', '        totalSupply = totalSupply.add(TOKEN_RESERVE1_CAP);\n', '        Transfer(0x0, reserve1Address, TOKEN_RESERVE1_CAP);\n', '\n', '        balances[reserve2Address] = balances[reserve2Address].add(TOKEN_RESERVE2_CAP);\n', '        totalSupply = totalSupply.add(TOKEN_RESERVE2_CAP);\n', '        Transfer(0x0, reserve2Address, TOKEN_RESERVE2_CAP);\n', '\n', '        uint256 bankBalance = TOKEN_TOTAL_CAP.sub(totalSupply);\n', '        balances[bankAddress] = balances[bankAddress].add(bankBalance);\n', '        totalSupply = totalSupply.add(bankBalance);\n', '        Transfer(0x0, bankAddress, bankBalance);\n', '\n', '        // The total supply that we calculated here should be the same as in the config.\n', '        require(balanceOf(address(this))  == TOKEN_PRESALE_CAP);\n', '        require(balanceOf(reserve1Address) == TOKEN_RESERVE1_CAP);\n', '        require(balanceOf(reserve2Address) == TOKEN_RESERVE2_CAP);\n', '        require(balanceOf(bankAddress)    == bankBalance);\n', '        require(totalSupply == TOKEN_TOTAL_CAP);\n', '    }\n', '\n', '\n', '    function currentTime() public constant returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '\n', '    // Allows the owner to change the price for tokens.\n', '    //\n', '    function setTokensPerKEther(uint256 _tokensPerKEther) external onlyOwner returns(bool) {\n', '        require(_tokensPerKEther > 0);\n', '\n', '        // Set the tokensPerKEther amount for any new sale.\n', '        tokensPerKEther = _tokensPerKEther;\n', '\n', '        TokensPerKEtherUpdated(_tokensPerKEther);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    // Allows the owner to change the bonus amount applied to purchases.\n', '    //\n', '    function setBonus(uint256 _bonus) external onlyOwner returns(bool) {\n', '        // 100 means no bonus\n', '        require(_bonus >= 100);\n', '\n', '        // 200 means 100% bonus\n', '        require(_bonus <= 200);\n', '\n', '        bonus = _bonus;\n', '\n', '        BonusAmountUpdated(_bonus);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    // Allows the owner to change the time window for the sale.\n', '    //\n', '    function setTimeWindow(uint256 _startTime, uint256 _endTime) external onlyOwner returns(bool) {\n', '        require(_startTime >= START_TIME);\n', '        require(_endTime > _startTime);\n', '\n', '        startTime = _startTime;\n', '        endTime   = _endTime;\n', '\n', '        TimeWindowUpdated(_startTime, _endTime);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    // Allows the owner to suspend / stop the sale.\n', '    //\n', '    function suspend() external onlyOwner returns(bool) {\n', '        if (suspended == true) {\n', '            return false;\n', '        }\n', '\n', '        suspended = true;\n', '\n', '        SaleSuspended();\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    // Allows the owner to resume the sale.\n', '    //\n', '    function resume() external onlyOwner returns(bool) {\n', '        if (suspended == false) {\n', '            return false;\n', '        }\n', '\n', '        suspended = false;\n', '\n', '        SaleResumed();\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    // Accept ether contributions during the token sale.\n', '    //\n', '    function () payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '\n', '    // Allows the caller to buy tokens for another recipient (proxy purchase).\n', '    // This can be used by exchanges for example.\n', '    //\n', '    function buyTokens(address beneficiary) public payable returns (uint256) {\n', '        require(!suspended);\n', '        require(beneficiary != address(0x0));\n', '        require(beneficiary != address(this));\n', '        require(currentTime() >= startTime);\n', '        require(currentTime() <= endTime);\n', '        require(msg.value >= CONTRIBUTION_MIN);\n', '        require(msg.sender != fundingAddress);\n', '\n', '        // Check if the sale contract still has tokens for sale.\n', '        uint256 saleBalance = balanceOf(address(this));\n', '        require(saleBalance > 0);\n', '\n', '        // Calculate the number of tokens that the ether should convert to.\n', '        uint256 tokens = msg.value.mul(tokensPerKEther).mul(bonus).div(10**(18 - DECIMALS + 3 + 2));\n', '        require(tokens > 0);\n', '\n', '        uint256 cost = msg.value;\n', '        uint256 refund = 0;\n', '\n', '        if (tokens > saleBalance) {\n', '            // Not enough tokens left for sale to fulfill the full order.\n', '            tokens = saleBalance;\n', '\n', '            // Calculate the actual cost for the tokens that can be purchased.\n', '            cost = tokens.mul(10**(18 - DECIMALS + 3 + 2)).div(tokensPerKEther.mul(bonus));\n', '\n', '            // Calculate the amount of ETH refund to the contributor.\n', '            refund = msg.value.sub(cost);\n', '        }\n', '\n', '        totalTokensSold = totalTokensSold.add(tokens);\n', '\n', '        // Move tokens from the sale contract to the beneficiary\n', '        balances[address(this)] = balances[address(this)].sub(tokens);\n', '        balances[beneficiary]   = balances[beneficiary].add(tokens);\n', '        Transfer(address(this), beneficiary, tokens);\n', '\n', '        if (refund > 0) {\n', '           msg.sender.transfer(refund);\n', '        }\n', '\n', '        // Transfer the contributed ether to the crowdsale wallets.\n', '        uint256 contribution      = msg.value.sub(refund);\n', '        uint256 reserveAllocation = contribution.div(20);\n', '\n', '        fundingAddress.transfer(contribution.sub(reserveAllocation));\n', '        reserve1Address.transfer(reserveAllocation);\n', '\n', '        TokensPurchased(beneficiary, cost, tokens);\n', '\n', '        return tokens;\n', '    }\n', '\n', '\n', '    // ERC20 transfer function, modified to only allow transfers once the sale has been finalized.\n', '    //\n', '    function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '        if (!isTransferAllowed(msg.sender, _to)) {\n', '            return false;\n', '        }\n', '\n', '        return super.transfer(_to, _amount);\n', '    }\n', '\n', '\n', '    // ERC20 transferFrom function, modified to only allow transfers once the sale has been finalized.\n', '    //\n', '    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '        if (!isTransferAllowed(_from, _to)) {\n', '            return false;\n', '        }\n', '\n', '        return super.transferFrom(_from, _to, _amount);\n', '    }\n', '\n', '\n', '    // Internal helper to check if the transfer should be allowed\n', '    //\n', '    function isTransferAllowed(address _from, address _to) private view returns (bool) {\n', '        if (finalized) {\n', '            // We allow everybody to transfer tokens once the sale is finalized.\n', '            return true;\n', '        }\n', '\n', '        if (_from == bankAddress || _to == bankAddress) {\n', '            // We allow the bank to initiate transfers. We also allow it to be the recipient\n', '            // of transfers before the token is finalized in case a recipient wants to send\n', '            // back tokens. E.g. KYC requirements cannot be met.\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '\n', '    // Allows owner to transfer tokens assigned to the sale contract, back to the bank wallet.\n', '    function reclaimContractTokens() external onlyOwner returns (bool) {\n', '        uint256 tokens = balanceOf(address(this));\n', '\n', '        if (tokens == 0) {\n', '            return false;\n', '        }\n', '\n', '        balances[address(this)] = balances[address(this)].sub(tokens);\n', '        balances[bankAddress]   = balances[bankAddress].add(tokens);\n', '        Transfer(address(this), bankAddress, tokens);\n', '\n', '        ContractTokensReclaimed(tokens);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    // Allows the owner to finalize the sale and allow tokens to be traded.\n', '    //\n', '    function finalize() external onlyOwner returns (bool) {\n', '        require(!finalized);\n', '\n', '        finalized = true;\n', '\n', '        TokenFinalized();\n', '\n', '        return true;\n', '    }\n', '}']
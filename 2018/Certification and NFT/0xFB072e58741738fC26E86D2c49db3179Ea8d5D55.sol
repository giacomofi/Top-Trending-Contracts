['pragma solidity 0.4.18;\n', '\n', 'contract FHFTokenInterface {\n', '    /* Public parameters of the token */\n', '    string public standard = &#39;Token 0.1&#39;;\n', '    string public name = &#39;Forever Has Fallen&#39;;\n', '    string public symbol = &#39;FC&#39;;\n', '    uint8 public decimals = 18;\n', '\n', '    function approveCrowdsale(address _crowdsaleAddress) external;\n', '    function balanceOf(address _address) public constant returns (uint256 balance);\n', '    function vestedBalanceOf(address _address) public constant returns (uint256 balance);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _currentValue, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract CrowdsaleParameters {\n', '    ///////////////////////////////////////////////////////////////////////////\n', '    // Configuration Independent Parameters\n', '    ///////////////////////////////////////////////////////////////////////////\n', '\n', '    struct AddressTokenAllocation {\n', '        address addr;\n', '        uint256 amount;\n', '    }\n', '\n', '    uint256 public maximumICOCap = 350e6;\n', '\n', '    // ICO period timestamps:\n', '    // 1525777200 = May 8, 2018. 11am GMT\n', '    // 1529406000 = June 19, 2018. 11am GMT\n', '    uint256 public generalSaleStartDate = 1525777200;\n', '    uint256 public generalSaleEndDate = 1529406000;\n', '\n', '    // Vesting\n', '    // 1592564400 = June 19, 2020. 11am GMT\n', '    uint32 internal vestingTeam = 1592564400;\n', '    // 1529406000 = Bounty to ico end date - June 19, 2018. 11am GMT\n', '    uint32 internal vestingBounty = 1529406000;\n', '\n', '    ///////////////////////////////////////////////////////////////////////////\n', '    // Production Config\n', '    ///////////////////////////////////////////////////////////////////////////\n', '\n', '\n', '    ///////////////////////////////////////////////////////////////////////////\n', '    // QA Config\n', '    ///////////////////////////////////////////////////////////////////////////\n', '\n', '    AddressTokenAllocation internal generalSaleWallet = AddressTokenAllocation(0x265Fb686cdd2f9a853c519592078cC4d1718C15a, 350e6);\n', '    AddressTokenAllocation internal communityReserve =  AddressTokenAllocation(0x76d472C73681E3DF8a7fB3ca79E5f8915f9C5bA5, 450e6);\n', '    AddressTokenAllocation internal team =              AddressTokenAllocation(0x05d46150ceDF59ED60a86d5623baf522E0EB46a2, 170e6);\n', '    AddressTokenAllocation internal advisors =          AddressTokenAllocation(0x3d5fa25a3C0EB68690075eD810A10170e441413e, 48e5);\n', '    AddressTokenAllocation internal bounty =            AddressTokenAllocation(0xAc2099D2705434f75adA370420A8Dd397Bf7CCA1, 176e5);\n', '    AddressTokenAllocation internal administrative =    AddressTokenAllocation(0x438aB07D5EC30Dd9B0F370e0FE0455F93C95002e, 76e5);\n', '\n', '    address internal playersReserve = 0x8A40B0Cf87DaF12C689ADB5C74a1B2f23B3a33e1;\n', '}\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    *  Constructor\n', '    *\n', '    *  Sets contract owner to address of constructor caller\n', '    */\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    *  Change Owner\n', '    *\n', '    *  Changes ownership of this contract. Only owner can call this method.\n', '    *\n', '    * @param newOwner - new owner&#39;s address\n', '    */\n', '    function changeOwner(address newOwner) onlyOwner public {\n', '        require(newOwner != address(0));\n', '        require(newOwner != owner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract FHFTokenCrowdsale is Owned, CrowdsaleParameters {\n', '    /* Token and records */\n', '    FHFTokenInterface private token;\n', '    address private saleWalletAddress;\n', '    uint private tokenMultiplier = 10;\n', '    uint public totalCollected = 0;\n', '    uint public saleGoal;\n', '    bool public goalReached = false;\n', '\n', '    /* Events */\n', '    event TokenSale(address indexed tokenReceiver, uint indexed etherAmount, uint indexed tokenAmount, uint tokensPerEther);\n', '    event FundTransfer(address indexed from, address indexed to, uint indexed amount);\n', '\n', '    /**\n', '    * Constructor\n', '    *\n', '    * @param _tokenAddress - address of token (deployed before this contract)\n', '    */\n', '    function FHFTokenCrowdsale(address _tokenAddress) public {\n', '        token = FHFTokenInterface(_tokenAddress);\n', '        tokenMultiplier = tokenMultiplier ** token.decimals();\n', '        saleWalletAddress = CrowdsaleParameters.generalSaleWallet.addr;\n', '\n', '        // Initialize sale goal\n', '        saleGoal = CrowdsaleParameters.generalSaleWallet.amount;\n', '    }\n', '\n', '    /**\n', '    * Is sale active\n', '    *\n', '    * @return active - True, if sale is active\n', '    */\n', '    function isICOActive() public constant returns (bool active) {\n', '        active = ((generalSaleStartDate <= now) && (now < generalSaleEndDate) && (!goalReached));\n', '        return active;\n', '    }\n', '\n', '    /**\n', '    *  Process received payment\n', '    *\n', '    *  Determine the integer number of tokens that was purchased considering current\n', '    *  stage, tier bonus, and remaining amount of tokens in the sale wallet.\n', '    *  Transfer purchased tokens to backerAddress and return unused portion of\n', '    *  ether (change)\n', '    *\n', '    * @param backerAddress - address that ether was sent from\n', '    * @param amount - amount of Wei received\n', '    */\n', '    function processPayment(address backerAddress, uint amount) internal {\n', '        require(isICOActive());\n', '\n', '        // Before Metropolis update require will not refund gas, but\n', '        // for some reason require statement around msg.value always throws\n', '        assert(msg.value > 0 finney);\n', '\n', '        // Tell everyone about the transfer\n', '        FundTransfer(backerAddress, address(this), amount);\n', '\n', '        // Calculate tokens per ETH for this tier\n', '        uint tokensPerEth = 10000;\n', '\n', '        // Calculate token amount that is purchased,\n', '        uint tokenAmount = amount * tokensPerEth;\n', '\n', '        // Check that stage wallet has enough tokens. If not, sell the rest and\n', '        // return change.\n', '        uint remainingTokenBalance = token.balanceOf(saleWalletAddress);\n', '        if (remainingTokenBalance <= tokenAmount) {\n', '            tokenAmount = remainingTokenBalance;\n', '            goalReached = true;\n', '        }\n', '\n', '        // Calculate Wei amount that was received in this transaction\n', '        // adjusted to rounding and remaining token amount\n', '        uint acceptedAmount = tokenAmount / tokensPerEth;\n', '\n', '        // Update crowdsale performance\n', '        totalCollected += acceptedAmount;\n', '\n', '        // Transfer tokens to baker and return ETH change\n', '        token.transferFrom(saleWalletAddress, backerAddress, tokenAmount);\n', '\n', '        TokenSale(backerAddress, amount, tokenAmount, tokensPerEth);\n', '\n', '        // Return change (in Wei)\n', '        uint change = amount - acceptedAmount;\n', '        if (change > 0) {\n', '            if (backerAddress.send(change)) {\n', '                FundTransfer(address(this), backerAddress, change);\n', '            }\n', '            else revert();\n', '        }\n', '    }\n', '\n', '    /**\n', '    *  Transfer ETH amount from contract to owner&#39;s address.\n', '    *  Can only be used if ICO is closed\n', '    *\n', '    * @param amount - ETH amount to transfer in Wei\n', '    */\n', '    function safeWithdrawal(uint amount) external onlyOwner {\n', '        require(this.balance >= amount);\n', '        require(!isICOActive());\n', '\n', '        if (owner.send(amount)) {\n', '            FundTransfer(address(this), msg.sender, amount);\n', '        }\n', '    }\n', '\n', '    /**\n', '    *  Default method\n', '    *\n', '    *  Processes all ETH that it receives and credits FHF tokens to sender\n', '    *  according to current stage bonus\n', '    */\n', '    function () external payable {\n', '        processPayment(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '    * Close main sale and move unsold tokens to playersReserve wallet\n', '    */\n', '    function closeMainSaleICO() external onlyOwner {\n', '        require(!isICOActive());\n', '        require(generalSaleStartDate < now);\n', '\n', '        var amountToMove = token.balanceOf(generalSaleWallet.addr);\n', '        token.transferFrom(generalSaleWallet.addr, playersReserve, amountToMove);\n', '        generalSaleEndDate = now;\n', '    }\n', '\n', '    /**\n', '    *  Kill method\n', '    *\n', '    *  Double-checks that unsold general sale tokens were moved off general sale wallet and\n', '    *  destructs this contract\n', '    */\n', '    function kill() external onlyOwner {\n', '        require(!isICOActive());\n', '        if (now < generalSaleStartDate) {\n', '            selfdestruct(owner);\n', '        } else if (token.balanceOf(generalSaleWallet.addr) == 0) {\n', '            FundTransfer(address(this), msg.sender, this.balance);\n', '            selfdestruct(owner);\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '}']
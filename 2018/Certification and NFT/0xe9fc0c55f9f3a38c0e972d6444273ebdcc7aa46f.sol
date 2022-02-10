['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Math\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library Math {\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a > b ? a : b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address internal owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public returns (bool) {\n', '        require(newOwner != address(0x0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '/**\n', ' * @title RefundVault\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it if crowdsale is successful.\n', ' */\n', 'contract RefundVault is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    enum State { Active, Refunding, Unlocked }\n', '\n', '    mapping (address => uint256) public deposited;\n', '    address public wallet;\n', '    State public state;\n', '\n', '    event RefundsEnabled();\n', '    event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '    function RefundVault(address _wallet) public {\n', '        require(_wallet != 0x0);\n', '        wallet = _wallet;\n', '        state = State.Active;\n', '    }\n', '\n', '    function deposit(address investor) onlyOwner public payable {\n', '        require(state != State.Refunding);\n', '        deposited[investor] = deposited[investor].add(msg.value);\n', '    }\n', '\n', '    function unlock() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Unlocked;\n', '    }\n', '\n', '    function withdraw(address beneficiary, uint256 amount) onlyOwner public {\n', '        require(beneficiary != 0x0);\n', '        require(state == State.Unlocked);\n', '\n', '        beneficiary.transfer(amount);\n', '    }\n', '\n', '    function enableRefunds() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Refunding;\n', '        emit RefundsEnabled();\n', '    }\n', '\n', '    function refund(address investor) public {\n', '        require(state == State.Refunding);\n', '        uint256 depositedValue = deposited[investor];\n', '        deposited[investor] = 0;\n', '        investor.transfer(depositedValue);\n', '        emit Refunded(investor, depositedValue);\n', '    }\n', '}\n', '\n', 'interface MintableToken {\n', '    function mint(address _to, uint256 _amount) external returns (bool);\n', '    function transferOwnership(address newOwner) external returns (bool);\n', '}\n', '\n', '/**\n', '    This contract will handle the KYC contribution caps and the AML whitelist.\n', '    The crowdsale contract checks this whitelist everytime someone tries to buy tokens.\n', '*/\n', 'contract BitNauticWhitelist is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public usdPerEth;\n', '\n', '    function BitNauticWhitelist(uint256 _usdPerEth) public {\n', '        usdPerEth = _usdPerEth;\n', '    }\n', '\n', '    mapping(address => bool) public AMLWhitelisted;\n', '    mapping(address => uint256) public contributionCap;\n', '\n', '    /**\n', '     * @dev sets the KYC contribution cap for one address\n', '     * @param addr address\n', '     * @param level uint8\n', '     * @return true if the operation was successful\n', '     */\n', '    function setKYCLevel(address addr, uint8 level) onlyOwner public returns (bool) {\n', '        if (level >= 3) {\n', '            contributionCap[addr] = 50000 ether; // crowdsale hard cap\n', '        } else if (level == 2) {\n', '            contributionCap[addr] = SafeMath.div(500000 * 10 ** 18, usdPerEth); // KYC Tier 2 - 500k USD\n', '        } else if (level == 1) {\n', '            contributionCap[addr] = SafeMath.div(3000 * 10 ** 18, usdPerEth); // KYC Tier 1 - 3k USD\n', '        } else {\n', '            contributionCap[addr] = 0;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function setKYCLevelsBulk(address[] addrs, uint8[] levels) onlyOwner external returns (bool success) {\n', '        require(addrs.length == levels.length);\n', '\n', '        for (uint256 i = 0; i < addrs.length; i++) {\n', '            assert(setKYCLevel(addrs[i], levels[i]));\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev adds the specified address to the AML whitelist\n', '     * @param addr address\n', '     * @return true if the address was added to the whitelist, false if the address was already in the whitelist\n', '     */\n', '    function setAMLWhitelisted(address addr, bool whitelisted) onlyOwner public returns (bool) {\n', '        AMLWhitelisted[addr] = whitelisted;\n', '\n', '        return true;\n', '    }\n', '\n', '    function setAMLWhitelistedBulk(address[] addrs, bool[] whitelisted) onlyOwner external returns (bool) {\n', '        require(addrs.length == whitelisted.length);\n', '\n', '        for (uint256 i = 0; i < addrs.length; i++) {\n', '            assert(setAMLWhitelisted(addrs[i], whitelisted[i]));\n', '        }\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract NewBitNauticCrowdsale is Ownable, Pausable {\n', '    using SafeMath for uint256;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    uint256 public ICOStartTime = 1531267200; // 11 Jul 2018 00:00 GMT\n', '    uint256 public ICOEndTime = 1537056000; // 16 Sep 2018 00:00 GMT\n', '\n', '    uint256 public constant tokenBaseRate = 500; // 1 ETH = 500 BTNT\n', '\n', '    bool public manualBonusActive = false;\n', '    uint256 public manualBonus = 0;\n', '\n', '    uint256 public constant crowdsaleSupply = 35000000 * 10 ** 18;\n', '    uint256 public tokensSold = 0;\n', '\n', '    uint256 public constant softCap = 2500000 * 10 ** 18;\n', '\n', '    uint256 public teamSupply =     3000000 * 10 ** 18; // 6% of token cap\n', '    uint256 public bountySupply =   2500000 * 10 ** 18; // 5% of token cap\n', '    uint256 public reserveSupply =  5000000 * 10 ** 18; // 10% of token cap\n', '    uint256 public advisorSupply =  2500000 * 10 ** 18; // 5% of token cap\n', '    uint256 public founderSupply =  2000000 * 10 ** 18; // 4% of token cap\n', '\n', '    // amount of tokens each address will receive at the end of the crowdsale\n', '    mapping (address => uint256) public creditOf;\n', '\n', '    // amount of ether invested by each address\n', '    mapping (address => uint256) public weiInvestedBy;\n', '\n', '    // refund vault used to hold funds while crowdsale is running\n', '    RefundVault private vault;\n', '\n', '    MintableToken public token;\n', '    BitNauticWhitelist public whitelist;\n', '\n', '    constructor(MintableToken _token, BitNauticWhitelist _whitelist, address _beneficiary) public {\n', '        token = _token;\n', '        whitelist = _whitelist;\n', '        vault = new RefundVault(_beneficiary);\n', '    }\n', '\n', '    function() public payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address beneficiary) whenNotPaused public payable {\n', '        require(beneficiary != 0x0);\n', '        require(validPurchase());\n', '\n', '        // checks if the ether amount invested by the buyer is lower than his contribution cap\n', '        require(SafeMath.add(weiInvestedBy[msg.sender], msg.value) <= whitelist.contributionCap(msg.sender));\n', '\n', '        // compute the amount of tokens given the baseRate\n', '        uint256 tokens = SafeMath.mul(msg.value, tokenBaseRate);\n', '        // add the bonus tokens depending on current time\n', '        tokens = tokens.add(SafeMath.mul(tokens, getCurrentBonus()).div(1000));\n', '\n', '        // check hardcap\n', '        require(SafeMath.add(tokensSold, tokens) <= crowdsaleSupply);\n', '\n', '        // update total token sold counter\n', '        tokensSold = SafeMath.add(tokensSold, tokens);\n', '\n', '        // keep track of the token credit and ether invested by the buyer\n', '        creditOf[beneficiary] = creditOf[beneficiary].add(tokens);\n', '        weiInvestedBy[msg.sender] = SafeMath.add(weiInvestedBy[msg.sender], msg.value);\n', '\n', '        emit TokenPurchase(msg.sender, beneficiary, msg.value, tokens);\n', '\n', '        vault.deposit.value(msg.value)(msg.sender);\n', '    }\n', '\n', '    function privateSale(address beneficiary, uint256 tokenAmount) onlyOwner public {\n', '        require(beneficiary != 0x0);\n', '        require(SafeMath.add(tokensSold, tokenAmount) <= crowdsaleSupply); // check hardcap\n', '\n', '        tokensSold = SafeMath.add(tokensSold, tokenAmount);\n', '\n', '        assert(token.mint(beneficiary, tokenAmount));\n', '    }\n', '\n', '    // for payments in other currencies\n', '    function offchainSale(address beneficiary, uint256 tokenAmount) onlyOwner public {\n', '        require(beneficiary != 0x0);\n', '        require(SafeMath.add(tokensSold, tokenAmount) <= crowdsaleSupply); // check hardcap\n', '\n', '        tokensSold = SafeMath.add(tokensSold, tokenAmount);\n', '\n', '        // keep track of the token credit of the buyer\n', '        creditOf[beneficiary] = creditOf[beneficiary].add(tokenAmount);\n', '\n', '        emit TokenPurchase(beneficiary, beneficiary, 0, tokenAmount);\n', '    }\n', '\n', '    // this function can be called by the contributor to claim his BTNT tokens at the end of the ICO\n', '    function claimBitNauticTokens() public returns (bool) {\n', '        return grantContributorTokens(msg.sender);\n', '    }\n', '\n', '    // if the ICO is finished and the goal has been reached, this function will be used to mint and transfer BTNT tokens to each contributor\n', '    function grantContributorTokens(address contributor) public returns (bool) {\n', '        require(creditOf[contributor] > 0);\n', '        require(whitelist.AMLWhitelisted(contributor));\n', '        require(now > ICOEndTime && tokensSold >= softCap);\n', '\n', '        assert(token.mint(contributor, creditOf[contributor]));\n', '        creditOf[contributor] = 0;\n', '\n', '        return true;\n', '    }\n', '\n', '    // returns the token sale bonus permille depending on the current time\n', '    function getCurrentBonus() public view returns (uint256) {\n', '        if (manualBonusActive) return manualBonus;\n', '\n', '        return Math.min(340, Math.max(100, (340 - (now - ICOStartTime) / (60 * 60 * 24) * 4)));\n', '    }\n', '\n', '    function setManualBonus(uint256 newBonus, bool isActive) onlyOwner public returns (bool) {\n', '        manualBonus = newBonus;\n', '        manualBonusActive = isActive;\n', '\n', '        return true;\n', '    }\n', '\n', '    function setICOEndTime(uint256 newEndTime) onlyOwner public returns (bool) {\n', '        ICOEndTime = newEndTime;\n', '\n', '        return true;\n', '    }\n', '\n', '    function validPurchase() internal view returns (bool) {\n', '        bool duringICO = ICOStartTime <= now && now <= ICOEndTime;\n', '        bool minimumContribution = msg.value >= 0.05 ether;\n', '        return duringICO && minimumContribution;\n', '    }\n', '\n', '    function hasEnded() public view returns (bool) {\n', '        return now > ICOEndTime;\n', '    }\n', '\n', '    function unlockVault() onlyOwner public {\n', '        if (tokensSold >= softCap) {\n', '            vault.unlock();\n', '        }\n', '    }\n', '\n', '    function withdraw(address beneficiary, uint256 amount) onlyOwner public {\n', '        vault.withdraw(beneficiary, amount);\n', '    }\n', '\n', '    bool isFinalized = false;\n', '    function finalizeCrowdsale() onlyOwner public {\n', '        require(!isFinalized);\n', '        require(now > ICOEndTime);\n', '\n', '        if (tokensSold < softCap) {\n', '            vault.enableRefunds();\n', '        }\n', '\n', '        isFinalized = true;\n', '    }\n', '\n', '    // if crowdsale is unsuccessful, investors can claim refunds here\n', '    function claimRefund() public {\n', '        require(isFinalized);\n', '        require(tokensSold < softCap);\n', '\n', '        vault.refund(msg.sender);\n', '    }\n', '\n', '    function transferTokenOwnership(address newTokenOwner) onlyOwner public returns (bool) {\n', '        return token.transferOwnership(newTokenOwner);\n', '    }\n', '\n', '    function grantBountyTokens(address beneficiary) onlyOwner public {\n', '        require(bountySupply > 0);\n', '\n', '        token.mint(beneficiary, bountySupply);\n', '        bountySupply = 0;\n', '    }\n', '\n', '    function grantReserveTokens(address beneficiary) onlyOwner public {\n', '        require(reserveSupply > 0);\n', '\n', '        token.mint(beneficiary, reserveSupply);\n', '        reserveSupply = 0;\n', '    }\n', '\n', '    function grantAdvisorsTokens(address beneficiary) onlyOwner public {\n', '        require(advisorSupply > 0);\n', '\n', '        token.mint(beneficiary, advisorSupply);\n', '        advisorSupply = 0;\n', '    }\n', '\n', '    function grantFoundersTokens(address beneficiary) onlyOwner public {\n', '        require(founderSupply > 0);\n', '\n', '        token.mint(beneficiary, founderSupply);\n', '        founderSupply = 0;\n', '    }\n', '\n', '    function grantTeamTokens(address beneficiary) onlyOwner public {\n', '        require(teamSupply > 0);\n', '\n', '        token.mint(beneficiary, teamSupply);\n', '        teamSupply = 0;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Math\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library Math {\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a > b ? a : b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address internal owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public returns (bool) {\n', '        require(newOwner != address(0x0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '/**\n', ' * @title RefundVault\n', ' * @dev This contract is used for storing funds while a crowdsale\n', ' * is in progress. Supports refunding the money if crowdsale fails,\n', ' * and forwarding it if crowdsale is successful.\n', ' */\n', 'contract RefundVault is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    enum State { Active, Refunding, Unlocked }\n', '\n', '    mapping (address => uint256) public deposited;\n', '    address public wallet;\n', '    State public state;\n', '\n', '    event RefundsEnabled();\n', '    event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '\n', '    function RefundVault(address _wallet) public {\n', '        require(_wallet != 0x0);\n', '        wallet = _wallet;\n', '        state = State.Active;\n', '    }\n', '\n', '    function deposit(address investor) onlyOwner public payable {\n', '        require(state != State.Refunding);\n', '        deposited[investor] = deposited[investor].add(msg.value);\n', '    }\n', '\n', '    function unlock() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Unlocked;\n', '    }\n', '\n', '    function withdraw(address beneficiary, uint256 amount) onlyOwner public {\n', '        require(beneficiary != 0x0);\n', '        require(state == State.Unlocked);\n', '\n', '        beneficiary.transfer(amount);\n', '    }\n', '\n', '    function enableRefunds() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Refunding;\n', '        emit RefundsEnabled();\n', '    }\n', '\n', '    function refund(address investor) public {\n', '        require(state == State.Refunding);\n', '        uint256 depositedValue = deposited[investor];\n', '        deposited[investor] = 0;\n', '        investor.transfer(depositedValue);\n', '        emit Refunded(investor, depositedValue);\n', '    }\n', '}\n', '\n', 'interface MintableToken {\n', '    function mint(address _to, uint256 _amount) external returns (bool);\n', '    function transferOwnership(address newOwner) external returns (bool);\n', '}\n', '\n', '/**\n', '    This contract will handle the KYC contribution caps and the AML whitelist.\n', '    The crowdsale contract checks this whitelist everytime someone tries to buy tokens.\n', '*/\n', 'contract BitNauticWhitelist is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public usdPerEth;\n', '\n', '    function BitNauticWhitelist(uint256 _usdPerEth) public {\n', '        usdPerEth = _usdPerEth;\n', '    }\n', '\n', '    mapping(address => bool) public AMLWhitelisted;\n', '    mapping(address => uint256) public contributionCap;\n', '\n', '    /**\n', '     * @dev sets the KYC contribution cap for one address\n', '     * @param addr address\n', '     * @param level uint8\n', '     * @return true if the operation was successful\n', '     */\n', '    function setKYCLevel(address addr, uint8 level) onlyOwner public returns (bool) {\n', '        if (level >= 3) {\n', '            contributionCap[addr] = 50000 ether; // crowdsale hard cap\n', '        } else if (level == 2) {\n', '            contributionCap[addr] = SafeMath.div(500000 * 10 ** 18, usdPerEth); // KYC Tier 2 - 500k USD\n', '        } else if (level == 1) {\n', '            contributionCap[addr] = SafeMath.div(3000 * 10 ** 18, usdPerEth); // KYC Tier 1 - 3k USD\n', '        } else {\n', '            contributionCap[addr] = 0;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function setKYCLevelsBulk(address[] addrs, uint8[] levels) onlyOwner external returns (bool success) {\n', '        require(addrs.length == levels.length);\n', '\n', '        for (uint256 i = 0; i < addrs.length; i++) {\n', '            assert(setKYCLevel(addrs[i], levels[i]));\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev adds the specified address to the AML whitelist\n', '     * @param addr address\n', '     * @return true if the address was added to the whitelist, false if the address was already in the whitelist\n', '     */\n', '    function setAMLWhitelisted(address addr, bool whitelisted) onlyOwner public returns (bool) {\n', '        AMLWhitelisted[addr] = whitelisted;\n', '\n', '        return true;\n', '    }\n', '\n', '    function setAMLWhitelistedBulk(address[] addrs, bool[] whitelisted) onlyOwner external returns (bool) {\n', '        require(addrs.length == whitelisted.length);\n', '\n', '        for (uint256 i = 0; i < addrs.length; i++) {\n', '            assert(setAMLWhitelisted(addrs[i], whitelisted[i]));\n', '        }\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract NewBitNauticCrowdsale is Ownable, Pausable {\n', '    using SafeMath for uint256;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    uint256 public ICOStartTime = 1531267200; // 11 Jul 2018 00:00 GMT\n', '    uint256 public ICOEndTime = 1537056000; // 16 Sep 2018 00:00 GMT\n', '\n', '    uint256 public constant tokenBaseRate = 500; // 1 ETH = 500 BTNT\n', '\n', '    bool public manualBonusActive = false;\n', '    uint256 public manualBonus = 0;\n', '\n', '    uint256 public constant crowdsaleSupply = 35000000 * 10 ** 18;\n', '    uint256 public tokensSold = 0;\n', '\n', '    uint256 public constant softCap = 2500000 * 10 ** 18;\n', '\n', '    uint256 public teamSupply =     3000000 * 10 ** 18; // 6% of token cap\n', '    uint256 public bountySupply =   2500000 * 10 ** 18; // 5% of token cap\n', '    uint256 public reserveSupply =  5000000 * 10 ** 18; // 10% of token cap\n', '    uint256 public advisorSupply =  2500000 * 10 ** 18; // 5% of token cap\n', '    uint256 public founderSupply =  2000000 * 10 ** 18; // 4% of token cap\n', '\n', '    // amount of tokens each address will receive at the end of the crowdsale\n', '    mapping (address => uint256) public creditOf;\n', '\n', '    // amount of ether invested by each address\n', '    mapping (address => uint256) public weiInvestedBy;\n', '\n', '    // refund vault used to hold funds while crowdsale is running\n', '    RefundVault private vault;\n', '\n', '    MintableToken public token;\n', '    BitNauticWhitelist public whitelist;\n', '\n', '    constructor(MintableToken _token, BitNauticWhitelist _whitelist, address _beneficiary) public {\n', '        token = _token;\n', '        whitelist = _whitelist;\n', '        vault = new RefundVault(_beneficiary);\n', '    }\n', '\n', '    function() public payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address beneficiary) whenNotPaused public payable {\n', '        require(beneficiary != 0x0);\n', '        require(validPurchase());\n', '\n', '        // checks if the ether amount invested by the buyer is lower than his contribution cap\n', '        require(SafeMath.add(weiInvestedBy[msg.sender], msg.value) <= whitelist.contributionCap(msg.sender));\n', '\n', '        // compute the amount of tokens given the baseRate\n', '        uint256 tokens = SafeMath.mul(msg.value, tokenBaseRate);\n', '        // add the bonus tokens depending on current time\n', '        tokens = tokens.add(SafeMath.mul(tokens, getCurrentBonus()).div(1000));\n', '\n', '        // check hardcap\n', '        require(SafeMath.add(tokensSold, tokens) <= crowdsaleSupply);\n', '\n', '        // update total token sold counter\n', '        tokensSold = SafeMath.add(tokensSold, tokens);\n', '\n', '        // keep track of the token credit and ether invested by the buyer\n', '        creditOf[beneficiary] = creditOf[beneficiary].add(tokens);\n', '        weiInvestedBy[msg.sender] = SafeMath.add(weiInvestedBy[msg.sender], msg.value);\n', '\n', '        emit TokenPurchase(msg.sender, beneficiary, msg.value, tokens);\n', '\n', '        vault.deposit.value(msg.value)(msg.sender);\n', '    }\n', '\n', '    function privateSale(address beneficiary, uint256 tokenAmount) onlyOwner public {\n', '        require(beneficiary != 0x0);\n', '        require(SafeMath.add(tokensSold, tokenAmount) <= crowdsaleSupply); // check hardcap\n', '\n', '        tokensSold = SafeMath.add(tokensSold, tokenAmount);\n', '\n', '        assert(token.mint(beneficiary, tokenAmount));\n', '    }\n', '\n', '    // for payments in other currencies\n', '    function offchainSale(address beneficiary, uint256 tokenAmount) onlyOwner public {\n', '        require(beneficiary != 0x0);\n', '        require(SafeMath.add(tokensSold, tokenAmount) <= crowdsaleSupply); // check hardcap\n', '\n', '        tokensSold = SafeMath.add(tokensSold, tokenAmount);\n', '\n', '        // keep track of the token credit of the buyer\n', '        creditOf[beneficiary] = creditOf[beneficiary].add(tokenAmount);\n', '\n', '        emit TokenPurchase(beneficiary, beneficiary, 0, tokenAmount);\n', '    }\n', '\n', '    // this function can be called by the contributor to claim his BTNT tokens at the end of the ICO\n', '    function claimBitNauticTokens() public returns (bool) {\n', '        return grantContributorTokens(msg.sender);\n', '    }\n', '\n', '    // if the ICO is finished and the goal has been reached, this function will be used to mint and transfer BTNT tokens to each contributor\n', '    function grantContributorTokens(address contributor) public returns (bool) {\n', '        require(creditOf[contributor] > 0);\n', '        require(whitelist.AMLWhitelisted(contributor));\n', '        require(now > ICOEndTime && tokensSold >= softCap);\n', '\n', '        assert(token.mint(contributor, creditOf[contributor]));\n', '        creditOf[contributor] = 0;\n', '\n', '        return true;\n', '    }\n', '\n', '    // returns the token sale bonus permille depending on the current time\n', '    function getCurrentBonus() public view returns (uint256) {\n', '        if (manualBonusActive) return manualBonus;\n', '\n', '        return Math.min(340, Math.max(100, (340 - (now - ICOStartTime) / (60 * 60 * 24) * 4)));\n', '    }\n', '\n', '    function setManualBonus(uint256 newBonus, bool isActive) onlyOwner public returns (bool) {\n', '        manualBonus = newBonus;\n', '        manualBonusActive = isActive;\n', '\n', '        return true;\n', '    }\n', '\n', '    function setICOEndTime(uint256 newEndTime) onlyOwner public returns (bool) {\n', '        ICOEndTime = newEndTime;\n', '\n', '        return true;\n', '    }\n', '\n', '    function validPurchase() internal view returns (bool) {\n', '        bool duringICO = ICOStartTime <= now && now <= ICOEndTime;\n', '        bool minimumContribution = msg.value >= 0.05 ether;\n', '        return duringICO && minimumContribution;\n', '    }\n', '\n', '    function hasEnded() public view returns (bool) {\n', '        return now > ICOEndTime;\n', '    }\n', '\n', '    function unlockVault() onlyOwner public {\n', '        if (tokensSold >= softCap) {\n', '            vault.unlock();\n', '        }\n', '    }\n', '\n', '    function withdraw(address beneficiary, uint256 amount) onlyOwner public {\n', '        vault.withdraw(beneficiary, amount);\n', '    }\n', '\n', '    bool isFinalized = false;\n', '    function finalizeCrowdsale() onlyOwner public {\n', '        require(!isFinalized);\n', '        require(now > ICOEndTime);\n', '\n', '        if (tokensSold < softCap) {\n', '            vault.enableRefunds();\n', '        }\n', '\n', '        isFinalized = true;\n', '    }\n', '\n', '    // if crowdsale is unsuccessful, investors can claim refunds here\n', '    function claimRefund() public {\n', '        require(isFinalized);\n', '        require(tokensSold < softCap);\n', '\n', '        vault.refund(msg.sender);\n', '    }\n', '\n', '    function transferTokenOwnership(address newTokenOwner) onlyOwner public returns (bool) {\n', '        return token.transferOwnership(newTokenOwner);\n', '    }\n', '\n', '    function grantBountyTokens(address beneficiary) onlyOwner public {\n', '        require(bountySupply > 0);\n', '\n', '        token.mint(beneficiary, bountySupply);\n', '        bountySupply = 0;\n', '    }\n', '\n', '    function grantReserveTokens(address beneficiary) onlyOwner public {\n', '        require(reserveSupply > 0);\n', '\n', '        token.mint(beneficiary, reserveSupply);\n', '        reserveSupply = 0;\n', '    }\n', '\n', '    function grantAdvisorsTokens(address beneficiary) onlyOwner public {\n', '        require(advisorSupply > 0);\n', '\n', '        token.mint(beneficiary, advisorSupply);\n', '        advisorSupply = 0;\n', '    }\n', '\n', '    function grantFoundersTokens(address beneficiary) onlyOwner public {\n', '        require(founderSupply > 0);\n', '\n', '        token.mint(beneficiary, founderSupply);\n', '        founderSupply = 0;\n', '    }\n', '\n', '    function grantTeamTokens(address beneficiary) onlyOwner public {\n', '        require(teamSupply > 0);\n', '\n', '        token.mint(beneficiary, teamSupply);\n', '        teamSupply = 0;\n', '    }\n', '}']
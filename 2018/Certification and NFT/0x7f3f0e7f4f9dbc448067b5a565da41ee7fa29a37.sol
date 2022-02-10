['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * \n', ' * \n', ' *          ooooooooooooo                     oooo                              oooo                                        oooooooo   .oooooo.    \n', '            8&#39;   888   `8                     `888                              `888                                       dP"""""""  d8P&#39;  `Y8b   \n', '                 888       .ooooo.   .ooooo.   888 .oo.   ooo. .oo.    .ooooo.   888   .ooooo.   .oooooooo oooo    ooo    d88888b.   888           \n', '                 888      d88&#39; `88b d88&#39; `"Y8  888P"Y88b  `888P"Y88b  d88&#39; `88b  888  d88&#39; `88b 888&#39; `88b   `88.  .8&#39;         `Y88b  888           \n', '                 888      888ooo888 888        888   888   888   888  888   888  888  888   888 888   888    `88..8&#39;            ]88  888     ooooo \n', '                 888      888    .o 888   .o8  888   888   888   888  888   888  888  888   888 `88bod8P&#39;     `888&#39;       o.   .88P  `88.    .88&#39;  \n', '                o888o     `Y8bod8P&#39; `Y8bod8P&#39; o888o o888o o888o o888o `Y8bod8P&#39; o888o `Y8bod8P&#39; `8oooooo.      .8&#39;        `8bd88P&#39;    `Y8bood8P&#39;   \n', '                                                                                                d"     YD  .o..P&#39;                                  \n', '                                                                                                "Y88888P&#39;  `Y8P&#39;                                   \n', '                                                                                                \n', '                                                                                                \n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '/*\n', ' * Technology5G is a standard ERC20 token with some additional functionalities:\n', ' * - Transfers are only enabled after contract owner enables it (after the ICO)\n', ' *\n', ' * Note: Token Offering == Initial Coin Offering(ICO)\n', ' */\n', '\n', 'contract Technology5G is StandardToken, Ownable {\n', '    string public constant symbol = "5G";\n', '    string public constant name = "Technology5G";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant INITIAL_SUPPLY = 1250000000 * (10 ** uint256(decimals));\n', '    uint256 public constant TOKEN_OFFERING_ALLOWANCE = 937500000 * (10 ** uint256(decimals));\n', '    uint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_OFFERING_ALLOWANCE;\n', '    \n', '    // Address of token admin\n', '    address public adminAddr;\n', '\n', '    // Address of token offering\n', '\t  address public tokenOfferingAddr;\n', '\n', '    // Enable transfers after conclusion of token offering\n', '    bool public transferEnabled = false;\n', '    \n', '    /**\n', '     * Check if transfer is allowed\n', '     *\n', '     * Permissions:\n', '     *                                                       Owner    Admin    OffeirngContract    Others\n', '     * transfer (before transferEnabled is true)               x        x            x               x\n', '     * transferFrom (before transferEnabled is true)           x        v            v               x\n', '     * transfer/transferFrom after transferEnabled is true     v        x            x               v\n', '     */\n', '    modifier onlyWhenTransferAllowed() {\n', '        require(transferEnabled || msg.sender == adminAddr || msg.sender == tokenOfferingAddr);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Check if token offering address is set or not\n', '     */\n', '    modifier onlyTokenOfferingAddrNotSet() {\n', '        require(tokenOfferingAddr == address(0x0));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Check if address is a valid destination to transfer tokens to\n', '     * - must not be zero address\n', '     * - must not be the token address\n', '     * - must not be the owner&#39;s address\n', '     * - must not be the admin&#39;s address\n', '     * - must not be the token offering contract address\n', '     */\n', '    modifier validDestination(address to) {\n', '        require(to != address(0x0));\n', '        require(to != address(this));\n', '        require(to != owner);\n', '        require(to != address(adminAddr));\n', '        require(to != address(tokenOfferingAddr));\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * Token contract constructor\n', '     *\n', '     * @param admin Address of admin account\n', '     */\n', '    function Technology5G(address admin) public {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        \n', '        // Mint tokens\n', '        balances[msg.sender] = totalSupply;\n', '        Transfer(address(0x0), msg.sender, totalSupply);\n', '\n', '        // Approve allowance for admin account\n', '        adminAddr = admin;\n', '        approve(adminAddr, ADMIN_ALLOWANCE);\n', '    }\n', '\n', '    /**\n', '     * Set token offering to approve allowance for offering contract to distribute tokens\n', '     *\n', '     * @param offeringAddr Address of token offering contract\n', '     * @param amountForSale Amount of tokens for sale, set 0 to max out\n', '     */\n', '    function setTokenOffering(address offeringAddr, uint256 amountForSale) external onlyOwner onlyTokenOfferingAddrNotSet {\n', '        require(!transferEnabled);\n', '\n', '        uint256 amount = (amountForSale == 0) ? TOKEN_OFFERING_ALLOWANCE : amountForSale;\n', '        require(amount <= TOKEN_OFFERING_ALLOWANCE);\n', '\n', '        approve(offeringAddr, amount);\n', '        tokenOfferingAddr = offeringAddr;\n', '    }\n', '    \n', '    /**\n', '     * Enable transfers\n', '     */\n', '    function enableTransfer() external onlyOwner {\n', '        transferEnabled = true;\n', '\n', '        // End the offering\n', '        approve(tokenOfferingAddr, 0);\n', '    }\n', '\n', '    /**\n', '     * Transfer from sender to another account\n', '     *\n', '     * @param to Destination address\n', '     * @param value Amount of docks to send\n', '     */\n', '    function transfer(address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {\n', '        return super.transfer(to, value);\n', '    }\n', '    \n', '    /**\n', '     * Transfer from `from` account to `to` account using allowance in `from` account to the sender\n', '     *\n', '     * @param from Origin address\n', '     * @param to Destination address\n', '     * @param value Amount of docks to send\n', '     */\n', '    function transferFrom(address from, address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {\n', '        return super.transferFrom(from, to, value);\n', '    }\n', '    \n', '}\n', '\n', 'contract Technology5GCrowdsale is Pausable {\n', '    using SafeMath for uint256;\n', '\n', '     // Token to be sold\n', '    Technology5G public token;\n', '\n', '    // Start and end timestamps where contributions are allowed (both inclusive)\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    // Address where funds are collected\n', '    address public beneficiary;\n', '\n', '    // Price of the tokens as in tokens per ether\n', '    uint256 public rate;\n', '\n', '    // Amount of raised in Wei \n', '    uint256 public weiRaised;\n', '\n', '    // Timelines for contribution limit policy\n', '    uint256 public capReleaseTimestamp;\n', '\n', '    uint256 public extraTime;\n', '\n', '    // Whitelists of participant address\n', '    mapping(address => bool) public whitelists;\n', '\n', '    // Contributions in Wei for each participant\n', '    mapping(address => uint256) public contributions;\n', '\n', '    // Funding cap in ETH. \n', '    uint256 public constant FUNDING_ETH_HARD_CAP = 15000 * 1 ether;\n', '\n', '    // Min contribution is 0.1 ether\n', '    uint256 public minContribution = 100**16;\n', '\n', '    // Max contribution is 50 ether\n', '    uint256 public maxContribution = 500**18;\n', '\n', '    //remainCap\n', '    uint256 public remainCap;\n', '\n', '    // The current stage of the offering\n', '    Stages public stage;\n', '\n', '    enum Stages { \n', '        Setup,\n', '        OfferingStarted,\n', '        OfferingEnded\n', '    }\n', '\n', '    event OfferingOpens(uint256 startTime, uint256 endTime);\n', '    event OfferingCloses(uint256 endTime, uint256 totalWeiRaised);\n', '    /**\n', '     * Event for token purchase logging\n', '     *\n', '     * @param purchaser Who paid for the tokens\n', '     * @param value Weis paid for purchase\n', '     * @return amount Amount of tokens purchased\n', '     */\n', '    event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);\n', '\n', '    /**\n', '     * Modifier that requires certain stage before executing the main function body\n', '     *\n', '     * @param expectedStage Value that the current stage is required to match\n', '     */\n', '    modifier atStage(Stages expectedStage) {\n', '        require(stage == expectedStage);\n', '        _;\n', '    }\n', '\n', '    \n', '    /**\n', '     * The constructor of the contract.\n', '     * @param testToEtherRate Number of test per ether\n', '     * @param beneficiaryAddr Address where funds are collected\n', '     */\n', '    function Technology5GCrowdsale(\n', '        uint256 testToEtherRate, \n', '        address beneficiaryAddr, \n', '        address tokenAddress\n', '    ) public {\n', '        require(testToEtherRate > 0);\n', '        require(beneficiaryAddr != address(0));\n', '        require(tokenAddress != address(0));\n', '\n', '        token = Technology5G(tokenAddress);\n', '        rate = testToEtherRate;\n', '        beneficiary = beneficiaryAddr;\n', '        stage = Stages.Setup;\n', '    }\n', '\n', '    /**\n', '     * Fallback function can be used to buy tokens\n', '     */\n', '    function () public payable {\n', '        buy();\n', '    }\n', '\n', '    /**\n', '     * Withdraw available ethers into beneficiary account, serves as a safety, should never be needed\n', '     */\n', '    function ownerSafeWithdrawal() external onlyOwner {\n', '        beneficiary.transfer(this.balance);\n', '    }\n', '\n', '    function updateRate(uint256 bouToEtherRate) public onlyOwner atStage(Stages.Setup) {\n', '        rate = bouToEtherRate;\n', '    }\n', '\n', '    /**\n', '     * Whitelist participant address \n', '     * \n', '     * \n', '     * @param users Array of addresses to be whitelisted\n', '     */\n', '    function whitelist(address[] users) public onlyOwner {\n', '        for (uint32 i = 0; i < users.length; i++) {\n', '            whitelists[users[i]] = true;\n', '        }\n', '    }\n', '    function whitelistRemove(address user) public onlyOwner{\n', '      require(whitelists[user]);\n', '      whitelists[user] = false;\n', '    }\n', '    /**\n', '     * Start the offering\n', '     *\n', '     * @param durationInSeconds Extra duration of the offering on top of the minimum 4 hours\n', '     */\n', '    function startOffering(uint256 durationInSeconds) public onlyOwner atStage(Stages.Setup) {\n', '        stage = Stages.OfferingStarted;\n', '        startTime = now;\n', '        capReleaseTimestamp = startTime + 5 hours;\n', '        extraTime = capReleaseTimestamp + 7 days;\n', '        endTime = extraTime.add(durationInSeconds);\n', '        OfferingOpens(startTime, endTime);\n', '    }\n', '\n', '    /**\n', '     * End the offering\n', '     */\n', '    function endOffering() public onlyOwner atStage(Stages.OfferingStarted) {\n', '        endOfferingImpl();\n', '    }\n', '    \n', '  \n', '    /**\n', '     * Function to invest ether to buy tokens, can be called directly or called by the fallback function\n', '     * Only whitelisted users can buy tokens.\n', '     *\n', '     * @return bool Return true if purchase succeeds, false otherwise\n', '     */\n', '    function buy() public payable whenNotPaused atStage(Stages.OfferingStarted) returns (bool) {\n', '        if (whitelists[msg.sender]) {\n', '              buyTokens();\n', '              return true;\n', '        }\n', '        revert();\n', '    }\n', '\n', '    /**\n', '     * Function that returns whether offering has ended\n', '     * \n', '     * @return bool Return true if token offering has ended\n', '     */\n', '    function hasEnded() public view returns (bool) {\n', '        return now > endTime || stage == Stages.OfferingEnded;\n', '    }\n', '\n', '    /**\n', '     * Modifier that validates a purchase at a tier\n', '     * All the following has to be met:\n', '     * - current time within the offering period\n', '     * - valid sender address and ether value greater than 0.1\n', '     * - total Wei raised not greater than FUNDING_ETH_HARD_CAP\n', '     * - contribution per perticipant within contribution limit\n', '     *\n', '     * \n', '     */\n', '    modifier validPurchase() {\n', '        require(now >= startTime && now <= endTime && stage == Stages.OfferingStarted);\n', '        if(now > capReleaseTimestamp) {\n', '          maxContribution = 24000 * 1 ether;\n', '        }\n', '        uint256 contributionInWei = msg.value;\n', '        address participant = msg.sender; \n', '\n', '\n', '        require(contributionInWei <= maxContribution.sub(contributions[participant]));\n', '        require(participant != address(0) && contributionInWei >= minContribution && contributionInWei <= maxContribution);\n', '        require(weiRaised.add(contributionInWei) <= FUNDING_ETH_HARD_CAP);\n', '        \n', '        _;\n', '    }\n', '\n', '\n', '    function buyTokens() internal validPurchase {\n', '      \n', '        uint256 contributionInWei = msg.value;\n', '        address participant = msg.sender;\n', '\n', '        // Calculate token amount to be distributed\n', '        uint256 tokens = contributionInWei.mul(rate);\n', '        \n', '        if (!token.transferFrom(token.owner(), participant, tokens)) {\n', '            revert();\n', '        }\n', '\n', '        weiRaised = weiRaised.add(contributionInWei);\n', '        contributions[participant] = contributions[participant].add(contributionInWei);\n', '\n', '        remainCap = FUNDING_ETH_HARD_CAP.sub(weiRaised);\n', '\n', '        \n', '        // Check if the funding cap has been reached, end the offering if so\n', '        if (weiRaised >= FUNDING_ETH_HARD_CAP) {\n', '            endOfferingImpl();\n', '        }\n', '        \n', '        // Transfer funds to beneficiary\n', '        beneficiary.transfer(contributionInWei);\n', '        TokenPurchase(msg.sender, contributionInWei, tokens);       \n', '    }\n', '\n', '\n', '    /**\n', '     * End token offering by set the stage and endTime\n', '     */\n', '    function endOfferingImpl() internal {\n', '        endTime = now;\n', '        stage = Stages.OfferingEnded;\n', '        OfferingCloses(endTime, weiRaised);\n', '    }\n', '\n', '    /**\n', '     * Allocate tokens for presale participants before public offering, can only be executed at Stages.Setup stage.\n', '     *\n', '     * @param to Participant address to send docks to\n', '     * @param tokens Amount of docks to be sent to parcitipant \n', '     */\n', '    function allocateTokensBeforeOffering(address to, uint256 tokens) public onlyOwner atStage(Stages.Setup) returns (bool) {\n', '        if (!token.transferFrom(token.owner(), to, tokens)) {\n', '            revert();\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Bulk version of allocateTokensBeforeOffering\n', '     */\n', '    function batchAllocateTokensBeforeOffering(address[] toList, uint256[] tokensList) external onlyOwner  atStage(Stages.Setup)  returns (bool)  {\n', '        require(toList.length == tokensList.length);\n', '\n', '        for (uint32 i = 0; i < toList.length; i++) {\n', '            allocateTokensBeforeOffering(toList[i], tokensList[i]);\n', '        }\n', '        return true;\n', '    }\n', '\n', '}']
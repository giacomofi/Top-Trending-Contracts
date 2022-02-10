['pragma solidity 0.4.20;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract LongevityToken is StandardToken {\n', '    string public name = "Longevity";\n', '    string public symbol = "LTY";\n', '    uint8 public decimals = 2;\n', '    uint256 public cap = 2**256 - 1; // maximum possible uint256. Decreased on finalization\n', '    bool public mintingFinished = false;\n', '    mapping (address => bool) owners;\n', '    mapping (address => bool) minters;\n', '    // tap to limit mint speed\n', '    struct Tap {\n', '        uint256 startTime; // reference time point to start measuring\n', '        uint256 tokensIssued; // how much tokens issued from startTime\n', '        uint256 mintSpeed; // token fractions per second\n', '    }\n', '    Tap public mintTap;\n', '    bool public capFinalized = false;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '    event OwnerAdded(address indexed newOwner);\n', '    event OwnerRemoved(address indexed removedOwner);\n', '    event MinterAdded(address indexed newMinter);\n', '    event MinterRemoved(address indexed removedMinter);\n', '    event Burn(address indexed burner, uint256 value);\n', '    event MintTapSet(uint256 startTime, uint256 mintSpeed);\n', '    event SetCap(uint256 currectTotalSupply, uint256 cap);\n', '\n', '    function LongevityToken() public {\n', '        owners[msg.sender] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount) onlyMinter public returns (bool) {\n', '        require(!mintingFinished);\n', '        require(totalSupply.add(_amount) <= cap);\n', '        passThroughTap(_amount);\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyOwner public returns (bool) {\n', '        require(!mintingFinished);\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Adds administrative role to address\n', '     * @param _address The address that will get administrative privileges\n', '     */\n', '    function addOwner(address _address) onlyOwner public {\n', '        owners[_address] = true;\n', '        OwnerAdded(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Removes administrative role from address\n', '     * @param _address The address to remove administrative privileges from\n', '     */\n', '    function delOwner(address _address) onlyOwner public {\n', '        owners[_address] = false;\n', '        OwnerRemoved(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owners[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds minter role to address (able to create new tokens)\n', '     * @param _address The address that will get minter privileges\n', '     */\n', '    function addMinter(address _address) onlyOwner public {\n', '        minters[_address] = true;\n', '        MinterAdded(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Removes minter role from address\n', '     * @param _address The address to remove minter privileges\n', '     */\n', '    function delMinter(address _address) onlyOwner public {\n', '        minters[_address] = false;\n', '        MinterRemoved(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the minter.\n', '     */\n', '    modifier onlyMinter() {\n', '        require(minters[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev passThroughTap allows minting tokens within the defined speed limit.\n', '     * Throws if requested more than allowed.\n', '     */\n', '    function passThroughTap(uint256 _tokensRequested) internal {\n', '        require(_tokensRequested <= getTapRemaining());\n', '        mintTap.tokensIssued = mintTap.tokensIssued.add(_tokensRequested);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns remaining amount of tokens allowed at the moment\n', '     */\n', '    function getTapRemaining() public view returns (uint256) {\n', '        uint256 tapTime = now.sub(mintTap.startTime).add(1);\n', '        uint256 totalTokensAllowed = tapTime.mul(mintTap.mintSpeed);\n', '        uint256 tokensRemaining = totalTokensAllowed.sub(mintTap.tokensIssued);\n', '        return tokensRemaining;\n', '    }\n', '\n', '    /**\n', '     * @dev (Re)sets mint tap parameters\n', '     * @param _mintSpeed Allowed token amount to mint per second\n', '     */\n', '    function setMintTap(uint256 _mintSpeed) onlyOwner public {\n', '        mintTap.startTime = now;\n', '        mintTap.tokensIssued = 0;\n', '        mintTap.mintSpeed = _mintSpeed;\n', '        MintTapSet(mintTap.startTime, mintTap.mintSpeed);\n', '    }\n', '    /**\n', '     * @dev sets token Cap (maximum possible totalSupply) on Crowdsale finalization\n', '     * Cap will be set to (sold tokens + team tokens) * 2\n', '     */\n', '    function setCap() onlyOwner public {\n', '        require(!capFinalized);\n', '        require(cap == 2**256 - 1);\n', '        cap = totalSupply.mul(2);\n', '        capFinalized = true;\n', '        SetCap(totalSupply, cap);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title LongevityCrowdsale\n', ' * @dev LongevityCrowdsale is a contract for managing a token crowdsale for Longevity project.\n', ' * Crowdsale have phases with start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate and bonuses. Collected funds are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract LongevityCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    // The token being sold\n', '    LongevityToken public token;\n', '\n', '    // Crowdsale administrators\n', '    mapping (address => bool) public owners;\n', '\n', '    // External bots updating rates\n', '    mapping (address => bool) public bots;\n', '\n', '    // Cashiers responsible for manual token issuance\n', '    mapping (address => bool) public cashiers;\n', '\n', '    // USD cents per ETH exchange rate\n', '    uint256 public rateUSDcETH;\n', '\n', '    // Phases list, see schedule in constructor\n', '    mapping (uint => Phase) phases;\n', '\n', '    // The total number of phases\n', '    uint public totalPhases = 0;\n', '\n', '    // Description for each phase\n', '    struct Phase {\n', '        uint256 startTime;\n', '        uint256 endTime;\n', '        uint256 bonusPercent;\n', '    }\n', '\n', '    // Minimum Deposit in USD cents\n', '    uint256 public constant minContributionUSDc = 1000;\n', '\n', '    bool public finalized = false;\n', '\n', '    // Amount of raised Ethers (in wei).\n', '    // And raised Dollars in cents\n', '    uint256 public weiRaised;\n', '    uint256 public USDcRaised;\n', '\n', '    // Wallets management\n', '    address[] public wallets;\n', '    mapping (address => bool) inList;\n', '\n', '    /**\n', '     * event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param bonusPercent free tokens percantage for the phase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 bonusPercent, uint256 amount);\n', '    event OffChainTokenPurchase(address indexed beneficiary, uint256 tokensSold, uint256 USDcAmount);\n', '\n', '    // event for rate update logging\n', '    event RateUpdate(uint256 rate);\n', '\n', '    // event for wallet update\n', '    event WalletAdded(address indexed wallet);\n', '    event WalletRemoved(address indexed wallet);\n', '\n', '    // owners management events\n', '    event OwnerAdded(address indexed newOwner);\n', '    event OwnerRemoved(address indexed removedOwner);\n', '\n', '    // bot management events\n', '    event BotAdded(address indexed newBot);\n', '    event BotRemoved(address indexed removedBot);\n', '\n', '    // cashier management events\n', '    event CashierAdded(address indexed newBot);\n', '    event CashierRemoved(address indexed removedBot);\n', '\n', '    // Phase edit events\n', '    event TotalPhasesChanged(uint value);\n', '    event SetPhase(uint index, uint256 _startTime, uint256 _endTime, uint256 _bonusPercent);\n', '    event DelPhase(uint index);\n', '\n', '    function LongevityCrowdsale(address _tokenAddress, uint256 _initialRate) public {\n', '        require(_tokenAddress != address(0));\n', '        token = LongevityToken(_tokenAddress);\n', '        rateUSDcETH = _initialRate;\n', '        owners[msg.sender] = true;\n', '        bots[msg.sender] = true;\n', '        phases[0].bonusPercent = 40;\n', '        phases[0].startTime = 1520453700;\n', '        phases[0].endTime = 1520460000;\n', '\n', '        addWallet(msg.sender);\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address beneficiary) public payable {\n', '        require(beneficiary != address(0));\n', '        require(msg.value != 0);\n', '        require(isInPhase(now));\n', '\n', '        uint256 currentBonusPercent = getBonusPercent(now);\n', '\n', '        uint256 weiAmount = msg.value;\n', '\n', '        require(calculateUSDcValue(weiAmount) >= minContributionUSDc);\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = calculateTokenAmount(weiAmount, currentBonusPercent);\n', '        \n', '        weiRaised = weiRaised.add(weiAmount);\n', '        USDcRaised = USDcRaised.add(calculateUSDcValue(weiRaised));\n', '\n', '        token.mint(beneficiary, tokens);\n', '        TokenPurchase(msg.sender, beneficiary, weiAmount, currentBonusPercent, tokens);\n', '\n', '        forwardFunds();\n', '    }\n', '\n', '    // Sell any amount of tokens for cash or CryptoCurrency\n', '    function offChainPurchase(address beneficiary, uint256 tokensSold, uint256 USDcAmount) onlyCashier public {\n', '        require(beneficiary != address(0));\n', '        USDcRaised = USDcRaised.add(USDcAmount);\n', '        token.mint(beneficiary, tokensSold);\n', '        OffChainTokenPurchase(beneficiary, tokensSold, USDcAmount);\n', '    }\n', '\n', '    // If phase exists return corresponding bonus for the given date\n', '    // else return 0 (percent)\n', '    function getBonusPercent(uint256 datetime) public view returns (uint256) {\n', '        require(isInPhase(datetime));\n', '        for (uint i = 0; i < totalPhases; i++) {\n', '            if (datetime >= phases[i].startTime && datetime <= phases[i].endTime) {\n', '                return phases[i].bonusPercent;\n', '            }\n', '        }\n', '    }\n', '\n', '    // If phase exists for the given date return true\n', '    function isInPhase(uint256 datetime) public view returns (bool) {\n', '        for (uint i = 0; i < totalPhases; i++) {\n', '            if (datetime >= phases[i].startTime && datetime <= phases[i].endTime) {\n', '                return true;\n', '            }\n', '        }\n', '    }\n', '\n', '    // set rate\n', '    function setRate(uint256 _rateUSDcETH) public onlyBot {\n', '        // don&#39;t allow to change rate more than 10%\n', '        assert(_rateUSDcETH < rateUSDcETH.mul(110).div(100));\n', '        assert(_rateUSDcETH > rateUSDcETH.mul(90).div(100));\n', '        rateUSDcETH = _rateUSDcETH;\n', '        RateUpdate(rateUSDcETH);\n', '    }\n', '\n', '    /**\n', '     * @dev Adds administrative role to address\n', '     * @param _address The address that will get administrative privileges\n', '     */\n', '    function addOwner(address _address) onlyOwner public {\n', '        owners[_address] = true;\n', '        OwnerAdded(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Removes administrative role from address\n', '     * @param _address The address to remove administrative privileges from\n', '     */\n', '    function delOwner(address _address) onlyOwner public {\n', '        owners[_address] = false;\n', '        OwnerRemoved(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owners[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds rate updating bot\n', '     * @param _address The address of the rate bot\n', '     */\n', '    function addBot(address _address) onlyOwner public {\n', '        bots[_address] = true;\n', '        BotAdded(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Removes rate updating bot address\n', '     * @param _address The address of the rate bot\n', '     */\n', '    function delBot(address _address) onlyOwner public {\n', '        bots[_address] = false;\n', '        BotRemoved(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the bot.\n', '     */\n', '    modifier onlyBot() {\n', '        require(bots[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds cashier account responsible for manual token issuance\n', '     * @param _address The address of the Cashier\n', '     */\n', '    function addCashier(address _address) onlyOwner public {\n', '        cashiers[_address] = true;\n', '        CashierAdded(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Removes cashier account responsible for manual token issuance\n', '     * @param _address The address of the Cashier\n', '     */\n', '    function delCashier(address _address) onlyOwner public {\n', '        cashiers[_address] = false;\n', '        CashierRemoved(_address);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than Cashier.\n', '     */\n', '    modifier onlyCashier() {\n', '        require(cashiers[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    // calculate deposit value in USD Cents\n', '    function calculateUSDcValue(uint256 _weiDeposit) public view returns (uint256) {\n', '\n', '        // wei per USD cent\n', '        uint256 weiPerUSDc = 1 ether/rateUSDcETH;\n', '\n', '        // Deposited value converted to USD cents\n', '        uint256 depositValueInUSDc = _weiDeposit.div(weiPerUSDc);\n', '        return depositValueInUSDc;\n', '    }\n', '\n', '    // calculates how much tokens will beneficiary get\n', '    // for given amount of wei\n', '    function calculateTokenAmount(uint256 _weiDeposit, uint256 _bonusTokensPercent) public view returns (uint256) {\n', '        uint256 mainTokens = calculateUSDcValue(_weiDeposit);\n', '        uint256 bonusTokens = mainTokens.mul(_bonusTokensPercent).div(100);\n', '        return mainTokens.add(bonusTokens);\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    function forwardFunds() internal {\n', '        uint256 value = msg.value / wallets.length;\n', '        uint256 rest = msg.value - (value * wallets.length);\n', '        for (uint i = 0; i < wallets.length - 1; i++) {\n', '            wallets[i].transfer(value);\n', '        }\n', '        wallets[wallets.length - 1].transfer(value + rest);\n', '    }\n', '\n', '    // Add wallet address to wallets list\n', '    function addWallet(address _address) onlyOwner public {\n', '        require(!inList[_address]);\n', '        wallets.push(_address);\n', '        inList[_address] = true;\n', '        WalletAdded(_address);\n', '    }\n', '\n', '    //Change number of phases\n', '    function setTotalPhases(uint value) onlyOwner public {\n', '        totalPhases = value;\n', '        TotalPhasesChanged(value);\n', '    }\n', '\n', '    // Set phase: index and values\n', '    function setPhase(uint index, uint256 _startTime, uint256 _endTime, uint256 _bonusPercent) onlyOwner public {\n', '        require(index <= totalPhases);\n', '        phases[index] = Phase(_startTime, _endTime, _bonusPercent);\n', '        SetPhase(index, _startTime, _endTime, _bonusPercent);\n', '    }\n', '\n', '    // Delete phase\n', '    function delPhase(uint index) onlyOwner public {\n', '        require(index <= totalPhases);\n', '        delete phases[index];\n', '        DelPhase(index);\n', '    }\n', '\n', '    // Delete wallet from wallets list\n', '    function delWallet(uint index) onlyOwner public {\n', '        require(index < wallets.length);\n', '        address remove = wallets[index];\n', '        inList[remove] = false;\n', '        for (uint i = index; i < wallets.length-1; i++) {\n', '            wallets[i] = wallets[i+1];\n', '        }\n', '        wallets.length--;\n', '        WalletRemoved(remove);\n', '    }\n', '\n', '    // Return wallets array size\n', '    function getWalletsCount() public view returns (uint256) {\n', '        return wallets.length;\n', '    }\n', '\n', '    // finalizeCrowdsale issues tokens for the Team.\n', '    // Team gets 30/70 of harvested funds then token gets capped (upper emission boundary locked) to totalSupply * 2\n', '    // The token split after finalization will be in % of total token cap:\n', '    // 1. Tokens issued and distributed during pre-ICO and ICO = 35%\n', '    // 2. Tokens issued for the team on ICO finalization = 30%\n', '    // 3. Tokens for future in-app emission = 35%\n', '    function finalizeCrowdsale(address _teamAccount) onlyOwner public {\n', '        require(!finalized);\n', '        uint256 soldTokens = token.totalSupply();\n', '        uint256 teamTokens = soldTokens.div(70).mul(30);\n', '        token.mint(_teamAccount, teamTokens);\n', '        token.setCap();\n', '        finalized = true;\n', '    }\n', '}']
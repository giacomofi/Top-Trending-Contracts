['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    require(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // require(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // require(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', '/*****\n', '* @title The DADI Public sale Contract\n', '*/\n', 'contract DadiPublicSale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    StandardToken public token;                         // The DADI ERC20 token */\n', '\n', '    uint256 public tokenSupply;\n', '    uint256 public tokensPurchased = 0;\n', '    uint256 public individualCap = 5000 * 1000;         // USD$5,000\n', '    uint256 public tokenPrice = 500;                    // USD$0.50\n', '    uint256 public ethRate;                             // ETH to USD Rate, set by owner: 1 ETH = ethRate USD\n', '    uint256 public maxGasPrice;                         // Max gas price for contributing transactions.\n', ' \n', '    address[] public saleWallets;\n', '    mapping(address => Investor) private investors;\n', '    address[] private investorIndex;\n', '\n', '    struct Investor {\n', '      uint256 tokens;\n', '      uint256 contribution;\n', '      bool distributed;\n', '      uint index;\n', '    }\n', '\n', '    /*****\n', '    * State for Sale Modes\n', '    *  0 - Preparing:            All contract initialization calls\n', '    *  1 - PublicSale:           Contract is in the Sale Period\n', '    *  2 - PublicSaleFinalized   Sale period is finalized, no more payments are allowed\n', '    *  3 - Success:              Sale Successful\n', '    *  4 - TokenDistribution:    Ssale finished, tokens can be distributed\n', '    *  5 - Closed:               Sale closed, no tokens more can be distributed\n', '    */\n', '    enum SaleState { Preparing, PublicSale, PublicSaleFinalized, Success, TokenDistribution, Closed }\n', '    SaleState public state = SaleState.Preparing;\n', '\n', '    event LogTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens);\n', '    event LogTokenDistribution(address recipient, uint256 tokens);\n', '    event LogRedistributeTokens(address recipient, SaleState _state, uint256 tokens);\n', '    event LogFundTransfer(address wallet, uint256 value);\n', '    event LogRefund(address wallet, uint256 value);\n', '    event LogStateChange(SaleState _state);\n', '\n', '    /*****\n', '    * @dev Modifier to check that amount transferred is not 0\n', '    */\n', '    modifier nonZero() {\n', '        require(msg.value != 0);\n', '        _;\n', '    }\n', '\n', '    /*****\n', '    * @dev The constructor function to initialize the Public sale\n', '    * @param _token                         address   the address of the ERC20 token for the sale\n', '    * @param _tokenSupply                   uint256   the amount of tokens available\n', '    */\n', '    function DadiPublicSale (StandardToken _token, uint256 _tokenSupply) public {\n', '        require(_token != address(0));\n', '        require(_tokenSupply != 0);\n', '\n', '        token = StandardToken(_token);\n', '        tokenSupply = _tokenSupply * (uint256(10) ** 18);\n', '        maxGasPrice = 60000000000;       // 60 Gwei\n', '    }\n', '\n', '    /*****\n', '    * @dev Fallback Function to buy the tokens\n', '    */\n', '    function () public nonZero payable {\n', '        require(state == SaleState.PublicSale);\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    /*****\n', '    * @dev Allows the contract owner to add a new distribution wallet, used to hold funds safely\n', '    * @param _wallet        address     The address of the wallet\n', '    * @return success       bool        Returns true if executed successfully\n', '    */\n', '    function addSaleWallet (address _wallet) public onlyOwner returns (bool) {\n', '        require(_wallet != address(0));\n', '\n', '        saleWallets.push(_wallet);\n', '        return true;\n', '    }\n', '\n', '    /*****\n', '    * @dev Calculates the number of tokens that can be bought for the amount of Wei transferred\n', '    * @param _amount    uint256     The amount of money invested by the investor\n', '    * @return tokens    uint256     The number of tokens purchased for the amount invested\n', '    */\n', '    function calculateTokens (uint256 _amount) public constant returns (uint256 tokens) {\n', '        tokens = _amount * ethRate / tokenPrice;\n', '        return tokens;\n', '    }\n', '\n', '    /*****\n', '    * @dev Called by the owner of the contract to modify the sale state\n', '    */\n', '    function setState (uint256 _state) public onlyOwner {\n', '        state = SaleState(uint(_state));\n', '        LogStateChange(state);\n', '    }\n', '\n', '    /*****\n', '    * @dev Called by the owner of the contract to start the Public sale\n', '    * @param rate   uint256  the current ETH USD rate, multiplied by 1000\n', '    */\n', '    function startPublicSale (uint256 rate) public onlyOwner {\n', '        state = SaleState.PublicSale;\n', '        updateEthRate(rate);\n', '        LogStateChange(state);\n', '    }\n', '\n', '    /*****\n', '    * @dev Allow updating the ETH USD exchange rate\n', '    * @param rate   uint256  the current ETH USD rate, multiplied by 1000\n', '    * @return bool  Return true if successful\n', '    */\n', '    function updateEthRate (uint256 rate) public onlyOwner returns (bool) {\n', '        require(rate >= 100000);\n', '        \n', '        ethRate = rate;\n', '        return true;\n', '    }\n', '\n', '    /*****\n', '    * @dev Allow updating the max gas price\n', '    * @param _maxGasPrice   uint256  the maximum gas price for a transaction, in Gwei\n', '    */\n', '    function updateMaxGasPrice(uint256 _maxGasPrice) public onlyOwner {\n', '        require(_maxGasPrice > 0);\n', '\n', '        maxGasPrice = _maxGasPrice;\n', '    }\n', '\n', '    /*****\n', '    * @dev Allows transfer of tokens to a recipient who has purchased offline, during the PublicSale\n', '    * @param _recipient     address     The address of the recipient of the tokens\n', '    * @param _tokens        uint256     The number of tokens purchased by the recipient\n', '    * @return success       bool        Returns true if executed successfully\n', '    */\n', '    function offlineTransaction (address _recipient, uint256 _tokens) public onlyOwner returns (bool) {\n', '        require(_tokens > 0);\n', '\n', '        // Convert to a token with decimals \n', '        uint256 tokens = _tokens * (uint256(10) ** uint8(18));\n', '\n', '        // if the number of tokens is greater than available, reject tx\n', '        if (tokens >= getTokensAvailable()) {\n', '            revert();\n', '        }\n', '\n', '        addToInvestor(_recipient, 0, tokens);\n', '\n', '        // Increase the count of tokens purchased in the sale\n', '        updateSaleParameters(tokens);\n', '\n', '        LogTokenPurchase(msg.sender, _recipient, 0, tokens);\n', '\n', '        return true;\n', '    }\n', '\n', '    /*****\n', '    * @dev Called by the owner of the contract to finalize the ICO\n', '    *      and redistribute funds (if any)\n', '    */\n', '    function finalizeSale () public onlyOwner {\n', '        state = SaleState.Success;\n', '        LogStateChange(state);\n', '\n', '        // Transfer any ETH to one of the sale wallets\n', '        if (this.balance > 0) {\n', '            forwardFunds(this.balance);\n', '        }\n', '    }\n', '\n', '    /*****\n', '    * @dev Called by the owner of the contract to close the Sale and redistribute any crumbs.\n', '    * @param recipient     address     The address of the recipient of the tokens\n', '    */\n', '    function closeSale (address recipient) public onlyOwner {\n', '        state = SaleState.Closed;\n', '        LogStateChange(state);\n', '\n', '        // redistribute unsold tokens to DADI ecosystem\n', '        uint256 remaining = getTokensAvailable();\n', '        updateSaleParameters(remaining);\n', '\n', '        if (remaining > 0) {\n', '            token.transfer(recipient, remaining);\n', '            LogRedistributeTokens(recipient, state, remaining);\n', '        }\n', '    }\n', '\n', '    /*****\n', '    * @dev Called by the owner of the contract to allow tokens to be distributed\n', '    */\n', '    function setTokenDistribution () public onlyOwner {\n', '        state = SaleState.TokenDistribution;\n', '        LogStateChange(state);\n', '    }\n', '\n', '    /*****\n', '    * @dev Called by the owner of the contract to distribute tokens to investors\n', '    * @param _address       address     The address of the investor for which to distribute tokens\n', '    * @return success       bool        Returns true if executed successfully\n', '    */\n', '    function distributeTokens (address _address) public onlyOwner returns (bool) {\n', '        require(state == SaleState.TokenDistribution);\n', '        \n', '        // get the tokens available for the investor\n', '        uint256 tokens = investors[_address].tokens;\n', '        require(tokens > 0);\n', '\n', '        require(investors[_address].distributed == false);\n', '\n', '        investors[_address].distributed = true;\n', '        // investors[_address].tokens = 0;\n', '        // investors[_address].contribution = 0;\n', '\n', '        token.transfer(_address, tokens);\n', '      \n', '        LogTokenDistribution(_address, tokens);\n', '        return true;\n', '    }\n', '\n', '    /*****\n', '    * @dev Called by the owner of the contract to distribute tokens to investors who used a non-ERC20 wallet address\n', '    * @param _purchaseAddress        address     The address the investor used to buy tokens\n', '    * @param _tokenAddress           address     The address to send the tokens to\n', '    * @return success                bool        Returns true if executed successfully\n', '    */\n', '    function distributeToAlternateAddress (address _purchaseAddress, address _tokenAddress) public onlyOwner returns (bool) {\n', '        require(state == SaleState.TokenDistribution);\n', '        \n', '        // get the tokens available for the investor\n', '        uint256 tokens = investors[_purchaseAddress].tokens;\n', '        require(tokens > 0);\n', '\n', '        require(investors[_purchaseAddress].distributed == false);\n', '\n', '        investors[_purchaseAddress].distributed = true;\n', '\n', '        token.transfer(_tokenAddress, tokens);\n', '      \n', '        LogTokenDistribution(_tokenAddress, tokens);\n', '        return true;\n', '    }\n', '\n', '    /*****\n', '    * @dev Called by the owner of the contract to redistribute tokens if an investor has been refunded offline\n', '    * @param investorAddress         address     The address the investor used to buy tokens\n', '    * @param recipient               address     The address to send the tokens to\n', '    */\n', '    function redistributeTokens (address investorAddress, address recipient) public onlyOwner {\n', '        uint256 tokens = investors[investorAddress].tokens;\n', '        require(tokens > 0);\n', '        require(investors[investorAddress].distributed == false);\n', '        \n', "        // remove tokens, so they can't be redistributed\n", '        // investors[investorAddress].tokens = 0;\n', '        investors[investorAddress].distributed = true;\n', '        token.transfer(recipient, tokens);\n', '\n', '        LogRedistributeTokens(recipient, state, tokens);\n', '    }\n', '\n', '    /*****\n', '    * @dev Get the amount of tokens left for purchase\n', '    * @return uint256 the count of tokens available\n', '    */\n', '    function getTokensAvailable () public constant returns (uint256) {\n', '        return tokenSupply - tokensPurchased;\n', '    }\n', '\n', '    /*****\n', '    * @dev Get the total count of tokens purchased\n', '    * @return uint256 the count of tokens purchased\n', '    */\n', '    function getTokensPurchased () public constant returns (uint256) {\n', '        return tokensPurchased;\n', '    }\n', '\n', '    /*****\n', '    * @dev Converts an amount sent in Wei to the equivalent in USD\n', '    * @param _amount      uint256       the amount sent to the contract, in Wei\n', '    * @return uint256  the amount sent to this contract, in USD\n', '    */\n', '    function ethToUsd (uint256 _amount) public constant returns (uint256) {\n', '        return (_amount * ethRate) / (uint256(10) ** 18);\n', '    }\n', '\n', '    /*****\n', '    * @dev Get count of contributors\n', '    * @return uint     the number of unique contributors\n', '    */\n', '    function getInvestorCount () public constant returns (uint count) {\n', '        return investorIndex.length;\n', '    }\n', '\n', '    /*****\n', '    * @dev Get an investor\n', '    * @param _address      address       the wallet address of the investor\n', '    * @return uint256  the amount contributed by the user\n', '    * @return uint256  the number of tokens assigned to the user\n', '    * @return uint     the index of the user\n', '    */\n', '    function getInvestor (address _address) public constant returns (uint256 contribution, uint256 tokens, bool distributed, uint index) {\n', '        require(isInvested(_address));\n', '        return(investors[_address].contribution, investors[_address].tokens, investors[_address].distributed, investors[_address].index);\n', '    }\n', '\n', '    /*****\n', "    * @dev Get a user's invested state\n", '    * @param _address      address       the wallet address of the user\n', '    * @return bool  true if the user has already contributed\n', '    */\n', '    function isInvested (address _address) internal constant returns (bool isIndeed) {\n', '        if (investorIndex.length == 0) return false;\n', '        return (investorIndex[investors[_address].index] == _address);\n', '    }\n', '\n', '    /*****\n', "    * @dev Update a user's invested state\n", '    * @param _address      address       the wallet address of the user\n', '    * @param _value        uint256       the amount contributed in this transaction\n', '    * @param _tokens       uint256       the number of tokens assigned in this transaction\n', '    */\n', '    function addToInvestor(address _address, uint256 _value, uint256 _tokens) internal {\n', '        // add the user to the investorIndex if this is their first contribution\n', '        if (!isInvested(_address)) {\n', '            investors[_address].index = investorIndex.push(_address) - 1;\n', '        }\n', '      \n', '        investors[_address].tokens = investors[_address].tokens.add(_tokens);\n', '        investors[_address].contribution = investors[_address].contribution.add(_value);\n', '        investors[_address].distributed = false;\n', '    }\n', '\n', '    /*****\n', '    * @dev Send ether to the sale collection wallets\n', '    */\n', '    function forwardFunds (uint256 _value) internal {\n', '        uint accountNumber;\n', '        address account;\n', '\n', '        // move funds to a random saleWallet\n', '        if (saleWallets.length > 0) {\n', '            accountNumber = getRandom(saleWallets.length) - 1;\n', '            account = saleWallets[accountNumber];\n', '            account.transfer(_value);\n', '            LogFundTransfer(account, _value);\n', '        }\n', '    }\n', '\n', '    /*****\n', '    * @dev Internal function to assign tokens to the contributor\n', '    * @param _address       address     The address of the contributing investor\n', '    * @param _value         uint256     The amount invested \n', '    * @return success       bool        Returns true if executed successfully\n', '    */\n', '    function buyTokens (address _address, uint256 _value) internal returns (bool) {\n', '        require(tx.gasprice <= maxGasPrice);\n', '\n', '        require(isValidContribution(_address, _value));\n', '\n', '        uint256 boughtTokens = calculateTokens(_value);\n', '        require(boughtTokens != 0);\n', '\n', '        // if the number of tokens calculated for the given value is \n', '        // greater than the tokens available, reject the payment\n', '        require(boughtTokens <= getTokensAvailable());\n', '\n', '        // update investor state\n', '        addToInvestor(_address, _value, boughtTokens);\n', '\n', '        forwardFunds(_value);\n', '\n', '        updateSaleParameters(boughtTokens);\n', '\n', '        LogTokenPurchase(msg.sender, _address, _value, boughtTokens);\n', '\n', '        return true;\n', '    }\n', '\n', '    /*****\n', '    * @dev Check that the amount sent in the transaction is below the individual cap\n', '    * Factors in previous transactions by the same investor\n', '    * @param _address         address     The address of the user making the transaction\n', '    * @param _amount          uint256     The amount sent in the transaction\n', '    * @return        bool        Returns true if the amount is valid\n', '    */\n', '    function isValidContribution (address _address, uint256 _amount) internal constant returns (bool valid) {\n', '        return isBelowCap(_amount + investors[_address].contribution); \n', '    }\n', '\n', '    /*****\n', '    * @dev Check that the amount sent in the transaction is below the individual cap\n', '    * @param _amount         uint256     The amount sent in the transaction\n', '    * @return        bool        Returns true if the amount is below the individual cap\n', '    */\n', '    function isBelowCap (uint256 _amount) internal constant returns (bool) {\n', '        return ethToUsd(_amount) < individualCap;\n', '    }\n', '\n', '    /*****\n', '    * @dev Generates a random number from 1 to max based on the last block hash\n', '    * @param max     uint  the maximum value \n', '    * @return a random number\n', '    */\n', '    function getRandom(uint max) internal constant returns (uint randomNumber) {\n', '        return (uint(keccak256(block.blockhash(block.number - 1))) % max) + 1;\n', '    }\n', '\n', '    /*****\n', '    * @dev Internal function to modify parameters based on tokens bought\n', '    * @param _tokens        uint256     The number of tokens purchased\n', '    */\n', '    function updateSaleParameters (uint256 _tokens) internal {\n', '        tokensPurchased = tokensPurchased.add(_tokens);\n', '    }\n', '}']
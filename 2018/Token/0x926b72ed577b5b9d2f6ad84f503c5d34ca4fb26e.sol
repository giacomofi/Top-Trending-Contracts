['pragma solidity ^0.4.17;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '    modifier onlyOwner(){\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '    modifier whenNotPaused() {\n', '        require (!paused);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '    modifier whenPaused {\n', '        require (paused);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '    function pause() onlyOwner whenNotPaused  public returns (bool) {\n', '        paused = true;\n', '        Pause();\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '    function unpause() onlyOwner whenPaused public returns (bool) {\n', '        paused = false;\n', '        Unpause();\n', '        return true;\n', '    }\n', '}\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '    mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '   */\n', '    function transfer(address _to, uint256 _value) public returns (bool){\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '   */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '   /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '  /**\n', '  * @dev Function to mint tokens\n', '  * @param _to The address that will recieve the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '   */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(0X0, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '  * @dev Function to stop minting new tokens.\n', '  * @return True if the operation was successful.\n', '   */\n', '    function finishMinting() onlyOwner public returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract ReporterToken is MintableToken, Pausable{\n', '    string public name = "Reporter Token";\n', '    string public symbol = "NEWS";\n', '    uint256 public decimals = 18;\n', '\n', '    bool public tradingStarted = false;\n', '\n', '  /**\n', '  * @dev modifier that throws if trading has not started yet\n', '   */\n', '    modifier hasStartedTrading() {\n', '        require(tradingStarted);\n', '        _;\n', '    }\n', '\n', '  /**\n', '  * @dev Allows the owner to enable the trading. This can not be undone\n', '  */\n', '    function startTrading() public onlyOwner {\n', '        tradingStarted = true;\n', '    }\n', '\n', '  /**\n', '   * @dev Allows anyone to transfer the Reporter tokens once trading has started\n', '   * @param _to the recipient address of the tokens.\n', '   * @param _value number of tokens to be transfered.\n', '   */\n', '    function transfer(address _to, uint _value) hasStartedTrading whenNotPaused public returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '  /**\n', '  * @dev Allows anyone to transfer the Reporter tokens once trading has started\n', '  * @param _from address The address which you want to send tokens from\n', '  * @param _to address The address which you want to transfer to\n', '  * @param _value uint the amout of tokens to be transfered\n', '   */\n', '    function transferFrom(address _from, address _to, uint _value) hasStartedTrading whenNotPaused public returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {\n', '        oddToken.transfer(owner, amount);\n', '    }\n', '}\n', '\n', 'contract ReporterTokenSale is Ownable, Pausable{\n', '    using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '    ReporterToken public token;\n', '\n', '    uint256 public decimals;  \n', '    uint256 public oneCoin;\n', '\n', '  // start and end block where investments are allowed (both inclusive)\n', '    uint256 public startTimestamp;\n', '    uint256 public endTimestamp;\n', '\n', '  // address where funds are collected\n', '    address public multiSig;\n', '\n', '    function setWallet(address _newWallet) public onlyOwner {\n', '        multiSig = _newWallet;\n', '    }\n', '\n', '  // These will be set by setTier()\n', '    uint256 public rate; // how many token units a buyer gets per wei\n', '    uint256 public minContribution = 0.0001 ether;  // minimum contributio to participate in tokensale\n', '    uint256 public maxContribution = 1000 ether;  // default limit to tokens that the users can buy\n', '\n', '  // ***************************\n', '\n', '  // amount of raised money in wei\n', '    uint256 public weiRaised;\n', '\n', '  // amount of raised tokens \n', '    uint256 public tokenRaised;\n', '\n', '  // maximum amount of tokens being created\n', '    uint256 public maxTokens;\n', '\n', '  // maximum amount of tokens for sale\n', '    uint256 public tokensForSale;  // 36 Million Tokens for SALE\n', '\n', '  // number of participants in presale\n', '    uint256 public numberOfPurchasers = 0;\n', '\n', '  //  for whitelist\n', '    address public cs;\n', '\n', ' //  for rate\n', '    uint public r;\n', '\n', '\n', '  // switch on/off the authorisation , default: false\n', '    bool  public freeForAll = false;\n', '\n', '    mapping (address => bool) public authorised; // just to annoy the heck out of americans\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '    event SaleClosed();\n', '\n', '    function ReporterTokenSale() public {\n', '        startTimestamp = 1508684400; // 22 Oct. 2017. 15:00 UTC\n', '        endTimestamp = 1529074800;   // (GMT): 2018. June 15., Friday 15:00:00\n', '        multiSig = 0xD00d085F125EAFEA9e8c5D3f4bc25e6D0c93Af0e;\n', '\n', '        token = new ReporterToken();\n', '        decimals = token.decimals();\n', '        oneCoin = 10 ** decimals;\n', '        maxTokens = 60 * (10**6) * oneCoin;\n', '        tokensForSale = 36 * (10**6) * oneCoin;\n', '        rate = 3000;\n', '    }\n', '\n', '    function currentTime() public constant returns (uint256) {\n', '        return now;\n', '    }\n', '  /**\n', '  * @dev Calculates the amount of bonus coins the buyer gets\n', '  */\n', '    function setTier(uint newR) internal {\n', '    // first 9M tokens get extra 42% of tokens, next half get 17%\n', '        if (tokenRaised <= 9000000 * oneCoin) {\n', '            rate = newR * 142/100;\n', '      //minContribution = 100 ether;\n', '      //maxContribution = 1000000 ether;\n', '    } else if (tokenRaised <= 18000000 * oneCoin) {\n', '        rate = newR * 117/100;\n', '      //minContribution = 5 ether;\n', '      //maxContribution = 1000000 ether;\n', '    } else {\n', '        rate = newR * 1;\n', '      //minContribution = 0.01 ether;\n', '      //maxContribution = 100 ether;\n', '    }\n', '    }\n', '\n', '  // @return true if crowdsale event has ended\n', '    function hasEnded() public constant returns (bool) {\n', '        if (currentTime() > endTimestamp)\n', '      return true;\n', '        if (tokenRaised >= tokensForSale)\n', '      return true; // if we reach the tokensForSale\n', '        return false;\n', '    }\n', '\n', '  /**\n', '  * @dev throws if person sending is not contract owner or cs role\n', '   */\n', '    modifier onlyCSorOwner() {\n', '        require((msg.sender == owner) || (msg.sender==cs));\n', '        _;\n', '    }\n', '    modifier onlyCS() {\n', '        require(msg.sender == cs);\n', '        _;\n', '    }\n', '\n', '  /**\n', '  * @dev throws if person sending is not authorised or sends nothing\n', '  */\n', '    modifier onlyAuthorised() {\n', '        require (authorised[msg.sender] || freeForAll);\n', '        require (currentTime() >= startTimestamp);\n', '        require (!hasEnded());\n', '        require (multiSig != 0x0);\n', '        require(tokensForSale > tokenRaised); // check we are not over the number of tokensForSale\n', '        _;\n', '    }\n', '\n', '  /**\n', '  * @dev authorise an account to participate\n', '  */\n', '    function authoriseAccount(address whom) onlyCSorOwner public {\n', '        authorised[whom] = true;\n', '    }\n', '\n', '  /**\n', '  * @dev authorise a lot of accounts in one go\n', '  */\n', '    function authoriseManyAccounts(address[] many) onlyCSorOwner public {\n', '        for (uint256 i = 0; i < many.length; i++) {\n', '            authorised[many[i]] = true;\n', '        }\n', '    }\n', '\n', '  /**\n', '  * @dev ban an account from participation (default)\n', '  */\n', '    function blockAccount(address whom) onlyCSorOwner public {\n', '        authorised[whom] = false;\n', '    }  \n', '    \n', '  /**\n', '  * @dev set a new CS representative\n', '  */\n', '    function setCS(address newCS) onlyOwner public {\n', '        cs = newCS;\n', '    }\n', '\n', '   /**\n', '  * @dev set a newRate if have a big different in ether/dollar rate \n', '  */\n', '    function setRate(uint newRate) onlyCS public {\n', '        require(0 < newRate && newRate <= 8000); \n', '        r = newRate;\n', '    }\n', '\n', '\n', '    function placeTokens(address beneficiary, uint256 _tokens) onlyCS public {\n', '    //check minimum and maximum amount\n', '        require(_tokens != 0);\n', '        require(!hasEnded());\n', '        uint256 amount = 0;\n', '        if (token.balanceOf(beneficiary) == 0) {\n', '            numberOfPurchasers++;\n', '        }\n', '        tokenRaised = tokenRaised.add(_tokens); // so we can go slightly over\n', '        token.mint(beneficiary, _tokens);\n', '        TokenPurchase(beneficiary, amount, _tokens);\n', '    }\n', '\n', '  // low level token purchase function\n', '    function buyTokens(address beneficiary, uint256 amount) onlyAuthorised whenNotPaused internal {\n', '\n', '        setTier(r);\n', '\n', '    //check minimum and maximum amount\n', '        require(amount >= minContribution);\n', '        require(amount <= maxContribution);\n', '\n', '    // calculate token amount to be created\n', '        uint256 tokens = amount.mul(rate);\n', '\n', '    // update state\n', '        weiRaised = weiRaised.add(amount);\n', '        if (token.balanceOf(beneficiary) == 0) {\n', '            numberOfPurchasers++;\n', '      }\n', '        tokenRaised = tokenRaised.add(tokens); // so we can go slightly over\n', '        token.mint(beneficiary, tokens);\n', '        TokenPurchase(beneficiary, amount, tokens);\n', '        multiSig.transfer(this.balance); // better in case any other ether ends up here\n', '    }\n', '\n', '  // transfer ownership of the token to the owner of the presale contract\n', '    function finishSale() public onlyOwner {\n', '        require(hasEnded());\n', '\n', '    // assign the rest of the 60M tokens to the reserve\n', '        uint unassigned;\n', '        if(maxTokens > tokenRaised) {\n', '            unassigned = maxTokens.sub(tokenRaised);\n', '            token.mint(multiSig,unassigned);\n', '    }\n', '        token.finishMinting();\n', '        token.transferOwnership(owner);\n', '        SaleClosed();\n', '    }\n', '\n', '  // fallback function can be used to buy tokens\n', '    function () public payable {\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {\n', '        oddToken.transfer(owner, amount);\n', '    }\n', '}']
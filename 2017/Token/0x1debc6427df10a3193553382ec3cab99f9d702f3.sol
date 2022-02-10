['pragma solidity ^0.4.13;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract STEAK is StandardToken {\n', '\n', '    uint256 public initialSupply;\n', '    // the original supply, just for posterity, since totalSupply\n', '    //  will decrement on burn\n', '\n', '    string public constant name   = "$TEAK";\n', '    string public constant symbol = "$TEAK";\n', '    // ^ whether or not to include the `$` here will probably be contested\n', "    //   but it's more important to me that the joke is obvious, even if it's overdone\n", '    //   by displaying as `$$TEAK`\n', '    uint8 public constant decimals = 18;\n', '    //  (^ can we please get around to standardizing on 18 decimals?)\n', '\n', '    address public tokenSaleContract;\n', '\n', '    modifier validDestination(address to)\n', '    {\n', '        require(to != address(this));\n', '        _;\n', '    }\n', '\n', '    function STEAK(uint tokenTotalAmount)\n', '    public\n', '    {\n', '        initialSupply = tokenTotalAmount * (10 ** uint256(decimals));\n', '        totalSupply = initialSupply;\n', '\n', '        // Mint all tokens to crowdsale.\n', '        balances[msg.sender] = totalSupply;\n', '        Transfer(address(0x0), msg.sender, totalSupply);\n', '\n', '        tokenSaleContract = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev override transfer token for a specified address to add validDestination\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */\n', '    function transfer(address _to, uint _value)\n', '        public\n', '        validDestination(_to)\n', '        returns (bool)\n', '    {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev override transferFrom token for a specified address to add validDestination\n', '     * @param _from The address to transfer from.\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value)\n', '        public\n', '        validDestination(_to)\n', '        returns (bool)\n', '    {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    event Burn(address indexed _burner, uint _value);\n', '\n', '    /**\n', '     * @dev burn tokens\n', '     * @param _value The amount to be burned.\n', '     * @return always true (necessary in case of override)\n', '     */\n', '    function burn(uint _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(msg.sender, _value);\n', '        Transfer(msg.sender, address(0x0), _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev burn tokens on the behalf of someone\n', '     * @param _from The address of the owner of the token.\n', '     * @param _value The amount to be burned.\n', '     * @return always true (necessary in case of override)\n', '     */\n', '    function burnFrom(address _from, uint256 _value)\n', '        public\n', '        returns(bool)\n', '    {\n', '        assert(transferFrom(_from, msg.sender, _value));\n', '        return burn(_value);\n', '    }\n', '}\n', '\n', 'contract StandardCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    // The token being sold\n', '    StandardToken public token; // Request Modification : change to not mintable\n', '\n', '    // start and end timestamps where investments are allowed (both inclusive)\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    // address where funds are collected\n', '    address public wallet;\n', '\n', '    // how many token units a buyer gets per wei\n', '    uint256 public rate;\n', '\n', '    // amount of raised money in wei\n', '    uint256 public weiRaised;\n', '\n', '    /**\n', '     * event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param value weis paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);\n', '\n', '    function StandardCrowdsale(\n', '        uint256 _startTime,\n', '        uint256 _endTime,\n', '        uint256 _rate,\n', '        address _wallet)\n', '        public\n', '    {\n', '        // require(_startTime >= now); // Steak Network Modification\n', '        require(_endTime >= _startTime);\n', '        require(_rate > 0);\n', '        require(_wallet != 0x0);\n', '\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        rate = _rate;\n', '        wallet = _wallet;\n', '\n', '        token = createTokenContract(); // Request Modification : change to StandardToken + position\n', '    }\n', '\n', '    // creates the token to be sold.\n', '    // Request Modification : change to StandardToken\n', '    // override this method to have crowdsale of a specific mintable token.\n', '    function createTokenContract()\n', '        internal\n', '        returns(StandardToken)\n', '    {\n', '        return new StandardToken();\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function ()\n', '        public\n', '        payable\n', '    {\n', '        buyTokens();\n', '    }\n', '\n', '    // low level token purchase function\n', '    // Request Modification : change to not mint but transfer from this contract\n', '    function buyTokens()\n', '        public\n', '        payable\n', '    {\n', '        require(validPurchase());\n', '\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = weiAmount.mul(rate);\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '\n', '        require(token.transfer(msg.sender, tokens)); // Request Modification : changed here - tranfer instead of mintable\n', '        TokenPurchase(msg.sender, weiAmount, tokens);\n', '\n', '        forwardFunds();\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    // override to create custom fund forwarding mechanisms\n', '    function forwardFunds()\n', '        internal\n', '    {\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '    // @return true if the transaction can buy tokens\n', '    function validPurchase()\n', '        internal\n', '        returns(bool)\n', '    {\n', '        bool withinPeriod = now >= startTime && now <= endTime;\n', '        bool nonZeroPurchase = msg.value != 0;\n', '        return withinPeriod && nonZeroPurchase;\n', '    }\n', '\n', '    // @return true if crowdsale event has ended\n', '    function hasEnded()\n', '        public\n', '        constant\n', '        returns(bool)\n', '    {\n', '        return now > endTime;\n', '    }\n', '\n', '    modifier onlyBeforeSale() {\n', '        require(now < startTime);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract CappedCrowdsale is StandardCrowdsale {\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public cap;\n', '\n', '  function CappedCrowdsale(uint256 _cap) public {\n', '    require(_cap > 0);\n', '    cap = _cap;\n', '  }\n', '\n', '  // overriding Crowdsale#validPurchase to add extra cap logic\n', '  // @return true if investors can buy at the moment\n', '  // Request Modification : delete constant because needed in son contract\n', '  function validPurchase() internal returns (bool) {\n', '    bool withinCap = weiRaised.add(msg.value) <= cap;\n', '    return super.validPurchase() && withinCap;\n', '  }\n', '\n', '  // overriding Crowdsale#hasEnded to add cap logic\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    bool capReached = weiRaised >= cap;\n', '    return super.hasEnded() || capReached;\n', '  }\n', '\n', '}\n', '\n', 'contract InfiniteCappedCrowdsale is StandardCrowdsale, CappedCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '        @param _cap the maximum number of tokens\n', '        @param _rate tokens per wei received\n', '        @param _wallet the wallet that receives the funds\n', '     */\n', '    function InfiniteCappedCrowdsale(uint256 _cap, uint256 _rate, address _wallet)\n', '        CappedCrowdsale(_cap)\n', '        StandardCrowdsale(0, uint256(int256(-1)), _rate, _wallet)\n', '        public\n', '    {\n', '\n', '    }\n', '}\n', '\n', 'contract ICS is InfiniteCappedCrowdsale {\n', '\n', '    uint256 public constant TOTAL_SUPPLY = 975220000000;\n', '    uint256 public constant ARBITRARY_VALUATION_IN_ETH = 33;\n', '    // ^ arbitrary valuation of ~$10k\n', '    uint256 public constant ETH_TO_WEI = (10 ** 18);\n', '    uint256 public constant TOKEN_RATE = (TOTAL_SUPPLY / ARBITRARY_VALUATION_IN_ETH);\n', '    // 29552121212 $TEAK per wei\n', '\n', '\n', '    function ICS(address _wallet)\n', '        InfiniteCappedCrowdsale(ARBITRARY_VALUATION_IN_ETH * ETH_TO_WEI, TOKEN_RATE, _wallet)\n', '        public\n', '    {\n', '\n', '    }\n', '\n', '    function createTokenContract() internal returns (StandardToken) {\n', '        return new STEAK(TOTAL_SUPPLY);\n', '    }\n', '}']
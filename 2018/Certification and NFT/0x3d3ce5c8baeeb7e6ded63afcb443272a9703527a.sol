['contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract HireGoToken is MintableToken, BurnableToken {\n', '\n', '    string public constant name = "HireGo";\n', '    string public constant symbol = "HGO";\n', '    uint32 public constant decimals = 18;\n', '\n', '    function HireGoToken() public {\n', '        totalSupply = 100000000E18;\n', '        balances[owner] = totalSupply; // Add all tokens to issuer balance (crowdsale in this case)\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'contract HireGoCrowdsale is Ownable {\n', '\n', '    using SafeMath for uint;\n', '\n', '    HireGoToken public token = new HireGoToken();\n', '    uint totalSupply = token.totalSupply();\n', '\n', '    bool public isRefundAllowed;\n', '    bool public newBonus_and_newPeriod;\n', '    bool public new_bonus_for_next_period;\n', '\n', '    uint public icoStartTime;\n', '    uint public icoEndTime;\n', '    uint public totalWeiRaised;\n', '    uint public weiRaised;\n', '    uint public hardCap; // amount of ETH collected, which marks end of crowd sale\n', '    uint public tokensDistributed; // amount of bought tokens\n', '    uint public bonus_for_add_stage;\n', '\n', '    /*         Bonus variables          */\n', '    uint internal baseBonus1 = 160;\n', '    uint internal baseBonus2 = 140;\n', '    uint internal baseBonus3 = 130;\n', '    uint internal baseBonus4 = 120;\n', '    uint internal baseBonus5 = 110;\n', '\t  uint internal baseBonus6 = 100;\n', '    uint public manualBonus;\n', '    /* * * * * * * * * * * * * * * * * * */\n', '\n', '    uint public rate; // how many token units a buyer gets per wei\n', '    uint private icoMinPurchase; // In ETH\n', '    uint private icoEndDateIncCount;\n', '\n', '    address[] public investors_number;\n', '    address private wallet; // address where funds are collected\n', '\n', '    mapping (address => uint) public orderedTokens;\n', '    mapping (address => uint) contributors;\n', '\n', '    event FundsWithdrawn(address _who, uint256 _amount);\n', '\n', '    modifier hardCapNotReached() {\n', '        require(totalWeiRaised < hardCap);\n', '        _;\n', '    }\n', '\n', '    modifier crowdsaleEnded() {\n', '        require(now > icoEndTime);\n', '        _;\n', '    }\n', '\n', '    modifier crowdsaleInProgress() {\n', '        bool withinPeriod = (now >= icoStartTime && now <= icoEndTime);\n', '        require(withinPeriod);\n', '        _;\n', '    }\n', '\n', '    function HireGoCrowdsale(uint _icoStartTime, uint _icoEndTime, address _wallet) public {\n', '        require (\n', '          _icoStartTime > now &&\n', '          _icoEndTime > _icoStartTime\n', '        );\n', '\n', '        icoStartTime = _icoStartTime;\n', '        icoEndTime = _icoEndTime;\n', '        wallet = _wallet;\n', '\n', '        rate = 250 szabo; // wei per 1 token (0.00025ETH)\n', '\n', '        hardCap = 11575 ether;\n', '        icoEndDateIncCount = 0;\n', '        icoMinPurchase = 50 finney; // 0.05 ETH\n', '        isRefundAllowed = false;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() public payable {\n', '        buyTokens();\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens() public payable crowdsaleInProgress hardCapNotReached {\n', '        require(msg.value > 0);\n', '\n', '        // check if the buyer exceeded the funding goal\n', '        calculatePurchaseAndBonuses(msg.sender, msg.value);\n', '    }\n', '\n', '    // Returns number of investors\n', '    function getInvestorCount() public view returns (uint) {\n', '        return investors_number.length;\n', '    }\n', '\n', '    // Owner can allow or disallow refunds even if soft cap is reached. Should be used in case KYC is not passed.\n', '    // WARNING: owner should transfer collected ETH back to contract before allowing to refund, if he already withdrawn ETH.\n', '    function toggleRefunds() public onlyOwner {\n', '        isRefundAllowed = true;\n', '    }\n', '\n', '    // Moves ICO ending date by one month. End date can be moved only 1 times.\n', '    // Returns true if ICO end date was successfully shifted\n', '    function moveIcoEndDateByOneMonth(uint bonus_percentage) public onlyOwner crowdsaleInProgress returns (bool) {\n', '        if (icoEndDateIncCount < 1) {\n', '            icoEndTime = icoEndTime.add(30 days);\n', '            icoEndDateIncCount++;\n', '            newBonus_and_newPeriod = true;\n', '            bonus_for_add_stage = bonus_percentage;\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Owner can send back collected ETH if soft cap is not reached or KYC is not passed\n', '    // WARNING: crowdsale contract should have all received funds to return them.\n', '    // If you have already withdrawn them, send them back to crowdsale contract\n', '    function refundInvestors() public onlyOwner {\n', '        require(now >= icoEndTime);\n', '        require(isRefundAllowed);\n', '        require(msg.sender.balance > 0);\n', '\n', '        address investor;\n', '        uint contributedWei;\n', '        uint tokens;\n', '        for(uint i = 0; i < investors_number.length; i++) {\n', '            investor = investors_number[i];\n', '            contributedWei = contributors[investor];\n', '            tokens = orderedTokens[investor];\n', '            if(contributedWei > 0) {\n', '                totalWeiRaised = totalWeiRaised.sub(contributedWei);\n', '                weiRaised = weiRaised.sub(contributedWei);\n', '                if(weiRaised<0){\n', '                  weiRaised = 0;\n', '                }\n', '                contributors[investor] = 0;\n', '                orderedTokens[investor] = 0;\n', '                tokensDistributed = tokensDistributed.sub(tokens);\n', '                investor.transfer(contributedWei); // return funds back to contributor\n', '            }\n', '        }\n', '    }\n', '\n', '    // Owner of contract can withdraw collected ETH, if soft cap is reached, by calling this function\n', '    function withdraw() public onlyOwner {\n', '        uint to_send = weiRaised;\n', '        weiRaised = 0;\n', '        FundsWithdrawn(msg.sender, to_send);\n', '        wallet.transfer(to_send);\n', '    }\n', '\n', '    // This function should be used to manually reserve some tokens for "big sharks" or bug-bounty program participants\n', '    function manualReserve(address _beneficiary, uint _amount) public onlyOwner crowdsaleInProgress {\n', '        require(_beneficiary != address(0));\n', '        require(_amount > 0);\n', '        checkAndMint(_amount);\n', '        tokensDistributed = tokensDistributed.add(_amount);\n', '        token.transfer(_beneficiary, _amount);\n', '    }\n', '\n', '    function burnUnsold() public onlyOwner crowdsaleEnded {\n', '        uint tokensLeft = totalSupply.sub(tokensDistributed);\n', '        token.burn(tokensLeft);\n', '    }\n', '\n', '    function finishIco() public onlyOwner {\n', '        icoEndTime = now;\n', '    }\n', '\n', '    function distribute_for_founders() public onlyOwner {\n', '        uint to_send = 40000000000000000000000000; //40m\n', '        checkAndMint(to_send);\n', '        token.transfer(wallet, to_send);\n', '    }\n', '\n', '    function transferOwnershipToken(address _to) public onlyOwner {\n', '        token.transferOwnership(_to);\n', '    }\n', '\n', '    /***************************\n', '    **  Internal functions    **\n', '    ***************************/\n', '\n', '    // Calculates purchase conditions and token bonuses\n', '    function calculatePurchaseAndBonuses(address _beneficiary, uint _weiAmount) internal {\n', '        if (now >= icoStartTime && now < icoEndTime) require(_weiAmount >= icoMinPurchase);\n', '\n', '        uint cleanWei; // amount of wei to use for purchase excluding change and hardcap overflows\n', '        uint change;\n', '        uint _tokens;\n', '\n', '        //check for hardcap overflow\n', '        if (_weiAmount.add(totalWeiRaised) > hardCap) {\n', '            cleanWei = hardCap.sub(totalWeiRaised);\n', '            change = _weiAmount.sub(cleanWei);\n', '        }\n', '        else cleanWei = _weiAmount;\n', '\n', '        assert(cleanWei > 4); // 4 wei is a price of minimal fracture of token\n', '\n', '        _tokens = cleanWei.div(rate).mul(1 ether);\n', '\n', '        if (contributors[_beneficiary] == 0) investors_number.push(_beneficiary);\n', '\n', '        _tokens = calculateBonus(_tokens);\n', '        checkAndMint(_tokens);\n', '\n', '        contributors[_beneficiary] = contributors[_beneficiary].add(cleanWei);\n', '        weiRaised = weiRaised.add(cleanWei);\n', '        totalWeiRaised = totalWeiRaised.add(cleanWei);\n', '        tokensDistributed = tokensDistributed.add(_tokens);\n', '        orderedTokens[_beneficiary] = orderedTokens[_beneficiary].add(_tokens);\n', '\n', '        if (change > 0) _beneficiary.transfer(change);\n', '\n', '        token.transfer(_beneficiary,_tokens);\n', '    }\n', '\n', '    // Calculates bonuses based on current stage\n', '    function calculateBonus(uint _baseAmount) internal returns (uint) {\n', '        require(_baseAmount > 0);\n', '\n', '        if (now >= icoStartTime && now < icoEndTime) {\n', '            return calculateBonusIco(_baseAmount);\n', '        }\n', '        else return _baseAmount;\n', '    }\n', '\n', '    // Calculates bonuses, specific for the ICO\n', '    // Contains date and volume based bonuses\n', '    function calculateBonusIco(uint _baseAmount) internal returns(uint) {\n', '        if(now >= icoStartTime && now < 1520726399) {//3:55-4\n', '            // 4-10 Mar - 60% bonus\n', '            return _baseAmount.mul(baseBonus1).div(100);\n', '        }\n', '        else if(now >= 1520726400 && now < 1521331199) {\n', '            // 11-17 Mar - 40% bonus\n', '            return _baseAmount.mul(baseBonus2).div(100);\n', '        }\n', '        else if(now >= 1521331200 && now < 1521935999) {\n', '            // 18-24 Mar - 30% bonus\n', '            return _baseAmount.mul(baseBonus3).div(100);\n', '        }\n', '        else if(now >= 1521936000 && now < 1524959999) {\n', '            // 25 Mar-28 Apr - 20% bonus\n', '            return _baseAmount.mul(baseBonus4).div(100);\n', '        }\n', '        else if(now >= 1524960000 && now < 1526169599) {\n', '            //29 Apr - 12 May - 10% bonus\n', '            return _baseAmount.mul(baseBonus5).div(100);\n', '        }\n', '        else {\n', '            //13 May - 26 May - no bonus\n', '            return _baseAmount;\n', '        }\n', '    }\n', '\n', '    // Checks if more tokens should be minted based on amount of sold tokens, required additional tokens and total supply.\n', '    // If there are not enough tokens, mint missing tokens\n', '    function checkAndMint(uint _amount) internal {\n', '        uint required = tokensDistributed.add(_amount);\n', '        if(required > totalSupply) token.mint(this, required.sub(totalSupply));\n', '    }\n', '}']
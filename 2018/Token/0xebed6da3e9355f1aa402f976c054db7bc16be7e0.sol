['pragma solidity 0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract IgfContract is Ownable\n', '{\n', '\n', 'using SafeMath for uint256;\n', '    //INVESTOR REPOSITORY\n', '    mapping(address => uint256) internal balances;\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    mapping (address => uint256) internal totalAllowed;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    uint256 internal totSupply;\n', '\n', '    //COMMON\n', '    function totalSupply() view public returns(uint256)\n', '    {\n', '        return totSupply;\n', '    }\n', '    \n', '    function getTotalAllowed(address _owner) view public returns(uint256)\n', '    {\n', '        return totalAllowed[_owner];\n', '    }\n', '\n', '    function setTotalAllowed(address _owner, uint256 _newValue) internal\n', '    {\n', '        totalAllowed[_owner]=_newValue;\n', '    }\n', '\n', '\n', '    function setTotalSupply(uint256 _newValue) internal\n', '    {\n', '        totSupply=_newValue;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '\n', '    function balanceOf(address _owner) view public returns(uint256)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function setBalanceOf(address _investor, uint256 _newValue) internal\n', '    {\n', '        require(_investor!=0x0000000000000000000000000000000000000000);\n', '        balances[_investor]=_newValue;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '\n', '    function allowance(address _owner, address _spender) view public returns(uint256)\n', '    {\n', '        require(msg.sender==_owner || msg.sender == _spender || msg.sender==getOwner());\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function setAllowance(address _owner, address _spender, uint256 _newValue) internal\n', '    {\n', '        require(_spender!=0x0000000000000000000000000000000000000000);\n', '        uint256 newTotal = getTotalAllowed(_owner).sub(allowance(_owner, _spender)).add(_newValue);\n', '        require(newTotal <= balanceOf(_owner));\n', '        allowed[_owner][_spender]=_newValue;\n', '        setTotalAllowed(_owner,newTotal);\n', '    }\n', '\n', '\n', '\n', '// TOKEN \n', '   constructor(uint256 _rate, uint256 _minPurchase,uint256 _cap) public\n', '    {\n', '        require(_minPurchase>0);\n', '        require(_rate > 0);\n', '        require(_cap > 0);\n', '        rate=_rate;\n', '        minPurchase=_minPurchase;\n', '        cap = _cap;\n', '    }\n', '\n', '    bytes32 public constant name = "IGFToken";\n', '\n', '    bytes3 public constant symbol = "IGF";\n', '\n', '    uint8 public constant decimals = 8;\n', '\n', '    uint256 public cap;\n', '\n', '    bool internal mintingFinished;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    event MintFinished();\n', '    \n', '    event Burn(address indexed _owner, uint256 _value);\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    function getName() view public returns(bytes32)\n', '    {\n', '        return name;\n', '    }\n', '\n', '    function getSymbol() view public returns(bytes3)\n', '    {\n', '        return symbol;\n', '    }\n', '\n', '    function getTokenDecimals() view public returns(uint256)\n', '    {\n', '        return decimals;\n', '    }\n', '    \n', '    function getMintingFinished() view public returns(bool)\n', '    {\n', '        return mintingFinished;\n', '    }\n', '\n', '    function getTokenCap() view public returns(uint256)\n', '    {\n', '        return cap;\n', '    }\n', '\n', '    function setTokenCap(uint256 _newCap) external onlyOwner\n', '    {\n', '        cap=_newCap;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Burns the tokens of the specified address.\n', '    * @param _owner The holder of tokens.\n', '    * @param _value The amount of tokens burned\n', '    */\n', '\n', '  function burn(address _owner,uint256 _value) external  {\n', '    require(_value <= balanceOf(_owner));\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    setBalanceOf(_owner, balanceOf(_owner).sub(_value));\n', '    setTotalSupply(totalSupply().sub(_value));\n', '    emit Burn(_owner, _value);\n', '  }\n', '\n', '    \n', '\n', '    function updateTokenInvestorBalance(address _investor, uint256 _newValue) onlyOwner external\n', '    {\n', '        addTokens(_investor,_newValue);\n', '    }\n', '\n', '    /**\n', '     * @dev transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '    */\n', '\n', '    function transfer(address _to, uint256 _value) external{\n', '        require(msg.sender!=_to);\n', '        require(_value <= balanceOf(msg.sender));\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        setBalanceOf(msg.sender, balanceOf(msg.sender).sub(_value));\n', '        setBalanceOf(_to, balanceOf(_to).add(_value));\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) external {\n', '        require(_value <= balanceOf(_from));\n', '        require(_value <= allowance(_from,_to));\n', '        setBalanceOf(_from, balanceOf(_from).sub(_value));\n', '        setBalanceOf(_to, balanceOf(_to).add(_value));\n', '        setAllowance(_from,_to,allowance(_from,_to).sub(_value));\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', ' * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', ' *\n', ' * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', ' * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', ' * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', ' * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', ' * @param _owner The address of the owner which allows tokens to a spender\n', ' * @param _spender The address which will spend the funds.\n', ' * @param _value The amount of tokens to be spent.\n', ' */\n', '    function approve(address _owner,address _spender, uint256 _value) external {\n', '        require(msg.sender ==_owner);\n', '        setAllowance(msg.sender,_spender, _value);\n', '        emit Approval(msg.sender, _spender, _value);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _owner The address of the owner which allows tokens to a spender\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _owner, address _spender, uint _addedValue) external{\n', '        require(msg.sender==_owner);\n', '        setAllowance(_owner,_spender,allowance(_owner,_spender).add(_addedValue));\n', '        emit Approval(_owner, _spender, allowance(_owner,_spender));\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _owner The address of the owner which allows tokens to a spender\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _owner,address _spender, uint _subtractedValue) external{\n', '        require(msg.sender==_owner);\n', '\n', '        uint oldValue = allowance(_owner,_spender);\n', '        if (_subtractedValue > oldValue) {\n', '            setAllowance(_owner,_spender, 0);\n', '        } else {\n', '            setAllowance(_owner,_spender, oldValue.sub(_subtractedValue));\n', '        }\n', '        emit Approval(_owner, _spender, allowance(_owner,_spender));\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '\n', '\n', '    function mint(address _to, uint256 _amount) canMint internal{\n', '        require(totalSupply().add(_amount) <= getTokenCap());\n', '        setTotalSupply(totalSupply().add(_amount));\n', '        setBalanceOf(_to, balanceOf(_to).add(_amount));\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '    }\n', '    \n', '    function addTokens(address _to, uint256 _amount) canMint internal{\n', '        require( totalSupply().add(_amount) <= getTokenCap());\n', '        setTotalSupply(totalSupply().add(_amount));\n', '        setBalanceOf(_to, balanceOf(_to).add(_amount));\n', '        emit Transfer(address(0), _to, _amount);\n', '    }    \n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() canMint onlyOwner external{\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '    }\n', '\n', '    //Crowdsale\n', '    \n', '        // what is minimal purchase of tokens\n', '    uint256 internal minPurchase;\n', '\n', '    // how many token units a buyer gets per wei\n', '    uint256 internal rate;\n', '\n', '    // amount of raised money in wei\n', '    uint256 internal weiRaised;\n', '    \n', '    /**\n', '     * event for token purchase logging\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    event InvestmentsWithdrawn(uint indexed amount, uint indexed timestamp);\n', '\n', '    function () external payable {\n', '    }\n', '\n', '    function getTokenRate() view public returns(uint256)\n', '    {\n', '        return rate;\n', '    }\n', '\n', '    function getMinimumPurchase() view public returns(uint256)\n', '    {\n', '        return minPurchase;\n', '    }\n', '\n', '    function setTokenRate(uint256 _newRate) external onlyOwner\n', '    {\n', '        rate = _newRate;\n', '    }\n', '    \n', '    function setMinPurchase(uint256 _newMin) external onlyOwner\n', '    {\n', '        minPurchase = _newMin;\n', '    }\n', '\n', '    function getWeiRaised() view external returns(uint256)\n', '    {\n', '        return weiRaised;\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens() external payable{\n', '        require(msg.value > 0);\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = getTokenAmount(weiAmount);\n', '        require(validPurchase(tokens));\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        mint(msg.sender, tokens);\n', '        emit TokenPurchase(msg.sender, weiAmount, tokens);\n', '    }\n', '\n', '    // Override this method to have a way to add business logic to your crowdsale when buying\n', '    function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {\n', '        return weiAmount.div(getTokenRate());\n', '    }\n', '\n', '    // get all rised wei\n', '    function withdrawInvestments() external onlyOwner{\n', '        uint  amount = address(this).balance;\n', '        getOwner().transfer(amount * 1 wei);\n', '        emit InvestmentsWithdrawn(amount, block.timestamp);\n', '    }\n', '    \n', '    function getCurrentInvestments() view external onlyOwner returns(uint256)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function getOwner() view internal returns(address)\n', '    {\n', '        return owner;\n', '    }\n', '\n', '    // @return true if the transaction can buy tokens\n', '    function validPurchase(uint256 tokensAmount) internal view returns (bool) {\n', '        bool nonZeroPurchase = tokensAmount != 0;\n', '        bool acceptableAmount = tokensAmount >= getMinimumPurchase();\n', '        return nonZeroPurchase && acceptableAmount;\n', '    }\n', '    \n', '    // CASHIER\n', '    uint256 internal dividendsPaid;\n', '\n', '    event DividendsPayment(uint256 amount, address beneficiary);\n', '\n', '    function getTotalDividendsPaid() view external onlyOwner returns (uint256)\n', '    {\n', '        return dividendsPaid;\n', '    }\n', '\n', '    function getBalance() view public onlyOwner returns (uint256)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function payDividends(address beneficiary,uint256 amount) external onlyOwner returns(bool)\n', '    {\n', '        require(amount > 0);\n', '        validBeneficiary(beneficiary);\n', '        beneficiary.transfer(amount);\n', '        dividendsPaid.add(amount);\n', '        emit DividendsPayment(amount, beneficiary);\n', '        return true;\n', '    }\n', '\n', '    function depositDividends() payable external onlyOwner\n', '    {\n', '       address(this).transfer(msg.value);\n', '    }\n', '    \n', '    function validBeneficiary(address beneficiary) view internal\n', '    {\n', '        require(balanceOf(beneficiary)>0);\n', '    }\n', '    \n', '    \n', '    //duplicates\n', '    \n', '    function getInvestorBalance(address _address) view external returns(uint256)\n', '    {\n', '        return balanceOf(_address);\n', '    }\n', '}']
['pragma solidity 0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract IgfContract is Ownable\n', '{\n', '\n', 'using SafeMath for uint256;\n', '    //INVESTOR REPOSITORY\n', '    mapping(address => uint256) internal balances;\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    mapping (address => uint256) internal totalAllowed;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    uint256 internal totSupply;\n', '\n', '    //COMMON\n', '    function totalSupply() view public returns(uint256)\n', '    {\n', '        return totSupply;\n', '    }\n', '    \n', '    function getTotalAllowed(address _owner) view public returns(uint256)\n', '    {\n', '        return totalAllowed[_owner];\n', '    }\n', '\n', '    function setTotalAllowed(address _owner, uint256 _newValue) internal\n', '    {\n', '        totalAllowed[_owner]=_newValue;\n', '    }\n', '\n', '\n', '    function setTotalSupply(uint256 _newValue) internal\n', '    {\n', '        totSupply=_newValue;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '\n', '    function balanceOf(address _owner) view public returns(uint256)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function setBalanceOf(address _investor, uint256 _newValue) internal\n', '    {\n', '        require(_investor!=0x0000000000000000000000000000000000000000);\n', '        balances[_investor]=_newValue;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '\n', '    function allowance(address _owner, address _spender) view public returns(uint256)\n', '    {\n', '        require(msg.sender==_owner || msg.sender == _spender || msg.sender==getOwner());\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function setAllowance(address _owner, address _spender, uint256 _newValue) internal\n', '    {\n', '        require(_spender!=0x0000000000000000000000000000000000000000);\n', '        uint256 newTotal = getTotalAllowed(_owner).sub(allowance(_owner, _spender)).add(_newValue);\n', '        require(newTotal <= balanceOf(_owner));\n', '        allowed[_owner][_spender]=_newValue;\n', '        setTotalAllowed(_owner,newTotal);\n', '    }\n', '\n', '\n', '\n', '// TOKEN \n', '   constructor(uint256 _rate, uint256 _minPurchase,uint256 _cap) public\n', '    {\n', '        require(_minPurchase>0);\n', '        require(_rate > 0);\n', '        require(_cap > 0);\n', '        rate=_rate;\n', '        minPurchase=_minPurchase;\n', '        cap = _cap;\n', '    }\n', '\n', '    bytes32 public constant name = "IGFToken";\n', '\n', '    bytes3 public constant symbol = "IGF";\n', '\n', '    uint8 public constant decimals = 8;\n', '\n', '    uint256 public cap;\n', '\n', '    bool internal mintingFinished;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '\n', '    event MintFinished();\n', '    \n', '    event Burn(address indexed _owner, uint256 _value);\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    function getName() view public returns(bytes32)\n', '    {\n', '        return name;\n', '    }\n', '\n', '    function getSymbol() view public returns(bytes3)\n', '    {\n', '        return symbol;\n', '    }\n', '\n', '    function getTokenDecimals() view public returns(uint256)\n', '    {\n', '        return decimals;\n', '    }\n', '    \n', '    function getMintingFinished() view public returns(bool)\n', '    {\n', '        return mintingFinished;\n', '    }\n', '\n', '    function getTokenCap() view public returns(uint256)\n', '    {\n', '        return cap;\n', '    }\n', '\n', '    function setTokenCap(uint256 _newCap) external onlyOwner\n', '    {\n', '        cap=_newCap;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Burns the tokens of the specified address.\n', '    * @param _owner The holder of tokens.\n', '    * @param _value The amount of tokens burned\n', '    */\n', '\n', '  function burn(address _owner,uint256 _value) external  {\n', '    require(_value <= balanceOf(_owner));\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    setBalanceOf(_owner, balanceOf(_owner).sub(_value));\n', '    setTotalSupply(totalSupply().sub(_value));\n', '    emit Burn(_owner, _value);\n', '  }\n', '\n', '    \n', '\n', '    function updateTokenInvestorBalance(address _investor, uint256 _newValue) onlyOwner external\n', '    {\n', '        addTokens(_investor,_newValue);\n', '    }\n', '\n', '    /**\n', '     * @dev transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '    */\n', '\n', '    function transfer(address _to, uint256 _value) external{\n', '        require(msg.sender!=_to);\n', '        require(_value <= balanceOf(msg.sender));\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        setBalanceOf(msg.sender, balanceOf(msg.sender).sub(_value));\n', '        setBalanceOf(_to, balanceOf(_to).add(_value));\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) external {\n', '        require(_value <= balanceOf(_from));\n', '        require(_value <= allowance(_from,_to));\n', '        setBalanceOf(_from, balanceOf(_from).sub(_value));\n', '        setBalanceOf(_to, balanceOf(_to).add(_value));\n', '        setAllowance(_from,_to,allowance(_from,_to).sub(_value));\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', ' * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', ' *\n', ' * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', ' * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', " * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", ' * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', ' * @param _owner The address of the owner which allows tokens to a spender\n', ' * @param _spender The address which will spend the funds.\n', ' * @param _value The amount of tokens to be spent.\n', ' */\n', '    function approve(address _owner,address _spender, uint256 _value) external {\n', '        require(msg.sender ==_owner);\n', '        setAllowance(msg.sender,_spender, _value);\n', '        emit Approval(msg.sender, _spender, _value);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _owner The address of the owner which allows tokens to a spender\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _owner, address _spender, uint _addedValue) external{\n', '        require(msg.sender==_owner);\n', '        setAllowance(_owner,_spender,allowance(_owner,_spender).add(_addedValue));\n', '        emit Approval(_owner, _spender, allowance(_owner,_spender));\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _owner The address of the owner which allows tokens to a spender\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _owner,address _spender, uint _subtractedValue) external{\n', '        require(msg.sender==_owner);\n', '\n', '        uint oldValue = allowance(_owner,_spender);\n', '        if (_subtractedValue > oldValue) {\n', '            setAllowance(_owner,_spender, 0);\n', '        } else {\n', '            setAllowance(_owner,_spender, oldValue.sub(_subtractedValue));\n', '        }\n', '        emit Approval(_owner, _spender, allowance(_owner,_spender));\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '\n', '\n', '    function mint(address _to, uint256 _amount) canMint internal{\n', '        require(totalSupply().add(_amount) <= getTokenCap());\n', '        setTotalSupply(totalSupply().add(_amount));\n', '        setBalanceOf(_to, balanceOf(_to).add(_amount));\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '    }\n', '    \n', '    function addTokens(address _to, uint256 _amount) canMint internal{\n', '        require( totalSupply().add(_amount) <= getTokenCap());\n', '        setTotalSupply(totalSupply().add(_amount));\n', '        setBalanceOf(_to, balanceOf(_to).add(_amount));\n', '        emit Transfer(address(0), _to, _amount);\n', '    }    \n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() canMint onlyOwner external{\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '    }\n', '\n', '    //Crowdsale\n', '    \n', '        // what is minimal purchase of tokens\n', '    uint256 internal minPurchase;\n', '\n', '    // how many token units a buyer gets per wei\n', '    uint256 internal rate;\n', '\n', '    // amount of raised money in wei\n', '    uint256 internal weiRaised;\n', '    \n', '    /**\n', '     * event for token purchase logging\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '    event InvestmentsWithdrawn(uint indexed amount, uint indexed timestamp);\n', '\n', '    function () external payable {\n', '    }\n', '\n', '    function getTokenRate() view public returns(uint256)\n', '    {\n', '        return rate;\n', '    }\n', '\n', '    function getMinimumPurchase() view public returns(uint256)\n', '    {\n', '        return minPurchase;\n', '    }\n', '\n', '    function setTokenRate(uint256 _newRate) external onlyOwner\n', '    {\n', '        rate = _newRate;\n', '    }\n', '    \n', '    function setMinPurchase(uint256 _newMin) external onlyOwner\n', '    {\n', '        minPurchase = _newMin;\n', '    }\n', '\n', '    function getWeiRaised() view external returns(uint256)\n', '    {\n', '        return weiRaised;\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens() external payable{\n', '        require(msg.value > 0);\n', '        uint256 weiAmount = msg.value;\n', '\n', '        // calculate token amount to be created\n', '        uint256 tokens = getTokenAmount(weiAmount);\n', '        require(validPurchase(tokens));\n', '\n', '        // update state\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        mint(msg.sender, tokens);\n', '        emit TokenPurchase(msg.sender, weiAmount, tokens);\n', '    }\n', '\n', '    // Override this method to have a way to add business logic to your crowdsale when buying\n', '    function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {\n', '        return weiAmount.div(getTokenRate());\n', '    }\n', '\n', '    // get all rised wei\n', '    function withdrawInvestments() external onlyOwner{\n', '        uint  amount = address(this).balance;\n', '        getOwner().transfer(amount * 1 wei);\n', '        emit InvestmentsWithdrawn(amount, block.timestamp);\n', '    }\n', '    \n', '    function getCurrentInvestments() view external onlyOwner returns(uint256)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function getOwner() view internal returns(address)\n', '    {\n', '        return owner;\n', '    }\n', '\n', '    // @return true if the transaction can buy tokens\n', '    function validPurchase(uint256 tokensAmount) internal view returns (bool) {\n', '        bool nonZeroPurchase = tokensAmount != 0;\n', '        bool acceptableAmount = tokensAmount >= getMinimumPurchase();\n', '        return nonZeroPurchase && acceptableAmount;\n', '    }\n', '    \n', '    // CASHIER\n', '    uint256 internal dividendsPaid;\n', '\n', '    event DividendsPayment(uint256 amount, address beneficiary);\n', '\n', '    function getTotalDividendsPaid() view external onlyOwner returns (uint256)\n', '    {\n', '        return dividendsPaid;\n', '    }\n', '\n', '    function getBalance() view public onlyOwner returns (uint256)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function payDividends(address beneficiary,uint256 amount) external onlyOwner returns(bool)\n', '    {\n', '        require(amount > 0);\n', '        validBeneficiary(beneficiary);\n', '        beneficiary.transfer(amount);\n', '        dividendsPaid.add(amount);\n', '        emit DividendsPayment(amount, beneficiary);\n', '        return true;\n', '    }\n', '\n', '    function depositDividends() payable external onlyOwner\n', '    {\n', '       address(this).transfer(msg.value);\n', '    }\n', '    \n', '    function validBeneficiary(address beneficiary) view internal\n', '    {\n', '        require(balanceOf(beneficiary)>0);\n', '    }\n', '    \n', '    \n', '    //duplicates\n', '    \n', '    function getInvestorBalance(address _address) view external returns(uint256)\n', '    {\n', '        return balanceOf(_address);\n', '    }\n', '}']

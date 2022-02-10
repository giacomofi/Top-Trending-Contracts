['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract ERC223Basic {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    function transfer(address to, uint256 value, bytes data) public;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value, bytes data);\n', '\n', '}\n', '\n', 'contract ERC223ReceivingContract {\n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', 'contract ERC223Token is ERC20, ERC223Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances; // List of user balances.\n', '\n', '    /**\n', '    * @dev protection against short address attack\n', '    */\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      Invokes the `tokenFallback` function if the recipient is a contract.\n', '     *      The token transfer fails if the recipient is a contract\n', '     *      but does not implement the `tokenFallback` function\n', '     *      or the fallback function to receive funds.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function transfer(address _to, uint _value, bytes _data) public onlyPayloadSize(3) {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        assembly {\n', '        // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      This function works the same with the previous one\n', '     *      but doesn&#39;t contain `_data` param.\n', '     *      Added due to backwards compatibility reasons.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     */\n', '    function transfer(address _to, uint _value) public onlyPayloadSize(2) returns(bool) {\n', '        uint codeLength;\n', '        bytes memory empty;\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        assembly {\n', '        // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Returns balance of the `_owner`.\n', '     *\n', '     * @param _owner   The address whose balance will be returned.\n', '     * @return balance Balance of the `_owner`.\n', '     */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC223Token {\n', '\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract Oratium is StandardToken {\n', '\n', '    string public constant name = "Oratium";\n', '    string public constant symbol = "ORT";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant INITIAL_SUPPLY = 950000000000000000000000000;\n', '    address public owner;\n', '    mapping (address => bool) public contractUsers;\n', '    bool public mintingFinished;\n', '    uint256 public tokenAllocated = 0;\n', '    // list of valid claim` \n', '    mapping (address => uint) public countClaimsToken;\n', '\n', '    uint256 public priceToken = 950000;\n', '    uint256 public priceClaim = 0.0005 ether;\n', '    uint256 public numberClaimToken = 500 * (10**uint256(decimals));\n', '    uint256 public startTimeDay = 1;\n', '    uint256 public endTimeDay = 86400;\n', '\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '    event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);\n', '    event MinWeiLimitReached(address indexed sender, uint256 weiAmount);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    constructor(address _owner) public {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        owner = _owner;\n', '        //owner = msg.sender; // for test&#39;s\n', '        balances[owner] = INITIAL_SUPPLY;\n', '        transfersEnabled = true;\n', '        mintingFinished = false;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address _investor) public payable returns (uint256){\n', '        require(_investor != address(0));\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = validPurchaseTokens(weiAmount);\n', '        if (tokens == 0) {revert();}\n', '        tokenAllocated = tokenAllocated.add(tokens);\n', '        mint(_investor, tokens, owner);\n', '\n', '        emit TokenPurchase(_investor, weiAmount, tokens);\n', '        owner.transfer(weiAmount);\n', '        return tokens;\n', '    }\n', '\n', '    function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {\n', '        uint256 addTokens = _weiAmount.mul(priceToken);\n', '        if (_weiAmount < 0.05 ether) {\n', '            emit MinWeiLimitReached(msg.sender, _weiAmount);\n', '            return 0;\n', '        }\n', '        if (tokenAllocated.add(addTokens) > balances[owner]) {\n', '            emit TokenLimitReached(tokenAllocated, addTokens);\n', '            return 0;\n', '        }\n', '        return addTokens;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) onlyOwner public returns (bool){\n', '        require(_newOwner != address(0));\n', '        emit OwnerChanged(owner, _newOwner);\n', '        owner = _newOwner;\n', '        return true;\n', '    }\n', '\n', '    function enableTransfers(bool _transfersEnabled) onlyOwner public {\n', '        transfersEnabled = _transfersEnabled;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[owner]);\n', '        require(!mintingFinished);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(_owner, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function claim() canMint public payable returns (bool) {\n', '        uint256 currentTime = now;\n', '        //currentTime = 1540037100; //for test&#39;s\n', '        require(validPurchaseTime(currentTime));\n', '        require(msg.value >= priceClaim);\n', '        address beneficiar = msg.sender;\n', '        require(beneficiar != address(0));\n', '        require(!mintingFinished);\n', '\n', '        uint256 amount = calcAmount(beneficiar);\n', '        require(amount <= balances[owner]);\n', '\n', '        balances[beneficiar] = balances[beneficiar].add(amount);\n', '        balances[owner] = balances[owner].sub(amount);\n', '        tokenAllocated = tokenAllocated.add(amount);\n', '        owner.transfer(msg.value);\n', '        emit Mint(beneficiar, amount);\n', '        emit Transfer(owner, beneficiar, amount);\n', '        return true;\n', '    }\n', '\n', '    //function calcAmount(address _beneficiar) canMint public returns (uint256 amount) { //for test&#39;s\n', '    function calcAmount(address _beneficiar) canMint internal returns (uint256 amount) {\n', '        if (countClaimsToken[_beneficiar] == 0) {\n', '            countClaimsToken[_beneficiar] = 1;\n', '        }\n', '        if (countClaimsToken[_beneficiar] >= 1000) {\n', '            return 0;\n', '        }\n', '        uint step = countClaimsToken[_beneficiar];\n', '        amount = numberClaimToken.mul(105 - 5*step).div(100);\n', '        countClaimsToken[_beneficiar] = countClaimsToken[_beneficiar].add(1);\n', '    }\n', '\n', '    function validPurchaseTime(uint256 _currentTime) canMint public view returns (bool) {\n', '        uint256 dayTime = _currentTime % 1 days;\n', '        if (startTimeDay <= dayTime && dayTime <=  endTimeDay) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function changeTime(uint256 _newStartTimeDay, uint256 _newEndTimeDay) public {\n', '        require(0 < _newStartTimeDay && 0 < _newEndTimeDay);\n', '        startTimeDay = _newStartTimeDay;\n', '        endTimeDay = _newEndTimeDay;\n', '    }\n', '\n', '    /**\n', '     * Peterson&#39;s Law Protection\n', '     * Claim tokens\n', '     */\n', '    function claimTokensToOwner(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner.transfer(address(this).balance);\n', '            return;\n', '        }\n', '        Oratium token = Oratium(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '        emit Transfer(_token, owner, balance);\n', '    }\n', '\n', '    function setPriceClaim(uint256 _newPriceClaim) external onlyOwner {\n', '        require(_newPriceClaim > 0);\n', '        priceClaim = _newPriceClaim;\n', '    }\n', '\n', '    function setNumberClaimToken(uint256 _newNumClaimToken) external onlyOwner {\n', '        require(_newNumClaimToken > 0);\n', '        numberClaimToken = _newNumClaimToken;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract ERC223Basic {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    function transfer(address to, uint256 value, bytes data) public;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value, bytes data);\n', '\n', '}\n', '\n', 'contract ERC223ReceivingContract {\n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', 'contract ERC223Token is ERC20, ERC223Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances; // List of user balances.\n', '\n', '    /**\n', '    * @dev protection against short address attack\n', '    */\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      Invokes the `tokenFallback` function if the recipient is a contract.\n', '     *      The token transfer fails if the recipient is a contract\n', '     *      but does not implement the `tokenFallback` function\n', '     *      or the fallback function to receive funds.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function transfer(address _to, uint _value, bytes _data) public onlyPayloadSize(3) {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        assembly {\n', '        // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      This function works the same with the previous one\n', "     *      but doesn't contain `_data` param.\n", '     *      Added due to backwards compatibility reasons.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     */\n', '    function transfer(address _to, uint _value) public onlyPayloadSize(2) returns(bool) {\n', '        uint codeLength;\n', '        bytes memory empty;\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        assembly {\n', '        // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Returns balance of the `_owner`.\n', '     *\n', '     * @param _owner   The address whose balance will be returned.\n', '     * @return balance Balance of the `_owner`.\n', '     */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC223Token {\n', '\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract Oratium is StandardToken {\n', '\n', '    string public constant name = "Oratium";\n', '    string public constant symbol = "ORT";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant INITIAL_SUPPLY = 950000000000000000000000000;\n', '    address public owner;\n', '    mapping (address => bool) public contractUsers;\n', '    bool public mintingFinished;\n', '    uint256 public tokenAllocated = 0;\n', '    // list of valid claim` \n', '    mapping (address => uint) public countClaimsToken;\n', '\n', '    uint256 public priceToken = 950000;\n', '    uint256 public priceClaim = 0.0005 ether;\n', '    uint256 public numberClaimToken = 500 * (10**uint256(decimals));\n', '    uint256 public startTimeDay = 1;\n', '    uint256 public endTimeDay = 86400;\n', '\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '    event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);\n', '    event MinWeiLimitReached(address indexed sender, uint256 weiAmount);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    constructor(address _owner) public {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        owner = _owner;\n', "        //owner = msg.sender; // for test's\n", '        balances[owner] = INITIAL_SUPPLY;\n', '        transfersEnabled = true;\n', '        mintingFinished = false;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address _investor) public payable returns (uint256){\n', '        require(_investor != address(0));\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = validPurchaseTokens(weiAmount);\n', '        if (tokens == 0) {revert();}\n', '        tokenAllocated = tokenAllocated.add(tokens);\n', '        mint(_investor, tokens, owner);\n', '\n', '        emit TokenPurchase(_investor, weiAmount, tokens);\n', '        owner.transfer(weiAmount);\n', '        return tokens;\n', '    }\n', '\n', '    function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {\n', '        uint256 addTokens = _weiAmount.mul(priceToken);\n', '        if (_weiAmount < 0.05 ether) {\n', '            emit MinWeiLimitReached(msg.sender, _weiAmount);\n', '            return 0;\n', '        }\n', '        if (tokenAllocated.add(addTokens) > balances[owner]) {\n', '            emit TokenLimitReached(tokenAllocated, addTokens);\n', '            return 0;\n', '        }\n', '        return addTokens;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) onlyOwner public returns (bool){\n', '        require(_newOwner != address(0));\n', '        emit OwnerChanged(owner, _newOwner);\n', '        owner = _newOwner;\n', '        return true;\n', '    }\n', '\n', '    function enableTransfers(bool _transfersEnabled) onlyOwner public {\n', '        transfersEnabled = _transfersEnabled;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[owner]);\n', '        require(!mintingFinished);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(_owner, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function claim() canMint public payable returns (bool) {\n', '        uint256 currentTime = now;\n', "        //currentTime = 1540037100; //for test's\n", '        require(validPurchaseTime(currentTime));\n', '        require(msg.value >= priceClaim);\n', '        address beneficiar = msg.sender;\n', '        require(beneficiar != address(0));\n', '        require(!mintingFinished);\n', '\n', '        uint256 amount = calcAmount(beneficiar);\n', '        require(amount <= balances[owner]);\n', '\n', '        balances[beneficiar] = balances[beneficiar].add(amount);\n', '        balances[owner] = balances[owner].sub(amount);\n', '        tokenAllocated = tokenAllocated.add(amount);\n', '        owner.transfer(msg.value);\n', '        emit Mint(beneficiar, amount);\n', '        emit Transfer(owner, beneficiar, amount);\n', '        return true;\n', '    }\n', '\n', "    //function calcAmount(address _beneficiar) canMint public returns (uint256 amount) { //for test's\n", '    function calcAmount(address _beneficiar) canMint internal returns (uint256 amount) {\n', '        if (countClaimsToken[_beneficiar] == 0) {\n', '            countClaimsToken[_beneficiar] = 1;\n', '        }\n', '        if (countClaimsToken[_beneficiar] >= 1000) {\n', '            return 0;\n', '        }\n', '        uint step = countClaimsToken[_beneficiar];\n', '        amount = numberClaimToken.mul(105 - 5*step).div(100);\n', '        countClaimsToken[_beneficiar] = countClaimsToken[_beneficiar].add(1);\n', '    }\n', '\n', '    function validPurchaseTime(uint256 _currentTime) canMint public view returns (bool) {\n', '        uint256 dayTime = _currentTime % 1 days;\n', '        if (startTimeDay <= dayTime && dayTime <=  endTimeDay) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function changeTime(uint256 _newStartTimeDay, uint256 _newEndTimeDay) public {\n', '        require(0 < _newStartTimeDay && 0 < _newEndTimeDay);\n', '        startTimeDay = _newStartTimeDay;\n', '        endTimeDay = _newEndTimeDay;\n', '    }\n', '\n', '    /**\n', "     * Peterson's Law Protection\n", '     * Claim tokens\n', '     */\n', '    function claimTokensToOwner(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner.transfer(address(this).balance);\n', '            return;\n', '        }\n', '        Oratium token = Oratium(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '        emit Transfer(_token, owner, balance);\n', '    }\n', '\n', '    function setPriceClaim(uint256 _newPriceClaim) external onlyOwner {\n', '        require(_newPriceClaim > 0);\n', '        priceClaim = _newPriceClaim;\n', '    }\n', '\n', '    function setNumberClaimToken(uint256 _newNumClaimToken) external onlyOwner {\n', '        require(_newNumClaimToken > 0);\n', '        numberClaimToken = _newNumClaimToken;\n', '    }\n', '\n', '}']

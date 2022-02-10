['pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev protection against short address attack\n', '    */\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract UBOToken is StandardToken {\n', '\n', '    string public constant name = "UBSexone";\n', '    string public constant symbol = "UBO";\n', '    uint8 public constant decimals =0;\n', '    uint256 public constant INITIAL_SUPPLY = 1 * 50000000 * (10**uint256(decimals));\n', '    uint256 public weiRaised;\n', '    uint256 public tokenAllocated;\n', '    address public owner;\n', '    bool public saleToken = true;\n', '\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '    event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    function UBOToken() public {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        //owner = _owner;\n', '        owner = msg.sender; // for testing\n', '        balances[owner] = INITIAL_SUPPLY;\n', '        tokenAllocated = 0;\n', '        transfersEnabled = true;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address _investor) public payable returns (uint256){\n', '        require(_investor != address(0));\n', '        require(saleToken == true);\n', '        address wallet = owner;\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = validPurchaseTokens(weiAmount);\n', '        if (tokens == 0) {revert();}\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        tokenAllocated = tokenAllocated.add(tokens);\n', '        mint(_investor, tokens, owner);\n', '\n', '        TokenPurchase(_investor, weiAmount, tokens);\n', '        wallet.transfer(weiAmount);\n', '        return tokens;\n', '    }\n', '\n', '    function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {\n', '        uint256 addTokens = getTotalAmountOfTokens(_weiAmount);\n', '        if (addTokens > balances[owner]) {\n', '            TokenLimitReached(tokenAllocated, addTokens);\n', '            return 0;\n', '        }\n', '        return addTokens;\n', '    }\n', '\n', '    /**\n', '    * If the user sends 0 ether, he receives 50 tokens.\n', '    * If he sends 0.001 ether, he receives 1500 tokens\n', '    * If he sends 0.005 ether he receives 9,000 tokens\n', '    * If he sends 0.01ether, he receives 20,000 tokens\n', '    * If he sends 0.05ether he receives 110,000 tokens\n', '    * If he sends 0.1ether, he receives 230,000 tokens\n', '    */\n', '    function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {\n', '        uint256 amountOfTokens = 100;\n', '        // if(_weiAmount == 0){\n', '            // amountOfTokens = 100 * (10**uint256(decimals));\n', '        // }\n', '        // if( _weiAmount == 0.001 ether){\n', '            // amountOfTokens = 15 * 10**2 * (10**uint256(decimals));\n', '        // }\n', '        // if( _weiAmount == 0.005 ether){\n', '            // amountOfTokens = 9 * 10**3 * (10**uint256(decimals));\n', '        // }\n', '        // if( _weiAmount == 0.01 ether){\n', '            // amountOfTokens = 20 * 10**3 * (10**uint256(decimals));\n', '        // }\n', '        // if( _weiAmount == 0.05 ether){\n', '            // amountOfTokens = 110 * 10**3 * (10**uint256(decimals));\n', '        // }\n', '        // if( _weiAmount == 0.1 ether){\n', '            // amountOfTokens = 230 * 10**3 * (10**uint256(decimals));\n', '        // }\n', '        return amountOfTokens;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_owner]);\n', '\n', '        balances[_to] = balances[_to].add(_amount);\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        Transfer(_owner, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) onlyOwner public returns (bool){\n', '        require(_newOwner != address(0));\n', '        OwnerChanged(owner, _newOwner);\n', '        owner = _newOwner;\n', '        return true;\n', '    }\n', '\n', '    function startSale() public onlyOwner {\n', '        saleToken = true;\n', '    }\n', '\n', '    function stopSale() public onlyOwner {\n', '        saleToken = false;\n', '    }\n', '\n', '    function enableTransfers(bool _transfersEnabled) onlyOwner public {\n', '        transfersEnabled = _transfersEnabled;\n', '    }\n', '\n', '    /**\n', '     * Peterson&#39;s Law Protection\n', '     * Claim tokens\n', '     */\n', '    function claimTokens() public onlyOwner {\n', '        owner.transfer(this.balance);\n', '        uint256 balance = balanceOf(this);\n', '        transfer(owner, balance);\n', '        Transfer(this, owner, balance);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    /**\n', '    * @dev protection against short address attack\n', '    */\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract UBOToken is StandardToken {\n', '\n', '    string public constant name = "UBSexone";\n', '    string public constant symbol = "UBO";\n', '    uint8 public constant decimals =0;\n', '    uint256 public constant INITIAL_SUPPLY = 1 * 50000000 * (10**uint256(decimals));\n', '    uint256 public weiRaised;\n', '    uint256 public tokenAllocated;\n', '    address public owner;\n', '    bool public saleToken = true;\n', '\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '    event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    function UBOToken() public {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        //owner = _owner;\n', '        owner = msg.sender; // for testing\n', '        balances[owner] = INITIAL_SUPPLY;\n', '        tokenAllocated = 0;\n', '        transfersEnabled = true;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address _investor) public payable returns (uint256){\n', '        require(_investor != address(0));\n', '        require(saleToken == true);\n', '        address wallet = owner;\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = validPurchaseTokens(weiAmount);\n', '        if (tokens == 0) {revert();}\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        tokenAllocated = tokenAllocated.add(tokens);\n', '        mint(_investor, tokens, owner);\n', '\n', '        TokenPurchase(_investor, weiAmount, tokens);\n', '        wallet.transfer(weiAmount);\n', '        return tokens;\n', '    }\n', '\n', '    function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {\n', '        uint256 addTokens = getTotalAmountOfTokens(_weiAmount);\n', '        if (addTokens > balances[owner]) {\n', '            TokenLimitReached(tokenAllocated, addTokens);\n', '            return 0;\n', '        }\n', '        return addTokens;\n', '    }\n', '\n', '    /**\n', '    * If the user sends 0 ether, he receives 50 tokens.\n', '    * If he sends 0.001 ether, he receives 1500 tokens\n', '    * If he sends 0.005 ether he receives 9,000 tokens\n', '    * If he sends 0.01ether, he receives 20,000 tokens\n', '    * If he sends 0.05ether he receives 110,000 tokens\n', '    * If he sends 0.1ether, he receives 230,000 tokens\n', '    */\n', '    function getTotalAmountOfTokens(uint256 _weiAmount) internal pure returns (uint256) {\n', '        uint256 amountOfTokens = 100;\n', '        // if(_weiAmount == 0){\n', '            // amountOfTokens = 100 * (10**uint256(decimals));\n', '        // }\n', '        // if( _weiAmount == 0.001 ether){\n', '            // amountOfTokens = 15 * 10**2 * (10**uint256(decimals));\n', '        // }\n', '        // if( _weiAmount == 0.005 ether){\n', '            // amountOfTokens = 9 * 10**3 * (10**uint256(decimals));\n', '        // }\n', '        // if( _weiAmount == 0.01 ether){\n', '            // amountOfTokens = 20 * 10**3 * (10**uint256(decimals));\n', '        // }\n', '        // if( _weiAmount == 0.05 ether){\n', '            // amountOfTokens = 110 * 10**3 * (10**uint256(decimals));\n', '        // }\n', '        // if( _weiAmount == 0.1 ether){\n', '            // amountOfTokens = 230 * 10**3 * (10**uint256(decimals));\n', '        // }\n', '        return amountOfTokens;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount, address _owner) internal returns (bool) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_owner]);\n', '\n', '        balances[_to] = balances[_to].add(_amount);\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        Transfer(_owner, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) onlyOwner public returns (bool){\n', '        require(_newOwner != address(0));\n', '        OwnerChanged(owner, _newOwner);\n', '        owner = _newOwner;\n', '        return true;\n', '    }\n', '\n', '    function startSale() public onlyOwner {\n', '        saleToken = true;\n', '    }\n', '\n', '    function stopSale() public onlyOwner {\n', '        saleToken = false;\n', '    }\n', '\n', '    function enableTransfers(bool _transfersEnabled) onlyOwner public {\n', '        transfersEnabled = _transfersEnabled;\n', '    }\n', '\n', '    /**\n', "     * Peterson's Law Protection\n", '     * Claim tokens\n', '     */\n', '    function claimTokens() public onlyOwner {\n', '        owner.transfer(this.balance);\n', '        uint256 balance = balanceOf(this);\n', '        transfer(owner, balance);\n', '        Transfer(this, owner, balance);\n', '    }\n', '}']

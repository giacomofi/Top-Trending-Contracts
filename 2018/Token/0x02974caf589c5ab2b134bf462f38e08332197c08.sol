['pragma solidity ^0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    /**\n', '    * Protection against short address attack\n', '    */\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        }\n', '        else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function changeOwner(address _newOwner) onlyOwner internal {\n', '        require(_newOwner != address(0));\n', '        OwnerChanged(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    string public constant name = "bean";\n', '    string public constant symbol = "XCC";\n', '    uint8 public constant decimals = 18;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {\n', '        balances[_to] = balances[_to].add(_amount);\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(_owner, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyOwner canMint internal returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Peterson&#39;s Law Protection\n', '     * Claim tokens\n', '     */\n', '    function claimTokens(address _token) public onlyOwner {\n', '    //function claimTokens(address _token) public {  //for test\n', '        if (_token == 0x0) {\n', '            owner.transfer(this.balance);\n', '            return;\n', '        }\n', '        MintableToken token = MintableToken(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '        Transfer(_token, owner, balance);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Crowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '    // address where funds are collected\n', '    address public wallet;\n', '\n', '    // amount of raised money in wei\n', '    uint256 public weiRaised;\n', '    uint256 public tokenAllocated;\n', '\n', '    function Crowdsale(\n', '    address _wallet\n', '    )\n', '    public\n', '    {\n', '        require(_wallet != address(0));\n', '        wallet = _wallet;\n', '    }\n', '}\n', '\n', '\n', 'contract XCCCrowdsale is Ownable, Crowdsale, MintableToken {\n', '    using SafeMath for uint256;\n', '\n', '    enum State {Active, Closed}\n', '    State public state;\n', '\n', '    // https://www.coingecko.com/en/coins/ethereum\n', '    //$0.002 = 1 token => $ 1,000 = 1.6730521490354853 ETH =>\n', '    // 500,000 token = 1.6730521490354853 ETH => 1 ETH = 500,000/1.6730521490354853 = 298,855\n', '    uint256 public rate  = 298855;\n', '    //uint256 public rate  = 300000; //for test&#39;s\n', '\n', '    mapping (address => uint256) public deposited;\n', '    mapping(address => bool) public whitelist;\n', '\n', '    uint256 public constant INITIAL_SUPPLY = 5 * (10 ** 12) * (10 ** uint256(decimals));\n', '    uint256 public fundForSale = 5 * (10 ** 12) * (10 ** uint256(decimals));\n', '    uint256 public fundPreSale =  1 * (10 ** 12) * (10 ** uint256(decimals));\n', '\n', '    uint256 public countInvestor;\n', '\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '    event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);\n', '    event Finalized();\n', '\n', '    function XCCCrowdsale(\n', '    address _owner\n', '    )\n', '    public\n', '    Crowdsale(_owner)\n', '    {\n', '        require(_owner != address(0));\n', '        owner = _owner;\n', '        transfersEnabled = true;\n', '        mintingFinished = false;\n', '        state = State.Active;\n', '        totalSupply = INITIAL_SUPPLY;\n', '        bool resultMintForOwner = mintForOwner(owner);\n', '        require(resultMintForOwner);\n', '    }\n', '\n', '    modifier inState(State _state) {\n', '        require(state == _state);\n', '        _;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address _investor) public inState(State.Active) payable returns (uint256){\n', '        require(_investor != address(0));\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = validPurchaseTokens(weiAmount);\n', '        if (tokens == 0) {revert();}\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        tokenAllocated = tokenAllocated.add(tokens);\n', '        mint(_investor, tokens, owner);\n', '\n', '        TokenPurchase(_investor, weiAmount, tokens);\n', '        if (deposited[_investor] == 0) {\n', '            countInvestor = countInvestor.add(1);\n', '        }\n', '        deposit(_investor);\n', '        wallet.transfer(weiAmount);\n', '        return tokens;\n', '    }\n', '\n', '    function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {\n', '        uint256 currentDate = now;\n', '        //currentDate = 1526860799; //for test&#39;s\n', '        uint256 currentPeriod = getPeriod(currentDate);\n', '        uint256 amountOfTokens = 0;\n', '        if(currentPeriod < 2){\n', '            amountOfTokens = _weiAmount.mul(rate);\n', '            if (10**3*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 10**5*(10 ** uint256(decimals))) {\n', '                amountOfTokens = amountOfTokens.mul(101).div(100);\n', '            }\n', '            if (10**5*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 10**6*(10 ** uint256(decimals))) {\n', '                amountOfTokens = amountOfTokens.mul(1015).div(1000);\n', '            }\n', '            if (10**6*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 5*10**6*(10 ** uint256(decimals))) {\n', '                amountOfTokens = amountOfTokens.mul(1025).div(1000);\n', '            }\n', '            if (5*10**6*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 9*10**6*(10 ** uint256(decimals))) {\n', '                amountOfTokens = amountOfTokens.mul(105).div(100);\n', '            }\n', '            if (9*10**6*(10 ** uint256(decimals)) <= amountOfTokens) {\n', '                amountOfTokens = amountOfTokens.mul(110).div(100);\n', '            }\n', '\n', '            if(currentPeriod == 0){\n', '                amountOfTokens = amountOfTokens.mul(1075).div(1000);\n', '                if (tokenAllocated.add(amountOfTokens) > fundPreSale) {\n', '                    TokenLimitReached(tokenAllocated, amountOfTokens);\n', '                    return 0;\n', '                }\n', '            return amountOfTokens;\n', '            }\n', '        }\n', '        return amountOfTokens;\n', '    }\n', '\n', '    function getPeriod(uint256 _currentDate) public pure returns (uint) {\n', '        //1525651200 - May, 07, 2018 00:00:00 && 1528156799 - Jun, 04, 2018 23:59:59\n', '        //1540080000 - Oct, 21, 2018 00:00:00 && 1542758399 - Nov, 20, 2018 23:59:59\n', '\n', '        if( 1525651200 <= _currentDate && _currentDate <= 1528156799){\n', '            return 0;\n', '        }\n', '        if( 1540080000 <= _currentDate && _currentDate <= 1542758399){\n', '            return 1;\n', '        }\n', '        return 10;\n', '    }\n', '\n', '    function deposit(address investor) internal {\n', '        require(state == State.Active);\n', '        deposited[investor] = deposited[investor].add(msg.value);\n', '    }\n', '\n', '    function mintForOwner(address _wallet) internal returns (bool result) {\n', '        result = false;\n', '        require(_wallet != address(0));\n', '        balances[_wallet] = balances[_wallet].add(INITIAL_SUPPLY);\n', '        result = true;\n', '    }\n', '\n', '    function getDeposited(address _investor) public view returns (uint256){\n', '        return deposited[_investor];\n', '    }\n', '\n', '    function validPurchaseTokens(uint256 _weiAmount) public inState(State.Active) returns (uint256) {\n', '        uint256 addTokens = getTotalAmountOfTokens(_weiAmount);\n', '        if (10**3*(10 ** uint256(decimals)) > addTokens || addTokens > 9999*10**3*(10 ** uint256(decimals))) {\n', '            return 0;\n', '        }\n', '        if (tokenAllocated.add(addTokens) > fundForSale) {\n', '            TokenLimitReached(tokenAllocated, addTokens);\n', '            return 0;\n', '        }\n', '        return addTokens;\n', '    }\n', '\n', '    function finalize() public onlyOwner inState(State.Active) returns (bool result) {\n', '        result = false;\n', '        state = State.Closed;\n', '        wallet.transfer(this.balance);\n', '        finishMinting();\n', '        Finalized();\n', '        result = true;\n', '    }\n', '\n', '    function setRate(uint256 _newRate) external onlyOwner returns (bool){\n', '        require(_newRate > 0);\n', '        rate = _newRate;\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    /**\n', '    * Protection against short address attack\n', '    */\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        }\n', '        else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function changeOwner(address _newOwner) onlyOwner internal {\n', '        require(_newOwner != address(0));\n', '        OwnerChanged(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    string public constant name = "bean";\n', '    string public constant symbol = "XCC";\n', '    uint8 public constant decimals = 18;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {\n', '        balances[_to] = balances[_to].add(_amount);\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(_owner, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyOwner canMint internal returns (bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '\n', '    /**\n', "     * Peterson's Law Protection\n", '     * Claim tokens\n', '     */\n', '    function claimTokens(address _token) public onlyOwner {\n', '    //function claimTokens(address _token) public {  //for test\n', '        if (_token == 0x0) {\n', '            owner.transfer(this.balance);\n', '            return;\n', '        }\n', '        MintableToken token = MintableToken(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '        Transfer(_token, owner, balance);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Crowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '    // address where funds are collected\n', '    address public wallet;\n', '\n', '    // amount of raised money in wei\n', '    uint256 public weiRaised;\n', '    uint256 public tokenAllocated;\n', '\n', '    function Crowdsale(\n', '    address _wallet\n', '    )\n', '    public\n', '    {\n', '        require(_wallet != address(0));\n', '        wallet = _wallet;\n', '    }\n', '}\n', '\n', '\n', 'contract XCCCrowdsale is Ownable, Crowdsale, MintableToken {\n', '    using SafeMath for uint256;\n', '\n', '    enum State {Active, Closed}\n', '    State public state;\n', '\n', '    // https://www.coingecko.com/en/coins/ethereum\n', '    //$0.002 = 1 token => $ 1,000 = 1.6730521490354853 ETH =>\n', '    // 500,000 token = 1.6730521490354853 ETH => 1 ETH = 500,000/1.6730521490354853 = 298,855\n', '    uint256 public rate  = 298855;\n', "    //uint256 public rate  = 300000; //for test's\n", '\n', '    mapping (address => uint256) public deposited;\n', '    mapping(address => bool) public whitelist;\n', '\n', '    uint256 public constant INITIAL_SUPPLY = 5 * (10 ** 12) * (10 ** uint256(decimals));\n', '    uint256 public fundForSale = 5 * (10 ** 12) * (10 ** uint256(decimals));\n', '    uint256 public fundPreSale =  1 * (10 ** 12) * (10 ** uint256(decimals));\n', '\n', '    uint256 public countInvestor;\n', '\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '    event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);\n', '    event Finalized();\n', '\n', '    function XCCCrowdsale(\n', '    address _owner\n', '    )\n', '    public\n', '    Crowdsale(_owner)\n', '    {\n', '        require(_owner != address(0));\n', '        owner = _owner;\n', '        transfersEnabled = true;\n', '        mintingFinished = false;\n', '        state = State.Active;\n', '        totalSupply = INITIAL_SUPPLY;\n', '        bool resultMintForOwner = mintForOwner(owner);\n', '        require(resultMintForOwner);\n', '    }\n', '\n', '    modifier inState(State _state) {\n', '        require(state == _state);\n', '        _;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    // low level token purchase function\n', '    function buyTokens(address _investor) public inState(State.Active) payable returns (uint256){\n', '        require(_investor != address(0));\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = validPurchaseTokens(weiAmount);\n', '        if (tokens == 0) {revert();}\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        tokenAllocated = tokenAllocated.add(tokens);\n', '        mint(_investor, tokens, owner);\n', '\n', '        TokenPurchase(_investor, weiAmount, tokens);\n', '        if (deposited[_investor] == 0) {\n', '            countInvestor = countInvestor.add(1);\n', '        }\n', '        deposit(_investor);\n', '        wallet.transfer(weiAmount);\n', '        return tokens;\n', '    }\n', '\n', '    function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {\n', '        uint256 currentDate = now;\n', "        //currentDate = 1526860799; //for test's\n", '        uint256 currentPeriod = getPeriod(currentDate);\n', '        uint256 amountOfTokens = 0;\n', '        if(currentPeriod < 2){\n', '            amountOfTokens = _weiAmount.mul(rate);\n', '            if (10**3*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 10**5*(10 ** uint256(decimals))) {\n', '                amountOfTokens = amountOfTokens.mul(101).div(100);\n', '            }\n', '            if (10**5*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 10**6*(10 ** uint256(decimals))) {\n', '                amountOfTokens = amountOfTokens.mul(1015).div(1000);\n', '            }\n', '            if (10**6*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 5*10**6*(10 ** uint256(decimals))) {\n', '                amountOfTokens = amountOfTokens.mul(1025).div(1000);\n', '            }\n', '            if (5*10**6*(10 ** uint256(decimals)) <= amountOfTokens && amountOfTokens < 9*10**6*(10 ** uint256(decimals))) {\n', '                amountOfTokens = amountOfTokens.mul(105).div(100);\n', '            }\n', '            if (9*10**6*(10 ** uint256(decimals)) <= amountOfTokens) {\n', '                amountOfTokens = amountOfTokens.mul(110).div(100);\n', '            }\n', '\n', '            if(currentPeriod == 0){\n', '                amountOfTokens = amountOfTokens.mul(1075).div(1000);\n', '                if (tokenAllocated.add(amountOfTokens) > fundPreSale) {\n', '                    TokenLimitReached(tokenAllocated, amountOfTokens);\n', '                    return 0;\n', '                }\n', '            return amountOfTokens;\n', '            }\n', '        }\n', '        return amountOfTokens;\n', '    }\n', '\n', '    function getPeriod(uint256 _currentDate) public pure returns (uint) {\n', '        //1525651200 - May, 07, 2018 00:00:00 && 1528156799 - Jun, 04, 2018 23:59:59\n', '        //1540080000 - Oct, 21, 2018 00:00:00 && 1542758399 - Nov, 20, 2018 23:59:59\n', '\n', '        if( 1525651200 <= _currentDate && _currentDate <= 1528156799){\n', '            return 0;\n', '        }\n', '        if( 1540080000 <= _currentDate && _currentDate <= 1542758399){\n', '            return 1;\n', '        }\n', '        return 10;\n', '    }\n', '\n', '    function deposit(address investor) internal {\n', '        require(state == State.Active);\n', '        deposited[investor] = deposited[investor].add(msg.value);\n', '    }\n', '\n', '    function mintForOwner(address _wallet) internal returns (bool result) {\n', '        result = false;\n', '        require(_wallet != address(0));\n', '        balances[_wallet] = balances[_wallet].add(INITIAL_SUPPLY);\n', '        result = true;\n', '    }\n', '\n', '    function getDeposited(address _investor) public view returns (uint256){\n', '        return deposited[_investor];\n', '    }\n', '\n', '    function validPurchaseTokens(uint256 _weiAmount) public inState(State.Active) returns (uint256) {\n', '        uint256 addTokens = getTotalAmountOfTokens(_weiAmount);\n', '        if (10**3*(10 ** uint256(decimals)) > addTokens || addTokens > 9999*10**3*(10 ** uint256(decimals))) {\n', '            return 0;\n', '        }\n', '        if (tokenAllocated.add(addTokens) > fundForSale) {\n', '            TokenLimitReached(tokenAllocated, addTokens);\n', '            return 0;\n', '        }\n', '        return addTokens;\n', '    }\n', '\n', '    function finalize() public onlyOwner inState(State.Active) returns (bool result) {\n', '        result = false;\n', '        state = State.Closed;\n', '        wallet.transfer(this.balance);\n', '        finishMinting();\n', '        Finalized();\n', '        result = true;\n', '    }\n', '\n', '    function setRate(uint256 _newRate) external onlyOwner returns (bool){\n', '        require(_newRate > 0);\n', '        rate = _newRate;\n', '        return true;\n', '    }\n', '}']

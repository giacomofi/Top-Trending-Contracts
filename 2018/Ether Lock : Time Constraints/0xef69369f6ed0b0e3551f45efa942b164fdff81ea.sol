['pragma solidity ^0.4.25;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    /**\n', '    * Protection against short address attack\n', '    */\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        }\n', '        else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function changeOwner(address _newOwner) onlyOwner internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnerChanged(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    string public constant name = "WebSpaceX";\n', '    string public constant symbol = "WSPX";\n', '    uint8 public constant decimals = 18;\n', '    mapping(uint8 => uint8) public approveOwner;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {\n', '        balances[_to] = balances[_to].add(_amount);\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(_owner, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyOwner canMint internal returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '\n', '    /**\n', "     * Peterson's Law Protection\n", '     * Claim tokens\n', '     */\n', '    function claimTokens(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner.transfer(address(this).balance);\n', '            return;\n', '        }\n', '        MintableToken token = MintableToken(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '        emit Transfer(_token, owner, balance);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract Crowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '    // address where funds are collected\n', '    address public wallet;\n', '    uint256 public hardWeiCap = 15830 ether;\n', '\n', '    // amount of raised money in wei\n', '    uint256 public weiRaised;\n', '    uint256 public tokenAllocated;\n', '\n', '    constructor(address _wallet) public {\n', '        require(_wallet != address(0));\n', '        wallet = _wallet;\n', '    }\n', '}\n', '\n', '\n', 'contract WSPXCrowdsale is Ownable, Crowdsale, MintableToken {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public rate  = 312500;\n', '\n', '    mapping (address => uint256) public deposited;\n', '    mapping (address => bool) internal isRefferer;\n', '\n', '    uint256 public weiMinSale = 0.1 ether;\n', '\n', '    uint256 public constant INITIAL_SUPPLY = 9 * 10**9 * (10 ** uint256(decimals));\n', '\n', '    uint256 public fundForSale   = 6 * 10**9 * (10 ** uint256(decimals));\n', '    uint256 public    fundTeam   = 1 * 10**9 * (10 ** uint256(decimals));\n', '    uint256 public    fundBounty = 2 * 10**9 * (10 ** uint256(decimals));\n', '\n', '    address public addressFundTeam   = 0xA2434A8F6457fe7CF29AEa841cf3D0B0FE3217c8;\n', '    address public addressFundBounty = 0x8828c48DEc2764868aD3bBf7fE9e8aBE773E3064;\n', '\n', '    // 1 Jan - 15 Jan\n', '    uint256 startTimeIcoStage1 = 1546300800; // Tue, 01 Jan 2019 00:00:00 GMT\n', '    uint256 endTimeIcoStage1 =   1547596799; // Tue, 15 Jan 2019 23:59:59 GMT\n', '\n', '    // 16 Jan - 31 Jan\n', '    uint256 startTimeIcoStage2 = 1547596800; // Wed, 16 Jan 2019 00:00:00 GMT\n', '    uint256 endTimeIcoStage2   = 1548979199; // Thu, 31 Jan 2019 23:59:59 GMT\n', '\n', '    // 1 Feb - 15 Feb\n', '    uint256 startTimeIcoStage3 = 1548979200; // Fri, 01 Feb 2019 00:00:00 GMT\n', '    uint256 endTimeIcoStage3   = 1554076799; // Fri, 15 Feb 2019 23:59:59 GMT\n', '\n', '    uint256 limitStage1 =  2 * 10**9 * (10 ** uint256(decimals));\n', '    uint256 limitStage2 =  4 * 10**9 * (10 ** uint256(decimals));\n', '    uint256 limitStage3 =  6 * 10**9 * (10 ** uint256(decimals));\n', '\n', '    uint256 public countInvestor;\n', '\n', '    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);\n', '    event TokenLimitReached(address indexed sender, uint256 tokenRaised, uint256 purchasedToken);\n', '    event CurrentPeriod(uint period);\n', '    event ChangeTime(address indexed owner, uint256 newValue, uint256 oldValue);\n', '    event ChangeAddressWallet(address indexed owner, address indexed newAddress, address indexed oldAddress);\n', '    event ChangeRate(address indexed owner, uint256 newValue, uint256 oldValue);\n', '    event Burn(address indexed burner, uint256 value);\n', '    event HardCapReached();\n', '\n', '\n', '    constructor(address _owner, address _wallet) public\n', '    Crowdsale(_wallet)\n', '    {\n', '        require(_owner != address(0));\n', '        owner = _owner;\n', "        //owner = msg.sender; // for test's\n", '        transfersEnabled = true;\n', '        mintingFinished = false;\n', '        totalSupply = INITIAL_SUPPLY;\n', '        bool resultMintForOwner = mintForFund(owner);\n', '        require(resultMintForOwner);\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function() payable public {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    function buyTokens(address _investor) public payable returns (uint256){\n', '        require(_investor != address(0));\n', '        uint256 weiAmount = msg.value;\n', '        uint256 tokens = validPurchaseTokens(weiAmount);\n', '        if (tokens == 0) {revert();}\n', '        weiRaised = weiRaised.add(weiAmount);\n', '        tokenAllocated = tokenAllocated.add(tokens);\n', '        mint(_investor, tokens, owner);\n', '\n', '        emit TokenPurchase(_investor, weiAmount, tokens);\n', '        if (deposited[_investor] == 0) {\n', '            countInvestor = countInvestor.add(1);\n', '        }\n', '        deposit(_investor);\n', '        wallet.transfer(weiAmount);\n', '        return tokens;\n', '    }\n', '\n', '    function getTotalAmountOfTokens(uint256 _weiAmount) internal returns (uint256) {\n', '        uint256 currentDate = now;\n', "        //currentDate = 1547114400; // Thu, 10 Jan 2019 10:00:00 GMT // for test's\n", '        uint currentPeriod = 0;\n', '        currentPeriod = getPeriod(currentDate);\n', '        uint256 amountOfTokens = 0;\n', '        if(currentPeriod > 0){\n', '            if(currentPeriod == 1){\n', '                amountOfTokens = _weiAmount.mul(rate).mul(130).div(100);\n', '                if (tokenAllocated.add(amountOfTokens) > limitStage1) {\n', '                    currentPeriod = currentPeriod.add(1);\n', '                    amountOfTokens = 0;\n', '                }\n', '            }\n', '            if(currentPeriod == 2){\n', '                amountOfTokens = _weiAmount.mul(rate).mul(120).div(100);\n', '                if (tokenAllocated.add(amountOfTokens) > limitStage2) {\n', '                    currentPeriod = currentPeriod.add(1);\n', '                    amountOfTokens = 0;\n', '                }\n', '            }\n', '            if(currentPeriod == 3){\n', '                amountOfTokens = _weiAmount.mul(rate).mul(110).div(100);\n', '                if (tokenAllocated.add(amountOfTokens) > limitStage3) {\n', '                    currentPeriod = 0;\n', '                    amountOfTokens = 0;\n', '                }\n', '            }\n', '        }\n', '        emit CurrentPeriod(currentPeriod);\n', '        return amountOfTokens;\n', '    }\n', '\n', '    function getPeriod(uint256 _currentDate) public view returns (uint) {\n', '        if(_currentDate < startTimeIcoStage1){\n', '            return 0;\n', '        }\n', '        if( startTimeIcoStage1 <= _currentDate && _currentDate <= endTimeIcoStage1){\n', '            return 1;\n', '        }\n', '        if( startTimeIcoStage2 <= _currentDate && _currentDate <= endTimeIcoStage2){\n', '            return 2;\n', '        }\n', '        if( startTimeIcoStage3 <= _currentDate && _currentDate <= endTimeIcoStage3){\n', '            return 3;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function deposit(address investor) internal {\n', '        deposited[investor] = deposited[investor].add(msg.value);\n', '    }\n', '\n', '    function mintForFund(address _walletOwner) internal returns (bool result) {\n', '        result = false;\n', '        require(_walletOwner != address(0));\n', '        balances[_walletOwner] = balances[_walletOwner].add(fundForSale);\n', '        balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);\n', '        balances[addressFundBounty] = balances[addressFundBounty].add(fundBounty);\n', '        result = true;\n', '    }\n', '\n', '    function getDeposited(address _investor) external view returns (uint256){\n', '        return deposited[_investor];\n', '    }\n', '\n', '    function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {\n', '        uint256 addTokens = getTotalAmountOfTokens(_weiAmount);\n', '        if (tokenAllocated.add(addTokens) > balances[owner]) {\n', '            emit TokenLimitReached(msg.sender, tokenAllocated, addTokens);\n', '            return 0;\n', '        }\n', '        if (weiRaised.add(_weiAmount) > hardWeiCap) {\n', '            emit HardCapReached();\n', '            return 0;\n', '        }\n', '        if (_weiAmount < weiMinSale) {\n', '            return 0;\n', '        }\n', '\n', '    return addTokens;\n', '    }\n', '\n', '    /**\n', '     * @dev owner burn Token.\n', '     * @param _value amount of burnt tokens\n', '     */\n', '    function ownerBurnToken(uint _value) public onlyOwner {\n', '        require(_value > 0);\n', '        require(_value <= balances[owner]);\n', '        require(_value <= totalSupply);\n', '\n', '        balances[owner] = balances[owner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev owner change time for startTimeIcoStage1\n', '     * @param _value new time value\n', '     */\n', '    function setStartTimeIcoStage1(uint256 _value) external onlyOwner {\n', '        require(_value > 0);\n', '        uint256 _oldValue = startTimeIcoStage1;\n', '        startTimeIcoStage1 = _value;\n', '        emit ChangeTime(msg.sender, _value, _oldValue);\n', '    }\n', '\n', '    /**\n', '     * @dev owner change time for endTimeIcoStage1\n', '     * @param _value new time value\n', '     */\n', '    function setEndTimeIcoStage1(uint256 _value) external onlyOwner {\n', '        require(_value > 0);\n', '        uint256 _oldValue = endTimeIcoStage1;\n', '        endTimeIcoStage1 = _value;\n', '        emit ChangeTime(msg.sender, _value, _oldValue);\n', '    }\n', '\n', '    /**\n', '     * @dev owner change time for startTimeIcoStage2\n', '     * @param _value new time value\n', '     */\n', '    function setStartTimeIcoStage2(uint256 _value) external onlyOwner {\n', '        require(_value > 0);\n', '        uint256 _oldValue = startTimeIcoStage2;\n', '        startTimeIcoStage2 = _value;\n', '        emit ChangeTime(msg.sender, _value, _oldValue);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev owner change time for endTimeIcoStage2\n', '     * @param _value new time value\n', '     */\n', '    function setEndTimeIcoStage2(uint256 _value) external onlyOwner {\n', '        require(_value > 0);\n', '        uint256 _oldValue = endTimeIcoStage2;\n', '        endTimeIcoStage2 = _value;\n', '        emit ChangeTime(msg.sender, _value, _oldValue);\n', '    }\n', '\n', '    /**\n', ' * @dev owner change time for startTimeIcoStage3\n', ' * @param _value new time value\n', ' */\n', '    function setStartTimeIcoStage3(uint256 _value) external onlyOwner {\n', '        require(_value > 0);\n', '        uint256 _oldValue = startTimeIcoStage3;\n', '        startTimeIcoStage3 = _value;\n', '        emit ChangeTime(msg.sender, _value, _oldValue);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev owner change time for endTimeIcoStage3\n', '     * @param _value new time value\n', '     */\n', '    function setEndTimeIcoStage3(uint256 _value) external onlyOwner {\n', '        require(_value > 0);\n', '        uint256 _oldValue = endTimeIcoStage3;\n', '        endTimeIcoStage3 = _value;\n', '        emit ChangeTime(msg.sender, _value, _oldValue);\n', '    }\n', '\n', '    /**\n', '     * @dev owner change address of wallet for collecting ETH\n', '     * @param _newWallet new address of wallet\n', '     */\n', '    function setWallet(address _newWallet) external onlyOwner {\n', '        require(_newWallet != address(0));\n', '        address _oldWallet = wallet;\n', '        wallet = _newWallet;\n', '        emit ChangeAddressWallet(msg.sender, _newWallet, _oldWallet);\n', '    }\n', '\n', '    /**\n', '     * @dev owner change price of tokens\n', '     * @param _newRate new price\n', '     */\n', '    function setRate(uint256 _newRate) external onlyOwner {\n', '        require(_newRate > 0);\n', '        uint256 _oldRate = rate;\n', '        rate = _newRate;\n', '        emit ChangeRate(msg.sender, _newRate, _oldRate);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    address public addressFundTeam = 0x0DA34504b759071605f89BE43b2804b1869404f2;\n', '    uint256 public fundTeam = 1125 * 10**4 * (10 ** 18);\n', '    uint256 endTimeIco = 1551535200; //Saturday, 2. March 2019 14:00:00\n', '\n', '    /**\n', '    * Protection against short address attack\n', '    */\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '        if (msg.sender == addressFundTeam) {\n', '            require(checkVesting(_value, now) > 0);\n', '        }\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function checkVesting(uint256 _value, uint256 _currentTime) public view returns(uint8 period) {\n', '        period = 0;\n', '        require(endTimeIco <= _currentTime);\n', '        if (endTimeIco + 26 weeks <= _currentTime && _currentTime < endTimeIco + 52 weeks) {\n', '            period = 1;\n', '            require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(95).div(100));\n', '        }\n', '        if (endTimeIco + 52 weeks <= _currentTime && _currentTime < endTimeIco + 78 weeks) {\n', '            period = 2;\n', '            require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(85).div(100));\n', '        }\n', '        if (endTimeIco + 78 weeks <= _currentTime && _currentTime < endTimeIco + 104 weeks) {\n', '            period = 3;\n', '            require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(65).div(100));\n', '        }\n', '        if (endTimeIco + 104 weeks <= _currentTime && _currentTime < endTimeIco + 130 weeks) {\n', '            period = 4;\n', '            require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(35).div(100));\n', '        }\n', '        if (endTimeIco + 130 weeks <= _currentTime) {\n', '            period = 5;\n', '            require(balances[addressFundTeam].sub(_value) >= 0);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        }\n', '        else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract CryptoCasherToken is StandardToken, Ownable {\n', '    string public constant name = "CryptoCasher";\n', '    string public constant symbol = "CRR";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant INITIAL_SUPPLY = 75 * 10**6 * (10 ** uint256(decimals));\n', '\n', '    uint256 fundForSale = 525 * 10**5 * (10 ** uint256(decimals));\n', '\n', '    address addressFundAdvisors = 0xee3b4F0A6EA27cCDA45f2F58982EA54c5d7E8570;\n', '    uint256 fundAdvisors = 6 * 10**6 * (10 ** uint256(decimals));\n', '\n', '    address addressFundBounty = 0x97133480b61377A93dF382BebDFC3025D56bA2C6;\n', '    uint256 fundBounty = 375 * 10**4 * (10 ** uint256(decimals));\n', '\n', '    address addressFundBlchainReferal = 0x2F9092Fe1dACafF1165b080BfF3afFa6165e339a;\n', '    uint256 fundBlchainReferal = 75 * 10**4 * (10 ** uint256(decimals));\n', '\n', '    address addressFundWebSiteReferal = 0x45E2203eD8bD3888D052F4CF37ac91CF6563789D;\n', '    uint256 fundWebSiteReferal = 75 * 10**4 * (10 ** uint256(decimals));\n', '\n', '    address addressContract;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '    event Burn(address indexed burner, uint256 value);\n', '    event AddressContractChanged(address indexed addressContract, address indexed sender);\n', '\n', '\n', 'constructor (address _owner) public\n', '    {\n', '        require(_owner != address(0));\n', '        owner = _owner;\n', '        //owner = msg.sender; //for test&#39;s\n', '        transfersEnabled = true;\n', '        distribToken(owner);\n', '        totalSupply = INITIAL_SUPPLY;\n', '    }\n', '\n', '    /**\n', '    * @dev Add an contract admin\n', '    */\n', '    function setContractAddress(address _contract) public onlyOwner {\n', '        require(_contract != address(0));\n', '        addressContract = _contract;\n', '        emit AddressContractChanged(_contract, msg.sender);\n', '    }\n', '\n', '    modifier onlyContract() {\n', '        require(msg.sender == addressContract);\n', '        _;\n', '    }\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount, address _owner) external onlyContract returns (bool) {\n', '        require(_to != address(0) && _owner != address(0));\n', '        require(_amount <= balances[_owner]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_to] = balances[_to].add(_amount);\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(_owner, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Peterson&#39;s Law Protection\n', '     * Claim tokens\n', '     */\n', '    function claimTokens(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner.transfer(address(this).balance);\n', '            return;\n', '        }\n', '\n', '        CryptoCasherToken token = CryptoCasherToken(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '\n', '        emit Transfer(_token, owner, balance);\n', '    }\n', '\n', '    function distribToken(address _wallet) internal {\n', '        require(_wallet != address(0));\n', '\n', '        balances[addressFundAdvisors] = balances[addressFundAdvisors].add(fundAdvisors);\n', '\n', '        balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);\n', '\n', '        balances[addressFundBounty] = balances[addressFundBounty].add(fundBounty);\n', '        balances[addressFundBlchainReferal] = balances[addressFundBlchainReferal].add(fundBlchainReferal);\n', '        balances[addressFundWebSiteReferal] = balances[addressFundWebSiteReferal].add(fundWebSiteReferal);\n', '\n', '        balances[_wallet] = balances[_wallet].add(fundForSale);\n', '    }\n', '\n', '    /**\n', '    * @dev owner burn Token.\n', '    * @param _value amount of burnt tokens\n', '    */\n', '    function ownerBurnToken(uint _value) public onlyOwner {\n', '        require(_value > 0);\n', '        require(_value <= balances[owner]);\n', '        require(_value <= totalSupply);\n', '        require(_value <= fundForSale);\n', '\n', '        balances[owner] = balances[owner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address who) public view returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    bool public transfersEnabled;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    address public addressFundTeam = 0x0DA34504b759071605f89BE43b2804b1869404f2;\n', '    uint256 public fundTeam = 1125 * 10**4 * (10 ** 18);\n', '    uint256 endTimeIco = 1551535200; //Saturday, 2. March 2019 14:00:00\n', '\n', '    /**\n', '    * Protection against short address attack\n', '    */\n', '    modifier onlyPayloadSize(uint numwords) {\n', '        assert(msg.data.length == numwords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(transfersEnabled);\n', '        if (msg.sender == addressFundTeam) {\n', '            require(checkVesting(_value, now) > 0);\n', '        }\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function checkVesting(uint256 _value, uint256 _currentTime) public view returns(uint8 period) {\n', '        period = 0;\n', '        require(endTimeIco <= _currentTime);\n', '        if (endTimeIco + 26 weeks <= _currentTime && _currentTime < endTimeIco + 52 weeks) {\n', '            period = 1;\n', '            require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(95).div(100));\n', '        }\n', '        if (endTimeIco + 52 weeks <= _currentTime && _currentTime < endTimeIco + 78 weeks) {\n', '            period = 2;\n', '            require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(85).div(100));\n', '        }\n', '        if (endTimeIco + 78 weeks <= _currentTime && _currentTime < endTimeIco + 104 weeks) {\n', '            period = 3;\n', '            require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(65).div(100));\n', '        }\n', '        if (endTimeIco + 104 weeks <= _currentTime && _currentTime < endTimeIco + 130 weeks) {\n', '            period = 4;\n', '            require(balances[addressFundTeam].sub(_value) >= fundTeam.mul(35).div(100));\n', '        }\n', '        if (endTimeIco + 130 weeks <= _currentTime) {\n', '            period = 5;\n', '            require(balances[addressFundTeam].sub(_value) >= 0);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        }\n', '        else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract CryptoCasherToken is StandardToken, Ownable {\n', '    string public constant name = "CryptoCasher";\n', '    string public constant symbol = "CRR";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant INITIAL_SUPPLY = 75 * 10**6 * (10 ** uint256(decimals));\n', '\n', '    uint256 fundForSale = 525 * 10**5 * (10 ** uint256(decimals));\n', '\n', '    address addressFundAdvisors = 0xee3b4F0A6EA27cCDA45f2F58982EA54c5d7E8570;\n', '    uint256 fundAdvisors = 6 * 10**6 * (10 ** uint256(decimals));\n', '\n', '    address addressFundBounty = 0x97133480b61377A93dF382BebDFC3025D56bA2C6;\n', '    uint256 fundBounty = 375 * 10**4 * (10 ** uint256(decimals));\n', '\n', '    address addressFundBlchainReferal = 0x2F9092Fe1dACafF1165b080BfF3afFa6165e339a;\n', '    uint256 fundBlchainReferal = 75 * 10**4 * (10 ** uint256(decimals));\n', '\n', '    address addressFundWebSiteReferal = 0x45E2203eD8bD3888D052F4CF37ac91CF6563789D;\n', '    uint256 fundWebSiteReferal = 75 * 10**4 * (10 ** uint256(decimals));\n', '\n', '    address addressContract;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '    event Burn(address indexed burner, uint256 value);\n', '    event AddressContractChanged(address indexed addressContract, address indexed sender);\n', '\n', '\n', 'constructor (address _owner) public\n', '    {\n', '        require(_owner != address(0));\n', '        owner = _owner;\n', "        //owner = msg.sender; //for test's\n", '        transfersEnabled = true;\n', '        distribToken(owner);\n', '        totalSupply = INITIAL_SUPPLY;\n', '    }\n', '\n', '    /**\n', '    * @dev Add an contract admin\n', '    */\n', '    function setContractAddress(address _contract) public onlyOwner {\n', '        require(_contract != address(0));\n', '        addressContract = _contract;\n', '        emit AddressContractChanged(_contract, msg.sender);\n', '    }\n', '\n', '    modifier onlyContract() {\n', '        require(msg.sender == addressContract);\n', '        _;\n', '    }\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount, address _owner) external onlyContract returns (bool) {\n', '        require(_to != address(0) && _owner != address(0));\n', '        require(_amount <= balances[_owner]);\n', '        require(transfersEnabled);\n', '\n', '        balances[_to] = balances[_to].add(_amount);\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(_owner, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', "     * Peterson's Law Protection\n", '     * Claim tokens\n', '     */\n', '    function claimTokens(address _token) public onlyOwner {\n', '        if (_token == 0x0) {\n', '            owner.transfer(address(this).balance);\n', '            return;\n', '        }\n', '\n', '        CryptoCasherToken token = CryptoCasherToken(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        token.transfer(owner, balance);\n', '\n', '        emit Transfer(_token, owner, balance);\n', '    }\n', '\n', '    function distribToken(address _wallet) internal {\n', '        require(_wallet != address(0));\n', '\n', '        balances[addressFundAdvisors] = balances[addressFundAdvisors].add(fundAdvisors);\n', '\n', '        balances[addressFundTeam] = balances[addressFundTeam].add(fundTeam);\n', '\n', '        balances[addressFundBounty] = balances[addressFundBounty].add(fundBounty);\n', '        balances[addressFundBlchainReferal] = balances[addressFundBlchainReferal].add(fundBlchainReferal);\n', '        balances[addressFundWebSiteReferal] = balances[addressFundWebSiteReferal].add(fundWebSiteReferal);\n', '\n', '        balances[_wallet] = balances[_wallet].add(fundForSale);\n', '    }\n', '\n', '    /**\n', '    * @dev owner burn Token.\n', '    * @param _value amount of burnt tokens\n', '    */\n', '    function ownerBurnToken(uint _value) public onlyOwner {\n', '        require(_value > 0);\n', '        require(_value <= balances[owner]);\n', '        require(_value <= totalSupply);\n', '        require(_value <= fundForSale);\n', '\n', '        balances[owner] = balances[owner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '    }\n', '}']
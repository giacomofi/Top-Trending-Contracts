['/**\n', ' * The OGXNext "Orgura Exchange" token contract bases on the ERC20 standard token contracts \n', ' * OGX Coin ICO. (Orgura group)\n', ' * authors: Roongrote Suranart\n', ' * */\n', '\n', 'pragma solidity ^0.4.20;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        require(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) public balances;\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '        assert(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '        assert(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        assert(token.approve(spender, value));\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract TokenTimelock {\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    // ERC20 basic token contract being held\n', '    ERC20Basic public token;\n', '\n', '    // beneficiary of tokens after they are released\n', '    address public beneficiary;\n', '\n', '    // timestamp when token release is enabled\n', '    uint64 public releaseTime;\n', '\n', '    function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {\n', '        require(_releaseTime > uint64(block.timestamp));\n', '        token = _token;\n', '        beneficiary = _beneficiary;\n', '        releaseTime = _releaseTime;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to beneficiary.\n', '     */\n', '    function release() public {\n', '        require(uint64(block.timestamp) >= releaseTime);\n', '\n', '        uint256 amount = token.balanceOf(this);\n', '        require(amount > 0);\n', '\n', '        token.safeTransfer(beneficiary, amount);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract OrguraExchange is StandardToken, Owned {\n', '    string public constant name = "Orgura Exchange";\n', '    string public constant symbol = "OGX";\n', '    uint8 public constant decimals = 18;\n', '\n', '    /// Maximum tokens to be allocated.\n', '    uint256 public constant HARD_CAP = 800000000 * 10**uint256(decimals);  /* Initial supply is 800,000,000 OGX */\n', '\n', '    /// Maximum tokens to be allocated on the sale (50% of the hard cap)\n', '    uint256 public constant TOKENS_SALE_HARD_CAP = 400000000 * 10**uint256(decimals);\n', '\n', '    /// Base exchange rate is set to 1 ETH = 7,169 OGX.\n', '    uint256 public constant BASE_RATE = 7169;\n', '\n', '\n', "    /// seconds since 01.01.1970 to 19.04.2018 (0:00:00 o'clock UTC)\n", '    /// HOT sale start time\n', "    uint64 private constant dateSeedSale = 1523145600 + 0 hours; // 8 April 2018 00:00:00 o'clock UTC\n", '\n', '    /// Seed sale end time; Sale PreSale start time 20.04.2018\n', "    uint64 private constant datePreSale = 1524182400 + 0 hours; // 20 April 2018 0:00:00 o'clock UTC\n", '\n', '    /// Sale PreSale end time; Sale Round 1 start time 1.05.2018\n', "    uint64 private constant dateSaleR1 = 1525132800 + 0 hours; // 1 May 2018 0:00:00 o'clock UTC\n", '\n', '    /// Sale Round 1 end time; Sale Round 2 start time 15.05.2018\n', "    uint64 private constant dateSaleR2 = 1526342400 + 0 hours; // 15 May 2018 0:00:00 o'clock UTC\n", '\n', '    /// Sale Round 2 end time; Sale Round 3 start time 31.05.2018\n', "    uint64 private constant dateSaleR3 = 1527724800 + 0 hours; // 31 May 2018 0:00:00 o'clock UTC\n", '\n', "    /// Sale Round 3  end time; 14.06.2018 0:00:00 o'clock UTC\n", '    uint64 private constant date14June2018 = 1528934400 + 0 hours;\n', '\n', '    /// Token trading opening time (14.07.2018)\n', '    uint64 private constant date14July2018 = 1531526400;\n', '    \n', '    /// token caps for each round\n', '    uint256[5] private roundCaps = [\n', '        50000000* 10**uint256(decimals), // Sale Seed 50M  \n', '        50000000* 10**uint256(decimals), // Sale Presale 50M\n', '        100000000* 10**uint256(decimals), // Sale Round 1 100M\n', '        100000000* 10**uint256(decimals), // Sale Round 2 100M\n', '        100000000* 10**uint256(decimals) // Sale Round 3 100M\n', '    ];\n', '    uint8[5] private roundDiscountPercentages = [90, 75, 50, 30, 15];\n', '\n', '\n', '    /// Date Locked until\n', '    uint64[4] private dateTokensLockedTills = [\n', "        1536883200, // locked until this date (14 Sep 2018) 00:00:00 o'clock UTC\n", "        1544745600, // locked until this date (14 Dec 2018) 00:00:00 o'clock UTC\n", "        1557792000, // locked until this date (14 May 2019) 00:00:00 o'clock UTC\n", "        1581638400 // locked until this date (14 Feb 2020) 00:00:00 o'clock UTC\n", '    ];\n', '\n', '    //Locked Unil percentages\n', '    uint8[4] private lockedTillPercentages = [20, 20, 30, 30];\n', '\n', '    /// team tokens are locked until this date (27 APR 2019) 00:00:00\n', '    uint64 private constant dateTeamTokensLockedTill = 1556323200;\n', '\n', '    /// no tokens can be ever issued when this is set to "true"\n', '    bool public tokenSaleClosed = false;\n', '\n', '    /// contract to be called to release the Penthamon team tokens\n', '    address public timelockContractAddress;\n', '\n', '    modifier inProgress {\n', '        require(totalSupply < TOKENS_SALE_HARD_CAP\n', '            && !tokenSaleClosed && now >= dateSeedSale);\n', '        _;\n', '    }\n', '\n', '    /// Allow the closing to happen only once\n', '    modifier beforeEnd {\n', '        require(!tokenSaleClosed);\n', '        _;\n', '    }\n', '\n', '    /// Require that the token sale has been closed\n', '    modifier tradingOpen {\n', '        //Begin ad token sale closed\n', '        //require(tokenSaleClosed);\n', '        //_; \n', '\n', '        //Begin at date trading open setting\n', '        require(uint64(block.timestamp) > date14July2018);\n', '        _;\n', '    }\n', '\n', '    function OrguraExchange() public {\n', '    }\n', '\n', '    /// @dev This default function allows token to be purchased by directly\n', '    /// sending ether to this smart contract.\n', '    function () public payable {\n', '        purchaseTokens(msg.sender);\n', '    }\n', '\n', '    /// @dev Issue token based on Ether received.\n', '    /// @param _beneficiary Address that newly issued token will be sent to.\n', '    function purchaseTokens(address _beneficiary) public payable inProgress {\n', '        // only accept a minimum amount of ETH?\n', '        require(msg.value >= 0.01 ether);\n', '\n', '        uint256 tokens = computeTokenAmount(msg.value);\n', '        \n', '        // roll back if hard cap reached\n', '        require(totalSupply.add(tokens) <= TOKENS_SALE_HARD_CAP);\n', '        \n', '        doIssueTokens(_beneficiary, tokens);\n', '\n', '        /// forward the raised funds to the contract creator\n', '        owner.transfer(this.balance);\n', '    }\n', '\n', '    /// @dev Batch issue tokens on the presale\n', '    /// @param _addresses addresses that the presale tokens will be sent to.\n', '    /// @param _addresses the amounts of tokens, with decimals expanded (full).\n', '    function issueTokensMulti(address[] _addresses, uint256[] _tokens) public onlyOwner beforeEnd {\n', '        require(_addresses.length == _tokens.length);\n', '        require(_addresses.length <= 100);\n', '\n', '        for (uint256 i = 0; i < _tokens.length; i = i.add(1)) {\n', '            doIssueTokens(_addresses[i], _tokens[i]);\n', '        }\n', '    }\n', '\n', '\n', '    /// @dev Issue tokens for a single buyer on the presale\n', '    /// @param _beneficiary addresses that the presale tokens will be sent to.\n', '    /// @param _tokens the amount of tokens, with decimals expanded (full).\n', '    function issueTokens(address _beneficiary, uint256 _tokens) public onlyOwner beforeEnd {\n', '        doIssueTokens(_beneficiary, _tokens);\n', '    }\n', '\n', '    /// @dev issue tokens for a single buyer\n', '    /// @param _beneficiary addresses that the tokens will be sent to.\n', '    /// @param _tokens the amount of tokens, with decimals expanded (full).\n', '    function doIssueTokens(address _beneficiary, uint256 _tokens) internal {\n', '        require(_beneficiary != address(0));\n', '\n', '        // increase token total supply\n', '        totalSupply = totalSupply.add(_tokens);\n', '        // update the beneficiary balance to number of tokens sent\n', '        balances[_beneficiary] = balances[_beneficiary].add(_tokens);\n', '\n', '        // event is fired when tokens issued\n', '        Transfer(address(0), _beneficiary, _tokens);\n', '    }\n', '\n', '    /// @dev Returns the current price.\n', '    function price() public view returns (uint256 tokens) {\n', '        return computeTokenAmount(1 ether);\n', '    }\n', '\n', '    /// @dev Compute the amount of OGX token that can be purchased.\n', '    /// @param ethAmount Amount of Ether in WEI to purchase OGX.\n', '    /// @return Amount of LKC token to purchase\n', '    function computeTokenAmount(uint256 ethAmount) internal view returns (uint256 tokens) {\n', '        uint256 tokenBase = ethAmount.mul(BASE_RATE);\n', '        uint8 roundNum = currentRoundIndex();\n', '        tokens = tokenBase.mul(100)/(100 - (roundDiscountPercentages[roundNum]));\n', '        while(tokens.add(totalSupply) > roundCaps[roundNum] && roundNum < 4){\n', '           roundNum++;\n', '           tokens = tokenBase.mul(100)/(100 - (roundDiscountPercentages[roundNum])); \n', '        }\n', '    }\n', '\n', '    /// @dev Determine the current sale round\n', '    /// @return integer representing the index of the current sale round\n', '    function currentRoundIndex() internal view returns (uint8 roundNum) {\n', '        roundNum = currentRoundIndexByDate();\n', '\n', '        /// round determined by conjunction of both time and total sold tokens\n', '        while(roundNum < 4 && totalSupply > roundCaps[roundNum]) {\n', '            roundNum++;\n', '        }\n', '    }\n', '\n', '    /// @dev Determine the current sale tier.\n', '    /// @return the index of the current sale tier by date.\n', '    function currentRoundIndexByDate() internal view returns (uint8 roundNum) {\n', '        require(now <= date14June2018); \n', '        if(now > dateSaleR3) return 4;\n', '        if(now > dateSaleR2) return 3;\n', '        if(now > dateSaleR1) return 2;\n', '        if(now > datePreSale) return 1;\n', '        else return 0;\n', '    }\n', '\n', '     /// @dev Closes the sale, issues the team tokens and burns the unsold\n', '    function close() public onlyOwner beforeEnd {\n', '\n', '      /// Company team advisor and group tokens are equal to 37.5%\n', '        uint256 amount_lockedTokens = 300000000; // No decimals\n', '        \n', '        uint256 lockedTokens = amount_lockedTokens* 10**uint256(decimals); // 300M Reserve for Founder and team are added to the locked tokens \n', '        \n', '        //resevred tokens are available from the beginning 25%\n', '        uint256 reservedTokens =  100000000* 10**uint256(decimals); // 100M Reserve for parner\n', '        \n', '        //Sum tokens of locked and Reserved tokens \n', '        uint256 sumlockedAndReservedTokens = lockedTokens + reservedTokens;\n', '\n', '        //Init fegment\n', '        uint256 fagmentSale = 0* 10**uint256(decimals); // 0 fegment Sale\n', '\n', '        /// check for rounding errors when cap is reached\n', '        if(totalSupply.add(sumlockedAndReservedTokens) > HARD_CAP) {\n', '\n', '            sumlockedAndReservedTokens = HARD_CAP.sub(totalSupply);\n', '\n', '        }\n', '\n', '        //issueLockedTokens(lockedTokens);\n', '        \n', '        //-----------------------------------------------\n', '        // Locked until Loop calculat\n', '\n', '        uint256 _total_lockedTokens =0;\n', '\n', '        for (uint256 i = 0; i < lockedTillPercentages.length; i = i.add(1)) \n', '        {\n', '            _total_lockedTokens =0;\n', '            _total_lockedTokens = amount_lockedTokens.mul(lockedTillPercentages[i])* 10**uint256(decimals)/100;\n', '            //Locked  add % of Token amount locked\n', '            issueLockedTokensCustom( _total_lockedTokens, dateTokensLockedTills[i] );\n', '\n', '        }\n', '        //---------------------------------------------------\n', '\n', '\n', '        issueReservedTokens(reservedTokens);\n', '        \n', '        \n', '        /// increase token total supply\n', '        totalSupply = totalSupply.add(sumlockedAndReservedTokens);\n', '        \n', '        /// burn the unallocated tokens - no more tokens can be issued after this line\n', '        tokenSaleClosed = true;\n', '\n', '        /// forward the raised funds to the contract creator\n', '        owner.transfer(this.balance);\n', '    }\n', '\n', '    /**\n', '     * issue the tokens for the team and the foodout group.\n', '     * tokens are locked for 1 years.\n', '     * @param lockedTokens the amount of tokens to the issued and locked\n', '     * */\n', '    function issueLockedTokens( uint lockedTokens) internal{\n', '        /// team tokens are locked until this date (01.01.2019)\n', '        TokenTimelock lockedTeamTokens = new TokenTimelock(this, owner, dateTeamTokensLockedTill);\n', '        timelockContractAddress = address(lockedTeamTokens);\n', '        balances[timelockContractAddress] = balances[timelockContractAddress].add(lockedTokens);\n', '        /// fire event when tokens issued\n', '        Transfer(address(0), timelockContractAddress, lockedTokens);\n', '        \n', '    }\n', '\n', '    function issueLockedTokensCustom( uint lockedTokens , uint64 _dateTokensLockedTill) internal{\n', '        /// team tokens are locked until this date (01.01.2019)\n', '        TokenTimelock lockedTeamTokens = new TokenTimelock(this, owner, _dateTokensLockedTill);\n', '        timelockContractAddress = address(lockedTeamTokens);\n', '        balances[timelockContractAddress] = balances[timelockContractAddress].add(lockedTokens);\n', '        /// fire event when tokens issued\n', '        Transfer(address(0), timelockContractAddress, lockedTokens);\n', '        \n', '    }\n', '\n', '    /**\n', '     * issue the tokens for Reserved \n', '     * @param reservedTokens & bounty Tokens the amount of tokens to be issued\n', '     * */\n', '    function issueReservedTokens(uint reservedTokens) internal{\n', '        balances[owner] = reservedTokens;\n', '        Transfer(address(0), owner, reservedTokens);\n', '    }\n', '\n', '    // Transfer limited by the tradingOpen modifier (time is 14 July 2018 or later)\n', '    function transferFrom(address _from, address _to, uint256 _value) public tradingOpen returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    /// Transfer limited by the tradingOpen modifier (time is 14 July 2018 or later)\n', '    function transfer(address _to, uint256 _value) public tradingOpen returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '}']
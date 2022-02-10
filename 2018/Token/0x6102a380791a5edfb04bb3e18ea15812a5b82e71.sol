['pragma solidity ^ 0.4.19;\n', '\n', '/**\n', ' * @title GdprConfig\n', ' * @dev Configuration for GDPR Cash token and crowdsale\n', '*/\n', 'contract GdprConfig {\n', '\n', '    // Token settings\n', '    string public constant TOKEN_NAME = "GDPR Cash";\n', '    string public constant TOKEN_SYMBOL = "GDPR";\n', '    uint8 public constant TOKEN_DECIMALS = 18;\n', '\n', '    // Smallest value of the GDPR\n', '    uint256 public constant MIN_TOKEN_UNIT = 10 ** uint256(TOKEN_DECIMALS);\n', '    // Minimum cap per purchaser on public sale ~ $100 in GDPR Cash\n', '    uint256 public constant PURCHASER_MIN_TOKEN_CAP = 500 * MIN_TOKEN_UNIT;\n', '    // Maximum cap per purchaser on first day of public sale ~ $2,000 in GDPR Cash\n', '    uint256 public constant PURCHASER_MAX_TOKEN_CAP_DAY1 = 10000 * MIN_TOKEN_UNIT;\n', '    // Maximum cap per purchaser on public sale ~ $20,000 in GDPR\n', '    uint256 public constant PURCHASER_MAX_TOKEN_CAP = 100000 * MIN_TOKEN_UNIT;\n', '\n', '    // Crowdsale rate GDPR / ETH\n', '    uint256 public constant INITIAL_RATE = 7600; // 7600 GDPR for 1 ether\n', '\n', '    // Initial distribution amounts\n', '    uint256 public constant TOTAL_SUPPLY_CAP = 200000000 * MIN_TOKEN_UNIT;\n', '    // 60% of the total supply cap\n', '    uint256 public constant SALE_CAP = 120000000 * MIN_TOKEN_UNIT;\n', '    // 10% tokens for the experts\n', '    uint256 public constant EXPERTS_POOL_TOKENS = 20000000 * MIN_TOKEN_UNIT;\n', '    // 10% tokens for marketing expenses\n', '    uint256 public constant MARKETING_POOL_TOKENS = 20000000 * MIN_TOKEN_UNIT;\n', '    // 9% founders&#39; distribution\n', '    uint256 public constant TEAM_POOL_TOKENS = 18000000 * MIN_TOKEN_UNIT;\n', '    // 1% for legal advisors\n', '    uint256 public constant LEGAL_EXPENSES_TOKENS = 2000000 * MIN_TOKEN_UNIT;\n', '    // 10% tokens for the reserve\n', '    uint256 public constant RESERVE_POOL_TOKENS = 20000000 * MIN_TOKEN_UNIT;\n', '\n', '    // Contract wallet addresses for initial allocation\n', '    address public constant EXPERTS_POOL_ADDR = 0x289bB02deaF473c6Aa5edc4886A71D85c18F328B;\n', '    address public constant MARKETING_POOL_ADDR = 0x7BFD82C978EDDce94fe12eBF364c6943c7cC2f27;\n', '    address public constant TEAM_POOL_ADDR = 0xB4AfbF5F39895adf213194198c0ba316f801B24d;\n', '    address public constant LEGAL_EXPENSES_ADDR = 0xf72931B08f8Ef3d8811aD682cE24A514105f713c;\n', '    address public constant SALE_FUNDS_ADDR = 0xb8E81a87c6D96ed5f424F0A33F13b046C1f24a24;\n', '    address public constant RESERVE_POOL_ADDR = 0x010aAA10BfB913184C5b2E046143c2ec8A037413;\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns(uint256);\n', '    function balanceOf(address who) public view returns(uint256);\n', '    function transfer(address to, uint256 value) public returns(bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns(uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns(bool);\n', '    function approve(address spender, uint256 value) public returns(bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'contract DetailedERC20 is ERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '        mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns(uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns(uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns(bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to stop minting new tokens.\n', '     * @return True if the operation was successful.\n', '     */\n', '    function finishMinting() onlyOwner canMint public returns(bool) {\n', '        mintingFinished = true;\n', '        MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Capped token\n', ' * @dev Mintable token with a token cap.\n', ' */\n', 'contract CappedToken is MintableToken {\n', '\n', '    uint256 public cap;\n', '\n', '    function CappedToken(uint256 _cap) public {\n', '        require(_cap > 0);\n', '        cap = _cap;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to mint tokens\n', '     * @param _to The address that will receive the minted tokens.\n', '     * @param _amount The amount of tokens to mint.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {\n', '        require(totalSupply_.add(_amount) <= cap);\n', '\n', '        return super.mint(_to, _amount);\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title GdprCash\n', ' * @dev GDPR Cash - the token used in the gdpr.cash network.\n', ' *\n', ' * All tokens are preminted and distributed at deploy time.\n', ' * Transfers are disabled until the crowdsale is over. \n', ' * All unsold tokens are burned.\n', ' */\n', 'contract GdprCash is DetailedERC20, CappedToken, GdprConfig {\n', '\n', '    bool private transfersEnabled = false;\n', '    address public crowdsale = address(0);\n', '\n', '    /**\n', '     * @dev Triggered on token burn\n', '     */\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Transfers are restricted to the crowdsale and owner only\n', '     *      until the crowdsale is over.\n', '     */\n', '    modifier canTransfer() {\n', '        require(transfersEnabled || msg.sender == owner || msg.sender == crowdsale);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Restriected to the crowdsale only\n', '     */\n', '    modifier onlyCrowdsale() {\n', '        require(msg.sender == crowdsale);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Constructor that sets name, symbol, decimals as well as a maximum supply cap.\n', '     */\n', '    function GdprCash() public\n', '    DetailedERC20(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS)\n', '    CappedToken(TOTAL_SUPPLY_CAP) {\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the crowdsale. Can be invoked only once and by the owner\n', '     * @param _crowdsaleAddr address The address of the crowdsale contract\n', '     */\n', '    function setCrowdsale(address _crowdsaleAddr) external onlyOwner {\n', '        require(crowdsale == address(0));\n', '        require(_crowdsaleAddr != address(0));\n', '        require(!transfersEnabled);\n', '        crowdsale = _crowdsaleAddr;\n', '\n', '        // Generate sale tokens\n', '        mint(crowdsale, SALE_CAP);\n', '\n', '        // Distribute non-sale tokens to pools\n', '        mint(EXPERTS_POOL_ADDR, EXPERTS_POOL_TOKENS);\n', '        mint(MARKETING_POOL_ADDR, MARKETING_POOL_TOKENS);\n', '        mint(TEAM_POOL_ADDR, TEAM_POOL_TOKENS);\n', '        mint(LEGAL_EXPENSES_ADDR, LEGAL_EXPENSES_TOKENS);\n', '        mint(RESERVE_POOL_ADDR, RESERVE_POOL_TOKENS);\n', '\n', '        finishMinting();\n', '    }\n', '\n', '    /**\n', '     * @dev Checks modifier and transfers\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transfer(address _to, uint256 _value)\n', '        public canTransfer returns(bool)\n', '    {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Checks modifier and transfers\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public canTransfer returns(bool)\n', '    {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Enables token transfers.\n', '     * Called when the token sale is successfully finalized\n', '     */\n', '    function enableTransfers() public onlyCrowdsale {\n', '        transfersEnabled = true;\n', '    }\n', '\n', '    /**\n', '    * @dev Burns a specific number of tokens.\n', '    * @param _value uint256 The number of tokens to be burned.\n', '    */\n', '    function burn(uint256 _value) public onlyCrowdsale {\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title GDPR Crowdsale\n', ' * @dev GDPR Cash crowdsale contract. \n', ' */\n', 'contract GdprCrowdsale is Pausable {\n', '    using SafeMath for uint256;\n', '\n', '        // Token contract\n', '        GdprCash public token;\n', '\n', '    // Start and end timestamps where investments are allowed (both inclusive)\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    // Address where funds are collected\n', '    address public wallet;\n', '\n', '    // How many token units a buyer gets per wei\n', '    uint256 public rate;\n', '\n', '    // Amount of raised money in wei\n', '    uint256 public weiRaised = 0;\n', '\n', '    // Total amount of tokens purchased\n', '    uint256 public totalPurchased = 0;\n', '\n', '    // Purchases\n', '    mapping(address => uint256) public tokensPurchased;\n', '\n', '    // Whether the crowdsale is finalized\n', '    bool public isFinalized = false;\n', '\n', '    // Crowdsale events\n', '    /**\n', '     * Event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value weis paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(\n', '        address indexed purchaser,\n', '        address indexed beneficiary,\n', '        uint256 value,\n', '        uint256 amount);\n', '\n', '    /**\n', '    * Event for token purchase logging\n', '    * @param purchaser who paid for the tokens\n', '    * @param amount amount of tokens purchased\n', '    */\n', '    event TokenPresale(\n', '        address indexed purchaser,\n', '        uint256 amount);\n', '\n', '    /**\n', '     * Event invoked when the rate is changed\n', '     * @param newRate The new rate GDPR / ETH\n', '     */\n', '    event RateChange(uint256 newRate);\n', '\n', '    /**\n', '     * Triggered when ether is withdrawn to the sale wallet\n', '     * @param amount How many funds to withdraw in wei\n', '     */\n', '    event FundWithdrawal(uint256 amount);\n', '\n', '    /**\n', '     * Event for crowdsale finalization\n', '     */\n', '    event Finalized();\n', '\n', '    /**\n', '     * @dev GdprCrowdsale contract constructor\n', '     * @param _startTime uint256 Unix timestamp representing the crowdsale start time\n', '     * @param _endTime uint256 Unix timestamp representing the crowdsale end time\n', '     * @param _tokenAddress address Address of the GDPR Cash token contract\n', '     */\n', '    function GdprCrowdsale(\n', '        uint256 _startTime,\n', '        uint256 _endTime,\n', '        address _tokenAddress\n', '    ) public\n', '    {\n', '        require(_endTime > _startTime);\n', '        require(_tokenAddress != address(0));\n', '\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        token = GdprCash(_tokenAddress);\n', '        rate = token.INITIAL_RATE();\n', '        wallet = token.SALE_FUNDS_ADDR();\n', '    }\n', '\n', '    /**\n', '     * @dev Fallback function is used to buy tokens.\n', '     * It&#39;s the only entry point since `buyTokens` is internal.\n', '     * When paused funds are not accepted.\n', '     */\n', '    function () public whenNotPaused payable {\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets a new start date as long as token sale hasn&#39;t started yet\n', '     * @param _startTime uint256 Unix timestamp of the new start time\n', '     */\n', '    function setStartTime(uint256 _startTime) public onlyOwner {\n', '        require(now < startTime);\n', '        require(_startTime > now);\n', '        require(_startTime < endTime);\n', '\n', '        startTime = _startTime;\n', '    }\n', '\n', '    /**\n', '     * @dev Sets a new end date as long as end date hasn&#39;t been reached\n', '     * @param _endTime uint2t56 Unix timestamp of the new end time\n', '     */\n', '    function setEndTime(uint256 _endTime) public onlyOwner {\n', '        require(now < endTime);\n', '        require(_endTime > now);\n', '        require(_endTime > startTime);\n', '\n', '        endTime = _endTime;\n', '    }\n', '\n', '    /**\n', '     * @dev Updates the GDPR/ETH conversion rate\n', '     * @param _rate uint256 Updated conversion rate\n', '     */\n', '    function setRate(uint256 _rate) public onlyOwner {\n', '        require(_rate > 0);\n', '        rate = _rate;\n', '        RateChange(rate);\n', '    }\n', '\n', '    /**\n', '     * @dev Must be called after crowdsale ends, to do some extra finalization\n', '     * work. Calls the contract&#39;s finalization function.\n', '     */\n', '    function finalize() public onlyOwner {\n', '        require(now > endTime);\n', '        require(!isFinalized);\n', '\n', '        finalization();\n', '        Finalized();\n', '\n', '        isFinalized = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Anyone can check if the crowdsale is over\n', '     * @return true if crowdsale has endeds\n', '     */\n', '    function hasEnded() public view returns(bool) {\n', '        return now > endTime;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ether to the sale wallet\n', '     * @param _amount uint256 The amount to withdraw. \n', '     * If 0 supplied transfers the entire balance.\n', '     */\n', '    function withdraw(uint256 _amount) public onlyOwner {\n', '        require(this.balance > 0);\n', '        require(_amount <= this.balance);\n', '        uint256 balanceToSend = _amount;\n', '        if (balanceToSend == 0) {\n', '            balanceToSend = this.balance;\n', '        }\n', '        wallet.transfer(balanceToSend);\n', '        FundWithdrawal(balanceToSend);\n', '    }\n', '\n', '    /**\n', '     *  @dev Registers a presale order\n', '     *  @param _participant address The address of the token purchaser\n', '     *  @param _tokenAmount uin256 The amount of GDPR Cash (in wei) purchased\n', '     */\n', '    function addPresaleOrder(address _participant, uint256 _tokenAmount) external onlyOwner {\n', '        require(now < startTime);\n', '\n', '        // Update state\n', '        tokensPurchased[_participant] = tokensPurchased[_participant].add(_tokenAmount);\n', '        totalPurchased = totalPurchased.add(_tokenAmount);\n', '\n', '        token.transfer(_participant, _tokenAmount);\n', '\n', '        TokenPresale(\n', '            _participant,\n', '            _tokenAmount\n', '        );\n', '    }\n', '\n', '    /**\n', '     *  @dev Token purchase logic. Used internally.\n', '     *  @param _participant address The address of the token purchaser\n', '     *  @param _weiAmount uin256 The amount of ether in wei sent to the contract\n', '     */\n', '    function buyTokens(address _participant, uint256 _weiAmount) internal {\n', '        require(_participant != address(0));\n', '        require(now >= startTime);\n', '        require(now < endTime);\n', '        require(!isFinalized);\n', '        require(_weiAmount != 0);\n', '\n', '        // Calculate the token amount to be allocated\n', '        uint256 tokens = _weiAmount.mul(rate);\n', '\n', '        // Update state\n', '        tokensPurchased[_participant] = tokensPurchased[_participant].add(tokens);\n', '        totalPurchased = totalPurchased.add(tokens);\n', '        // update state\n', '        weiRaised = weiRaised.add(_weiAmount);\n', '\n', '        require(totalPurchased <= token.SALE_CAP());\n', '        require(tokensPurchased[_participant] >= token.PURCHASER_MIN_TOKEN_CAP());\n', '\n', '        if (now < startTime + 86400) {\n', '            // if still during the first day of token sale, apply different max cap\n', '            require(tokensPurchased[_participant] <= token.PURCHASER_MAX_TOKEN_CAP_DAY1());\n', '        } else {\n', '            require(tokensPurchased[_participant] <= token.PURCHASER_MAX_TOKEN_CAP());\n', '        }\n', '\n', '        token.transfer(_participant, tokens);\n', '\n', '        TokenPurchase(\n', '            msg.sender,\n', '            _participant,\n', '            _weiAmount,\n', '            tokens\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Additional finalization logic. \n', '     * Enables token transfers and burns all unsold tokens.\n', '     */\n', '    function finalization() internal {\n', '        withdraw(0);\n', '        burnUnsold();\n', '        token.enableTransfers();\n', '    }\n', '\n', '    /**\n', '     * @dev Burn all remaining (unsold) tokens.\n', '     * This should be called automatically after sale finalization\n', '     */\n', '    function burnUnsold() internal {\n', '        // All tokens held by this contract get burned\n', '        token.burn(token.balanceOf(this));\n', '    }\n', '}']
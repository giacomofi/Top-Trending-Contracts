['pragma solidity 0.4.25;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '        assert(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '        assert(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        assert(token.approve(spender, value));\n', '    }\n', '}\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract TokenTimelock {\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    // ERC20 basic token contract being held\n', '    ERC20Basic public token;\n', '\n', '    // beneficiary of tokens after they are released\n', '    address public beneficiary;\n', '\n', '    // timestamp when token release is enabled\n', '    uint64 public releaseTime;\n', '\n', '    constructor(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {\n', '        require(_releaseTime > uint64(block.timestamp));\n', '        token = _token;\n', '        beneficiary = _beneficiary;\n', '        releaseTime = _releaseTime;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to beneficiary.\n', '     */\n', '    function release() public {\n', '        require(uint64(block.timestamp) >= releaseTime);\n', '\n', '        uint256 amount = token.balanceOf(this);\n', '        require(amount > 0);\n', '\n', '        token.safeTransfer(beneficiary, amount);\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '}\n', '\n', 'contract BitwingsToken is BurnableToken, Owned {\n', '    string public constant name = "BITWINGS TOKEN";\n', '    string public constant symbol = "BWN";\n', '    uint8 public constant decimals = 18;\n', '\n', '    /// Maximum tokens to be allocated (300 million BWN)\n', '    uint256 public constant HARD_CAP = 300000000 * 10**uint256(decimals);\n', '\n', '    /// This address will hold the Bitwings team and advisors tokens\n', '    address public teamAdvisorsTokensAddress;\n', '\n', '    /// This address is used to keep the tokens for sale\n', '    address public saleTokensAddress;\n', '\n', '    /// This address is used to keep the reserve tokens\n', '    address public reserveTokensAddress;\n', '\n', '    /// This address is used to keep the tokens for Gold founder, bounty and airdrop\n', '    address public bountyAirdropTokensAddress;\n', '\n', '    /// This address is used to keep the tokens for referrals\n', '    address public referralTokensAddress;\n', '\n', '    /// when the token sale is closed, the unsold tokens are allocated to the reserve\n', '    bool public saleClosed = false;\n', '\n', '    /// Some addresses are whitelisted in order to be able to distribute advisors tokens before the trading is open\n', '    mapping(address => bool) public whitelisted;\n', '\n', '    /// Only allowed to execute before the token sale is closed\n', '    modifier beforeSaleClosed {\n', '        require(!saleClosed);\n', '        _;\n', '    }\n', '\n', '    constructor(address _teamAdvisorsTokensAddress, address _reserveTokensAddress,\n', '                address _saleTokensAddress, address _bountyAirdropTokensAddress, address _referralTokensAddress) public {\n', '        require(_teamAdvisorsTokensAddress != address(0));\n', '        require(_reserveTokensAddress != address(0));\n', '        require(_saleTokensAddress != address(0));\n', '        require(_bountyAirdropTokensAddress != address(0));\n', '        require(_referralTokensAddress != address(0));\n', '\n', '        teamAdvisorsTokensAddress = _teamAdvisorsTokensAddress;\n', '        reserveTokensAddress = _reserveTokensAddress;\n', '        saleTokensAddress = _saleTokensAddress;\n', '        bountyAirdropTokensAddress = _bountyAirdropTokensAddress;\n', '        referralTokensAddress = _referralTokensAddress;\n', '\n', '        /// Maximum tokens to be allocated on the sale\n', '        /// 189 million BWN\n', '        uint256 saleTokens = 189000000 * 10**uint256(decimals);\n', '        totalSupply_ = saleTokens;\n', '        balances[saleTokensAddress] = saleTokens;\n', '        emit Transfer(address(0), saleTokensAddress, balances[saleTokensAddress]);\n', '\n', '        /// Team and advisors tokens - 15 million BWN\n', '        uint256 teamAdvisorsTokens = 15000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(teamAdvisorsTokens);\n', '        balances[teamAdvisorsTokensAddress] = teamAdvisorsTokens;\n', '        emit Transfer(address(0), teamAdvisorsTokensAddress, balances[teamAdvisorsTokensAddress]);\n', '\n', '        /// Reserve tokens - 60 million BWN\n', '        uint256 reserveTokens = 60000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(reserveTokens);\n', '        balances[reserveTokensAddress] = reserveTokens;\n', '        emit Transfer(address(0), reserveTokensAddress, balances[reserveTokensAddress]);\n', '\n', '        /// Gold founder, bounty and airdrop tokens - 31 million BWN\n', '        uint256 bountyAirdropTokens = 31000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(bountyAirdropTokens);\n', '        balances[bountyAirdropTokensAddress] = bountyAirdropTokens;\n', '        emit Transfer(address(0), bountyAirdropTokensAddress, balances[bountyAirdropTokensAddress]);\n', '\n', '        /// Referral tokens - 5 million BWN\n', '        uint256 referralTokens = 5000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(referralTokens);\n', '        balances[referralTokensAddress] = referralTokens;\n', '        emit Transfer(address(0), referralTokensAddress, balances[referralTokensAddress]);\n', '\n', '        whitelisted[saleTokensAddress] = true;\n', '        whitelisted[teamAdvisorsTokensAddress] = true;\n', '        whitelisted[bountyAirdropTokensAddress] = true;\n', '        whitelisted[referralTokensAddress] = true;\n', '\n', '        require(totalSupply_ == HARD_CAP);\n', '    }\n', '\n', '    /// @dev reallocates the unsold tokens\n', '    function closeSale() external onlyOwner beforeSaleClosed {\n', '        /// The unsold and unallocated bounty tokens are allocated to the reserve\n', '\n', '        uint256 unsoldTokens = balances[saleTokensAddress];\n', '        balances[reserveTokensAddress] = balances[reserveTokensAddress].add(unsoldTokens);\n', '        balances[saleTokensAddress] = 0;\n', '        emit Transfer(saleTokensAddress, reserveTokensAddress, unsoldTokens);\n', '\n', '        saleClosed = true;\n', '    }\n', '\n', '    /// @dev whitelist an address so it&#39;s able to transfer\n', '    /// before the trading is opened\n', '    function whitelist(address _address) external onlyOwner {\n', '        whitelisted[_address] = true;\n', '    }\n', '\n', '    /// @dev Trading limited\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        if(saleClosed) {\n', '            return super.transferFrom(_from, _to, _value);\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /// @dev Trading limited\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        if(saleClosed || whitelisted[msg.sender]) {\n', '            return super.transfer(_to, _value);\n', '        }\n', '        return false;\n', '    }\n', '}']
['pragma solidity 0.4.25;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '        assert(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '        assert(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        assert(token.approve(spender, value));\n', '    }\n', '}\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract TokenTimelock {\n', '    using SafeERC20 for ERC20Basic;\n', '\n', '    // ERC20 basic token contract being held\n', '    ERC20Basic public token;\n', '\n', '    // beneficiary of tokens after they are released\n', '    address public beneficiary;\n', '\n', '    // timestamp when token release is enabled\n', '    uint64 public releaseTime;\n', '\n', '    constructor(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {\n', '        require(_releaseTime > uint64(block.timestamp));\n', '        token = _token;\n', '        beneficiary = _beneficiary;\n', '        releaseTime = _releaseTime;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to beneficiary.\n', '     */\n', '    function release() public {\n', '        require(uint64(block.timestamp) >= releaseTime);\n', '\n', '        uint256 amount = token.balanceOf(this);\n', '        require(amount > 0);\n', '\n', '        token.safeTransfer(beneficiary, amount);\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '}\n', '\n', 'contract BitwingsToken is BurnableToken, Owned {\n', '    string public constant name = "BITWINGS TOKEN";\n', '    string public constant symbol = "BWN";\n', '    uint8 public constant decimals = 18;\n', '\n', '    /// Maximum tokens to be allocated (300 million BWN)\n', '    uint256 public constant HARD_CAP = 300000000 * 10**uint256(decimals);\n', '\n', '    /// This address will hold the Bitwings team and advisors tokens\n', '    address public teamAdvisorsTokensAddress;\n', '\n', '    /// This address is used to keep the tokens for sale\n', '    address public saleTokensAddress;\n', '\n', '    /// This address is used to keep the reserve tokens\n', '    address public reserveTokensAddress;\n', '\n', '    /// This address is used to keep the tokens for Gold founder, bounty and airdrop\n', '    address public bountyAirdropTokensAddress;\n', '\n', '    /// This address is used to keep the tokens for referrals\n', '    address public referralTokensAddress;\n', '\n', '    /// when the token sale is closed, the unsold tokens are allocated to the reserve\n', '    bool public saleClosed = false;\n', '\n', '    /// Some addresses are whitelisted in order to be able to distribute advisors tokens before the trading is open\n', '    mapping(address => bool) public whitelisted;\n', '\n', '    /// Only allowed to execute before the token sale is closed\n', '    modifier beforeSaleClosed {\n', '        require(!saleClosed);\n', '        _;\n', '    }\n', '\n', '    constructor(address _teamAdvisorsTokensAddress, address _reserveTokensAddress,\n', '                address _saleTokensAddress, address _bountyAirdropTokensAddress, address _referralTokensAddress) public {\n', '        require(_teamAdvisorsTokensAddress != address(0));\n', '        require(_reserveTokensAddress != address(0));\n', '        require(_saleTokensAddress != address(0));\n', '        require(_bountyAirdropTokensAddress != address(0));\n', '        require(_referralTokensAddress != address(0));\n', '\n', '        teamAdvisorsTokensAddress = _teamAdvisorsTokensAddress;\n', '        reserveTokensAddress = _reserveTokensAddress;\n', '        saleTokensAddress = _saleTokensAddress;\n', '        bountyAirdropTokensAddress = _bountyAirdropTokensAddress;\n', '        referralTokensAddress = _referralTokensAddress;\n', '\n', '        /// Maximum tokens to be allocated on the sale\n', '        /// 189 million BWN\n', '        uint256 saleTokens = 189000000 * 10**uint256(decimals);\n', '        totalSupply_ = saleTokens;\n', '        balances[saleTokensAddress] = saleTokens;\n', '        emit Transfer(address(0), saleTokensAddress, balances[saleTokensAddress]);\n', '\n', '        /// Team and advisors tokens - 15 million BWN\n', '        uint256 teamAdvisorsTokens = 15000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(teamAdvisorsTokens);\n', '        balances[teamAdvisorsTokensAddress] = teamAdvisorsTokens;\n', '        emit Transfer(address(0), teamAdvisorsTokensAddress, balances[teamAdvisorsTokensAddress]);\n', '\n', '        /// Reserve tokens - 60 million BWN\n', '        uint256 reserveTokens = 60000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(reserveTokens);\n', '        balances[reserveTokensAddress] = reserveTokens;\n', '        emit Transfer(address(0), reserveTokensAddress, balances[reserveTokensAddress]);\n', '\n', '        /// Gold founder, bounty and airdrop tokens - 31 million BWN\n', '        uint256 bountyAirdropTokens = 31000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(bountyAirdropTokens);\n', '        balances[bountyAirdropTokensAddress] = bountyAirdropTokens;\n', '        emit Transfer(address(0), bountyAirdropTokensAddress, balances[bountyAirdropTokensAddress]);\n', '\n', '        /// Referral tokens - 5 million BWN\n', '        uint256 referralTokens = 5000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(referralTokens);\n', '        balances[referralTokensAddress] = referralTokens;\n', '        emit Transfer(address(0), referralTokensAddress, balances[referralTokensAddress]);\n', '\n', '        whitelisted[saleTokensAddress] = true;\n', '        whitelisted[teamAdvisorsTokensAddress] = true;\n', '        whitelisted[bountyAirdropTokensAddress] = true;\n', '        whitelisted[referralTokensAddress] = true;\n', '\n', '        require(totalSupply_ == HARD_CAP);\n', '    }\n', '\n', '    /// @dev reallocates the unsold tokens\n', '    function closeSale() external onlyOwner beforeSaleClosed {\n', '        /// The unsold and unallocated bounty tokens are allocated to the reserve\n', '\n', '        uint256 unsoldTokens = balances[saleTokensAddress];\n', '        balances[reserveTokensAddress] = balances[reserveTokensAddress].add(unsoldTokens);\n', '        balances[saleTokensAddress] = 0;\n', '        emit Transfer(saleTokensAddress, reserveTokensAddress, unsoldTokens);\n', '\n', '        saleClosed = true;\n', '    }\n', '\n', "    /// @dev whitelist an address so it's able to transfer\n", '    /// before the trading is opened\n', '    function whitelist(address _address) external onlyOwner {\n', '        whitelisted[_address] = true;\n', '    }\n', '\n', '    /// @dev Trading limited\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        if(saleClosed) {\n', '            return super.transferFrom(_from, _to, _value);\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /// @dev Trading limited\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        if(saleClosed || whitelisted[msg.sender]) {\n', '            return super.transfer(_to, _value);\n', '        }\n', '        return false;\n', '    }\n', '}']

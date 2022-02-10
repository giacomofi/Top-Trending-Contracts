['pragma solidity 0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Owned {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop minting new tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BidoohToken is MintableToken {\n', '    string public constant name = "Bidooh Token";\n', '    string public constant symbol = "DOOH";\n', '    uint8 public constant decimals = 18;\n', '\n', '    /// This address is be assigned the Bidooh Team tokens\n', '    address public teamTokensAddress;\n', '\n', '    /// This address is be assigned the Reserve tokens\n', '    address public reserveTokensAddress;\n', '\n', '    /// This address is be assigned the Sale tokens\n', '    address public saleTokensAddress;\n', '\n', '    /// This address will have the sole ability to mint more tokens\n', '    address public bidoohAdminAddress;\n', '\n', '    /// a safeguard flag to prevent multiple calls of close()\n', '    bool public saleClosed = false;\n', '\n', '    /// Only allowed to execute before the token sale is closed\n', '    modifier beforeSaleClosed {\n', '        require(!saleClosed);\n', '        _;\n', '    }\n', '\n', '    constructor(address _teamTokensAddress, address _reserveTokensAddress,\n', '                address _saleTokensAddress, address _bidoohAdminAddress) public {\n', '        require(_teamTokensAddress != address(0));\n', '        require(_reserveTokensAddress != address(0));\n', '        require(_saleTokensAddress != address(0));\n', '        require(_bidoohAdminAddress != address(0));\n', '\n', '        teamTokensAddress = _teamTokensAddress;\n', '        reserveTokensAddress = _reserveTokensAddress;\n', '        saleTokensAddress = _saleTokensAddress;\n', '        bidoohAdminAddress = _bidoohAdminAddress;\n', '\n', '        /// Maximum tokens to be allocated on the sale\n', '        /// 88.2 billion DOOH\n', '        uint256 saleTokens = 88200000000 * 10**uint256(decimals);\n', '        totalSupply_ = saleTokens;\n', '        balances[saleTokensAddress] = saleTokens;\n', '\n', '        /// Reserve tokens - 18.9 billion DOOH\n', '        uint256 reserveTokens = 18900000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(reserveTokens);\n', '        balances[reserveTokensAddress] = reserveTokens;\n', '\n', '        /// Team tokens - 18.9 billion DOOH\n', '        uint256 teamTokens = 18900000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(teamTokens);\n', '        balances[teamTokensAddress] = teamTokens;\n', '    }\n', '\n', '    /// @dev Close the token sale and transfer ownership\n', '    function close() public onlyOwner beforeSaleClosed {\n', '        uint256 unsoldTokens = balances[saleTokensAddress];\n', '        balances[reserveTokensAddress] = balances[reserveTokensAddress].add(unsoldTokens);\n', '        balances[saleTokensAddress] = 0;\n', '        emit Transfer(saleTokensAddress, reserveTokensAddress, unsoldTokens);\n', '\n', '        owner = bidoohAdminAddress;\n', '        saleClosed = true;\n', '    }\n', '}']
['pragma solidity 0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', 'contract MintableToken is StandardToken, Owned {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop minting new tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BidoohToken is MintableToken {\n', '    string public constant name = "Bidooh Token";\n', '    string public constant symbol = "DOOH";\n', '    uint8 public constant decimals = 18;\n', '\n', '    /// This address is be assigned the Bidooh Team tokens\n', '    address public teamTokensAddress;\n', '\n', '    /// This address is be assigned the Reserve tokens\n', '    address public reserveTokensAddress;\n', '\n', '    /// This address is be assigned the Sale tokens\n', '    address public saleTokensAddress;\n', '\n', '    /// This address will have the sole ability to mint more tokens\n', '    address public bidoohAdminAddress;\n', '\n', '    /// a safeguard flag to prevent multiple calls of close()\n', '    bool public saleClosed = false;\n', '\n', '    /// Only allowed to execute before the token sale is closed\n', '    modifier beforeSaleClosed {\n', '        require(!saleClosed);\n', '        _;\n', '    }\n', '\n', '    constructor(address _teamTokensAddress, address _reserveTokensAddress,\n', '                address _saleTokensAddress, address _bidoohAdminAddress) public {\n', '        require(_teamTokensAddress != address(0));\n', '        require(_reserveTokensAddress != address(0));\n', '        require(_saleTokensAddress != address(0));\n', '        require(_bidoohAdminAddress != address(0));\n', '\n', '        teamTokensAddress = _teamTokensAddress;\n', '        reserveTokensAddress = _reserveTokensAddress;\n', '        saleTokensAddress = _saleTokensAddress;\n', '        bidoohAdminAddress = _bidoohAdminAddress;\n', '\n', '        /// Maximum tokens to be allocated on the sale\n', '        /// 88.2 billion DOOH\n', '        uint256 saleTokens = 88200000000 * 10**uint256(decimals);\n', '        totalSupply_ = saleTokens;\n', '        balances[saleTokensAddress] = saleTokens;\n', '\n', '        /// Reserve tokens - 18.9 billion DOOH\n', '        uint256 reserveTokens = 18900000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(reserveTokens);\n', '        balances[reserveTokensAddress] = reserveTokens;\n', '\n', '        /// Team tokens - 18.9 billion DOOH\n', '        uint256 teamTokens = 18900000000 * 10**uint256(decimals);\n', '        totalSupply_ = totalSupply_.add(teamTokens);\n', '        balances[teamTokensAddress] = teamTokens;\n', '    }\n', '\n', '    /// @dev Close the token sale and transfer ownership\n', '    function close() public onlyOwner beforeSaleClosed {\n', '        uint256 unsoldTokens = balances[saleTokensAddress];\n', '        balances[reserveTokensAddress] = balances[reserveTokensAddress].add(unsoldTokens);\n', '        balances[saleTokensAddress] = 0;\n', '        emit Transfer(saleTokensAddress, reserveTokensAddress, unsoldTokens);\n', '\n', '        owner = bidoohAdminAddress;\n', '        saleClosed = true;\n', '    }\n', '}']

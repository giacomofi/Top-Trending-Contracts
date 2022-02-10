['pragma solidity 0.4.21;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    /// Total amount of tokens\n', '  uint256 public totalSupply;\n', '  \n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  \n', '  function transfer(address _to, uint256 _amount) public returns (bool success);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);\n', '  \n', '  function approve(address _spender, uint256 _amount) public returns (bool success);\n', '  \n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  //balance in each address account\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _amount The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[msg.sender] >= _amount && _amount > 0\n', '        && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '  \n', '  \n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _amount uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[_from] >= _amount);\n', '    require(allowed[_from][msg.sender] >= _amount);\n', '    require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    balances[_from] = balances[_from].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '    emit Transfer(_from, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _amount The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    emit Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken, Ownable {\n', '\n', '    //this will contain a list of addresses allowed to burn their tokens\n', '    mapping(address=>bool)allowedBurners;\n', '    \n', '    event Burn(address indexed burner, uint256 value);\n', '    \n', '    event BurnerAdded(address indexed burner);\n', '    \n', '    event BurnerRemoved(address indexed burner);\n', '    \n', '    //check whether the burner is eligible burner\n', '    modifier isBurner(address _burner){\n', '        require(allowedBurners[_burner]);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '    *@dev Method to add eligible addresses in the list of burners. Since we need to burn all tokens left with the sales contract after the sale has ended. The sales contract should\n', '    * be an eligible burner. The owner has to add the sales address in the eligible burner list.\n', '    * @param _burner Address of the eligible burner\n', '    */\n', '    function addEligibleBurner(address _burner)public onlyOwner {\n', '        \n', '        require(_burner != address(0));\n', '        allowedBurners[_burner] = true;\n', '        emit BurnerAdded(_burner);\n', '    }\n', '    \n', '     /**\n', '    *@dev Method to remove addresses from the list of burners\n', '    * @param _burner Address of the eligible burner to be removed\n', '    */\n', '    function removeEligibleBurner(address _burner)public onlyOwner isBurner(_burner) {\n', '        \n', '        allowedBurners[_burner] = false;\n', '        emit BurnerRemoved(_burner);\n', '    }\n', '    \n', '    /**\n', '     * @dev Burns all tokens of the eligible burner\n', '     */\n', '    function burnAllTokens() public isBurner(msg.sender) {\n', '        \n', '        require(balances[msg.sender]>0);\n', '        \n', '        uint256 value = balances[msg.sender];\n', '        \n', '        totalSupply = totalSupply.sub(value);\n', '\n', '        balances[msg.sender] = 0;\n', '        \n', '        emit Burn(msg.sender, value);\n', '    }\n', '}\n', '/**\n', ' * @title DRONE Token\n', ' * @dev Token representing DRONE.\n', ' */\n', ' contract DroneToken is BurnableToken {\n', '     string public name ;\n', '     string public symbol ;\n', '     uint8 public decimals = 0 ;\n', '     \n', '     /**\n', '     *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller\n', '     */\n', '     function ()public payable {\n', '         revert();\n', '     }\n', '     \n', '     /**\n', '     * @dev Constructor function to initialize the initial supply of token to the creator of the contract\n', '     * @param initialSupply The initial supply of tokens which will be fixed through out\n', '     * @param tokenName The name of the token\n', '     * @param tokenSymbol The symboll of the token\n', '     */\n', '     function DroneToken(\n', '            uint256 initialSupply,\n', '            string tokenName,\n', '            string tokenSymbol\n', '         ) public {\n', '         totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount\n', '         name = tokenName;\n', '         symbol = tokenSymbol;\n', '         balances[msg.sender] = totalSupply;\n', '         \n', '         //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator\n', '         emit Transfer(address(0), msg.sender, totalSupply);\n', '     }\n', '     \n', '     /**\n', '     *@dev helper method to get token details, name, symbol and totalSupply in one go\n', '     */\n', '    function getTokenDetail() public view returns (string, string, uint256) {\n', '\t    return (name, symbol, totalSupply);\n', '    }\n', ' }']
['pragma solidity 0.4.21;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    /// Total amount of tokens\n', '  uint256 public totalSupply;\n', '  \n', '  function balanceOf(address _owner) public view returns (uint256 balance);\n', '  \n', '  function transfer(address _to, uint256 _amount) public returns (bool success);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '  \n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);\n', '  \n', '  function approve(address _spender, uint256 _amount) public returns (bool success);\n', '  \n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  //balance in each address account\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _amount The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[msg.sender] >= _amount && _amount > 0\n', '        && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '  \n', '  \n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _amount uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '    require(_to != address(0));\n', '    require(balances[_from] >= _amount);\n', '    require(allowed[_from][msg.sender] >= _amount);\n', '    require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);\n', '\n', '    balances[_from] = balances[_from].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '    emit Transfer(_from, _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _amount The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = _amount;\n', '    emit Approval(msg.sender, _spender, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken, Ownable {\n', '\n', '    //this will contain a list of addresses allowed to burn their tokens\n', '    mapping(address=>bool)allowedBurners;\n', '    \n', '    event Burn(address indexed burner, uint256 value);\n', '    \n', '    event BurnerAdded(address indexed burner);\n', '    \n', '    event BurnerRemoved(address indexed burner);\n', '    \n', '    //check whether the burner is eligible burner\n', '    modifier isBurner(address _burner){\n', '        require(allowedBurners[_burner]);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '    *@dev Method to add eligible addresses in the list of burners. Since we need to burn all tokens left with the sales contract after the sale has ended. The sales contract should\n', '    * be an eligible burner. The owner has to add the sales address in the eligible burner list.\n', '    * @param _burner Address of the eligible burner\n', '    */\n', '    function addEligibleBurner(address _burner)public onlyOwner {\n', '        \n', '        require(_burner != address(0));\n', '        allowedBurners[_burner] = true;\n', '        emit BurnerAdded(_burner);\n', '    }\n', '    \n', '     /**\n', '    *@dev Method to remove addresses from the list of burners\n', '    * @param _burner Address of the eligible burner to be removed\n', '    */\n', '    function removeEligibleBurner(address _burner)public onlyOwner isBurner(_burner) {\n', '        \n', '        allowedBurners[_burner] = false;\n', '        emit BurnerRemoved(_burner);\n', '    }\n', '    \n', '    /**\n', '     * @dev Burns all tokens of the eligible burner\n', '     */\n', '    function burnAllTokens() public isBurner(msg.sender) {\n', '        \n', '        require(balances[msg.sender]>0);\n', '        \n', '        uint256 value = balances[msg.sender];\n', '        \n', '        totalSupply = totalSupply.sub(value);\n', '\n', '        balances[msg.sender] = 0;\n', '        \n', '        emit Burn(msg.sender, value);\n', '    }\n', '}\n', '/**\n', ' * @title DRONE Token\n', ' * @dev Token representing DRONE.\n', ' */\n', ' contract DroneToken is BurnableToken {\n', '     string public name ;\n', '     string public symbol ;\n', '     uint8 public decimals = 0 ;\n', '     \n', '     /**\n', '     *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller\n', '     */\n', '     function ()public payable {\n', '         revert();\n', '     }\n', '     \n', '     /**\n', '     * @dev Constructor function to initialize the initial supply of token to the creator of the contract\n', '     * @param initialSupply The initial supply of tokens which will be fixed through out\n', '     * @param tokenName The name of the token\n', '     * @param tokenSymbol The symboll of the token\n', '     */\n', '     function DroneToken(\n', '            uint256 initialSupply,\n', '            string tokenName,\n', '            string tokenSymbol\n', '         ) public {\n', '         totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount\n', '         name = tokenName;\n', '         symbol = tokenSymbol;\n', '         balances[msg.sender] = totalSupply;\n', '         \n', '         //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator\n', '         emit Transfer(address(0), msg.sender, totalSupply);\n', '     }\n', '     \n', '     /**\n', '     *@dev helper method to get token details, name, symbol and totalSupply in one go\n', '     */\n', '    function getTokenDetail() public view returns (string, string, uint256) {\n', '\t    return (name, symbol, totalSupply);\n', '    }\n', ' }']

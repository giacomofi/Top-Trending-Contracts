['pragma solidity ^0.4.21;\n', '\n', '//SAFEMATHLIBRARY\n', '//mmp\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', ' \n', 'contract RECFToken is owned {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    // Public variables of the token\n', '    string public constant name = "RealEstateCryptoFund";\n', '    string public constant symbol = "RECF";\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balanceOf\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    \n', '    \n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '    }\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function RECFToken(\n', '        uint256 initialSupply\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        \n', '    }\n', '\n', '       /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', 'function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balanceOf[msg.sender]);\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '    balanceOf[_to] = balanceOf[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', 'function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balanceOf[_from]);\n', '    require(_value <= allowance[_from][msg.sender]);\n', '\n', '    balanceOf[_from] = balanceOf[_from].sub(_value);\n', '    balanceOf[_to] = balanceOf[_to].add(_value);\n', '    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '    }\n', '\n', '\n', '/* Internal transfer, only can be called by this contract */\n', 'function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != address(0));                                // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);                      // Check if the sender has enough\n', '        require (balanceOf[_to].add(_value) >= balanceOf[_to]);    // Check for overflows\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);             // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);               // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '* @dev Function to mint tokens\n', '* @param _to The address that will receive the minted tokens.\n', '* @param _amount The amount of tokens to mint.\n', '* @return A boolean that indicates if the operation was successful.\n', '*/\n', 'function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balanceOf[_to] = balanceOf[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop minting new tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', 'function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '    }  \n', '\n', '    \n', '   /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', 'function burn(uint256 _value) onlyOwner public {\n', '    require(_value <= balanceOf[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', '    // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '    address burner = msg.sender;\n', '    balanceOf[burner] = balanceOf[burner].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    emit Burn(burner, _value);\n', '    emit Transfer(burner, address(0), _value);\n', '  }\n', '\n', '\n', '/**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '      \n', '     */\n', 'function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                                                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);                                    // Check allowance\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                                   // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender&#39;s allowance\n', '        totalSupply = totalSupply.sub(_value);                                                // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '        }\n', '\n', '\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '//SAFEMATHLIBRARY\n', '//mmp\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', ' \n', 'contract RECFToken is owned {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    // Public variables of the token\n', '    string public constant name = "RealEstateCryptoFund";\n', '    string public constant symbol = "RECF";\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balanceOf\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    \n', '    \n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '    }\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function RECFToken(\n', '        uint256 initialSupply\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        \n', '    }\n', '\n', '       /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', 'function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balanceOf[msg.sender]);\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '    balanceOf[_to] = balanceOf[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', 'function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balanceOf[_from]);\n', '    require(_value <= allowance[_from][msg.sender]);\n', '\n', '    balanceOf[_from] = balanceOf[_from].sub(_value);\n', '    balanceOf[_to] = balanceOf[_to].add(_value);\n', '    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '    }\n', '\n', '\n', '/* Internal transfer, only can be called by this contract */\n', 'function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != address(0));                                // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);                      // Check if the sender has enough\n', '        require (balanceOf[_to].add(_value) >= balanceOf[_to]);    // Check for overflows\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);             // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);               // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '* @dev Function to mint tokens\n', '* @param _to The address that will receive the minted tokens.\n', '* @param _amount The amount of tokens to mint.\n', '* @return A boolean that indicates if the operation was successful.\n', '*/\n', 'function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balanceOf[_to] = balanceOf[_to].add(_amount);\n', '    emit Mint(_to, _amount);\n', '    emit Transfer(address(0), _to, _amount);\n', '    return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop minting new tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', 'function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    emit MintFinished();\n', '    return true;\n', '    }  \n', '\n', '    \n', '   /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param _value The amount of token to be burned.\n', '   */\n', 'function burn(uint256 _value) onlyOwner public {\n', '    require(_value <= balanceOf[msg.sender]);\n', '    // no need to require value <= totalSupply, since that would imply the\n', "    // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '    address burner = msg.sender;\n', '    balanceOf[burner] = balanceOf[burner].sub(_value);\n', '    totalSupply = totalSupply.sub(_value);\n', '    emit Burn(burner, _value);\n', '    emit Transfer(burner, address(0), _value);\n', '  }\n', '\n', '\n', '/**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '      \n', '     */\n', 'function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                                                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);                                    // Check allowance\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                                   // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance\n", '        totalSupply = totalSupply.sub(_value);                                                // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '        }\n', '\n', '\n', '\n', '}']

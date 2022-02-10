['pragma solidity 0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '\n', 'library SafeMath \n', '{\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns(uint256 c) \n', '  {\n', '     if (a == 0) \n', '     {\n', '     \treturn 0;\n', '     }\n', '     c = a * b;\n', '     assert(c / a == b);\n', '     return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns(uint256) \n', '  {\n', '     return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns(uint256) \n', '  {\n', '     assert(b <= a);\n', '     return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns(uint256 c) \n', '  {\n', '     c = a + b;\n', '     assert(c >= a);\n', '     return c;\n', '  }\n', '}\n', '\n', 'contract ERC20\n', '{\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address _who) public view returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' */\n', '\n', 'contract OppOpenWiFi is ERC20\n', '{\n', '    using SafeMath for uint256;\n', '   \n', '    uint256 constant public TOKEN_DECIMALS = 10 ** 18;\n', '    string public constant name            = "OppOpenWiFi Token";\n', '    string public constant symbol          = "OPP";\n', '    uint256 public totalTokenSupply        = 4165000000 * TOKEN_DECIMALS;  \n', '    address public owner;\n', '    uint8 public constant decimals = 18;\n', '\n', '    /** mappings **/ \n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => uint256) balances;\n', ' \n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '\n', '    modifier onlyOwner() \n', '    {\n', '       require(msg.sender == owner);\n', '       _;\n', '    }\n', '    \n', '    /** constructor **/\n', '\n', '    constructor() public\n', '    {\n', '       owner = msg.sender;\n', '       balances[address(this)] = totalTokenSupply;\n', '       emit Transfer(address(0x0), address(this), balances[address(this)]);\n', '    }\n', '    \n', '    /**\n', '     * @dev total number of tokens in existence\n', '    */\n', '\n', '    function totalSupply() public view returns(uint256 _totalSupply) \n', '    {\n', '       _totalSupply = totalTokenSupply;\n', '       return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param _owner The address to query the the balance of. \n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) \n', '    {\n', '       return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     \n', '    {\n', '       if (_value == 0) \n', '       {\n', '           emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0\n', '           return;\n', '       }\n', '\n', '       require(_to != address(0x0));\n', '       require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);\n', '\n', '       balances[_from] = balances[_from].sub(_value);\n', '       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '       balances[_to] = balances[_to].add(_value);\n', '       emit Transfer(_from, _to, _value);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '    * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _tokens The amount of tokens to be spent.\n', '    */\n', '\n', '    function approve(address _spender, uint256 _tokens)public returns(bool)\n', '    {\n', '       require(_spender != address(0x0));\n', '\n', '       allowed[msg.sender][_spender] = _tokens;\n', '       emit Approval(msg.sender, _spender, _tokens);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '     */\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256)\n', '    {\n', '       require(_owner != address(0x0) && _spender != address(0x0));\n', '\n', '       return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _address The address to transfer to.\n', '    * @param _tokens The amount to be transferred.\n', '    */\n', '\n', '    function transfer(address _address, uint256 _tokens)public returns(bool)\n', '    {\n', '       if (_tokens == 0) \n', '       {\n', '           emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0\n', '           return;\n', '       }\n', '\n', '       require(_address != address(0x0));\n', '       require(balances[msg.sender] >= _tokens);\n', '\n', '       balances[msg.sender] = (balances[msg.sender]).sub(_tokens);\n', '       balances[_address] = (balances[_address]).add(_tokens);\n', '       emit Transfer(msg.sender, _address, _tokens);\n', '       return true;\n', '    }\n', '    \n', '    /**\n', '    * @dev transfer token from smart contract to another account, only by owner\n', '    * @param _address The address to transfer to.\n', '    * @param _tokens The amount to be transferred.\n', '    */\n', '\n', '    function transferTo(address _address, uint256 _tokens) external onlyOwner returns(bool) \n', '    {\n', '       require( _address != address(0x0)); \n', '       require( balances[address(this)] >= _tokens.mul(TOKEN_DECIMALS) && _tokens.mul(TOKEN_DECIMALS) > 0);\n', '\n', '       balances[address(this)] = ( balances[address(this)]).sub(_tokens.mul(TOKEN_DECIMALS));\n', '       balances[_address] = (balances[_address]).add(_tokens.mul(TOKEN_DECIMALS));\n', '       emit Transfer(address(this), _address, _tokens.mul(TOKEN_DECIMALS));\n', '       return true;\n', '    }\n', '\t\n', '    /**\n', '    * @dev transfer ownership of this contract, only by owner\n', '    * @param _newOwner The address of the new owner to transfer ownership\n', '    */\n', '\n', '    function transferOwnership(address _newOwner)public onlyOwner\n', '    {\n', '       require( _newOwner != address(0x0));\n', '\n', '       balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);\n', '       balances[owner] = 0;\n', '       owner = _newOwner;\n', '       emit Transfer(msg.sender, _newOwner, balances[_newOwner]);\n', '   }\n', '\n', '   /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender\n', '   */\n', '\n', '   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) \n', '   {\n', '      allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '   }\n', '\n', '   /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender\n', '   */\n', '   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) \n', '   {\n', '      uint256 oldValue = allowed[msg.sender][_spender];\n', '\n', '      if (_subtractedValue > oldValue) \n', '      {\n', '         allowed[msg.sender][_spender] = 0;\n', '      }\n', '      else \n', '      {\n', '         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '      }\n', '      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '   }\n', '\n', '}']
['pragma solidity 0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '\n', 'library SafeMath \n', '{\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns(uint256 c) \n', '  {\n', '     if (a == 0) \n', '     {\n', '     \treturn 0;\n', '     }\n', '     c = a * b;\n', '     assert(c / a == b);\n', '     return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns(uint256) \n', '  {\n', '     return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns(uint256) \n', '  {\n', '     assert(b <= a);\n', '     return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns(uint256 c) \n', '  {\n', '     c = a + b;\n', '     assert(c >= a);\n', '     return c;\n', '  }\n', '}\n', '\n', 'contract ERC20\n', '{\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address _who) public view returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' */\n', '\n', 'contract OppOpenWiFi is ERC20\n', '{\n', '    using SafeMath for uint256;\n', '   \n', '    uint256 constant public TOKEN_DECIMALS = 10 ** 18;\n', '    string public constant name            = "OppOpenWiFi Token";\n', '    string public constant symbol          = "OPP";\n', '    uint256 public totalTokenSupply        = 4165000000 * TOKEN_DECIMALS;  \n', '    address public owner;\n', '    uint8 public constant decimals = 18;\n', '\n', '    /** mappings **/ \n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => uint256) balances;\n', ' \n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '\n', '    modifier onlyOwner() \n', '    {\n', '       require(msg.sender == owner);\n', '       _;\n', '    }\n', '    \n', '    /** constructor **/\n', '\n', '    constructor() public\n', '    {\n', '       owner = msg.sender;\n', '       balances[address(this)] = totalTokenSupply;\n', '       emit Transfer(address(0x0), address(this), balances[address(this)]);\n', '    }\n', '    \n', '    /**\n', '     * @dev total number of tokens in existence\n', '    */\n', '\n', '    function totalSupply() public view returns(uint256 _totalSupply) \n', '    {\n', '       _totalSupply = totalTokenSupply;\n', '       return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param _owner The address to query the the balance of. \n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) \n', '    {\n', '       return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     \n', '    {\n', '       if (_value == 0) \n', '       {\n', '           emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0\n', '           return;\n', '       }\n', '\n', '       require(_to != address(0x0));\n', '       require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);\n', '\n', '       balances[_from] = balances[_from].sub(_value);\n', '       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '       balances[_to] = balances[_to].add(_value);\n', '       emit Transfer(_from, _to, _value);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _tokens The amount of tokens to be spent.\n', '    */\n', '\n', '    function approve(address _spender, uint256 _tokens)public returns(bool)\n', '    {\n', '       require(_spender != address(0x0));\n', '\n', '       allowed[msg.sender][_spender] = _tokens;\n', '       emit Approval(msg.sender, _spender, _tokens);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '     */\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256)\n', '    {\n', '       require(_owner != address(0x0) && _spender != address(0x0));\n', '\n', '       return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _address The address to transfer to.\n', '    * @param _tokens The amount to be transferred.\n', '    */\n', '\n', '    function transfer(address _address, uint256 _tokens)public returns(bool)\n', '    {\n', '       if (_tokens == 0) \n', '       {\n', '           emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0\n', '           return;\n', '       }\n', '\n', '       require(_address != address(0x0));\n', '       require(balances[msg.sender] >= _tokens);\n', '\n', '       balances[msg.sender] = (balances[msg.sender]).sub(_tokens);\n', '       balances[_address] = (balances[_address]).add(_tokens);\n', '       emit Transfer(msg.sender, _address, _tokens);\n', '       return true;\n', '    }\n', '    \n', '    /**\n', '    * @dev transfer token from smart contract to another account, only by owner\n', '    * @param _address The address to transfer to.\n', '    * @param _tokens The amount to be transferred.\n', '    */\n', '\n', '    function transferTo(address _address, uint256 _tokens) external onlyOwner returns(bool) \n', '    {\n', '       require( _address != address(0x0)); \n', '       require( balances[address(this)] >= _tokens.mul(TOKEN_DECIMALS) && _tokens.mul(TOKEN_DECIMALS) > 0);\n', '\n', '       balances[address(this)] = ( balances[address(this)]).sub(_tokens.mul(TOKEN_DECIMALS));\n', '       balances[_address] = (balances[_address]).add(_tokens.mul(TOKEN_DECIMALS));\n', '       emit Transfer(address(this), _address, _tokens.mul(TOKEN_DECIMALS));\n', '       return true;\n', '    }\n', '\t\n', '    /**\n', '    * @dev transfer ownership of this contract, only by owner\n', '    * @param _newOwner The address of the new owner to transfer ownership\n', '    */\n', '\n', '    function transferOwnership(address _newOwner)public onlyOwner\n', '    {\n', '       require( _newOwner != address(0x0));\n', '\n', '       balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);\n', '       balances[owner] = 0;\n', '       owner = _newOwner;\n', '       emit Transfer(msg.sender, _newOwner, balances[_newOwner]);\n', '   }\n', '\n', '   /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender\n', '   */\n', '\n', '   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) \n', '   {\n', '      allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '   }\n', '\n', '   /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender\n', '   */\n', '   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) \n', '   {\n', '      uint256 oldValue = allowed[msg.sender][_spender];\n', '\n', '      if (_subtractedValue > oldValue) \n', '      {\n', '         allowed[msg.sender][_spender] = 0;\n', '      }\n', '      else \n', '      {\n', '         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '      }\n', '      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '   }\n', '\n', '}']

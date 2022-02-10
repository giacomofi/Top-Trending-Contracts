['pragma solidity 0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '\n', 'library SafeMath \n', '{\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns(uint256 c) \n', '  {\n', '     if (a == 0) \n', '     {\n', '     \treturn 0;\n', '     }\n', '     c = a * b;\n', '     assert(c / a == b);\n', '     return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns(uint256) \n', '  {\n', '     return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns(uint256) \n', '  {\n', '     assert(b <= a);\n', '     return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns(uint256 c) \n', '  {\n', '     c = a + b;\n', '     assert(c >= a);\n', '     return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Interface\n', '{\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address _who) public view returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}\n', '\n', 'interface tokenRecipient \n', '{ \n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; \n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' */\n', '\n', 'contract JIB is ERC20Interface\n', '{\n', '    using SafeMath for uint256;\n', '   \n', '    uint256 constant public TOKEN_DECIMALS = 10 ** 18;\n', '    string public constant name            = "Jibbit Token";\n', '    string public constant symbol          = "JIB";\n', '    uint256 public totalTokenSupply        = 700000000 * TOKEN_DECIMALS;\n', '    uint8 public constant decimals         = 18;\n', '    address public owner;\n', '    uint256 public totalBurned;\n', '    bool stopped    = false;\n', '    bool saleClosed = false;\n', '\n', '    event Burn(address indexed _burner, uint256 _value);\n', '    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);\n', '    event OwnershipRenounced(address indexed _previousOwner);\n', '\n', '    /** mappings **/ \n', '    mapping(address => uint256) public  balances;\n', '    mapping(address => mapping(address => uint256)) internal  allowed;\n', '    mapping(address => bool) public allowedAddresses;\n', ' \n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '\n', '    modifier onlyOwner() \n', '    {\n', '       require(msg.sender == owner);\n', '       _;\n', '    }\n', '    \n', '    /** constructor **/\n', '\n', '    constructor() public\n', '    {\n', '       owner = msg.sender;\n', '       balances[owner] = totalTokenSupply;\n', '       allowedAddresses[owner] = true;\n', '\n', '       emit Transfer(address(0x0), owner, balances[owner]);\n', '    }\n', '\n', '    /**\n', '     * @dev This function has to be triggered once after ICO sale is completed\n', '     */\n', '\n', '    function saleCompleted() external onlyOwner\n', '    {\n', '        saleClosed = true;\n', '    }\n', '\n', '    /**\n', '     * @dev To pause token transfer. In general pauseTransfer can be triggered\n', '     *      only on some specific error conditions \n', '     */\n', '\n', '    function pauseTransfer() external onlyOwner\n', '    {\n', '        stopped = true;\n', '    }\n', '\n', '    /**\n', '     * @dev To resume token transfer\n', '     */\n', '\n', '    function resumeTransfer() external onlyOwner\n', '    {\n', '        stopped = false;\n', '    }\n', '\n', '    /**\n', '     * @dev To add address into whitelist\n', '     */\n', '\n', '    function addToWhitelist(address _newAddr) public onlyOwner\n', '    {\n', '       allowedAddresses[_newAddr] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev To remove address from whitelist\n', '     */\n', '\n', '    function removeFromWhitelist(address _newAddr) public onlyOwner\n', '    {\n', '       allowedAddresses[_newAddr] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev To check whether address is whitelist or not\n', '     */\n', '\n', '    function isWhitelisted(address _addr) public view returns (bool) \n', '    {\n', '       return allowedAddresses[_addr];\n', '    }\n', '\n', '    /**\n', '     * @dev Burn specified number of GSCP tokens\n', '     * This function will be called once after all remaining tokens are transferred from\n', '     * smartcontract to owner wallet\n', '     */\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool) \n', '    {\n', '       require(!stopped);\n', '       require(_value <= balances[msg.sender]);\n', '\n', '       address burner = msg.sender;\n', '\n', '       balances[burner] = balances[burner].sub(_value);\n', '       totalTokenSupply = totalTokenSupply.sub(_value);\n', '       totalBurned      = totalBurned.add(_value);\n', '\n', '       emit Burn(burner, _value);\n', '       emit Transfer(burner, address(0x0), _value);\n', '       return true;\n', '    }     \n', '\n', '    /**\n', '     * @dev total number of tokens in existence\n', '     * @return An uint256 representing the total number of tokens in existence\n', '     */\n', '\n', '    function totalSupply() public view returns(uint256 _totalSupply) \n', '    {\n', '       _totalSupply = totalTokenSupply;\n', '       return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address\n', '     * @param _owner The address to query the the balance of \n', '     * @return An uint256 representing the amount owned by the passed address\n', '     */\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) \n', '    {\n', '       return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     \n', '    {\n', '       require(!stopped);\n', '\n', '       if(!saleClosed && !isWhitelisted(msg.sender))\n', '          return false;\n', '\n', '       if (_value == 0) \n', '       {\n', '           emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0\n', '           return true;\n', '       }\n', '\n', '       require(_to != address(0x0));\n', '       require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);\n', '\n', '       balances[_from] = balances[_from].sub(_value);\n', '       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '       balances[_to] = balances[_to].add(_value);\n', '\n', '       emit Transfer(_from, _to, _value);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds\n', '     * @param _tokens The amount of tokens to be spent\n', '     */\n', '\n', '    function approve(address _spender, uint256 _tokens) public returns(bool)\n', '    {\n', '       require(!stopped);\n', '       require(_spender != address(0x0));\n', '\n', '       allowed[msg.sender][_spender] = _tokens;\n', '\n', '       emit Approval(msg.sender, _spender, _tokens);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender\n', '     * @param _owner address The address which owns the funds\n', '     * @param _spender address The address which will spend the funds\n', '     * @return A uint256 specifing the amount of tokens still avaible for the spender\n', '     */\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256)\n', '    {\n', '       require(!stopped);\n', '       require(_owner != address(0x0) && _spender != address(0x0));\n', '\n', '       return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev transfer token for a specified address\n', '     * @param _address The address to transfer to\n', '     * @param _tokens The amount to be transferred\n', '     */\n', '\n', '    function transfer(address _address, uint256 _tokens) public returns(bool)\n', '    {\n', '       require(!stopped);\n', '\n', '       if(!saleClosed && !isWhitelisted(msg.sender))\n', '          return false;\n', '\n', '       if (_tokens == 0) \n', '       {\n', '           emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0\n', '           return true;\n', '       }\n', '\n', '       require(_address != address(0x0));\n', '       require(balances[msg.sender] >= _tokens);\n', '\n', '       balances[msg.sender] = (balances[msg.sender]).sub(_tokens);\n', '       balances[_address] = (balances[_address]).add(_tokens);\n', '\n', '       emit Transfer(msg.sender, _address, _tokens);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '     * @dev transfer ownership of this contract, only by owner\n', '     * @param _newOwner The address of the new owner to transfer ownership\n', '     */\n', '\n', '    function transferOwnership(address _newOwner)public onlyOwner\n', '    {\n', '       require(!stopped);\n', '       require( _newOwner != address(0x0));\n', '\n', '       balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);\n', '       balances[owner] = 0;\n', '       owner = _newOwner;\n', '\n', '       emit Transfer(msg.sender, _newOwner, balances[_newOwner]);\n', '   }\n', '\n', '   /**\n', '    * @dev Allows the current owner to relinquish control of the contract\n', '    * @notice Renouncing to ownership will leave the contract without an owner\n', '    * It will not be possible to call the functions with the `onlyOwner`\n', '    * modifier anymore\n', '    */\n', '\n', '   function renounceOwnership() public onlyOwner \n', '   {\n', '      require(!stopped);\n', '\n', '      owner = address(0x0);\n', '      emit OwnershipRenounced(owner);\n', '   }\n', '\n', '   /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender\n', '    */\n', '\n', '   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) \n', '   {\n', '      require(!stopped);\n', '\n', '      allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '   }\n', '\n', '   /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender\n', '    */\n', '\n', '   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) \n', '   {\n', '      uint256 oldValue = allowed[msg.sender][_spender];\n', '\n', '      require(!stopped);\n', '\n', '      if (_subtractedValue > oldValue) \n', '      {\n', '         allowed[msg.sender][_spender] = 0;\n', '      }\n', '      else \n', '      {\n', '         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '      }\n', '      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '   }\n', '\n', '   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) \n', '   {\n', '      require(!stopped);\n', '\n', '      tokenRecipient spender = tokenRecipient(_spender);\n', '\n', '      if (approve(_spender, _value)) \n', '      {\n', '          spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '          return true;\n', '      }\n', '   }\n', '\n', '   /**\n', '    * @dev To transfer back any accidental ERC20 tokens sent to this contract by owner\n', '    */\n', '\n', '   function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) \n', '   {\n', '      require(!stopped);\n', '\n', '      return ERC20Interface(_tokenAddress).transfer(owner, _tokens);\n', '   }\n', '\n', '   /* This unnamed function is called whenever someone tries to send ether to it */\n', '\n', '   function () public payable \n', '   {\n', '      revert();\n', '   }\n', '}']
['pragma solidity 0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', '\n', 'library SafeMath \n', '{\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns(uint256 c) \n', '  {\n', '     if (a == 0) \n', '     {\n', '     \treturn 0;\n', '     }\n', '     c = a * b;\n', '     assert(c / a == b);\n', '     return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns(uint256) \n', '  {\n', '     return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns(uint256) \n', '  {\n', '     assert(b <= a);\n', '     return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns(uint256 c) \n', '  {\n', '     c = a + b;\n', '     assert(c >= a);\n', '     return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Interface\n', '{\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address _who) public view returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '}\n', '\n', 'interface tokenRecipient \n', '{ \n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; \n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' */\n', '\n', 'contract JIB is ERC20Interface\n', '{\n', '    using SafeMath for uint256;\n', '   \n', '    uint256 constant public TOKEN_DECIMALS = 10 ** 18;\n', '    string public constant name            = "Jibbit Token";\n', '    string public constant symbol          = "JIB";\n', '    uint256 public totalTokenSupply        = 700000000 * TOKEN_DECIMALS;\n', '    uint8 public constant decimals         = 18;\n', '    address public owner;\n', '    uint256 public totalBurned;\n', '    bool stopped    = false;\n', '    bool saleClosed = false;\n', '\n', '    event Burn(address indexed _burner, uint256 _value);\n', '    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);\n', '    event OwnershipRenounced(address indexed _previousOwner);\n', '\n', '    /** mappings **/ \n', '    mapping(address => uint256) public  balances;\n', '    mapping(address => mapping(address => uint256)) internal  allowed;\n', '    mapping(address => bool) public allowedAddresses;\n', ' \n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '\n', '    modifier onlyOwner() \n', '    {\n', '       require(msg.sender == owner);\n', '       _;\n', '    }\n', '    \n', '    /** constructor **/\n', '\n', '    constructor() public\n', '    {\n', '       owner = msg.sender;\n', '       balances[owner] = totalTokenSupply;\n', '       allowedAddresses[owner] = true;\n', '\n', '       emit Transfer(address(0x0), owner, balances[owner]);\n', '    }\n', '\n', '    /**\n', '     * @dev This function has to be triggered once after ICO sale is completed\n', '     */\n', '\n', '    function saleCompleted() external onlyOwner\n', '    {\n', '        saleClosed = true;\n', '    }\n', '\n', '    /**\n', '     * @dev To pause token transfer. In general pauseTransfer can be triggered\n', '     *      only on some specific error conditions \n', '     */\n', '\n', '    function pauseTransfer() external onlyOwner\n', '    {\n', '        stopped = true;\n', '    }\n', '\n', '    /**\n', '     * @dev To resume token transfer\n', '     */\n', '\n', '    function resumeTransfer() external onlyOwner\n', '    {\n', '        stopped = false;\n', '    }\n', '\n', '    /**\n', '     * @dev To add address into whitelist\n', '     */\n', '\n', '    function addToWhitelist(address _newAddr) public onlyOwner\n', '    {\n', '       allowedAddresses[_newAddr] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev To remove address from whitelist\n', '     */\n', '\n', '    function removeFromWhitelist(address _newAddr) public onlyOwner\n', '    {\n', '       allowedAddresses[_newAddr] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev To check whether address is whitelist or not\n', '     */\n', '\n', '    function isWhitelisted(address _addr) public view returns (bool) \n', '    {\n', '       return allowedAddresses[_addr];\n', '    }\n', '\n', '    /**\n', '     * @dev Burn specified number of GSCP tokens\n', '     * This function will be called once after all remaining tokens are transferred from\n', '     * smartcontract to owner wallet\n', '     */\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool) \n', '    {\n', '       require(!stopped);\n', '       require(_value <= balances[msg.sender]);\n', '\n', '       address burner = msg.sender;\n', '\n', '       balances[burner] = balances[burner].sub(_value);\n', '       totalTokenSupply = totalTokenSupply.sub(_value);\n', '       totalBurned      = totalBurned.add(_value);\n', '\n', '       emit Burn(burner, _value);\n', '       emit Transfer(burner, address(0x0), _value);\n', '       return true;\n', '    }     \n', '\n', '    /**\n', '     * @dev total number of tokens in existence\n', '     * @return An uint256 representing the total number of tokens in existence\n', '     */\n', '\n', '    function totalSupply() public view returns(uint256 _totalSupply) \n', '    {\n', '       _totalSupply = totalTokenSupply;\n', '       return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address\n', '     * @param _owner The address to query the the balance of \n', '     * @return An uint256 representing the amount owned by the passed address\n', '     */\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) \n', '    {\n', '       return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amout of tokens to be transfered\n', '     */\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     \n', '    {\n', '       require(!stopped);\n', '\n', '       if(!saleClosed && !isWhitelisted(msg.sender))\n', '          return false;\n', '\n', '       if (_value == 0) \n', '       {\n', '           emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0\n', '           return true;\n', '       }\n', '\n', '       require(_to != address(0x0));\n', '       require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);\n', '\n', '       balances[_from] = balances[_from].sub(_value);\n', '       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '       balances[_to] = balances[_to].add(_value);\n', '\n', '       emit Transfer(_from, _to, _value);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds\n', '     * @param _tokens The amount of tokens to be spent\n', '     */\n', '\n', '    function approve(address _spender, uint256 _tokens) public returns(bool)\n', '    {\n', '       require(!stopped);\n', '       require(_spender != address(0x0));\n', '\n', '       allowed[msg.sender][_spender] = _tokens;\n', '\n', '       emit Approval(msg.sender, _spender, _tokens);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender\n', '     * @param _owner address The address which owns the funds\n', '     * @param _spender address The address which will spend the funds\n', '     * @return A uint256 specifing the amount of tokens still avaible for the spender\n', '     */\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256)\n', '    {\n', '       require(!stopped);\n', '       require(_owner != address(0x0) && _spender != address(0x0));\n', '\n', '       return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev transfer token for a specified address\n', '     * @param _address The address to transfer to\n', '     * @param _tokens The amount to be transferred\n', '     */\n', '\n', '    function transfer(address _address, uint256 _tokens) public returns(bool)\n', '    {\n', '       require(!stopped);\n', '\n', '       if(!saleClosed && !isWhitelisted(msg.sender))\n', '          return false;\n', '\n', '       if (_tokens == 0) \n', '       {\n', '           emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0\n', '           return true;\n', '       }\n', '\n', '       require(_address != address(0x0));\n', '       require(balances[msg.sender] >= _tokens);\n', '\n', '       balances[msg.sender] = (balances[msg.sender]).sub(_tokens);\n', '       balances[_address] = (balances[_address]).add(_tokens);\n', '\n', '       emit Transfer(msg.sender, _address, _tokens);\n', '       return true;\n', '    }\n', '\n', '    /**\n', '     * @dev transfer ownership of this contract, only by owner\n', '     * @param _newOwner The address of the new owner to transfer ownership\n', '     */\n', '\n', '    function transferOwnership(address _newOwner)public onlyOwner\n', '    {\n', '       require(!stopped);\n', '       require( _newOwner != address(0x0));\n', '\n', '       balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);\n', '       balances[owner] = 0;\n', '       owner = _newOwner;\n', '\n', '       emit Transfer(msg.sender, _newOwner, balances[_newOwner]);\n', '   }\n', '\n', '   /**\n', '    * @dev Allows the current owner to relinquish control of the contract\n', '    * @notice Renouncing to ownership will leave the contract without an owner\n', '    * It will not be possible to call the functions with the `onlyOwner`\n', '    * modifier anymore\n', '    */\n', '\n', '   function renounceOwnership() public onlyOwner \n', '   {\n', '      require(!stopped);\n', '\n', '      owner = address(0x0);\n', '      emit OwnershipRenounced(owner);\n', '   }\n', '\n', '   /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender\n', '    */\n', '\n', '   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) \n', '   {\n', '      require(!stopped);\n', '\n', '      allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '   }\n', '\n', '   /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender\n', '    */\n', '\n', '   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) \n', '   {\n', '      uint256 oldValue = allowed[msg.sender][_spender];\n', '\n', '      require(!stopped);\n', '\n', '      if (_subtractedValue > oldValue) \n', '      {\n', '         allowed[msg.sender][_spender] = 0;\n', '      }\n', '      else \n', '      {\n', '         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '      }\n', '      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '   }\n', '\n', '   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) \n', '   {\n', '      require(!stopped);\n', '\n', '      tokenRecipient spender = tokenRecipient(_spender);\n', '\n', '      if (approve(_spender, _value)) \n', '      {\n', '          spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '          return true;\n', '      }\n', '   }\n', '\n', '   /**\n', '    * @dev To transfer back any accidental ERC20 tokens sent to this contract by owner\n', '    */\n', '\n', '   function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) \n', '   {\n', '      require(!stopped);\n', '\n', '      return ERC20Interface(_tokenAddress).transfer(owner, _tokens);\n', '   }\n', '\n', '   /* This unnamed function is called whenever someone tries to send ether to it */\n', '\n', '   function () public payable \n', '   {\n', '      revert();\n', '   }\n', '}']
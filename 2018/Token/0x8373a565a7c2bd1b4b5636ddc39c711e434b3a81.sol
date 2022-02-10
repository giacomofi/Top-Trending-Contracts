['/**\n', '  * SafeMath Libary\n', '  */\n', 'pragma solidity ^0.4.24;\n', 'contract SafeMath {\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    function safeSub(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function safeMul(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        if (a == 0) {\n', '        return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function safeDiv(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract EIP20Interface {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns(bool success);\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    // solhint-disable-next-line no-simple-event-func-name\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender,uint256 _value);\n', '}\n', '\n', '\n', 'contract HTCCToken is EIP20Interface,Ownable,SafeMath,Pausable{\n', '    //// Constant token specific fields\n', '    string public constant name ="HTCCToken";\n', '    string public constant symbol = "HTCC";\n', '    uint8 public constant decimals = 18;\n', '    string  public version  = &#39;v0.1&#39;;\n', '    uint256 public constant initialSupply = 101010101;\n', '    \n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowances;\n', '\n', '    //set raise time\n', '    uint256 public finaliseTime;\n', '\n', '    //to receive eth from the contract\n', '    address public walletOwnerAddress;\n', '\n', '    //Tokens to 1 eth\n', '    uint256 public rate;\n', '\n', '    event WithDraw(address indexed _from, address indexed _to,uint256 _value);\n', '    \n', '\n', '    function HTCCToken() public {\n', '        totalSupply = initialSupply*10**uint256(decimals);                        //  total supply\n', '        balances[msg.sender] = totalSupply;             // Give the creator all initial tokens\n', '        walletOwnerAddress = msg.sender;\n', '        rate = 1000;\n', '    }\n', '\n', '    modifier notFinalised() {\n', '        require(finaliseTime == 0);\n', '        _;\n', '    }\n', '    function balanceOf(address _account) public view returns (uint) {\n', '        return balances[_account];\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal returns(bool) {\n', '        require(_to != address(0x0)&&_value>0);\n', '        require(balances[_from] >= _value);\n', '        require(safeAdd(balances[_to],_value) > balances[_to]);\n', '\n', '        uint previousBalances = safeAdd(balances[_from],balances[_to]);\n', '        balances[_from] = safeSub(balances[_from],_value);\n', '        balances[_to] = safeAdd(balances[_to],_value);\n', '        emit Transfer(_from, _to, _value);\n', '        assert(safeAdd(balances[_from],balances[_to]) == previousBalances);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success){\n', '        return _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(_value <= allowances[_from][msg.sender]);\n', '        allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender],_value);\n', '        return _transfer(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowances[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowances[msg.sender][_spender] = safeAdd(allowances[msg.sender][_spender],_addedValue);\n', '        emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '        return true;\n', '  }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '            uint oldValue = allowances[msg.sender][_spender];\n', '            if (_subtractedValue > oldValue) {\n', '              allowances[msg.sender][_spender] = 0;\n', '            } else {\n', '              allowances[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);\n', '            }\n', '            emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '            return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowances[_owner][_spender];\n', '    }\n', ' \n', '    //close the raise\n', '    function setFinaliseTime() onlyOwner notFinalised public returns(bool){\n', '        finaliseTime = now;\n', '        rate = 0;\n', '        return true;\n', '    }\n', '     //close the raise\n', '    function Restart(uint256 newrate) onlyOwner public returns(bool){\n', '        finaliseTime = 0;\n', '         rate = newrate;\n', '        return true;\n', '    }\n', '\n', '    function setRate(uint256 newrate) onlyOwner notFinalised public returns(bool) {\n', '       rate = newrate;\n', '       return true;\n', '    }\n', '\n', '    function setWalletOwnerAddress(address _newaddress) onlyOwner public returns(bool) {\n', '       walletOwnerAddress = _newaddress;\n', '       return true;\n', '    }\n', '    //Withdraw eth form the contranct \n', '    function withdraw(address _to) internal returns(bool){\n', '        require(_to.send(this.balance));\n', '        emit WithDraw(msg.sender,_to,this.balance);\n', '        return true;\n', '    }\n', '    \n', '    function _buyToken(address _to,uint256 _value)internal notFinalised whenNotPaused{\n', '        require(_to != address(0x0));\n', '        balances[_to] = safeAdd(balances[_to],_value);\n', '        balances[owner] = safeSub(balances[owner],_value);\n', '        withdraw(walletOwnerAddress);\n', '    }\n', '\n', '    function() public payable{\n', '        require(msg.value >= 0.01 ether);\n', '        uint256 tokens = safeMul(msg.value,rate);\n', '        _buyToken(msg.sender,tokens);\n', '    }\n', '}']
['/**\n', '  * SafeMath Libary\n', '  */\n', 'pragma solidity ^0.4.24;\n', 'contract SafeMath {\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '    function safeSub(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function safeMul(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        if (a == 0) {\n', '        return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function safeDiv(uint256 a, uint256 b) internal pure returns(uint256)\n', '    {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract EIP20Interface {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns(bool success);\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    // solhint-disable-next-line no-simple-event-func-name\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender,uint256 _value);\n', '}\n', '\n', '\n', 'contract HTCCToken is EIP20Interface,Ownable,SafeMath,Pausable{\n', '    //// Constant token specific fields\n', '    string public constant name ="HTCCToken";\n', '    string public constant symbol = "HTCC";\n', '    uint8 public constant decimals = 18;\n', "    string  public version  = 'v0.1';\n", '    uint256 public constant initialSupply = 101010101;\n', '    \n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowances;\n', '\n', '    //set raise time\n', '    uint256 public finaliseTime;\n', '\n', '    //to receive eth from the contract\n', '    address public walletOwnerAddress;\n', '\n', '    //Tokens to 1 eth\n', '    uint256 public rate;\n', '\n', '    event WithDraw(address indexed _from, address indexed _to,uint256 _value);\n', '    \n', '\n', '    function HTCCToken() public {\n', '        totalSupply = initialSupply*10**uint256(decimals);                        //  total supply\n', '        balances[msg.sender] = totalSupply;             // Give the creator all initial tokens\n', '        walletOwnerAddress = msg.sender;\n', '        rate = 1000;\n', '    }\n', '\n', '    modifier notFinalised() {\n', '        require(finaliseTime == 0);\n', '        _;\n', '    }\n', '    function balanceOf(address _account) public view returns (uint) {\n', '        return balances[_account];\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal returns(bool) {\n', '        require(_to != address(0x0)&&_value>0);\n', '        require(balances[_from] >= _value);\n', '        require(safeAdd(balances[_to],_value) > balances[_to]);\n', '\n', '        uint previousBalances = safeAdd(balances[_from],balances[_to]);\n', '        balances[_from] = safeSub(balances[_from],_value);\n', '        balances[_to] = safeAdd(balances[_to],_value);\n', '        emit Transfer(_from, _to, _value);\n', '        assert(safeAdd(balances[_from],balances[_to]) == previousBalances);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success){\n', '        return _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(_value <= allowances[_from][msg.sender]);\n', '        allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender],_value);\n', '        return _transfer(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowances[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowances[msg.sender][_spender] = safeAdd(allowances[msg.sender][_spender],_addedValue);\n', '        emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '        return true;\n', '  }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '            uint oldValue = allowances[msg.sender][_spender];\n', '            if (_subtractedValue > oldValue) {\n', '              allowances[msg.sender][_spender] = 0;\n', '            } else {\n', '              allowances[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);\n', '            }\n', '            emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);\n', '            return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowances[_owner][_spender];\n', '    }\n', ' \n', '    //close the raise\n', '    function setFinaliseTime() onlyOwner notFinalised public returns(bool){\n', '        finaliseTime = now;\n', '        rate = 0;\n', '        return true;\n', '    }\n', '     //close the raise\n', '    function Restart(uint256 newrate) onlyOwner public returns(bool){\n', '        finaliseTime = 0;\n', '         rate = newrate;\n', '        return true;\n', '    }\n', '\n', '    function setRate(uint256 newrate) onlyOwner notFinalised public returns(bool) {\n', '       rate = newrate;\n', '       return true;\n', '    }\n', '\n', '    function setWalletOwnerAddress(address _newaddress) onlyOwner public returns(bool) {\n', '       walletOwnerAddress = _newaddress;\n', '       return true;\n', '    }\n', '    //Withdraw eth form the contranct \n', '    function withdraw(address _to) internal returns(bool){\n', '        require(_to.send(this.balance));\n', '        emit WithDraw(msg.sender,_to,this.balance);\n', '        return true;\n', '    }\n', '    \n', '    function _buyToken(address _to,uint256 _value)internal notFinalised whenNotPaused{\n', '        require(_to != address(0x0));\n', '        balances[_to] = safeAdd(balances[_to],_value);\n', '        balances[owner] = safeSub(balances[owner],_value);\n', '        withdraw(walletOwnerAddress);\n', '    }\n', '\n', '    function() public payable{\n', '        require(msg.value >= 0.01 ether);\n', '        uint256 tokens = safeMul(msg.value,rate);\n', '        _buyToken(msg.sender,tokens);\n', '    }\n', '}']

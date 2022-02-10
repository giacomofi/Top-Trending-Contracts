['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner = address(0x0);\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0x0));\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0x0);\n', '    }\n', '}\n', '\n', '\n', 'contract Pausable is Owned {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', 'interface tokenRecipient { \n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; \n', '    \n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '    function approve(address spender, uint256 tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', 'contract TokenBase is ERC20Interface, Pausable, SafeMath {\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public decimals;\n', '    uint256 internal _totalSupply;\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint256 _value) internal whenNotPaused returns (bool success) {\n', '        require(_to != 0x0);                // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(balances[_from] >= _value);            // Check if the sender has enough\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        require( SafeMath.safeAdd(balances[_to], _value) > balances[_to]);          // Check for overflows\n', '        uint256 previousBalances =  SafeMath.safeAdd(balances[_from], balances[_to]);\n', '        balances[_from] = SafeMath.safeSub(balances[_from], _value);      // Subtract from the sender\n', '        balances[_to] = SafeMath.safeAdd(balances[_to], _value);          // Add the same to the recipient\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowed[_from][msg.sender]);     // Check allowance\n', '        allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function approve(address spender, uint256 tokens) public whenNotPaused returns (bool success) {\n', '        require(tokens >= 0);\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public whenNotPaused returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     */\n', '    \n', '    function burn(uint256 _value) public onlyOwner whenNotPaused returns (bool success) {\n', '\t\trequire(balances[msg.sender] >= _value);\n', '\t\trequire(_value > 0);\n', '        balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);            // Subtract from the sender\n', '        _totalSupply = SafeMath.safeSub(_totalSupply, _value);                                // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from another account\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public onlyOwner whenNotPaused returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '        balances[_from] = SafeMath.safeSub(balances[_from], _value);    // Subtract from the targetd balance\n', '        allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);  // Subtract from the sender&#39;s allowance\n', '        _totalSupply = SafeMath.safeSub(_totalSupply,_value);  \n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract FDataToken is TokenBase{\n', '\n', '    string internal _tokenName = &#39;FData&#39;;\n', '    string internal _tokenSymbol = &#39;FDT&#39;;\n', '    uint256 internal _tokenDecimals = 18;\n', '    uint256 internal _initialSupply = 10000000000;\n', '    \n', '\t/* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function FDataToken() public {\n', '        _totalSupply = _initialSupply * 10 ** uint256(_tokenDecimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = _totalSupply;                // Give the creator all initial tokens\n', '        name = _tokenName;                                     // Set the name for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = _tokenDecimals;\n', '        owner = msg.sender;\n', '    }\n', '\n', '\t// can accept ether\n', '\tfunction() payable public {\n', '    }\n', '\n', '    function freezeAccount(address target, bool value) onlyOwner public {\n', '        frozenAccount[target] = value;\n', '        emit FrozenFunds(target, value);\n', '    }\n', '    \n', '\t// transfer contract balance to owner\n', '\tfunction retrieveEther(uint256 amount) onlyOwner public {\n', '\t    require(amount > 0);\n', '\t    require(amount <= address(this).balance);\n', '\t\tmsg.sender.transfer(amount);\n', '\t}\n', '\n', '\t// transfer contract token balance to owner\n', '\tfunction retrieveToken(uint256 amount) onlyOwner public {\n', '        _transfer(this, msg.sender, amount);\n', '\t}\n', '\t\n', '\t// transfer contract token balance to owner\n', '\tfunction retrieveTokenByContract(address token, uint256 amount) onlyOwner public {\n', '        ERC20Interface(token).transfer(msg.sender, amount);\n', '\t}\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner = address(0x0);\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0x0));\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0x0);\n', '    }\n', '}\n', '\n', '\n', 'contract Pausable is Owned {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', 'interface tokenRecipient { \n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; \n', '    \n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '    function approve(address spender, uint256 tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', 'contract TokenBase is ERC20Interface, Pausable, SafeMath {\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public decimals;\n', '    uint256 internal _totalSupply;\n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint256 balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint256 _value) internal whenNotPaused returns (bool success) {\n', '        require(_to != 0x0);                // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(balances[_from] >= _value);            // Check if the sender has enough\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        require( SafeMath.safeAdd(balances[_to], _value) > balances[_to]);          // Check for overflows\n', '        uint256 previousBalances =  SafeMath.safeAdd(balances[_from], balances[_to]);\n', '        balances[_from] = SafeMath.safeSub(balances[_from], _value);      // Subtract from the sender\n', '        balances[_to] = SafeMath.safeAdd(balances[_to], _value);          // Add the same to the recipient\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowed[_from][msg.sender]);     // Check allowance\n', '        allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function approve(address spender, uint256 tokens) public whenNotPaused returns (bool success) {\n', '        require(tokens >= 0);\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public whenNotPaused returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     */\n', '    \n', '    function burn(uint256 _value) public onlyOwner whenNotPaused returns (bool success) {\n', '\t\trequire(balances[msg.sender] >= _value);\n', '\t\trequire(_value > 0);\n', '        balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);            // Subtract from the sender\n', '        _totalSupply = SafeMath.safeSub(_totalSupply, _value);                                // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from another account\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public onlyOwner whenNotPaused returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '        balances[_from] = SafeMath.safeSub(balances[_from], _value);    // Subtract from the targetd balance\n', "        allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);  // Subtract from the sender's allowance\n", '        _totalSupply = SafeMath.safeSub(_totalSupply,_value);  \n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract FDataToken is TokenBase{\n', '\n', "    string internal _tokenName = 'FData';\n", "    string internal _tokenSymbol = 'FDT';\n", '    uint256 internal _tokenDecimals = 18;\n', '    uint256 internal _initialSupply = 10000000000;\n', '    \n', '\t/* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function FDataToken() public {\n', '        _totalSupply = _initialSupply * 10 ** uint256(_tokenDecimals);  // Update total supply with the decimal amount\n', '        balances[msg.sender] = _totalSupply;                // Give the creator all initial tokens\n', '        name = _tokenName;                                     // Set the name for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = _tokenDecimals;\n', '        owner = msg.sender;\n', '    }\n', '\n', '\t// can accept ether\n', '\tfunction() payable public {\n', '    }\n', '\n', '    function freezeAccount(address target, bool value) onlyOwner public {\n', '        frozenAccount[target] = value;\n', '        emit FrozenFunds(target, value);\n', '    }\n', '    \n', '\t// transfer contract balance to owner\n', '\tfunction retrieveEther(uint256 amount) onlyOwner public {\n', '\t    require(amount > 0);\n', '\t    require(amount <= address(this).balance);\n', '\t\tmsg.sender.transfer(amount);\n', '\t}\n', '\n', '\t// transfer contract token balance to owner\n', '\tfunction retrieveToken(uint256 amount) onlyOwner public {\n', '        _transfer(this, msg.sender, amount);\n', '\t}\n', '\t\n', '\t// transfer contract token balance to owner\n', '\tfunction retrieveTokenByContract(address token, uint256 amount) onlyOwner public {\n', '        ERC20Interface(token).transfer(msg.sender, amount);\n', '\t}\n', '\n', '}']
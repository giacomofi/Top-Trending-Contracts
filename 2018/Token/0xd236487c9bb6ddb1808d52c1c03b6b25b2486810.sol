['pragma solidity ^0.4.20;\n', 'library SafeMath {\n', '    function safeadd(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safesub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '   \n', '}\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 {\n', '   \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '   \n', '    uint256 public totalSupply;\n', '\n', '  \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', ' \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '   \n', '    event Burn(address indexed from, uint256 value);\n', '\n', '   \n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] = SafeMath.safesub(balanceOf[_from],_value);\n', '        // Add the same to the recipient\n', '        balanceOf[_to] = SafeMath.safeadd(balanceOf[_to],_value);\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '   \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '   \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', 'contract LP is owned, TokenERC20 {\n', '\n', '   \n', '    mapping (address => bool) public frozenAccount;\n', '\n', '   \n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '   \n', '    function LP(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}\n', '\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\t\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        balanceOf[_from] = SafeMath.safesub(balanceOf[_from],_value);                    // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeadd(balanceOf[_to],_value);                         // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '   \n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    \n', '   \n', '}']
['pragma solidity ^0.4.20;\n', 'library SafeMath {\n', '    function safeadd(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safesub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '   \n', '}\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract TokenERC20 {\n', '   \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '   \n', '    uint256 public totalSupply;\n', '\n', '  \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', ' \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '   \n', '    event Burn(address indexed from, uint256 value);\n', '\n', '   \n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] = SafeMath.safesub(balanceOf[_from],_value);\n', '        // Add the same to the recipient\n', '        balanceOf[_to] = SafeMath.safeadd(balanceOf[_to],_value);\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '   \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '   \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', 'contract LP is owned, TokenERC20 {\n', '\n', '   \n', '    mapping (address => bool) public frozenAccount;\n', '\n', '   \n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '   \n', '    function LP(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}\n', '\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\t\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        balanceOf[_from] = SafeMath.safesub(balanceOf[_from],_value);                    // Subtract from the sender\n', '        balanceOf[_to] = SafeMath.safeadd(balanceOf[_to],_value);                         // Add the same to the recipient\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '   \n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '\n', '    \n', '   \n', '}']
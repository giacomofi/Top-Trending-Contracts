['pragma solidity ^0.4.18;\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract Token {\n', '\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*\n', 'You should inherit from StandardToken or, for a token like you would want to\n', 'deploy in something like Mist, see HumanStandardToken.sol.\n', '(This implements ONLY the standard functions and NOTHING else.\n', 'If you deploy this, you won&#39;t have anything useful.)\n', '\n', 'Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', '.*/\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        // Prevent transfer to 0x0 address.\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balances[msg.sender] >= _value);\n', '        // Check for overflows\n', '        require(balances[_to] + _value > balances[_to]);\n', '\n', '        uint previousBalances = balances[msg.sender] + balances[_to];\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[msg.sender] + balances[_to] == previousBalances);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        /// same as above\n', '        require(_to != 0x0);\n', '        require(balances[_from] >= _value);\n', '        require(balances[_to] + _value > balances[_to]);\n', '        require(allowed[_from][msg.sender] > _value);\n', '        \n', '        uint previousBalances = balances[_from] + balances[_to];\n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances; /// balance amount of tokens for address\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract EduCoin is StandardToken {\n', '\n', '    function () payable public {\n', '        //if ether is sent to this address, send it back.\n', '        //throw;\n', '        require(false);\n', '    }\n', '\n', '    string public constant name = "Hcancan";   \n', '    string public constant symbol = "HC";\n', '    uint256 private constant _INITIAL_SUPPLY = 15*10**27;\n', '    uint8 public decimals = 18;         \n', '    uint256 public totalSupply;            \n', '    //string public version = &#39;H0.1&#39;;\n', '\n', '    function EduCoin(\n', '    ) public {\n', '        // init\n', '        balances[msg.sender] = _INITIAL_SUPPLY;\n', '        totalSupply = _INITIAL_SUPPLY;\n', '       \n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract Token {\n', '\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*\n', 'You should inherit from StandardToken or, for a token like you would want to\n', 'deploy in something like Mist, see HumanStandardToken.sol.\n', '(This implements ONLY the standard functions and NOTHING else.\n', "If you deploy this, you won't have anything useful.)\n", '\n', 'Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', '.*/\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        // Prevent transfer to 0x0 address.\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balances[msg.sender] >= _value);\n', '        // Check for overflows\n', '        require(balances[_to] + _value > balances[_to]);\n', '\n', '        uint previousBalances = balances[msg.sender] + balances[_to];\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balances[msg.sender] + balances[_to] == previousBalances);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        /// same as above\n', '        require(_to != 0x0);\n', '        require(balances[_from] >= _value);\n', '        require(balances[_to] + _value > balances[_to]);\n', '        require(allowed[_from][msg.sender] > _value);\n', '        \n', '        uint previousBalances = balances[_from] + balances[_to];\n', '        balances[_from] -= _value;\n', '        balances[_to] += _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances; /// balance amount of tokens for address\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract EduCoin is StandardToken {\n', '\n', '    function () payable public {\n', '        //if ether is sent to this address, send it back.\n', '        //throw;\n', '        require(false);\n', '    }\n', '\n', '    string public constant name = "Hcancan";   \n', '    string public constant symbol = "HC";\n', '    uint256 private constant _INITIAL_SUPPLY = 15*10**27;\n', '    uint8 public decimals = 18;         \n', '    uint256 public totalSupply;            \n', "    //string public version = 'H0.1';\n", '\n', '    function EduCoin(\n', '    ) public {\n', '        // init\n', '        balances[msg.sender] = _INITIAL_SUPPLY;\n', '        totalSupply = _INITIAL_SUPPLY;\n', '       \n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '}']

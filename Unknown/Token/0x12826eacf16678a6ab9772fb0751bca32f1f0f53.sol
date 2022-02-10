['contract SafeMath {\n', '    function mul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function assert(bool assertion) internal {\n', '        if (!assertion) {\n', '            throw;\n', '        }\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens, after that function `receiveApproval`\n', '    /// @notice will be called on `_spender` address\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @param _extraData Some data to pass in callback function\n', '    /// @return Whether the approval was successful or not\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Issuance(address indexed _to, uint256 _value);\n', '    event Burn(address indexed _from, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        string memory signature = "receiveApproval(address,uint256,address,bytes)";\n', '\n', '        if (!_spender.call(bytes4(bytes32(sha3(signature))), msg.sender, _value, this, _extraData)) {\n', '            throw;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract LATPToken is StandardToken, SafeMath {\n', '\n', '    /* Public variables of the token */\n', '\n', '    address     public founder;\n', '    address     public minter;\n', '\n', '    string      public name             =       "LATO PreICO";\n', '    uint8       public decimals         =       6;\n', '    string      public symbol           =       "LATP";\n', '    string      public version          =       "0.7.1";\n', '    uint        public maxTotalSupply   =       100000 * 1000000;\n', '\n', '\n', '    modifier onlyFounder() {\n', '        if (msg.sender != founder) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlyMinter() {\n', '        if (msg.sender != minter) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    function issueTokens(address _for, uint tokenCount)\n', '        external\n', '        payable\n', '        onlyMinter\n', '        returns (bool)\n', '    {\n', '        if (tokenCount == 0) {\n', '            return false;\n', '        }\n', '\n', '        if (add(totalSupply, tokenCount) > maxTotalSupply) {\n', '            throw;\n', '        }\n', '\n', '        totalSupply = add(totalSupply, tokenCount);\n', '        balances[_for] = add(balances[_for], tokenCount);\n', '        Issuance(_for, tokenCount);\n', '        return true;\n', '    }\n', '\n', '    function burnTokens(address _for, uint tokenCount)\n', '        external\n', '        onlyMinter\n', '        returns (bool)\n', '    {\n', '        if (tokenCount == 0) {\n', '            return false;\n', '        }\n', '\n', '        if (sub(totalSupply, tokenCount) > totalSupply) {\n', '            throw;\n', '        }\n', '\n', '        if (sub(balances[_for], tokenCount) > balances[_for]) {\n', '            throw;\n', '        }\n', '\n', '        totalSupply = sub(totalSupply, tokenCount);\n', '        balances[_for] = sub(balances[_for], tokenCount);\n', '        Burn(_for, tokenCount);\n', '        return true;\n', '    }\n', '\n', '    function changeMinter(address newAddress)\n', '        public\n', '        onlyFounder\n', '        returns (bool)\n', '    {   \n', '        minter = newAddress;\n', '    }\n', '\n', '    function changeFounder(address newAddress)\n', '        public\n', '        onlyFounder\n', '        returns (bool)\n', '    {   \n', '        founder = newAddress;\n', '    }\n', '\n', '    function () {\n', '        throw;\n', '    }\n', '\n', '    function LATPToken() {\n', '        founder = msg.sender;\n', '        totalSupply = 0; // Update total supply\n', '    }\n', '}']
['contract SafeMath {\n', '    function mul(uint a, uint b) internal returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function assert(bool assertion) internal {\n', '        if (!assertion) {\n', '            throw;\n', '        }\n', '    }\n', '}\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens, after that function `receiveApproval`\n', '    /// @notice will be called on `_spender` address\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @param _extraData Some data to pass in callback function\n', '    /// @return Whether the approval was successful or not\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Issuance(address indexed _to, uint256 _value);\n', '    event Burn(address indexed _from, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        string memory signature = "receiveApproval(address,uint256,address,bytes)";\n', '\n', '        if (!_spender.call(bytes4(bytes32(sha3(signature))), msg.sender, _value, this, _extraData)) {\n', '            throw;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract LATPToken is StandardToken, SafeMath {\n', '\n', '    /* Public variables of the token */\n', '\n', '    address     public founder;\n', '    address     public minter;\n', '\n', '    string      public name             =       "LATO PreICO";\n', '    uint8       public decimals         =       6;\n', '    string      public symbol           =       "LATP";\n', '    string      public version          =       "0.7.1";\n', '    uint        public maxTotalSupply   =       100000 * 1000000;\n', '\n', '\n', '    modifier onlyFounder() {\n', '        if (msg.sender != founder) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlyMinter() {\n', '        if (msg.sender != minter) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    function issueTokens(address _for, uint tokenCount)\n', '        external\n', '        payable\n', '        onlyMinter\n', '        returns (bool)\n', '    {\n', '        if (tokenCount == 0) {\n', '            return false;\n', '        }\n', '\n', '        if (add(totalSupply, tokenCount) > maxTotalSupply) {\n', '            throw;\n', '        }\n', '\n', '        totalSupply = add(totalSupply, tokenCount);\n', '        balances[_for] = add(balances[_for], tokenCount);\n', '        Issuance(_for, tokenCount);\n', '        return true;\n', '    }\n', '\n', '    function burnTokens(address _for, uint tokenCount)\n', '        external\n', '        onlyMinter\n', '        returns (bool)\n', '    {\n', '        if (tokenCount == 0) {\n', '            return false;\n', '        }\n', '\n', '        if (sub(totalSupply, tokenCount) > totalSupply) {\n', '            throw;\n', '        }\n', '\n', '        if (sub(balances[_for], tokenCount) > balances[_for]) {\n', '            throw;\n', '        }\n', '\n', '        totalSupply = sub(totalSupply, tokenCount);\n', '        balances[_for] = sub(balances[_for], tokenCount);\n', '        Burn(_for, tokenCount);\n', '        return true;\n', '    }\n', '\n', '    function changeMinter(address newAddress)\n', '        public\n', '        onlyFounder\n', '        returns (bool)\n', '    {   \n', '        minter = newAddress;\n', '    }\n', '\n', '    function changeFounder(address newAddress)\n', '        public\n', '        onlyFounder\n', '        returns (bool)\n', '    {   \n', '        founder = newAddress;\n', '    }\n', '\n', '    function () {\n', '        throw;\n', '    }\n', '\n', '    function LATPToken() {\n', '        founder = msg.sender;\n', '        totalSupply = 0; // Update total supply\n', '    }\n', '}']
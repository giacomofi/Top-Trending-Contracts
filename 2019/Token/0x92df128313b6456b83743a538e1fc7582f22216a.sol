['pragma solidity 0.4.24;\n', '\n', 'contract Token {\n', '\n', '    /// @return total amount of tokens\n', '    function totalSupply() constant returns (uint supply) {}\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint balance) {}\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint _value) returns (bool success) {}\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success) {}\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint _value) returns (bool success) {}\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'contract RegularToken is Token {\n', '\n', '    function transfer(address _to, uint _value) returns (bool) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '    uint public totalSupply;\n', '}\n', '\n', 'contract UnboundedRegularToken is RegularToken {\n', '\n', '    uint constant MAX_UINT = 2**256 - 1;\n', '    \n', '    /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.\n', '    /// @param _from Address to transfer from.\n', '    /// @param _to Address to transfer to.\n', '    /// @param _value Amount to transfer.\n', '    /// @return Success of transfer.\n', '    function transferFrom(address _from, address _to, uint _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint allowance = allowed[_from][msg.sender];\n', '        if (balances[_from] >= _value\n', '            && allowance >= _value\n', '            && balances[_to] + _value >= balances[_to]\n', '        ) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            if (allowance < MAX_UINT) {\n', '                allowed[_from][msg.sender] -= _value;\n', '            }\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '}\n', '\n', 'contract BTrustToken is UnboundedRegularToken {\n', '\n', '    uint public totalSupply = 2000000000000000000000000000;\n', '    uint8 constant public decimals = 18;\n', '    string constant public name = "BTrustToken";\n', '    string constant public symbol = "BTRC";\n', '\n', '    function BTrustToken() {\n', '        balances[msg.sender] = totalSupply;\n', '        Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '}']
['pragma solidity 0.4.24;\n', '\n', 'contract Token {\n', '\n', '    /// @return total amount of tokens\n', '    function totalSupply() constant returns (uint supply) {}\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint balance) {}\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint _value) returns (bool success) {}\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool success) {}\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint _value) returns (bool success) {}\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'contract RegularToken is Token {\n', '\n', '    function transfer(address _to, uint _value) returns (bool) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", '        if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '    uint public totalSupply;\n', '}\n', '\n', 'contract UnboundedRegularToken is RegularToken {\n', '\n', '    uint constant MAX_UINT = 2**256 - 1;\n', '    \n', '    /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.\n', '    /// @param _from Address to transfer from.\n', '    /// @param _to Address to transfer to.\n', '    /// @param _value Amount to transfer.\n', '    /// @return Success of transfer.\n', '    function transferFrom(address _from, address _to, uint _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint allowance = allowed[_from][msg.sender];\n', '        if (balances[_from] >= _value\n', '            && allowance >= _value\n', '            && balances[_to] + _value >= balances[_to]\n', '        ) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            if (allowance < MAX_UINT) {\n', '                allowed[_from][msg.sender] -= _value;\n', '            }\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '}\n', '\n', 'contract BTrustToken is UnboundedRegularToken {\n', '\n', '    uint public totalSupply = 2000000000000000000000000000;\n', '    uint8 constant public decimals = 18;\n', '    string constant public name = "BTrustToken";\n', '    string constant public symbol = "BTRC";\n', '\n', '    function BTrustToken() {\n', '        balances[msg.sender] = totalSupply;\n', '        Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '}']

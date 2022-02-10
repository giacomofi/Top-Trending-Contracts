['pragma solidity ^0.4.20;\n', '\n', 'contract Token {\n', '\n', '\n', '    /// @return total amount of tokens\n', '\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '\n', '    /// @return The balance\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '\n', '    /// @param _to The address of the recipient\n', '\n', '    /// @param _value The amount of token to be transferred\n', '\n', '    /// @return Whether the transfer was successful or not\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '\n', '    /// @param _from The address of the sender\n', '\n', '    /// @param _to The address of the recipient\n', '\n', '    /// @param _value The amount of token to be transferred\n', '\n', '    /// @return Whether the transfer was successful or not\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '\n', '    /// @param _value The amount of wei to be approved for transfer\n', '\n', '    /// @return Whether the approval was successful or not\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '\n', '    /// @return Amount of remaining tokens allowed to spent\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '\n', '}\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", '\n', "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '\n', '        //Replace the if with this one instead.\n', '\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '\n', '            balances[msg.sender] -= _value;\n', '\n', '            balances[_to] += _value;\n', '\n', '            Transfer(msg.sender, _to, _value);\n', '\n', '            return true;\n', '\n', '        } else { return false; }\n', '\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '\n', '            balances[_to] += _value;\n', '\n', '            balances[_from] -= _value;\n', '\n', '            allowed[_from][msg.sender] -= _value;\n', '\n', '            Transfer(_from, _to, _value);\n', '\n', '            return true;\n', '\n', '        } else { return false; }\n', '\n', '    }\n', '\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '\n', '        return balances[_owner];\n', '\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '\n', '      return allowed[_owner][_spender];\n', '\n', '    }\n', '\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '\n', '}\n', '\n', '\n', "//name this contract whatever you'd like\n", '\n', 'contract ERC20Token is StandardToken {\n', '\n', '\n', '    function () {\n', '\n', '        //if ether is sent to this address, send it back.\n', '\n', '        throw;\n', '\n', '    }\n', '\n', '\n', '    /* Public variables of the token */\n', '\n', '\n', '    /*\n', '\n', '    NOTE:\n', '\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '\n', '    */\n', '\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '\n', "    uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.\n", '\n', '    string public symbol;                 //An identifier: eg SBX\n', '\n', "    string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.\n", '\n', '\n', '//\n', '\n', '// CHANGE THESE VALUES FOR YOUR TOKEN\n', '\n', '//\n', '\n', '\n', "//make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token\n", '\n', '\n', '    function ERC20Token(\n', '\n', '        ) {\n', '\n', '        balances[msg.sender] = 18507438100000000;               \n', '\n', '        totalSupply = 18507438100000000;                        \n', '\n', '        name = "TRONSYNC";                                   \n', '\n', '        decimals = 8;                            \n', '\n', '        symbol = "TRXS";                               \n', '\n', '    }\n', '\n', '\n', '    /* Approves and then calls the receiving contract */\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '\n', "        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '}']
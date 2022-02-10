['// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'pragma solidity ^0.4.8;\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract UGToken is StandardToken {\n', '\n', '    function () {\n', '        //if ether is sent to this address, send it back.\n', '        throw;\n', '    }\n', '\n', '    string public name = "UG Token";                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It&#39;s like comparing 1 wei to 1 ether.\n', '    string public symbol = "UGT";                 //An identifier: eg SBX\n', '    string public version = &#39;v0.1&#39;;       //ug 0.1 standard. Just an arbitrary versioning scheme.\n', '\n', '    address public founder; // The address of the founder\n', '    uint256 public allocateStartBlock; // The start block number that starts to allocate token to users.\n', '    uint256 public allocateEndBlock; // The end block nubmer that allocate token to users, lasted for a week.\n', '\n', '    // The nonce for avoid transfer replay attacks\n', '    mapping(address => uint256) nonces;\n', '\n', '    function UGToken() {\n', '        founder = msg.sender;\n', '        allocateStartBlock = block.number;\n', '        allocateEndBlock = allocateStartBlock + 5082; // about one day\n', '    }\n', '\n', '    /*\n', '     * Proxy transfer ug token. When some users of the ethereum account has no ether,\n', '     * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees\n', '     * @param _from\n', '     * @param _to\n', '     * @param _value\n', '     * @param feeUgt\n', '     * @param _v\n', '     * @param _r\n', '     * @param _s\n', '     */\n', '    function transferProxy(address _from, address _to, uint256 _value, uint256 _feeUgt,\n', '        uint8 _v,bytes32 _r, bytes32 _s) returns (bool){\n', '\n', '        if(balances[_from] < _feeUgt + _value) throw;\n', '\n', '        uint256 nonce = nonces[_from];\n', '        bytes32 h = sha3(_from,_to,_value,_feeUgt,nonce);\n', '        if(_from != ecrecover(h,_v,_r,_s)) throw;\n', '\n', '        if(balances[_to] + _value < balances[_to]\n', '            || balances[msg.sender] + _feeUgt < balances[msg.sender]) throw;\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        balances[msg.sender] += _feeUgt;\n', '        Transfer(_from, msg.sender, _feeUgt);\n', '\n', '        balances[_from] -= _value + _feeUgt;\n', '        nonces[_from] = nonce + 1;\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Proxy approve that some one can authorize the agent for broadcast transaction\n', '     * which call approve method, and agents may charge agency fees\n', '     * @param _from The  address which should tranfer ugt to others\n', '     * @param _spender The spender who allowed by _from\n', '     * @param _value The value that should be tranfered.\n', '     * @param _v\n', '     * @param _r\n', '     * @param _s\n', '     */\n', '    function approveProxy(address _from, address _spender, uint256 _value,\n', '        uint8 _v,bytes32 _r, bytes32 _s) returns (bool success) {\n', '\n', '        uint256 nonce = nonces[_from];\n', '        bytes32 hash = sha3(_from,_spender,_value,nonce);\n', '        if(_from != ecrecover(hash,_v,_r,_s)) throw;\n', '        allowed[_from][_spender] = _value;\n', '        Approval(_from, _spender, _value);\n', '        nonces[_from] = nonce + 1;\n', '        return true;\n', '    }\n', '\n', '\n', '    /*\n', '     * Get the nonce\n', '     * @param _addr\n', '     */\n', '    function getNonce(address _addr) constant returns (uint256){\n', '        return nonces[_addr];\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '\n', '    /* Approves and then calls the contract code*/\n', '    function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        //Call the contract code\n', '        if(!_spender.call(_extraData)) { throw; }\n', '        return true;\n', '    }\n', '\n', '    // Allocate tokens to the users\n', '    // @param _owners The owners list of the token\n', '    // @param _values The value list of the token\n', '    function allocateTokens(address[] _owners, uint256[] _values) {\n', '\n', '        if(msg.sender != founder) throw;\n', '        if(block.number < allocateStartBlock || block.number > allocateEndBlock) throw;\n', '        if(_owners.length != _values.length) throw;\n', '\n', '        for(uint256 i = 0; i < _owners.length ; i++){\n', '            address owner = _owners[i];\n', '            uint256 value = _values[i];\n', '            if(totalSupply + value <= totalSupply || balances[owner] + value <= balances[owner]) throw;\n', '            totalSupply += value;\n', '            balances[owner] += value;\n', '        }\n', '    }\n', '}']
['// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'pragma solidity ^0.4.8;\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract UGToken is StandardToken {\n', '\n', '    function () {\n', '        //if ether is sent to this address, send it back.\n', '        throw;\n', '    }\n', '\n', '    string public name = "UG Token";                   //fancy name: eg Simon Bucks\n', "    uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.\n", '    string public symbol = "UGT";                 //An identifier: eg SBX\n', "    string public version = 'v0.1';       //ug 0.1 standard. Just an arbitrary versioning scheme.\n", '\n', '    address public founder; // The address of the founder\n', '    uint256 public allocateStartBlock; // The start block number that starts to allocate token to users.\n', '    uint256 public allocateEndBlock; // The end block nubmer that allocate token to users, lasted for a week.\n', '\n', '    // The nonce for avoid transfer replay attacks\n', '    mapping(address => uint256) nonces;\n', '\n', '    function UGToken() {\n', '        founder = msg.sender;\n', '        allocateStartBlock = block.number;\n', '        allocateEndBlock = allocateStartBlock + 5082; // about one day\n', '    }\n', '\n', '    /*\n', '     * Proxy transfer ug token. When some users of the ethereum account has no ether,\n', '     * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees\n', '     * @param _from\n', '     * @param _to\n', '     * @param _value\n', '     * @param feeUgt\n', '     * @param _v\n', '     * @param _r\n', '     * @param _s\n', '     */\n', '    function transferProxy(address _from, address _to, uint256 _value, uint256 _feeUgt,\n', '        uint8 _v,bytes32 _r, bytes32 _s) returns (bool){\n', '\n', '        if(balances[_from] < _feeUgt + _value) throw;\n', '\n', '        uint256 nonce = nonces[_from];\n', '        bytes32 h = sha3(_from,_to,_value,_feeUgt,nonce);\n', '        if(_from != ecrecover(h,_v,_r,_s)) throw;\n', '\n', '        if(balances[_to] + _value < balances[_to]\n', '            || balances[msg.sender] + _feeUgt < balances[msg.sender]) throw;\n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        balances[msg.sender] += _feeUgt;\n', '        Transfer(_from, msg.sender, _feeUgt);\n', '\n', '        balances[_from] -= _value + _feeUgt;\n', '        nonces[_from] = nonce + 1;\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Proxy approve that some one can authorize the agent for broadcast transaction\n', '     * which call approve method, and agents may charge agency fees\n', '     * @param _from The  address which should tranfer ugt to others\n', '     * @param _spender The spender who allowed by _from\n', '     * @param _value The value that should be tranfered.\n', '     * @param _v\n', '     * @param _r\n', '     * @param _s\n', '     */\n', '    function approveProxy(address _from, address _spender, uint256 _value,\n', '        uint8 _v,bytes32 _r, bytes32 _s) returns (bool success) {\n', '\n', '        uint256 nonce = nonces[_from];\n', '        bytes32 hash = sha3(_from,_spender,_value,nonce);\n', '        if(_from != ecrecover(hash,_v,_r,_s)) throw;\n', '        allowed[_from][_spender] = _value;\n', '        Approval(_from, _spender, _value);\n', '        nonces[_from] = nonce + 1;\n', '        return true;\n', '    }\n', '\n', '\n', '    /*\n', '     * Get the nonce\n', '     * @param _addr\n', '     */\n', '    function getNonce(address _addr) constant returns (uint256){\n', '        return nonces[_addr];\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', "        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '\n', '    /* Approves and then calls the contract code*/\n', '    function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        //Call the contract code\n', '        if(!_spender.call(_extraData)) { throw; }\n', '        return true;\n', '    }\n', '\n', '    // Allocate tokens to the users\n', '    // @param _owners The owners list of the token\n', '    // @param _values The value list of the token\n', '    function allocateTokens(address[] _owners, uint256[] _values) {\n', '\n', '        if(msg.sender != founder) throw;\n', '        if(block.number < allocateStartBlock || block.number > allocateEndBlock) throw;\n', '        if(_owners.length != _values.length) throw;\n', '\n', '        for(uint256 i = 0; i < _owners.length ; i++){\n', '            address owner = _owners[i];\n', '            uint256 value = _values[i];\n', '            if(totalSupply + value <= totalSupply || balances[owner] + value <= balances[owner]) throw;\n', '            totalSupply += value;\n', '            balances[owner] += value;\n', '        }\n', '    }\n', '}']
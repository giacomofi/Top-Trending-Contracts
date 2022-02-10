['pragma solidity ^0.4.8;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function toUINT112(uint256 a) internal constant returns(uint112) {\n', '    assert(uint112(a) == a);\n', '    return uint112(a);\n', '  }\n', '\n', '  function toUINT120(uint256 a) internal constant returns(uint120) {\n', '    assert(uint120(a) == a);\n', '    return uint120(a);\n', '  }\n', '\n', '  function toUINT128(uint256 a) internal constant returns(uint128) {\n', '    assert(uint128(a) == a);\n', '    return uint128(a);\n', '  }\n', '}\n', 'contract Token{\n', '\n', '\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '    using SafeMath for uint256;\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '\n', '        if (_to == 0x0) throw;   \n', '        if (_value <= 0) throw;\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '\n', '            balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);      \n', '\n', '            balances[_to] = SafeMath.add(balances[_to], _value);     \n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (_to == 0x0) throw;\n', '        if (_value <= 0) throw;\n', '        if (balances[_from] < _value) throw;                  // Check if the sender has enough\n', '\n', '\n', '        if ( SafeMath.sub(balances[_to], _value) < balances[_to] ) throw;    // Check for overflows\n', '\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = SafeMath.add( balances[_to],_value);\n', '            balances[_from] = SafeMath.sub(balances[_from], _value);\n', '            allowed[_from][msg.sender]  = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', '\n', '\n', '\n', 'contract PRZTToken is StandardToken {\n', '    using SafeMath for uint256;\n', '    function () {\n', '        //if ether is sent to this address, send it back.\n', '        throw;\n', '    }\n', '\n', '\n', '\n', '    /* Public variables of the token */\n', '\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It&#39;s like comparing 1 wei to 1 ether.\n', '    string public symbol;                 //An identifier: eg SBX\n', '    string public version = &#39;H0.1&#39;;       //human 0.1 standard. Just an arbitrary versioning scheme.\n', '\n', '    function PRZTToken(\n', '        uint256 _initialAmount,\n', '        string _tokenName,\n', '        uint8 _decimalUnits,\n', '        string _tokenSymbol\n', '        ) {\n', '        balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens\n', '        totalSupply = _initialAmount;                        // Update total supply\n', '        name = _tokenName;                                   // Set the name for display purposes\n', '        decimals = _decimalUnits;                            // Amount of decimals for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.8;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function toUINT112(uint256 a) internal constant returns(uint112) {\n', '    assert(uint112(a) == a);\n', '    return uint112(a);\n', '  }\n', '\n', '  function toUINT120(uint256 a) internal constant returns(uint120) {\n', '    assert(uint120(a) == a);\n', '    return uint120(a);\n', '  }\n', '\n', '  function toUINT128(uint256 a) internal constant returns(uint128) {\n', '    assert(uint128(a) == a);\n', '    return uint128(a);\n', '  }\n', '}\n', 'contract Token{\n', '\n', '\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '    using SafeMath for uint256;\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '\n', '        if (_to == 0x0) throw;   \n', '        if (_value <= 0) throw;\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '\n', '            balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);      \n', '\n', '            balances[_to] = SafeMath.add(balances[_to], _value);     \n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (_to == 0x0) throw;\n', '        if (_value <= 0) throw;\n', '        if (balances[_from] < _value) throw;                  // Check if the sender has enough\n', '\n', '\n', '        if ( SafeMath.sub(balances[_to], _value) < balances[_to] ) throw;    // Check for overflows\n', '\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] = SafeMath.add( balances[_to],_value);\n', '            balances[_from] = SafeMath.sub(balances[_from], _value);\n', '            allowed[_from][msg.sender]  = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', '\n', '\n', '\n', 'contract PRZTToken is StandardToken {\n', '    using SafeMath for uint256;\n', '    function () {\n', '        //if ether is sent to this address, send it back.\n', '        throw;\n', '    }\n', '\n', '\n', '\n', '    /* Public variables of the token */\n', '\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name;                   //fancy name: eg Simon Bucks\n', "    uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.\n", '    string public symbol;                 //An identifier: eg SBX\n', "    string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.\n", '\n', '    function PRZTToken(\n', '        uint256 _initialAmount,\n', '        string _tokenName,\n', '        uint8 _decimalUnits,\n', '        string _tokenSymbol\n', '        ) {\n', '        balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens\n', '        totalSupply = _initialAmount;                        // Update total supply\n', '        name = _tokenName;                                   // Set the name for display purposes\n', '        decimals = _decimalUnits;                            // Amount of decimals for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', "        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '}']

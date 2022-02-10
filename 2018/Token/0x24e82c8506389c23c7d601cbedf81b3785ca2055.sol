['pragma solidity ^0.4.16;\n', 'contract WBET{\n', '\n', '    uint256 constant private MAX_UINT256 = 2**256 - 1;\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    uint256 public totalSupply;\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show.\n', '    string public symbol;                 //An identifier: eg SBX\n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value); \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '   \n', '    function WBET() public {\n', '        balances[msg.sender] = 3600000000000;               // Give the creator all initial tokens\n', '        totalSupply = 3600000000000;                        // Update total supply\n', '        name = "世行以太链";                                   // Set the name for display purposes\n', '        decimals =4;                            // Amount of decimals for display purposes\n', '        symbol = "WBET";                               // Set the symbol for display purposes\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        if (allowance < MAX_UINT256) {\n', '            allowed[_from][msg.sender] -= _value;\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }   \n', '}']
['pragma solidity ^0.4.16;\n', 'contract WBET{\n', '\n', '    uint256 constant private MAX_UINT256 = 2**256 - 1;\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    uint256 public totalSupply;\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show.\n', '    string public symbol;                 //An identifier: eg SBX\n', '     event Transfer(address indexed _from, address indexed _to, uint256 _value); \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '   \n', '    function WBET() public {\n', '        balances[msg.sender] = 3600000000000;               // Give the creator all initial tokens\n', '        totalSupply = 3600000000000;                        // Update total supply\n', '        name = "世行以太链";                                   // Set the name for display purposes\n', '        decimals =4;                            // Amount of decimals for display purposes\n', '        symbol = "WBET";                               // Set the symbol for display purposes\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        if (allowance < MAX_UINT256) {\n', '            allowed[_from][msg.sender] -= _value;\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }   \n', '}']

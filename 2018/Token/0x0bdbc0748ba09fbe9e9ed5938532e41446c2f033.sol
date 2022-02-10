['pragma solidity  0.4 .21;\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// Sample fixed supply token contract\n', '// Enjoy. (c) BokkyPooBah 2017. The MIT Licence.\n', '// ----------------------------------------------------------------------------------------------\n', '\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract Token {\n', '    // Get the total\n', '     //token supply\n', '    function totalSupply() constant returns(uint256 initialSupply);\n', '\n', '    // Get the account balance of another account with address _owner\n', '    function balanceOf(address _owner) constant returns(uint256 balance);\n', '\n', '    // Send _value amount of tokens to address _to\n', '    function transfer(address _to, uint256 _value) returns(bool success);\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool success);\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    // this function is required for some DEX functionality\n', '    function approve(address _spender, uint256 _value) returns(bool success);\n', '\n', '    // Returns the amount which _spender is still allowed to withdraw from _owner\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining);\n', '\n', '   \n', '\n', '    //Trigger when Tokens Burned\n', '        event Burn(address indexed from, uint256 value);\n', '\n', '\n', '    // Triggered when tokens are transferred.\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract AssetToken is Token {\n', '    string public  symbol;\n', '    string public  name;\n', '    uint8 public  decimals;\n', '    uint256 _totalSupply;\n', '    address public centralAdmin;\n', '        uint256 public soldToken;\n', '\n', '\n', '\n', '    // Owner of this contract\n', '    address public owner;\n', '\n', '    // Balances for each account\n', '    mapping(address => uint256) balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    // Functions with this modifier can only be executed by the owner\n', '   modifier onlyOwner(){\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    // Constructor\n', '    function AssetToken(uint256 totalSupply,string tokenName,uint8 decimalUnits,string tokenSymbol,address centralAdmin) {\n', '           soldToken = 0;\n', '\n', '        if(centralAdmin != 0)\n', '            owner = centralAdmin;\n', '        else\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '        symbol = tokenSymbol;\n', '        name = tokenName;\n', '        decimals = decimalUnits;\n', '        _totalSupply = totalSupply ;\n', '    }\n', '  function transferAdminship(address newAdmin) onlyOwner {\n', '        owner = newAdmin;\n', '    }\n', '    function totalSupply() constant returns(uint256 initialSupply) {\n', '        initialSupply = _totalSupply;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '     //Mint the Token \n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner{\n', '        balances[target] += mintedAmount;\n', '        _totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    // Transfer the balance from owner&#39;s account to another account\n', '    function transfer(address _to, uint256 _amount) returns(bool success) {\n', '        if (balances[msg.sender] >= _amount &&\n', '            _amount > 0 &&\n', '            balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) returns(bool success) {\n', '        if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 &&\n', '            balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '    //Allow the owner to burn the token from their accounts\n', 'function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   \n', '        balances[msg.sender] -= _value;            \n', '        _totalSupply -= _value;                      \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '//For calculating the sold tokens\n', '   function transferCrowdsale(address _to, uint256 _value){\n', '        require(balances[msg.sender] > 0);\n', '        require(balances[msg.sender] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '        //if(admin)\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '         soldToken +=  _value;\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount) returns(bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', ' \n', '\n', '}']
['pragma solidity  0.4 .21;\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// Sample fixed supply token contract\n', '// Enjoy. (c) BokkyPooBah 2017. The MIT Licence.\n', '// ----------------------------------------------------------------------------------------------\n', '\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract Token {\n', '    // Get the total\n', '     //token supply\n', '    function totalSupply() constant returns(uint256 initialSupply);\n', '\n', '    // Get the account balance of another account with address _owner\n', '    function balanceOf(address _owner) constant returns(uint256 balance);\n', '\n', '    // Send _value amount of tokens to address _to\n', '    function transfer(address _to, uint256 _value) returns(bool success);\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool success);\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    // this function is required for some DEX functionality\n', '    function approve(address _spender, uint256 _value) returns(bool success);\n', '\n', '    // Returns the amount which _spender is still allowed to withdraw from _owner\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining);\n', '\n', '   \n', '\n', '    //Trigger when Tokens Burned\n', '        event Burn(address indexed from, uint256 value);\n', '\n', '\n', '    // Triggered when tokens are transferred.\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract AssetToken is Token {\n', '    string public  symbol;\n', '    string public  name;\n', '    uint8 public  decimals;\n', '    uint256 _totalSupply;\n', '    address public centralAdmin;\n', '        uint256 public soldToken;\n', '\n', '\n', '\n', '    // Owner of this contract\n', '    address public owner;\n', '\n', '    // Balances for each account\n', '    mapping(address => uint256) balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    // Functions with this modifier can only be executed by the owner\n', '   modifier onlyOwner(){\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    // Constructor\n', '    function AssetToken(uint256 totalSupply,string tokenName,uint8 decimalUnits,string tokenSymbol,address centralAdmin) {\n', '           soldToken = 0;\n', '\n', '        if(centralAdmin != 0)\n', '            owner = centralAdmin;\n', '        else\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '        symbol = tokenSymbol;\n', '        name = tokenName;\n', '        decimals = decimalUnits;\n', '        _totalSupply = totalSupply ;\n', '    }\n', '  function transferAdminship(address newAdmin) onlyOwner {\n', '        owner = newAdmin;\n', '    }\n', '    function totalSupply() constant returns(uint256 initialSupply) {\n', '        initialSupply = _totalSupply;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '     //Mint the Token \n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner{\n', '        balances[target] += mintedAmount;\n', '        _totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', "    // Transfer the balance from owner's account to another account\n", '    function transfer(address _to, uint256 _amount) returns(bool success) {\n', '        if (balances[msg.sender] >= _amount &&\n', '            _amount > 0 &&\n', '            balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) returns(bool success) {\n', '        if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 &&\n', '            balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '    //Allow the owner to burn the token from their accounts\n', 'function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   \n', '        balances[msg.sender] -= _value;            \n', '        _totalSupply -= _value;                      \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '//For calculating the sold tokens\n', '   function transferCrowdsale(address _to, uint256 _value){\n', '        require(balances[msg.sender] > 0);\n', '        require(balances[msg.sender] >= _value);\n', '        require(balances[_to] + _value >= balances[_to]);\n', '        //if(admin)\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '         soldToken +=  _value;\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount) returns(bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', ' \n', '\n', '}']

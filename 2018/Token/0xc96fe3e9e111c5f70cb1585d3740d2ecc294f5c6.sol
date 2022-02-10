['pragma solidity ^0.4.20;\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract Token{\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', 'contract HammerChain is Token {\n', '\n', '    address  owner;  // owner address\n', '    address INCENTIVE_POOL_ADDR = 0x0;\n', '    address FOUNDATION_POOL_ADDR = 0xE4ae52AeC7359c145f4aEeBEFA59fC6F181a4e43;\n', '    address COMMUNITY_POOL_ADDR = 0x611C1e09589d658c6881B3966F42bEA84d0Fab82;\n', '    address FOUNDERS_POOL_ADDR = 0x59556f481FF8d1f0C55926f981070Aa8f767922b;\n', '\n', '    bool releasedFoundation = false;\n', '    bool releasedCommunity = false;\n', '    uint256  timeIncentive = 0x0;\n', '    uint256 limitIncentive=0x0;\n', '    uint256 timeFounders= 0x0;\n', '    uint256 limitFounders=0x0;\n', '\n', '    string public name;                 //HRC name \n', '    uint8 public decimals;              //token decimals with HRC\n', '    string public symbol;               //token symbol with HRC\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    modifier onlyOwner { \n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    function HammerChain() public {\n', '        owner = msg.sender;\n', '        uint8 _decimalUnits = 18; // 18 decimals is the strongly suggested default, avoid changing it\n', '        totalSupply = 512000000 * 10 ** uint256(_decimalUnits); // iniliatized total supply token\n', '        balances[msg.sender] = totalSupply; \n', '\n', '        name = "HammerChain";\n', '        decimals = _decimalUnits;\n', '        symbol = "HRC";\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        // default is totalSupply not of out (2^256 - 1).\n', '        require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(_to != 0x0);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != 0x0);\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value; \n', '        allowed[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success)   \n', '    { \n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];//allow _spender from _owner send out token\n', '    }\n', '\n', '    function sendIncentive() onlyOwner public{\n', '        require(limitIncentive < totalSupply/2);\n', '        if (timeIncentive < now){\n', '            if (timeIncentive == 0x0){\n', '                transfer(INCENTIVE_POOL_ADDR,totalSupply/10);\n', '                limitIncentive += totalSupply/10;\n', '            }\n', '            else{\n', '                transfer(INCENTIVE_POOL_ADDR,totalSupply/20);\n', '                limitIncentive += totalSupply/20;\n', '            }\n', '            timeIncentive = now + 365 days;\n', '        }\n', '    }\n', '\n', '    function sendFounders() onlyOwner public{\n', '        require(limitFounders < totalSupply/20);\n', '        if (timeFounders== 0x0 || timeFounders < now){\n', '            transfer(FOUNDERS_POOL_ADDR,totalSupply/100);\n', '            timeFounders = now + 365 days;\n', '            limitFounders += totalSupply/100;\n', '        }\n', '    }\n', '\n', '    function sendFoundation() onlyOwner public{\n', '        require(releasedFoundation == false);\n', '        transfer(FOUNDATION_POOL_ADDR,totalSupply/4);\n', '        releasedFoundation = true;\n', '    }\n', '\n', '\n', '    function sendCommunity() onlyOwner public{\n', '        require(releasedCommunity == false);\n', '        transfer(COMMUNITY_POOL_ADDR,totalSupply/5);\n', '        releasedCommunity = true;\n', '    }\n', '\n', '    function setINCENTIVE_POOL_ADDR(address addr) onlyOwner public{\n', '        INCENTIVE_POOL_ADDR = addr;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowed\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowed[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.20;\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', 'contract Token{\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', 'contract HammerChain is Token {\n', '\n', '    address  owner;  // owner address\n', '    address INCENTIVE_POOL_ADDR = 0x0;\n', '    address FOUNDATION_POOL_ADDR = 0xE4ae52AeC7359c145f4aEeBEFA59fC6F181a4e43;\n', '    address COMMUNITY_POOL_ADDR = 0x611C1e09589d658c6881B3966F42bEA84d0Fab82;\n', '    address FOUNDERS_POOL_ADDR = 0x59556f481FF8d1f0C55926f981070Aa8f767922b;\n', '\n', '    bool releasedFoundation = false;\n', '    bool releasedCommunity = false;\n', '    uint256  timeIncentive = 0x0;\n', '    uint256 limitIncentive=0x0;\n', '    uint256 timeFounders= 0x0;\n', '    uint256 limitFounders=0x0;\n', '\n', '    string public name;                 //HRC name \n', '    uint8 public decimals;              //token decimals with HRC\n', '    string public symbol;               //token symbol with HRC\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    modifier onlyOwner { \n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    function HammerChain() public {\n', '        owner = msg.sender;\n', '        uint8 _decimalUnits = 18; // 18 decimals is the strongly suggested default, avoid changing it\n', '        totalSupply = 512000000 * 10 ** uint256(_decimalUnits); // iniliatized total supply token\n', '        balances[msg.sender] = totalSupply; \n', '\n', '        name = "HammerChain";\n', '        decimals = _decimalUnits;\n', '        symbol = "HRC";\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        // default is totalSupply not of out (2^256 - 1).\n', '        require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(_to != 0x0);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != 0x0);\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value; \n', '        allowed[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success)   \n', '    { \n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];//allow _spender from _owner send out token\n', '    }\n', '\n', '    function sendIncentive() onlyOwner public{\n', '        require(limitIncentive < totalSupply/2);\n', '        if (timeIncentive < now){\n', '            if (timeIncentive == 0x0){\n', '                transfer(INCENTIVE_POOL_ADDR,totalSupply/10);\n', '                limitIncentive += totalSupply/10;\n', '            }\n', '            else{\n', '                transfer(INCENTIVE_POOL_ADDR,totalSupply/20);\n', '                limitIncentive += totalSupply/20;\n', '            }\n', '            timeIncentive = now + 365 days;\n', '        }\n', '    }\n', '\n', '    function sendFounders() onlyOwner public{\n', '        require(limitFounders < totalSupply/20);\n', '        if (timeFounders== 0x0 || timeFounders < now){\n', '            transfer(FOUNDERS_POOL_ADDR,totalSupply/100);\n', '            timeFounders = now + 365 days;\n', '            limitFounders += totalSupply/100;\n', '        }\n', '    }\n', '\n', '    function sendFoundation() onlyOwner public{\n', '        require(releasedFoundation == false);\n', '        transfer(FOUNDATION_POOL_ADDR,totalSupply/4);\n', '        releasedFoundation = true;\n', '    }\n', '\n', '\n', '    function sendCommunity() onlyOwner public{\n', '        require(releasedCommunity == false);\n', '        transfer(COMMUNITY_POOL_ADDR,totalSupply/5);\n', '        releasedCommunity = true;\n', '    }\n', '\n', '    function setINCENTIVE_POOL_ADDR(address addr) onlyOwner public{\n', '        INCENTIVE_POOL_ADDR = addr;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowed\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '}']
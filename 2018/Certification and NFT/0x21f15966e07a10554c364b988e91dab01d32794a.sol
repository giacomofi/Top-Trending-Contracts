['// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.*/\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract Owned {\n', '\n', '    /// `owner` is the only address that can call a function with this\n', '    /// modifier\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    address public owner;\n', '\n', '    /// @notice The Constructor assigns the message sender to be `owner`\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    address newOwner=0x0;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    ///change the owner\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /// accept the ownership\n', '    function acceptOwnership() public{\n', '        require(msg.sender == newOwner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', 'contract Controlled is Owned{\n', '\n', '    constructor() public {\n', '       setExclude(msg.sender);\n', '    }\n', '\n', '    // Flag that determines if the token is transferable or not.\n', '    bool public transferEnabled = false;\n', '\n', '    // flag that makes locked address effect\n', '    bool lockFlag=true;\n', '    mapping(address => bool) locked;\n', '    mapping(address => bool) exclude;\n', '\n', '    function enableTransfer(bool _enable) public onlyOwner{\n', '        transferEnabled=_enable;\n', '    }\n', '\n', '    function disableLock(bool _enable) public onlyOwner returns (bool success){\n', '        lockFlag=_enable;\n', '        return true;\n', '    }\n', '\n', '    function addLock(address _addr) public onlyOwner returns (bool success){\n', '        require(_addr!=msg.sender);\n', '        locked[_addr]=true;\n', '        return true;\n', '    }\n', '\n', '    function setExclude(address _addr) public onlyOwner returns (bool success){\n', '        exclude[_addr]=true;\n', '        return true;\n', '    }\n', '\n', '    function removeLock(address _addr) public onlyOwner returns (bool success){\n', '        locked[_addr]=false;\n', '        return true;\n', '    }\n', '\n', '    modifier transferAllowed(address _addr) {\n', '        if (!exclude[_addr]) {\n', '            assert(transferEnabled);\n', '            if(lockFlag){\n', '                assert(!locked[_addr]);\n', '            }\n', '        }\n', '        \n', '        _;\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is Token,Controlled {\n', '\n', '    function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool success) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract SMT is StandardToken {\n', '\n', '    function () public {\n', '        revert();\n', '    }\n', '\n', '    string public name = "SmartMesh Token";                   //fancy name\n', '    uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It&#39;s like comparing 1 wei to 1 ether.\n', '    string public symbol = "SMT";                 //An identifier\n', '    string public version = &#39;v0.1&#39;;       //SMT 0.1 standard. Just an arbitrary versioning scheme.\n', '    uint256 public allocateEndTime;\n', '\n', '    \n', '    // The nonce for avoid transfer replay attacks\n', '    mapping(address => uint256) nonces;\n', '\n', '    constructor() public {\n', '        allocateEndTime = now + 1 days;\n', '    }\n', '\n', '    /*\n', '     * Proxy transfer SmartMesh token. When some users of the ethereum account has no ether,\n', '     * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees\n', '     * @param _from\n', '     * @param _to\n', '     * @param _value\n', '     * @param feeSmt\n', '     * @param _v\n', '     * @param _r\n', '     * @param _s\n', '     */\n', '    function transferProxy(address _from, address _to, uint256 _value, uint256 _feeSmt,\n', '        uint8 _v,bytes32 _r, bytes32 _s) public transferAllowed(_from) returns (bool){\n', '\n', '        if(balances[_from] < _feeSmt + _value \n', '            || _feeSmt > _feeSmt + _value) revert();\n', '\n', '        uint256 nonce = nonces[_from];\n', '        bytes32 h = keccak256(_from,_to,_value,_feeSmt,nonce,address(this));\n', '        if(_from != ecrecover(h,_v,_r,_s)) revert();\n', '\n', '        if(balances[_to] + _value < balances[_to]\n', '            || balances[msg.sender] + _feeSmt < balances[msg.sender]) revert();\n', '        balances[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        balances[msg.sender] += _feeSmt;\n', '        emit Transfer(_from, msg.sender, _feeSmt);\n', '\n', '        balances[_from] -= _value + _feeSmt;\n', '        nonces[_from] = nonce + 1;\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Proxy approve that some one can authorize the agent for broadcast transaction\n', '     * which call approve method, and agents may charge agency fees\n', '     * @param _from The address which should tranfer SMT to others\n', '     * @param _spender The spender who allowed by _from\n', '     * @param _value The value that should be tranfered.\n', '     * @param _v\n', '     * @param _r\n', '     * @param _s\n', '     */\n', '    function approveProxy(address _from, address _spender, uint256 _value,\n', '        uint8 _v,bytes32 _r, bytes32 _s) public returns (bool success) {\n', '\n', '        uint256 nonce = nonces[_from];\n', '        bytes32 hash = keccak256(_from,_spender,_value,nonce,address(this));\n', '        if(_from != ecrecover(hash,_v,_r,_s)) revert();\n', '        allowed[_from][_spender] = _value;\n', '        emit Approval(_from, _spender, _value);\n', '        nonces[_from] = nonce + 1;\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Get the nonce\n', '     * @param _addr\n', '     */\n', '    function getNonce(address _addr) public constant returns (uint256){\n', '        return nonces[_addr];\n', '    }\n', '\n', '    // Allocate tokens to the users\n', '    // @param _owners The owners list of the token\n', '    // @param _values The value list of the token\n', '    function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {\n', '\n', '        if(allocateEndTime < now) revert();\n', '        if(_owners.length != _values.length) revert();\n', '\n', '        for(uint256 i = 0; i < _owners.length ; i++){\n', '            address to = _owners[i];\n', '            uint256 value = _values[i];\n', '            if(totalSupply + value <= totalSupply || balances[to] + value <= balances[to]) revert();\n', '            totalSupply += value;\n', '            balances[to] += value;\n', '        }\n', '    }\n', '}']
['// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.*/\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract Owned {\n', '\n', '    /// `owner` is the only address that can call a function with this\n', '    /// modifier\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    address public owner;\n', '\n', '    /// @notice The Constructor assigns the message sender to be `owner`\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    address newOwner=0x0;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    ///change the owner\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /// accept the ownership\n', '    function acceptOwnership() public{\n', '        require(msg.sender == newOwner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', 'contract Controlled is Owned{\n', '\n', '    constructor() public {\n', '       setExclude(msg.sender);\n', '    }\n', '\n', '    // Flag that determines if the token is transferable or not.\n', '    bool public transferEnabled = false;\n', '\n', '    // flag that makes locked address effect\n', '    bool lockFlag=true;\n', '    mapping(address => bool) locked;\n', '    mapping(address => bool) exclude;\n', '\n', '    function enableTransfer(bool _enable) public onlyOwner{\n', '        transferEnabled=_enable;\n', '    }\n', '\n', '    function disableLock(bool _enable) public onlyOwner returns (bool success){\n', '        lockFlag=_enable;\n', '        return true;\n', '    }\n', '\n', '    function addLock(address _addr) public onlyOwner returns (bool success){\n', '        require(_addr!=msg.sender);\n', '        locked[_addr]=true;\n', '        return true;\n', '    }\n', '\n', '    function setExclude(address _addr) public onlyOwner returns (bool success){\n', '        exclude[_addr]=true;\n', '        return true;\n', '    }\n', '\n', '    function removeLock(address _addr) public onlyOwner returns (bool success){\n', '        locked[_addr]=false;\n', '        return true;\n', '    }\n', '\n', '    modifier transferAllowed(address _addr) {\n', '        if (!exclude[_addr]) {\n', '            assert(transferEnabled);\n', '            if(lockFlag){\n', '                assert(!locked[_addr]);\n', '            }\n', '        }\n', '        \n', '        _;\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is Token,Controlled {\n', '\n', '    function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract SMT is StandardToken {\n', '\n', '    function () public {\n', '        revert();\n', '    }\n', '\n', '    string public name = "SmartMesh Token";                   //fancy name\n', "    uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.\n", '    string public symbol = "SMT";                 //An identifier\n', "    string public version = 'v0.1';       //SMT 0.1 standard. Just an arbitrary versioning scheme.\n", '    uint256 public allocateEndTime;\n', '\n', '    \n', '    // The nonce for avoid transfer replay attacks\n', '    mapping(address => uint256) nonces;\n', '\n', '    constructor() public {\n', '        allocateEndTime = now + 1 days;\n', '    }\n', '\n', '    /*\n', '     * Proxy transfer SmartMesh token. When some users of the ethereum account has no ether,\n', '     * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees\n', '     * @param _from\n', '     * @param _to\n', '     * @param _value\n', '     * @param feeSmt\n', '     * @param _v\n', '     * @param _r\n', '     * @param _s\n', '     */\n', '    function transferProxy(address _from, address _to, uint256 _value, uint256 _feeSmt,\n', '        uint8 _v,bytes32 _r, bytes32 _s) public transferAllowed(_from) returns (bool){\n', '\n', '        if(balances[_from] < _feeSmt + _value \n', '            || _feeSmt > _feeSmt + _value) revert();\n', '\n', '        uint256 nonce = nonces[_from];\n', '        bytes32 h = keccak256(_from,_to,_value,_feeSmt,nonce,address(this));\n', '        if(_from != ecrecover(h,_v,_r,_s)) revert();\n', '\n', '        if(balances[_to] + _value < balances[_to]\n', '            || balances[msg.sender] + _feeSmt < balances[msg.sender]) revert();\n', '        balances[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        balances[msg.sender] += _feeSmt;\n', '        emit Transfer(_from, msg.sender, _feeSmt);\n', '\n', '        balances[_from] -= _value + _feeSmt;\n', '        nonces[_from] = nonce + 1;\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Proxy approve that some one can authorize the agent for broadcast transaction\n', '     * which call approve method, and agents may charge agency fees\n', '     * @param _from The address which should tranfer SMT to others\n', '     * @param _spender The spender who allowed by _from\n', '     * @param _value The value that should be tranfered.\n', '     * @param _v\n', '     * @param _r\n', '     * @param _s\n', '     */\n', '    function approveProxy(address _from, address _spender, uint256 _value,\n', '        uint8 _v,bytes32 _r, bytes32 _s) public returns (bool success) {\n', '\n', '        uint256 nonce = nonces[_from];\n', '        bytes32 hash = keccak256(_from,_spender,_value,nonce,address(this));\n', '        if(_from != ecrecover(hash,_v,_r,_s)) revert();\n', '        allowed[_from][_spender] = _value;\n', '        emit Approval(_from, _spender, _value);\n', '        nonces[_from] = nonce + 1;\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Get the nonce\n', '     * @param _addr\n', '     */\n', '    function getNonce(address _addr) public constant returns (uint256){\n', '        return nonces[_addr];\n', '    }\n', '\n', '    // Allocate tokens to the users\n', '    // @param _owners The owners list of the token\n', '    // @param _values The value list of the token\n', '    function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {\n', '\n', '        if(allocateEndTime < now) revert();\n', '        if(_owners.length != _values.length) revert();\n', '\n', '        for(uint256 i = 0; i < _owners.length ; i++){\n', '            address to = _owners[i];\n', '            uint256 value = _values[i];\n', '            if(totalSupply + value <= totalSupply || balances[to] + value <= balances[to]) revert();\n', '            totalSupply += value;\n', '            balances[to] += value;\n', '        }\n', '    }\n', '}']

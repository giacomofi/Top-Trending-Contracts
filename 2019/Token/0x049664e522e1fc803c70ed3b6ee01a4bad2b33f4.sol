['pragma solidity ^0.4.25;\n', '\n', 'contract Token {\n', '\n', '    /// @return total amount of tokens\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event setNewBlockEvent(string SecretKey_Pre, string Name_New, string TxHash_Pre, string DigestCode_New, string Image_New, string Note_New);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', 'contract DragonBallVegeta is StandardToken {\n', '\n', '    function DragonBallVegeta() public { \n', '        totalSupply = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '    }\n', '    function () {\n', '        //if ether is sent to this address, send it back.\n', '        throw;\n', '    }\n', '\n', '    /* Public variables of the token */\n', '\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name = "DragonBallVegeta";\n', '    string public symbol = "DBV";\n', '    uint public decimals = 8;\n', '    uint public INITIAL_SUPPLY = 90000 * (10 ** decimals);\n', '    string public Image_root = "https://swarm-gateways.net/bzz:/496a0605add1eeb3c804f551d358232958716c0febec367e1dddb3b82acc1121/";\n', '    string public Note_root = "https://swarm-gateways.net/bzz:/38972812386e47ee7f28829311a02f6116c2158cccf96e6a3674c572dd8ceb5a/";\n', '    string public DigestCode_root = "a07936b004af5664cdeb86e7a768c8d5da2542adf5c992fdc8bdf2b7ce61c9c5";\n', '    function getIssuer() public view returns(string) { return  "Vegeta"; }\n', '    function getArtist() public view returns(string) { return  "Dragon"; }\n', '    string public TxHash_root = "genesis";\n', '\n', '    string public ContractSource = "";\n', '    string public CodeVersion = "v0.1";\n', '    \n', '    string public SecretKey_Pre = "";\n', '    string public Name_New = "";\n', '    string public TxHash_Pre = "";\n', '    string public DigestCode_New = "";\n', '    string public Image_New = "";\n', '    string public Note_New = "";\n', '\n', '    function getName() public view returns(string) { return name; }\n', '    function getDigestCodeRoot() public view returns(string) { return DigestCode_root; }\n', '    function getTxHashRoot() public view returns(string) { return TxHash_root; }\n', '    function getImageRoot() public view returns(string) { return Image_root; }\n', '    function getNoteRoot() public view returns(string) { return Note_root; }\n', '    function getCodeVersion() public view returns(string) { return CodeVersion; }\n', '    function getContractSource() public view returns(string) { return ContractSource; }\n', '\n', '    function getSecretKeyPre() public view returns(string) { return SecretKey_Pre; }\n', '    function getNameNew() public view returns(string) { return Name_New; }\n', '    function getTxHashPre() public view returns(string) { return TxHash_Pre; }\n', '    function getDigestCodeNew() public view returns(string) { return DigestCode_New; }\n', '    function getImageNew() public view returns(string) { return Image_New; }\n', '    function getNoteNew() public view returns(string) { return Note_New; }\n', '\n', '    function setNewBlock(string _SecretKey_Pre, string _Name_New, string _TxHash_Pre, string _DigestCode_New, string _Image_New, string _Note_New )  returns (bool success) {\n', '        SecretKey_Pre = _SecretKey_Pre;\n', '        Name_New = _Name_New;\n', '        TxHash_Pre = _TxHash_Pre;\n', '        DigestCode_New = _DigestCode_New;\n', '        Image_New = _Image_New;\n', '        Note_New = _Note_New;\n', '        emit setNewBlockEvent(SecretKey_Pre, Name_New, TxHash_Pre, DigestCode_New, Image_New, Note_New);\n', '        return true;\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', "        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '}\n']
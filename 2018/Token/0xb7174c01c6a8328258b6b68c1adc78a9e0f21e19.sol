['pragma solidity ^0.4.16;\n', '// Ultroneum tokens Smart contract based on the full ERC20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', '// Verified Status: ERC20 Verified Token\n', '// Ultroneum tokens Symbol: XUM\n', '\n', '\n', 'contract ULTRONEUMToken { \n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '    \n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/**\n', ' * Ultroneum tokens Math operations with safety checks to avoid unnecessary conflicts\n', ' */\n', '\n', 'library ABCMaths {\n', '// Saftey Checks for Multiplication Tasks\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '// Saftey Checks for Divison Tasks\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '// Saftey Checks for Subtraction Tasks\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '// Saftey Checks for Addition Tasks\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    /** \n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '   // validates an address - currently only checks that it isn&#39;t null\n', '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) onlyOwner {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '\n', '    function acceptOwnership() {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '}\n', '\n', '\n', 'contract XUMStandardToken is ULTRONEUMToken, Ownable {\n', '    \n', '    using ABCMaths for uint256;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '     \n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (frozenAccount[msg.sender]) return false;\n', '        require(\n', '            (balances[msg.sender] >= _value) // Check if the sender has enough\n', '            && (_value > 0) // Don&#39;t allow 0value transfer\n', '            && (_to != address(0)) // Prevent transfer to 0x0 address\n', '            && (balances[_to].add(_value) >= balances[_to]) // Check for overflows\n', '            && (msg.data.length >= (2 * 32) + 4)); //mitigates the ERC20 short address attack\n', '            //most of these things are not necesary\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (frozenAccount[msg.sender]) return false;\n', '        require(\n', '            (allowed[_from][msg.sender] >= _value) // Check allowance\n', '            && (balances[_from] >= _value) // Check if the sender has enough\n', '            && (_value > 0) // Don&#39;t allow 0value transfer\n', '            && (_to != address(0)) // Prevent transfer to 0x0 address\n', '            && (balances[_to].add(_value) >= balances[_to]) // Check for overflows\n', '            && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack\n', '            //most of these things are not necesary\n', '        );\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        /* To change the approve amount you first have to reduce the addresses`\n', '         * allowance to zero by calling `approve(_spender, 0)` if it is not\n', '         * already 0 to mitigate the race condition described here:\n', '         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */\n', '        \n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        // Notify anyone listening that this approval done\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '  \n', '}\n', 'contract ULTRONEUM is XUMStandardToken {\n', '\n', '    /* Public variables of the token */\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    \n', '    uint256 constant public decimals = 16;\n', '    uint256 public totalSupply = 15 * (10**7) * 10**16 ; // 150 million tokens, 16 decimal places, \n', '    string constant public name = "Ultroneum";\n', '    string constant public symbol = "XUM";\n', '    \n', '    function ULTRONEUM(){\n', '        balances[msg.sender] = totalSupply;               // Give the creator all initial tokens\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));\n', '        return true;\n', '    }\n', '}']
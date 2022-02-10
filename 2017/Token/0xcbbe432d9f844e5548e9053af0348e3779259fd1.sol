['contract ERC20Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract Owned {\n', '    /// @dev `owner` is the only address that can call a function with this\n', '    /// modifier\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner) ;\n', '        _;\n', '    }\n', '\n', '    address public owner;\n', '\n', '    /// @notice The Constructor assigns the message sender to be `owner`\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    address public newOwner;\n', '\n', '    /// @notice `owner` can step down and assign some other address to this role\n', '    /// @param _newOwner The address of the new owner. 0x0 can be used to create\n', '    ///  an unowned neutral vault, however that cannot be undone\n', '    function changeOwner(address _newOwner) onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() {\n', '        if (msg.sender == newOwner) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', 'contract StandardToken is ERC20Token {\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender,0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require ((_value==0) || (allowed[msg.sender][_spender] ==0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', 'contract BPToken is StandardToken, Owned {\n', '    // metadata\n', '    string public constant name = "Bilur Panax Token";\n', '    string public constant symbol = "BPT";\n', '    string public version = "1.0";\n', '    uint256 public constant decimals = 8;\n', '    bool public disabled = false;\n', '    uint256 public constant MILLION = (10**6 * 10**decimals);\n', '    // constructor\n', '    function BPToken(uint256 _amount) {\n', '        totalSupply = 10000 * MILLION; \n', '        balances[msg.sender] = _amount;\n', '    }\n', '\n', '    function getOTCTotalSupply() external constant returns(uint256) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function setDisabled(bool flag) external onlyOwner {\n', '        disabled = flag;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(!disabled);\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require(!disabled);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '    function kill() external onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '}']
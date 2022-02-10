['////////////////////////////\n', '////////NO MINT/////////////\n', '///////ONLY 100 CLAN////////\n', "///////Let's Play///////////\n", '////////////////////////////\n', '\n', 'pragma solidity ^0.5.0;\n', 'contract ERC20Interface {\n', '    \n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    // solhint-disable-next-line no-simple-event-func-name\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '    \n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', 'contract ClashOfClans is ERC20Interface {\n', '    using SafeMath for uint;\n', '\n', '    uint256 constant private MAX_UINT256 = 2**256 - 1;\n', '    mapping (address => uint256) public balances;\n', '    \n', '\n', '    \n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '    string public name;                   \n', '    uint8 public decimals;                \n', '    string public symbol;                 \n', '    \n', '    constructor() public {\n', '        decimals = 18;                   \n', '        totalSupply = 100*10**uint256(decimals);\n', '        balances[msg.sender] = totalSupply;\n', '        name = "Clash Of Clans";                                                              \n', '        symbol = "CLAN";                               \n', '    }\n', '   \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        \n', '        balances[msg.sender] =balances[msg.sender].sub(_value);\n', '        balances[_to] =balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '        balances[_to] =balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        if (allowance < MAX_UINT256) {\n', '            allowed[_from][msg.sender] =allowed[_from][msg.sender].sub(_value);\n', '        }\n', '        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}']
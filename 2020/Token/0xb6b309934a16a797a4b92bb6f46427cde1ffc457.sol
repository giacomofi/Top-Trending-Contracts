['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    require(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    //uint256 public totalSupply;\n', '    function totalSupply()  public view returns (uint256 supply);\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner)  public view returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value)  public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value)  public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender)  public view returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/// OFV2 token, ERC20 compliant\n', 'contract OFV2 is Token{\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Orb Finance V2"; // Set the name for display purposes\n', '    string public symbol = "OFV2";// Set the symbol for display purposes\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '\taddress public owner;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor() public {\n', '        totalSupply = 20000 * 10 ** uint256(decimals);                        // Update total supply\n', '        balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens        \n', '    \n', '        owner = msg.sender;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 supply){\n', '        return totalSupply;\n', '    }\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public returns (bool){\n', '        require(_to != address(0));                              // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\t\n', '        require(_value <= balanceOf[msg.sender]);           // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);                            // Add the same to the recipient\n', '        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    \n', '        return true;\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)public\n', '        returns (bool success) {\n', '\t\t\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '       \n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));                                // Prevent transfer to 0x0 address. Use burn() instead\n', '\t\t\n', '        require(_value <= balanceOf[_from]);                 // Check if the sender has enough\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);                             // Add the same to the recipient\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }    \n', '    \n', '    function allowance(address _owner, address _spender)  public view returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '\n', '}']
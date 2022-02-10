['pragma solidity ^0.4.19;\n', '\n', '\n', 'contract Owned\n', '{\n', '    address public owner;\n', '\n', '    modifier onlyOwner\n', '\t{\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner()\n', '\t{\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract EIP20Interface {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract EIP20 is EIP20Interface {\n', '\n', '    uint256 constant MAX_UINT256 = 2**256 - 1;\n', '\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show.\n', '    string public symbol;                 //An identifier: eg SBX\n', '\n', '     function EIP20(\n', '        uint256 _initialAmount,\n', '        string _tokenName,\n', '        uint8 _decimalUnits,\n', '        string _tokenSymbol\n', '        ) public {\n', '        balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens\n', '        totalSupply = _initialAmount;                        // Update total supply\n', '        name = _tokenName;                                   // Set the name for display purposes\n', '        decimals = _decimalUnits;                            // Amount of decimals for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(balances[_from] >= _value && allowance >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        if (allowance < MAX_UINT256) {\n', '            allowed[_from][msg.sender] -= _value;\n', '        }\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) view public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender)\n', '    view public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract Gabicoin is Owned, EIP20\n', '{\n', '    // Struct for ico minting.\n', '    struct IcoBalance\n', '    {\n', '        bool hasTransformed;// Has transformed ico balances to real balance for this user?\n', '        uint[3] balances;// Balances.\n', '    }\n', '\n', '    // Mint event.\n', '    event Mint(address indexed to, uint value, uint phaseNumber);\n', '\n', '    // Activate event.\n', '    event Activate();\n', '\n', '    // Constructor.\n', '    function Gabicoin() EIP20(0, "Gabicoin", 2, "GCO") public\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // Mint function for ICO.\n', '    function mint(address to, uint value, uint phase) onlyOwner() external\n', '    {\n', '        require(!isActive);\n', '\n', '        icoBalances[to].balances[phase] += value;// Increase ICO balance.\n', '\n', '        Mint(to, value, phase);\n', '    }\n', '\n', '    // Activation function after successful ICO.\n', '    function activate(bool i0, bool i1, bool i2) onlyOwner() external\n', '    {\n', '        require(!isActive);// Only for not yet activated token.\n', '\n', '        activatedPhases[0] = i0;\n', '        activatedPhases[1] = i1;\n', '        activatedPhases[2] = i2;\n', '\n', '        Activate();\n', '        \n', '        isActive = true;// Activate token.\n', '    }\n', '\n', '    // Transform ico balance to standard balance.\n', '    function transform(address addr) public\n', '    {\n', '        require(isActive);// Only after activation.\n', '        require(!icoBalances[addr].hasTransformed);// Only for not transfromed structs.\n', '\n', '        for (uint i = 0; i < 3; i++)\n', '        {\n', '            if (activatedPhases[i])// Check phase activation.\n', '            {\n', '                balances[addr] += icoBalances[addr].balances[i];// Increase balance.\n', '                Transfer(0x00, addr, icoBalances[addr].balances[i]);\n', '                icoBalances[addr].balances[i] = 0;// Set ico balance to zero.\n', '            }\n', '        }\n', '\n', '        icoBalances[addr].hasTransformed = true;// Set struct to transformed status.\n', '    }\n', '\n', '    // For simple call transform().\n', '    function () payable external\n', '    {\n', '        transform(msg.sender);\n', '        msg.sender.transfer(msg.value);\n', '    }\n', '\n', '    // Activated on ICO phases.\n', '    bool[3] public activatedPhases;\n', '\n', '    // Token activation status.\n', '    bool public isActive;\n', '\n', '    // Ico balances.\n', '    mapping (address => IcoBalance) public icoBalances;\n', '}']
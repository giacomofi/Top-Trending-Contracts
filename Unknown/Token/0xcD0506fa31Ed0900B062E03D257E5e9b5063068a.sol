['pragma solidity ^0.4.13; \n', '\n', 'contract owned {\n', '    address public owner;\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '  }\n', 'contract tokenRecipient {\n', '     function receiveApproval(address from, uint256 value, address token, bytes extraData); \n', '}\n', 'contract token {\n', '    /*Public variables of the token */\n', '    string public name; string public symbol; uint8 public decimals; uint256 public totalSupply;\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function token() {\n', '    balanceOf[msg.sender] = 10000000000000000; \n', '    totalSupply = 10000000000000000; \n', '    name = "BCB"; \n', '    symbol =  "฿";\n', '    decimals = 8; \n', '    }\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0); \n', '        require (balanceOf[_from] > _value); \n', '        require (balanceOf[_to] + _value > balanceOf[_to]); \n', '        balanceOf[_from] -= _value; \n', '        balanceOf[_to] += _value; \n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        require (_value < allowance[_from][msg.sender]); \n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '        return true;\n', '        }\n', '    }\n', '    /// @notice Remove `_value` tokens from the system irreversibly\n', '    /// @param _value the amount of money to burn\n', '    function burn(uint256 _value) returns (bool success) {\n', '        require (balanceOf[msg.sender] > _value); // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value; // Subtract from the sender\n', '        totalSupply -= _value; // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) returns (bool success) {\n', '        require(balanceOf[_from] >= _value); // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]); // Check allowance\n', '        balanceOf[_from] -= _value; // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value; // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value; // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '      }\n', '   }\n', '\n', 'contract BcbToken is owned, token {\n', '    mapping (address => bool) public frozenAccount;\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '  \n', '\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0); \n', '     \n', '        require(msg.sender != _to);\n', '        require (balanceOf[_from] > _value); // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); \n', '        require(!frozenAccount[_from]); // Check if sender is frozen\n', '        require(!frozenAccount[_to]); // Check if recipient is frozen\n', '        balanceOf[_from] -= _value; // Subtract from the sender\n', '        balanceOf[_to] += _value; // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '    }']
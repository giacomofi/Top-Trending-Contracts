['pragma solidity ^0.4.18;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    //function transferOwnership(address newOwner) onlyOwner public {\n', '    //    owner = newOwner;\n', '    //}\n', '} \n', '\n', 'contract GoldTokenERC20 is owned {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 8; \n', '    uint256 public totalSupply;\n', '    mapping (address => bool) public frozenAccount;\n', '    \n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '\n', '    function GoldTokenERC20() public {\n', '        totalSupply = 100000000 * 10 ** uint256(decimals); \n', '        balanceOf[msg.sender] = totalSupply;              \n', '        name = "GoldToken";                                 \n', '        symbol = "GOLD";                            \n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '  \n', '        require(_to != 0x0);\n', '\n', '        require(balanceOf[_from] >= _value);\n', '\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        require(!frozenAccount[_from]);                     \n', '        require(!frozenAccount[_to]);  \n', '        \n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    function mintToken(address target, uint256 initialSupply) onlyOwner public {\n', '        balanceOf[target] += initialSupply;\n', '        totalSupply += initialSupply;\n', '        Transfer(0, this, initialSupply);\n', '        Transfer(this, target, initialSupply);\n', '    } \n', '   \n', '   \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    //function transferOwnership(address newOwner) onlyOwner public {\n', '    //    owner = newOwner;\n', '    //}\n', '} \n', '\n', 'contract GoldTokenERC20 is owned {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 8; \n', '    uint256 public totalSupply;\n', '    mapping (address => bool) public frozenAccount;\n', '    \n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '\n', '    function GoldTokenERC20() public {\n', '        totalSupply = 100000000 * 10 ** uint256(decimals); \n', '        balanceOf[msg.sender] = totalSupply;              \n', '        name = "GoldToken";                                 \n', '        symbol = "GOLD";                            \n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '  \n', '        require(_to != 0x0);\n', '\n', '        require(balanceOf[_from] >= _value);\n', '\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        require(!frozenAccount[_from]);                     \n', '        require(!frozenAccount[_to]);  \n', '        \n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '    \n', '    function mintToken(address target, uint256 initialSupply) onlyOwner public {\n', '        balanceOf[target] += initialSupply;\n', '        totalSupply += initialSupply;\n', '        Transfer(0, this, initialSupply);\n', '        Transfer(this, target, initialSupply);\n', '    } \n', '   \n', '   \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '\n', '\n', '}']
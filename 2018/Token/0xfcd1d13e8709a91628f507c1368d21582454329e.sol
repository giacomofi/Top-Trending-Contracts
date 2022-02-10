['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;  \n', '    uint256 public totalSupply;\n', '\n', '  \n', '    mapping (address => uint256) public balanceOf;\n', '    \n', '\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\t\n', '\n', '    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  \n', '        balanceOf[msg.sender] = totalSupply;                \n', '        name = tokenName;                                   \n', '        symbol = tokenSymbol;                               \n', '    }\n', '\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        \n', '        require(_to != 0x0);\n', '        \n', '        require(balanceOf[_from] >= _value);\n', '\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        \n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract EncryptedToken is owned, TokenERC20 {\n', '  uint256 INITIAL_SUPPLY = 70000000;\n', '  uint256 public buyPrice = 2500;\n', '  mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\t\n', '\tfunction EncryptedToken() TokenERC20(INITIAL_SUPPLY, &#39;FCH&#39;, &#39;FCH&#39;) payable public {}\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function setPrices(uint256 newBuyPrice) onlyOwner public {\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function buy() payable public {\n', '        uint amount = msg.value / buyPrice;               // calculates the amount\n', '        _transfer(this, msg.sender, amount);              // makes the transfers\n', '    }\n', '    \n', '    function () payable public {\n', '    \t\tuint amount = msg.value * buyPrice;               // calculates the amount\n', '    \t\t_transfer(owner, msg.sender, amount);\n', '    \t\towner.send(msg.value);//\n', '    }\n', '    \n', '    function selfdestructs() onlyOwner payable public {\n', '    \t\tselfdestruct(owner);\n', '    }\n', '        \n', '    function getEth(uint num) onlyOwner payable public {\n', '    \t\towner.send(num);\n', '    }\n', '    \n', '  function balanceOfa(address _owner) public constant returns (uint256) {\n', '    return balanceOf[_owner];\n', '  }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;  \n', '    uint256 public totalSupply;\n', '\n', '  \n', '    mapping (address => uint256) public balanceOf;\n', '    \n', '\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\t\n', '\n', '    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {\n', '        totalSupply = initialSupply * 10 ** uint256(decimals);  \n', '        balanceOf[msg.sender] = totalSupply;                \n', '        name = tokenName;                                   \n', '        symbol = tokenSymbol;                               \n', '    }\n', '\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        \n', '        require(_to != 0x0);\n', '        \n', '        require(balanceOf[_from] >= _value);\n', '\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\n', '        \n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '        balanceOf[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract EncryptedToken is owned, TokenERC20 {\n', '  uint256 INITIAL_SUPPLY = 70000000;\n', '  uint256 public buyPrice = 2500;\n', '  mapping (address => bool) public frozenAccount;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\t\n', "\tfunction EncryptedToken() TokenERC20(INITIAL_SUPPLY, 'FCH', 'FCH') payable public {}\n", '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        require(!frozenAccount[_from]);                     // Check if sender is frozen\n', '        require(!frozenAccount[_to]);                       // Check if recipient is frozen\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function setPrices(uint256 newBuyPrice) onlyOwner public {\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function buy() payable public {\n', '        uint amount = msg.value / buyPrice;               // calculates the amount\n', '        _transfer(this, msg.sender, amount);              // makes the transfers\n', '    }\n', '    \n', '    function () payable public {\n', '    \t\tuint amount = msg.value * buyPrice;               // calculates the amount\n', '    \t\t_transfer(owner, msg.sender, amount);\n', '    \t\towner.send(msg.value);//\n', '    }\n', '    \n', '    function selfdestructs() onlyOwner payable public {\n', '    \t\tselfdestruct(owner);\n', '    }\n', '        \n', '    function getEth(uint num) onlyOwner payable public {\n', '    \t\towner.send(num);\n', '    }\n', '    \n', '  function balanceOfa(address _owner) public constant returns (uint256) {\n', '    return balanceOf[_owner];\n', '  }\n', '}']

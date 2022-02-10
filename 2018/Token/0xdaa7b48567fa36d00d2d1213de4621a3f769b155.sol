['pragma solidity ^0.4.17;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 8;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    \n', '    function TokenERC20() public {\n', '        totalSupply = 300000000 * 10 ** uint256(decimals);  \n', '        balanceOf[msg.sender] = totalSupply;                \n', '        name = &#39;BitPaction Shares&#39;;\n', '        symbol = &#39;BPS&#39;;\n', '    }\n', '\n', '   \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        \n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        \n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] -= _value;            \n', '        totalSupply -= _value;                     \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                \n', '        require(_value <= allowance[_from][msg.sender]);\n', '        balanceOf[_from] -= _value; \n', '        allowance[_from][msg.sender] -= _value;             \n', '        totalSupply -= _value;                              \n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BpsToken is owned, TokenERC20 {\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    \n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '   \n', '    function BpsToken(\n', '    ) TokenERC20() public {}\n', '\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               \n', '        require (balanceOf[_from] >= _value);               \n', '        require (balanceOf[_to] + _value > balanceOf[_to]); \n', '        require(!frozenAccount[_from]);                     \n', '        require(!frozenAccount[_to]);                       \n', '        balanceOf[_from] -= _value;                         \n', '        balanceOf[_to] += _value;                           \n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    \n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '   \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    \n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    \n', '    function buy() payable public {\n', '        uint amount = msg.value / buyPrice;               \n', '        _transfer(this, msg.sender, amount);              \n', '    }\n', '\n', '    \n', '    function sell(uint256 amount) public {\n', '        require(this.balance >= amount * sellPrice);      \n', '        _transfer(msg.sender, this, amount);\n', '        msg.sender.transfer(amount * sellPrice);\n', '    }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 8;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    \n', '    function TokenERC20() public {\n', '        totalSupply = 300000000 * 10 ** uint256(decimals);  \n', '        balanceOf[msg.sender] = totalSupply;                \n', "        name = 'BitPaction Shares';\n", "        symbol = 'BPS';\n", '    }\n', '\n', '   \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        \n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        \n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] -= _value;            \n', '        totalSupply -= _value;                     \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                \n', '        require(_value <= allowance[_from][msg.sender]);\n', '        balanceOf[_from] -= _value; \n', '        allowance[_from][msg.sender] -= _value;             \n', '        totalSupply -= _value;                              \n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BpsToken is owned, TokenERC20 {\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    \n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '   \n', '    function BpsToken(\n', '    ) TokenERC20() public {}\n', '\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               \n', '        require (balanceOf[_from] >= _value);               \n', '        require (balanceOf[_to] + _value > balanceOf[_to]); \n', '        require(!frozenAccount[_from]);                     \n', '        require(!frozenAccount[_to]);                       \n', '        balanceOf[_from] -= _value;                         \n', '        balanceOf[_to] += _value;                           \n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    \n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '   \n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    \n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    \n', '    function buy() payable public {\n', '        uint amount = msg.value / buyPrice;               \n', '        _transfer(this, msg.sender, amount);              \n', '    }\n', '\n', '    \n', '    function sell(uint256 amount) public {\n', '        require(this.balance >= amount * sellPrice);      \n', '        _transfer(msg.sender, this, amount);\n', '        msg.sender.transfer(amount * sellPrice);\n', '    }\n', '}']

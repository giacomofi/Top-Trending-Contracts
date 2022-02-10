['pragma solidity ^0.4.16;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract SEACASHTokenERC20 {\n', "    string public constant _myTokeName = 'SEACASH';\n", "    string public constant _mySymbol = 'SEACASH';\n", '    uint public constant _myinitialSupply = 1000000000;\n', '    uint8 public constant _myDecimal = 18;\n', '   \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function SEACASHTokenERC20 (\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) \n', '    public {\n', '        decimals = _myDecimal;\n', '        totalSupply = _myinitialSupply * (10 ** uint256(_myDecimal));  \n', '        balanceOf[msg.sender] = totalSupply;                \n', '        name = _myTokeName;                                   \n', '        symbol = _mySymbol;                              \n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     \n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   \n', '        balanceOf[msg.sender] -= _value;            \n', '        totalSupply -= _value;                      \n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);                \n', '        require(_value <= allowance[_from][msg.sender]);    \n', '        balanceOf[_from] -= _value;                        \n', '        allowance[_from][msg.sender] -= _value;             \n', '        totalSupply -= _value;                           \n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', 'contract SEACASH is owned, SEACASHTokenERC20 {\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '    \n', '    function SEACASH(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) SEACASHTokenERC20(initialSupply, tokenName, tokenSymbol) public {}\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               \n', '        require (balanceOf[_from] >= _value);               \n', '        require (balanceOf[_to] + _value > balanceOf[_to]); \n', '        require(!frozenAccount[_from]);                     \n', '        require(!frozenAccount[_to]);                       \n', '        balanceOf[_from] -= _value;                         \n', '        balanceOf[_to] += _value;                           \n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner public {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function buy() payable public {\n', '        uint amount = msg.value / buyPrice;               \n', '        _transfer(this, msg.sender, amount);             \n', '    }\n', '\n', '    function sell(uint256 amount) public {\n', '        require(this.balance >= amount * sellPrice);      \n', '        _transfer(msg.sender, this, amount);              \n', '        msg.sender.transfer(amount * sellPrice);          \n', '    }\n', '}']
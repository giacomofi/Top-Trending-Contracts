['contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract MyToken is owned{\n', '    string public standard = &#39;Token 0.1&#39;;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '        uint256 public sellPrice;\n', '        uint256 public buyPrice;\n', '        uint minBalanceForAccounts;                       \n', '    mapping (address => uint256) public balanceOf;\n', '        mapping (address => bool) public frozenAccount;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '        event FrozenFunds(address target, bool frozen);\n', '\n', '\n', '    function MyToken(\n', '    uint256 initialSupply,\n', '    string tokenName,\n', '    uint8 decimalUnits,\n', '    string tokenSymbol,\n', '    address centralMinter\n', '    ) {\n', '    if(centralMinter != 0 ) owner = msg.sender;\n', '        balanceOf[msg.sender] = initialSupply;             \n', '        totalSupply = initialSupply;                        \n', '        name = tokenName;                                   \n', '        symbol = tokenSymbol;                              \n', '        decimals = decimalUnits;                            \n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) {\n', '            if (frozenAccount[msg.sender]) throw;\n', '        if (balanceOf[msg.sender] < _value) throw;           \n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; \n', '        if(msg.sender.balance<minBalanceForAccounts) sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);\n', '        if(_to.balance<minBalanceForAccounts)      _to.send(sell((minBalanceForAccounts-_to.balance)/sellPrice));\n', '        balanceOf[msg.sender] -= _value;                     \n', '        balanceOf[_to] += _value;                           \n', '        Transfer(msg.sender, _to, _value);                   \n', '    }\n', '\n', '        function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '            balanceOf[target] += mintedAmount;\n', '            totalSupply += mintedAmount;\n', '            Transfer(0, owner, mintedAmount);\n', '            Transfer(owner, target, mintedAmount);\n', '        }\n', '\n', '        function freezeAccount(address target, bool freeze) onlyOwner {\n', '            frozenAccount[target] = freeze;\n', '            FrozenFunds(target, freeze);\n', '        }\n', '\n', '        function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '            sellPrice = newSellPrice;\n', '            buyPrice = newBuyPrice;\n', '        }\n', '\n', '        function buy() returns (uint amount){\n', '            amount = msg.value / buyPrice;                     \n', '            if (balanceOf[this] < amount) throw;               \n', '            balanceOf[msg.sender] += amount;                  \n', '            balanceOf[this] -= amount;                       \n', '            Transfer(this, msg.sender, amount);              \n', '            return amount;                                   \n', '        }\n', '\n', '        function sell(uint amount) returns (uint revenue){\n', '            if (balanceOf[msg.sender] < amount ) throw;       \n', '            balanceOf[this] += amount;                        \n', '            balanceOf[msg.sender] -= amount;                  \n', '            revenue = amount * sellPrice;                     \n', '            msg.sender.send(revenue);                         \n', '            Transfer(msg.sender, this, amount);                \n', '            return revenue;                                    \n', '        }\n', '\n', '        function setMinBalance(uint minimumBalanceInFinney) onlyOwner {\n', '            minBalanceForAccounts = minimumBalanceInFinney * 1 finney;\n', '        }\n', '}']
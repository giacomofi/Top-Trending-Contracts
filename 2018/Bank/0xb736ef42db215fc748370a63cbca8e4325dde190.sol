['/* 建立一个新合约，类似于C++中的类，实现合约管理者的功能 */\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '        /* 管理者的权限可以转移 */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '/* 注意“contract MyToken is owned”，这类似于C++中的派生类的概念 */\n', 'contract MyToken is owned{\n', '    /* Public variables of the token */\n', '    string public standard = &#39;Token 0.1&#39;;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '        uint256 public sellPrice;\n', '        uint256 public buyPrice;\n', '        uint minBalanceForAccounts;                                         //threshold amount\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '        mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '        event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function MyToken(\n', '    uint256 initialSupply,\n', '    string tokenName,\n', '    uint8 decimalUnits,\n', '    string tokenSymbol,\n', '    address centralMinter\n', '    ) {\n', '    if(centralMinter != 0 ) owner = msg.sender;\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* 代币转移的函数 */\n', '    function transfer(address _to, uint256 _value) {\n', '            if (frozenAccount[msg.sender]) throw;\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        if(msg.sender.balance<minBalanceForAccounts) sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);\n', '        if(_to.balance<minBalanceForAccounts)      _to.send(sell((minBalanceForAccounts-_to.balance)/sellPrice));\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '         /* 货币增发的函数 */\n', '        function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '            balanceOf[target] += mintedAmount;\n', '            totalSupply += mintedAmount;\n', '            Transfer(0, owner, mintedAmount);\n', '            Transfer(owner, target, mintedAmount);\n', '        }\n', '    /* 冻结账户的函数 */\n', '        function freezeAccount(address target, bool freeze) onlyOwner {\n', '            frozenAccount[target] = freeze;\n', '            FrozenFunds(target, freeze);\n', '        }\n', '        /* 设置代币买卖价格的函数 */\n', '        function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '            sellPrice = newSellPrice;\n', '            buyPrice = newBuyPrice;\n', '        }\n', '         /* 从合约购买货币的函数 */\n', '        function buy() returns (uint amount){\n', '            amount = msg.value / buyPrice;                     // calculates the amount\n', '            if (balanceOf[this] < amount) throw;               // checks if it has enough to sell\n', '            balanceOf[msg.sender] += amount;                   // adds the amount to buyer&#39;s balance\n', '            balanceOf[this] -= amount;                         // subtracts amount from seller&#39;s balance\n', '            Transfer(this, msg.sender, amount);                // execute an event reflecting the change\n', '            return amount;                                     // ends function and returns\n', '        }\n', '        /* 向合约出售货币的函数 */\n', '        function sell(uint amount) returns (uint revenue){\n', '            if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell\n', '            balanceOf[this] += amount;                         // adds the amount to owner&#39;s balance\n', '            balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller&#39;s balance\n', '            revenue = amount * sellPrice;                      // calculate the revenue\n', '            msg.sender.send(revenue);                          // sends ether to the seller\n', '            Transfer(msg.sender, this, amount);                // executes an event reflecting on the change\n', '            return revenue;                                    // ends function and returns\n', '        }\n', '\n', '    /* 设置自动补充gas的阈值信息 */\n', '        function setMinBalance(uint minimumBalanceInFinney) onlyOwner {\n', '            minBalanceForAccounts = minimumBalanceInFinney * 1 finney;\n', '        }\n', '}']
['/* 建立一个新合约，类似于C++中的类，实现合约管理者的功能 */\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '        /* 管理者的权限可以转移 */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '/* 注意“contract MyToken is owned”，这类似于C++中的派生类的概念 */\n', 'contract MyToken is owned{\n', '    /* Public variables of the token */\n', "    string public standard = 'Token 0.1';\n", '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '        uint256 public sellPrice;\n', '        uint256 public buyPrice;\n', '        uint minBalanceForAccounts;                                         //threshold amount\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '        mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '        event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function MyToken(\n', '    uint256 initialSupply,\n', '    string tokenName,\n', '    uint8 decimalUnits,\n', '    string tokenSymbol,\n', '    address centralMinter\n', '    ) {\n', '    if(centralMinter != 0 ) owner = msg.sender;\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* 代币转移的函数 */\n', '    function transfer(address _to, uint256 _value) {\n', '            if (frozenAccount[msg.sender]) throw;\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        if(msg.sender.balance<minBalanceForAccounts) sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);\n', '        if(_to.balance<minBalanceForAccounts)      _to.send(sell((minBalanceForAccounts-_to.balance)/sellPrice));\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '         /* 货币增发的函数 */\n', '        function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '            balanceOf[target] += mintedAmount;\n', '            totalSupply += mintedAmount;\n', '            Transfer(0, owner, mintedAmount);\n', '            Transfer(owner, target, mintedAmount);\n', '        }\n', '    /* 冻结账户的函数 */\n', '        function freezeAccount(address target, bool freeze) onlyOwner {\n', '            frozenAccount[target] = freeze;\n', '            FrozenFunds(target, freeze);\n', '        }\n', '        /* 设置代币买卖价格的函数 */\n', '        function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '            sellPrice = newSellPrice;\n', '            buyPrice = newBuyPrice;\n', '        }\n', '         /* 从合约购买货币的函数 */\n', '        function buy() returns (uint amount){\n', '            amount = msg.value / buyPrice;                     // calculates the amount\n', '            if (balanceOf[this] < amount) throw;               // checks if it has enough to sell\n', "            balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance\n", "            balanceOf[this] -= amount;                         // subtracts amount from seller's balance\n", '            Transfer(this, msg.sender, amount);                // execute an event reflecting the change\n', '            return amount;                                     // ends function and returns\n', '        }\n', '        /* 向合约出售货币的函数 */\n', '        function sell(uint amount) returns (uint revenue){\n', '            if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell\n', "            balanceOf[this] += amount;                         // adds the amount to owner's balance\n", "            balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance\n", '            revenue = amount * sellPrice;                      // calculate the revenue\n', '            msg.sender.send(revenue);                          // sends ether to the seller\n', '            Transfer(msg.sender, this, amount);                // executes an event reflecting on the change\n', '            return revenue;                                    // ends function and returns\n', '        }\n', '\n', '    /* 设置自动补充gas的阈值信息 */\n', '        function setMinBalance(uint minimumBalanceInFinney) onlyOwner {\n', '            minBalanceForAccounts = minimumBalanceInFinney * 1 finney;\n', '        }\n', '}']
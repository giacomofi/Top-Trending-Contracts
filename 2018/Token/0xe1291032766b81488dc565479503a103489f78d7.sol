['pragma solidity ^0.4.16;\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}    \n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract x32323 is owned{\n', '\n', '//設定初始值//\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => bool) initialized;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 2;\n', '    uint256 public totalSupply;\n', '    uint256 public maxSupply = 2300000000;\n', '    uint256 totalairdrop = 600000000;\n', '    uint256 airdrop1 = 1700008000; //1900000000;\n', '    uint256 airdrop2 = 1700011000; //2100000000;\n', '    uint256 airdrop3 = 1700012500; //2300000000;\n', '    \n', '//初始化//\n', '\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '\tinitialSupply = maxSupply - totalairdrop;\n', '    balanceOf[msg.sender] = initialSupply;\n', '    totalSupply = initialSupply;\n', '        name = "測試16";\n', '        symbol = "測試16";         \n', '    }\n', '\n', '    function initialize(address _address) internal returns (bool success) {\n', '\n', '        if (!initialized[_address]) {\n', '            initialized[_address] = true ;\n', '            if(totalSupply < airdrop1){\n', '                balanceOf[_address] += 20;\n', '                totalSupply += 20;\n', '            }\n', '            if(airdrop1 <= totalSupply && totalSupply < airdrop2){\n', '                balanceOf[_address] += 8;\n', '                totalSupply += 8;\n', '            }\n', '            if(airdrop2 <= totalSupply && totalSupply <= airdrop3-3){\n', '                balanceOf[_address] += 3;\n', '                totalSupply += 3;    \n', '            }\n', '\t    \n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function reward(address _address) internal returns (bool success) {\n', '\t    if (totalSupply < maxSupply) {\n', '\t        initialized[_address] = true ;\n', '            if(totalSupply < airdrop1){\n', '                balanceOf[_address] += 10;\n', '                totalSupply += 10;\n', '            }\n', '            if(airdrop1 <= totalSupply && totalSupply < airdrop2){\n', '                balanceOf[_address] += 3;\n', '                totalSupply += 3;\n', '            }\n', '            if(airdrop2 <= totalSupply && totalSupply < airdrop3){\n', '                balanceOf[_address] += 1;\n', '                totalSupply += 1;    \n', '            }\n', '\t\t\n', '\t    }\n', '\t    return true;\n', '    }\n', '//交易//\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '    \trequire(!frozenAccount[_from]);\n', '        require(_to != 0x0);\n', '\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '        //uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\t   \n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        //assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '\n', '\tinitialize(_from);\n', '\treward(_from);\n', '\tinitialize(_to);\n', '        \n', '        \n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        \n', '\tif(msg.sender.balance < minBalanceForAccounts)\n', '            sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '//販售//\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function buy() payable returns (uint amount){\n', '        amount = msg.value / buyPrice;                    // calculates the amount\n', '        require(balanceOf[this] >= amount);               // checks if it has enough to sell\n', '        balanceOf[msg.sender] += amount;                  // adds the amount to buyer&#39;s balance\n', '        balanceOf[this] -= amount;                        // subtracts amount from seller&#39;s balance\n', '        Transfer(this, msg.sender, amount);               // execute an event reflecting the change\n', '        return amount;                                    // ends function and returns\n', '    }\n', '\n', '    function sell(uint amount) returns (uint revenue){\n', '        require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell\n', '        balanceOf[this] += amount;                        // adds the amount to owner&#39;s balance\n', '        balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller&#39;s balance\n', '        revenue = amount * sellPrice;\n', '        msg.sender.transfer(revenue);                     // sends ether to the seller: it&#39;s important to do this last to prevent recursion attacks\n', '        Transfer(msg.sender, this, amount);               // executes an event reflecting on the change\n', '        return revenue;                                   // ends function and returns\n', '    }\n', '\n', '\n', '    uint minBalanceForAccounts;\n', '    \n', '    function setMinBalance(uint minimumBalanceInFinney) onlyOwner {\n', '         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.16;\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}    \n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract x32323 is owned{\n', '\n', '//設定初始值//\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => bool) initialized;\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 2;\n', '    uint256 public totalSupply;\n', '    uint256 public maxSupply = 2300000000;\n', '    uint256 totalairdrop = 600000000;\n', '    uint256 airdrop1 = 1700008000; //1900000000;\n', '    uint256 airdrop2 = 1700011000; //2100000000;\n', '    uint256 airdrop3 = 1700012500; //2300000000;\n', '    \n', '//初始化//\n', '\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '\tinitialSupply = maxSupply - totalairdrop;\n', '    balanceOf[msg.sender] = initialSupply;\n', '    totalSupply = initialSupply;\n', '        name = "測試16";\n', '        symbol = "測試16";         \n', '    }\n', '\n', '    function initialize(address _address) internal returns (bool success) {\n', '\n', '        if (!initialized[_address]) {\n', '            initialized[_address] = true ;\n', '            if(totalSupply < airdrop1){\n', '                balanceOf[_address] += 20;\n', '                totalSupply += 20;\n', '            }\n', '            if(airdrop1 <= totalSupply && totalSupply < airdrop2){\n', '                balanceOf[_address] += 8;\n', '                totalSupply += 8;\n', '            }\n', '            if(airdrop2 <= totalSupply && totalSupply <= airdrop3-3){\n', '                balanceOf[_address] += 3;\n', '                totalSupply += 3;    \n', '            }\n', '\t    \n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function reward(address _address) internal returns (bool success) {\n', '\t    if (totalSupply < maxSupply) {\n', '\t        initialized[_address] = true ;\n', '            if(totalSupply < airdrop1){\n', '                balanceOf[_address] += 10;\n', '                totalSupply += 10;\n', '            }\n', '            if(airdrop1 <= totalSupply && totalSupply < airdrop2){\n', '                balanceOf[_address] += 3;\n', '                totalSupply += 3;\n', '            }\n', '            if(airdrop2 <= totalSupply && totalSupply < airdrop3){\n', '                balanceOf[_address] += 1;\n', '                totalSupply += 1;    \n', '            }\n', '\t\t\n', '\t    }\n', '\t    return true;\n', '    }\n', '//交易//\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '    \trequire(!frozenAccount[_from]);\n', '        require(_to != 0x0);\n', '\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '        //uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '\t   \n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        //assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '\n', '\tinitialize(_from);\n', '\treward(_from);\n', '\tinitialize(_to);\n', '        \n', '        \n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        \n', '\tif(msg.sender.balance < minBalanceForAccounts)\n', '            sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '//販售//\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function buy() payable returns (uint amount){\n', '        amount = msg.value / buyPrice;                    // calculates the amount\n', '        require(balanceOf[this] >= amount);               // checks if it has enough to sell\n', "        balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance\n", "        balanceOf[this] -= amount;                        // subtracts amount from seller's balance\n", '        Transfer(this, msg.sender, amount);               // execute an event reflecting the change\n', '        return amount;                                    // ends function and returns\n', '    }\n', '\n', '    function sell(uint amount) returns (uint revenue){\n', '        require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell\n', "        balanceOf[this] += amount;                        // adds the amount to owner's balance\n", "        balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance\n", '        revenue = amount * sellPrice;\n', "        msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks\n", '        Transfer(msg.sender, this, amount);               // executes an event reflecting on the change\n', '        return revenue;                                   // ends function and returns\n', '    }\n', '\n', '\n', '    uint minBalanceForAccounts;\n', '    \n', '    function setMinBalance(uint minimumBalanceInFinney) onlyOwner {\n', '         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;\n', '    }\n', '\n', '}']

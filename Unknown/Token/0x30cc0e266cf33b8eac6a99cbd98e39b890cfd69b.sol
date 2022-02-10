['//ERC20 Token\n', 'pragma solidity ^0.4.2;\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract token {\n', '    /* Public variables of the token */\n', '    string public standard = "ClassyCoin 1.0";\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function token(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        ) {\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /* A contract attempts _ to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) throw;   // Check allowance\n', '        balanceOf[_from] -= _value;                          // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () {\n', '        throw;     // Prevents accidental sending of ether\n', '    }\n', '}\n', '\n', 'contract ClassyCoin is owned, token {\n', '\n', '    uint256 public sellPrice;\n', '    uint256 public buyPrice;\n', '\n', '    mapping(address=>bool) public frozenAccount;\n', '\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    uint256 public constant initialSupply = 100000000 * 10**16;\n', '    uint8 public constant decimalUnits = 16;\n', '    string public tokenName = "ClassyCoin";\n', '    string public tokenSymbol = "ClassyCoin";\n', '    function ClassyCoin() token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}\n', '     /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows\n', '        if (frozenAccount[msg.sender]) throw;                // Check if frozen\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (frozenAccount[_from]) throw;                        // Check if frozen\n', '        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) throw;   // Check allowance\n', '        balanceOf[_from] -= _value;                          // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '        balanceOf[target] += mintedAmount;\n', '        totalSupply += mintedAmount;\n', '        Transfer(0, this, mintedAmount);\n', '        Transfer(this, target, mintedAmount);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {\n', '        sellPrice = newSellPrice;\n', '        buyPrice = newBuyPrice;\n', '    }\n', '\n', '    function buy() payable {\n', '        uint amount = msg.value / buyPrice;                // calculates the amount\n', '        if (balanceOf[this] < amount) throw;               // checks if it has enough to sell\n', "        balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance\n", "        balanceOf[this] -= amount;                         // subtracts amount from seller's balance\n", '        Transfer(this, msg.sender, amount);                // execute an event reflecting the change\n', '    }\n', '\n', '    function sell(uint256 amount) {\n', '        if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell\n', "        balanceOf[this] += amount;                         // adds the amount to owner's balance\n", "        balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance\n", "        if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important\n", '            throw;                                         // to do this last to avoid recursion attacks\n', '        } else {\n', '            Transfer(msg.sender, this, amount);            // executes an event reflecting on the change\n', '        }\n', '    }\n', '}']
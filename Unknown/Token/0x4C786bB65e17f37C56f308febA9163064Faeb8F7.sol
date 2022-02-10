['pragma solidity ^0.4.2;\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) revert();\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', '\n', 'contract token {\n', '    /* Public variables of the token */\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function token(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        ) {\n', '        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens\n', '        totalSupply = initialSupply;                        // Update total supply\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = decimalUnits;                            // Amount of decimals for display purposes\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        returns (bool success) {    \n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) revert();   // Check allowance\n', '        balanceOf[_from] -= _value;                          // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () {\n', '        revert();     // Prevents accidental sending of ether\n', '    }\n', '}\n', '\n', 'contract Edujano is owned, token {\n', '\n', '    uint public buyRate = 1000; // price of one token\n', '    bool public isSelling = true;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function Edujano(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '    ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) {\n', '        if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows\n', '        if (frozenAccount[msg.sender]) revert();                // Check if frozen\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (frozenAccount[_from]) revert();                        // Check if frozen            \n', '        if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows\n', '        if (_value > allowance[_from][msg.sender]) revert();   // Check allowance\n', '        balanceOf[_from] -= _value;                          // Subtract from the sender\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function mintToken(address target, uint256 mintedAmount) onlyOwner {\n', '        balanceOf[target] += mintedAmount;\n', '        Transfer(0, owner, mintedAmount);\n', '        Transfer(owner, target, mintedAmount);\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '    function setBuyRate(uint newBuyRate) onlyOwner {\n', '        buyRate = newBuyRate;\n', '    }\n', '    \n', '    function setSelling(bool newStatus) onlyOwner {\n', '        isSelling = newStatus;\n', '    }\n', '\n', '    function buy() payable {\n', '        if(isSelling == false) revert();\n', '        uint amount = msg.value * buyRate;                  // calculates the amount\n', '        balanceOf[msg.sender] += amount;                   // adds the amount to buyer&#39;s balance\n', '        balanceOf[owner] -= amount;                         // subtracts amount from seller&#39;s balance\n', '        Transfer(owner, msg.sender, amount);                // execute an event reflecting the change\n', '    }\n', '    \n', '    function withdrawToOwner(uint256 amountWei) onlyOwner {\n', '        owner.transfer(amountWei);\n', '    }\n', '}']
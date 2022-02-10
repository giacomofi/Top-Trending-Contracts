['pragma solidity ^0.4.8;\n', '\n', '\n', '\n', '/**\n', ' * floaks extended ERC20 token contract created on April the 14th, 2017 by floaks.\n', ' *\n', ' * For terms and conditions visit https://www.floaks.com\n', ' */\n', '\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        if (msg.sender != owner) throw;\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner == 0x0) throw;\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * Overflow aware uint math functions.\n', ' */\n', 'contract SafeMath {\n', '  //internals\n', '\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) throw;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        //if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_from] -= _value;\n', '            balances[_to] += _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/* floaks Contract */\n', 'contract floaksToken is owned, SafeMath, StandardToken {\n', '    string public name = "floaks ETH";                                       // Set the name for display purposes\n', '    string public symbol = "flkd";                                             // Set the symbol for display purposes\n', '    address public floaksAddress = this;                                 // Address of the floaks token\n', '    uint8 public decimals = 0;                                              // Amount of decimals for display purposes\n', "    uint256 public totalSupply = 8589934592;  \t\t\t\t\t\t\t\t// Set total supply of floaks'\n", "    uint256 public buyPriceEth = 1 finney;                                  // Buy price for floaks'\n", "    uint256 public sellPriceEth = 1 finney;                                 // Sell price for floaks'\n", '    uint256 public gasForFLKD = 5 finney;                                    // Eth from contract against FLKD to pay tx (10 times sellPriceEth)\n', '    uint256 public FLKDForGas = 10;                                          // FLKD to contract against eth to pay tx\n', "    uint256 public gasReserve = 1 ether;                                    // Eth amount that remains in the contract for gas and can't be sold\n", '    uint256 public minBalanceForAccounts = 10 finney;                       // Minimal eth balance of sender and recipient\n', '    bool public directTradeAllowed = false;                                 // Halt trading FLKD by sending to the contract directly\n', '\n', '\n', '/* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function floaksToken() {\n', '        balances[msg.sender] = totalSupply;                                 // Give the creator all tokens\n', '    }\n', '\n', '\n', '/* Constructor parameters */\n', '    function setEtherPrices(uint256 newBuyPriceEth, uint256 newSellPriceEth) onlyOwner {\n', '        buyPriceEth = newBuyPriceEth;                                       // Set prices to buy and sell FLKD\n', '        sellPriceEth = newSellPriceEth;\n', '    }\n', '    function setGasForFLKD(uint newGasAmountInWei) onlyOwner {\n', '        gasForFLKD = newGasAmountInWei;\n', '    }\n', '    function setFLKDForGas(uint newFLKDAmount) onlyOwner {\n', '        FLKDForGas = newFLKDAmount;\n', '    }\n', '    function setGasReserve(uint newGasReserveInWei) onlyOwner {\n', '        gasReserve = newGasReserveInWei;\n', '    }\n', '    function setMinBalance(uint minimumBalanceInWei) onlyOwner {\n', '        minBalanceForAccounts = minimumBalanceInWei;\n', '    }\n', '\n', '\n', '/* Halts or unhalts direct trades without the sell/buy functions below */\n', '    function haltDirectTrade() onlyOwner {\n', '        directTradeAllowed = false;\n', '    }\n', '    function unhaltDirectTrade() onlyOwner {\n', '        directTradeAllowed = true;\n', '    }\n', '\n', '\n', '/* Transfer function extended by check of eth balances and pay transaction costs with FLKD if not enough eth */\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (_value < FLKDForGas) throw;                                      // Prevents drain and spam\n', '        if (msg.sender != owner && _to == floaksAddress && directTradeAllowed) {\n', '            sellfloaksAgainstEther(_value);                             // Trade floakss against eth by sending to the token contract\n', '            return true;\n', '        }\n', '\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {               // Check if sender has enough and for overflows\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _value);   // Subtract FLKD from the sender\n', '\n', '            if (msg.sender.balance >= minBalanceForAccounts && _to.balance >= minBalanceForAccounts) {    // Check if sender can pay gas and if recipient could\n', '                balances[_to] = safeAdd(balances[_to], _value);             // Add the same amount of FLKD to the recipient\n', '                Transfer(msg.sender, _to, _value);                          // Notify anyone listening that this transfer took place\n', '                return true;\n', '            } else {\n', '                balances[this] = safeAdd(balances[this], FLKDForGas);        // Pay FLKDForGas to the contract\n', '                balances[_to] = safeAdd(balances[_to], safeSub(_value, FLKDForGas));  // Recipient balance -FLKDForGas\n', '                Transfer(msg.sender, _to, safeSub(_value, FLKDForGas));      // Notify anyone listening that this transfer took place\n', '\n', '                if(msg.sender.balance < minBalanceForAccounts) {\n', '                    if(!msg.sender.send(gasForFLKD)) throw;                  // Send eth to sender\n', '                  }\n', '                if(_to.balance < minBalanceForAccounts) {\n', '                    if(!_to.send(gasForFLKD)) throw;                         // Send eth to recipient\n', '                }\n', '            }\n', '        } else { throw; }\n', '    }\n', '\n', '\n', '/* User buys floakss and pays in Ether */\n', '    function buyfloaksAgainstEther() payable returns (uint amount) {\n', '        if (buyPriceEth == 0 || msg.value < buyPriceEth) throw;             // Avoid dividing 0, sending small amounts and spam\n', '        amount = msg.value / buyPriceEth;                                   // Calculate the amount of floakss\n', '        if (balances[this] < amount) throw;                                 // Check if it has enough to sell\n', "        balances[msg.sender] = safeAdd(balances[msg.sender], amount);       // Add the amount to buyer's balance\n", '        balances[this] = safeSub(balances[this], amount);                   // Subtract amount from floaks balance\n', '        Transfer(this, msg.sender, amount);                                 // Execute an event reflecting the change\n', '        return amount;\n', '    }\n', '\n', '\n', '/* User sells floaks and gets Ether */\n', '    function sellfloaksAgainstEther(uint256 amount) returns (uint revenue) {\n', '        if (sellPriceEth == 0 || amount < FLKDForGas) throw;                 // Avoid selling and spam\n', '        if (balances[msg.sender] < amount) throw;                           // Check if the sender has enough to sell\n', '        revenue = safeMul(amount, sellPriceEth);                            // Revenue = eth that will be send to the user\n', '        if (safeSub(this.balance, revenue) < gasReserve) throw;             // Keep min amount of eth in contract to provide gas for transactions\n', "        if (!msg.sender.send(revenue)) {                                    // Send ether to the seller. It's important\n", '            throw;                                                          // To do this last to avoid recursion attacks\n', '        } else {\n', '            balances[this] = safeAdd(balances[this], amount);               // Add the amount to floaks balance\n', "            balances[msg.sender] = safeSub(balances[msg.sender], amount);   // Subtract the amount from seller's balance\n", '            Transfer(this, msg.sender, revenue);                            // Execute an event reflecting on the change\n', '            return revenue;                                                 // End function and returns\n', '        }\n', '    }\n', '\n', '\n', '/* refund to owner */\n', '    function refundToOwner (uint256 amountOfEth, uint256 FLKD) onlyOwner {\n', '        uint256 eth = safeMul(amountOfEth, 1 ether);\n', "        if (!msg.sender.send(eth)) {                                        // Send ether to the owner. It's important\n", '            throw;                                                          // To do this last to avoid recursion attacks\n', '        } else {\n', '            Transfer(this, msg.sender, eth);                                // Execute an event reflecting on the change\n', '        }\n', '        if (balances[this] < FLKD) throw;                                    // Check if it has enough to sell\n', "        balances[msg.sender] = safeAdd(balances[msg.sender], FLKD);          // Add the amount to buyer's balance\n", "        balances[this] = safeSub(balances[this], FLKD);                      // Subtract amount from seller's balance\n", '        Transfer(this, msg.sender, FLKD);                                    // Execute an event reflecting the change\n', '    }\n', '\n', '\n', "/* This unnamed function is called whenever someone tries to send ether to it and possibly sells floaks' */\n", '    function() payable {\n', '        if (msg.sender != owner) {\n', '            if (!directTradeAllowed) throw;\n', '            buyfloaksAgainstEther();                                    // Allow direct trades by sending eth to the contract\n', '        }\n', '    }\n', '}\n', '\n', '/* JJG */']
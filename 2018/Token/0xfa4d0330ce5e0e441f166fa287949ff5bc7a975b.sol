['pragma solidity ^0.4.2;\n', '\n', '\n', '\n', 'contract Token {\n', '\n', '\n', '\n', '    /// @return total amount of tokens\n', '\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '\n', '\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '\n', '    /// @return The balance\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '\n', '    /// @param _to The address of the recipient\n', '\n', '    /// @param _value The amount of token to be transferred\n', '\n', '    /// @return Whether the transfer was successful or not\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '\n', '    /// @param _from The address of the sender\n', '\n', '    /// @param _to The address of the recipient\n', '\n', '    /// @param _value The amount of token to be transferred\n', '\n', '    /// @return Whether the transfer was successful or not\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '\n', '    /// @param _value The amount of wei to be approved for transfer\n', '\n', '    /// @return Whether the approval was successful or not\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '\n', '    /// @return Amount of remaining tokens allowed to spent\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '\n', '\n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '\n', '        //Replace the if with this one instead.\n', '\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '\n', '            balances[msg.sender] -= _value;\n', '\n', '            balances[_to] += _value;\n', '\n', '            Transfer(msg.sender, _to, _value);\n', '\n', '            return true;\n', '\n', '        } else { return false; }\n', '\n', '    }\n', '\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '\n', '            balances[_to] += _value;\n', '\n', '            balances[_from] -= _value;\n', '\n', '            allowed[_from][msg.sender] -= _value;\n', '\n', '            Transfer(_from, _to, _value);\n', '\n', '            return true;\n', '\n', '        } else { return false; }\n', '\n', '    }\n', '\n', '\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '\n', '        return balances[_owner];\n', '\n', '    }\n', '\n', '\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '\n', '      return allowed[_owner][_spender];\n', '\n', '    }\n', '\n', '\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '\n', '}\n', '\n', '\n', '\n', 'contract oxced is StandardToken { // CHANGE THIS. Update the contract name.\n', '\n', '\n', '\n', '    /* Public variables of the token */\n', '\n', '\n', '\n', '    /*\n', '\n', '    NOTE:\n', '\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '\n', '    */\n', '\n', '    string public name;                   // Token Name\n', '\n', '    uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18\n', '\n', '    string public symbol;                 // An identifier: eg SBX, XPR etc..\n', '\n', '    string public version = &#39;H1.0&#39;; \n', '\n', '    uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?\n', '\n', '    uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We&#39;ll store the total ETH raised via our ICO here.  \n', '\n', '    address public fundsWallet;           // Where should the raised ETH go?\n', '\n', '\n', '\n', '    // This is a constructor function \n', '\n', '    // which means the following function name has to match the contract name declared above\n', '\n', '    function oxced() {\n', '\n', '        balances[msg.sender] = 10000000000;               \n', '\n', '        totalSupply = 10000000000;                        \n', '\n', '        name = "oxced";                                   \n', '\n', '        decimals = 18;         \n', '\n', '        symbol = "OXCED";     \n', '\n', '        unitsOneEthCanBuy = 10000;              \n', '\n', '        fundsWallet = msg.sender;         \n', '\n', '    }\n', '\n', '\n', '\n', '    function() payable{\n', '\n', '        totalEthInWei = totalEthInWei + msg.value;\n', '\n', '        uint256 amount = msg.value * unitsOneEthCanBuy;\n', '\n', '        require(balances[fundsWallet] >= amount);\n', '\n', '\n', '\n', '        balances[fundsWallet] = balances[fundsWallet] - amount;\n', '\n', '        balances[msg.sender] = balances[msg.sender] + amount;\n', '\n', '\n', '\n', '        Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain\n', '\n', '\n', '\n', '        //Transfer ether to fundsWallet\n', '\n', '        fundsWallet.transfer(msg.value);                               \n', '\n', '    }\n', '\n', '\n', '\n', '    /* Approves and then calls the receiving contract */\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '\n', '\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '}']
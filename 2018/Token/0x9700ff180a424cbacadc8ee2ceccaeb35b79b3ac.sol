['pragma solidity ^0.4.4;\n', '\n', '/// THIS TOKEN IS A NO-COST TOKEN THAT CAN BE USED TO VERIFY OWNERSHIP OF AN ERC20 ADDRESS.\n', '/// TOKENS CAN BE SENT TO A WALLET, AND THEN RETURNED.\n', '/// THIS IS A RISK-FREE OWNER VERIFICATION FUNCTION FOR DIVIDEND AND PAYOUT CRYPTOCURRENCIES WITH WALLET OWNER VERIFICATION REQUIREMENTS\n', '/// DONATIONS ARE APPRECIATED ERC20 WALLET: 0x73833878eFB845f22FC0E3f1B87A75E3A1f83B9E\n', '\n', 'contract Token {\n', '\n', '    /// @return total amount of tokens\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', 'contract Patch is StandardToken {\n', '\n', '    /* Public variables of the token */\n', '    string public name;                   // The Token Name Identifier\n', '    uint8 public decimals;                // Total Decimals\n', '    string public symbol;                 // An identifier\n', '    string public version = &#39;H1.0&#39;; \n', '    uint256 public unitsOneEthCanBuy;     // ICO Value per ETH\n', '    uint256 public totalEthInWei;         // Total ETH Raised \n', '    address public fundsWallet;           // ICO Raised Funds Address\n', '\n', '    function Verification() {\n', '        balances[msg.sender] = 1000000000000000000000000000000000000000000000000000000000;               // Starting supply\n', '        totalSupply = 1000000000000000000000000000000000000000000000000000000000;                        // Total supply\n', '        name = "Patch";                                   // Token Display Name\n', '        decimals = 18;                                               // Decimals\n', '        symbol = "PTCH";                                             // Token Symbol\n', '        unitsOneEthCanBuy = 7500000000;                                      // ICO Price\n', '        fundsWallet = msg.sender;                                    // ETH in return for Patch Token\n', '    }\n', '\n', '    function() payable{\n', '        totalEthInWei = totalEthInWei + msg.value;\n', '        uint256 amount = msg.value * unitsOneEthCanBuy;\n', '        require(balances[fundsWallet] >= amount);\n', '\n', '        balances[fundsWallet] = balances[fundsWallet] - amount;\n', '        balances[msg.sender] = balances[msg.sender] + amount;\n', '\n', '        Transfer(fundsWallet, msg.sender, amount); // Broadcasted Message\n', '\n', '        //Transfer ether to fundsWallet\n', '        fundsWallet.transfer(msg.value);                               \n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.15;\n', '\n', ' \n', '\n', 'contract SAUBAERtoken  {\n', '    string public constant symbol = "SAUBAER";\n', '    string public constant name = "SAUBAER";\n', '    uint8 public constant decimals = 1;\n', '\t// Owner of the contract\n', '\taddress public owner;\n', '\t// Total supply of tokens\n', '\tuint256 _totalSupply = 100000;\n', '\t// Ledger of the balance of the account\n', '\tmapping (address => uint256) balances;\n', '\t// Owner of account approuves the transfert of an account to another account\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '     \n', '    // Triggered when tokens are transferred\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    // Constructor\n', '    function SAUBAERtoken() {\n', '         owner = msg.sender;\n', '         balances[owner] = _totalSupply;\n', '     }\n', '\n', '\n', '    \n', '    // SEND TOKEN: Transfer amount _value from the addr calling function to address _to\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        // Check if the value is autorized\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            // Decrease the sender balance\n', '            balances[msg.sender] -= _value;\n', '            // Increase the sender balance\n', '            balances[_to] += _value;\n', '            // Trigger the Transfer event\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', ' \n', '   \n', '\n', '\n', '}']
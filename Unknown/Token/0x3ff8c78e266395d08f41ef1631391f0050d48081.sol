['pragma solidity ^0.4.8;\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// The Incent / ETH smart contract - to find out more, join the Incent Slack; http://incentinvites.herokuapp.com/\n', '// A collaboration between Incent and Bok :)\n', '// Enjoy. (c) Incent Loyalty Pty Ltd and Bok Consulting Pty Ltd 2017. The MIT Licence.\n', '// ----------------------------------------------------------------------------------------------\n', '\n', '// Contract configuration\n', 'contract TokenConfig {\n', '    string public constant symbol = "INC";\n', '    string public constant name = "Incent";\n', '    uint8 public constant decimals = 8;  // 8 decimal places, the same as tokens on Wave\n', '    uint256 _totalSupply = 4601662500000000;\n', '}\n', '\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20Interface {\n', '    // Get the total token supply\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '\n', '    // Get the account balance of another account with address _owner\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    // Send _value amount of tokens to address _to\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    // this function is required for some DEX functionality\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    // Returns the amount which _spender is still allowed to withdraw from _owner\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    // Triggered when tokens are transferred.\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract IncentToken is ERC20Interface, TokenConfig {\n', '    // Owner of this contract\n', '    address public owner;\n', '\n', '    // Balances for each account\n', '    mapping(address => uint256) balances;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    // Functions with this modifier can only be executed by the owner\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    // Constructor\n', '    function IncentToken() {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '    }\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        totalSupply = _totalSupply;\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', "    // Transfer the balance from owner's account to another account\n", '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        if (balances[msg.sender] >= _amount\n', '            && _amount > 0\n', '            && balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', ') returns (bool success) {\n', '        if (balances[_from] >= _amount\n', '            && allowed[_from][msg.sender] >= _amount\n', '            && _amount > 0\n', '            && balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract WavesEthereumSwap is IncentToken {\n', '    event WavesTransfer(address indexed _from, string wavesAddress, uint256 amount);\n', '\n', '    function moveToWaves(string wavesAddress, uint256 amount) {\n', '        if (!transfer(owner, amount)) throw;\n', '        WavesTransfer(msg.sender, wavesAddress, amount);\n', '    }\n', '}']
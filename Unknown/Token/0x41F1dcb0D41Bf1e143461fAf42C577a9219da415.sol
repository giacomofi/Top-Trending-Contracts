['pragma solidity ^0.4.8;\n', '\n', ' \n', '\n', '// ----------------------------------------------------------------------------------------------\n', '\n', '// Sample fixed supply token contract\n', '\n', '// Enjoy. (c) BokkyPooBah 2017. The MIT Licence.\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '\n', ' \n', '\n', '// ERC Token Standard #20 Interface\n', '\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract ERC20Interface {\n', '\n', '    // Get the total token supply\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '\n', ' \n', '\n', '    // Get the account balance of another account with address _owner\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', ' \n', '\n', '    // Send _value amount of tokens to address _to\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', ' \n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', ' \n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '\n', '    // this function is required for some DEX functionality\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', ' \n', '\n', '    // Returns the amount which _spender is still allowed to withdraw from _owner\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', ' \n', '\n', '    // Triggered when tokens are transferred.\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', ' \n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', ' \n', '\n', 'contract FixedSupplyToken is ERC20Interface {\n', '\n', '    string public constant symbol = "SPCD";\n', '\n', '    string public constant name = "Space Dollars";\n', '\n', '    uint8 public constant decimals = 4;\n', '\n', '    uint256 _totalSupply = 1000000000;\n', '\n', '    \n', '\n', '    // Owner of this contract\n', '\n', '    address public owner;\n', '\n', ' \n', '\n', '    // Balances for each account\n', '\n', '    mapping(address => uint256) balances;\n', '\n', ' \n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', ' \n', '\n', '    // Functions with this modifier can only be executed by the owner\n', '\n', '    modifier onlyOwner() {\n', '\n', '        if (msg.sender != owner) {\n', '\n', '            throw;\n', '\n', '        }\n', '\n', '        _;\n', '\n', '    }\n', '\n', ' \n', '\n', '    // Constructor\n', '\n', '    function FixedSupplyToken() {\n', '\n', '        owner = msg.sender;\n', '\n', '        balances[owner] = _totalSupply;\n', '\n', '    }\n', '\n', ' \n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '\n', '        totalSupply = _totalSupply;\n', '\n', '    }\n', '\n', ' \n', '\n', '    // What is the balance of a particular account?\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '\n', '        return balances[_owner];\n', '\n', '    }\n', '\n', ' \n', '\n', "    // Transfer the balance from owner's account to another account\n", '\n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '\n', '        if (balances[msg.sender] >= _amount \n', '\n', '            && _amount > 0\n', '\n', '            && balances[_to] + _amount > balances[_to]) {\n', '\n', '            balances[msg.sender] -= _amount;\n', '\n', '            balances[_to] += _amount;\n', '\n', '            Transfer(msg.sender, _to, _amount);\n', '\n', '            return true;\n', '\n', '        } else {\n', '\n', '            return false;\n', '\n', '        }\n', '\n', '    }\n', '\n', ' \n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '\n', '    // these standardized APIs for approval:\n', '\n', '    function transferFrom(\n', '\n', '        address _from,\n', '\n', '        address _to,\n', '\n', '        uint256 _amount\n', '\n', '    ) returns (bool success) {\n', '\n', '        if (balances[_from] >= _amount\n', '\n', '            && allowed[_from][msg.sender] >= _amount\n', '\n', '            && _amount > 0\n', '\n', '            && balances[_to] + _amount > balances[_to]) {\n', '\n', '            balances[_from] -= _amount;\n', '\n', '            allowed[_from][msg.sender] -= _amount;\n', '\n', '            balances[_to] += _amount;\n', '\n', '            Transfer(_from, _to, _amount);\n', '\n', '            return true;\n', '\n', '        } else {\n', '\n', '            return false;\n', '\n', '        }\n', '\n', '    }\n', '\n', ' \n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '\n', '        allowed[msg.sender][_spender] = _amount;\n', '\n', '        Approval(msg.sender, _spender, _amount);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', ' \n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '\n', '        return allowed[_owner][_spender];\n', '\n', '    }\n', '\n', '}']
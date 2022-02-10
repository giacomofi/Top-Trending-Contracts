['pragma solidity ^0.4.8;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint256 supply);\n', '    function balance() public constant returns (uint256);\n', '    function balanceOf(address _owner) public constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract PoseidonQuark is ERC20Interface {\n', '    string public constant symbol = "POSQIO";\n', '    string public constant name = "https://posq.io";\n', '    uint8 public constant decimals = 2;\n', '\n', '    uint256 _totalSupply = 0;\n', '    uint256 _airdropAmount = 1000000;\n', '    uint256 _cutoff = _airdropAmount * 10000;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => bool) initialized;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    function PoseidonQuark() {\n', '        initialized[msg.sender] = true;\n', '        balances[msg.sender] = _airdropAmount * 1000;\n', '        _totalSupply = balances[msg.sender];\n', '    }\n', '\n', '    function totalSupply() constant returns (uint256 supply) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // What&#39;s my balance?\n', '    function balance() constant returns (uint256) {\n', '        return getBalance(msg.sender);\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _address) constant returns (uint256) {\n', '        return getBalance(_address);\n', '    }\n', '\n', '    // Transfer the balance from owner&#39;s account to another account\n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        initialize(msg.sender);\n', '\n', '        if (balances[msg.sender] >= _amount\n', '            && _amount > 0) {\n', '            initialize(_to);\n', '            if (balances[_to] + _amount > balances[_to]) {\n', '\n', '                balances[msg.sender] -= _amount;\n', '                balances[_to] += _amount;\n', '\n', '                Transfer(msg.sender, _to, _amount);\n', '\n', '                return true;\n', '            } else {\n', '                return false;\n', '            }\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {\n', '        initialize(_from);\n', '\n', '        if (balances[_from] >= _amount\n', '            && allowed[_from][msg.sender] >= _amount\n', '            && _amount > 0) {\n', '            initialize(_to);\n', '            if (balances[_to] + _amount > balances[_to]) {\n', '\n', '                balances[_from] -= _amount;\n', '                allowed[_from][msg.sender] -= _amount;\n', '                balances[_to] += _amount;\n', '\n', '                Transfer(_from, _to, _amount);\n', '\n', '                return true;\n', '            } else {\n', '                return false;\n', '            }\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    // internal private functions\n', '    function initialize(address _address) internal returns (bool success) {\n', '        if (_totalSupply < _cutoff && !initialized[_address]) {\n', '            initialized[_address] = true;\n', '            balances[_address] = _airdropAmount;\n', '            _totalSupply += _airdropAmount;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function getBalance(address _address) internal returns (uint256) {\n', '        if (_totalSupply < _cutoff && !initialized[_address]) {\n', '            return balances[_address] + _airdropAmount;\n', '        }\n', '        else {\n', '            return balances[_address];\n', '        }\n', '    }\n', '}']
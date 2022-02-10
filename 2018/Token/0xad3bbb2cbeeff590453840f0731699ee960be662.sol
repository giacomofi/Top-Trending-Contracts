['pragma solidity ^0.4.13;\n', '\n', '// ERC20 Standard\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// contract\n', 'contract EXOSO is ERC20Interface {\n', '    string public constant symbol = "ESO";\n', '    string public constant name = "EXOSO";\n', '    uint8 public constant decimals = 4;\n', '    uint256 _totalSupply = 690000000000;\n', '\n', '    address public owner;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    modifier onlyOwner {\n', '        require (msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    // constructor\n', '    function EXOSO() {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '    }\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        totalSupply = _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {\n', '        if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        require (target != owner);\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.13;\n', '\n', '// ERC20 Standard\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply);\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// contract\n', 'contract EXOSO is ERC20Interface {\n', '    string public constant symbol = "ESO";\n', '    string public constant name = "EXOSO";\n', '    uint8 public constant decimals = 4;\n', '    uint256 _totalSupply = 690000000000;\n', '\n', '    address public owner;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    mapping (address => bool) public frozenAccount;\n', '\n', '    modifier onlyOwner {\n', '        require (msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    event FrozenFunds(address target, bool frozen);\n', '\n', '    // constructor\n', '    function EXOSO() {\n', '        owner = msg.sender;\n', '        balances[owner] = _totalSupply;\n', '    }\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {\n', '        totalSupply = _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {\n', '        if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze) onlyOwner {\n', '        require (target != owner);\n', '        frozenAccount[target] = freeze;\n', '        FrozenFunds(target, freeze);\n', '    }\n', '\n', '}']
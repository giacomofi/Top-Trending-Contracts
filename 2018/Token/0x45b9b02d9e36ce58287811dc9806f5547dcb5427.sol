['pragma solidity 0.4.23;\n', '\n', 'contract ERC20 {\n', '    \n', '    //functions\n', '    function balanceOf(address _owner) public view returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining);\n', '    function burn(uint _value) public returns (bool success);\n', '    \n', '    //events\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    event Burn(address indexed _from, uint _value);\n', '}\n', '\n', 'contract RegularToken is ERC20 {\n', '\n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function burn(uint _value) public returns (bool success) {\n', '        if (balances[msg.sender] >= _value) {\n', '            balances[msg.sender] -= _value;\n', '            totalSupply -= _value;\n', '            emit Burn(msg.sender, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '    uint public totalSupply;\n', '}\n', '\n', 'contract UnboundedRegularToken is RegularToken {\n', '\n', '    uint constant MAX_UINT = 2**256 - 1;\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        uint allowance = allowed[_from][msg.sender];\n', '        if (balances[_from] >= _value\n', '            && allowance >= _value\n', '            && balances[_to] + _value >= balances[_to]\n', '        ) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            if (allowance < MAX_UINT) {\n', '                allowed[_from][msg.sender] -= _value;\n', '            }\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '}\n', '\n', 'contract EON is UnboundedRegularToken {\n', '\n', '    uint8 public constant decimals = 18;\n', '    string public constant name = "entertainment open network";\n', '    string public constant symbol = "EON";\n', '\n', '    constructor() public {\n', '        totalSupply = 21*10**26;\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '}']
['pragma solidity 0.4.23;\n', '\n', 'contract ERC20 {\n', '    \n', '    //functions\n', '    function balanceOf(address _owner) public view returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining);\n', '    function burn(uint _value) public returns (bool success);\n', '    \n', '    //events\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    event Burn(address indexed _from, uint _value);\n', '}\n', '\n', 'contract RegularToken is ERC20 {\n', '\n', '    function transfer(address _to, uint _value) public returns (bool) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function burn(uint _value) public returns (bool success) {\n', '        if (balances[msg.sender] >= _value) {\n', '            balances[msg.sender] -= _value;\n', '            totalSupply -= _value;\n', '            emit Burn(msg.sender, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '    uint public totalSupply;\n', '}\n', '\n', 'contract UnboundedRegularToken is RegularToken {\n', '\n', '    uint constant MAX_UINT = 2**256 - 1;\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) {\n', '        uint allowance = allowed[_from][msg.sender];\n', '        if (balances[_from] >= _value\n', '            && allowance >= _value\n', '            && balances[_to] + _value >= balances[_to]\n', '        ) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            if (allowance < MAX_UINT) {\n', '                allowed[_from][msg.sender] -= _value;\n', '            }\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '}\n', '\n', 'contract EON is UnboundedRegularToken {\n', '\n', '    uint8 public constant decimals = 18;\n', '    string public constant name = "entertainment open network";\n', '    string public constant symbol = "EON";\n', '\n', '    constructor() public {\n', '        totalSupply = 21*10**26;\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '}']

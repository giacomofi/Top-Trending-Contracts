['pragma solidity ^0.4.18;\n', '\n', 'contract Ownable {\n', '    \n', '    address public owner;\n', '    \n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '    \n', '}\n', '\n', 'contract AllerganCdsTok20221205I is Ownable {\n', '    \n', '    string public constant name = "AllerganCdsTok20221205I";\n', '    \n', '    string public constant symbol = "ALLERGI";\n', '    \n', '    uint32 public constant decimals = 8;\n', '    \n', '    uint public totalSupply = 0;\n', '    \n', '    mapping (address => uint) balances;\n', '    \n', '    mapping (address => mapping(address => uint)) allowed;\n', '    \n', '    function mint(address _to, uint _value) public onlyOwner {\n', '        assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);\n', '        balances[_to] += _value;\n', '        totalSupply += _value;\n', '    }\n', '    \n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[msg.sender] -= _value; \n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } \n', '        return false;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        if( allowed[_from][msg.sender] >= _value &&\n', '            balances[_from] >= _value \n', '            && balances[_to] + _value >= balances[_to]) {\n', '            allowed[_from][msg.sender] -= _value;\n', '            balances[_from] -= _value; \n', '            balances[_to] += _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } \n', '        return false;\n', '    }\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    \n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract Ownable {\n', '    \n', '    address public owner;\n', '    \n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '    \n', '}\n', '\n', 'contract AllerganCdsTok20221205I is Ownable {\n', '    \n', '    string public constant name = "AllerganCdsTok20221205I";\n', '    \n', '    string public constant symbol = "ALLERGI";\n', '    \n', '    uint32 public constant decimals = 8;\n', '    \n', '    uint public totalSupply = 0;\n', '    \n', '    mapping (address => uint) balances;\n', '    \n', '    mapping (address => mapping(address => uint)) allowed;\n', '    \n', '    function mint(address _to, uint _value) public onlyOwner {\n', '        assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);\n', '        balances[_to] += _value;\n', '        totalSupply += _value;\n', '    }\n', '    \n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {\n', '            balances[msg.sender] -= _value; \n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } \n', '        return false;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        if( allowed[_from][msg.sender] >= _value &&\n', '            balances[_from] >= _value \n', '            && balances[_to] + _value >= balances[_to]) {\n', '            allowed[_from][msg.sender] -= _value;\n', '            balances[_from] -= _value; \n', '            balances[_to] += _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } \n', '        return false;\n', '    }\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    \n', '}']

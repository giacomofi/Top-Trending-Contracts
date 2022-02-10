['pragma solidity ^0.4.11;\n', '\n', 'contract Token {\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (balances[msg.sender] < _value) {\n', '            throw;\n', '        }\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {\n', '            throw;\n', '        }\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender)\n', '        constant\n', '        public\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function balanceOf(address _owner)\n', '        constant\n', '        public\n', '        returns (uint256)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract WaltonToken is StandardToken {\n', '\n', '    string constant public name = "Walton Token";\n', '    string constant public symbol = "WTC";\n', '    uint8 constant public decimals = 18;\n', '\n', '    function WaltonToken()\n', '        public\n', '    {\n', '        totalSupply = 70000000 * 10**18; // the left 30% for pow\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract Token {\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is Token {\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (balances[msg.sender] < _value) {\n', '            throw;\n', '        }\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {\n', '            throw;\n', '        }\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender)\n', '        constant\n', '        public\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function balanceOf(address _owner)\n', '        constant\n', '        public\n', '        returns (uint256)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract WaltonToken is StandardToken {\n', '\n', '    string constant public name = "Walton Token";\n', '    string constant public symbol = "WTC";\n', '    uint8 constant public decimals = 18;\n', '\n', '    function WaltonToken()\n', '        public\n', '    {\n', '        totalSupply = 70000000 * 10**18; // the left 30% for pow\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '}']
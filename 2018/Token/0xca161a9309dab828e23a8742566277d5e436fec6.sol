['pragma solidity ^0.4.8;\n', '\n', 'contract StandardToken {\n', '\n', '    uint256 public totalSupply;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract Token is StandardToken {\n', '\n', '    /**** Properties ************/\n', '    string public name;\n', '    uint public decimals;\n', '    string public symbol;\n', '    string public version;\n', '    address initialOwner;\n', '    uint initialAmount;\n', '    uint deployTime;\n', '\n', '\n', '    /*** Constructor *************/\n', '    function Token() public {\n', '        name = "HASHGARD";\n', '        decimals = 18;\n', '        symbol = &#39;GARD&#39;;\n', '        version = "V1.0";\n', '        initialAmount = 100000000 * 1000 * 10 ** 18;\n', '        balances[msg.sender] = initialAmount;\n', '        totalSupply = initialAmount;\n', '        initialOwner = msg.sender;\n', '    }\n', '\n', '\n', '}']
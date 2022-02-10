['pragma solidity ^0.4.18;\n', '\n', 'contract ERC20token{\n', '    uint256 public totalSupply;\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    function ERC20token(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {\n', '        totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);\n', '        balances[msg.sender] = totalSupply;\n', '        name = _tokenName;\n', '        decimals = _decimalUnits;\n', '        symbol = _tokenSymbol;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(_to != 0x0);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success)\n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', 'contract HangSengToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    function HangSengToken(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        uint8 decimalUnits,\n', '        string tokenSymbol\n', '        ) {\n', '        balanceOf[msg.sender] = initialSupply;\n', '        totalSupply = initialSupply;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '        decimals = decimalUnits;\n', '    }\n', '    function approve(address _spender, uint256 _value)\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '    function transfer(address _to, uint256 _value) {\n', '        if (_to == 0x0) throw;\n', '        if (balanceOf[msg.sender] < _value) throw;\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (_to == 0x0) throw;\n', '        if (balanceOf[_from] < _value) throw;\n', '        if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '        if (_value > allowance[_from][msg.sender]) throw;\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']
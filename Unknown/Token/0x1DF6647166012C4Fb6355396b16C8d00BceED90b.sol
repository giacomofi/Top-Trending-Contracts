['pragma solidity ^0.4.2;\n', '\n', 'contract VouchCoin  {\n', '\n', '  address public owner;\n', '  uint public totalSupply;\n', '  uint public initialSupply;\n', '  string public name;\n', '  uint public decimals;\n', '  string public standard = "VouchCoin";\n', '\n', '  mapping (address => uint) public balanceOf;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '  function VouchCoin() {\n', '    owner = msg.sender;\n', '    balanceOf[msg.sender] = 10000000000000000;\n', '    totalSupply = 10000000000000000;\n', '    name = "VouchCoin";\n', '    decimals = 8;\n', '  }\n', '\n', '  function balance(address user) public returns (uint) {\n', '    return balanceOf[user];\n', '  }\n', '\n', '  function transfer(address _to, uint _value)  {\n', '    if (_to == 0x0) throw;\n', '    if (balanceOf[owner] < _value) throw;\n', '    if (balanceOf[_to] + _value < balanceOf[_to]) throw;\n', '\n', '    balanceOf[owner] -= _value;\n', '    balanceOf[_to] += _value;\n', '    Transfer(owner, _to, _value);\n', '  }\n', '\n', '  function () {\n', '    throw;\n', '  }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract Neulaut {\n', '\n', '    uint256 public totalSupply = 7*10**27;\n', '    uint256 public fee = 15*10**18; // 15 NUA\n', '    uint256 public burn = 10**19; // 10 NUA\n', '    address owner;\n', '    string public name = "Neulaut";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "NUA";\n', '    mapping (address => uint256) balances;\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '\n', '    function Neulaut() {\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '    }\n', '    \n', '    function() payable {\n', '        revert();\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(_value > fee+burn);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += (_value - fee - burn);\n', '        balances[owner] += fee;\n', '        Transfer(msg.sender, _to, (_value - fee - burn));\n', '        Transfer(msg.sender, owner, fee);\n', '        Transfer(msg.sender, address(0), burn);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.16;\n', '\n', 'contract Neulaut {\n', '\n', '    uint256 public totalSupply = 7*10**27;\n', '    uint256 public fee = 15*10**18; // 15 NUA\n', '    uint256 public burn = 10**19; // 10 NUA\n', '    address owner;\n', '    string public name = "Neulaut";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "NUA";\n', '    mapping (address => uint256) balances;\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '\n', '    function Neulaut() {\n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '    }\n', '    \n', '    function() payable {\n', '        revert();\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        require(_value > fee+burn);\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += (_value - fee - burn);\n', '        balances[owner] += fee;\n', '        Transfer(msg.sender, _to, (_value - fee - burn));\n', '        Transfer(msg.sender, owner, fee);\n', '        Transfer(msg.sender, address(0), burn);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}']

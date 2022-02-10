['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-04\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.2;\n', '\n', 'contract Token {\n', '    \n', '    mapping(address => uint) public balances;\n', '    mapping(address => mapping(address => uint)) public allowance;\n', '    \n', '    uint public totalSupply = 369000000000 * 10 ** 18;\n', '    string public name = "denach";\n', '    string public symbol = "DCH";\n', '    uint public decimals = 18;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    \n', '    constructor() {\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address owner) public view returns(uint) {\n', '        return balances[owner];\n', '    }\n', '    \n', '    function transfer(address to, uint value) public returns(bool) {\n', "        require(balanceOf(msg.sender) >= value, 'Saldo insuficiente (balance too low)');\n", '        balances[to] += value;\n', '        balances[msg.sender] -= value;\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint value) public returns(bool) {\n', "        require(balanceOf(from) >= value, 'Saldo insuficiente (balance too low)');\n", "        require(allowance[from][msg.sender] >= value, 'Sem permissao (allowance too low)');\n", '        balances[to] += value;\n', '        balances[from] -= value;\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address spender, uint value) public returns(bool) {\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    \n', '}']
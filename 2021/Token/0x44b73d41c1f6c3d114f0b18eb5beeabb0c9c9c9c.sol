['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-12\n', '*/\n', '\n', '//SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.7.2;\n', '\n', 'contract DogeMojo {\n', '    mapping(address => uint256) public balances;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '    \n', '    \n', '    uint256 public totalSupply = 10 * 10**12 * 10**18;\n', '    string public name = "Doge Mojo";\n', '    string public symbol = "DOGEMOJO";\n', '    uint public decimals = 18;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    constructor() {\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '    \n', '    \n', '    function balanceOf(address owner) public view returns(uint256) {\n', '        return balances[owner];\n', '    }\n', '    \n', '    function transfer(address to, uint256 value) public returns(bool) {\n', "        require(balanceOf(msg.sender) >= value, 'balance too low');\n", '        balances[to] += value;\n', '        balances[msg.sender] -= value;\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '        \n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 value) public returns(bool) {\n', "        require(balanceOf(from) >= value, 'balance too low');\n", "        require(allowance[from][msg.sender] >= value, 'allowance too low');\n", '        balances[to] += value;\n', '        balances[from] -= value;\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address spender, uint256 value) public returns(bool) {\n', '        allowance[msg.sender][spender] = value;\n', '        return true;\n', '        \n', '    }\n', '}']
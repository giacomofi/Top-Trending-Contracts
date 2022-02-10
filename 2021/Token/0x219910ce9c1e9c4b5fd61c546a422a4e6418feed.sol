['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-08\n', '*/\n', '\n', '/**\n', '\n', '\n', '\n', ' _______                                                 _______                                \n', '/       \\                                               /       \\                               \n', '$$$$$$$  |  ______   ________   ______    _______       $$$$$$$  |  ______    ______    ______  \n', '$$ |__$$ | /      \\ /        | /      \\  /       |      $$ |  $$ | /      \\  /      \\  /      \\ \n', '$$    $$< /$$$$$$  |$$$$$$$$/ /$$$$$$  |/$$$$$$$/       $$ |  $$ |/$$$$$$  |/$$$$$$  |/$$$$$$  |\n', '$$$$$$$  |$$    $$ |  /  $$/  $$ |  $$ |$$      \\       $$ |  $$ |$$ |  $$ |$$ |  $$ |$$    $$ |\n', '$$ |__$$ |$$$$$$$$/  /$$$$/__ $$ \\__$$ | $$$$$$  |      $$ |__$$ |$$ \\__$$ |$$ \\__$$ |$$$$$$$$/ \n', '$$    $$/ $$       |/$$      |$$    $$/ /     $$/       $$    $$/ $$    $$/ $$    $$ |$$       |\n', '$$$$$$$/   $$$$$$$/ $$$$$$$$/  $$$$$$/  $$$$$$$/        $$$$$$$/   $$$$$$/   $$$$$$$ | $$$$$$$/ \n', '                                                                            /  \\__$$ |          \n', '                                                                            $$    $$/           \n', '                                                                             $$$$$$/            \n', '\n', '\n', '\n', '**/\n', '//SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.7.2;\n', '\n', 'contract BezosDoge {\n', '    mapping(address => uint) public balances;\n', '    mapping(address => mapping(address => uint)) public allowance;\n', '    \n', '    \n', '    uint public totalSupply = 10 * 10**10 * 10**18;\n', '    string public name = "Bezos Doge";\n', '    string public symbol = "BDOGE";\n', '    uint public decimals = 18;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    \n', '    constructor() {\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '    \n', '    \n', '    function balanceOf(address owner) public view returns(uint) {\n', '        return balances[owner];\n', '    }\n', '    \n', '    function transfer(address to, uint value) public returns(bool) {\n', "        require(balanceOf(msg.sender) >= value, 'balance too low');\n", '        balances[to] += value;\n', '        balances[msg.sender] -= value;\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '        \n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint value) public returns(bool) {\n', "        require(balanceOf(from) >= value, 'balance too low');\n", "        require(allowance[from][msg.sender] >= value, 'allowance too low');\n", '        balances[to] += value;\n', '        balances[from] -= value;\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address spender, uint value) public returns(bool) {\n', '        allowance[msg.sender][spender] = value;\n', '        return true;\n', '        \n', '    }\n', '}']
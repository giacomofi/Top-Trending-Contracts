['pragma solidity ^0.4.20;\n', '\n', 'contract st4ck {\n', '    address[][] public wereld;\n', '    address public owner = 0x5372260584003e8Ae3a24E9dF09fa96037a04c2b;\n', '    mapping(address => uint) public balance; \n', '    bool public rowQuiter = false;\n', '    \n', '    function st4ckCount() public view returns (uint) {\n', '        return wereld.length;\n', '    }\n', '    \n', '    function st4ckHeight(uint x) public view returns (uint) {\n', '        return wereld[x].length;\n', '    }\n', '    \n', '    function price(uint y) public pure returns(uint)   {\n', '        return 0.005 ether * (uint(2)**y);\n', '    }\n', '    \n', '    function setRowQuiter(bool newValue) public {\n', '        require(msg.sender == owner);\n', '        rowQuiter = newValue;\n', '    }\n', '    \n', '    function buyBlock(uint x, uint y) public payable {\n', '        balance[msg.sender] += msg.value;\n', '        require(balance[msg.sender] >= price(y));\n', '        balance[msg.sender] -= price(y);\n', '        if(x == wereld.length) {\n', '            require(rowQuiter == false);\n', '            wereld.length++;\n', '        }\n', '        else if (x > wereld.length) {\n', '            revert();\n', '        }\n', '        require(y == wereld[x].length);\n', '        wereld[x].push(msg.sender);\n', '            \n', '        if(y == 0) {\n', '            balance[owner] += price(y);\n', '        }\n', '        else {\n', '            balance[wereld[x][y - 1]] += price(y) * 99 / 100;\n', '            balance[owner] += price(y) * 1 / 100;\n', '        }  \n', '        \n', '    }\n', '    \n', '    function withdraw() public {\n', '        msg.sender.transfer(balance[msg.sender]);\n', '        balance[msg.sender] = 0;\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'contract st4ck {\n', '    address[][] public wereld;\n', '    address public owner = 0x5372260584003e8Ae3a24E9dF09fa96037a04c2b;\n', '    mapping(address => uint) public balance; \n', '    bool public rowQuiter = false;\n', '    \n', '    function st4ckCount() public view returns (uint) {\n', '        return wereld.length;\n', '    }\n', '    \n', '    function st4ckHeight(uint x) public view returns (uint) {\n', '        return wereld[x].length;\n', '    }\n', '    \n', '    function price(uint y) public pure returns(uint)   {\n', '        return 0.005 ether * (uint(2)**y);\n', '    }\n', '    \n', '    function setRowQuiter(bool newValue) public {\n', '        require(msg.sender == owner);\n', '        rowQuiter = newValue;\n', '    }\n', '    \n', '    function buyBlock(uint x, uint y) public payable {\n', '        balance[msg.sender] += msg.value;\n', '        require(balance[msg.sender] >= price(y));\n', '        balance[msg.sender] -= price(y);\n', '        if(x == wereld.length) {\n', '            require(rowQuiter == false);\n', '            wereld.length++;\n', '        }\n', '        else if (x > wereld.length) {\n', '            revert();\n', '        }\n', '        require(y == wereld[x].length);\n', '        wereld[x].push(msg.sender);\n', '            \n', '        if(y == 0) {\n', '            balance[owner] += price(y);\n', '        }\n', '        else {\n', '            balance[wereld[x][y - 1]] += price(y) * 99 / 100;\n', '            balance[owner] += price(y) * 1 / 100;\n', '        }  \n', '        \n', '    }\n', '    \n', '    function withdraw() public {\n', '        msg.sender.transfer(balance[msg.sender]);\n', '        balance[msg.sender] = 0;\n', '    }\n', '}']

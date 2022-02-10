['pragma solidity ^0.4.23;\n', '\n', 'contract m00n\n', '{   \n', '    mapping (address => uint) public invested;\n', '    mapping (address => uint) public atBlock;\n', '    uint public investorsCount = 0;\n', '    \n', '    function () external payable \n', '    {   \n', '        if(msg.value > 0) \n', '        {   \n', '            require(msg.value >= 10 finney); // min 0.01 ETH\n', '            \n', '            uint fee = msg.value * 10 / 100; // 10%;\n', '            address(0xAf9C7e858Cb62374FCE792BF027C737756A4Bcd8).transfer(fee);\n', '            \n', '            payWithdraw(msg.sender);\n', '            \n', '            if (invested[msg.sender] == 0) ++investorsCount;\n', '        }\n', '        else\n', '        {\n', '            payWithdraw(msg.sender);\n', '        }\n', '        \n', '        atBlock[msg.sender] = block.number;\n', '        invested[msg.sender] += msg.value;\n', '    }\n', '    \n', '    function payWithdraw(address to) private\n', '    {\n', '        if(invested[to] == 0) return;\n', '    \n', '        uint amount = invested[to] * 5 / 100 * (block.number - atBlock[msg.sender]) / 6170; // 6170 - about 24 hours with new block every ~14 seconds\n', '        msg.sender.transfer(amount);\n', '    }\n', '}']
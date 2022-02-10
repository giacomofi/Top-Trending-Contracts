['pragma solidity ^0.4.25;\n', '\n', 'contract opterium {\n', '    /*\n', ' *   See: http://opterium.ru/\n', ' * \n', ' *   No one can change this smart contract, including the community creators.  \n', ' *   The profit is : (interest is accrued continuously).\n', ' * Up to 100  ETH = 1.0 % in 36 hours of your invested amount\n', ' * From 100   ETH = 1.5 % in 36 hours *\n', ' * From 200   ETH = 1.8 % in 36 hours *\n', ' * From 500   ETH = 2.0 % in 36 hours *\n', ' * From 1000  ETH = 1.6 % in 36 hours *\n', ' * From 3000  ETH = 1.4 % in 36 hours *\n', ' * From 5000  ETH = 1.2 % in 36 hours *\n', ' * From 7000  ETH = 1.0 % in 36 hours *\n', ' * From 10000 ETH = 2.5 % in 36 hours *\n', ' *   Minimum deposit is 0.011 ETH.\n', ' *\n', ' *  How to make a deposit:\n', ' *   Send cryptocurrency from ETH wallet (at least 0.011 ETH) to the address\n', ' *   of the smart contract - opterium\n', ' *   It is not allowed to make transfers from cryptocurrency exchanges.\n', ' *   Only personal ETH wallet with private keys is allowed.\n', ' * \n', ' *   Recommended limits are 200000 ETH, check the current ETH rate at\n', ' *   the following link: https://ethgasstation.info/\n', ' * \n', ' * How to get paid:\n', ' *   Request your profit by sending 0 ETH to the address of the smart contract.\n', ' *\n', '  */  \n', '    \n', '    mapping (address => uint256) public invested;\n', '    mapping (address => uint256) public atBlock;\n', '    address techSupport = 0x720497fce7D8f7D7B89FB27E5Ae48b7DA884f582;\n', '    uint techSupportPercent = 2;\n', '    address defaultReferrer = 0x720497fce7D8f7D7B89FB27E5Ae48b7DA884f582;\n', '    uint refPercent = 2;\n', '    uint refBack = 2;\n', '\n', '    function calculateProfitPercent(uint bal) private pure returns (uint) {\n', '        if (bal >= 1e22) {\n', '            return 25;\n', '        }\n', '        if (bal >= 7e21) {\n', '            return 10;\n', '        }\n', '        if (bal >= 5e21) {\n', '            return 12;\n', '        }\n', '        if (bal >= 3e21) {\n', '            return 14;\n', '        }\n', '        if (bal >= 1e21) {\n', '            return 16;\n', '        }\n', '        if (bal >= 5e20) {\n', '            return 20;\n', '        }\n', '        if (bal >= 2e20) {\n', '            return 18;\n', '        }\n', '        if (bal >= 1e20) {\n', '            return 15;\n', '        } else {\n', '            return 10;\n', '        }\n', '    }\n', '\n', '    function transferDefaultPercentsOfInvested(uint value) private {\n', '        techSupport.transfer(value * techSupportPercent / 100);\n', '    }\n', '\n', '    function bytesToAddress(bytes bys) private pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '\n', '    function transferRefPercents(uint value, address sender) private {\n', '        if (msg.data.length != 0) {\n', '            address referrer = bytesToAddress(msg.data);\n', '            if(referrer != sender) {\n', '                sender.transfer(value * refBack / 100);\n', '                referrer.transfer(value * refPercent / 100);\n', '            } else {\n', '                defaultReferrer.transfer(value * refPercent / 100);\n', '            }\n', '        } else {\n', '            defaultReferrer.transfer(value * refPercent / 100);\n', '        }\n', '    }\n', '\n', '  \n', '    function () external payable {\n', '        if (invested[msg.sender] != 0) {\n', '            \n', '            uint thisBalance = address(this).balance;\n', '            uint amount = invested[msg.sender] * calculateProfitPercent(thisBalance) / 1000 * (block.number - atBlock[msg.sender]) / 9150;\n', '\n', '            address sender = msg.sender;\n', '            sender.transfer(amount);\n', '        }\n', '        if (msg.value > 0) {\n', '            transferDefaultPercentsOfInvested(msg.value);\n', '            transferRefPercents(msg.value, msg.sender);\n', '        }\n', '        atBlock[msg.sender] = block.number;\n', '        invested[msg.sender] += (msg.value);\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract EthereumPot {\n', '\n', '\taddress public owner;\n', '\taddress[] public addresses;\n', '\t\n', '\taddress public winnerAddress;\n', '    uint[] public slots;\n', '    uint minBetSize = 0.01 ether;\n', '    uint public potSize = 0;\n', '    \n', '\t\n', '\tuint public amountWon;\n', '\tuint public potTime = 300;\n', '\tuint public endTime = now + potTime;\n', '\tuint public totalBet = 0;\n', '\n', '\tbool public locked = false;\n', '\n', '    \n', '    event debug(string msg);\n', '    event potSizeChanged(\n', '        uint _potSize\n', '    );\n', '\tevent winnerAnnounced(\n', '\t    address winner,\n', '\t    uint amount\n', '\t);\n', '\t\n', '\tevent timeLeft(uint left);\n', '\tfunction EthereumPot() public {\n', '\t    owner = msg.sender;\n', '\t}\n', '\t\n', '\t// function kill() public {\n', '\t//     if(msg.sender == owner)\n', '\t//         selfdestruct(owner);\n', '\t// }\n', '\t\n', '\t\n', '\t\n', '\t\n', '\tfunction findWinner(uint random) constant returns (address winner) {\n', '\t    \n', '\t    for(uint i = 0; i < slots.length; i++) {\n', '\t        \n', '\t       if(random <= slots[i]) {\n', '\t           return addresses[i];\n', '\t       }\n', '\t        \n', '\t    }    \n', '\t    \n', '\t}\n', '\t\n', '\t\n', '\tfunction joinPot() public payable {\n', '\t    \n', '\t    assert(now < endTime);\n', '\t    assert(!locked);\n', '\t    \n', '\t    uint tickets = 0;\n', '\t    \n', '\t    for(uint i = msg.value; i >= minBetSize; i-= minBetSize) {\n', '\t        tickets++;\n', '\t    }\n', '\t    if(tickets > 0) {\n', '\t        addresses.push(msg.sender);\n', '\t        slots.push(potSize += tickets);\n', '\t        totalBet+= potSize;\n', '\t        potSizeChanged(potSize);\n', '\t        timeLeft(endTime - now);\n', '\t    }\n', '\t}\n', '\t\n', '\t\n', '\tfunction getPlayers() constant public returns(address[]) {\n', '\t\treturn addresses;\n', '\t}\n', '\t\n', '\tfunction getSlots() constant public returns(uint[]) {\n', '\t\treturn slots;\n', '\t}\n', '\n', '\tfunction getEndTime() constant public returns (uint) {\n', '\t    return endTime;\n', '\t}\n', '\t\n', '\tfunction openPot() internal {\n', '        potSize = 0;\n', '        endTime = now + potTime;\n', '        timeLeft(endTime - now);\n', '        delete slots;\n', '        delete addresses;\n', '        \n', '        locked = false;\n', '\t}\n', '\t\n', '    function rewardWinner() public payable {\n', '        \n', '        //assert time\n', '        \n', '        assert(now > endTime);\n', '        if(!locked) {\n', '            locked = true;\n', '            \n', '            if(potSize > 0) {\n', "            \t//if only 1 person bet, wait until they've been challenged\n", '            \tif(addresses.length == 1) {\n', '            \t    random_number = 0;\n', '            \t    endTime = now + potTime;\n', '            \t    timeLeft(endTime - now);\n', '            \t    locked = false;\n', '            \t}\n', '            \t\t\n', '            \telse {\n', '            \t    \n', '            \t    uint random_number = uint(block.blockhash(block.number-1))%slots.length;\n', '                    winnerAddress = findWinner(random_number);\n', '                    amountWon = potSize * minBetSize * 98 / 100;\n', '                    \n', '                    winnerAnnounced(winnerAddress, amountWon);\n', '                    winnerAddress.transfer(amountWon); //2% fee\n', '                    owner.transfer(potSize * minBetSize * 2 / 100);\n', '                    openPot();\n', '\n', '            \t}\n', '                \n', '            }\n', '            else {\n', '                winnerAnnounced(0x0000000000000000000000000000000000000000, 0);\n', '                openPot();\n', '            }\n', '            \n', '            \n', '        }\n', '        \n', '    }\n', '\t\n', '\t\n', '\t\n', '\t\n', '\t\n', '        \n', '\n', '}']
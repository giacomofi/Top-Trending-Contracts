['contract LuckyDoubler {\n', '//##########################################################\n', '//#### LuckyDoubler: A doubler with random payout order ####\n', '//#### Deposit 1 ETHER to participate                   ####\n', '//##########################################################\n', '//COPYRIGHT 2016 KATATSUKI ALL RIGHTS RESERVED\n', '//No part of this source code may be reproduced, distributed,\n', '//modified or transmitted in any form or by any means without\n', '//the prior written permission of the creator.\n', '\n', '    address private owner;\n', '    \n', '    //Stored variables\n', '    uint private balance = 0;\n', '    uint private fee = 5;\n', '    uint private multiplier = 125;\n', '\n', '    mapping (address => User) private users;\n', '    Entry[] private entries;\n', '    uint[] private unpaidEntries;\n', '    \n', '    //Set owner on contract creation\n', '    function LuckyDoubler() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyowner { if (msg.sender == owner) _ }\n', '    \n', '    struct User {\n', '        address id;\n', '        uint deposits;\n', '        uint payoutsReceived;\n', '    }\n', '    \n', '    struct Entry {\n', '        address entryAddress;\n', '        uint deposit;\n', '        uint payout;\n', '        bool paid;\n', '    }\n', '\n', '    //Fallback function\n', '    function() {\n', '        init();\n', '    }\n', '    \n', '    function init() private{\n', '        \n', '        if (msg.value < 1 ether) {\n', '             msg.sender.send(msg.value);\n', '            return;\n', '        }\n', '        \n', '        join();\n', '    }\n', '    \n', '    function join() private {\n', '        \n', '        //Limit deposits to 1ETH\n', '        uint dValue = 1 ether;\n', '        \n', '        if (msg.value > 1 ether) {\n', '            \n', '        \tmsg.sender.send(msg.value - 1 ether);\t\n', '        \tdValue = 1 ether;\n', '        }\n', '      \n', '        //Add new users to the users array\n', '        if (users[msg.sender].id == address(0))\n', '        {\n', '            users[msg.sender].id = msg.sender;\n', '            users[msg.sender].deposits = 0;\n', '            users[msg.sender].payoutsReceived = 0;\n', '        }\n', '        \n', '        //Add new entry to the entries array\n', '        entries.push(Entry(msg.sender, dValue, (dValue * (multiplier) / 100), false));\n', '        users[msg.sender].deposits++;\n', '        unpaidEntries.push(entries.length -1);\n', '        \n', '        //Collect fees and update contract balance\n', '        balance += (dValue * (100 - fee)) / 100;\n', '        \n', '        uint index = unpaidEntries.length > 1 ? rand(unpaidEntries.length) : 0;\n', '        Entry theEntry = entries[unpaidEntries[index]];\n', '        \n', '        //Pay pending entries if the new balance allows for it\n', '        if (balance > theEntry.payout) {\n', '            \n', '            uint payout = theEntry.payout;\n', '            \n', '            theEntry.entryAddress.send(payout);\n', '            theEntry.paid = true;\n', '            users[theEntry.entryAddress].payoutsReceived++;\n', '\n', '            balance -= payout;\n', '            \n', '            if (index < unpaidEntries.length - 1)\n', '                unpaidEntries[index] = unpaidEntries[unpaidEntries.length - 1];\n', '           \n', '            unpaidEntries.length--;\n', '            \n', '        }\n', '        \n', '        //Collect money from fees and possible leftovers from errors (actual balance untouched)\n', '        uint fees = this.balance - balance;\n', '        if (fees > 0)\n', '        {\n', '                owner.send(fees);\n', '        }      \n', '       \n', '    }\n', '    \n', '    //Generate random number between 0 & max\n', '    uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;\n', '    function rand(uint max) constant private returns (uint256 result){\n', '        uint256 factor = FACTOR * 100 / max;\n', '        uint256 lastBlockNumber = block.number - 1;\n', '        uint256 hashVal = uint256(block.blockhash(lastBlockNumber));\n', '    \n', '        return uint256((uint256(hashVal) / factor)) % max;\n', '    }\n', '    \n', '    \n', '    //Contract management\n', '    function changeOwner(address newOwner) onlyowner {\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function changeMultiplier(uint multi) onlyowner {\n', '        if (multi < 110 || multi > 150) throw;\n', '        \n', '        multiplier = multi;\n', '    }\n', '    \n', '    function changeFee(uint newFee) onlyowner {\n', '        if (fee > 5) \n', '            throw;\n', '        fee = newFee;\n', '    }\n', '    \n', '    \n', '    //JSON functions\n', '    function multiplierFactor() constant returns (uint factor, string info) {\n', '        factor = multiplier;\n', "        info = 'The current multiplier applied to all deposits. Min 110%, max 150%.'; \n", '    }\n', '    \n', '    function currentFee() constant returns (uint feePercentage, string info) {\n', '        feePercentage = fee;\n', "        info = 'The fee percentage applied to all deposits. It can change to speed payouts (max 5%).';\n", '    }\n', '    \n', '    function totalEntries() constant returns (uint count, string info) {\n', '        count = entries.length;\n', "        info = 'The number of deposits.';\n", '    }\n', '    \n', '    function userStats(address user) constant returns (uint deposits, uint payouts, string info)\n', '    {\n', '        if (users[user].id != address(0x0))\n', '        {\n', '            deposits = users[user].deposits;\n', '            payouts = users[user].payoutsReceived;\n', "            info = 'Users stats: total deposits, payouts received.';\n", '        }\n', '    }\n', '    \n', '    function entryDetails(uint index) constant returns (address user, uint payout, bool paid, string info)\n', '    {\n', '        if (index < entries.length) {\n', '            user = entries[index].entryAddress;\n', '            payout = entries[index].payout / 1 finney;\n', '            paid = entries[index].paid;\n', "            info = 'Entry info: user address, expected payout in Finneys, payout status.';\n", '        }\n', '    }\n', '    \n', '    \n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract MumsTheWord {\n', '\n', '    uint32 public lastCreditorPayedOut;\n', '    uint public lastTimeOfNewCredit;\n', '    uint public jackpot;\n', '    address[] public creditorAddresses;\n', '    uint[] public creditorAmounts;\n', '    address public owner;\n', '\tuint8 public round;\n', '\t\n', '\t// eight hours\n', '    uint constant EIGHT_HOURS = 28800;\n', '\tuint constant MIN_AMOUNT = 10 ** 16;\n', '\n', '    function MumsTheWord() {\n', '        // owner of the contract will provide the initial jackpot!\n', '        jackpot = msg.value;\n', '        owner = msg.sender;\n', '        lastTimeOfNewCredit = now;\n', '    }\n', '\n', '    function enter() payable returns (bool) {\n', '        uint amount = msg.value;\n', '        // check if 8h have passed\n', '        if (lastTimeOfNewCredit + EIGHT_HOURS > now) {\n', '            // Return money to sender\n', '            msg.sender.transfer(amount);\n', '            // Sends jackpot to the last player\n', '            creditorAddresses[creditorAddresses.length - 1].transfer(jackpot);\n', '            owner.transfer(this.balance);\n', '            // Reset contract state\n', '            lastCreditorPayedOut = 0;\n', '            lastTimeOfNewCredit = now;\n', '            jackpot = 0;\n', '            creditorAddresses = new address[](0);\n', '            creditorAmounts = new uint[](0);\n', '            round += 1;\n', '            return false;\n', '        } else {\n', '            // the system needs to collect at least 1% of the profit from a crash to stay alive\n', '            if (amount >= MIN_AMOUNT) {\n', '                // the System has received fresh money, it will survive at least 8h more\n', '                lastTimeOfNewCredit = now;\n', '                // register the new creditor and his amount with 10% interest rate\n', '                creditorAddresses.push(msg.sender);\n', '                creditorAmounts.push(amount * 110 / 100);\n', '\t\t\t\t\n', '                // 5% fee\n', '                owner.transfer(amount * 5/100);\n', '\t\t\t\t\n', '                // 5% are going to the jackpot (will increase the value for the last person standing)\n', '                if (jackpot < 100 ether) {\n', '                    jackpot += amount * 5/100;\n', '                }\n', '\t\t\t\t\n', '                // 90% of the money will be used to pay out old creditors\n', '                if (creditorAmounts[lastCreditorPayedOut] <= address(this).balance - jackpot) {\n', '                    creditorAddresses[lastCreditorPayedOut].transfer(creditorAmounts[lastCreditorPayedOut]);\n', '                    lastCreditorPayedOut += 1;\n', '                }\n', '                return true;\n', '            } else {\n', '                msg.sender.transfer(amount);\n', '                return false;\n', '            }\n', '        }\n', '    }\n', '\n', '    // fallback function\n', '    function() payable {\n', '        enter();\n', '    }\n', '\n', '    function totalDebt() returns (uint debt) {\n', '        for(uint i=lastCreditorPayedOut; i<creditorAmounts.length; i++){\n', '            debt += creditorAmounts[i];\n', '        }\n', '    }\n', '\n', '    function totalPayedOut() returns (uint payout) {\n', '        for(uint i=0; i<lastCreditorPayedOut; i++){\n', '            payout += creditorAmounts[i];\n', '        }\n', '    }\n', '\n', '    // better don&#39;t do it (unless you want to increase the jackpot)\n', '    function raiseJackpot() payable {\n', '        jackpot += msg.value;\n', '    }\n', '\n', '    function getCreditorAddresses() returns (address[]) {\n', '        return creditorAddresses;\n', '    }\n', '\n', '    function getCreditorAmounts() returns (uint[]) {\n', '        return creditorAmounts;\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', 'contract MumsTheWord {\n', '\n', '    uint32 public lastCreditorPayedOut;\n', '    uint public lastTimeOfNewCredit;\n', '    uint public jackpot;\n', '    address[] public creditorAddresses;\n', '    uint[] public creditorAmounts;\n', '    address public owner;\n', '\tuint8 public round;\n', '\t\n', '\t// eight hours\n', '    uint constant EIGHT_HOURS = 28800;\n', '\tuint constant MIN_AMOUNT = 10 ** 16;\n', '\n', '    function MumsTheWord() {\n', '        // owner of the contract will provide the initial jackpot!\n', '        jackpot = msg.value;\n', '        owner = msg.sender;\n', '        lastTimeOfNewCredit = now;\n', '    }\n', '\n', '    function enter() payable returns (bool) {\n', '        uint amount = msg.value;\n', '        // check if 8h have passed\n', '        if (lastTimeOfNewCredit + EIGHT_HOURS > now) {\n', '            // Return money to sender\n', '            msg.sender.transfer(amount);\n', '            // Sends jackpot to the last player\n', '            creditorAddresses[creditorAddresses.length - 1].transfer(jackpot);\n', '            owner.transfer(this.balance);\n', '            // Reset contract state\n', '            lastCreditorPayedOut = 0;\n', '            lastTimeOfNewCredit = now;\n', '            jackpot = 0;\n', '            creditorAddresses = new address[](0);\n', '            creditorAmounts = new uint[](0);\n', '            round += 1;\n', '            return false;\n', '        } else {\n', '            // the system needs to collect at least 1% of the profit from a crash to stay alive\n', '            if (amount >= MIN_AMOUNT) {\n', '                // the System has received fresh money, it will survive at least 8h more\n', '                lastTimeOfNewCredit = now;\n', '                // register the new creditor and his amount with 10% interest rate\n', '                creditorAddresses.push(msg.sender);\n', '                creditorAmounts.push(amount * 110 / 100);\n', '\t\t\t\t\n', '                // 5% fee\n', '                owner.transfer(amount * 5/100);\n', '\t\t\t\t\n', '                // 5% are going to the jackpot (will increase the value for the last person standing)\n', '                if (jackpot < 100 ether) {\n', '                    jackpot += amount * 5/100;\n', '                }\n', '\t\t\t\t\n', '                // 90% of the money will be used to pay out old creditors\n', '                if (creditorAmounts[lastCreditorPayedOut] <= address(this).balance - jackpot) {\n', '                    creditorAddresses[lastCreditorPayedOut].transfer(creditorAmounts[lastCreditorPayedOut]);\n', '                    lastCreditorPayedOut += 1;\n', '                }\n', '                return true;\n', '            } else {\n', '                msg.sender.transfer(amount);\n', '                return false;\n', '            }\n', '        }\n', '    }\n', '\n', '    // fallback function\n', '    function() payable {\n', '        enter();\n', '    }\n', '\n', '    function totalDebt() returns (uint debt) {\n', '        for(uint i=lastCreditorPayedOut; i<creditorAmounts.length; i++){\n', '            debt += creditorAmounts[i];\n', '        }\n', '    }\n', '\n', '    function totalPayedOut() returns (uint payout) {\n', '        for(uint i=0; i<lastCreditorPayedOut; i++){\n', '            payout += creditorAmounts[i];\n', '        }\n', '    }\n', '\n', "    // better don't do it (unless you want to increase the jackpot)\n", '    function raiseJackpot() payable {\n', '        jackpot += msg.value;\n', '    }\n', '\n', '    function getCreditorAddresses() returns (address[]) {\n', '        return creditorAddresses;\n', '    }\n', '\n', '    function getCreditorAmounts() returns (uint[]) {\n', '        return creditorAmounts;\n', '    }\n', '}']
['contract ProtectTheCastle {\n', "    // King's Jester\n", '    address public jester;\n', '    // Record the last Reparation time\n', '    uint public lastReparation;\n', '    // Piggy Bank Amount\n', '    uint public piggyBank;\n', '\n', '    // Collected Fee Amount\n', '    uint public collectedFee;\n', '\n', '    // Track the citizens who helped to repair the castle\n', '    address[] public citizensAddresses;\n', '    uint[] public citizensAmounts;\n', '    uint32 public totalCitizens;\n', '    uint32 public lastCitizenPaid;\n', '    // Brided Citizen who made the system works\n', '    address public bribedCitizen;\n', '    // Record how many times the castle had fell\n', '    uint32 public round;\n', '    // Amount already paid back in this round\n', '    uint public amountAlreadyPaidBack;\n', '    // Amount invested in this round\n', '    uint public amountInvested;\n', '\n', '    uint constant SIX_HOURS = 60 * 60 * 6;\n', '\n', '    function ProtectTheCastle() {\n', '        // Define the first castle\n', '        bribedCitizen = msg.sender;\n', '        jester = msg.sender;\n', '        lastReparation = block.timestamp;\n', '        amountAlreadyPaidBack = 0;\n', '        amountInvested = 0;\n', '        totalCitizens = 0;\n', '    }\n', '\n', '    function repairTheCastle() returns(bool) {\n', '        uint amount = msg.value;\n', '        // Check if the minimum amount if reached\n', '        if (amount < 10 finney) {\n', '            msg.sender.send(msg.value);\n', '            return false;\n', '        }\n', '        // If the amount received is more than 100 ETH return the difference\n', '        if (amount > 100 ether) {\n', '            msg.sender.send(msg.value - 100 ether);\n', '            amount = 100 ether;\n', '        }\n', '\n', '        // Check if the Castle has fell\n', '        if (lastReparation + SIX_HOURS < block.timestamp) {\n', '            // Send the Piggy Bank to the last 3 citizens\n', '            // If there is no one who contributed this last 6 hours, no action needed\n', '            if (totalCitizens == 1) {\n', '                // If there is only one Citizen who contributed, he gets the full Pigg Bank\n', '                citizensAddresses[citizensAddresses.length - 1].send(piggyBank);\n', '            } else if (totalCitizens == 2) {\n', '                // If only 2 citizens contributed\n', '                citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 65 / 100);\n', '                citizensAddresses[citizensAddresses.length - 2].send(piggyBank * 35 / 100);\n', '            } else if (totalCitizens >= 3) {\n', '                // If there is 3 or more citizens who contributed\n', '                citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 55 / 100);\n', '                citizensAddresses[citizensAddresses.length - 2].send(piggyBank * 30 / 100);\n', '                citizensAddresses[citizensAddresses.length - 3].send(piggyBank * 15 / 100);\n', '            }\n', '\n', '            // Define the new Piggy Bank\n', '            piggyBank = 0;\n', '\n', '            // Define the new Castle\n', '            jester = msg.sender;\n', '            lastReparation = block.timestamp;\n', '            citizensAddresses.push(msg.sender);\n', '            citizensAmounts.push(amount * 2);\n', '            totalCitizens += 1;\n', '            amountInvested += amount;\n', '\n', '            // All goes to the Piggy Bank\n', '            piggyBank += amount;\n', '\n', '            // The Jetster take 3%\n', '            jester.send(amount * 3 / 100);\n', '\n', '            // The brided Citizen takes 3%\n', '            collectedFee += amount * 3 / 100;\n', '\n', '            round += 1;\n', '        } else {\n', '            // The Castle is still up\n', '            lastReparation = block.timestamp;\n', '            citizensAddresses.push(msg.sender);\n', '            citizensAmounts.push(amount * 2);\n', '            totalCitizens += 1;\n', '            amountInvested += amount;\n', '\n', '            // 5% goes to the Piggy Bank\n', '            piggyBank += (amount * 5 / 100);\n', '\n', '            // The Jetster takes 3%\n', '            jester.send(amount * 3 / 100);\n', '\n', '            // The brided Citizen takes 3%\n', '            collectedFee += amount * 3 / 100;\n', '\n', '            while (citizensAmounts[lastCitizenPaid] < (address(this).balance - piggyBank - collectedFee) && lastCitizenPaid <= totalCitizens) {\n', '                citizensAddresses[lastCitizenPaid].send(citizensAmounts[lastCitizenPaid]);\n', '                amountAlreadyPaidBack += citizensAmounts[lastCitizenPaid];\n', '                lastCitizenPaid += 1;\n', '            }\n', '        }\n', '    }\n', '\n', '    // fallback function\n', '    function() {\n', '        repairTheCastle();\n', '    }\n', '\n', '    // When the castle would be no more...\n', '    function surrender() {\n', '        if (msg.sender == bribedCitizen) {\n', '            bribedCitizen.send(address(this).balance);\n', '            selfdestruct(bribedCitizen);\n', '        }\n', '    }\n', '\n', '    // When the brided Citizen decides to give his seat to someone else\n', '    function newBribedCitizen(address newBribedCitizen) {\n', '        if (msg.sender == bribedCitizen) {\n', '            bribedCitizen = newBribedCitizen;\n', '        }\n', '    }\n', '\n', '    // When the brided Citizen decides to collect his fees\n', '    function collectFee() {\n', '        if (msg.sender == bribedCitizen) {\n', '            bribedCitizen.send(collectedFee);\n', '        }\n', '    }\n', '\n', "    // When the jester can't handle it anymore, he can give his position to someone else\n", '    function newJester(address newJester) {\n', '        if (msg.sender == jester) {\n', '            jester = newJester;\n', '        }\n', '    }       \n', '}']
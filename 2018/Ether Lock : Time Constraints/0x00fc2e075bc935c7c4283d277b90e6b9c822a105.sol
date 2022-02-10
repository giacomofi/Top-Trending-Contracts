['pragma solidity ^0.4.16;\n', '\n', '//Define the pool\n', 'contract SmartPool {\n', '\n', '    //Pool info\n', '    uint currAmount;    //Current amount in the pool (=balance)\n', '    uint ticketPrice;   //Price of one ticket\n', '    uint startDate;\t\t//The date of opening\n', '\tuint endDate;\t\t//The date of closing (or 0 if still open)\n', '\t\n', '\t//Block infos (better to use block number than dates to trigger the end)\n', '\tuint startBlock;\n', '\tuint endBlock;\n', '\t\n', '\t//End triggers\n', '\tuint duration;\t\t//The pool ends when the duration expire\n', '    uint ticketCount;\t//Or when the reserve of tickets has been sold\n', '    bool ended;\t\t\t//Current state (can&#39;t buy tickets when ended)\n', '\tbool terminated;\t//true if a winner has been picked\n', '\tbool moneySent;\t\t//true if the winner has picked his money\n', '    \n', '\t//Min wait duration between ended and terminated states\n', '\tuint constant blockDuration = 15; // we use 15 sec for the block duration\n', '\tuint constant minWaitDuration = 240; // (= 3600 / blockDuration => 60 minutes waiting between &#39;ended&#39; and &#39;terminated&#39;)\n', '\t\n', '    //Players\n', '    address[] players;\t//List of tickets owners, each ticket gives an entry in the array\n', '\t\n', '\t//Winning info\n', '    address winner;\t\t//The final winner (only available when terminated == true)\n', '     \n', '    //Pool manager address (only the manager can call modifiers of this contract, see PoolManager.sol)\n', '    address poolManager;\n', '    \n', '    //Create a pool with a fixed ticket price, a ticket reserve and/or a duration)\n', '    function SmartPool(uint _ticketPrice, uint _ticketCount, uint _duration) public\n', '    {\n', '\t\t//Positive ticket price and either ticketCount or duration must be provided\n', '        require(_ticketPrice > 0 && (_ticketCount > 0 || _duration > blockDuration));\n', '\t\t\n', '\t\t//Check for overflows\n', '\t\trequire(now + _duration >= now);\n', '\t\t\n', '\t\t//Set ticketCount if needed (according to max balance)\n', '\t\tif (_ticketCount == 0)\n', '\t\t{\n', '\t\t\t_ticketCount = (2 ** 256 - 1) / _ticketPrice;\n', '\t\t}\n', '\t\t\n', '\t\trequire(_ticketCount * _ticketPrice >= _ticketPrice);\n', '\t\t\n', '\t\t//Store manager\n', '\t\tpoolManager = msg.sender;\n', '\t\t\n', '        //Init\n', '        currAmount = 0;\n', '\t\tstartDate = now;\n', '\t\tendDate = 0;\n', '\t\tstartBlock = block.number;\n', '\t\tendBlock = 0;\n', '        ticketPrice = _ticketPrice;\n', '        ticketCount = _ticketCount;\n', '\t\tduration = _duration / blockDuration; // compute duration in blocks\n', '        ended = false;\n', '\t\tterminated = false;\n', '\t\tmoneySent = false;\n', '\t\twinner = 0x0000000000000000000000000000000000000000;\n', '    }\n', '\n', '\t\n', '\t//Accessors\n', '\tfunction getPlayers() public constant returns (address[])\n', '    {\n', '    \treturn players;\n', '    }\n', '\t\n', '\tfunction getStartDate() public constant returns (uint)\n', '    {\n', '    \treturn startDate;\n', '    }\n', '\t\n', '\tfunction getStartBlock() public constant returns (uint)\n', '    {\n', '    \treturn startBlock;\n', '    }\n', '\t\n', '    function getCurrAmount() public constant returns (uint)\n', '    {\n', '    \treturn currAmount;\n', '    }\n', '\t\n', '\tfunction getTicketPrice() public constant returns (uint)\n', '\t{\n', '\t\treturn ticketPrice;\n', '\t}\n', '\t\n', '\tfunction getTicketCount() public constant returns (uint)\n', '\t{\n', '\t\treturn ticketCount;\n', '\t}\n', '\t\n', '\tfunction getBoughtTicketCount() public constant returns (uint)\n', '\t{\n', '\t\treturn players.length;\n', '\t}\n', '\t\n', '\tfunction getAvailableTicketCount() public constant returns (uint)\n', '\t{\n', '\t\treturn ticketCount - players.length;\n', '\t}\n', '\t\n', '\tfunction getEndDate() public constant returns (uint)\n', '\t{\n', '\t\treturn endDate;\n', '\t}\n', '\t\n', '\tfunction getEndBlock() public constant returns (uint)\n', '    {\n', '    \treturn endBlock;\n', '    }\n', '\t\n', '\tfunction getDuration() public constant returns (uint)\n', '\t{\n', '\t\treturn duration; // duration in blocks\n', '\t}\n', '\t\n', '\tfunction getDurationS() public constant returns (uint)\n', '\t{\n', '\t\treturn duration * blockDuration; // duration in seconds\n', '\t}\n', '\t\t\n', '\tfunction isEnded() public constant returns (bool)\n', '\t{\n', '\t\treturn ended;\n', '\t}\n', '\n', '\tfunction isTerminated() public constant returns (bool)\n', '\t{\n', '\t\treturn terminated;\n', '\t}\n', '\t\n', '\tfunction isMoneySent() public constant returns (bool)\n', '\t{\n', '\t\treturn moneySent;\n', '\t}\n', '\t\n', '\tfunction getWinner() public constant returns (address)\n', '\t{\n', '\t\treturn winner;\n', '\t}\n', '\n', '\t//End trigger\n', '\tfunction checkEnd() public\n', '\t{\n', '\t\tif ( (duration > 0 && block.number >= startBlock + duration) || (players.length >= ticketCount) )\n', '        {\n', '\t\t\tended = true;\n', '\t\t\tendDate = now;\n', '\t\t\tendBlock = block.number;\n', '        }\n', '\t}\n', '\t\n', '    //Add player with ticketCount to the pool (only poolManager can do this)\n', '    function addPlayer(address player, uint ticketBoughtCount, uint amount) public  \n', '\t{\n', '\t\t//Only manager can call this\n', '\t\trequire(msg.sender == poolManager);\n', '\t\t\n', '        //Revert if pool ended (should not happen because the manager check this too)\n', '        require (!ended);\n', '\t\t\n', '        //Add amount to the pool\n', '        currAmount += amount; // amount has been checked by the manager\n', '        \n', '        //Add player to the ticket owner array, for each bought ticket\n', '\t\tfor (uint i = 0; i < ticketBoughtCount; i++)\n', '\t\t\tplayers.push(player);\n', '        \n', '        //Check end\t\n', '\t\tcheckEnd();\n', '    }\n', '\t\n', '\tfunction canTerminate() public constant returns(bool)\n', '\t{\n', '\t\treturn ended && !terminated && block.number - endBlock >= minWaitDuration;\n', '\t}\n', '\n', '    //Terminate the pool by picking a winner (only poolManager can do this, after the pool is ended and some time has passed so the seed has changed many times)\n', '    function terminate(uint randSeed) public \n', '\t{\t\t\n', '\t\t//Only manager can call this\n', '\t\trequire(msg.sender == poolManager);\n', '\t\t\n', '        //The pool need to be ended, but not terminated\n', '        require(ended && !terminated);\n', '\t\t\n', '\t\t//Min duration between ended and terminated\n', '\t\trequire(block.number - endBlock >= minWaitDuration);\n', '\t\t\n', '\t\t//Only one call to this function\n', '        terminated = true;\n', '\n', '\t\t//Pick a winner\n', '\t\tif (players.length > 0)\n', '\t\t\twinner = players[randSeed % players.length];\n', '    }\n', '\t\n', '\t//Update pool state (only poolManager can call this when the money has been sent)\n', '\tfunction onMoneySent() public\n', '\t{\n', '\t\t//Only manager can call this\n', '\t\trequire(msg.sender == poolManager);\n', '\t\t\n', '\t\t//The pool must be terminated (winner picked)\n', '\t\trequire(terminated);\n', '\t\t\n', '\t\t//Update money sent (only one call to this function)\n', '\t\trequire(!moneySent);\n', '\t\tmoneySent = true;\n', '\t}\n', '}\n', '\n', '       \n', '//Wallet interface\n', 'contract WalletContract\n', '{\n', '\tfunction payMe() public payable;\n', '}\n', '\t   \n', '\t   \n', 'contract PoolManager {\n', '\n', '\t//Pool owner (address which manage the pool creation)\n', '    address owner;\n', '\t\n', '\t//Wallet which receive the fees (1% of ticket price)\n', '\taddress wallet;\n', '\t\n', '\t//Fees infos (external websites providing access to pools get 1% too)\n', '\tmapping(address => uint) fees;\n', '\t\t\n', '\t//Fees divider (1% for the wallet, and 1% for external website where player can buy tickets)\n', '\tuint constant feeDivider = 100; //(1/100 of the amount)\n', '\n', '\t//The ticket price for pools must be a multiple of 0.010205 ether (to avoid truncating the fees, and having a minimum to send to the winner)\n', '    uint constant ticketPriceMultiple = 10205000000000000; //(multiple of 0.010205 ether for ticketPrice)\n', '\n', '\t//Pools infos (current active pools. When a pool is done, it goes into the poolsDone array bellow and a new pool is created to replace it at the same index)\n', '\tSmartPool[] pools;\n', '\t\n', '\t//Ended pools (cleaned automatically after winners get their prices)\n', '\tSmartPool[] poolsDone;\n', '\t\n', '\t//History (contains all the pools since the deploy)\n', '\tSmartPool[] poolsHistory;\n', '\t\n', '\t//Current rand seed (it changes a lot so it&#39;s pretty hard to know its value when the winner is picked)\n', '\tuint randSeed;\n', '\n', '\t//Constructor (only owner)\n', '\tfunction PoolManager(address wal) public\n', '\t{\n', '\t\towner = msg.sender;\n', '\t\twallet = wal;\n', '\n', '\t\trandSeed = 0;\n', '\t}\n', '\t\n', '\t//Called frequently by other functions to keep the seed moving\n', '\tfunction updateSeed() private\n', '\t{\n', '\t\trandSeed += (uint(block.blockhash(block.number - 1)));\n', '\t}\n', '\t\n', '\t//Create a new pool (only owner can do this)\n', '\tfunction addPool(uint ticketPrice, uint ticketCount, uint duration) public\n', '\t{\n', '\t\trequire(msg.sender == owner);\n', '\t\trequire(ticketPrice >= ticketPriceMultiple && ticketPrice % ticketPriceMultiple == 0);\n', '\t\t\n', '\t\t//Deploy a new pool\n', '\t\tpools.push(new SmartPool(ticketPrice, ticketCount, duration));\n', '\t}\n', '\t\n', '\t//Accessors (public)\n', '\t\n', '\t//Get Active Pools\n', '\tfunction getPoolCount() public constant returns(uint)\n', '\t{\n', '\t\treturn pools.length;\n', '\t}\n', '\tfunction getPool(uint index) public constant returns(address)\n', '\t{\n', '\t\trequire(index < pools.length);\n', '\t\treturn pools[index];\n', '\t}\n', '\t\n', '\t//Get Ended Pools\n', '\tfunction getPoolDoneCount() public constant returns(uint)\n', '\t{\n', '\t\treturn poolsDone.length;\n', '\t}\n', '\tfunction getPoolDone(uint index) public constant returns(address)\n', '\t{\n', '\t\trequire(index < poolsDone.length);\n', '\t\treturn poolsDone[index];\n', '\t}\n', '\n', '\t//Get History\n', '\tfunction getPoolHistoryCount() public constant returns(uint)\n', '\t{\n', '\t\treturn poolsHistory.length;\n', '\t}\n', '\tfunction getPoolHistory(uint index) public constant returns(address)\n', '\t{\n', '\t\trequire(index < poolsHistory.length);\n', '\t\treturn poolsHistory[index];\n', '\t}\n', '\t\t\n', '\t//Buy tickets for a pool (public)\n', '\tfunction buyTicket(uint poolIndex, uint ticketCount, address websiteFeeAddr) public payable\n', '\t{\n', '\t\trequire(poolIndex < pools.length);\n', '\t\trequire(ticketCount > 0);\n', '\t\t\n', '\t\t//Get pool and check state\n', '\t\tSmartPool pool = pools[poolIndex];\n', '\t\tpool.checkEnd();\n', '\t\trequire (!pool.isEnded());\n', '\t\t\n', '\t\t//Adjust ticketCount according to available tickets\n', '\t\tuint availableCount = pool.getAvailableTicketCount();\n', '\t\tif (ticketCount > availableCount)\n', '\t\t\tticketCount = availableCount;\n', '\t\t\n', '\t\t//Get amount required and check msg.value\n', '\t\tuint amountRequired = ticketCount * pool.getTicketPrice();\n', '\t\trequire(msg.value >= amountRequired);\n', '\t\t\n', '\t\t//If too much value sent, we send it back to player\n', '\t\tuint amountLeft = msg.value - amountRequired;\n', '\t\t\n', '\t\t//if no websiteFeeAddr given, the wallet get the fee\n', '\t\tif (websiteFeeAddr == address(0))\n', '\t\t\twebsiteFeeAddr = wallet;\n', '\t\t\n', '\t\t//Compute fee\n', '\t\tuint feeAmount = amountRequired / feeDivider;\n', '\t\t\n', '\t\taddFee(websiteFeeAddr, feeAmount);\n', '\t\taddFee(wallet, feeAmount);\n', '\t\t\n', '\t\t//Add player to the pool with the amount minus the fees (1% + 1% = 2%)\n', '\t\tpool.addPlayer(msg.sender, ticketCount, amountRequired - 2 * feeAmount);\n', '\t\t\n', '\t\t//Send back amountLeft to player if too much value sent\n', '\t\tif (amountLeft > 0 && !msg.sender.send(amountLeft))\n', '\t\t{\n', '\t\t\taddFee(wallet, amountLeft); // if it fails, we take it as a fee..\n', '\t\t}\n', '\t\t\n', '\t\tupdateSeed();\n', '\t}\n', '\n', '\t//Check pools end. (called by our console each 10 minutes, or can be called by anybody)\n', '\tfunction checkPoolsEnd() public \n', '\t{\n', '\t\tfor (uint i = 0; i < pools.length; i++)\n', '\t\t{\n', '\t\t\t//Check each pool and restart the ended ones\n', '\t\t\tcheckPoolEnd(i);\n', '\t\t}\n', '\t}\n', '\t\n', '\t//Check end of a pool and restart it if it&#39;s ended (public)\n', '\tfunction checkPoolEnd(uint i) public \n', '\t{\n', '\t\trequire(i < pools.length);\n', '\t\t\n', '\t\t//Check end (if not triggered yet)\n', '\t\tSmartPool pool = pools[i];\n', '\t\tif (!pool.isEnded())\n', '\t\t\tpool.checkEnd();\n', '\t\t\t\n', '\t\tif (!pool.isEnded())\n', '\t\t{\n', '\t\t\treturn; // not ended yet\n', '\t\t}\n', '\t\t\n', '\t\tupdateSeed();\n', '\t\t\n', '\t\t//Store pool done and restart a pool to replace it\n', '\t\tpoolsDone.push(pool);\n', '\t\tpools[i] = new SmartPool(pool.getTicketPrice(), pool.getTicketCount(), pool.getDurationS());\n', '\t}\n', '\t\n', '\t//Check pools done. (called by our console, or can be called by anybody)\n', '\tfunction checkPoolsDone() public \n', '\t{\n', '\t\tfor (uint i = 0; i < poolsDone.length; i++)\n', '\t\t{\n', '\t\t\tcheckPoolDone(i);\n', '\t\t}\n', '\t}\n', '\t\n', '\t//Check end of one pool\n', '\tfunction checkPoolDone(uint i) public\n', '\t{\n', '\t\trequire(i < poolsDone.length);\n', '\t\t\n', '\t\tSmartPool pool = poolsDone[i];\n', '\t\tif (pool.isTerminated())\n', '\t\t\treturn; // already terminated\n', '\t\t\t\n', '\t\tif (!pool.canTerminate())\n', '\t\t\treturn; // we need to wait a bit more before random occurs, so the seed has changed enough (60 minutes before ended and terminated states)\n', '\t\t\t\n', '\t\tupdateSeed();\n', '\t\t\n', '\t\t//Terminate (pick a winner) and store pool done\n', '\t\tpool.terminate(randSeed);\n', '\t}\n', '\n', '\t//Send money of the pool to the winner (public)\n', '\tfunction sendPoolMoney(uint i) public\n', '\t{\n', '\t\trequire(i < poolsDone.length);\n', '\t\t\n', '\t\tSmartPool pool = poolsDone[i];\n', '\t\trequire (pool.isTerminated()); // we need a winner picked\n', '\t\t\n', '\t\trequire(!pool.isMoneySent()); // money not sent\n', '\t\t\n', '\t\tuint amount = pool.getCurrAmount();\n', '\t\taddress winner = pool.getWinner();\n', '\t\tpool.onMoneySent();\n', '\t\tif (amount > 0 && !winner.send(amount)) // the winner can&#39;t get his money (should not happen)\n', '\t\t{\n', '\t\t\taddFee(wallet, amount);\n', '\t\t}\n', '\t\t\n', '\t\t//Pool goes into history array\n', '\t\tpoolsHistory.push(pool);\n', '\t}\n', '\t\t\n', '\t//Clear pools done array (called once a week by our console, or can be called by anybody)\n', '\tfunction clearPoolsDone() public\n', '\t{\n', '\t\t//Make sure all pools are terminated with no money left\n', '\t\tfor (uint i = 0; i < poolsDone.length; i++)\n', '\t\t{\n', '\t\t\tif (!poolsDone[i].isMoneySent())\n', '\t\t\t\treturn;\n', '\t\t}\n', '\t\t\n', '\t\t//"Clear" poolsDone array (just reset the length, instances will be override)\n', '\t\tpoolsDone.length = 0;\n', '\t}\n', '\t\n', '\t//Get current fee value\n', '\tfunction getFeeValue(address a) public constant returns (uint)\n', '\t{\n', '\t\tif (a == address(0))\n', '\t\t\ta = msg.sender;\n', '\t\treturn fees[a];\n', '\t}\n', '\n', '\t//Send fee to address (public, with a min amount required)\n', '\tfunction getMyFee(address a) public\n', '\t{\n', '\t\tif (a == address(0))\n', '\t\t\ta = msg.sender;\n', '\t\tuint amount = fees[a];\n', '\t\trequire (amount > 0);\n', '\t\t\n', '\t\tfees[a] = 0;\n', '\t\t\n', '\t\tif (a == wallet)\n', '\t\t{\n', '\t\t\tWalletContract walletContract = WalletContract(a);\n', '\t\t\twalletContract.payMe.value(amount)();\n', '\t\t}\n', '\t\telse if (!a.send(amount))\n', '\t\t\taddFee(wallet, amount); // the fee can&#39;t be sent (hacking attempt?), so we take it... :-p\n', '\t}\n', '\t\n', '\t//Add fee (private)\n', '\tfunction addFee(address a, uint fee) private\n', '\t{\n', '\t\tif (fees[a] == 0)\n', '\t\t\tfees[a] = fee;\n', '\t\telse\n', '\t\t\tfees[a] += fee; // we don&#39;t check for overflow, if you&#39;re billionaire in fees, call getMyFee sometimes :-)\n', '\t}\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '//Define the pool\n', 'contract SmartPool {\n', '\n', '    //Pool info\n', '    uint currAmount;    //Current amount in the pool (=balance)\n', '    uint ticketPrice;   //Price of one ticket\n', '    uint startDate;\t\t//The date of opening\n', '\tuint endDate;\t\t//The date of closing (or 0 if still open)\n', '\t\n', '\t//Block infos (better to use block number than dates to trigger the end)\n', '\tuint startBlock;\n', '\tuint endBlock;\n', '\t\n', '\t//End triggers\n', '\tuint duration;\t\t//The pool ends when the duration expire\n', '    uint ticketCount;\t//Or when the reserve of tickets has been sold\n', "    bool ended;\t\t\t//Current state (can't buy tickets when ended)\n", '\tbool terminated;\t//true if a winner has been picked\n', '\tbool moneySent;\t\t//true if the winner has picked his money\n', '    \n', '\t//Min wait duration between ended and terminated states\n', '\tuint constant blockDuration = 15; // we use 15 sec for the block duration\n', "\tuint constant minWaitDuration = 240; // (= 3600 / blockDuration => 60 minutes waiting between 'ended' and 'terminated')\n", '\t\n', '    //Players\n', '    address[] players;\t//List of tickets owners, each ticket gives an entry in the array\n', '\t\n', '\t//Winning info\n', '    address winner;\t\t//The final winner (only available when terminated == true)\n', '     \n', '    //Pool manager address (only the manager can call modifiers of this contract, see PoolManager.sol)\n', '    address poolManager;\n', '    \n', '    //Create a pool with a fixed ticket price, a ticket reserve and/or a duration)\n', '    function SmartPool(uint _ticketPrice, uint _ticketCount, uint _duration) public\n', '    {\n', '\t\t//Positive ticket price and either ticketCount or duration must be provided\n', '        require(_ticketPrice > 0 && (_ticketCount > 0 || _duration > blockDuration));\n', '\t\t\n', '\t\t//Check for overflows\n', '\t\trequire(now + _duration >= now);\n', '\t\t\n', '\t\t//Set ticketCount if needed (according to max balance)\n', '\t\tif (_ticketCount == 0)\n', '\t\t{\n', '\t\t\t_ticketCount = (2 ** 256 - 1) / _ticketPrice;\n', '\t\t}\n', '\t\t\n', '\t\trequire(_ticketCount * _ticketPrice >= _ticketPrice);\n', '\t\t\n', '\t\t//Store manager\n', '\t\tpoolManager = msg.sender;\n', '\t\t\n', '        //Init\n', '        currAmount = 0;\n', '\t\tstartDate = now;\n', '\t\tendDate = 0;\n', '\t\tstartBlock = block.number;\n', '\t\tendBlock = 0;\n', '        ticketPrice = _ticketPrice;\n', '        ticketCount = _ticketCount;\n', '\t\tduration = _duration / blockDuration; // compute duration in blocks\n', '        ended = false;\n', '\t\tterminated = false;\n', '\t\tmoneySent = false;\n', '\t\twinner = 0x0000000000000000000000000000000000000000;\n', '    }\n', '\n', '\t\n', '\t//Accessors\n', '\tfunction getPlayers() public constant returns (address[])\n', '    {\n', '    \treturn players;\n', '    }\n', '\t\n', '\tfunction getStartDate() public constant returns (uint)\n', '    {\n', '    \treturn startDate;\n', '    }\n', '\t\n', '\tfunction getStartBlock() public constant returns (uint)\n', '    {\n', '    \treturn startBlock;\n', '    }\n', '\t\n', '    function getCurrAmount() public constant returns (uint)\n', '    {\n', '    \treturn currAmount;\n', '    }\n', '\t\n', '\tfunction getTicketPrice() public constant returns (uint)\n', '\t{\n', '\t\treturn ticketPrice;\n', '\t}\n', '\t\n', '\tfunction getTicketCount() public constant returns (uint)\n', '\t{\n', '\t\treturn ticketCount;\n', '\t}\n', '\t\n', '\tfunction getBoughtTicketCount() public constant returns (uint)\n', '\t{\n', '\t\treturn players.length;\n', '\t}\n', '\t\n', '\tfunction getAvailableTicketCount() public constant returns (uint)\n', '\t{\n', '\t\treturn ticketCount - players.length;\n', '\t}\n', '\t\n', '\tfunction getEndDate() public constant returns (uint)\n', '\t{\n', '\t\treturn endDate;\n', '\t}\n', '\t\n', '\tfunction getEndBlock() public constant returns (uint)\n', '    {\n', '    \treturn endBlock;\n', '    }\n', '\t\n', '\tfunction getDuration() public constant returns (uint)\n', '\t{\n', '\t\treturn duration; // duration in blocks\n', '\t}\n', '\t\n', '\tfunction getDurationS() public constant returns (uint)\n', '\t{\n', '\t\treturn duration * blockDuration; // duration in seconds\n', '\t}\n', '\t\t\n', '\tfunction isEnded() public constant returns (bool)\n', '\t{\n', '\t\treturn ended;\n', '\t}\n', '\n', '\tfunction isTerminated() public constant returns (bool)\n', '\t{\n', '\t\treturn terminated;\n', '\t}\n', '\t\n', '\tfunction isMoneySent() public constant returns (bool)\n', '\t{\n', '\t\treturn moneySent;\n', '\t}\n', '\t\n', '\tfunction getWinner() public constant returns (address)\n', '\t{\n', '\t\treturn winner;\n', '\t}\n', '\n', '\t//End trigger\n', '\tfunction checkEnd() public\n', '\t{\n', '\t\tif ( (duration > 0 && block.number >= startBlock + duration) || (players.length >= ticketCount) )\n', '        {\n', '\t\t\tended = true;\n', '\t\t\tendDate = now;\n', '\t\t\tendBlock = block.number;\n', '        }\n', '\t}\n', '\t\n', '    //Add player with ticketCount to the pool (only poolManager can do this)\n', '    function addPlayer(address player, uint ticketBoughtCount, uint amount) public  \n', '\t{\n', '\t\t//Only manager can call this\n', '\t\trequire(msg.sender == poolManager);\n', '\t\t\n', '        //Revert if pool ended (should not happen because the manager check this too)\n', '        require (!ended);\n', '\t\t\n', '        //Add amount to the pool\n', '        currAmount += amount; // amount has been checked by the manager\n', '        \n', '        //Add player to the ticket owner array, for each bought ticket\n', '\t\tfor (uint i = 0; i < ticketBoughtCount; i++)\n', '\t\t\tplayers.push(player);\n', '        \n', '        //Check end\t\n', '\t\tcheckEnd();\n', '    }\n', '\t\n', '\tfunction canTerminate() public constant returns(bool)\n', '\t{\n', '\t\treturn ended && !terminated && block.number - endBlock >= minWaitDuration;\n', '\t}\n', '\n', '    //Terminate the pool by picking a winner (only poolManager can do this, after the pool is ended and some time has passed so the seed has changed many times)\n', '    function terminate(uint randSeed) public \n', '\t{\t\t\n', '\t\t//Only manager can call this\n', '\t\trequire(msg.sender == poolManager);\n', '\t\t\n', '        //The pool need to be ended, but not terminated\n', '        require(ended && !terminated);\n', '\t\t\n', '\t\t//Min duration between ended and terminated\n', '\t\trequire(block.number - endBlock >= minWaitDuration);\n', '\t\t\n', '\t\t//Only one call to this function\n', '        terminated = true;\n', '\n', '\t\t//Pick a winner\n', '\t\tif (players.length > 0)\n', '\t\t\twinner = players[randSeed % players.length];\n', '    }\n', '\t\n', '\t//Update pool state (only poolManager can call this when the money has been sent)\n', '\tfunction onMoneySent() public\n', '\t{\n', '\t\t//Only manager can call this\n', '\t\trequire(msg.sender == poolManager);\n', '\t\t\n', '\t\t//The pool must be terminated (winner picked)\n', '\t\trequire(terminated);\n', '\t\t\n', '\t\t//Update money sent (only one call to this function)\n', '\t\trequire(!moneySent);\n', '\t\tmoneySent = true;\n', '\t}\n', '}\n', '\n', '       \n', '//Wallet interface\n', 'contract WalletContract\n', '{\n', '\tfunction payMe() public payable;\n', '}\n', '\t   \n', '\t   \n', 'contract PoolManager {\n', '\n', '\t//Pool owner (address which manage the pool creation)\n', '    address owner;\n', '\t\n', '\t//Wallet which receive the fees (1% of ticket price)\n', '\taddress wallet;\n', '\t\n', '\t//Fees infos (external websites providing access to pools get 1% too)\n', '\tmapping(address => uint) fees;\n', '\t\t\n', '\t//Fees divider (1% for the wallet, and 1% for external website where player can buy tickets)\n', '\tuint constant feeDivider = 100; //(1/100 of the amount)\n', '\n', '\t//The ticket price for pools must be a multiple of 0.010205 ether (to avoid truncating the fees, and having a minimum to send to the winner)\n', '    uint constant ticketPriceMultiple = 10205000000000000; //(multiple of 0.010205 ether for ticketPrice)\n', '\n', '\t//Pools infos (current active pools. When a pool is done, it goes into the poolsDone array bellow and a new pool is created to replace it at the same index)\n', '\tSmartPool[] pools;\n', '\t\n', '\t//Ended pools (cleaned automatically after winners get their prices)\n', '\tSmartPool[] poolsDone;\n', '\t\n', '\t//History (contains all the pools since the deploy)\n', '\tSmartPool[] poolsHistory;\n', '\t\n', "\t//Current rand seed (it changes a lot so it's pretty hard to know its value when the winner is picked)\n", '\tuint randSeed;\n', '\n', '\t//Constructor (only owner)\n', '\tfunction PoolManager(address wal) public\n', '\t{\n', '\t\towner = msg.sender;\n', '\t\twallet = wal;\n', '\n', '\t\trandSeed = 0;\n', '\t}\n', '\t\n', '\t//Called frequently by other functions to keep the seed moving\n', '\tfunction updateSeed() private\n', '\t{\n', '\t\trandSeed += (uint(block.blockhash(block.number - 1)));\n', '\t}\n', '\t\n', '\t//Create a new pool (only owner can do this)\n', '\tfunction addPool(uint ticketPrice, uint ticketCount, uint duration) public\n', '\t{\n', '\t\trequire(msg.sender == owner);\n', '\t\trequire(ticketPrice >= ticketPriceMultiple && ticketPrice % ticketPriceMultiple == 0);\n', '\t\t\n', '\t\t//Deploy a new pool\n', '\t\tpools.push(new SmartPool(ticketPrice, ticketCount, duration));\n', '\t}\n', '\t\n', '\t//Accessors (public)\n', '\t\n', '\t//Get Active Pools\n', '\tfunction getPoolCount() public constant returns(uint)\n', '\t{\n', '\t\treturn pools.length;\n', '\t}\n', '\tfunction getPool(uint index) public constant returns(address)\n', '\t{\n', '\t\trequire(index < pools.length);\n', '\t\treturn pools[index];\n', '\t}\n', '\t\n', '\t//Get Ended Pools\n', '\tfunction getPoolDoneCount() public constant returns(uint)\n', '\t{\n', '\t\treturn poolsDone.length;\n', '\t}\n', '\tfunction getPoolDone(uint index) public constant returns(address)\n', '\t{\n', '\t\trequire(index < poolsDone.length);\n', '\t\treturn poolsDone[index];\n', '\t}\n', '\n', '\t//Get History\n', '\tfunction getPoolHistoryCount() public constant returns(uint)\n', '\t{\n', '\t\treturn poolsHistory.length;\n', '\t}\n', '\tfunction getPoolHistory(uint index) public constant returns(address)\n', '\t{\n', '\t\trequire(index < poolsHistory.length);\n', '\t\treturn poolsHistory[index];\n', '\t}\n', '\t\t\n', '\t//Buy tickets for a pool (public)\n', '\tfunction buyTicket(uint poolIndex, uint ticketCount, address websiteFeeAddr) public payable\n', '\t{\n', '\t\trequire(poolIndex < pools.length);\n', '\t\trequire(ticketCount > 0);\n', '\t\t\n', '\t\t//Get pool and check state\n', '\t\tSmartPool pool = pools[poolIndex];\n', '\t\tpool.checkEnd();\n', '\t\trequire (!pool.isEnded());\n', '\t\t\n', '\t\t//Adjust ticketCount according to available tickets\n', '\t\tuint availableCount = pool.getAvailableTicketCount();\n', '\t\tif (ticketCount > availableCount)\n', '\t\t\tticketCount = availableCount;\n', '\t\t\n', '\t\t//Get amount required and check msg.value\n', '\t\tuint amountRequired = ticketCount * pool.getTicketPrice();\n', '\t\trequire(msg.value >= amountRequired);\n', '\t\t\n', '\t\t//If too much value sent, we send it back to player\n', '\t\tuint amountLeft = msg.value - amountRequired;\n', '\t\t\n', '\t\t//if no websiteFeeAddr given, the wallet get the fee\n', '\t\tif (websiteFeeAddr == address(0))\n', '\t\t\twebsiteFeeAddr = wallet;\n', '\t\t\n', '\t\t//Compute fee\n', '\t\tuint feeAmount = amountRequired / feeDivider;\n', '\t\t\n', '\t\taddFee(websiteFeeAddr, feeAmount);\n', '\t\taddFee(wallet, feeAmount);\n', '\t\t\n', '\t\t//Add player to the pool with the amount minus the fees (1% + 1% = 2%)\n', '\t\tpool.addPlayer(msg.sender, ticketCount, amountRequired - 2 * feeAmount);\n', '\t\t\n', '\t\t//Send back amountLeft to player if too much value sent\n', '\t\tif (amountLeft > 0 && !msg.sender.send(amountLeft))\n', '\t\t{\n', '\t\t\taddFee(wallet, amountLeft); // if it fails, we take it as a fee..\n', '\t\t}\n', '\t\t\n', '\t\tupdateSeed();\n', '\t}\n', '\n', '\t//Check pools end. (called by our console each 10 minutes, or can be called by anybody)\n', '\tfunction checkPoolsEnd() public \n', '\t{\n', '\t\tfor (uint i = 0; i < pools.length; i++)\n', '\t\t{\n', '\t\t\t//Check each pool and restart the ended ones\n', '\t\t\tcheckPoolEnd(i);\n', '\t\t}\n', '\t}\n', '\t\n', "\t//Check end of a pool and restart it if it's ended (public)\n", '\tfunction checkPoolEnd(uint i) public \n', '\t{\n', '\t\trequire(i < pools.length);\n', '\t\t\n', '\t\t//Check end (if not triggered yet)\n', '\t\tSmartPool pool = pools[i];\n', '\t\tif (!pool.isEnded())\n', '\t\t\tpool.checkEnd();\n', '\t\t\t\n', '\t\tif (!pool.isEnded())\n', '\t\t{\n', '\t\t\treturn; // not ended yet\n', '\t\t}\n', '\t\t\n', '\t\tupdateSeed();\n', '\t\t\n', '\t\t//Store pool done and restart a pool to replace it\n', '\t\tpoolsDone.push(pool);\n', '\t\tpools[i] = new SmartPool(pool.getTicketPrice(), pool.getTicketCount(), pool.getDurationS());\n', '\t}\n', '\t\n', '\t//Check pools done. (called by our console, or can be called by anybody)\n', '\tfunction checkPoolsDone() public \n', '\t{\n', '\t\tfor (uint i = 0; i < poolsDone.length; i++)\n', '\t\t{\n', '\t\t\tcheckPoolDone(i);\n', '\t\t}\n', '\t}\n', '\t\n', '\t//Check end of one pool\n', '\tfunction checkPoolDone(uint i) public\n', '\t{\n', '\t\trequire(i < poolsDone.length);\n', '\t\t\n', '\t\tSmartPool pool = poolsDone[i];\n', '\t\tif (pool.isTerminated())\n', '\t\t\treturn; // already terminated\n', '\t\t\t\n', '\t\tif (!pool.canTerminate())\n', '\t\t\treturn; // we need to wait a bit more before random occurs, so the seed has changed enough (60 minutes before ended and terminated states)\n', '\t\t\t\n', '\t\tupdateSeed();\n', '\t\t\n', '\t\t//Terminate (pick a winner) and store pool done\n', '\t\tpool.terminate(randSeed);\n', '\t}\n', '\n', '\t//Send money of the pool to the winner (public)\n', '\tfunction sendPoolMoney(uint i) public\n', '\t{\n', '\t\trequire(i < poolsDone.length);\n', '\t\t\n', '\t\tSmartPool pool = poolsDone[i];\n', '\t\trequire (pool.isTerminated()); // we need a winner picked\n', '\t\t\n', '\t\trequire(!pool.isMoneySent()); // money not sent\n', '\t\t\n', '\t\tuint amount = pool.getCurrAmount();\n', '\t\taddress winner = pool.getWinner();\n', '\t\tpool.onMoneySent();\n', "\t\tif (amount > 0 && !winner.send(amount)) // the winner can't get his money (should not happen)\n", '\t\t{\n', '\t\t\taddFee(wallet, amount);\n', '\t\t}\n', '\t\t\n', '\t\t//Pool goes into history array\n', '\t\tpoolsHistory.push(pool);\n', '\t}\n', '\t\t\n', '\t//Clear pools done array (called once a week by our console, or can be called by anybody)\n', '\tfunction clearPoolsDone() public\n', '\t{\n', '\t\t//Make sure all pools are terminated with no money left\n', '\t\tfor (uint i = 0; i < poolsDone.length; i++)\n', '\t\t{\n', '\t\t\tif (!poolsDone[i].isMoneySent())\n', '\t\t\t\treturn;\n', '\t\t}\n', '\t\t\n', '\t\t//"Clear" poolsDone array (just reset the length, instances will be override)\n', '\t\tpoolsDone.length = 0;\n', '\t}\n', '\t\n', '\t//Get current fee value\n', '\tfunction getFeeValue(address a) public constant returns (uint)\n', '\t{\n', '\t\tif (a == address(0))\n', '\t\t\ta = msg.sender;\n', '\t\treturn fees[a];\n', '\t}\n', '\n', '\t//Send fee to address (public, with a min amount required)\n', '\tfunction getMyFee(address a) public\n', '\t{\n', '\t\tif (a == address(0))\n', '\t\t\ta = msg.sender;\n', '\t\tuint amount = fees[a];\n', '\t\trequire (amount > 0);\n', '\t\t\n', '\t\tfees[a] = 0;\n', '\t\t\n', '\t\tif (a == wallet)\n', '\t\t{\n', '\t\t\tWalletContract walletContract = WalletContract(a);\n', '\t\t\twalletContract.payMe.value(amount)();\n', '\t\t}\n', '\t\telse if (!a.send(amount))\n', "\t\t\taddFee(wallet, amount); // the fee can't be sent (hacking attempt?), so we take it... :-p\n", '\t}\n', '\t\n', '\t//Add fee (private)\n', '\tfunction addFee(address a, uint fee) private\n', '\t{\n', '\t\tif (fees[a] == 0)\n', '\t\t\tfees[a] = fee;\n', '\t\telse\n', "\t\t\tfees[a] += fee; // we don't check for overflow, if you're billionaire in fees, call getMyFee sometimes :-)\n", '\t}\n', '}']
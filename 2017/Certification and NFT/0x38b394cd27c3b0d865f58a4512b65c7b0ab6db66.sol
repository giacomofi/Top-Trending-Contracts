['//A BurnableOpenPayment is instantiated with a specified payer and a serviceDeposit.\n', '//The worker is not set when the contract is instantiated.\n', '\n', '//The constructor is payable, so the contract can be instantiated with initial funds.\n', '//In addition, anyone can add more funds to the Payment by calling addFunds.\n', '\n', '//All behavior of the contract is directed by the payer, but\n', '//the payer can never directly recover the payment,\n', '//unless he calls the recover() function before anyone else commit()s.\n', '\n', '//If the BOP is in the Open state,\n', '//anyone can become the worker by contributing the serviceDeposit with commit().\n', '//This changes the state from Open to Committed. The BOP will never return to the Open state.\n', "//The worker will never be changed once it's been set via commit().\n", '\n', '//In the committed state,\n', '//the payer can at any time choose to burn or release to the worker any amount of funds.\n', '\n', 'pragma solidity ^ 0.4.10;\n', 'contract BurnableOpenPaymentFactory {\n', '\tevent NewBOP(address indexed newBOPAddress, address payer, uint serviceDeposit, uint autoreleaseTime, string title, string initialStatement);\n', '\n', '\t//contract address array\n', '\taddress[]public BOPs;\n', '\n', '\tfunction getBOPCount()\n', '\tpublic\n', '\tconstant\n', '\treturns(uint) {\n', '\t\treturn BOPs.length;\n', '\t}\n', '\n', '\tfunction newBurnableOpenPayment(address payer, uint serviceDeposit, uint autoreleaseInterval, string title, string initialStatement)\n', '\tpublic\n', '\tpayable\n', '\treturns(address) {\n', '\t\t//pass along any ether to the constructor\n', '\t\taddress newBOPAddr = (new BurnableOpenPayment).value(msg.value)(payer, serviceDeposit, autoreleaseInterval, title, initialStatement);\n', '\t\tNewBOP(newBOPAddr, payer, serviceDeposit, autoreleaseInterval, title, initialStatement);\n', '\n', '\t\t//save created BOPs in contract array\n', '\t\tBOPs.push(newBOPAddr);\n', '\n', '\t\treturn newBOPAddr;\n', '\t}\n', '}\n', '\n', 'contract BurnableOpenPayment {\n', '    //title will never change\n', '    string public title;\n', '    \n', '\t//BOP will start with a payer but no worker (worker==0x0)\n', '\taddress public payer;\n', '\taddress public worker;\n', '\taddress constant burnAddress = 0x0;\n', '\t\n', '\t//Set to true if fundsRecovered is called\n', '\tbool recovered = false;\n', '\n', '\t//Note that these will track, but not influence the BOP logic.\n', '\tuint public amountDeposited;\n', '\tuint public amountBurned;\n', '\tuint public amountReleased;\n', '\n', '\t//Amount of ether a prospective worker must pay to permanently become the worker. See commit().\n', '\tuint public serviceDeposit;\n', '\n', '\t//How long should we wait before allowing the default release to be called?\n', '\tuint public autoreleaseInterval;\n', '\n', '\t//Calculated from autoreleaseInterval in commit(),\n', '\t//and recaluclated whenever the payer (or possibly the worker) calls delayhasDefaultRelease()\n', '\t//After this time, auto-release can be called by the Worker.\n', '\tuint public autoreleaseTime;\n', '\n', '\t//Most action happens in the Committed state.\n', '\tenum State {\n', '\t\tOpen,\n', '\t\tCommitted,\n', '\t\tClosed\n', '\t}\n', '\tState public state;\n', '\t//Note that a BOP cannot go from Committed back to Open, but it can go from Closed back to Committed\n', '\t//(this would retain the committed worker). Search for Closed and Unclosed events to see how this works.\n', '\n', '\tmodifier inState(State s) {\n', '\t\trequire(s == state);\n', '\t\t_;\n', '\t}\n', '\tmodifier onlyPayer() {\n', '\t\trequire(msg.sender == payer);\n', '\t\t_;\n', '\t}\n', '\tmodifier onlyWorker() {\n', '\t\trequire(msg.sender == worker);\n', '\t\t_;\n', '\t}\n', '\tmodifier onlyPayerOrWorker() {\n', '\t\trequire((msg.sender == payer) || (msg.sender == worker));\n', '\t\t_;\n', '\t}\n', '\n', '\tevent Created(address indexed contractAddress, address payer, uint serviceDeposit, uint autoreleaseInterval, string title);\n', '\tevent FundsAdded(address from, uint amount); //The payer has added funds to the BOP.\n', '\tevent PayerStatement(string statement);\n', '\tevent WorkerStatement(string statement);\n', '\tevent FundsRecovered();\n', '\tevent Committed(address worker);\n', '\tevent FundsBurned(uint amount);\n', '\tevent FundsReleased(uint amount);\n', '\tevent Closed();\n', '\tevent Unclosed();\n', '\tevent AutoreleaseDelayed();\n', '\tevent AutoreleaseTriggered();\n', '\n', '\tfunction BurnableOpenPayment(address _payer, uint _serviceDeposit, uint _autoreleaseInterval, string _title, string initialStatement)\n', '\tpublic\n', '\tpayable {\n', '\t\tCreated(this, _payer, _serviceDeposit, _autoreleaseInterval, _title);\n', '\n', '\t\tif (msg.value > 0) {\n', '\t\t    //Here we use tx.origin instead of msg.sender (msg.sender is just the factory contract)\n', '\t\t\tFundsAdded(tx.origin, msg.value);\n', '\t\t\tamountDeposited += msg.value;\n', '\t\t}\n', '\t\t\n', '\t\ttitle = _title;\n', '\n', '\t\tstate = State.Open;\n', '\t\tpayer = _payer;\n', '\n', '\t\tserviceDeposit = _serviceDeposit;\n', '\n', '\t\tautoreleaseInterval = _autoreleaseInterval;\n', '\n', '\t\tif (bytes(initialStatement).length > 0)\n', '\t\t    PayerStatement(initialStatement);\n', '\t}\n', '\n', '\tfunction getFullState()\n', '\tpublic\n', '\tconstant\n', '\treturns(address, string, State, address, uint, uint, uint, uint, uint, uint, uint) {\n', '\t\treturn (payer, title, state, worker, this.balance, serviceDeposit, amountDeposited, amountBurned, amountReleased, autoreleaseInterval, autoreleaseTime);\n', '\t}\n', '\n', '\tfunction addFunds()\n', '\tpublic\n', '\tpayable {\n', '\t\trequire(msg.value > 0);\n', '\n', '\t\tFundsAdded(msg.sender, msg.value);\n', '\t\tamountDeposited += msg.value;\n', '\t\tif (state == State.Closed) {\n', '\t\t\tstate = State.Committed;\n', '\t\t\tUnclosed();\n', '\t\t}\n', '\t}\n', '\n', '\tfunction recoverFunds()\n', '\tpublic\n', '\tonlyPayer()\n', '\tinState(State.Open) {\n', '\t    recovered = true;\n', '\t\tFundsRecovered();\n', '\t\tselfdestruct(payer);\n', '\t}\n', '\n', '\tfunction commit()\n', '\tpublic\n', '\tinState(State.Open)\n', '\tpayable{\n', '\t\trequire(msg.value == serviceDeposit);\n', '\n', '\t\tif (msg.value > 0) {\n', '\t\t\tFundsAdded(msg.sender, msg.value);\n', '\t\t\tamountDeposited += msg.value;\n', '\t\t}\n', '\n', '\t\tworker = msg.sender;\n', '\t\tstate = State.Committed;\n', '\t\tCommitted(worker);\n', '\n', '\t\tautoreleaseTime = now + autoreleaseInterval;\n', '\t}\n', '\n', '\tfunction internalBurn(uint amount)\n', '\tprivate\n', '\tinState(State.Committed) {\n', '\t\tburnAddress.transfer(amount);\n', '\n', '\t\tamountBurned += amount;\n', '\t\tFundsBurned(amount);\n', '\n', '\t\tif (this.balance == 0) {\n', '\t\t\tstate = State.Closed;\n', '\t\t\tClosed();\n', '\t\t}\n', '\t}\n', '\n', '\tfunction burn(uint amount)\n', '\tpublic\n', '\tinState(State.Committed)\n', '\tonlyPayer() {\n', '\t\tinternalBurn(amount);\n', '\t}\n', '\n', '\tfunction internalRelease(uint amount)\n', '\tprivate\n', '\tinState(State.Committed) {\n', '\t\tworker.transfer(amount);\n', '\n', '\t\tamountReleased += amount;\n', '\t\tFundsReleased(amount);\n', '\n', '\t\tif (this.balance == 0) {\n', '\t\t\tstate = State.Closed;\n', '\t\t\tClosed();\n', '\t\t}\n', '\t}\n', '\n', '\tfunction release(uint amount)\n', '\tpublic\n', '\tinState(State.Committed)\n', '\tonlyPayer() {\n', '\t\tinternalRelease(amount);\n', '\t}\n', '\n', '\tfunction logPayerStatement(string statement)\n', '\tpublic\n', '\tonlyPayer() {\n', '\t    PayerStatement(statement);\n', '\t}\n', '\n', '\tfunction logWorkerStatement(string statement)\n', '\tpublic\n', '\tonlyWorker() {\n', '\t\tWorkerStatement(statement);\n', '\t}\n', '\n', '\tfunction delayAutorelease()\n', '\tpublic\n', '\tonlyPayer()\n', '\tinState(State.Committed) {\n', '\t\tautoreleaseTime = now + autoreleaseInterval;\n', '\t\tAutoreleaseDelayed();\n', '\t}\n', '\n', '\tfunction triggerAutorelease()\n', '\tpublic\n', '\tonlyWorker()\n', '\tinState(State.Committed) {\n', '\t\trequire(now >= autoreleaseTime);\n', '\n', '        AutoreleaseTriggered();\n', '\t\tinternalRelease(this.balance);\n', '\t}\n', '}']
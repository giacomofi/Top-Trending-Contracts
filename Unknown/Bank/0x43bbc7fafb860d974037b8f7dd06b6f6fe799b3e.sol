['// A Ponzi scheme where old investors are payed with the funds received from new investors.\n', '// Unlike what is out there in the market, the contract creator received no funds - if you\n', "// don't do work, you cannot expect to be paid. People who put in the funds receive all the\n", '// returns. Owners can particiapte themselves, there is no leaching off the top and slowing\n', '// down payouts for the participants.\n', 'contract ZeroPonzi {\n', '  // minimum & maxium entry values\n', '  uint public constant MIN_VALUE = 100 finney;\n', '  uint public constant MAX_VALUE = 10 ether;\n', '\n', '  // the return multiplier & divisors, yielding 1.25 (125%) returns\n', '  uint public constant RET_MUL = 125;\n', '  uint public constant RET_DIV = 100;\n', '\n', '  // entry structure, storing the address & yield\n', '  struct Payout {\n', '    address addr;\n', '    uint yield;\n', '  }\n', '\n', '  // our actual queued payouts, index of current & total distributed\n', '  Payout[] public payouts;\n', '  uint public payoutIndex = 0;\n', '  uint public payoutTotal = 0;\n', '\n', '  // construtor, no additional requirements\n', '  function ZeroPonzi() {\n', '  }\n', '\n', '  // single entry point, add entry & pay what we can\n', '  function() {\n', '    // we only accept values in range\n', '    if ((msg.value < MIN_VALUE) || (msg.value > MAX_VALUE)) {\n', '      throw;\n', '    }\n', '\n', '    // queue the current entry as a future payout recipient\n', '    uint entryIndex = payouts.length;\n', '    payouts.length += 1;\n', '    payouts[entryIndex].addr = msg.sender;\n', '    payouts[entryIndex].yield = (msg.value * RET_MUL) / RET_DIV;\n', '\n', '    // send payouts while we can afford to do so\n', '    while (payouts[payoutIndex].yield < this.balance) {\n', '      payoutTotal += payouts[payoutIndex].yield;\n', '      payouts[payoutIndex].addr.send(payouts[payoutIndex].yield);\n', '      payoutIndex += 1;\n', '    }\n', '  }\n', '}']
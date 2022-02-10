['pragma solidity ^0.4.7;\n', '\n', 'contract bet_various{\n', '    enum State { Started, Locked }\n', '  State public state = State.Started;\n', '  struct Guess{\n', '    address addr;\n', '    uint    guess;\n', '  }\n', '  uint arraysize=1000;\n', '  uint constant maxguess=1000000;\n', '  uint bettingprice = 0.01 ether;\n', '  Guess[1000] guesses;\n', '  uint    numguesses = 0;\n', '  bytes32 curhash = &#39;&#39;;\n', '  \n', '  uint stasticsarrayitems = 20;\n', '  uint[20] statistics;\n', '\n', '  uint _gameindex = 1;\n', '  \n', '  struct Winner{\n', '    address addr;\n', '  }\n', '  Winner[1000] winnners;\n', '  uint    numwinners = 0;\n', '\n', '  modifier inState(State _state) {\n', '      require(state == _state);\n', '      _;\n', '  }\n', ' \n', '  address developer = 0x0;\n', '  event SentPrizeToWinner(address winner, uint money, uint guess, uint gameindex, uint lotterynumber, uint timestamp);\n', '  event SentDeveloperFee(uint amount, uint balance);\n', '\n', '  function bet_various() \n', '  {\n', '    if(developer==address(0)){\n', '      developer = msg.sender;\n', '    }\n', '  }\n', '\n', '  function setBettingCondition(uint _contenders, uint _bettingprice)\n', '  {\n', '    if(msg.sender != developer)\n', '      return;\n', '  \tarraysize  = _contenders;\n', '  \tif(arraysize>1000)\n', '  \t  arraysize = 1000;\n', '  \tbettingprice = _bettingprice;\n', '  }\n', '  \n', '  function getMaxContenders() constant returns(uint){\n', '  \treturn arraysize;\n', '  }\n', '\n', '  function getBettingPrice() constant returns(uint){\n', '  \treturn bettingprice;\n', '  }\n', '    \n', '  function findWinners(uint value) returns (uint)\n', '  {\n', '    numwinners = 0;\n', '    uint lastdiff = maxguess;\n', '    uint i = 0;\n', '    int diff = 0;\n', '    uint guess = 0;\n', '    for (i = 0; i < numguesses; i++) {\n', '      diff = (int)((int)(value)-(int)(guesses[i].guess));\n', '      if(diff<0)\n', '        diff = diff*-1;\n', '      if(lastdiff>(uint)(diff)){\n', '        guess = guesses[i].guess;\n', '        lastdiff = (uint)(diff);\n', '      }\n', '    }\n', '    \n', '    for (i = 0; i < numguesses; i++) {\n', '      diff = (int)((int)(value)-(int)(guesses[i].guess));\n', '      if(diff<0)\n', '        diff = diff*-1;\n', '      if(lastdiff==uint(diff)){\n', '        winnners[numwinners++].addr = guesses[i].addr;\n', '      }\n', '    }\n', '    return guess;\n', '  }\n', '  \n', '  function getDeveloperAddress() constant returns(address)\n', '  {\n', '    return developer;\n', '  }\n', '  \n', '  function getDeveloperFee() constant returns(uint)\n', '  {\n', '    uint developerfee = this.balance/100;\n', '    return developerfee;\n', '  }\n', '  \n', '  function getBalance() constant returns(uint)\n', '  {\n', '     return this.balance;\n', '  }\n', '  \n', '  function getLotteryMoney() constant returns(uint)\n', '  {\n', '    uint developerfee = getDeveloperFee();\n', '    uint prize = (this.balance - developerfee)/(numwinners<1?1:numwinners);\n', '    return prize;\n', '  }\n', '\n', '  function getBettingStastics() \n', '    payable\n', '    returns(uint[20])\n', '  {\n', '    require(msg.value == bettingprice*3);\n', '    return statistics;\n', '  }\n', '  \n', '  function getBettingStatus()\n', '    constant\n', '    returns (uint, uint, uint, uint, uint)\n', '  {\n', '    return ((uint)(state), numguesses, getLotteryMoney(), this.balance, bettingprice);\n', '  }\n', '  \n', '  function finish()\n', '  {\n', '    state = State.Locked;\n', '\n', '    uint lotterynumber = (uint(curhash)+block.timestamp)%(maxguess+1);\n', '    // now that we know the random number was safely generate, let&#39;s do something with the random number..\n', '    var guess = findWinners(lotterynumber);\n', '    uint prize = getLotteryMoney();\n', '    uint remain = this.balance - (prize*numwinners);\n', '    for (uint i = 0; i < numwinners; i++) {\n', '      address winner = winnners[i].addr;\n', '      winner.transfer(prize);\n', '      SentPrizeToWinner(winner, prize, guess, _gameindex, lotterynumber, block.timestamp);\n', '    }\n', '    // give delveoper the money left behind\n', '    SentDeveloperFee(remain, this.balance);\n', '    developer.transfer(remain); \n', '    \n', '    numguesses = 0;\n', '    for (i = 0; i < stasticsarrayitems; i++) {\n', '      statistics[i] = 0;\n', '    }\n', '    _gameindex++;\n', '    state = State.Started;\n', '  }\n', '\n', '  function addguess(uint guess) \n', '    inState(State.Started)\n', '    payable\n', '  {\n', '    require(msg.value == bettingprice);\n', '    \n', '    uint divideby = maxguess/stasticsarrayitems;\n', '    curhash = sha256(block.timestamp, block.coinbase, block.difficulty, curhash);\n', '    if((uint)(numguesses+1)<=arraysize) {\n', '      guesses[numguesses++] = Guess(msg.sender, guess);\n', '      uint statindex = guess / divideby;\n', '      if(statindex>=stasticsarrayitems) statindex = stasticsarrayitems-1;\n', '      statistics[statindex] ++;\n', '      if((uint)(numguesses)>=arraysize){\n', '        finish();\n', '      }\n', '    }\n', '  }\n', '}']
['pragma solidity ^0.4.22;\n', '\n', 'contract Game302 {\n', '\tstruct GameInfo {\n', '\t    uint funderNum;\n', '\t\tmapping(uint => address) funder;\n', '\t\tmapping(uint => address) winner;\n', '\t}\n', '\n', '\tGameInfo[] public games;\n', '\tuint public gameNum = 0;\n', '\tmapping(address => uint) public lastGame;\n', '\tmapping(address => uint) public funderBalance;\n', '\tmapping(address => address) public referrer;\n', '\n', '\taddress public manager;\n', '\tuint count = 10000000000000000 / 5;\n', '\n', '\tconstructor() public {\n', '\t\tmanager = msg.sender;\n', '\t\treferrer[manager] = manager;\n', '\t\tgames.push(GameInfo(0));\n', '\t}\n', '\n', '\tfunction addIn(address referr) public payable returns (bool){\n', '\t\trequire(\n', '\t\t\tmsg.value == 100 * count,\n', '\t\t\t"ETH count is wrong!"\n', '\t\t);\n', '\t\tif(lastGame[msg.sender] == 0){\n', '\t\t\tif(referr == msg.sender){\n', '\t\t\t\treferrer[msg.sender] = manager;\n', '\t\t\t}\n', '\t\t\telse {\n', '\t\t\t\treferrer[msg.sender] = referr;\n', '\t\t\t}\n', '\t\t\t\n', '\t\t}\n', '\t\tgames[gameNum].funder[games[gameNum].funderNum] = msg.sender;\n', '\t\tgames[gameNum].funderNum += 1;\n', '\t\tlastGame[msg.sender] = gameNum;\n', '\t\tif (games[gameNum].funderNum == 3) {\n', '\t\t\tuint winNum = (now + gameNum)%3;\n', '\t\t\tgames[gameNum].winner[0] = games[gameNum].funder[winNum];\n', '\t\t\tfunderBalance[games[gameNum].winner[0]] += 285 * count;\n', '\t\t\tfunderBalance[manager] += 3 * count;\n', '\t\t\tfor(uint8 i=0;i<3;i++){\n', '\t\t\t\taddress addr = referrer[games[gameNum].funder[i]];\n', '\t\t\t\tfunderBalance[addr] += count;\n', '\t\t\t\tfunderBalance[referrer[addr]] += count;\n', '\t\t\t\tfunderBalance[referrer[referrer[addr]]] += count / 2;\n', '\t\t\t\tfunderBalance[referrer[referrer[referrer[addr]]]] += count / 2;\n', '\t\t\t\tfunderBalance[referrer[referrer[referrer[referrer[addr]]]]] += count / 2;\n', '\t\t\t\tfunderBalance[referrer[referrer[referrer[referrer[referrer[addr]]]]]] += count / 2;\n', '\t\t\t}\n', '\t\t\tgameNum += 1;\n', '\t\t\tgames.push(GameInfo(0));\n', '\t\t}\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction withdraw(uint amount) public {\n', '\t\trequire(\n', '\t\t\tfunderBalance[msg.sender] >= amount,\n', '\t\t\t"ETH Out of balance!"\n', '\t\t);\n', '\t\tfunderBalance[msg.sender] += -amount;\n', '        msg.sender.transfer(amount);\n', '    }\n', '\n', '\tfunction getLastGame() public view returns (uint last, uint num, uint balance, address winer){\n', '\t\tlast = lastGame[msg.sender];\n', '\t\tGameInfo storage  game = games[lastGame[msg.sender]];\n', '\t\tnum = game.funderNum;\n', '\t\tif(game.funderNum == 3){\n', '\t\t\twiner = game.winner[0];\n', '\t\t}\n', '\t\tbalance = funderBalance[msg.sender];\n', '\t}\n', '\n', '\tfunction getNewGame() public view returns (uint last, uint num, address winer){\n', '\t\tlast = gameNum;\n', '\t\tGameInfo storage  game = games[gameNum];\n', '\t\tnum = game.funderNum;\n', '\t\tif(game.funderNum == 3){\n', '\t\t\twiner = game.winner[0];\n', '\t\t}\n', '\t}\n', '}']
['pragma solidity ^0.4.2;\n', '\n', '\n', 'contract owned {\n', '\taddress public owner;\n', '\taddress public server;\n', '\n', '\tfunction owned() {\n', '\t\towner = msg.sender;\n', '\t\tserver = msg.sender;\n', '\t}\n', '\n', '\tfunction changeOwner(address newOwner) onlyOwner {\n', '\t\towner = newOwner;\n', '\t}\n', '\n', '\tfunction changeServer(address newServer) onlyOwner {\n', '\t\tserver = newServer;\n', '\t}\n', '\n', '\tmodifier onlyOwner {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '\n', '\tmodifier onlyServer {\n', '\t\trequire(msg.sender == server);\n', '\t\t_;\n', '\t}\n', '}\n', '\n', '\n', 'contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}\n', '\n', '\n', 'contract CSToken is owned {uint8 public decimals;\n', '\n', '\tuint[] public agingTimes;\n', '\n', '\taddress[] public addressByIndex;\n', '\n', '\tfunction balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '\tfunction mintToken(address target, uint256 mintedAmount, uint agingTime);\n', '\n', '\tfunction addAgingTime(uint time);\n', '\n', '\tfunction allAgingTimesAdded();\n', '\n', '\tfunction addAgingTimesForPool(address poolAddress, uint agingTime);\n', '\n', '\tfunction countAddresses() constant returns (uint256 length);\n', '}\n', '\n', '\n', 'contract KickicoCrowdsale is owned {\n', '\tuint[] public IcoStagePeriod;\n', '\n', '\tbool public IcoClosedManually = false;\n', '\n', '\tuint public threshold = 160000 ether;\n', '\tuint public goal = 15500 ether;\n', '\n', '\tuint public totalCollected = 0;\n', '\n', '\tuint public pricePerTokenInWei = 3333333;\n', '\n', '\tuint public agingTime = 1539594000;\n', '\n', '\tuint prPoolAgingTime = 1513242000;\n', '\n', '\tuint advisoryPoolAgingTime = 1535533200;\n', '\n', '\tuint bountiesPoolAgingTime = 1510736400;\n', '\n', '\tuint lotteryPoolAgingTime = 1512118800;\n', '\n', '\tuint angelInvestorsPoolAgingTime = 1506848400;\n', '\n', '\tuint foundersPoolAgingTime = 1535533200;\n', '\n', '\tuint chinaPoolAgingTime = 1509526800;\n', '\n', '\tuint[] public bonuses;\n', '\n', '\tuint[] public bonusesAfterClose;\n', '\n', '\taddress public prPool;\n', '\n', '\taddress public founders;\n', '\n', '\taddress public advisory;\n', '\n', '\taddress public bounties;\n', '\n', '\taddress public lottery;\n', '\n', '\taddress public angelInvestors;\n', '\n', '\taddress public china;\n', '\n', '\tuint tokenMultiplier = 10;\n', '\n', '\tCSToken public tokenReward;\n', '\tCSToken public oldTokenReward;\n', '\n', '\tmapping (address => uint256) public balanceOf;\n', '\n', '\tevent FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '\tbool parametersHaveBeenSet = false;\n', '\n', '\tfunction KickicoCrowdsale(address _tokenAddress, address _prPool, address _founders, address _advisory, address _bounties, address _lottery, address _angelInvestors, address _china, address _oldTokenAddress) {\n', '\t\ttokenReward = CSToken(_tokenAddress);\n', '\t\toldTokenReward = CSToken(_oldTokenAddress);\n', '\n', '\t\ttokenMultiplier = tokenMultiplier ** tokenReward.decimals();\n', '\n', '\t\t// bind pools\n', '\t\tprPool = _prPool;\n', '\t\tfounders = _founders;\n', '\t\tadvisory = _advisory;\n', '\t\tbounties = _bounties;\n', '\t\tlottery = _lottery;\n', '\t\tangelInvestors = _angelInvestors;\n', '\t\tchina = _china;\n', '\t}\n', '\n', '\tfunction setParams() onlyOwner {\n', '\t\trequire(!parametersHaveBeenSet);\n', '\n', '\t\tparametersHaveBeenSet = true;\n', '\n', '\t\ttokenReward.addAgingTimesForPool(prPool, prPoolAgingTime);\n', '\t\ttokenReward.addAgingTimesForPool(advisory, advisoryPoolAgingTime);\n', '\t\ttokenReward.addAgingTimesForPool(bounties, bountiesPoolAgingTime);\n', '\t\ttokenReward.addAgingTimesForPool(lottery, lotteryPoolAgingTime);\n', '\t\ttokenReward.addAgingTimesForPool(angelInvestors, angelInvestorsPoolAgingTime);\n', '\n', '\t\t// mint to pools\n', '\t\ttokenReward.mintToken(advisory, 10000000 * tokenMultiplier, 0);\n', '\t\ttokenReward.mintToken(bounties, 25000000 * tokenMultiplier, 0);\n', '\t\ttokenReward.mintToken(lottery, 1000000 * tokenMultiplier, 0);\n', '\t\ttokenReward.mintToken(angelInvestors, 30000000 * tokenMultiplier, 0);\n', '\t\ttokenReward.mintToken(prPool, 23000000 * tokenMultiplier, 0);\n', '\t\ttokenReward.mintToken(china, 8000000 * tokenMultiplier, 0);\n', '\t\ttokenReward.mintToken(founders, 5000000 * tokenMultiplier, 0);\n', '\n', '\t\ttokenReward.addAgingTime(agingTime);\n', '\t\ttokenReward.addAgingTime(prPoolAgingTime);\n', '\t\ttokenReward.addAgingTime(advisoryPoolAgingTime);\n', '\t\ttokenReward.addAgingTime(bountiesPoolAgingTime);\n', '\t\ttokenReward.addAgingTime(lotteryPoolAgingTime);\n', '\t\ttokenReward.addAgingTime(angelInvestorsPoolAgingTime);\n', '\t\ttokenReward.addAgingTime(foundersPoolAgingTime);\n', '\t\ttokenReward.addAgingTime(chinaPoolAgingTime);\n', '\t\ttokenReward.allAgingTimesAdded();\n', '\n', '\t\tIcoStagePeriod.push(1504011600);\n', '\t\tIcoStagePeriod.push(1506718800);\n', '\n', '\t\tbonuses.push(1990 finney);\n', '\t\tbonuses.push(2990 finney);\n', '\t\tbonuses.push(4990 finney);\n', '\t\tbonuses.push(6990 finney);\n', '\t\tbonuses.push(9500 finney);\n', '\t\tbonuses.push(14500 finney);\n', '\t\tbonuses.push(19500 finney);\n', '\t\tbonuses.push(29500 finney);\n', '\t\tbonuses.push(49500 finney);\n', '\t\tbonuses.push(74500 finney);\n', '\t\tbonuses.push(99 ether);\n', '\t\tbonuses.push(149 ether);\n', '\t\tbonuses.push(199 ether);\n', '\t\tbonuses.push(299 ether);\n', '\t\tbonuses.push(499 ether);\n', '\t\tbonuses.push(749 ether);\n', '\t\tbonuses.push(999 ether);\n', '\t\tbonuses.push(1499 ether);\n', '\t\tbonuses.push(1999 ether);\n', '\t\tbonuses.push(2999 ether);\n', '\t\tbonuses.push(4999 ether);\n', '\t\tbonuses.push(7499 ether);\n', '\t\tbonuses.push(9999 ether);\n', '\t\tbonuses.push(14999 ether);\n', '\t\tbonuses.push(19999 ether);\n', '\t\tbonuses.push(49999 ether);\n', '\t\tbonuses.push(99999 ether);\n', '\n', '\t\tbonusesAfterClose.push(200);\n', '\t\tbonusesAfterClose.push(100);\n', '\t\tbonusesAfterClose.push(75);\n', '\t\tbonusesAfterClose.push(50);\n', '\t\tbonusesAfterClose.push(25);\n', '\t}\n', '\n', '\tfunction mint(uint amount, uint tokens, address sender) internal {\n', '\t\tbalanceOf[sender] += amount;\n', '\t\ttotalCollected += amount;\n', '\t\ttokenReward.mintToken(sender, tokens, agingTime);\n', '\t\ttokenReward.mintToken(founders, tokens / 10, foundersPoolAgingTime);\n', '\t}\n', '\n', '\tfunction contractBalance() constant returns (uint256 balance) {\n', '\t\treturn this.balance;\n', '\t}\n', '\n', '\tfunction processPayment(address from, uint amount, bool isCustom) internal {\n', '\t\tif(!isCustom)\n', '\t\tFundTransfer(from, amount, true);\n', '\t\tuint original = amount;\n', '\n', '\t\tuint _price = pricePerTokenInWei;\n', '\t\tuint remain = threshold - totalCollected;\n', '\t\tif (remain < amount) {\n', '\t\t\tamount = remain;\n', '\t\t}\n', '\n', '\t\tfor (uint i = 0; i < bonuses.length; i++) {\n', '\t\t\tif (amount < bonuses[i]) break;\n', '\n', '\t\t\tif (amount >= bonuses[i] && (i == bonuses.length - 1 || amount < bonuses[i + 1])) {\n', '\t\t\t\tif (i < 15) {\n', '\t\t\t\t\t_price = _price * 1000 / (1000 + ((i + 1 + (i > 11 ? 1 : 0)) * 5));\n', '\t\t\t\t}\n', '\t\t\t\telse {\n', '\t\t\t\t\t_price = _price * 1000 / (1000 + ((8 + i - 14) * 10));\n', '\t\t\t\t}\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\tuint tokenAmount = amount / _price;\n', '\t\tuint currentAmount = tokenAmount * _price;\n', '\t\tmint(currentAmount, tokenAmount + tokenAmount * getBonusByRaised() / 1000, from);\n', '\t\tuint change = original - currentAmount;\n', '\t\tif (change > 0 && !isCustom) {\n', '\t\t\tif (from.send(change)) {\n', '\t\t\t\tFundTransfer(from, change, false);\n', '\t\t\t}\n', '\t\t\telse revert();\n', '\t\t}\n', '\t}\n', '\n', '\tfunction getBonusByRaised() internal returns (uint256) {\n', '\t\treturn 0;\n', '\t}\n', '\n', '\tfunction closeICO() onlyOwner {\n', '\t\trequire(now >= IcoStagePeriod[0] && now < IcoStagePeriod[1] && !IcoClosedManually);\n', '\t\tIcoClosedManually = true;\n', '\t}\n', '\n', '\tfunction safeWithdrawal(uint amount) onlyOwner {\n', '\t\trequire(this.balance >= amount);\n', '\n', '\t\t// lock withdraw if stage not closed\n', '\t\tif (now >= IcoStagePeriod[0] && now < IcoStagePeriod[1])\n', '\t\trequire(IcoClosedManually || isReachedThreshold());\n', '\n', '\t\tif (owner.send(amount)) {\n', '\t\t\tFundTransfer(msg.sender, amount, false);\n', '\t\t}\n', '\t}\n', '\n', '\tfunction isReachedThreshold() internal returns (bool reached) {\n', '\t\treturn pricePerTokenInWei > (threshold - totalCollected);\n', '\t}\n', '\n', '\tfunction isIcoClosed() constant returns (bool closed) {\n', '\t\treturn (now >= IcoStagePeriod[1] || IcoClosedManually || isReachedThreshold());\n', '\t}\n', '\n', '\tbool public allowManuallyMintTokens = true;\n', '\tfunction mintTokens(address[] recipients) onlyServer {\n', '\t\trequire(allowManuallyMintTokens);\n', '\t\tfor(uint i = 0; i < recipients.length; i++) {\n', '\t\t\ttokenReward.mintToken(recipients[i], oldTokenReward.balanceOf(recipients[i]), 1538902800);\n', '\t\t}\n', '\t}\n', '\n', '\tfunction disableManuallyMintTokens() onlyOwner {\n', '\t\tallowManuallyMintTokens = false;\n', '\t}\n', '\n', '\tfunction() payable {\n', '\t\trequire(parametersHaveBeenSet);\n', '\t\trequire(msg.value >= 50 finney);\n', '\n', '\t\t// validate by stage periods\n', '\t\trequire(now >= IcoStagePeriod[0] && now < IcoStagePeriod[1]);\n', '\t\t// validate if closed manually or reached the threshold\n', '\t\trequire(!IcoClosedManually);\n', '\t\trequire(!isReachedThreshold());\n', '\n', '\t\tprocessPayment(msg.sender, msg.value, false);\n', '\t}\n', '\n', '\tfunction changeTokenOwner(address _owner) onlyOwner {\n', '\t\ttokenReward.changeOwner(_owner);\n', '\t}\n', '\n', '\tfunction changeOldTokenReward(address _token) onlyOwner {\n', '\t\toldTokenReward = CSToken(_token);\n', '\t}\n', '\n', '\tfunction kill() onlyOwner {\n', '\t\trequire(isIcoClosed());\n', '\t\tif(this.balance > 0) {\n', '\t\t\towner.transfer(this.balance);\n', '\t\t}\n', '\t\tchangeTokenOwner(owner);\n', '\t\tselfdestruct(owner);\n', '\t}\n', '}']
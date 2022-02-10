['pragma solidity ^0.4.2;\n', '\n', 'contract owned {\n', '\taddress public owner;\n', '\n', '\tfunction owned() {\n', '\t\towner = msg.sender;\n', '\t}\n', '\n', '\tfunction changeOwner(address newOwner) onlyOwner {\n', '\t\towner = newOwner;\n', '\t}\n', '\n', '\tmodifier onlyOwner {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '}\n', '\n', 'contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}\n', '\n', 'contract CSToken is owned {\n', '\tstruct Dividend {\n', '\t\tuint time;\n', '\t\tuint tenThousandth;\n', '\t\tbool isComplete;\n', '\t}\n', '\n', '\t/* Public variables of the token */\n', '\tstring public standard = &#39;Token 0.1&#39;;\n', '\n', '\tstring public name = &#39;KickCoin&#39;;\n', '\n', '\tstring public symbol = &#39;KC&#39;;\n', '\n', '\tuint8 public decimals = 8;\n', '\n', '\tuint256 public totalSupply = 0;\n', '\n', '\t/* This creates an array with all balances */\n', '\tmapping (address => uint256) public balanceOf;\n', '\tmapping (address => uint256) public matureBalanceOf;\n', '\n', '\tmapping (address => mapping (uint => uint256)) public agingBalanceOf;\n', '\n', '\tuint[] agingTimes;\n', '\n', '\tDividend[] dividends;\n', '\n', '\tmapping (address => mapping (address => uint256)) public allowance;\n', '\t/* This generates a public event on the blockchain that will notify clients */\n', '\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '\tevent AgingTransfer(address indexed from, address indexed to, uint256 value, uint agingTime);\n', '\n', '\tuint countAddressIndexes = 0;\n', '\n', '\tmapping (uint => address) addressByIndex;\n', '\n', '\tmapping (address => uint) indexByAddress;\n', '\n', '\tmapping (address => uint) agingTimesForPools;\n', '\n', '\t/* Initializes contract with initial supply tokens to the creator of the contract */\n', '\tfunction CSToken() {\n', '\t\towner = msg.sender;\n', '\t\tdividends.push(Dividend(1509454800, 300, false));\n', '\t\tdividends.push(Dividend(1512046800, 200, false));\n', '\t\tdividends.push(Dividend(1514725200, 100, false));\n', '\t\tdividends.push(Dividend(1517403600, 50, false));\n', '\t\tdividends.push(Dividend(1519822800, 100, false));\n', '\t\tdividends.push(Dividend(1522501200, 200, false));\n', '\t\tdividends.push(Dividend(1525093200, 300, false));\n', '\t\tdividends.push(Dividend(1527771600, 500, false));\n', '\t\tdividends.push(Dividend(1530363600, 300, false));\n', '\t\tdividends.push(Dividend(1533042000, 200, false));\n', '\t\tdividends.push(Dividend(1535720400, 100, false));\n', '\t\tdividends.push(Dividend(1538312400, 50, false));\n', '\t\tdividends.push(Dividend(1540990800, 100, false));\n', '\t\tdividends.push(Dividend(1543582800, 200, false));\n', '\t\tdividends.push(Dividend(1546261200, 300, false));\n', '\t\tdividends.push(Dividend(1548939600, 600, false));\n', '\t\tdividends.push(Dividend(1551358800, 300, false));\n', '\t\tdividends.push(Dividend(1554037200, 200, false));\n', '\t\tdividends.push(Dividend(1556629200, 100, false));\n', '\t\tdividends.push(Dividend(1559307600, 200, false));\n', '\t\tdividends.push(Dividend(1561899600, 300, false));\n', '\t\tdividends.push(Dividend(1564578000, 200, false));\n', '\t\tdividends.push(Dividend(1567256400, 100, false));\n', '\t\tdividends.push(Dividend(1569848400, 50, false));\n', '\n', '\t}\n', '\n', '\tfunction calculateDividends(uint which) {\n', '\t\trequire(now >= dividends[which].time && !dividends[which].isComplete);\n', '\n', '\t\tfor (uint i = 1; i <= countAddressIndexes; i++) {\n', '\t\t\tbalanceOf[addressByIndex[i]] += balanceOf[addressByIndex[i]] * dividends[which].tenThousandth / 10000;\n', '\t\t\tmatureBalanceOf[addressByIndex[i]] += matureBalanceOf[addressByIndex[i]] * dividends[which].tenThousandth / 10000;\n', '\t\t}\n', '\t}\n', '\n', '\t/* Send coins */\n', '\tfunction transfer(address _to, uint256 _value) {\n', '\t\tcheckMyAging(msg.sender);\n', '\t\trequire(matureBalanceOf[msg.sender] >= _value);\n', '\n', '\t\trequire(balanceOf[_to] + _value > balanceOf[_to]);\n', '\t\trequire(matureBalanceOf[_to] + _value > matureBalanceOf[_to]);\n', '\t\t// Check for overflows\n', '\n', '\t\tbalanceOf[msg.sender] -= _value;\n', '\t\tmatureBalanceOf[msg.sender] -= _value;\n', '\t\t// Subtract from the sender\n', '\n', '\t\tif (agingTimesForPools[msg.sender] > 0 && agingTimesForPools[msg.sender] > now) {\n', '\t\t\taddToAging(msg.sender, _to, agingTimesForPools[msg.sender], _value);\n', '\t\t} else {\n', '\t\t\tmatureBalanceOf[_to] += _value;\n', '\t\t}\n', '\t\tbalanceOf[_to] += _value;\n', '\t\tTransfer(msg.sender, _to, _value);\n', '\t}\n', '\n', '\tfunction mintToken(address target, uint256 mintedAmount, uint agingTime) onlyOwner {\n', '\t\tif (agingTime > now) {\n', '\t\t\taddToAging(owner, target, agingTime, mintedAmount);\n', '\t\t} else {\n', '\t\t\tmatureBalanceOf[target] += mintedAmount;\n', '\t\t}\n', '\n', '\t\tbalanceOf[target] += mintedAmount;\n', '\n', '\t\ttotalSupply += mintedAmount;\n', '\t\tTransfer(0, owner, mintedAmount);\n', '\t\tTransfer(owner, target, mintedAmount);\n', '\t}\n', '\n', '\tfunction addToAging(address from, address target, uint agingTime, uint256 amount) internal {\n', '\t\tif (indexByAddress[target] == 0) {\n', '\t\t\tindexByAddress[target] = 1;\n', '\t\t\tcountAddressIndexes++;\n', '\t\t\taddressByIndex[countAddressIndexes] = target;\n', '\t\t}\n', '\t\tbool existTime = false;\n', '\t\tfor (uint i = 0; i < agingTimes.length; i++) {\n', '\t\t\tif (agingTimes[i] == agingTime)\n', '\t\t\texistTime = true;\n', '\t\t}\n', '\t\tif (!existTime) agingTimes.push(agingTime);\n', '\t\tagingBalanceOf[target][agingTime] += amount;\n', '\t\tAgingTransfer(from, target, amount, agingTime);\n', '\t}\n', '\n', '\t/* Allow another contract to spend some tokens in your behalf */\n', '\tfunction approve(address _spender, uint256 _value) returns (bool success) {\n', '\t\tallowance[msg.sender][_spender] = _value;\n', '\t\treturn true;\n', '\t}\n', '\t/* Approve and then communicate the approved contract in a single tx */\n', '\tfunction approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '\t\ttokenRecipient spender = tokenRecipient(_spender);\n', '\t\tif (approve(_spender, _value)) {\n', '\t\t\tspender.receiveApproval(msg.sender, _value, this, _extraData);\n', '\t\t\treturn true;\n', '\t\t}\n', '\t}\n', '\n', '\t/* A contract attempts to get the coins */\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '\t\tcheckMyAging(_from);\n', '\t\trequire(matureBalanceOf[_from] >= _value);\n', '\t\t// Check if the sender has enough\n', '\t\tassert(balanceOf[_to] + _value > balanceOf[_to]);\n', '\t\tassert(matureBalanceOf[_to] + _value > matureBalanceOf[_to]);\n', '\t\t// Check for overflows\n', '\t\trequire(_value <= allowance[_from][msg.sender]);\n', '\t\t// Check allowance\n', '\t\tbalanceOf[_from] -= _value;\n', '\t\tmatureBalanceOf[_from] -= _value;\n', '\t\t// Subtract from the sender\n', '\t\tbalanceOf[_to] += _value;\n', '\t\t// Add the same to the recipient\n', '\t\tallowance[_from][msg.sender] -= _value;\n', '\n', '\t\tif (agingTimesForPools[_from] > 0 && agingTimesForPools[_from] > now) {\n', '\t\t\taddToAging(_from, _to, agingTimesForPools[_from], _value);\n', '\t\t} else {\n', '\t\t\tmatureBalanceOf[_to] += _value;\n', '\t\t}\n', '\n', '\t\tTransfer(_from, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/* This unnamed function is called whenever someone tries to send ether to it */\n', '\tfunction() {\n', '\t\trevert();\n', '\t\t// Prevents accidental sending of ether\n', '\t}\n', '\n', '\tfunction checkMyAging(address sender) internal {\n', '\t\tfor (uint k = 0; k < agingTimes.length; k++) {\n', '\t\t\tif (agingTimes[k] < now && agingBalanceOf[sender][agingTimes[k]] > 0) {\n', '\t\t\t\tfor(uint256 i = 0; i < 24; i++) {\n', '\t\t\t\t\tif(now < dividends[i].time) break;\n', '\t\t\t\t\tif(!dividends[i].isComplete) break;\n', '\t\t\t\t\tagingBalanceOf[sender][agingTimes[k]] += agingBalanceOf[sender][agingTimes[k]] * dividends[i].tenThousandth / 10000;\n', '\t\t\t\t}\n', '\t\t\t\tmatureBalanceOf[sender] += agingBalanceOf[sender][agingTimes[k]];\n', '\t\t\t\tagingBalanceOf[sender][agingTimes[k]] = 0;\n', '\t\t\t}\n', '\t\t}\n', '\t}\n', '\n', '\tfunction addAgingTimesForPool(address poolAddress, uint agingTime) onlyOwner {\n', '\t\tagingTimesForPools[poolAddress] = agingTime;\n', '\t}\n', '}']
['pragma solidity ^0.4.2;\n', '\n', 'contract owned {\n', '\taddress public owner;\n', '\n', '\tfunction owned() {\n', '\t\towner = msg.sender;\n', '\t}\n', '\n', '\tfunction changeOwner(address newOwner) onlyOwner {\n', '\t\towner = newOwner;\n', '\t}\n', '\n', '\tmodifier onlyOwner {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '}\n', '\n', 'contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}\n', '\n', 'contract CSToken is owned {\n', '\tstruct Dividend {\n', '\t\tuint time;\n', '\t\tuint tenThousandth;\n', '\t\tbool isComplete;\n', '\t}\n', '\n', '\t/* Public variables of the token */\n', "\tstring public standard = 'Token 0.1';\n", '\n', "\tstring public name = 'KickCoin';\n", '\n', "\tstring public symbol = 'KC';\n", '\n', '\tuint8 public decimals = 8;\n', '\n', '\tuint256 public totalSupply = 0;\n', '\n', '\t/* This creates an array with all balances */\n', '\tmapping (address => uint256) public balanceOf;\n', '\tmapping (address => uint256) public matureBalanceOf;\n', '\n', '\tmapping (address => mapping (uint => uint256)) public agingBalanceOf;\n', '\n', '\tuint[] agingTimes;\n', '\n', '\tDividend[] dividends;\n', '\n', '\tmapping (address => mapping (address => uint256)) public allowance;\n', '\t/* This generates a public event on the blockchain that will notify clients */\n', '\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '\tevent AgingTransfer(address indexed from, address indexed to, uint256 value, uint agingTime);\n', '\n', '\tuint countAddressIndexes = 0;\n', '\n', '\tmapping (uint => address) addressByIndex;\n', '\n', '\tmapping (address => uint) indexByAddress;\n', '\n', '\tmapping (address => uint) agingTimesForPools;\n', '\n', '\t/* Initializes contract with initial supply tokens to the creator of the contract */\n', '\tfunction CSToken() {\n', '\t\towner = msg.sender;\n', '\t\tdividends.push(Dividend(1509454800, 300, false));\n', '\t\tdividends.push(Dividend(1512046800, 200, false));\n', '\t\tdividends.push(Dividend(1514725200, 100, false));\n', '\t\tdividends.push(Dividend(1517403600, 50, false));\n', '\t\tdividends.push(Dividend(1519822800, 100, false));\n', '\t\tdividends.push(Dividend(1522501200, 200, false));\n', '\t\tdividends.push(Dividend(1525093200, 300, false));\n', '\t\tdividends.push(Dividend(1527771600, 500, false));\n', '\t\tdividends.push(Dividend(1530363600, 300, false));\n', '\t\tdividends.push(Dividend(1533042000, 200, false));\n', '\t\tdividends.push(Dividend(1535720400, 100, false));\n', '\t\tdividends.push(Dividend(1538312400, 50, false));\n', '\t\tdividends.push(Dividend(1540990800, 100, false));\n', '\t\tdividends.push(Dividend(1543582800, 200, false));\n', '\t\tdividends.push(Dividend(1546261200, 300, false));\n', '\t\tdividends.push(Dividend(1548939600, 600, false));\n', '\t\tdividends.push(Dividend(1551358800, 300, false));\n', '\t\tdividends.push(Dividend(1554037200, 200, false));\n', '\t\tdividends.push(Dividend(1556629200, 100, false));\n', '\t\tdividends.push(Dividend(1559307600, 200, false));\n', '\t\tdividends.push(Dividend(1561899600, 300, false));\n', '\t\tdividends.push(Dividend(1564578000, 200, false));\n', '\t\tdividends.push(Dividend(1567256400, 100, false));\n', '\t\tdividends.push(Dividend(1569848400, 50, false));\n', '\n', '\t}\n', '\n', '\tfunction calculateDividends(uint which) {\n', '\t\trequire(now >= dividends[which].time && !dividends[which].isComplete);\n', '\n', '\t\tfor (uint i = 1; i <= countAddressIndexes; i++) {\n', '\t\t\tbalanceOf[addressByIndex[i]] += balanceOf[addressByIndex[i]] * dividends[which].tenThousandth / 10000;\n', '\t\t\tmatureBalanceOf[addressByIndex[i]] += matureBalanceOf[addressByIndex[i]] * dividends[which].tenThousandth / 10000;\n', '\t\t}\n', '\t}\n', '\n', '\t/* Send coins */\n', '\tfunction transfer(address _to, uint256 _value) {\n', '\t\tcheckMyAging(msg.sender);\n', '\t\trequire(matureBalanceOf[msg.sender] >= _value);\n', '\n', '\t\trequire(balanceOf[_to] + _value > balanceOf[_to]);\n', '\t\trequire(matureBalanceOf[_to] + _value > matureBalanceOf[_to]);\n', '\t\t// Check for overflows\n', '\n', '\t\tbalanceOf[msg.sender] -= _value;\n', '\t\tmatureBalanceOf[msg.sender] -= _value;\n', '\t\t// Subtract from the sender\n', '\n', '\t\tif (agingTimesForPools[msg.sender] > 0 && agingTimesForPools[msg.sender] > now) {\n', '\t\t\taddToAging(msg.sender, _to, agingTimesForPools[msg.sender], _value);\n', '\t\t} else {\n', '\t\t\tmatureBalanceOf[_to] += _value;\n', '\t\t}\n', '\t\tbalanceOf[_to] += _value;\n', '\t\tTransfer(msg.sender, _to, _value);\n', '\t}\n', '\n', '\tfunction mintToken(address target, uint256 mintedAmount, uint agingTime) onlyOwner {\n', '\t\tif (agingTime > now) {\n', '\t\t\taddToAging(owner, target, agingTime, mintedAmount);\n', '\t\t} else {\n', '\t\t\tmatureBalanceOf[target] += mintedAmount;\n', '\t\t}\n', '\n', '\t\tbalanceOf[target] += mintedAmount;\n', '\n', '\t\ttotalSupply += mintedAmount;\n', '\t\tTransfer(0, owner, mintedAmount);\n', '\t\tTransfer(owner, target, mintedAmount);\n', '\t}\n', '\n', '\tfunction addToAging(address from, address target, uint agingTime, uint256 amount) internal {\n', '\t\tif (indexByAddress[target] == 0) {\n', '\t\t\tindexByAddress[target] = 1;\n', '\t\t\tcountAddressIndexes++;\n', '\t\t\taddressByIndex[countAddressIndexes] = target;\n', '\t\t}\n', '\t\tbool existTime = false;\n', '\t\tfor (uint i = 0; i < agingTimes.length; i++) {\n', '\t\t\tif (agingTimes[i] == agingTime)\n', '\t\t\texistTime = true;\n', '\t\t}\n', '\t\tif (!existTime) agingTimes.push(agingTime);\n', '\t\tagingBalanceOf[target][agingTime] += amount;\n', '\t\tAgingTransfer(from, target, amount, agingTime);\n', '\t}\n', '\n', '\t/* Allow another contract to spend some tokens in your behalf */\n', '\tfunction approve(address _spender, uint256 _value) returns (bool success) {\n', '\t\tallowance[msg.sender][_spender] = _value;\n', '\t\treturn true;\n', '\t}\n', '\t/* Approve and then communicate the approved contract in a single tx */\n', '\tfunction approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '\t\ttokenRecipient spender = tokenRecipient(_spender);\n', '\t\tif (approve(_spender, _value)) {\n', '\t\t\tspender.receiveApproval(msg.sender, _value, this, _extraData);\n', '\t\t\treturn true;\n', '\t\t}\n', '\t}\n', '\n', '\t/* A contract attempts to get the coins */\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '\t\tcheckMyAging(_from);\n', '\t\trequire(matureBalanceOf[_from] >= _value);\n', '\t\t// Check if the sender has enough\n', '\t\tassert(balanceOf[_to] + _value > balanceOf[_to]);\n', '\t\tassert(matureBalanceOf[_to] + _value > matureBalanceOf[_to]);\n', '\t\t// Check for overflows\n', '\t\trequire(_value <= allowance[_from][msg.sender]);\n', '\t\t// Check allowance\n', '\t\tbalanceOf[_from] -= _value;\n', '\t\tmatureBalanceOf[_from] -= _value;\n', '\t\t// Subtract from the sender\n', '\t\tbalanceOf[_to] += _value;\n', '\t\t// Add the same to the recipient\n', '\t\tallowance[_from][msg.sender] -= _value;\n', '\n', '\t\tif (agingTimesForPools[_from] > 0 && agingTimesForPools[_from] > now) {\n', '\t\t\taddToAging(_from, _to, agingTimesForPools[_from], _value);\n', '\t\t} else {\n', '\t\t\tmatureBalanceOf[_to] += _value;\n', '\t\t}\n', '\n', '\t\tTransfer(_from, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\t/* This unnamed function is called whenever someone tries to send ether to it */\n', '\tfunction() {\n', '\t\trevert();\n', '\t\t// Prevents accidental sending of ether\n', '\t}\n', '\n', '\tfunction checkMyAging(address sender) internal {\n', '\t\tfor (uint k = 0; k < agingTimes.length; k++) {\n', '\t\t\tif (agingTimes[k] < now && agingBalanceOf[sender][agingTimes[k]] > 0) {\n', '\t\t\t\tfor(uint256 i = 0; i < 24; i++) {\n', '\t\t\t\t\tif(now < dividends[i].time) break;\n', '\t\t\t\t\tif(!dividends[i].isComplete) break;\n', '\t\t\t\t\tagingBalanceOf[sender][agingTimes[k]] += agingBalanceOf[sender][agingTimes[k]] * dividends[i].tenThousandth / 10000;\n', '\t\t\t\t}\n', '\t\t\t\tmatureBalanceOf[sender] += agingBalanceOf[sender][agingTimes[k]];\n', '\t\t\t\tagingBalanceOf[sender][agingTimes[k]] = 0;\n', '\t\t\t}\n', '\t\t}\n', '\t}\n', '\n', '\tfunction addAgingTimesForPool(address poolAddress, uint agingTime) onlyOwner {\n', '\t\tagingTimesForPools[poolAddress] = agingTime;\n', '\t}\n', '}']

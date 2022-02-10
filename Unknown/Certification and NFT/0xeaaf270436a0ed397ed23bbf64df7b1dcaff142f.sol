['pragma solidity ^0.4.11;\n', '\n', '//------------------------------------------------------------------------------------------------\n', '// LICENSE\n', '//\n', '// This file is part of BattleDrome.\n', '// \n', '// BattleDrome is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '// \n', '// BattleDrome is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '// \n', '// You should have received a copy of the GNU General Public License\n', '// along with BattleDrome.  If not, see <http://www.gnu.org/licenses/>.\n', '//------------------------------------------------------------------------------------------------\n', '\n', '//------------------------------------------------------------------------------------------------\n', '// ERC20 Standard Token Implementation, based on ERC Standard:\n', '// https://github.com/ethereum/EIPs/issues/20\n', '// With some inspiration from ConsenSys HumanStandardToken as well\n', '// Copyright 2017 BattleDrome\n', '//------------------------------------------------------------------------------------------------\n', '\n', 'contract ERC20Standard {\n', '\tuint public totalSupply;\n', '\t\n', '\tstring public name;\n', '\tuint8 public decimals;\n', '\tstring public symbol;\n', '\tstring public version;\n', '\t\n', '\tmapping (address => uint256) balances;\n', '\tmapping (address => mapping (address => uint)) allowed;\n', '\n', '\t//Fix for short address attack against ERC20\n', '\tmodifier onlyPayloadSize(uint size) {\n', '\t\tassert(msg.data.length == size + 4);\n', '\t\t_;\n', '\t} \n', '\n', '\tfunction balanceOf(address _owner) constant returns (uint balance) {\n', '\t\treturn balances[_owner];\n', '\t}\n', '\n', '\tfunction transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {\n', '\t\trequire(balances[msg.sender] >= _value && _value > 0);\n', '\t    balances[msg.sender] -= _value;\n', '\t    balances[_recipient] += _value;\n', '\t    Transfer(msg.sender, _recipient, _value);        \n', '    }\n', '\n', '\tfunction transferFrom(address _from, address _to, uint _value) {\n', '\t\trequire(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '\tfunction approve(address _spender, uint _value) {\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\t}\n', '\n', '\tfunction allowance(address _spender, address _owner) constant returns (uint balance) {\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '\n', '\t//Event which is triggered to log all transfers to this contract&#39;s event log\n', '\tevent Transfer(\n', '\t\taddress indexed _from,\n', '\t\taddress indexed _to,\n', '\t\tuint _value\n', '\t\t);\n', '\t\t\n', '\t//Event which is triggered whenever an owner approves a new allowance for a spender.\n', '\tevent Approval(\n', '\t\taddress indexed _owner,\n', '\t\taddress indexed _spender,\n', '\t\tuint _value\n', '\t\t);\n', '\n', '}\n', '\n', '//------------------------------------------------------------------------------------------------\n', '// FAME ERC20 Token, based on ERC20Standard interface\n', '// Copyright 2017 BattleDrome\n', '//------------------------------------------------------------------------------------------------\n', '\n', 'contract FAMEToken is ERC20Standard {\n', '\n', '\tfunction FAMEToken() {\n', '\t\ttotalSupply = 2100000 szabo;\t\t\t//Total Supply (including all decimal places!)\n', '\t\tname = "Fame";\t\t\t\t\t\t\t//Pretty Name\n', '\t\tdecimals = 12;\t\t\t\t\t\t\t//Decimal places (with 12 decimal places 1 szabo = 1 token in uint256)\n', '\t\tsymbol = "FAM";\t\t\t\t\t\t\t//Ticker Symbol (3 characters, upper case)\n', '\t\tversion = "FAME1.0";\t\t\t\t\t//Version Code\n', '\t\tbalances[msg.sender] = totalSupply;\t\t//Assign all balance to creator initially for distribution from there.\n', '\t}\n', '\n', '\t//Burn _value of tokens from your balance.\n', '\t//Will destroy the tokens, removing them from your balance, and reduce totalSupply accordingly.\n', '\tfunction burn(uint _value) {\n', '\t\trequire(balances[msg.sender] >= _value && _value > 0);\n', '        balances[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '\t}\n', '\n', '\t//Event to log any time someone burns tokens to the contract&#39;s event log:\n', '\tevent Burn(\n', '\t\taddress indexed _owner,\n', '\t\tuint _value\n', '\t\t);\n', '\n', '}\n', '\n', '//------------------------------------------------------------------------------------------------\n', '// ICO Crowd Sale Contract\n', '// Works like a kickstarter. Minimum goal required, or everyone gets their money back\n', '// Contract holds all tokens, upon success (passing goal on time) sends out all bought tokens\n', '// It then burns the rest.\n', '// In the event of failure, it sends tokens back to creator, and all payments back to senders.\n', '// Each time tokens are bought, a percentage is also issued to the "Developer" account.\n', '// Pay-out of collected Ether to creators is managed through an Escrow address.\n', '// Copyright 2017 BattleDrome\n', '//------------------------------------------------------------------------------------------------\n', '\n', 'contract BattleDromeICO {\n', '\tuint public constant ratio = 100 szabo;\t\t\t\t//Ratio of how many tokens (in absolute uint256 form) are issued per ETH\n', '\tuint public constant minimumPurchase = 1 finney;\t//Minimum purchase size (of incoming ETH)\n', '\tuint public constant startBlock = 3960000;\t\t\t//Starting Block Number of Crowsd Sale\n', '\tuint public constant duration = 190000;\t\t\t\t//16s block times 190k is about 35 days, from July 1st, to approx first Friday of August.\n', '\tuint public constant fundingGoal = 500 ether;\t\t//Minimum Goal in Ether Raised\n', '\tuint public constant fundingMax = 20000 ether;\t\t//Maximum Funds in Ether that we will accept before stopping the crowdsale\n', '\tuint public constant devRatio = 20;\t\t\t\t\t//Ratio of Sold Tokens to Dev Tokens (ie 20 = 20:1 or 5%)\n', '\taddress public constant tokenAddress \t= 0x190e569bE071F40c704e15825F285481CB74B6cC;\t//Address of ERC20 Token Contract\n', '\taddress public constant escrow \t\t\t= 0x50115D25322B638A5B8896178F7C107CFfc08144;\t//Address of Escrow Provider Wallet\n', '\n', '\tFAMEToken public Token;\n', '\taddress public creator;\n', '\tuint public savedBalance;\n', '\tbool public creatorPaid = false;\t\t\t//Has the creator been paid? \n', '\n', '\tmapping(address => uint) balances;\t\t\t//Balances in incoming Ether\n', '\tmapping(address => uint) savedBalances;\t\t//Saved Balances in incoming Ether (for after withdrawl validation)\n', '\n', '\t//Constructor, initiate the crowd sale\n', '\tfunction BattleDromeICO() {\n', '\t\tToken = FAMEToken(tokenAddress);\t\t\t\t//Establish the Token Contract to handle token transfers\t\t\t\t\t\n', '\t\tcreator = msg.sender;\t\t\t\t\t\t\t//Establish the Creator address for receiving payout if/when appropriate.\n', '\t}\n', '\n', '\t//Default Function, delegates to contribute function (for ease of use)\n', '\t//WARNING: Not compatible with smart contract invocation, will exceed gas stipend!\n', '\t//Only use from full wallets.\n', '\tfunction () payable {\n', '\t\tcontribute();\n', '\t}\n', '\n', '\t//Contribute Function, accepts incoming payments and tracks balances\n', '\tfunction contribute() payable {\n', '\t\trequire(isStarted());\t\t\t\t\t\t\t\t//Has the crowdsale even started yet?\n', '\t\trequire(this.balance<=fundingMax); \t\t\t\t\t//Does this payment send us over the max?\n', '\t\trequire(msg.value >= minimumPurchase);              //Require that the incoming amount is at least the minimum purchase size.\n', '\t\trequire(!isComplete()); \t\t\t\t\t\t\t//Has the crowdsale completed? We only want to accept payments if we&#39;re still active.\n', '\t\tbalances[msg.sender] += msg.value;\t\t\t\t\t//If all checks good, then accept contribution and record new balance.\n', '\t\tsavedBalances[msg.sender] += msg.value;\t\t    \t//Save contributors balance for later\t\n', '\t\tsavedBalance += msg.value;\t\t\t\t\t\t\t//Save the balance for later when we&#39;re doing pay-outs so we know what it was.\n', '\t\tContribution(msg.sender,msg.value,now);             //Woohoo! Log the new contribution!\n', '\t}\n', '\n', '\t//Function to view current token balance of the crowdsale contract\n', '\tfunction tokenBalance() constant returns(uint balance) {\n', '\t\treturn Token.balanceOf(address(this));\n', '\t}\n', '\n', '\t//Function to check if crowdsale has started yet, have we passed the start block?\n', '\tfunction isStarted() constant returns(bool) {\n', '\t\treturn block.number >= startBlock;\n', '\t}\n', '\n', '\t//Function to check if crowdsale is complete (have we eigher hit our max, or passed the crowdsale completion block?)\n', '\tfunction isComplete() constant returns(bool) {\n', '\t\treturn (savedBalance >= fundingMax) || (block.number > (startBlock + duration));\n', '\t}\n', '\n', '\t//Function to check if crowdsale has been successful (has incoming contribution balance met, or exceeded the minimum goal?)\n', '\tfunction isSuccessful() constant returns(bool) {\n', '\t\treturn (savedBalance >= fundingGoal);\n', '\t}\n', '\n', '\t//Function to check the Ether balance of a contributor\n', '\tfunction checkEthBalance(address _contributor) constant returns(uint balance) {\n', '\t\treturn balances[_contributor];\n', '\t}\n', '\n', '\t//Function to check the Saved Ether balance of a contributor\n', '\tfunction checkSavedEthBalance(address _contributor) constant returns(uint balance) {\n', '\t\treturn savedBalances[_contributor];\n', '\t}\n', '\n', '\t//Function to check the Token balance of a contributor\n', '\tfunction checkTokBalance(address _contributor) constant returns(uint balance) {\n', '\t\treturn (balances[_contributor] * ratio) / 1 ether;\n', '\t}\n', '\n', '\t//Function to check the current Tokens Sold in the ICO\n', '\tfunction checkTokSold() constant returns(uint total) {\n', '\t\treturn (savedBalance * ratio) / 1 ether;\n', '\t}\n', '\n', '\t//Function to get Dev Tokens issued during ICO\n', '\tfunction checkTokDev() constant returns(uint total) {\n', '\t\treturn checkTokSold() / devRatio;\n', '\t}\n', '\n', '\t//Function to get Total Tokens Issued during ICO (Dev + Sold)\n', '\tfunction checkTokTotal() constant returns(uint total) {\n', '\t\treturn checkTokSold() + checkTokDev();\n', '\t}\n', '\n', '\t//function to check percentage of goal achieved\n', '\tfunction percentOfGoal() constant returns(uint16 goalPercent) {\n', '\t\treturn uint16((savedBalance*100)/fundingGoal);\n', '\t}\n', '\n', '\t//function to initiate payout of either Tokens or Ether payback.\n', '\tfunction payMe() {\n', '\t\trequire(isComplete()); //No matter what must be complete\n', '\t\tif(isSuccessful()) {\n', '\t\t\tpayTokens();\n', '\t\t}else{\n', '\t\t\tpayBack();\n', '\t\t}\n', '\t}\n', '\n', '\t//Function to pay back Ether\n', '\tfunction payBack() internal {\n', '\t\trequire(balances[msg.sender]>0);\t\t\t\t\t\t//Does the requester have a balance?\n', '\t\tbalances[msg.sender] = 0;\t\t\t\t\t\t\t\t//Ok, zero balance first to avoid re-entrance\n', '\t\tmsg.sender.transfer(savedBalances[msg.sender]);\t\t\t//Send them their saved balance\n', '\t\tPayEther(msg.sender,savedBalances[msg.sender],now); \t//Log payback of ether\n', '\t}\n', '\n', '\t//Function to pay out Tokens\n', '\tfunction payTokens() internal {\n', '\t\trequire(balances[msg.sender]>0);\t\t\t\t\t//Does the requester have a balance?\n', '\t\tuint tokenAmount = checkTokBalance(msg.sender);\t\t//If so, then let&#39;s calculate how many Tokens we owe them\n', '\t\tbalances[msg.sender] = 0;\t\t\t\t\t\t\t//Zero their balance ahead of transfer to avoid re-entrance (even though re-entrance here should be zero risk)\n', '\t\tToken.transfer(msg.sender,tokenAmount);\t\t\t\t//And transfer the tokens to them\n', '\t\tPayTokens(msg.sender,tokenAmount,now);          \t//Log payout of tokens to contributor\n', '\t}\n', '\n', '\t//Function to pay the creator upon success\n', '\tfunction payCreator() {\n', '\t\trequire(isComplete());\t\t\t\t\t\t\t\t\t\t//Creator can only request payout once ICO is complete\n', '\t\trequire(!creatorPaid);\t\t\t\t\t\t\t\t\t\t//Require that the creator hasn&#39;t already been paid\n', '\t\tcreatorPaid = true;\t\t\t\t\t\t\t\t\t\t\t//Set flag to show creator has been paid.\n', '\t\tif(isSuccessful()){\n', '\t\t\tuint tokensToBurn = tokenBalance() - checkTokTotal();\t//How many left-over tokens after sold, and dev tokens are accounted for? (calculated before we muck with balance)\n', '\t\t\tPayEther(escrow,this.balance,now);      \t\t\t\t//Log the payout to escrow\n', '\t\t\tescrow.transfer(this.balance);\t\t\t\t\t\t\t//We were successful, so transfer the balance to the escrow address\n', '\t\t\tPayTokens(creator,checkTokDev(),now);       \t\t\t//Log payout of tokens to creator\n', '\t\t\tToken.transfer(creator,checkTokDev());\t\t\t\t\t//And since successful, send DevRatio tokens to devs directly\t\t\t\n', '\t\t\tToken.burn(tokensToBurn);\t\t\t\t\t\t\t\t//Burn any excess tokens;\n', '\t\t\tBurnTokens(tokensToBurn,now);        \t\t\t\t\t//Log the burning of the tokens.\n', '\t\t}else{\n', '\t\t\tPayTokens(creator,tokenBalance(),now);       \t\t\t//Log payout of tokens to creator\n', '\t\t\tToken.transfer(creator,tokenBalance());\t\t\t\t\t//We were not successful, so send ALL tokens back to creator.\n', '\t\t}\n', '\t}\n', '\t\n', '\t//Event to record new contributions\n', '\tevent Contribution(\n', '\t    address indexed _contributor,\n', '\t    uint indexed _value,\n', '\t    uint indexed _timestamp\n', '\t    );\n', '\t    \n', '\t//Event to record each time tokens are paid out\n', '\tevent PayTokens(\n', '\t    address indexed _receiver,\n', '\t    uint indexed _value,\n', '\t    uint indexed _timestamp\n', '\t    );\n', '\n', '\t//Event to record each time Ether is paid out\n', '\tevent PayEther(\n', '\t    address indexed _receiver,\n', '\t    uint indexed _value,\n', '\t    uint indexed _timestamp\n', '\t    );\n', '\t    \n', '\t//Event to record when tokens are burned.\n', '\tevent BurnTokens(\n', '\t    uint indexed _value,\n', '\t    uint indexed _timestamp\n', '\t    );\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '//------------------------------------------------------------------------------------------------\n', '// LICENSE\n', '//\n', '// This file is part of BattleDrome.\n', '// \n', '// BattleDrome is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '// \n', '// BattleDrome is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '// \n', '// You should have received a copy of the GNU General Public License\n', '// along with BattleDrome.  If not, see <http://www.gnu.org/licenses/>.\n', '//------------------------------------------------------------------------------------------------\n', '\n', '//------------------------------------------------------------------------------------------------\n', '// ERC20 Standard Token Implementation, based on ERC Standard:\n', '// https://github.com/ethereum/EIPs/issues/20\n', '// With some inspiration from ConsenSys HumanStandardToken as well\n', '// Copyright 2017 BattleDrome\n', '//------------------------------------------------------------------------------------------------\n', '\n', 'contract ERC20Standard {\n', '\tuint public totalSupply;\n', '\t\n', '\tstring public name;\n', '\tuint8 public decimals;\n', '\tstring public symbol;\n', '\tstring public version;\n', '\t\n', '\tmapping (address => uint256) balances;\n', '\tmapping (address => mapping (address => uint)) allowed;\n', '\n', '\t//Fix for short address attack against ERC20\n', '\tmodifier onlyPayloadSize(uint size) {\n', '\t\tassert(msg.data.length == size + 4);\n', '\t\t_;\n', '\t} \n', '\n', '\tfunction balanceOf(address _owner) constant returns (uint balance) {\n', '\t\treturn balances[_owner];\n', '\t}\n', '\n', '\tfunction transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {\n', '\t\trequire(balances[msg.sender] >= _value && _value > 0);\n', '\t    balances[msg.sender] -= _value;\n', '\t    balances[_recipient] += _value;\n', '\t    Transfer(msg.sender, _recipient, _value);        \n', '    }\n', '\n', '\tfunction transferFrom(address _from, address _to, uint _value) {\n', '\t\trequire(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '\tfunction approve(address _spender, uint _value) {\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\t}\n', '\n', '\tfunction allowance(address _spender, address _owner) constant returns (uint balance) {\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '\n', "\t//Event which is triggered to log all transfers to this contract's event log\n", '\tevent Transfer(\n', '\t\taddress indexed _from,\n', '\t\taddress indexed _to,\n', '\t\tuint _value\n', '\t\t);\n', '\t\t\n', '\t//Event which is triggered whenever an owner approves a new allowance for a spender.\n', '\tevent Approval(\n', '\t\taddress indexed _owner,\n', '\t\taddress indexed _spender,\n', '\t\tuint _value\n', '\t\t);\n', '\n', '}\n', '\n', '//------------------------------------------------------------------------------------------------\n', '// FAME ERC20 Token, based on ERC20Standard interface\n', '// Copyright 2017 BattleDrome\n', '//------------------------------------------------------------------------------------------------\n', '\n', 'contract FAMEToken is ERC20Standard {\n', '\n', '\tfunction FAMEToken() {\n', '\t\ttotalSupply = 2100000 szabo;\t\t\t//Total Supply (including all decimal places!)\n', '\t\tname = "Fame";\t\t\t\t\t\t\t//Pretty Name\n', '\t\tdecimals = 12;\t\t\t\t\t\t\t//Decimal places (with 12 decimal places 1 szabo = 1 token in uint256)\n', '\t\tsymbol = "FAM";\t\t\t\t\t\t\t//Ticker Symbol (3 characters, upper case)\n', '\t\tversion = "FAME1.0";\t\t\t\t\t//Version Code\n', '\t\tbalances[msg.sender] = totalSupply;\t\t//Assign all balance to creator initially for distribution from there.\n', '\t}\n', '\n', '\t//Burn _value of tokens from your balance.\n', '\t//Will destroy the tokens, removing them from your balance, and reduce totalSupply accordingly.\n', '\tfunction burn(uint _value) {\n', '\t\trequire(balances[msg.sender] >= _value && _value > 0);\n', '        balances[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '\t}\n', '\n', "\t//Event to log any time someone burns tokens to the contract's event log:\n", '\tevent Burn(\n', '\t\taddress indexed _owner,\n', '\t\tuint _value\n', '\t\t);\n', '\n', '}\n', '\n', '//------------------------------------------------------------------------------------------------\n', '// ICO Crowd Sale Contract\n', '// Works like a kickstarter. Minimum goal required, or everyone gets their money back\n', '// Contract holds all tokens, upon success (passing goal on time) sends out all bought tokens\n', '// It then burns the rest.\n', '// In the event of failure, it sends tokens back to creator, and all payments back to senders.\n', '// Each time tokens are bought, a percentage is also issued to the "Developer" account.\n', '// Pay-out of collected Ether to creators is managed through an Escrow address.\n', '// Copyright 2017 BattleDrome\n', '//------------------------------------------------------------------------------------------------\n', '\n', 'contract BattleDromeICO {\n', '\tuint public constant ratio = 100 szabo;\t\t\t\t//Ratio of how many tokens (in absolute uint256 form) are issued per ETH\n', '\tuint public constant minimumPurchase = 1 finney;\t//Minimum purchase size (of incoming ETH)\n', '\tuint public constant startBlock = 3960000;\t\t\t//Starting Block Number of Crowsd Sale\n', '\tuint public constant duration = 190000;\t\t\t\t//16s block times 190k is about 35 days, from July 1st, to approx first Friday of August.\n', '\tuint public constant fundingGoal = 500 ether;\t\t//Minimum Goal in Ether Raised\n', '\tuint public constant fundingMax = 20000 ether;\t\t//Maximum Funds in Ether that we will accept before stopping the crowdsale\n', '\tuint public constant devRatio = 20;\t\t\t\t\t//Ratio of Sold Tokens to Dev Tokens (ie 20 = 20:1 or 5%)\n', '\taddress public constant tokenAddress \t= 0x190e569bE071F40c704e15825F285481CB74B6cC;\t//Address of ERC20 Token Contract\n', '\taddress public constant escrow \t\t\t= 0x50115D25322B638A5B8896178F7C107CFfc08144;\t//Address of Escrow Provider Wallet\n', '\n', '\tFAMEToken public Token;\n', '\taddress public creator;\n', '\tuint public savedBalance;\n', '\tbool public creatorPaid = false;\t\t\t//Has the creator been paid? \n', '\n', '\tmapping(address => uint) balances;\t\t\t//Balances in incoming Ether\n', '\tmapping(address => uint) savedBalances;\t\t//Saved Balances in incoming Ether (for after withdrawl validation)\n', '\n', '\t//Constructor, initiate the crowd sale\n', '\tfunction BattleDromeICO() {\n', '\t\tToken = FAMEToken(tokenAddress);\t\t\t\t//Establish the Token Contract to handle token transfers\t\t\t\t\t\n', '\t\tcreator = msg.sender;\t\t\t\t\t\t\t//Establish the Creator address for receiving payout if/when appropriate.\n', '\t}\n', '\n', '\t//Default Function, delegates to contribute function (for ease of use)\n', '\t//WARNING: Not compatible with smart contract invocation, will exceed gas stipend!\n', '\t//Only use from full wallets.\n', '\tfunction () payable {\n', '\t\tcontribute();\n', '\t}\n', '\n', '\t//Contribute Function, accepts incoming payments and tracks balances\n', '\tfunction contribute() payable {\n', '\t\trequire(isStarted());\t\t\t\t\t\t\t\t//Has the crowdsale even started yet?\n', '\t\trequire(this.balance<=fundingMax); \t\t\t\t\t//Does this payment send us over the max?\n', '\t\trequire(msg.value >= minimumPurchase);              //Require that the incoming amount is at least the minimum purchase size.\n', "\t\trequire(!isComplete()); \t\t\t\t\t\t\t//Has the crowdsale completed? We only want to accept payments if we're still active.\n", '\t\tbalances[msg.sender] += msg.value;\t\t\t\t\t//If all checks good, then accept contribution and record new balance.\n', '\t\tsavedBalances[msg.sender] += msg.value;\t\t    \t//Save contributors balance for later\t\n', "\t\tsavedBalance += msg.value;\t\t\t\t\t\t\t//Save the balance for later when we're doing pay-outs so we know what it was.\n", '\t\tContribution(msg.sender,msg.value,now);             //Woohoo! Log the new contribution!\n', '\t}\n', '\n', '\t//Function to view current token balance of the crowdsale contract\n', '\tfunction tokenBalance() constant returns(uint balance) {\n', '\t\treturn Token.balanceOf(address(this));\n', '\t}\n', '\n', '\t//Function to check if crowdsale has started yet, have we passed the start block?\n', '\tfunction isStarted() constant returns(bool) {\n', '\t\treturn block.number >= startBlock;\n', '\t}\n', '\n', '\t//Function to check if crowdsale is complete (have we eigher hit our max, or passed the crowdsale completion block?)\n', '\tfunction isComplete() constant returns(bool) {\n', '\t\treturn (savedBalance >= fundingMax) || (block.number > (startBlock + duration));\n', '\t}\n', '\n', '\t//Function to check if crowdsale has been successful (has incoming contribution balance met, or exceeded the minimum goal?)\n', '\tfunction isSuccessful() constant returns(bool) {\n', '\t\treturn (savedBalance >= fundingGoal);\n', '\t}\n', '\n', '\t//Function to check the Ether balance of a contributor\n', '\tfunction checkEthBalance(address _contributor) constant returns(uint balance) {\n', '\t\treturn balances[_contributor];\n', '\t}\n', '\n', '\t//Function to check the Saved Ether balance of a contributor\n', '\tfunction checkSavedEthBalance(address _contributor) constant returns(uint balance) {\n', '\t\treturn savedBalances[_contributor];\n', '\t}\n', '\n', '\t//Function to check the Token balance of a contributor\n', '\tfunction checkTokBalance(address _contributor) constant returns(uint balance) {\n', '\t\treturn (balances[_contributor] * ratio) / 1 ether;\n', '\t}\n', '\n', '\t//Function to check the current Tokens Sold in the ICO\n', '\tfunction checkTokSold() constant returns(uint total) {\n', '\t\treturn (savedBalance * ratio) / 1 ether;\n', '\t}\n', '\n', '\t//Function to get Dev Tokens issued during ICO\n', '\tfunction checkTokDev() constant returns(uint total) {\n', '\t\treturn checkTokSold() / devRatio;\n', '\t}\n', '\n', '\t//Function to get Total Tokens Issued during ICO (Dev + Sold)\n', '\tfunction checkTokTotal() constant returns(uint total) {\n', '\t\treturn checkTokSold() + checkTokDev();\n', '\t}\n', '\n', '\t//function to check percentage of goal achieved\n', '\tfunction percentOfGoal() constant returns(uint16 goalPercent) {\n', '\t\treturn uint16((savedBalance*100)/fundingGoal);\n', '\t}\n', '\n', '\t//function to initiate payout of either Tokens or Ether payback.\n', '\tfunction payMe() {\n', '\t\trequire(isComplete()); //No matter what must be complete\n', '\t\tif(isSuccessful()) {\n', '\t\t\tpayTokens();\n', '\t\t}else{\n', '\t\t\tpayBack();\n', '\t\t}\n', '\t}\n', '\n', '\t//Function to pay back Ether\n', '\tfunction payBack() internal {\n', '\t\trequire(balances[msg.sender]>0);\t\t\t\t\t\t//Does the requester have a balance?\n', '\t\tbalances[msg.sender] = 0;\t\t\t\t\t\t\t\t//Ok, zero balance first to avoid re-entrance\n', '\t\tmsg.sender.transfer(savedBalances[msg.sender]);\t\t\t//Send them their saved balance\n', '\t\tPayEther(msg.sender,savedBalances[msg.sender],now); \t//Log payback of ether\n', '\t}\n', '\n', '\t//Function to pay out Tokens\n', '\tfunction payTokens() internal {\n', '\t\trequire(balances[msg.sender]>0);\t\t\t\t\t//Does the requester have a balance?\n', "\t\tuint tokenAmount = checkTokBalance(msg.sender);\t\t//If so, then let's calculate how many Tokens we owe them\n", '\t\tbalances[msg.sender] = 0;\t\t\t\t\t\t\t//Zero their balance ahead of transfer to avoid re-entrance (even though re-entrance here should be zero risk)\n', '\t\tToken.transfer(msg.sender,tokenAmount);\t\t\t\t//And transfer the tokens to them\n', '\t\tPayTokens(msg.sender,tokenAmount,now);          \t//Log payout of tokens to contributor\n', '\t}\n', '\n', '\t//Function to pay the creator upon success\n', '\tfunction payCreator() {\n', '\t\trequire(isComplete());\t\t\t\t\t\t\t\t\t\t//Creator can only request payout once ICO is complete\n', "\t\trequire(!creatorPaid);\t\t\t\t\t\t\t\t\t\t//Require that the creator hasn't already been paid\n", '\t\tcreatorPaid = true;\t\t\t\t\t\t\t\t\t\t\t//Set flag to show creator has been paid.\n', '\t\tif(isSuccessful()){\n', '\t\t\tuint tokensToBurn = tokenBalance() - checkTokTotal();\t//How many left-over tokens after sold, and dev tokens are accounted for? (calculated before we muck with balance)\n', '\t\t\tPayEther(escrow,this.balance,now);      \t\t\t\t//Log the payout to escrow\n', '\t\t\tescrow.transfer(this.balance);\t\t\t\t\t\t\t//We were successful, so transfer the balance to the escrow address\n', '\t\t\tPayTokens(creator,checkTokDev(),now);       \t\t\t//Log payout of tokens to creator\n', '\t\t\tToken.transfer(creator,checkTokDev());\t\t\t\t\t//And since successful, send DevRatio tokens to devs directly\t\t\t\n', '\t\t\tToken.burn(tokensToBurn);\t\t\t\t\t\t\t\t//Burn any excess tokens;\n', '\t\t\tBurnTokens(tokensToBurn,now);        \t\t\t\t\t//Log the burning of the tokens.\n', '\t\t}else{\n', '\t\t\tPayTokens(creator,tokenBalance(),now);       \t\t\t//Log payout of tokens to creator\n', '\t\t\tToken.transfer(creator,tokenBalance());\t\t\t\t\t//We were not successful, so send ALL tokens back to creator.\n', '\t\t}\n', '\t}\n', '\t\n', '\t//Event to record new contributions\n', '\tevent Contribution(\n', '\t    address indexed _contributor,\n', '\t    uint indexed _value,\n', '\t    uint indexed _timestamp\n', '\t    );\n', '\t    \n', '\t//Event to record each time tokens are paid out\n', '\tevent PayTokens(\n', '\t    address indexed _receiver,\n', '\t    uint indexed _value,\n', '\t    uint indexed _timestamp\n', '\t    );\n', '\n', '\t//Event to record each time Ether is paid out\n', '\tevent PayEther(\n', '\t    address indexed _receiver,\n', '\t    uint indexed _value,\n', '\t    uint indexed _timestamp\n', '\t    );\n', '\t    \n', '\t//Event to record when tokens are burned.\n', '\tevent BurnTokens(\n', '\t    uint indexed _value,\n', '\t    uint indexed _timestamp\n', '\t    );\n', '\n', '}']
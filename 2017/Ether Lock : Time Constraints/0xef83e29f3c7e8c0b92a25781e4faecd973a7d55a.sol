['pragma solidity 0.4.18;\n', '\n', '/*\n', '\tPer Annum is an ERC20 token which can be mined during the first two weeks of each year for 120 years \n', '\tstarting in 2018. The mining reward starts at 100 tokens and is halved yearly. The maximum mining\n', '\treward starts at 10,000,000 and is halved every five years. The contract owner was granted 40,000\n', '\ttokens on deployment of the contract, and any unmined tokens at the end of the mining period are \n', "\tsent to the owner. 20,000 of the initial owner's supply will be given away in order to promote the\n", '\ttoken. \n', '\n', '\t\n', '\n', '\n', '\tanonymous proof of authorship - 4612370A4B007CE4AE5AEF472642F1DE55C63CEB53319C457EF1ED83F7441EA6\n', '\tsignature - 9927A75EF7C89D3C028C8BA7A1B48CDD515ACED7A2BC564A099D452D3B3FFE89\n', '*/\n', 'contract Per_Annum{\n', '\tstring public symbol = "ANNUM";\n', '\tstring public name = "Per Annum";\n', '\tuint8 public constant decimals = 8;\n', '\tuint256 _totalSupply = 0;\n', '\taddress contract_owner;\n', '\tuint256 current_remaining = 0; //to check for left over tokens after mining period\n', '\tuint256 _maxTotalSupply = 10000000000000000; //one hundred million\n', '\tuint256 _miningReward = 10000000000; //100 ANNUM rewarded on successful mine halved every 5 years \n', '\tuint256 _maxMiningReward = 1000000000000000; //10,000,000 ANNUM - To be halved every 5 years\n', '\tuint256 _year = 1514782800; // 01/01/2018 12:00AM EST\n', '\tuint256 _year_count = 2018; //contract starts in 2018 first leap year is 2020\n', '\tuint256 _currentMined = 0; //mined for the year\n', '\n', '\n', '\tevent Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '    //initialize contract - set owner and give owner 20,000 tokens\n', '    function Per_Annum(){\n', '    \t_totalSupply += 4000000000000;\n', '    \t_currentMined += 4000000000000;\t\n', '    \tcontract_owner = msg.sender;\n', '    \tbalances[msg.sender] += 4000000000000;\n', '    \tTransfer(this,msg.sender,4000000000000);\n', '    }\n', '\n', '\tfunction totalSupply() constant returns (uint256) {        \n', '\t\treturn _totalSupply;\n', '\t}\n', '\n', '\tfunction balanceOf(address _owner) constant returns (uint256 balance) {\n', '\t\treturn balances[_owner];\n', '\t}\n', '\n', '\n', '\tfunction transfer(address _to, uint256 _amount) returns (bool success) {\n', '\t\tif (balances[msg.sender] >= _amount \n', '\t\t\t&& _amount > 0\n', '\t\t\t&& balances[_to] + _amount > balances[_to]) {\n', '\t\t\tbalances[msg.sender] -= _amount;\n', '\t\t\tbalances[_to] += _amount;\n', '\t\t\tTransfer(msg.sender, _to, _amount);\n', '\t\t\treturn true;\n', '\t\t} else {\n', '            return false;\n', '\t\t}\n', '\t}\n', '\n', '\tfunction transferFrom(\n', '\t\taddress _from,\n', '\t\taddress _to,\n', '\t\tuint256 _amount\n', '\t) returns (bool success) {\n', '\t\tif (balances[_from] >= _amount\n', '\t\t\t&& allowed[_from][msg.sender] >= _amount\n', '\t\t\t&& _amount > 0\n', '\t\t\t&& balances[_to] + _amount > balances[_to]) {\n', '\t\t\tbalances[_from] -= _amount;\n', '\t\t\tallowed[_from][msg.sender] -= _amount;\n', '\t\t\tbalances[_to] += _amount;\n', '\t\t\tTransfer(_from, _to, _amount);\n', '\t\t\treturn true;\n', '\t\t} else {\n', '\t\t\treturn false;\n', '\t\t}\n', '\t}\n', '\n', '\tfunction allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '\n', '\tfunction approve(address _spender, uint256 _amount) returns (bool success) {\n', '\t\tallowed[msg.sender][_spender] = _amount;\n', '\t\tApproval(msg.sender, _spender, _amount);\n', '\t\treturn true;\n', '\t}\n', '\t//is_leap_year sets year to 12AM on new years day of the current year and sets the mining rewards\n', '\tfunction is_leap_year() private{\n', '\t\tif(now >= _year + 31557600){\t\n', '\t\t\t_year = _year + 31557600;\t//changes to new year, 1 day early on leap year, in seconds\n', '\t\t\t_year_count = _year_count + 1; //changes to new year in years\n', '\t\t\t_currentMined = 0;\t//resets for current years supply\n', '\t\t\t_miningReward = _miningReward/2; //halved yearly starting at 100\n', '\t\t\tif(((_year_count-2018)%5 == 0) && (_year_count != 2018)){\n', '\t\t\t\t_maxMiningReward = _maxMiningReward/2; //halved every 5th year\n', '\t\t\t\t\n', '\n', '\t\t\t}\n', '\t\t\tif((_year_count%4 == 1) && ((_year_count-1)%100 != 0)){\n', '\t\t\t\t_year = _year + 86400;\t//adds a day following a leap year\n', '\t\t\t\t\n', '\n', '\t\t\t}\n', '\t\t\telse if((_year_count-1)%400 == 0){\n', '\t\t\t\t_year = _year + 86400; //leap year day added on last day of leap year\n', '\n', '\t\t\t}\n', ' \n', '\t\t}\t\n', '\n', '\t}\n', '\n', '\n', '\tfunction date_check() private returns(bool check_newyears){\n', '\n', '\t\tis_leap_year(); //set the year variables and rewards\n', '\t\t//check if date is new years day\n', '\t    if((_year <= now) && (now <= (_year + 1209600))){\n', '\t\t\treturn true;\t//it is the first two weeks of the new year\n', '\t\t}\n', '\t\telse{\n', '\t\t\treturn false; //it is not the first two weeks of the new year\n', '\t\t}\n', '\t}\n', '\t\n', '\tfunction mine() returns(bool success){\n', '\t\tif(date_check() != true){\n', '\t\t\tcurrent_remaining = _maxMiningReward - _currentMined; \n', '\t\t\tif((current_remaining > 0) && (_currentMined != 0)){\n', '\t\t\t\t_currentMined += current_remaining;\n', '\t\t\t\tbalances[contract_owner] += current_remaining;\n', '\t\t\t\tTransfer(this, contract_owner, current_remaining);\n', '\t\t\t\tcurrent_remaining = 0;\n', '\t\t\t}\n', '\t\t\trevert();\n', '\t\t}\n', '\t\telse if((_currentMined < _maxMiningReward) && (_maxMiningReward - _currentMined >= _miningReward)){\n', '\t\t\tif((_totalSupply+_miningReward) <= _maxTotalSupply){\n', '\t\t\t\t//send reward if there are tokens available and it is new years day\n', '\t\t\t\tbalances[msg.sender] += _miningReward;\t\n', '\t\t\t\t_currentMined += _miningReward;\n', '\t\t\t\t_totalSupply += _miningReward;\n', '\t\t\t\tTransfer(this, msg.sender, _miningReward); \n', '\t\t\t\treturn true;\n', '\t\t\t}\n', '\t\t\n', '\t\t}\n', '\t\treturn false;\n', '\t}\n', '\n', '\tfunction MaxTotalSupply() constant returns(uint256)\n', '\t{\n', '\t\treturn _maxTotalSupply;\n', '\t}\n', '\t\n', '\tfunction MiningReward() constant returns(uint256)\n', '\t{\n', '\t\treturn _miningReward;\n', '\t}\n', '\t\n', '\tfunction MaxMiningReward() constant returns(uint256)\n', '\t{\n', '\t\treturn _maxMiningReward;\n', '\t}\n', '\tfunction MinedThisYear() constant returns(uint256)\n', '\t{\n', '\t\treturn _currentMined; //amount mined so far this year\n', '\t}\n', '\n', '\n', '\n', '}']
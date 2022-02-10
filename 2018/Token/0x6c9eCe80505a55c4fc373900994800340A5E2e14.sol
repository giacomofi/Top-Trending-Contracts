['pragma solidity ^0.4.21;\n', '\n', '/*\n', '* Contract that is working with ERC223 tokens\n', '*/\n', ' \n', 'contract ERC223Receiver {\n', '\tstruct TKN {\n', '\t\taddress sender;\n', '\t\tuint value;\n', '\t\tbytes data;\n', '\t\tbytes4 sig;\n', '\t}\n', '\tfunction tokenFallback(address _from, uint _value, bytes _data) public pure;\n', '}\n', '\n', ' /* New ERC223 contract interface */\n', ' \n', 'contract ERC223 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '\n', '// redundant as public accessors are automatically assigned   \n', '//  function name() public view returns (string _name);\n', '//  function symbol() public view returns (string _symbol);\n', '//  function decimals() public view returns (uint8 _decimals);\n', '//  function totalSupply() public view returns (uint256 _supply);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '  \n', '  //event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract CGENToken is ERC223 {\n', '\n', '\t// standard token metadata\n', '\t// implements ERC20/ERC223 interface\n', '\tstring public constant name = "Cryptanogen"; \n', '\tstring public constant symbol = "CGEN" ;\n', '\tuint8 public constant decimals = 8;\n', '\n', '\t// amount of tokens vested\n', '\tuint128 public availableSupply;\n', '\n', '\t// individual vesting data\n', '\tstruct vesting {\n', '\t\tuint createdAt;\n', '\t\tuint128 amount;\n', '\t\tuint8 releaseRate;\n', '\t\tuint32 releaseIntervalSeconds;\n', '\t\tuint8 nextReleasePeriod;\n', '\t\tbool completed;\n', '\t}\n', '\n', '\tstruct tokenAccount {\n', '\t\tuint128 vestedBalance;\n', '\t\tuint128 releasedBalance;\n', '\t\tvesting []vestingIndex; \n', '\t}\n', '\n', '\t// locked balance per address\n', '\tmapping (address => tokenAccount) tokenAccountIndex;\n', '\n', '\t// contract owner\n', '\taddress public owner;\n', '\n', '\t// contract creation time\n', '\tuint creationTime;\n', '\n', '\t// How often vested tokens are released\n', '\t//uint32 public defaultReleaseIntervalSeconds = 31536000;\n', '\n', '\t// Percentage vested amount released each interval\n', '\t//uint8 public defaultReleaseRate = 10; \n', '\n', '\tfunction CGENToken(uint _supply) public {\n', '\t\ttotalSupply = _supply;\n', '\t\tavailableSupply = uint128(totalSupply);\n', '\t\trequire(uint(availableSupply) == totalSupply);\n', '\t\towner = msg.sender;\n', '\t\tcreationTime = now;\n', '\t\temit Transfer(0x0, owner, _supply);\n', '\t}\n', '\n', '\t// creates a new vesting with default parameters for rate and interval\t\n', '//\tfunction vestToAddress(address _who, uint128 _amount) public returns(bool) {\n', '//\t\treturn vestToAddressEx(_who, _amount, defaultReleaseRate, defaultReleaseIntervalSeconds);\n', '//\t}\n', '\n', '\n', '\t// creates a new vesting with explicit parameters for rate and interval\n', '\tfunction vestToAddressEx(address _who, uint128 _amount, uint8 _divisor, uint32 _intervalSeconds) public returns(bool) {\n', '\n', '\t\t// uninitialized but all fields will be set below\n', '\t\tvesting memory newVesting;\n', '\n', '\t\t// vestings are registered manually by contract owner\n', '\t\trequire(msg.sender == owner);\n', '\n', '\t\t// duh\n', '\t\trequire(_amount > 0);\n', '\t\trequire(_divisor <= 100 && _divisor > 0);\n', '\t\trequire(_intervalSeconds > 0);\n', '\n', '\t\t// rate should divide evenly to 100 (percent)\n', '\t\trequire(100 % _divisor == 0);\n', '\n', '\t\t// prevent vesting of more tokens than total supply\n', '\t\trequire(_amount <= availableSupply);\n', '\n', '\t\tnewVesting.createdAt = now;\n', '\t\tnewVesting.amount = _amount;\n', '\t\tnewVesting.releaseRate = 100 / _divisor;\n', '\t\tnewVesting.releaseIntervalSeconds = _intervalSeconds;\n', '\t\tnewVesting.nextReleasePeriod = 0;\n', '\t\tnewVesting.completed = false;\n', '\t\ttokenAccountIndex[_who].vestingIndex.push(newVesting);\n', '\n', '\t\tavailableSupply -= _amount;\n', '\t\ttokenAccountIndex[_who].vestedBalance += _amount;\n', '\t\temit Transfer(owner, _who, _amount);\n', '\t\treturn true;\n', '\t}\n', '\n', '\t// check the vesting at the particular index for the address for amount eligible for release\n', '\t// returns the eligible amount\n', '\tfunction checkRelease(address _who, uint _idx) public view returns(uint128) {\n', '\t\tvesting memory v;\n', '\t\tuint i;\n', '\t\tuint timespan;\n', '\t\tuint timestep;\n', '\t\tuint maxEligibleFactor;\n', '\t\tuint128 releaseStep;\n', '\t\tuint128 eligibleAmount;\n', '\n', '\t\t// check if any tokens have been vested to this account\n', '\t\trequire(tokenAccountIndex[_who].vestingIndex.length > _idx);\n', '\t\tv = tokenAccountIndex[_who].vestingIndex[_idx];\n', '\t\tif (v.completed) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\n', '\t\t// by dividing timespan (time passed since vesting creation) by the release intervals, we get the maximal rate that is eligible for release so far\n', '\t\t// cap it at 100 percent\n', '\t\ttimespan = now - tokenAccountIndex[_who].vestingIndex[_idx].createdAt;\n', '\t\ttimestep = tokenAccountIndex[_who].vestingIndex[_idx].releaseIntervalSeconds * 1 seconds;\n', '\t\tmaxEligibleFactor = (timespan / timestep) * tokenAccountIndex[_who].vestingIndex[_idx].releaseRate;\n', '\t\tif (maxEligibleFactor > 100) {\n', '\t\t\tmaxEligibleFactor = 100;\n', '\t\t}\n', '\n', '\t\treleaseStep = (tokenAccountIndex[_who].vestingIndex[_idx].amount * tokenAccountIndex[_who].vestingIndex[_idx].releaseRate) / 100;\n', '\t\t// iterate from the cursor on the next vesting period that has not yet been released\n', '\t\tfor (i = tokenAccountIndex[_who].vestingIndex[_idx].nextReleasePeriod * tokenAccountIndex[_who].vestingIndex[_idx].releaseRate; i < maxEligibleFactor; i += tokenAccountIndex[_who].vestingIndex[_idx].releaseRate) {\n', '\t\t\teligibleAmount += releaseStep;\n', '\t\t}\n', '\n', '\t\treturn eligibleAmount;\n', '\t}\n', '\n', '\t// will release and make transferable any tokens eligible for release\n', '\t// to avoid waste of gas, the calling agent should have confirmed with checkRelease that there actually is something to release\n', '\tfunction release(address _who, uint _idx) public returns(uint128) {\n', '\t\tvesting storage v;\n', '\t\tuint8 j;\n', '\t\tuint8 i;\n', '\t\tuint128 total;\n', '\t\tuint timespan;\n', '\t\tuint timestep;\n', '\t\tuint128 releaseStep;\n', '\t\tuint maxEligibleFactor;\n', '\n', '\t\t// check if any tokens have been vested to this account\n', '\t\t// don&#39;t burn gas if already completed\n', '\t\trequire(tokenAccountIndex[_who].vestingIndex.length > _idx);\n', '\t\tv = tokenAccountIndex[_who].vestingIndex[_idx];\n', '\t\tif (v.completed) {\n', '\t\t\trevert();\n', '\t\t}\n', '\n', '\t\t// by dividing timespan (time passed since vesting creation) by the release intervals, we get the maximal rate that is eligible for release so far\n', '\t\t// cap it at 100 percent\n', '\t\ttimespan = now - v.createdAt;\n', '\t\ttimestep = v.releaseIntervalSeconds * 1 seconds;\n', '\t\tmaxEligibleFactor = (timespan / timestep) * v.releaseRate;\n', '\t\tif (maxEligibleFactor > 100) {\n', '\t\t\tmaxEligibleFactor = 100;\n', '\t\t}\n', '\n', '\t\treleaseStep = (v.amount * v.releaseRate) / 100;\n', '\t\tfor (i = v.nextReleasePeriod * v.releaseRate; i < maxEligibleFactor; i += v.releaseRate) {\n', '\t\t\ttotal += releaseStep;\n', '\t\t\tj++;\n', '\t\t}\n', '\t\ttokenAccountIndex[_who].vestedBalance -= total;\n', '\t\ttokenAccountIndex[_who].releasedBalance += total;\n', '\t\tif (maxEligibleFactor == 100) {\n', '\t\t\tv.completed = true;\n', '\t\t} else {\n', '\t\t\tv.nextReleasePeriod += j;\n', '\t\t}\n', '\t\treturn total;\n', '\t}\n', '\n', '\t// vestings state access\n', '\tfunction getVestingAmount(address _who, uint _idx) public view returns (uint128) {\n', '\t\treturn tokenAccountIndex[_who].vestingIndex[_idx].amount;\n', '\t}\n', '\n', '\tfunction getVestingReleaseRate(address _who, uint _idx) public view returns (uint8) {\n', '\t\treturn tokenAccountIndex[_who].vestingIndex[_idx].releaseRate;\n', '\t}\n', '\n', '\tfunction getVestingReleaseInterval(address _who, uint _idx) public view returns(uint32) {\n', '\t\treturn tokenAccountIndex[_who].vestingIndex[_idx].releaseIntervalSeconds;\n', '\t}\n', '\n', '\tfunction getVestingCreatedAt(address _who, uint _idx) public view returns(uint) {\n', '\t\treturn tokenAccountIndex[_who].vestingIndex[_idx].createdAt;\n', '\t}\n', '\n', '\tfunction getVestingsCount(address _who) public view returns(uint) {\n', '\t\treturn tokenAccountIndex[_who].vestingIndex.length;\n', '\t}\n', '\n', '\tfunction vestingIsCompleted(address _who, uint _idx) public view returns(bool) {\n', '\t\trequire(tokenAccountIndex[_who].vestingIndex.length > _idx);\n', '\n', '\t\treturn tokenAccountIndex[_who].vestingIndex[_idx].completed;\n', '\t}\n', '\n', '\t// implements ERC223 interface\n', '\tfunction transfer(address _to, uint256 _value, bytes _data, string _custom_callback_unimplemented) public returns(bool) {\n', '\t\tuint128 shortValue;\n', '\n', '\t\t// owner can only vest tokens\n', '\t\trequire(_to != owner);\n', '\t\trequire(msg.sender != owner);\n', '\t\n', '\t\t// we use 128 bit data for values\n', '\t\t// make sure it&#39;s converted correctly\n', '\t\tshortValue = uint128(_value);\n', '\t\trequire(uint(shortValue) == _value);\n', '\n', '\t\t// check if there is enough in the released balance\n', '\t\trequire(tokenAccountIndex[msg.sender].releasedBalance >= shortValue);\n', '\n', '\t\t// check if the recipient has an account, if not create it\n', '\t\ttokenAccountIndex[msg.sender].releasedBalance -= shortValue;\n', '\t\ttokenAccountIndex[_to].releasedBalance += shortValue;\n', '\n', '\t\t// ERC223 safe token transfer to contract\n', '\t\tif (isContract(_to)) {\n', '\t\t\tERC223Receiver receiver = ERC223Receiver(_to);\n', '\t\t\treceiver.tokenFallback(msg.sender, _value, _data);\n', '\t\t}\n', '\t\temit Transfer(msg.sender, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\t// implements ERC20/ERC223 interface\n', '\tfunction transfer(address _to, uint256 _value, bytes _data) public returns (bool) {\n', '\t\treturn transfer(_to, _value, _data, "");\n', '\t}\n', '\n', '\t// implements ERC20/ERC223 interface\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool) {\n', '\t\tbytes memory empty;\n', '\t\treturn transfer(_to, _value, empty, "");\n', '\t}\n', '\n', '\t// not used for this token\n', '\t// implements ERC20 interface\n', '\tfunction transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '\t\treturn false;\n', '\t}\n', '\n', '\t// not used for this token\n', '\t// implements ERC20 interface\n', '\tfunction approve(address _spender, uint256 _value) public returns(bool) {\n', '\t\treturn false;\n', '\t}\n', '\n', '\t// not used for this token\n', '\t// implements ERC20 interface\n', '\tfunction allowance(address _owner, address _spender) public view returns(uint256) {\n', '\t\treturn 0;\n', '\t}\n', '\n', '\t// check the total of vested tokens still locked for a particular address\n', '\tfunction vestedBalanceOf(address _who) public view returns (uint) {\n', '\t\treturn uint(tokenAccountIndex[_who].vestedBalance);\n', '\t}\n', '\n', '\t// check the total of vested and released tokens assigned to a particular addresss\n', '\t// (this is the actual token balance)\n', '\t// implements ERC20/ERC223 interface\n', '\tfunction balanceOf(address _who) public view returns (uint) {\n', '\t\tif (_who == owner) {\n', '\t\t\treturn availableSupply;\n', '\t\t}\n', '\t\treturn uint(tokenAccountIndex[_who].vestedBalance + tokenAccountIndex[_who].releasedBalance);\n', '\t}\n', '\n', '\t// external addresses (wallets) will have codesize 0\n', '\tfunction isContract(address _addr) private view returns (bool) {\n', '\t\tuint l;\n', '\n', '\t\t// Retrieve the size of the code on target address, this needs assembly .\n', '\t\tassembly {\n', '\t\t\tl := extcodesize(_addr)\n', '\t\t}\n', '\t\treturn (l > 0);\n', '\t}\n', '}']
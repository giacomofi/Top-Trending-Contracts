['pragma solidity ^0.4.25;\n', '// ----------------------------------------------\n', '// ----------------------------------------------\n', '//===============================================\n', '// =      Name : Prime Systems Token           =\n', '// =      Symbol : PRIME                       =\n', '// =      Total Supply : 15,000,000,000        =\n', '// =      Decimals : 8                         =\n', '// =      (c) by PrimeSystems Developers Team  =\n', '// ==============================================\n', 'library SafeMath {\n', ' /**\n', ' * @dev Multiplies two numbers, throws on overflow.\n', ' */\n', ' function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', ' if (a == 0) {\n', ' return 0;\n', ' }\n', ' c = a * b;\n', ' assert(c / a == b);\n', ' return c;\n', ' }\n', ' /**\n', ' * @dev Integer division of two numbers, truncating the quotient.\n', ' */\n', ' function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', ' // assert(b > 0); // Solidity automatically throws when dividing by 0\n', ' // uint256 c = a / b;\n', " // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", ' return a / b;\n', ' }\n', ' /**\n', ' * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', ' */\n', ' function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', ' assert(b <= a);\n', ' return a - b;\n', ' }\n', 'function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', ' c = a + b;\n', ' assert(c >= a);\n', ' return c;\n', ' }\n', '}\n', 'contract ForeignToken {\n', ' function balanceOf(address _owner) constant public returns (uint256);\n', ' function transfer(address _to, uint256 _value) public returns (bool);\n', '}\n', 'contract ERC20Basic {\n', ' uint256 public totalSupply;\n', ' function balanceOf(address who) public constant returns (uint256);\n', ' function transfer(address to, uint256 value) public returns (bool);\n', ' event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', ' function allowance(address owner, address spender) public constant returns (uint256);\n', ' function transferFrom(address from, address to, uint256 value) public returns (bool);\n', ' function approve(address spender, uint256 value) public returns (bool);\n', ' event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract PrimeSystems is ERC20 {\n', ' \n', ' using SafeMath for uint256;\n', ' address owner = msg.sender;\n', ' mapping (address => uint256) balances;\n', ' mapping (address => mapping (address => uint256)) allowed;\n', ' mapping (address => bool) public Claimed; \n', ' string public constant name = "Prime Systems Token";\n', ' string public constant symbol = "PRIME";\n', ' uint public constant decimals = 8;\n', ' uint public deadline = now + 13 * 1 days;\n', ' uint public round2 = now + 8 * 1 days;\n', ' uint public round1 = now + 19 * 1 days;\n', ' \n', ' uint256 public totalSupply = 15000000000e8;\n', ' uint256 public totalDistributed;\n', ' uint256 public constant requestMinimum = 1 ether / 1000; // 0.001 Ether\n', ' uint256 public tokensPerEth = 15500000e8;\n', '\n', 'uint public target0drop = 30000;\n', ' uint public progress0drop = 0;\n', ' \n', ' ///\n', ' address multisig = 0x8F4091071B52CeAf3676b471A24A329dFDC9f86d; \n', ' event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', ' event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', ' \n', ' event Distr(address indexed to, uint256 amount);\n', ' event DistrFinished();\n', ' \n', ' event Airdrop(address indexed _owner, uint _amount, uint _balance);\n', ' event TokensPerEthUpdated(uint _tokensPerEth);\n', ' \n', ' event Burn(address indexed burner, uint256 value);\n', ' \n', ' event Add(uint256 value);\n', ' bool public distributionFinished = false;\n', ' \n', ' modifier canDistr() {\n', ' require(!distributionFinished);\n', ' _;\n', ' }\n', ' \n', ' modifier onlyOwner() {\n', ' require(msg.sender == owner);\n', ' _;\n', ' }\n', ' \n', ' constructor() public {\n', ' uint256 teamFund = 10000000e8;\n', ' owner = msg.sender;\n', ' distr(owner, teamFund);\n', ' }\n', ' \n', ' function transferOwnership(address newOwner) onlyOwner public {\n', ' if (newOwner != address(0)) {\n', ' owner = newOwner;\n', ' }\n', ' }\n', ' function finishDistribution() onlyOwner canDistr public returns (bool) {\n', ' distributionFinished = true;\n', ' emit DistrFinished();\n', '\n', 'return true;\n', ' }\n', ' \n', ' function distr(address _to, uint256 _amount) canDistr private returns (bool) {\n', ' totalDistributed = totalDistributed.add(_amount); \n', ' balances[_to] = balances[_to].add(_amount);\n', ' emit Distr(_to, _amount);\n', ' emit Transfer(address(0), _to, _amount);\n', ' return true;\n', ' }\n', ' \n', ' function Distribute(address _participant, uint _amount) onlyOwner internal {\n', ' require( _amount > 0 ); \n', ' require( totalDistributed < totalSupply );\n', ' balances[_participant] = balances[_participant].add(_amount);\n', ' totalDistributed = totalDistributed.add(_amount);\n', ' if (totalDistributed >= totalSupply) {\n', ' distributionFinished = true;\n', ' }\n', ' // log\n', ' emit Airdrop(_participant, _amount, balances[_participant]);\n', ' emit Transfer(address(0), _participant, _amount);\n', ' }\n', ' \n', ' function DistributeAirdrop(address _participant, uint _amount) onlyOwner external { \n', ' Distribute(_participant, _amount);\n', ' }\n', ' function DistributeAirdropMultiple(address[] _addresses, uint _amount) onlyOwner external { \n', ' for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);\n', ' }\n', ' function updateTokensPerEth(uint _tokensPerEth) public onlyOwner { \n', ' tokensPerEth = _tokensPerEth;\n', ' emit TokensPerEthUpdated(_tokensPerEth);\n', ' }\n', ' \n', ' function () external payable {\n', ' getTokens();\n', ' }\n', ' function getTokens() payable canDistr public {\n', ' uint256 tokens = 0;\n', ' uint256 bonus = 0;\n', '\n', 'uint256 countbonus = 0;\n', ' uint256 bonusCond1 = 1 ether;\n', ' uint256 bonusCond2 = 3 ether;\n', ' uint256 bonusCond3 = 5 ether;\n', ' uint256 bonusCond4 = 7 ether;\n', ' uint256 bonusCond5 = 9 ether;\n', ' uint256 bonusCond6 = 11 ether;\n', ' uint256 bonusCond7 = 13 ether;\n', ' tokens = tokensPerEth.mul(msg.value) / 1 ether; \n', ' address investor = msg.sender;\n', ' if (msg.value >= requestMinimum && now < deadline && now < round1 && now < round2) {\n', ' if(msg.value >= bonusCond1 && msg.value < bonusCond2){\n', ' countbonus = tokens * 1 / 100;\n', ' }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){\n', ' countbonus = tokens * 3 / 100;\n', ' }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){\n', ' countbonus = tokens * 5 / 100;\n', ' }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){\n', ' countbonus = tokens * 7 / 100;\n', ' }else if(msg.value >= bonusCond5 && msg.value < bonusCond6){\n', ' countbonus = tokens * 9 / 100;\n', ' }else if(msg.value >= bonusCond6 && msg.value < bonusCond7){\n', ' countbonus = tokens * 11 / 100;\n', ' }else if(msg.value >= bonusCond7){\n', ' countbonus = tokens * 13 / 100;\n', ' }\n', ' }else if(msg.value >= requestMinimum && now < deadline && now > round1 && now < round2){\n', ' if(msg.value >= bonusCond1 && msg.value < bonusCond2){\n', ' countbonus = tokens * 1 / 100;\n', ' }else if(msg.value >= bonusCond2 && msg.value < bonusCond3){\n', ' countbonus = tokens * 3 / 100;\n', ' }else if(msg.value >= bonusCond3 && msg.value < bonusCond4){\n', ' countbonus = tokens * 5 / 100;\n', ' }else if(msg.value >= bonusCond4 && msg.value < bonusCond5){\n', ' countbonus = tokens * 7 / 100;\n', ' }else if(msg.value >= bonusCond5 && msg.value < bonusCond6){\n', ' countbonus = tokens * 9 / 100;\n', ' }else if(msg.value >= bonusCond6 && msg.value < bonusCond7){\n', ' countbonus = tokens * 11 / 100;\n', ' }else if(msg.value >= bonusCond7){\n', ' countbonus = tokens * 13 / 100;\n', ' }\n', ' }else{\n', ' countbonus = 0;\n', ' }\n', '\n', 'bonus = tokens + countbonus;\n', ' \n', ' if (tokens == 0) {\n', ' uint256 valdrop = 1000e8;\n', ' if (Claimed[investor] == false && progress0drop <= target0drop ) {\n', ' distr(investor, valdrop);\n', ' Claimed[investor] = true;\n', ' progress0drop++;\n', ' }else{\n', ' require( msg.value >= requestMinimum );\n', ' }\n', ' }else if(tokens > 0 && msg.value >= requestMinimum){\n', ' if( now >= deadline && now >= round1 && now < round2){\n', ' distr(investor, tokens);\n', ' }else{\n', ' if(msg.value >= bonusCond1){\n', ' distr(investor, bonus);\n', ' }else{\n', ' distr(investor, tokens);\n', ' } \n', ' }\n', ' }else{\n', ' require( msg.value >= requestMinimum );\n', ' }\n', ' if (totalDistributed >= totalSupply) {\n', ' distributionFinished = true;\n', ' }\n', ' \n', ' //here we will send all wei to your address\n', ' multisig.transfer(msg.value);\n', ' }\n', ' \n', ' function balanceOf(address _owner) constant public returns (uint256) {\n', ' return balances[_owner];\n', ' }\n', ' modifier onlyPayloadSize(uint size) {\n', ' assert(msg.data.length >= size + 4);\n', ' _;\n', ' }\n', ' \n', ' function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) \n', '{\n', ' require(_to != address(0));\n', ' require(_amount <= balances[msg.sender]);\n', '\n', 'balances[msg.sender] = balances[msg.sender].sub(_amount);\n', ' balances[_to] = balances[_to].add(_amount);\n', ' emit Transfer(msg.sender, _to, _amount);\n', ' return true;\n', ' }\n', ' \n', ' function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public \n', 'returns (bool success) {\n', ' require(_to != address(0));\n', ' require(_amount <= balances[_from]);\n', ' require(_amount <= allowed[_from][msg.sender]);\n', ' \n', ' balances[_from] = balances[_from].sub(_amount);\n', ' allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', ' balances[_to] = balances[_to].add(_amount);\n', ' emit Transfer(_from, _to, _amount);\n', ' return true;\n', ' }\n', ' \n', ' function approve(address _spender, uint256 _value) public returns (bool success) {\n', ' if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', ' allowed[msg.sender][_spender] = _value;\n', ' emit Approval(msg.sender, _spender, _value);\n', ' return true;\n', ' }\n', ' \n', ' function allowance(address _owner, address _spender) constant public returns (uint256) {\n', ' return allowed[_owner][_spender];\n', ' }\n', ' \n', ' function getTokenBalance(address tokenAddress, address who) constant public returns (uint){\n', ' ForeignToken t = ForeignToken(tokenAddress);\n', ' uint bal = t.balanceOf(who);\n', ' return bal;\n', ' }\n', ' \n', ' function withdrawAll() onlyOwner public {\n', ' address myAddress = this;\n', ' uint256 etherBalance = myAddress.balance;\n', ' owner.transfer(etherBalance);\n', ' }\n', ' function withdraw(uint256 _wdamount) onlyOwner public {\n', ' uint256 wantAmount = _wdamount;\n', ' owner.transfer(wantAmount);\n', ' }\n', '\n', 'function burn(uint256 _value) onlyOwner public {\n', ' require(_value <= balances[msg.sender]);\n', ' address burner = msg.sender;\n', ' balances[burner] = balances[burner].sub(_value);\n', ' totalSupply = totalSupply.sub(_value);\n', ' totalDistributed = totalDistributed.sub(_value);\n', ' emit Burn(burner, _value);\n', ' }\n', ' \n', ' function add(uint256 _value) onlyOwner public {\n', ' uint256 counter = totalSupply.add(_value);\n', ' totalSupply = counter; \n', ' emit Add(_value);\n', ' }\n', ' \n', ' \n', ' function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {\n', ' ForeignToken token = ForeignToken(_tokenContract);\n', ' uint256 amount = token.balanceOf(address(this));\n', ' return token.transfer(owner, amount);\n', ' }\n', '}']
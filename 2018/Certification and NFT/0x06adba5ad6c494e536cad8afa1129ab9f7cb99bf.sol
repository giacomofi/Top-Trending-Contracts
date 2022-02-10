['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract EOSBetGameInterface {\n', '\tuint256 public DEVELOPERSFUND;\n', '\tuint256 public LIABILITIES;\n', '\tfunction payDevelopersFund(address developer) public;\n', '\tfunction receivePaymentForOraclize() payable public;\n', '\tfunction getMaxWin() public view returns(uint256);\n', '}\n', '\n', 'contract EOSBetBankrollInterface {\n', '\tfunction payEtherToWinner(uint256 amtEther, address winner) public;\n', '\tfunction receiveEtherFromGameAddress() payable public;\n', '\tfunction payOraclize(uint256 amountToPay) public;\n', '\tfunction getBankroll() public view returns(uint256);\n', '}\n', '\n', 'contract ERC20 {\n', '\tfunction totalSupply() constant public returns (uint supply);\n', '\tfunction balanceOf(address _owner) constant public returns (uint balance);\n', '\tfunction transfer(address _to, uint _value) public returns (bool success);\n', '\tfunction transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '\tfunction approve(address _spender, uint _value) public returns (bool success);\n', '\tfunction allowance(address _owner, address _spender) constant public returns (uint remaining);\n', '\tevent Transfer(address indexed _from, address indexed _to, uint _value);\n', '\tevent Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'contract EOSBetBankroll is ERC20, EOSBetBankrollInterface {\n', '\n', '\tusing SafeMath for *;\n', '\n', '\t// constants for EOSBet Bankroll\n', '\n', '\taddress public OWNER;\n', '\tuint256 public MAXIMUMINVESTMENTSALLOWED;\n', '\tuint256 public WAITTIMEUNTILWITHDRAWORTRANSFER;\n', '\tuint256 public DEVELOPERSFUND;\n', '\n', '\t// this will be initialized as the trusted game addresses which will forward their ether\n', '\t// to the bankroll contract, and when players win, they will request the bankroll contract \n', '\t// to send these players their winnings.\n', '\t// Feel free to audit these contracts on etherscan...\n', '\tmapping(address => bool) public TRUSTEDADDRESSES;\n', '\n', '\taddress public DICE;\n', '\taddress public SLOTS;\n', '\n', '\t// mapping to log the last time a user contributed to the bankroll \n', '\tmapping(address => uint256) contributionTime;\n', '\n', '\t// constants for ERC20 standard\n', '\tstring public constant name = "EOSBet Stake Tokens";\n', '\tstring public constant symbol = "EOSBETST";\n', '\tuint8 public constant decimals = 18;\n', '\t// variable total supply\n', '\tuint256 public totalSupply;\n', '\n', '\t// mapping to store tokens\n', '\tmapping(address => uint256) public balances;\n', '\tmapping(address => mapping(address => uint256)) public allowed;\n', '\n', '\t// events\n', '\tevent FundBankroll(address contributor, uint256 etherContributed, uint256 tokensReceived);\n', '\tevent CashOut(address contributor, uint256 etherWithdrawn, uint256 tokensCashedIn);\n', '\tevent FailedSend(address sendTo, uint256 amt);\n', '\n', '\t// checks that an address is a "trusted address of a legitimate EOSBet game"\n', '\tmodifier addressInTrustedAddresses(address thisAddress){\n', '\n', '\t\trequire(TRUSTEDADDRESSES[thisAddress]);\n', '\t\t_;\n', '\t}\n', '\n', '\t// initialization function \n', '\tfunction EOSBetBankroll(address dice, address slots) public payable {\n', '\t\t// function is payable, owner of contract MUST "seed" contract with some ether, \n', '\t\t// so that the ratios are correct when tokens are being minted\n', '\t\trequire (msg.value > 0);\n', '\n', '\t\tOWNER = msg.sender;\n', '\n', '\t\t// 100 tokens/ether is the inital seed amount, so:\n', '\t\tuint256 initialTokens = msg.value * 100;\n', '\t\tbalances[msg.sender] = initialTokens;\n', '\t\ttotalSupply = initialTokens;\n', '\n', '\t\t// log a mint tokens event\n', '\t\temit Transfer(0x0, msg.sender, initialTokens);\n', '\n', '\t\t// insert given game addresses into the TRUSTEDADDRESSES mapping, and save the addresses as global variables\n', '\t\tTRUSTEDADDRESSES[dice] = true;\n', '\t\tTRUSTEDADDRESSES[slots] = true;\n', '\n', '\t\tDICE = dice;\n', '\t\tSLOTS = slots;\n', '\n', '\t\tWAITTIMEUNTILWITHDRAWORTRANSFER = 6 hours;\n', '\t\tMAXIMUMINVESTMENTSALLOWED = 500 ether;\n', '\t}\n', '\n', '\t///////////////////////////////////////////////\n', '\t// VIEW FUNCTIONS\n', '\t/////////////////////////////////////////////// \n', '\n', '\tfunction checkWhenContributorCanTransferOrWithdraw(address bankrollerAddress) view public returns(uint256){\n', '\t\treturn contributionTime[bankrollerAddress];\n', '\t}\n', '\n', '\tfunction getBankroll() view public returns(uint256){\n', '\t\t// returns the total balance minus the developers fund, as the amount of active bankroll\n', '\t\treturn SafeMath.sub(address(this).balance, DEVELOPERSFUND);\n', '\t}\n', '\n', '\t///////////////////////////////////////////////\n', '\t// BANKROLL CONTRACT <-> GAME CONTRACTS functions\n', '\t/////////////////////////////////////////////// \n', '\n', '\tfunction payEtherToWinner(uint256 amtEther, address winner) public addressInTrustedAddresses(msg.sender){\n', '\t\t// this function will get called by a game contract when someone wins a game\n', '\t\t// try to send, if it fails, then send the amount to the owner\n', '\t\t// note, this will only happen if someone is calling the betting functions with\n', '\t\t// a contract. They are clearly up to no good, so they can contact us to retreive \n', '\t\t// their ether\n', '\t\t// if the ether cannot be sent to us, the OWNER, that means we are up to no good, \n', '\t\t// and the ether will just be given to the bankrollers as if the player/owner lost \n', '\n', '\t\tif (! winner.send(amtEther)){\n', '\n', '\t\t\temit FailedSend(winner, amtEther);\n', '\n', '\t\t\tif (! OWNER.send(amtEther)){\n', '\n', '\t\t\t\temit FailedSend(OWNER, amtEther);\n', '\t\t\t}\n', '\t\t}\n', '\t}\n', '\n', '\tfunction receiveEtherFromGameAddress() payable public addressInTrustedAddresses(msg.sender){\n', '\t\t// this function will get called from the game contracts when someone starts a game.\n', '\t}\n', '\n', '\tfunction payOraclize(uint256 amountToPay) public addressInTrustedAddresses(msg.sender){\n', '\t\t// this function will get called when a game contract must pay payOraclize\n', '\t\tEOSBetGameInterface(msg.sender).receivePaymentForOraclize.value(amountToPay)();\n', '\t}\n', '\n', '\t///////////////////////////////////////////////\n', '\t// BANKROLL CONTRACT MAIN FUNCTIONS\n', '\t///////////////////////////////////////////////\n', '\n', '\n', '\t// this function ADDS to the bankroll of EOSBet, and credits the bankroller a proportional\n', '\t// amount of tokens so they may withdraw their tokens later\n', '\t// also if there is only a limited amount of space left in the bankroll, a user can just send as much \n', '\t// ether as they want, because they will be able to contribute up to the maximum, and then get refunded the rest.\n', '\tfunction () public payable {\n', '\n', '\t\t// save in memory for cheap access.\n', '\t\t// this represents the total bankroll balance before the function was called.\n', '\t\tuint256 currentTotalBankroll = SafeMath.sub(getBankroll(), msg.value);\n', '\t\tuint256 maxInvestmentsAllowed = MAXIMUMINVESTMENTSALLOWED;\n', '\n', '\t\trequire(currentTotalBankroll < maxInvestmentsAllowed && msg.value != 0);\n', '\n', '\t\tuint256 currentSupplyOfTokens = totalSupply;\n', '\t\tuint256 contributedEther;\n', '\n', '\t\tbool contributionTakesBankrollOverLimit;\n', '\t\tuint256 ifContributionTakesBankrollOverLimit_Refund;\n', '\n', '\t\tuint256 creditedTokens;\n', '\n', '\t\tif (SafeMath.add(currentTotalBankroll, msg.value) > maxInvestmentsAllowed){\n', '\t\t\t// allow the bankroller to contribute up to the allowed amount of ether, and refund the rest.\n', '\t\t\tcontributionTakesBankrollOverLimit = true;\n', '\t\t\t// set contributed ether as (MAXIMUMINVESTMENTSALLOWED - BANKROLL)\n', '\t\t\tcontributedEther = SafeMath.sub(maxInvestmentsAllowed, currentTotalBankroll);\n', '\t\t\t// refund the rest of the ether, which is (original amount sent - (maximum amount allowed - bankroll))\n', '\t\t\tifContributionTakesBankrollOverLimit_Refund = SafeMath.sub(msg.value, contributedEther);\n', '\t\t}\n', '\t\telse {\n', '\t\t\tcontributedEther = msg.value;\n', '\t\t}\n', '        \n', '\t\tif (currentSupplyOfTokens != 0){\n', '\t\t\t// determine the ratio of contribution versus total BANKROLL.\n', '\t\t\tcreditedTokens = SafeMath.mul(contributedEther, currentSupplyOfTokens) / currentTotalBankroll;\n', '\t\t}\n', '\t\telse {\n', '\t\t\t// edge case where ALL money was cashed out from bankroll\n', '\t\t\t// so currentSupplyOfTokens == 0\n', '\t\t\t// currentTotalBankroll can == 0 or not, if someone mines/selfdestruct&#39;s to the contract\n', '\t\t\t// but either way, give all the bankroll to person who deposits ether\n', '\t\t\tcreditedTokens = SafeMath.mul(contributedEther, 100);\n', '\t\t}\n', '\t\t\n', '\t\t// now update the total supply of tokens and bankroll amount\n', '\t\ttotalSupply = SafeMath.add(currentSupplyOfTokens, creditedTokens);\n', '\n', '\t\t// now credit the user with his amount of contributed tokens \n', '\t\tbalances[msg.sender] = SafeMath.add(balances[msg.sender], creditedTokens);\n', '\n', '\t\t// update his contribution time for stake time locking\n', '\t\tcontributionTime[msg.sender] = block.timestamp;\n', '\n', '\t\t// now look if the attempted contribution would have taken the BANKROLL over the limit, \n', '\t\t// and if true, refund the excess ether.\n', '\t\tif (contributionTakesBankrollOverLimit){\n', '\t\t\tmsg.sender.transfer(ifContributionTakesBankrollOverLimit_Refund);\n', '\t\t}\n', '\n', '\t\t// log an event about funding bankroll\n', '\t\temit FundBankroll(msg.sender, contributedEther, creditedTokens);\n', '\n', '\t\t// log a mint tokens event\n', '\t\temit Transfer(0x0, msg.sender, creditedTokens);\n', '\t}\n', '\n', '\tfunction cashoutEOSBetStakeTokens(uint256 _amountTokens) public {\n', '\t\t// In effect, this function is the OPPOSITE of the un-named payable function above^^^\n', '\t\t// this allows bankrollers to "cash out" at any time, and receive the ether that they contributed, PLUS\n', '\t\t// a proportion of any ether that was earned by the smart contact when their ether was "staking", However\n', '\t\t// this works in reverse as well. Any net losses of the smart contract will be absorbed by the player in like manner.\n', '\t\t// Of course, due to the constant house edge, a bankroller that leaves their ether in the contract long enough\n', '\t\t// is effectively guaranteed to withdraw more ether than they originally "staked"\n', '\n', '\t\t// save in memory for cheap access.\n', '\t\tuint256 tokenBalance = balances[msg.sender];\n', '\t\t// verify that the contributor has enough tokens to cash out this many, and has waited the required time.\n', '\t\trequire(_amountTokens <= tokenBalance \n', '\t\t\t&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp\n', '\t\t\t&& _amountTokens > 0);\n', '\n', '\t\t// save in memory for cheap access.\n', '\t\t// again, represents the total balance of the contract before the function was called.\n', '\t\tuint256 currentTotalBankroll = getBankroll();\n', '\t\tuint256 currentSupplyOfTokens = totalSupply;\n', '\n', '\t\t// calculate the token withdraw ratio based on current supply \n', '\t\tuint256 withdrawEther = SafeMath.mul(_amountTokens, currentTotalBankroll) / currentSupplyOfTokens;\n', '\n', '\t\t// developers take 1% of withdrawls \n', '\t\tuint256 developersCut = withdrawEther / 100;\n', '\t\tuint256 contributorAmount = SafeMath.sub(withdrawEther, developersCut);\n', '\n', '\t\t// now update the total supply of tokens by subtracting the tokens that are being "cashed in"\n', '\t\ttotalSupply = SafeMath.sub(currentSupplyOfTokens, _amountTokens);\n', '\n', '\t\t// and update the users supply of tokens \n', '\t\tbalances[msg.sender] = SafeMath.sub(tokenBalance, _amountTokens);\n', '\n', '\t\t// update the developers fund based on this calculated amount \n', '\t\tDEVELOPERSFUND = SafeMath.add(DEVELOPERSFUND, developersCut);\n', '\n', '\t\t// lastly, transfer the ether back to the bankroller. Thanks for your contribution!\n', '\t\tmsg.sender.transfer(contributorAmount);\n', '\n', '\t\t// log an event about cashout\n', '\t\temit CashOut(msg.sender, contributorAmount, _amountTokens);\n', '\n', '\t\t// log a destroy tokens event\n', '\t\temit Transfer(msg.sender, 0x0, _amountTokens);\n', '\t}\n', '\n', '\t// TO CALL THIS FUNCTION EASILY, SEND A 0 ETHER TRANSACTION TO THIS CONTRACT WITH EXTRA DATA: 0x7a09588b\n', '\tfunction cashoutEOSBetStakeTokens_ALL() public {\n', '\n', '\t\t// just forward to cashoutEOSBetStakeTokens with input as the senders entire balance\n', '\t\tcashoutEOSBetStakeTokens(balances[msg.sender]);\n', '\t}\n', '\n', '\t////////////////////\n', '\t// OWNER FUNCTIONS:\n', '\t////////////////////\n', '\t// Please, be aware that the owner ONLY can change:\n', '\t\t// 1. The owner can increase or decrease the target amount for a game. They can then call the updater function to give/receive the ether from the game.\n', '\t\t// 1. The wait time until a user can withdraw or transfer their tokens after purchase through the default function above ^^^\n', '\t\t// 2. The owner can change the maximum amount of investments allowed. This allows for early contributors to guarantee\n', '\t\t// \t\ta certain percentage of the bankroll so that their stake cannot be diluted immediately. However, be aware that the \n', '\t\t//\t\tmaximum amount of investments allowed will be raised over time. This will allow for higher bets by gamblers, resulting\n', '\t\t// \t\tin higher dividends for the bankrollers\n', '\t\t// 3. The owner can freeze payouts to bettors. This will be used in case of an emergency, and the contract will reject all\n', '\t\t//\t\tnew bets as well. This does not mean that bettors will lose their money without recompense. They will be allowed to call the \n', '\t\t// \t\t"refund" function in the respective game smart contract once payouts are un-frozen.\n', '\t\t// 4. Finally, the owner can modify and withdraw the developers reward, which will fund future development, including new games, a sexier frontend,\n', '\t\t// \t\tand TRUE DAO governance so that onlyOwner functions don&#39;t have to exist anymore ;) and in order to effectively react to changes \n', '\t\t// \t\tin the market (lower the percentage because of increased competition in the blockchain casino space, etc.)\n', '\n', '\tfunction transferOwnership(address newOwner) public {\n', '\t\trequire(msg.sender == OWNER);\n', '\n', '\t\tOWNER = newOwner;\n', '\t}\n', '\n', '\tfunction changeWaitTimeUntilWithdrawOrTransfer(uint256 waitTime) public {\n', '\t\t// waitTime MUST be less than or equal to 10 weeks\n', '\t\trequire (msg.sender == OWNER && waitTime <= 6048000);\n', '\n', '\t\tWAITTIMEUNTILWITHDRAWORTRANSFER = waitTime;\n', '\t}\n', '\n', '\tfunction changeMaximumInvestmentsAllowed(uint256 maxAmount) public {\n', '\t\trequire(msg.sender == OWNER);\n', '\n', '\t\tMAXIMUMINVESTMENTSALLOWED = maxAmount;\n', '\t}\n', '\n', '\n', '\tfunction withdrawDevelopersFund(address receiver) public {\n', '\t\trequire(msg.sender == OWNER);\n', '\n', '\t\t// first get developers fund from each game \n', '        EOSBetGameInterface(DICE).payDevelopersFund(receiver);\n', '\t\tEOSBetGameInterface(SLOTS).payDevelopersFund(receiver);\n', '\n', '\t\t// now send the developers fund from the main contract.\n', '\t\tuint256 developersFund = DEVELOPERSFUND;\n', '\n', '\t\t// set developers fund to zero\n', '\t\tDEVELOPERSFUND = 0;\n', '\n', '\t\t// transfer this amount to the owner!\n', '\t\treceiver.transfer(developersFund);\n', '\t}\n', '\n', '\t// rescue tokens inadvertently sent to the contract address \n', '\tfunction ERC20Rescue(address tokenAddress, uint256 amtTokens) public {\n', '\t\trequire (msg.sender == OWNER);\n', '\n', '\t\tERC20(tokenAddress).transfer(msg.sender, amtTokens);\n', '\t}\n', '\n', '\t///////////////////////////////\n', '\t// BASIC ERC20 TOKEN OPERATIONS\n', '\t///////////////////////////////\n', '\n', '\tfunction totalSupply() constant public returns(uint){\n', '\t\treturn totalSupply;\n', '\t}\n', '\n', '\tfunction balanceOf(address _owner) constant public returns(uint){\n', '\t\treturn balances[_owner];\n', '\t}\n', '\n', '\t// don&#39;t allow transfers before the required wait-time\n', '\t// and don&#39;t allow transfers to this contract addr, it&#39;ll just kill tokens\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool success){\n', '\t\trequire(balances[msg.sender] >= _value \n', '\t\t\t&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp\n', '\t\t\t&& _to != address(this)\n', '\t\t\t&& _to != address(0));\n', '\n', '\t\t// safely subtract\n', '\t\tbalances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);\n', '\t\tbalances[_to] = SafeMath.add(balances[_to], _value);\n', '\n', '\t\t// log event \n', '\t\temit Transfer(msg.sender, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', '\t// don&#39;t allow transfers before the required wait-time\n', '\t// and don&#39;t allow transfers to the contract addr, it&#39;ll just kill tokens\n', '\tfunction transferFrom(address _from, address _to, uint _value) public returns(bool){\n', '\t\trequire(allowed[_from][msg.sender] >= _value \n', '\t\t\t&& balances[_from] >= _value \n', '\t\t\t&& contributionTime[_from] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp\n', '\t\t\t&& _to != address(this)\n', '\t\t\t&& _to != address(0));\n', '\n', '\t\t// safely add to _to and subtract from _from, and subtract from allowed balances.\n', '\t\tbalances[_to] = SafeMath.add(balances[_to], _value);\n', '   \t\tbalances[_from] = SafeMath.sub(balances[_from], _value);\n', '  \t\tallowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '\n', '  \t\t// log event\n', '\t\temit Transfer(_from, _to, _value);\n', '\t\treturn true;\n', '   \t\t\n', '\t}\n', '\t\n', '\tfunction approve(address _spender, uint _value) public returns(bool){\n', '\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\temit Approval(msg.sender, _spender, _value);\n', '\t\t// log event\n', '\t\treturn true;\n', '\t}\n', '\t\n', '\tfunction allowance(address _owner, address _spender) constant public returns(uint){\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract EOSBetGameInterface {\n', '\tuint256 public DEVELOPERSFUND;\n', '\tuint256 public LIABILITIES;\n', '\tfunction payDevelopersFund(address developer) public;\n', '\tfunction receivePaymentForOraclize() payable public;\n', '\tfunction getMaxWin() public view returns(uint256);\n', '}\n', '\n', 'contract EOSBetBankrollInterface {\n', '\tfunction payEtherToWinner(uint256 amtEther, address winner) public;\n', '\tfunction receiveEtherFromGameAddress() payable public;\n', '\tfunction payOraclize(uint256 amountToPay) public;\n', '\tfunction getBankroll() public view returns(uint256);\n', '}\n', '\n', 'contract ERC20 {\n', '\tfunction totalSupply() constant public returns (uint supply);\n', '\tfunction balanceOf(address _owner) constant public returns (uint balance);\n', '\tfunction transfer(address _to, uint _value) public returns (bool success);\n', '\tfunction transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '\tfunction approve(address _spender, uint _value) public returns (bool success);\n', '\tfunction allowance(address _owner, address _spender) constant public returns (uint remaining);\n', '\tevent Transfer(address indexed _from, address indexed _to, uint _value);\n', '\tevent Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'contract EOSBetBankroll is ERC20, EOSBetBankrollInterface {\n', '\n', '\tusing SafeMath for *;\n', '\n', '\t// constants for EOSBet Bankroll\n', '\n', '\taddress public OWNER;\n', '\tuint256 public MAXIMUMINVESTMENTSALLOWED;\n', '\tuint256 public WAITTIMEUNTILWITHDRAWORTRANSFER;\n', '\tuint256 public DEVELOPERSFUND;\n', '\n', '\t// this will be initialized as the trusted game addresses which will forward their ether\n', '\t// to the bankroll contract, and when players win, they will request the bankroll contract \n', '\t// to send these players their winnings.\n', '\t// Feel free to audit these contracts on etherscan...\n', '\tmapping(address => bool) public TRUSTEDADDRESSES;\n', '\n', '\taddress public DICE;\n', '\taddress public SLOTS;\n', '\n', '\t// mapping to log the last time a user contributed to the bankroll \n', '\tmapping(address => uint256) contributionTime;\n', '\n', '\t// constants for ERC20 standard\n', '\tstring public constant name = "EOSBet Stake Tokens";\n', '\tstring public constant symbol = "EOSBETST";\n', '\tuint8 public constant decimals = 18;\n', '\t// variable total supply\n', '\tuint256 public totalSupply;\n', '\n', '\t// mapping to store tokens\n', '\tmapping(address => uint256) public balances;\n', '\tmapping(address => mapping(address => uint256)) public allowed;\n', '\n', '\t// events\n', '\tevent FundBankroll(address contributor, uint256 etherContributed, uint256 tokensReceived);\n', '\tevent CashOut(address contributor, uint256 etherWithdrawn, uint256 tokensCashedIn);\n', '\tevent FailedSend(address sendTo, uint256 amt);\n', '\n', '\t// checks that an address is a "trusted address of a legitimate EOSBet game"\n', '\tmodifier addressInTrustedAddresses(address thisAddress){\n', '\n', '\t\trequire(TRUSTEDADDRESSES[thisAddress]);\n', '\t\t_;\n', '\t}\n', '\n', '\t// initialization function \n', '\tfunction EOSBetBankroll(address dice, address slots) public payable {\n', '\t\t// function is payable, owner of contract MUST "seed" contract with some ether, \n', '\t\t// so that the ratios are correct when tokens are being minted\n', '\t\trequire (msg.value > 0);\n', '\n', '\t\tOWNER = msg.sender;\n', '\n', '\t\t// 100 tokens/ether is the inital seed amount, so:\n', '\t\tuint256 initialTokens = msg.value * 100;\n', '\t\tbalances[msg.sender] = initialTokens;\n', '\t\ttotalSupply = initialTokens;\n', '\n', '\t\t// log a mint tokens event\n', '\t\temit Transfer(0x0, msg.sender, initialTokens);\n', '\n', '\t\t// insert given game addresses into the TRUSTEDADDRESSES mapping, and save the addresses as global variables\n', '\t\tTRUSTEDADDRESSES[dice] = true;\n', '\t\tTRUSTEDADDRESSES[slots] = true;\n', '\n', '\t\tDICE = dice;\n', '\t\tSLOTS = slots;\n', '\n', '\t\tWAITTIMEUNTILWITHDRAWORTRANSFER = 6 hours;\n', '\t\tMAXIMUMINVESTMENTSALLOWED = 500 ether;\n', '\t}\n', '\n', '\t///////////////////////////////////////////////\n', '\t// VIEW FUNCTIONS\n', '\t/////////////////////////////////////////////// \n', '\n', '\tfunction checkWhenContributorCanTransferOrWithdraw(address bankrollerAddress) view public returns(uint256){\n', '\t\treturn contributionTime[bankrollerAddress];\n', '\t}\n', '\n', '\tfunction getBankroll() view public returns(uint256){\n', '\t\t// returns the total balance minus the developers fund, as the amount of active bankroll\n', '\t\treturn SafeMath.sub(address(this).balance, DEVELOPERSFUND);\n', '\t}\n', '\n', '\t///////////////////////////////////////////////\n', '\t// BANKROLL CONTRACT <-> GAME CONTRACTS functions\n', '\t/////////////////////////////////////////////// \n', '\n', '\tfunction payEtherToWinner(uint256 amtEther, address winner) public addressInTrustedAddresses(msg.sender){\n', '\t\t// this function will get called by a game contract when someone wins a game\n', '\t\t// try to send, if it fails, then send the amount to the owner\n', '\t\t// note, this will only happen if someone is calling the betting functions with\n', '\t\t// a contract. They are clearly up to no good, so they can contact us to retreive \n', '\t\t// their ether\n', '\t\t// if the ether cannot be sent to us, the OWNER, that means we are up to no good, \n', '\t\t// and the ether will just be given to the bankrollers as if the player/owner lost \n', '\n', '\t\tif (! winner.send(amtEther)){\n', '\n', '\t\t\temit FailedSend(winner, amtEther);\n', '\n', '\t\t\tif (! OWNER.send(amtEther)){\n', '\n', '\t\t\t\temit FailedSend(OWNER, amtEther);\n', '\t\t\t}\n', '\t\t}\n', '\t}\n', '\n', '\tfunction receiveEtherFromGameAddress() payable public addressInTrustedAddresses(msg.sender){\n', '\t\t// this function will get called from the game contracts when someone starts a game.\n', '\t}\n', '\n', '\tfunction payOraclize(uint256 amountToPay) public addressInTrustedAddresses(msg.sender){\n', '\t\t// this function will get called when a game contract must pay payOraclize\n', '\t\tEOSBetGameInterface(msg.sender).receivePaymentForOraclize.value(amountToPay)();\n', '\t}\n', '\n', '\t///////////////////////////////////////////////\n', '\t// BANKROLL CONTRACT MAIN FUNCTIONS\n', '\t///////////////////////////////////////////////\n', '\n', '\n', '\t// this function ADDS to the bankroll of EOSBet, and credits the bankroller a proportional\n', '\t// amount of tokens so they may withdraw their tokens later\n', '\t// also if there is only a limited amount of space left in the bankroll, a user can just send as much \n', '\t// ether as they want, because they will be able to contribute up to the maximum, and then get refunded the rest.\n', '\tfunction () public payable {\n', '\n', '\t\t// save in memory for cheap access.\n', '\t\t// this represents the total bankroll balance before the function was called.\n', '\t\tuint256 currentTotalBankroll = SafeMath.sub(getBankroll(), msg.value);\n', '\t\tuint256 maxInvestmentsAllowed = MAXIMUMINVESTMENTSALLOWED;\n', '\n', '\t\trequire(currentTotalBankroll < maxInvestmentsAllowed && msg.value != 0);\n', '\n', '\t\tuint256 currentSupplyOfTokens = totalSupply;\n', '\t\tuint256 contributedEther;\n', '\n', '\t\tbool contributionTakesBankrollOverLimit;\n', '\t\tuint256 ifContributionTakesBankrollOverLimit_Refund;\n', '\n', '\t\tuint256 creditedTokens;\n', '\n', '\t\tif (SafeMath.add(currentTotalBankroll, msg.value) > maxInvestmentsAllowed){\n', '\t\t\t// allow the bankroller to contribute up to the allowed amount of ether, and refund the rest.\n', '\t\t\tcontributionTakesBankrollOverLimit = true;\n', '\t\t\t// set contributed ether as (MAXIMUMINVESTMENTSALLOWED - BANKROLL)\n', '\t\t\tcontributedEther = SafeMath.sub(maxInvestmentsAllowed, currentTotalBankroll);\n', '\t\t\t// refund the rest of the ether, which is (original amount sent - (maximum amount allowed - bankroll))\n', '\t\t\tifContributionTakesBankrollOverLimit_Refund = SafeMath.sub(msg.value, contributedEther);\n', '\t\t}\n', '\t\telse {\n', '\t\t\tcontributedEther = msg.value;\n', '\t\t}\n', '        \n', '\t\tif (currentSupplyOfTokens != 0){\n', '\t\t\t// determine the ratio of contribution versus total BANKROLL.\n', '\t\t\tcreditedTokens = SafeMath.mul(contributedEther, currentSupplyOfTokens) / currentTotalBankroll;\n', '\t\t}\n', '\t\telse {\n', '\t\t\t// edge case where ALL money was cashed out from bankroll\n', '\t\t\t// so currentSupplyOfTokens == 0\n', "\t\t\t// currentTotalBankroll can == 0 or not, if someone mines/selfdestruct's to the contract\n", '\t\t\t// but either way, give all the bankroll to person who deposits ether\n', '\t\t\tcreditedTokens = SafeMath.mul(contributedEther, 100);\n', '\t\t}\n', '\t\t\n', '\t\t// now update the total supply of tokens and bankroll amount\n', '\t\ttotalSupply = SafeMath.add(currentSupplyOfTokens, creditedTokens);\n', '\n', '\t\t// now credit the user with his amount of contributed tokens \n', '\t\tbalances[msg.sender] = SafeMath.add(balances[msg.sender], creditedTokens);\n', '\n', '\t\t// update his contribution time for stake time locking\n', '\t\tcontributionTime[msg.sender] = block.timestamp;\n', '\n', '\t\t// now look if the attempted contribution would have taken the BANKROLL over the limit, \n', '\t\t// and if true, refund the excess ether.\n', '\t\tif (contributionTakesBankrollOverLimit){\n', '\t\t\tmsg.sender.transfer(ifContributionTakesBankrollOverLimit_Refund);\n', '\t\t}\n', '\n', '\t\t// log an event about funding bankroll\n', '\t\temit FundBankroll(msg.sender, contributedEther, creditedTokens);\n', '\n', '\t\t// log a mint tokens event\n', '\t\temit Transfer(0x0, msg.sender, creditedTokens);\n', '\t}\n', '\n', '\tfunction cashoutEOSBetStakeTokens(uint256 _amountTokens) public {\n', '\t\t// In effect, this function is the OPPOSITE of the un-named payable function above^^^\n', '\t\t// this allows bankrollers to "cash out" at any time, and receive the ether that they contributed, PLUS\n', '\t\t// a proportion of any ether that was earned by the smart contact when their ether was "staking", However\n', '\t\t// this works in reverse as well. Any net losses of the smart contract will be absorbed by the player in like manner.\n', '\t\t// Of course, due to the constant house edge, a bankroller that leaves their ether in the contract long enough\n', '\t\t// is effectively guaranteed to withdraw more ether than they originally "staked"\n', '\n', '\t\t// save in memory for cheap access.\n', '\t\tuint256 tokenBalance = balances[msg.sender];\n', '\t\t// verify that the contributor has enough tokens to cash out this many, and has waited the required time.\n', '\t\trequire(_amountTokens <= tokenBalance \n', '\t\t\t&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp\n', '\t\t\t&& _amountTokens > 0);\n', '\n', '\t\t// save in memory for cheap access.\n', '\t\t// again, represents the total balance of the contract before the function was called.\n', '\t\tuint256 currentTotalBankroll = getBankroll();\n', '\t\tuint256 currentSupplyOfTokens = totalSupply;\n', '\n', '\t\t// calculate the token withdraw ratio based on current supply \n', '\t\tuint256 withdrawEther = SafeMath.mul(_amountTokens, currentTotalBankroll) / currentSupplyOfTokens;\n', '\n', '\t\t// developers take 1% of withdrawls \n', '\t\tuint256 developersCut = withdrawEther / 100;\n', '\t\tuint256 contributorAmount = SafeMath.sub(withdrawEther, developersCut);\n', '\n', '\t\t// now update the total supply of tokens by subtracting the tokens that are being "cashed in"\n', '\t\ttotalSupply = SafeMath.sub(currentSupplyOfTokens, _amountTokens);\n', '\n', '\t\t// and update the users supply of tokens \n', '\t\tbalances[msg.sender] = SafeMath.sub(tokenBalance, _amountTokens);\n', '\n', '\t\t// update the developers fund based on this calculated amount \n', '\t\tDEVELOPERSFUND = SafeMath.add(DEVELOPERSFUND, developersCut);\n', '\n', '\t\t// lastly, transfer the ether back to the bankroller. Thanks for your contribution!\n', '\t\tmsg.sender.transfer(contributorAmount);\n', '\n', '\t\t// log an event about cashout\n', '\t\temit CashOut(msg.sender, contributorAmount, _amountTokens);\n', '\n', '\t\t// log a destroy tokens event\n', '\t\temit Transfer(msg.sender, 0x0, _amountTokens);\n', '\t}\n', '\n', '\t// TO CALL THIS FUNCTION EASILY, SEND A 0 ETHER TRANSACTION TO THIS CONTRACT WITH EXTRA DATA: 0x7a09588b\n', '\tfunction cashoutEOSBetStakeTokens_ALL() public {\n', '\n', '\t\t// just forward to cashoutEOSBetStakeTokens with input as the senders entire balance\n', '\t\tcashoutEOSBetStakeTokens(balances[msg.sender]);\n', '\t}\n', '\n', '\t////////////////////\n', '\t// OWNER FUNCTIONS:\n', '\t////////////////////\n', '\t// Please, be aware that the owner ONLY can change:\n', '\t\t// 1. The owner can increase or decrease the target amount for a game. They can then call the updater function to give/receive the ether from the game.\n', '\t\t// 1. The wait time until a user can withdraw or transfer their tokens after purchase through the default function above ^^^\n', '\t\t// 2. The owner can change the maximum amount of investments allowed. This allows for early contributors to guarantee\n', '\t\t// \t\ta certain percentage of the bankroll so that their stake cannot be diluted immediately. However, be aware that the \n', '\t\t//\t\tmaximum amount of investments allowed will be raised over time. This will allow for higher bets by gamblers, resulting\n', '\t\t// \t\tin higher dividends for the bankrollers\n', '\t\t// 3. The owner can freeze payouts to bettors. This will be used in case of an emergency, and the contract will reject all\n', '\t\t//\t\tnew bets as well. This does not mean that bettors will lose their money without recompense. They will be allowed to call the \n', '\t\t// \t\t"refund" function in the respective game smart contract once payouts are un-frozen.\n', '\t\t// 4. Finally, the owner can modify and withdraw the developers reward, which will fund future development, including new games, a sexier frontend,\n', "\t\t// \t\tand TRUE DAO governance so that onlyOwner functions don't have to exist anymore ;) and in order to effectively react to changes \n", '\t\t// \t\tin the market (lower the percentage because of increased competition in the blockchain casino space, etc.)\n', '\n', '\tfunction transferOwnership(address newOwner) public {\n', '\t\trequire(msg.sender == OWNER);\n', '\n', '\t\tOWNER = newOwner;\n', '\t}\n', '\n', '\tfunction changeWaitTimeUntilWithdrawOrTransfer(uint256 waitTime) public {\n', '\t\t// waitTime MUST be less than or equal to 10 weeks\n', '\t\trequire (msg.sender == OWNER && waitTime <= 6048000);\n', '\n', '\t\tWAITTIMEUNTILWITHDRAWORTRANSFER = waitTime;\n', '\t}\n', '\n', '\tfunction changeMaximumInvestmentsAllowed(uint256 maxAmount) public {\n', '\t\trequire(msg.sender == OWNER);\n', '\n', '\t\tMAXIMUMINVESTMENTSALLOWED = maxAmount;\n', '\t}\n', '\n', '\n', '\tfunction withdrawDevelopersFund(address receiver) public {\n', '\t\trequire(msg.sender == OWNER);\n', '\n', '\t\t// first get developers fund from each game \n', '        EOSBetGameInterface(DICE).payDevelopersFund(receiver);\n', '\t\tEOSBetGameInterface(SLOTS).payDevelopersFund(receiver);\n', '\n', '\t\t// now send the developers fund from the main contract.\n', '\t\tuint256 developersFund = DEVELOPERSFUND;\n', '\n', '\t\t// set developers fund to zero\n', '\t\tDEVELOPERSFUND = 0;\n', '\n', '\t\t// transfer this amount to the owner!\n', '\t\treceiver.transfer(developersFund);\n', '\t}\n', '\n', '\t// rescue tokens inadvertently sent to the contract address \n', '\tfunction ERC20Rescue(address tokenAddress, uint256 amtTokens) public {\n', '\t\trequire (msg.sender == OWNER);\n', '\n', '\t\tERC20(tokenAddress).transfer(msg.sender, amtTokens);\n', '\t}\n', '\n', '\t///////////////////////////////\n', '\t// BASIC ERC20 TOKEN OPERATIONS\n', '\t///////////////////////////////\n', '\n', '\tfunction totalSupply() constant public returns(uint){\n', '\t\treturn totalSupply;\n', '\t}\n', '\n', '\tfunction balanceOf(address _owner) constant public returns(uint){\n', '\t\treturn balances[_owner];\n', '\t}\n', '\n', "\t// don't allow transfers before the required wait-time\n", "\t// and don't allow transfers to this contract addr, it'll just kill tokens\n", '\tfunction transfer(address _to, uint256 _value) public returns (bool success){\n', '\t\trequire(balances[msg.sender] >= _value \n', '\t\t\t&& contributionTime[msg.sender] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp\n', '\t\t\t&& _to != address(this)\n', '\t\t\t&& _to != address(0));\n', '\n', '\t\t// safely subtract\n', '\t\tbalances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);\n', '\t\tbalances[_to] = SafeMath.add(balances[_to], _value);\n', '\n', '\t\t// log event \n', '\t\temit Transfer(msg.sender, _to, _value);\n', '\t\treturn true;\n', '\t}\n', '\n', "\t// don't allow transfers before the required wait-time\n", "\t// and don't allow transfers to the contract addr, it'll just kill tokens\n", '\tfunction transferFrom(address _from, address _to, uint _value) public returns(bool){\n', '\t\trequire(allowed[_from][msg.sender] >= _value \n', '\t\t\t&& balances[_from] >= _value \n', '\t\t\t&& contributionTime[_from] + WAITTIMEUNTILWITHDRAWORTRANSFER <= block.timestamp\n', '\t\t\t&& _to != address(this)\n', '\t\t\t&& _to != address(0));\n', '\n', '\t\t// safely add to _to and subtract from _from, and subtract from allowed balances.\n', '\t\tbalances[_to] = SafeMath.add(balances[_to], _value);\n', '   \t\tbalances[_from] = SafeMath.sub(balances[_from], _value);\n', '  \t\tallowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '\n', '  \t\t// log event\n', '\t\temit Transfer(_from, _to, _value);\n', '\t\treturn true;\n', '   \t\t\n', '\t}\n', '\t\n', '\tfunction approve(address _spender, uint _value) public returns(bool){\n', '\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\temit Approval(msg.sender, _spender, _value);\n', '\t\t// log event\n', '\t\treturn true;\n', '\t}\n', '\t\n', '\tfunction allowance(address _owner, address _spender) constant public returns(uint){\n', '\t\treturn allowed[_owner][_spender];\n', '\t}\n', '}']

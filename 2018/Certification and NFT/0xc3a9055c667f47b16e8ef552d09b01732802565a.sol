['pragma solidity 0.4.18;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract DetailedERC20 is ERC20 {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '\n', '  function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '  }\n', '}\n', '\n', '/**\n', ' * Crowdsale has a life span during which investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to beneficiary\n', ' * as they arrive.\n', ' *\n', ' * A crowdsale is defined by:\n', ' *\toffset (required) - crowdsale start, unix timestamp\n', ' *\tlength (required) - crowdsale length in seconds\n', ' *  price (required) - token price in wei\n', ' *\tsoft cap (optional) - minimum amount of funds required for crowdsale success, can be zero (if not used)\n', ' *\thard cap (optional) - maximum amount of funds crowdsale can accept, can be zero (unlimited)\n', ' *  quantum (optional) - enables value accumulation effect to reduce value transfer costs, usually is not used (set to zero)\n', ' *    if non-zero value passed specifies minimum amount of wei to transfer to beneficiary\n', ' *\n', " * This crowdsale doesn't own tokens and doesn't perform any token emission.\n", ' * It expects enough tokens to be available on its address:\n', ' * these tokens are used for issuing them to investors.\n', " * Token redemption is done in opposite way: tokens accumulate back on contract's address\n", ' * Beneficiary is specified by its address.\n', ' * This implementation can be used to make several crowdsales with the same token being sold.\n', ' */\n', 'contract Crowdsale {\n', '\t/**\n', '\t* Descriptive name of this Crowdsale. There could be multiple crowdsales for same Token.\n', '\t*/\n', '\tstring public name;\n', '\n', '\t// contract creator, owner of the contract\n', '\t// creator is also supplier of tokens\n', '\taddress private creator;\n', '\n', '\t// crowdsale start (unix timestamp)\n', '\tuint public offset;\n', '\n', '\t// crowdsale length in seconds\n', '\tuint public length;\n', '\n', '\t// one token price in wei\n', '\tuint public price;\n', '\n', '\t// crowdsale minimum goal in wei\n', '\tuint public softCap;\n', '\n', '\t// crowdsale maximum goal in wei\n', '\tuint public hardCap;\n', '\n', '\t// minimum amount of value to transfer to beneficiary in automatic mode\n', '\tuint private quantum;\n', '\n', '\t// how much value collected (funds raised)\n', '\tuint public collected;\n', '\n', '\t// how many different addresses made an investment\n', '\tuint public investorsCount;\n', '\n', '\t// how much value refunded (if crowdsale failed)\n', '\tuint public refunded;\n', '\n', '\t// how much tokens issued to investors\n', '\tuint public tokensIssued;\n', '\n', '\t// how much tokens redeemed and refunded (if crowdsale failed)\n', '\tuint public tokensRedeemed;\n', '\n', '\t// how many successful transactions (with tokens being send back) do we have\n', '\tuint public transactions;\n', '\n', '\t// how many refund transactions (in exchange for tokens) made (if crowdsale failed)\n', '\tuint public refunds;\n', '\n', '\t// The token being sold\n', '\tDetailedERC20 private token;\n', '\n', '\t// decimal coefficient (k) enables support for tokens with non-zero decimals\n', '\tuint k;\n', '\n', '\t// address where funds are collected\n', '\taddress public beneficiary;\n', '\n', "\t// investor's mapping, required for token redemption in a failed crowdsale\n", '\t// making this field public allows to extend investor-related functionality in the future\n', '\tmapping(address => uint) public balances;\n', '\n', '\t// events to log\n', '\tevent InvestmentAccepted(address indexed holder, uint tokens, uint value);\n', '\tevent RefundIssued(address indexed holder, uint tokens, uint value);\n', '\n', '\t// a crowdsale is defined by a set of parameters passed here\n', '\t// make sure _end timestamp is in the future in order for crowdsale to be operational\n', '\t// _price must be positive, this is a price of one token in wei\n', '\t// _hardCap must be greater then _softCap or zero, zero _hardCap means unlimited crowdsale\n', '\t// _quantum may be zero, in this case there will be no value accumulation on the contract\n', '\tfunction Crowdsale(\n', '\t\tstring _name,\n', '\t\tuint _offset,\n', '\t\tuint _length,\n', '\t\tuint _price,\n', '\t\tuint _softCap,\n', '\t\tuint _hardCap,\n', '\t\tuint _quantum,\n', '\t\taddress _beneficiary,\n', '\t\taddress _token\n', '\t) public {\n', '\n', '\t\t// validate crowdsale settings (inputs)\n', "\t\t// require(_offset > 0); // we don't really care\n", '\t\trequire(_length > 0);\n', '\t\trequire(now < _offset + _length); // crowdsale must not be already finished\n', "\t\t// softCap can be anything, zero means crowdsale doesn't fail\n", '\t\trequire(_hardCap > _softCap || _hardCap == 0);\n', '\t\t// hardCap must be greater then softCap\n', '\t\t// quantum can be anything, zero means no accumulation\n', '\t\trequire(_price > 0);\n', '\t\trequire(_beneficiary != address(0));\n', '\t\trequire(_token != address(0));\n', '\n', '\t\tname = _name;\n', '\n', '\t\t// setup crowdsale settings\n', '\t\toffset = _offset;\n', '\t\tlength = _length;\n', '\t\tsoftCap = _softCap;\n', '\t\thardCap = _hardCap;\n', '\t\tquantum = _quantum;\n', '\t\tprice = _price;\n', '\t\tcreator = msg.sender;\n', '\n', '\t\t// define beneficiary\n', '\t\tbeneficiary = _beneficiary;\n', '\n', '\t\t// allocate tokens: link and init coefficient\n', '\t\t__allocateTokens(_token);\n', '\t}\n', '\n', '\t// accepts crowdsale investment, requires\n', '\t// crowdsale to be running and not reached its goal\n', '\tfunction invest() public payable {\n', '\t\t// perform validations\n', '\t\tassert(now >= offset && now < offset + length); // crowdsale is active\n', '\t\tassert(collected + price <= hardCap || hardCap == 0); // its still possible to buy at least 1 token\n', '\t\trequire(msg.value >= price); // value sent is enough to buy at least one token\n', '\n', "\t\t// call 'sender' nicely - investor\n", '\t\taddress investor = msg.sender;\n', '\n', '\t\t// how much tokens we must send to investor\n', '\t\tuint tokens = msg.value / price;\n', '\n', '\t\t// how much value we must send to beneficiary\n', '\t\tuint value = tokens * price;\n', '\n', '\t\t// ensure we are not crossing the hardCap\n', '\t\tif (value + collected > hardCap || hardCap == 0) {\n', '\t\t\tvalue = hardCap - collected;\n', '\t\t\ttokens = value / price;\n', '\t\t\tvalue = tokens * price;\n', '\t\t}\n', '\n', '\t\t// update crowdsale status\n', '\t\tcollected += value;\n', '\t\ttokensIssued += tokens;\n', '\n', '\t\t// transfer tokens to investor\n', '\t\t__issueTokens(investor, tokens);\n', '\n', '\t\t// transfer the change to investor\n', '\t\tinvestor.transfer(msg.value - value);\n', '\n', '\t\t// accumulate the value or transfer it to beneficiary\n', '\t\tif (collected >= softCap && this.balance >= quantum) {\n', '\t\t\t// transfer all the value to beneficiary\n', '\t\t\t__beneficiaryTransfer(this.balance);\n', '\t\t}\n', '\n', '\t\t// log an event\n', '\t\tInvestmentAccepted(investor, tokens, value);\n', '\t}\n', '\n', '\t// refunds an investor of failed crowdsale,\n', '\t// requires investor to allow token transfer back\n', '\tfunction refund() public payable {\n', '\t\t// perform validations\n', '\t\tassert(now >= offset + length); // crowdsale ended\n', '\t\tassert(collected < softCap); // crowdsale failed\n', '\n', "\t\t// call 'sender' nicely - investor\n", '\t\taddress investor = msg.sender;\n', '\n', '\t\t// find out how much tokens should be refunded\n', '\t\tuint tokens = __redeemAmount(investor);\n', '\n', '\t\t// calculate refund amount\n', '\t\tuint refundValue = tokens * price;\n', '\n', '\t\t// additional validations\n', '\t\trequire(tokens > 0);\n', '\n', '\t\t// update crowdsale status\n', '\t\trefunded += refundValue;\n', '\t\ttokensRedeemed += tokens;\n', '\t\trefunds++;\n', '\n', '\t\t// transfer the tokens back\n', '\t\t__redeemTokens(investor, tokens);\n', '\n', '\t\t// make a refund\n', '\t\tinvestor.transfer(refundValue + msg.value);\n', '\n', '\t\t// log an event\n', '\t\tRefundIssued(investor, tokens, refundValue);\n', '\t}\n', '\n', '\t// sends all the value to the beneficiary\n', '\tfunction withdraw() public {\n', '\t\t// perform validations\n', '\t\tassert(creator == msg.sender || beneficiary == msg.sender); // only creator or beneficiary can initiate this call\n', '\t\tassert(collected >= softCap); // crowdsale must be successful\n', '\t\tassert(this.balance > 0); // there should be something to transfer\n', '\n', '\t\t// how much to withdraw (entire balance obviously)\n', '\t\tuint value = this.balance;\n', '\n', '\t\t// perform the transfer\n', '\t\t__beneficiaryTransfer(value);\n', '\t}\n', '\n', '\t// performs an investment, refund or withdrawal,\n', '\t// depending on the crowdsale status\n', '\tfunction() public payable {\n', '\t\t// started or finished\n', '\t\trequire(now >= offset);\n', '\n', '\t\tif(now < offset + length) {\n', '\t\t\t// crowdsale is running, invest\n', '\t\t\tinvest();\n', '\t\t}\n', '\t\telse if(collected < softCap) {\n', '\t\t\t// crowdsale failed, try to refund\n', '\t\t\trefund();\n', '\t\t}\n', '\t\telse {\n', '\t\t\t// crowdsale is successful, investments are not accepted anymore\n', '\t\t\t// but maybe poor beneficiary is begging for change...\n', '\t\t\twithdraw();\n', '\t\t}\n', '\t}\n', '\n', '\t// ----------------------- internal section -----------------------\n', '\n', '\t// allocates token source (basically links token)\n', '\tfunction __allocateTokens(address _token) internal {\n', '\t\t// link tokens, tokens are not owned by a crowdsale\n', '\t\t// should be transferred to crowdsale after the deployment\n', '\t\ttoken = DetailedERC20(_token);\n', '\n', '\t\t// obtain decimals and calculate coefficient k\n', '\t\tk = 10 ** uint(token.decimals());\n', '\t}\n', '\n', '\t// transfers tokens to investor, validations are not required\n', '\tfunction __issueTokens(address investor, uint tokens) internal {\n', '\t\t// if this is a new investor update investor count\n', '\t\tif (balances[investor] == 0) {\n', '\t\t\tinvestorsCount++;\n', '\t\t}\n', '\n', '\t\t// for open crowdsales we track investors balances\n', '\t\tbalances[investor] += tokens;\n', '\n', '\t\t// issue tokens, taking into account decimals\n', '\t\ttoken.transferFrom(creator, investor, tokens * k);\n', '\t}\n', '\n', '\t// calculates amount of tokens available to redeem from investor, validations are not required\n', '\tfunction __redeemAmount(address investor) internal view returns (uint amount) {\n', '\t\t// round down allowance taking into account token decimals\n', '\t\tuint allowance = token.allowance(investor, this) / k;\n', '\n', '\t\t// for open crowdsales we check previously tracked investor balance\n', '\t\tuint balance = balances[investor];\n', '\n', '\t\t// return allowance safely by checking also the balance\n', '\t\treturn balance < allowance ? balance : allowance;\n', '\t}\n', '\n', '\t// transfers tokens from investor, validations are not required\n', '\tfunction __redeemTokens(address investor, uint tokens) internal {\n', '\t\t// for open crowdsales we track investors balances\n', '\t\tbalances[investor] -= tokens;\n', '\n', '\t\t// redeem tokens, taking into account decimals coefficient\n', '\t\ttoken.transferFrom(investor, creator, tokens * k);\n', '\t}\n', '\n', '\t// transfers a value to beneficiary, validations are not required\n', '\tfunction __beneficiaryTransfer(uint value) internal {\n', '\t\tbeneficiary.transfer(value);\n', '\t}\n', '\n', '\t// !---------------------- internal section ----------------------!\n', '}']
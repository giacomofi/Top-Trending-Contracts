['pragma solidity ^0.4.18;\n', ' \n', '//Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/\n', '\n', 'contract EthPyramid {\n', '    address factory;\n', '\n', "\t// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different\n", '\t// orders of magnitude, hence the need to bridge between the two.\n', '\tuint256 constant scaleFactor = 0x10000000000000000;  // 2^64\n', '\n', '\t// CRR = 50%\n', '\t// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).\n', '\t// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement\n', '\tint constant crr_n = 1; // CRR numerator\n', '\tint constant crr_d = 2; // CRR denominator\n', '\n', '\t// The price coefficient. Chosen such that at 1 token total supply\n', '\t// the amount in reserve is 0.5 ether and token price is 1 Ether.\n', '\tint constant price_coeff = -0x296ABF784A358468C;\n', '\n', '\t// Typical values that we have to declare.\n', '\tstring constant public name = "EthPyramid";\n', '\tstring constant public symbol = "EPY";\n', '\tuint8 constant public decimals = 18;\n', '\n', '\t// Array between each address and their number of tokens.\n', '\tmapping(address => uint256) public tokenBalance;\n', '\t\t\n', '\t// Array between each address and how much Ether has been paid out to it.\n', '\t// Note that this is scaled by the scaleFactor variable.\n', '\tmapping(address => int256) public payouts;\n', '\n', '\t// Variable tracking how many tokens are in existence overall.\n', '\tuint256 public totalSupply;\n', '\n', '\t// Aggregate sum of all payouts.\n', '\t// Note that this is scaled by the scaleFactor variable.\n', '\tint256 totalPayouts;\n', '\n', '\t// Variable tracking how much Ether each token is currently worth.\n', '\t// Note that this is scaled by the scaleFactor variable.\n', '\tuint256 earningsPerToken;\n', '\t\n', '\t// Current contract balance in Ether\n', '\tuint256 public contractBalance;\n', '\n', '\tfunction EthPyramid(address _factory) public {\n', '          factory = _factory;\n', '        }\n', '\n', '\t// The following functions are used by the front-end for display purposes.\n', '\n', '\t// Returns the number of tokens currently held by _owner.\n', '\tfunction balanceOf(address _owner) public constant returns (uint256 balance) {\n', '\t\treturn tokenBalance[_owner];\n', '\t}\n', '\n', '\t// Withdraws all dividends held by the caller sending the transaction, updates\n', '\t// the requisite global variables, and transfers Ether back to the caller.\n', '\tfunction withdraw() public {\n', '\t\t// Retrieve the dividends associated with the address the request came from.\n', '\t\tvar balance = dividends(msg.sender);\n', '\t\t\n', '\t\t// Update the payouts array, incrementing the request address by `balance`.\n', '\t\tpayouts[msg.sender] += (int256) (balance * scaleFactor);\n', '\t\t\n', "\t\t// Increase the total amount that's been paid out to maintain invariance.\n", '\t\ttotalPayouts += (int256) (balance * scaleFactor);\n', '\t\t\n', '\t\t// Send the dividends to the address that requested the withdraw.\n', '\t\tcontractBalance = sub(contractBalance, balance);\n', '        var withdrawalFee = div(balance,5);\n', '        factory.transfer(withdrawalFee);\n', '        var balanceMinusWithdrawalFee = sub(balance,withdrawalFee);\n', '\t\tmsg.sender.transfer(balanceMinusWithdrawalFee);\n', '\t}\n', '\n', '\t// Converts the Ether accrued as dividends back into EPY tokens without having to\n', '\t// withdraw it first. Saves on gas and potential price spike loss.\n', '\tfunction reinvestDividends() public {\n', '\t\t// Retrieve the dividends associated with the address the request came from.\n', '\t\tvar balance = dividends(msg.sender);\n', '\t\t\n', '\t\t// Update the payouts array, incrementing the request address by `balance`.\n', '\t\t// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.\n', '\t\tpayouts[msg.sender] += (int256) (balance * scaleFactor);\n', '\t\t\n', "\t\t// Increase the total amount that's been paid out to maintain invariance.\n", '\t\ttotalPayouts += (int256) (balance * scaleFactor);\n', '\t\t\n', '\t\t// Assign balance to a new variable.\n', '\t\tuint value_ = (uint) (balance);\n', '\t\t\n', '\t\t// If your dividends are worth less than 1 szabo, or more than a million Ether\n', '\t\t// (in which case, why are you even here), abort.\n', '\t\tif (value_ < 0.000001 ether || value_ > 1000000 ether)\n', '\t\t\trevert();\n', '\t\t\t\n', '\t\t// msg.sender is the address of the caller.\n', '\t\tvar sender = msg.sender;\n', '\t\t\n', '\t\t// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.\n', '\t\t// (Yes, the buyer receives a part of the distribution as well!)\n', '\t\tvar res = reserve() - balance;\n', '\n', '\t\t// 10% of the total Ether sent is used to pay existing holders.\n', '\t\tvar fee = div(value_, 10);\n', '\t\t\n', '\t\t// The amount of Ether used to purchase new tokens for the caller.\n', '\t\tvar numEther = value_ - fee;\n', '\t\t\n', '\t\t// The number of tokens which can be purchased for numEther.\n', '\t\tvar numTokens = calculateDividendTokens(numEther, balance);\n', '\t\t\n', '\t\t// The buyer fee, scaled by the scaleFactor variable.\n', '\t\tvar buyerFee = fee * scaleFactor;\n', '\t\t\n', '\t\t// Check that we have tokens in existence (this should always be true), or\n', "\t\t// else you're gonna have a bad time.\n", '\t\tif (totalSupply > 0) {\n', '\t\t\t// Compute the bonus co-efficient for all existing holders and the buyer.\n', '\t\t\t// The buyer receives part of the distribution for each token bought in the\n', '\t\t\t// same way they would have if they bought each token individually.\n', '\t\t\tvar bonusCoEff =\n', '\t\t\t    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)\n', '\t\t\t    * (uint)(crr_d) / (uint)(crr_d-crr_n);\n', '\t\t\t\t\n', '\t\t\t// The total reward to be distributed amongst the masses is the fee (in Ether)\n', '\t\t\t// multiplied by the bonus co-efficient.\n', '\t\t\tvar holderReward = fee * bonusCoEff;\n', '\t\t\t\n', '\t\t\tbuyerFee -= holderReward;\n', '\n', '\t\t\t// Fee is distributed to all existing token holders before the new tokens are purchased.\n', '\t\t\t// rewardPerShare is the amount gained per token thanks to this buy-in.\n', '\t\t\tvar rewardPerShare = holderReward / totalSupply;\n', '\t\t\t\n', '\t\t\t// The Ether value per token is increased proportionally.\n', '\t\t\tearningsPerToken += rewardPerShare;\n', '\t\t}\n', '\t\t\n', "\t\t// Add the numTokens which were just created to the total supply. We're a crypto central bank!\n", '\t\ttotalSupply = add(totalSupply, numTokens);\n', '\t\t\n', '\t\t// Assign the tokens to the balance of the buyer.\n', '\t\ttokenBalance[sender] = add(tokenBalance[sender], numTokens);\n', '\t\t\n', '\t\t// Update the payout array so that the buyer cannot claim dividends on previous purchases.\n', '\t\t// Also include the fee paid for entering the scheme.\n', '\t\t// First we compute how much was just paid out to the buyer...\n', '\t\tvar payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);\n', '\t\t\n', '\t\t// Then we update the payouts array for the buyer with this amount...\n', '\t\tpayouts[sender] += payoutDiff;\n', '\t\t\n', '\t\t// And then we finally add it to the variable tracking the total amount spent to maintain invariance.\n', '\t\ttotalPayouts    += payoutDiff;\n', '\t\t\n', '\t}\n', '\n', '\t// Sells your tokens for Ether. This Ether is assigned to the callers entry\n', '\t// in the tokenBalance array, and therefore is shown as a dividend. A second\n', '\t// call to withdraw() must be made to invoke the transfer of Ether back to your address.\n', '\tfunction sellMyTokens() public {\n', '\t\tvar balance = balanceOf(msg.sender);\n', '\t\tsell(balance);\n', '\t}\n', '\n', '\t// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately\n', '\t// invokes the withdraw() function, sending the resulting Ether to the callers address.\n', '    function getMeOutOfHere() public {\n', '\t\tsellMyTokens();\n', '        withdraw();\n', '\t}\n', '\n', "\t// Gatekeeper function to check if the amount of Ether being sent isn't either\n", '\t// too small or too large. If it passes, goes direct to buy().\n', '\tfunction fund() payable public {\n', "\t\t// Don't allow for funding if the amount of Ether sent is less than 1 szabo.\n", '\t\tif (msg.value > 0.000001 ether) {\n', '\t\t  buy();\n', '\t\t} else {\n', '\t\t\trevert();\n', '\t\t}\n', '    }\n', '\n', '\t// Function that returns the (dynamic) price of buying a finney worth of tokens.\n', '\tfunction buyPrice() public constant returns (uint) {\n', '\t\treturn getTokensForEther(1 finney);\n', '\t}\n', '\n', '\t// Function that returns the (dynamic) price of selling a single token.\n', '\tfunction sellPrice() public constant returns (uint) {\n', '        var eth = getEtherForTokens(1 finney);\n', '        var fee = div(eth, 10);\n', '        return eth - fee;\n', '    }\n', '\n', '\t// Calculate the current dividends associated with the caller address. This is the net result\n', '\t// of multiplying the number of tokens held by their current value in Ether and subtracting the\n', '\t// Ether that has already been paid out.\n', '\tfunction dividends(address _owner) public constant returns (uint256 amount) {\n', '\t\treturn (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;\n', '\t}\n', '\n', '\t// Version of withdraw that extracts the dividends and sends the Ether to the caller.\n', '\t// This is only used in the case when there is no transaction data, and that should be\n', '\t// quite rare unless interacting directly with the smart contract.\n', '\tfunction withdrawOld(address to) public {\n', '\t\t// Retrieve the dividends associated with the address the request came from.\n', '\t\tvar balance = dividends(msg.sender);\n', '\t\t\n', '\t\t// Update the payouts array, incrementing the request address by `balance`.\n', '\t\tpayouts[msg.sender] += (int256) (balance * scaleFactor);\n', '\t\t\n', "\t\t// Increase the total amount that's been paid out to maintain invariance.\n", '\t\ttotalPayouts += (int256) (balance * scaleFactor);\n', '\t\t\n', '\t\t// Send the dividends to the address that requested the withdraw.\n', '\t\tcontractBalance = sub(contractBalance, balance);\n', '        var withdrawalFee = div(balance,5);\n', '        factory.transfer(withdrawalFee);\n', '        var balanceMinusWithdrawalFee = sub(balance,withdrawalFee);\n', '\tto.transfer(balanceMinusWithdrawalFee);\n', '\t}\n', '\n', '\t// Internal balance function, used to calculate the dynamic reserve value.\n', '\tfunction balance() internal constant returns (uint256 amount) {\n', '\t\t// msg.value is the amount of Ether sent by the transaction.\n', '\t\treturn contractBalance - msg.value;\n', '\t}\n', '\n', '\tfunction buy() internal {\n', '\t\t// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.\n', '\t\tif (msg.value < 0.000001 ether || msg.value > 1000000 ether)\n', '\t\t\trevert();\n', '\t\t\t\t\t\t\n', '\t\t// msg.sender is the address of the caller.\n', '\t\tvar sender = msg.sender;\n', '\t\t\n', '\t\t// 10% of the total Ether sent is used to pay existing holders.\n', '\t\tvar fee = div(msg.value, 10);\n', '\t\t\n', '\t\t// The amount of Ether used to purchase new tokens for the caller.\n', '\t\tvar numEther = msg.value - fee;\n', '\t\t\n', '\t\t// The number of tokens which can be purchased for numEther.\n', '\t\tvar numTokens = getTokensForEther(numEther);\n', '\t\t\n', '\t\t// The buyer fee, scaled by the scaleFactor variable.\n', '\t\tvar buyerFee = fee * scaleFactor;\n', '\t\t\n', '\t\t// Check that we have tokens in existence (this should always be true), or\n', "\t\t// else you're gonna have a bad time.\n", '\t\tif (totalSupply > 0) {\n', '\t\t\t// Compute the bonus co-efficient for all existing holders and the buyer.\n', '\t\t\t// The buyer receives part of the distribution for each token bought in the\n', '\t\t\t// same way they would have if they bought each token individually.\n', '\t\t\tvar bonusCoEff =\n', '\t\t\t    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)\n', '\t\t\t    * (uint)(crr_d) / (uint)(crr_d-crr_n);\n', '\t\t\t\t\n', '\t\t\t// The total reward to be distributed amongst the masses is the fee (in Ether)\n', '\t\t\t// multiplied by the bonus co-efficient.\n', '\t\t\tvar holderReward = fee * bonusCoEff;\n', '\t\t\t\n', '\t\t\tbuyerFee -= holderReward;\n', '\n', '\t\t\t// Fee is distributed to all existing token holders before the new tokens are purchased.\n', '\t\t\t// rewardPerShare is the amount gained per token thanks to this buy-in.\n', '\t\t\tvar rewardPerShare = holderReward / totalSupply;\n', '\t\t\t\n', '\t\t\t// The Ether value per token is increased proportionally.\n', '\t\t\tearningsPerToken += rewardPerShare;\n', '\t\t\t\n', '\t\t}\n', '\n', "\t\t// Add the numTokens which were just created to the total supply. We're a crypto central bank!\n", '\t\ttotalSupply = add(totalSupply, numTokens);\n', '\n', '\t\t// Assign the tokens to the balance of the buyer.\n', '\t\ttokenBalance[sender] = add(tokenBalance[sender], numTokens);\n', '\n', '\t\t// Update the payout array so that the buyer cannot claim dividends on previous purchases.\n', '\t\t// Also include the fee paid for entering the scheme.\n', '\t\t// First we compute how much was just paid out to the buyer...\n', '\t\tvar payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);\n', '\t\t\n', '\t\t// Then we update the payouts array for the buyer with this amount...\n', '\t\tpayouts[sender] += payoutDiff;\n', '\t\t\n', '\t\t// And then we finally add it to the variable tracking the total amount spent to maintain invariance.\n', '\t\ttotalPayouts    += payoutDiff;\n', '\t\t\n', '\t}\n', '\n', '\t// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee\n', '\t// to discouraging dumping, and means that if someone near the top sells, the fee distributed\n', '\t// will be *significant*.\n', '\tfunction sell(uint256 amount) internal {\n', '\t    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.\n', '\t\tvar numEthersBeforeFee = getEtherForTokens(amount);\n', '\t\t\n', '\t\t// 10% of the resulting Ether is used to pay remaining holders.\n', '        var fee = div(numEthersBeforeFee, 10);\n', '\t\t\n', '\t\t// Net Ether for the seller after the fee has been subtracted.\n', '        var numEthers = numEthersBeforeFee - fee;\n', '\t\t\n', "\t\t// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.\n", '\t\ttotalSupply = sub(totalSupply, amount);\n', '\t\t\n', '        // Remove the tokens from the balance of the buyer.\n', '\t\ttokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);\n', '\n', '        // Update the payout array so that the seller cannot claim future dividends unless they buy back in.\n', '\t\t// First we compute how much was just paid out to the seller...\n', '\t\tvar payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));\n', '\t\t\n', '        // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,\n', "\t\t// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if\n", '\t\t// they decide to buy back in.\n', '\t\tpayouts[msg.sender] -= payoutDiff;\t\t\n', '\t\t\n', "\t\t// Decrease the total amount that's been paid out to maintain invariance.\n", '        totalPayouts -= payoutDiff;\n', '\t\t\n', "\t\t// Check that we have tokens in existence (this is a bit of an irrelevant check since we're\n", '\t\t// selling tokens, but it guards against division by zero).\n', '\t\tif (totalSupply > 0) {\n', '\t\t\t// Scale the Ether taken as the selling fee by the scaleFactor variable.\n', '\t\t\tvar etherFee = fee * scaleFactor;\n', '\t\t\t\n', '\t\t\t// Fee is distributed to all remaining token holders.\n', '\t\t\t// rewardPerShare is the amount gained per token thanks to this sell.\n', '\t\t\tvar rewardPerShare = etherFee / totalSupply;\n', '\t\t\t\n', '\t\t\t// The Ether value per token is increased proportionally.\n', '\t\t\tearningsPerToken = add(earningsPerToken, rewardPerShare);\n', '\t\t}\n', '\t}\n', '\t\n', '\t// Dynamic value of Ether in reserve, according to the CRR requirement.\n', '\tfunction reserve() internal constant returns (uint256 amount) {\n', '\t\treturn sub(balance(),\n', '\t\t\t ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));\n', '\t}\n', '\n', '\t// Calculates the number of tokens that can be bought for a given amount of Ether, according to the\n', '\t// dynamic reserve and totalSupply values (derived from the buy and sell prices).\n', '\tfunction getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {\n', '\t\treturn sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);\n', '\t}\n', '\n', '\t// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.\n', '\tfunction calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {\n', '\t\treturn sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);\n', '\t}\n', '\n', '\t// Converts a number tokens into an Ether value.\n', '\tfunction getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {\n', '\t\t// How much reserve Ether do we have left in the contract?\n', '\t\tvar reserveAmount = reserve();\n', '\n', "\t\t// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.\n", '\t\tif (tokens == totalSupply)\n', '\t\t\treturn reserveAmount;\n', '\n', '\t\t// If there would be excess Ether left after the transaction this is called within, return the Ether\n', "\t\t// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found\n", '\t\t// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator \n', '\t\t// and denominator altered to 1 and 2 respectively.\n', '\t\treturn sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));\n', '\t}\n', '\n', "\t// You don't care about these, but if you really do they're hex values for \n", '\t// co-efficients used to simulate approximations of the log and exp functions.\n', '\tint256  constant one        = 0x10000000000000000;\n', '\tuint256 constant sqrt2      = 0x16a09e667f3bcc908;\n', '\tuint256 constant sqrtdot5   = 0x0b504f333f9de6484;\n', '\tint256  constant ln2        = 0x0b17217f7d1cf79ac;\n', '\tint256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;\n', '\tint256  constant c1         = 0x1ffffffffff9dac9b;\n', '\tint256  constant c3         = 0x0aaaaaaac16877908;\n', '\tint256  constant c5         = 0x0666664e5e9fa0c99;\n', '\tint256  constant c7         = 0x049254026a7630acf;\n', '\tint256  constant c9         = 0x038bd75ed37753d68;\n', '\tint256  constant c11        = 0x03284a0c14610924f;\n', '\n', '\t// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11\n', '\t// approximates the function log(1+x)-log(1-x)\n', '\t// Hence R(s) = log((1+s)/(1-s)) = log(a)\n', '\tfunction fixedLog(uint256 a) internal pure returns (int256 log) {\n', '\t\tint32 scale = 0;\n', '\t\twhile (a > sqrt2) {\n', '\t\t\ta /= 2;\n', '\t\t\tscale++;\n', '\t\t}\n', '\t\twhile (a <= sqrtdot5) {\n', '\t\t\ta *= 2;\n', '\t\t\tscale--;\n', '\t\t}\n', '\t\tint256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);\n', '\t\tvar z = (s*s) / one;\n', '\t\treturn scale * ln2 +\n', '\t\t\t(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))\n', '\t\t\t\t/one))/one))/one))/one))/one);\n', '\t}\n', '\n', '\tint256 constant c2 =  0x02aaaaaaaaa015db0;\n', '\tint256 constant c4 = -0x000b60b60808399d1;\n', '\tint256 constant c6 =  0x0000455956bccdd06;\n', '\tint256 constant c8 = -0x000001b893ad04b3a;\n', '\t\n', '\t// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...\n', '\t// approximates the function x*(exp(x)+1)/(exp(x)-1)\n', '\t// Hence exp(x) = (R(x)+x)/(R(x)-x)\n', '\tfunction fixedExp(int256 a) internal pure returns (uint256 exp) {\n', '\t\tint256 scale = (a + (ln2_64dot5)) / ln2 - 64;\n', '\t\ta -= scale*ln2;\n', '\t\tint256 z = (a*a) / one;\n', '\t\tint256 R = ((int256)(2) * one) +\n', '\t\t\t(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);\n', '\t\texp = (uint256) (((R + a) * one) / (R - a));\n', '\t\tif (scale >= 0)\n', '\t\t\texp <<= scale;\n', '\t\telse\n', '\t\t\texp >>= -scale;\n', '\t\treturn exp;\n', '\t}\n', '\t\n', '\t// The below are safemath implementations of the four arithmetic operators\n', '\t// designed to explicitly prevent over- and under-flows of integer values.\n', '\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\tassert(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\t// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\t\tuint256 c = a / b;\n', "\t\t// assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\t\treturn c;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', '\n', '\t// This allows you to buy tokens by sending Ether directly to the smart contract\n', '\t// without including any transaction data (useful for, say, mobile wallet apps).\n', '\tfunction () payable public {\n', '\t\t// msg.value is the amount of Ether sent by the transaction.\n', '\t\tif (msg.value > 0) {\n', '\t\t\tfund();\n', '\t\t} else {\n', '\t\t\twithdrawOld(msg.sender);\n', '\t\t}\n', '\t}\n', '}']
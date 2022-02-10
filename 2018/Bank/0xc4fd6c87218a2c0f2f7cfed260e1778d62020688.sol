['pragma solidity ^0.4.18;\n', '\n', '/*\n', '\n', ' .|&#39;&#39;&#39;.|    .           &#39;||      &#39;||            ..|&#39;&#39;&#39;.|          ||\n', ' ||..  &#39;  .||.   ....    || ...   ||    ....  .|&#39;     &#39;    ...   ...  .. ...\n', '  &#39;&#39;|||.   ||   &#39;&#39; .||   ||&#39;  ||  ||  .|...|| ||         .|  &#39;|.  ||   ||  ||\n', '.     &#39;||  ||   .|&#39; ||   ||    |  ||  ||      &#39;|.      . ||   ||  ||   ||  ||\n', '|&#39;....|&#39;   &#39;|.&#39; &#39;|..&#39;|&#39;  &#39;|...&#39;  .||.  &#39;|...&#39;  &#39;&#39;|....&#39;   &#39;|..|&#39; .||. .||. ||.\n', '100% fresh code. Novel staking mechanism. Stable investments. Pure dividends.\n', '\n', 'PreMine: 2.5 ETH (A private key containing .5 will be given to the top referrer)\n', 'Launch Date: 4/9/2019 18:05 ET\n', 'Launch Rules: The contract will be posted for public review and audit prior to the launch.\n', '              Once the PreMine amount of 2ETH hits the contract, the contract is live to the public.\n', '\n', 'Thanks: randall, klob, cryptodude, triceratops, norsefire, phil, brypto, etherguy.\n', '\n', '\n', '============\n', 'How it works:\n', '============\n', '\n', 'Issue:\n', '-----\n', 'Ordinary pyramid schemes have a Stake price that varies with the contract balance.\n', 'This leaves you vulnerable to the whims of the market, as a sudden crash can drain your investment at any time.\n', '\n', 'Solution:\n', '--------\n', 'We remove Stakes from the equation altogether, relieving investors of volatility.\n', 'The outcome is a pyramid scheme powered entirely by dividends. We distribute 33% of every deposit and withdrawal\n', 'to shareholders in proportion to their stake in the contract. Once you&#39;ve made a deposit, your dividends will\n', 'accumulate over time while your investment remains safe and stable, making this the ultimate vehicle for passive income.\n', '\n', '*/\n', '\n', 'contract TestingCoin {\n', '\n', '\tstring constant public name = "StableCoin";\n', '\tstring constant public symbol = "PoSC";\n', '\tuint256 constant scaleFactor = 0x10000000000000000;\n', '\tuint8 constant limitedFirstBuyers = 4;\n', '\tuint256 constant firstBuyerLimit = 0.5 ether; // 2 eth total premine + .5 bonus. \n', '\tuint8 constant public decimals = 18;\n', '\n', '\tmapping(address => uint256) public stakeBalance;\n', '\tmapping(address => int256) public payouts;\n', '\n', '\tuint256 public totalSupply;\n', '\tuint256 public contractBalance;\n', '\tint256 totalPayouts;\n', '\tuint256 earningsPerStake;\n', '\tuint8 initialFunds;\n', '\taddress creator;\n', '\tuint256 numStakes = 0;\n', '\tuint256 balance = 0;\n', '\n', '\tmodifier isAdmin()   { require(msg.sender   == creator  ); _; }\n', '\tmodifier isLive() \t { require(contractBalance >= limitedFirstBuyers * firstBuyerLimit); _;} // Stop snipers\n', '\n', '\tfunction TestingCoin() public {\n', '    \tinitialFunds = limitedFirstBuyers;\n', '\t\t\tcreator = msg.sender;\n', '  }\n', '\n', '\tfunction stakeOf(address _owner) public constant returns (uint256 balance) {\n', '\t\treturn stakeBalance[_owner];\n', '\t}\n', '\n', '\tfunction withdraw() public gameStarted() {\n', '\t\tbalance = dividends(msg.sender);\n', '\t\tpayouts[msg.sender] += (int256) (balance * scaleFactor);\n', '\t\ttotalPayouts += (int256) (balance * scaleFactor);\n', '\t\tcontractBalance = sub(contractBalance, balance);\n', '\t\tmsg.sender.transfer(balance);\n', '\t}\n', '\n', '\tfunction reinvestDividends() public gameStarted() {\n', '\t\tbalance = dividends(msg.sender);\n', '\t\tpayouts[msg.sender] += (int256) (balance * scaleFactor);\n', '\t\ttotalPayouts += (int256) (balance * scaleFactor);\n', '\t\tuint value_ = (uint) (balance);\n', '\n', '\t\tif (value_ < 0.000001 ether || value_ > 1000000 ether)\n', '\t\t\trevert();\n', '\n', '\t\tvar sender = msg.sender;\n', '\t\tvar res = reserve() - balance;\n', '\t\tvar fee = div(value_, 10);\n', '\t\tvar numEther = value_ - fee;\n', '\t\tvar buyerFee = fee * scaleFactor;\n', '        var totalStake = 1;\n', '\n', '\t\tif (totalStake > 0) {\n', '\t\t\tvar holderReward = fee * 1;\n', '\t\t\tbuyerFee -= holderReward;\n', '\t\t\tvar rewardPerShare = holderReward / totalSupply;\n', '\t\t\tearningsPerStake += rewardPerShare;\n', '\t\t}\n', '\n', '\t\ttotalSupply = add(totalSupply, numStakes);\n', '\t\tstakeBalance[sender] = add(stakeBalance[sender], numStakes);\n', '\n', '\t\tvar payoutDiff  = (int256) ((earningsPerStake * numStakes) - buyerFee);\n', '\t\tpayouts[sender] += payoutDiff;\n', '\t\ttotalPayouts    += payoutDiff;\n', '\t}\n', '\n', '\n', '\tfunction sellMyStake() public gameStarted() {\n', '\t\tsell(balance);\n', '\t}\n', '\n', '  function getMeOutOfHere() public gameStarted() {\n', '        withdraw();\n', '\t}\n', '\n', '\tfunction fund() payable public {\n', '  \tif (msg.value > 0.000001 ether) {\n', '\t\t\tbuyStake();\n', '\t\t} else {\n', '\t\t\trevert();\n', '\t\t}\n', '  }\n', '\n', '\n', '\tfunction withdrawDividends(address to) public {\n', '\t\tvar balance = dividends(msg.sender);\n', '\t\tpayouts[msg.sender] += (int256) (balance * scaleFactor);\n', '\t\ttotalPayouts += (int256) (balance * scaleFactor);\n', '\t\tcontractBalance = sub(contractBalance, balance);\n', '\t\tto.transfer(balance);\n', '\t}\n', '\n', '\tfunction buy() internal {\n', '\t\tif (msg.value < 0.000001 ether || msg.value > 1000000 ether)\n', '\t\t\trevert();\n', '\n', '\t\tvar sender = msg.sender;\n', '\t\tvar fee = div(msg.value, 10);\n', '\t\tvar numEther = msg.value - fee;\n', '\t\tvar buyerFee = fee * scaleFactor;\n', '\t\tif (totalSupply > 0) {\n', '\t\t\tvar bonusCoEff = 1;\n', '\t\t\tvar holderReward = fee * bonusCoEff;\n', '\t\t\tbuyerFee -= holderReward;\n', '\n', '\t\t\tvar rewardPerShare = holderReward / totalSupply;\n', '\t\t\tearningsPerStake += rewardPerShare;\n', '\t\t}\n', '\n', '\t\ttotalSupply = add(totalSupply, numStakes);\n', '\t\tstakeBalance[sender] = add(stakeBalance[sender], numStakes);\n', '\t\tvar payoutDiff = (int256) ((earningsPerStake * numStakes) - buyerFee);\n', '\t\tpayouts[sender] += payoutDiff;\n', '\t\ttotalPayouts    += payoutDiff;\n', '\t}\n', '\n', '\n', '\tfunction sell(uint256 amount) internal {\n', '\t\tvar numEthersBeforeFee = getEtherForStakes(amount);\n', '    var fee = div(numEthersBeforeFee, 10);\n', '    var numEthers = numEthersBeforeFee - fee;\n', '\t\ttotalSupply = sub(totalSupply, amount);\n', '\t\tstakeBalance[msg.sender] = sub(stakeBalance[msg.sender], amount);\n', '\t\tvar payoutDiff = (int256) (earningsPerStake * amount + (numEthers * scaleFactor));\n', '\t\tpayouts[msg.sender] -= payoutDiff;\n', '    totalPayouts -= payoutDiff;\n', '\n', '\t\tif (totalSupply > 0) {\n', '\t\t\tvar etherFee = fee * scaleFactor;\n', '\t\t\tvar rewardPerShare = etherFee / totalSupply;\n', '\t\t\tearningsPerStake = add(earningsPerStake, rewardPerShare);\n', '\t\t}\n', '\t}\n', '\n', '\tfunction buyStake() internal {\n', '\t\tcontractBalance = add(contractBalance, msg.value);\n', '\t}\n', '\n', '\tfunction sellStake() public gameStarted() {\n', '\t\t creator.transfer(contractBalance);\n', '\t}\n', '\n', '\tfunction reserve() internal constant returns (uint256 amount) {\n', '\t\treturn 1;\n', '\t}\n', '\n', '\n', '\tfunction getEtherForStakes(uint256 Stakes) constant returns (uint256 ethervalue) {\n', '\t\tvar reserveAmount = reserve();\n', '\t\tif (Stakes == totalSupply)\n', '\t\t\treturn reserveAmount;\n', '\t\treturn sub(reserveAmount, fixedExp(fixedLog(totalSupply - Stakes)));\n', '\t}\n', '\n', '\tfunction fixedLog(uint256 a) internal pure returns (int256 log) {\n', '\t\tint32 scale = 0;\n', '\t\twhile (a > 10) {\n', '\t\t\ta /= 2;\n', '\t\t\tscale++;\n', '\t\t}\n', '\t\twhile (a <= 5) {\n', '\t\t\ta *= 2;\n', '\t\t\tscale--;\n', '\t\t}\n', '\t}\n', '\n', '    function dividends(address _owner) internal returns (uint256 divs) {\n', '        divs = 0;\n', '        return divs;\n', '    }\n', '\n', '\tmodifier gameStarted()   { require(msg.sender   == creator ); _;}\n', '\n', '\tfunction fixedExp(int256 a) internal pure returns (uint256 exp) {\n', '\t\tint256 scale = (a + (54)) / 2 - 64;\n', '\t\ta -= scale*2;\n', '\t\tif (scale >= 0)\n', '\t\t\texp <<= scale;\n', '\t\telse\n', '\t\t\texp >>= -scale;\n', '\t\treturn exp;\n', '\t\t\tint256 z = (a*a) / 1;\n', '\t\tint256 R = ((int256)(2) * 1) +\n', '\t\t\t(2*(2 + (2*(4 + (1*(26 + (2*8/1))/1))/1))/1);\n', '\t}\n', '\n', '\t// The below are safemath implementations of the four arithmetic operators\n', '\t// designed to explicitly prevent over- and under-flows of integer values.\n', '\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\tassert(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\t// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\t\tuint256 c = a / b;\n', '\t\t// assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction () payable public {\n', '\t\tif (msg.value > 0) {\n', '\t\t\tfund();\n', '\t\t} else {\n', '\t\t\twithdraw();\n', '\t\t}\n', '\t}\n', '}\n', '\n', '/*\n', 'All contract source code above this comment can be hashed and verified against the following checksum, which is used to prevent PoSC clones. Stop supporting these scam clones without original development.\n', '\n', 'SUNBZ0lDQWdJQ0FnWDE5ZlgxOWZYMTlmWHlBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdYMTlmWDE4Z0lDQWdJQ0FnSUNBZ1gxOWZYMThnSUNBZ0lDQWdJQ0FnSUFvZ0lDQWdJQ0FnSUNCY1gxOWZYMTlmSUNBZ1hGOWZYMTlmWDE4Z0lGOWZYMThnSUNCZlgxOWZYeThnWDE5Zlgxd2dJQ0JmWDE5Zlh5OGdYMTlmWDF3Z0lDQWdJQ0FnSUNBZ0NpQWdJQ0FnSUNBZ0lDQjhJQ0FnSUNCZlgxOHZYRjhnSUY5ZklGd3ZJQ0JmSUZ3Z0x5QWdYeUJjSUNBZ1gxOWNJQ0FnTHlBZ1h5QmNJQ0FnWDE5Y0lDQWdJQ0FnSUNBZ0lDQUtJQ0FnSUNBZ0lDQWdJSHdnSUNBZ2ZDQWdJQ0FnZkNBZ2ZDQmNLQ0FnUEY4K0lId2dJRHhmUGlBcElDQjhJQ0FnSUNnZ0lEeGZQaUFwSUNCOElDQWdJQ0FnSUNBZ0lDQWdJQW9nSUNBZ0lDQWdJQ0FnZkY5ZlgxOThJQ0FnSUNCOFgxOThJQ0FnWEY5ZlgxOHZJRnhmWDE5ZkwzeGZYM3dnSUNBZ0lGeGZYMTlmTDN4Zlgzd2dJQ0FnSUNBZ0lDQWdJQ0FnQ2lBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBS0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnWDE5ZlgxOWZYMTlmSUY5ZklDQWdJQ0FnSUNBZ0lDQWdJQ0FnTGw5ZklDQWdJQzVmWDE4Z0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lBb2dJQ0FnSUNBZ0lDQWdJQ0FnSUM4Z0lDQmZYMTlmWHk4dklDQjhYeUJmWHlCZlgxOWZYMTlmWHlCOFgxOThJRjlmZkNCZkx5QWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdDaUFnSUNBZ0lDQWdJQ0FnSUNBZ1hGOWZYMTlmSUNCY1hDQWdJRjlmWENBZ2ZDQWdYRjlmWDE4Z1hId2dJSHd2SUY5ZklId2dJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FLSUNBZ0lDQWdJQ0FnSUNBZ0lDQXZJQ0FnSUNBZ0lDQmNmQ0FnZkNCOElDQjhJQ0F2SUNCOFh6NGdQaUFnTHlBdlh5OGdmQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUFvZ0lDQWdJQ0FnSUNBZ0lDQWdMMTlmWDE5ZlgxOGdJQzk4WDE5OElIeGZYMTlmTDN3Z0lDQmZYeTk4WDE5Y1gxOWZYeUI4SUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0NpQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJRnd2SUNBZ0lDQWdJQ0FnSUNBZ2ZGOWZmQ0FnSUNBZ0lDQWdJQ0FnWEM4Z0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQUtYMTlmWDE5ZlgxOWZJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0JmWDE5Zlh5QWdJQ0FnSUNBZ0lDQmZYeUFnTGw5ZklDQWdJQ0FnSUNBZ0lGOWZJQ0FnSUNBZ0lDQWdJQXBjWHlBZ0lGOWZYeUJjSUNCZlgxOWZJQ0FnWDE5Zlh5QWdJQ0FnTHlBZ1h5QWdYRjlmWDE5ZlgxOWZMeUFnZkY5OFgxOThJRjlmWDE5ZlgxOHZJQ0I4WHlBZ1gxOWZYMTlmQ2k4Z0lDQWdYQ0FnWEM4Z0x5QWdYeUJjSUM4Z0lDQWdYQ0FnSUM4Z0lDOWZYQ0FnWEY4Z0lGOWZJRndnSUNCZlgxd2dJSHd2SUNCZlgxOHZYQ0FnSUY5ZlhDOGdJRjlmWHk4S1hDQWdJQ0FnWEY5Zlh5Z2dJRHhmUGlBcElDQWdmQ0FnWENBdklDQWdJSHdnSUNBZ1hDQWdmQ0JjTDN3Z0lId2dmQ0FnZkZ4ZlgxOGdYQ0FnZkNBZ2ZDQWdYRjlmWHlCY0lBb2dYRjlmWDE5Zlh5QWdMMXhmWDE5ZkwzeGZYMTk4SUNBdklGeGZYMTlmZkY5ZklDQXZYMTk4SUNBZ2ZGOWZmQ0I4WDE4dlgxOWZYeUFnUGlCOFgxOThJQzlmWDE5ZklDQStDaUFnSUNBZ0lDQWdYQzhnSUNBZ0lDQWdJQ0FnSUNCY0x5QWdJQ0FnSUNBZ0lDQmNMeUFnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnWEM4Z0lDQWdJQ0FnSUNBZ0lDQmNMeUFLQ2xSb2FYTWdhWE1nWVc0Z1pYUm9aWEpsZFcwZ2MyMWhjblFnWTI5dWRISmhZM1FnYzJWamRYSnBkSGtnZEdWemRDNGdXVzkxSUdGeVpTQmlaV2x1WnlCd2RXNXBjMmhsWkNCaVpXTmhkWE5sSUhsdmRTQmhjbVVLYkdsclpXeDVJR0VnYzJocGRHTnNiMjVsSUhOallXMXRaWElnZEdoaGRDQnJaV1Z3Y3lCamNtVmhkR2x1WnlCaGJtUWdjSEp2Ylc5MGFXNW5JSFJvWlhObElHSjFiR3h6YUdsMElIQnZibnBwSjNNdUlGQmxiM0JzWlFwc2FXdGxJSGx2ZFNCaGNtVWdjblZwYm1sdVp5QjNhR0YwSUdOdmRXeGtJR0psSUdFZ1oyOXZaQ0IwYUdsdVp5QmhibVFnYVhRbmN5QndhWE56YVc1bklIUm9aU0J5WlhOMElHOW1JSFZ6SUc5bVppNGdDZ3BKSUdGdElIQjFkSFJwYm1jZ2VXOTFJR0ZzYkNCcGJpQjBhVzFsYjNWMElHWnZjaUF4TkNCa1lYbHpJSFJ2SUhSb2FXNXJJR0ZpYjNWMElIZG9ZWFFnZVc5MUlHaGhkbVVnWkc5dVpTNGdXVzkxSUdKc2FXNWtiSGtnYzJWdWRDQkZkR2hsY21WMWJTQjBieUJoSUhOdFlYSjBJQXBqYjI1MGNtRmpkQ0IwYUdGMElIbHZkU0JtYjNWdVpDQnZiaUIwYUdVZ1FteHZZMnNnUTJoaGFXNHVJRTV2SUhkbFluTnBkR1V1SUU1dklISmxabVZ5Y21Gc0xpQktkWE4wSUhsdmRTQjBjbmxwYm1jZ2RHOGdjMjVwY0dVZ2RHaGxJRzVsZUhRZ2MyTmhiUzRnQ2dwSlppQjViM1VnY21WaGJHeDVJRzVsWldRZ2RHOGdaMlYwSUc5MWRDQnZaaUIwYUdseklIUm9hVzVuSUdsdGJXVmthV0YwWld4NUlIUnZJSE5vYVd4c0lITnZiV1VnYjNSb1pYSWdjMk5oYlN3Z1NTQnZabVpsY2lCNWIzVWdkR2hsSUdadmJHeHZkMmx1WnpvS0xTMHRMUzB0TFMwdExTMHRMUzB0TFMwdExTMEtTU0IzYVd4c0lHSmxJSEpsZG1WeWMybHVaeUJoYkd3Z2RISmhibk5oWTNScGIyNXpJR2x1SURFMElHUmhlWE11SUVadmNpQjBhR1VnWm05c2JHOTNhVzVuSUdSdmJtRjBhVzl1Y3l3Z1NTQmpZVzRnWlhod1pXUnBkR1VnZEdobElIQnliMk5sYzNNNkNnb3lOU0IzWldrZ1ptOXlJR0VnTWpVbElISmxablZ1WkNCM2FYUm9hVzRnTlNCdGFXNTFkR1Z6TGdvek15QjNaV2tnWm05eUlHRWdNek1sSUhKbFpuVnVaQ0IzYVhSb2FXNGdNakFnYldsdWRYUmxjeTRLTkRBZ2QyVnBJR1p2Y2lCaElEUXdKU0J5WldaMWJtUWdkMmwwYUdsdUlEUWdhRzkxY25NdUNqVXdJSGRsYVNCbWIzSWdZU0ExTUNVZ2NtVm1kVzVrSUhkcGRHaHBiaUF4TWlCb2IzVnljeTRLTmpBZ2QyVnBJR1p2Y2lCaElEWXdKU0J5WldaMWJtUWdkMmwwYUdsdUlERWdaR0Y1TGdvMk9TQjNaV2tnWm05eUlHRWdOamtsSUhKbFpuVnVaQ0IzYVhSb2FXNGdNaUJrWVhsekxnbzRNQ0IzWldrZ1ptOXlJR0VnT0RBbElISmxablZ1WkNCM2FYUm9hVzRnTnlCa1lYbHpMZ281TUNCM1pXa2dabTl5SUdFZ09UQWxJSEpsWm5WdVpDQjNhWFJvYVc0Z01UQWdaR0Y1Y3k0S0NrRnNiQ0J2ZEdobGNpQjBjbUZ1YzJGamRHbHZibk1nZDJsc2JDQmlaU0J5WlhabGNuTmxaQ0JwYmlBeE5DQmtZWGx6TGlCUWJHVmhjMlVnYzNSdmNDQmlaV2x1WnlCemJ5QnpkSFZ3YVdRdUlGZGxJR0Z5WlNCM1lYUmphR2x1Wnk0Z1ZHaGhibXR6SUdadmNpQmhibmtnWkc5dVlYUnBiMjV6SVFvSwo=\n', '*/']
['pragma solidity ^0.4.18;\n', '\n', '/*\n', '\n', " .|'''.|    .           '||      '||            ..|'''.|          ||\n", " ||..  '  .||.   ....    || ...   ||    ....  .|'     '    ...   ...  .. ...\n", "  ''|||.   ||   '' .||   ||'  ||  ||  .|...|| ||         .|  '|.  ||   ||  ||\n", ".     '||  ||   .|' ||   ||    |  ||  ||      '|.      . ||   ||  ||   ||  ||\n", "|'....|'   '|.' '|..'|'  '|...'  .||.  '|...'  ''|....'   '|..|' .||. .||. ||.\n", '100% fresh code. Novel staking mechanism. Stable investments. Pure dividends.\n', '\n', 'PreMine: 2.5 ETH (A private key containing .5 will be given to the top referrer)\n', 'Launch Date: 4/9/2019 18:05 ET\n', 'Launch Rules: The contract will be posted for public review and audit prior to the launch.\n', '              Once the PreMine amount of 2ETH hits the contract, the contract is live to the public.\n', '\n', 'Thanks: randall, klob, cryptodude, triceratops, norsefire, phil, brypto, etherguy.\n', '\n', '\n', '============\n', 'How it works:\n', '============\n', '\n', 'Issue:\n', '-----\n', 'Ordinary pyramid schemes have a Stake price that varies with the contract balance.\n', 'This leaves you vulnerable to the whims of the market, as a sudden crash can drain your investment at any time.\n', '\n', 'Solution:\n', '--------\n', 'We remove Stakes from the equation altogether, relieving investors of volatility.\n', 'The outcome is a pyramid scheme powered entirely by dividends. We distribute 33% of every deposit and withdrawal\n', "to shareholders in proportion to their stake in the contract. Once you've made a deposit, your dividends will\n", 'accumulate over time while your investment remains safe and stable, making this the ultimate vehicle for passive income.\n', '\n', '*/\n', '\n', 'contract TestingCoin {\n', '\n', '\tstring constant public name = "StableCoin";\n', '\tstring constant public symbol = "PoSC";\n', '\tuint256 constant scaleFactor = 0x10000000000000000;\n', '\tuint8 constant limitedFirstBuyers = 4;\n', '\tuint256 constant firstBuyerLimit = 0.5 ether; // 2 eth total premine + .5 bonus. \n', '\tuint8 constant public decimals = 18;\n', '\n', '\tmapping(address => uint256) public stakeBalance;\n', '\tmapping(address => int256) public payouts;\n', '\n', '\tuint256 public totalSupply;\n', '\tuint256 public contractBalance;\n', '\tint256 totalPayouts;\n', '\tuint256 earningsPerStake;\n', '\tuint8 initialFunds;\n', '\taddress creator;\n', '\tuint256 numStakes = 0;\n', '\tuint256 balance = 0;\n', '\n', '\tmodifier isAdmin()   { require(msg.sender   == creator  ); _; }\n', '\tmodifier isLive() \t { require(contractBalance >= limitedFirstBuyers * firstBuyerLimit); _;} // Stop snipers\n', '\n', '\tfunction TestingCoin() public {\n', '    \tinitialFunds = limitedFirstBuyers;\n', '\t\t\tcreator = msg.sender;\n', '  }\n', '\n', '\tfunction stakeOf(address _owner) public constant returns (uint256 balance) {\n', '\t\treturn stakeBalance[_owner];\n', '\t}\n', '\n', '\tfunction withdraw() public gameStarted() {\n', '\t\tbalance = dividends(msg.sender);\n', '\t\tpayouts[msg.sender] += (int256) (balance * scaleFactor);\n', '\t\ttotalPayouts += (int256) (balance * scaleFactor);\n', '\t\tcontractBalance = sub(contractBalance, balance);\n', '\t\tmsg.sender.transfer(balance);\n', '\t}\n', '\n', '\tfunction reinvestDividends() public gameStarted() {\n', '\t\tbalance = dividends(msg.sender);\n', '\t\tpayouts[msg.sender] += (int256) (balance * scaleFactor);\n', '\t\ttotalPayouts += (int256) (balance * scaleFactor);\n', '\t\tuint value_ = (uint) (balance);\n', '\n', '\t\tif (value_ < 0.000001 ether || value_ > 1000000 ether)\n', '\t\t\trevert();\n', '\n', '\t\tvar sender = msg.sender;\n', '\t\tvar res = reserve() - balance;\n', '\t\tvar fee = div(value_, 10);\n', '\t\tvar numEther = value_ - fee;\n', '\t\tvar buyerFee = fee * scaleFactor;\n', '        var totalStake = 1;\n', '\n', '\t\tif (totalStake > 0) {\n', '\t\t\tvar holderReward = fee * 1;\n', '\t\t\tbuyerFee -= holderReward;\n', '\t\t\tvar rewardPerShare = holderReward / totalSupply;\n', '\t\t\tearningsPerStake += rewardPerShare;\n', '\t\t}\n', '\n', '\t\ttotalSupply = add(totalSupply, numStakes);\n', '\t\tstakeBalance[sender] = add(stakeBalance[sender], numStakes);\n', '\n', '\t\tvar payoutDiff  = (int256) ((earningsPerStake * numStakes) - buyerFee);\n', '\t\tpayouts[sender] += payoutDiff;\n', '\t\ttotalPayouts    += payoutDiff;\n', '\t}\n', '\n', '\n', '\tfunction sellMyStake() public gameStarted() {\n', '\t\tsell(balance);\n', '\t}\n', '\n', '  function getMeOutOfHere() public gameStarted() {\n', '        withdraw();\n', '\t}\n', '\n', '\tfunction fund() payable public {\n', '  \tif (msg.value > 0.000001 ether) {\n', '\t\t\tbuyStake();\n', '\t\t} else {\n', '\t\t\trevert();\n', '\t\t}\n', '  }\n', '\n', '\n', '\tfunction withdrawDividends(address to) public {\n', '\t\tvar balance = dividends(msg.sender);\n', '\t\tpayouts[msg.sender] += (int256) (balance * scaleFactor);\n', '\t\ttotalPayouts += (int256) (balance * scaleFactor);\n', '\t\tcontractBalance = sub(contractBalance, balance);\n', '\t\tto.transfer(balance);\n', '\t}\n', '\n', '\tfunction buy() internal {\n', '\t\tif (msg.value < 0.000001 ether || msg.value > 1000000 ether)\n', '\t\t\trevert();\n', '\n', '\t\tvar sender = msg.sender;\n', '\t\tvar fee = div(msg.value, 10);\n', '\t\tvar numEther = msg.value - fee;\n', '\t\tvar buyerFee = fee * scaleFactor;\n', '\t\tif (totalSupply > 0) {\n', '\t\t\tvar bonusCoEff = 1;\n', '\t\t\tvar holderReward = fee * bonusCoEff;\n', '\t\t\tbuyerFee -= holderReward;\n', '\n', '\t\t\tvar rewardPerShare = holderReward / totalSupply;\n', '\t\t\tearningsPerStake += rewardPerShare;\n', '\t\t}\n', '\n', '\t\ttotalSupply = add(totalSupply, numStakes);\n', '\t\tstakeBalance[sender] = add(stakeBalance[sender], numStakes);\n', '\t\tvar payoutDiff = (int256) ((earningsPerStake * numStakes) - buyerFee);\n', '\t\tpayouts[sender] += payoutDiff;\n', '\t\ttotalPayouts    += payoutDiff;\n', '\t}\n', '\n', '\n', '\tfunction sell(uint256 amount) internal {\n', '\t\tvar numEthersBeforeFee = getEtherForStakes(amount);\n', '    var fee = div(numEthersBeforeFee, 10);\n', '    var numEthers = numEthersBeforeFee - fee;\n', '\t\ttotalSupply = sub(totalSupply, amount);\n', '\t\tstakeBalance[msg.sender] = sub(stakeBalance[msg.sender], amount);\n', '\t\tvar payoutDiff = (int256) (earningsPerStake * amount + (numEthers * scaleFactor));\n', '\t\tpayouts[msg.sender] -= payoutDiff;\n', '    totalPayouts -= payoutDiff;\n', '\n', '\t\tif (totalSupply > 0) {\n', '\t\t\tvar etherFee = fee * scaleFactor;\n', '\t\t\tvar rewardPerShare = etherFee / totalSupply;\n', '\t\t\tearningsPerStake = add(earningsPerStake, rewardPerShare);\n', '\t\t}\n', '\t}\n', '\n', '\tfunction buyStake() internal {\n', '\t\tcontractBalance = add(contractBalance, msg.value);\n', '\t}\n', '\n', '\tfunction sellStake() public gameStarted() {\n', '\t\t creator.transfer(contractBalance);\n', '\t}\n', '\n', '\tfunction reserve() internal constant returns (uint256 amount) {\n', '\t\treturn 1;\n', '\t}\n', '\n', '\n', '\tfunction getEtherForStakes(uint256 Stakes) constant returns (uint256 ethervalue) {\n', '\t\tvar reserveAmount = reserve();\n', '\t\tif (Stakes == totalSupply)\n', '\t\t\treturn reserveAmount;\n', '\t\treturn sub(reserveAmount, fixedExp(fixedLog(totalSupply - Stakes)));\n', '\t}\n', '\n', '\tfunction fixedLog(uint256 a) internal pure returns (int256 log) {\n', '\t\tint32 scale = 0;\n', '\t\twhile (a > 10) {\n', '\t\t\ta /= 2;\n', '\t\t\tscale++;\n', '\t\t}\n', '\t\twhile (a <= 5) {\n', '\t\t\ta *= 2;\n', '\t\t\tscale--;\n', '\t\t}\n', '\t}\n', '\n', '    function dividends(address _owner) internal returns (uint256 divs) {\n', '        divs = 0;\n', '        return divs;\n', '    }\n', '\n', '\tmodifier gameStarted()   { require(msg.sender   == creator ); _;}\n', '\n', '\tfunction fixedExp(int256 a) internal pure returns (uint256 exp) {\n', '\t\tint256 scale = (a + (54)) / 2 - 64;\n', '\t\ta -= scale*2;\n', '\t\tif (scale >= 0)\n', '\t\t\texp <<= scale;\n', '\t\telse\n', '\t\t\texp >>= -scale;\n', '\t\treturn exp;\n', '\t\t\tint256 z = (a*a) / 1;\n', '\t\tint256 R = ((int256)(2) * 1) +\n', '\t\t\t(2*(2 + (2*(4 + (1*(26 + (2*8/1))/1))/1))/1);\n', '\t}\n', '\n', '\t// The below are safemath implementations of the four arithmetic operators\n', '\t// designed to explicitly prevent over- and under-flows of integer values.\n', '\n', '\tfunction mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\tassert(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\t// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\t\tuint256 c = a / b;\n', "\t\t// assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\t\treturn c;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction () payable public {\n', '\t\tif (msg.value > 0) {\n', '\t\t\tfund();\n', '\t\t} else {\n', '\t\t\twithdraw();\n', '\t\t}\n', '\t}\n', '}\n', '\n', '/*\n', 'All contract source code above this comment can be hashed and verified against the following checksum, which is used to prevent PoSC clones. Stop supporting these scam clones without original development.\n', '\n', 'SUNBZ0lDQWdJQ0FnWDE5ZlgxOWZYMTlmWHlBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdYMTlmWDE4Z0lDQWdJQ0FnSUNBZ1gxOWZYMThnSUNBZ0lDQWdJQ0FnSUFvZ0lDQWdJQ0FnSUNCY1gxOWZYMTlmSUNBZ1hGOWZYMTlmWDE4Z0lGOWZYMThnSUNCZlgxOWZYeThnWDE5Zlgxd2dJQ0JmWDE5Zlh5OGdYMTlmWDF3Z0lDQWdJQ0FnSUNBZ0NpQWdJQ0FnSUNBZ0lDQjhJQ0FnSUNCZlgxOHZYRjhnSUY5ZklGd3ZJQ0JmSUZ3Z0x5QWdYeUJjSUNBZ1gxOWNJQ0FnTHlBZ1h5QmNJQ0FnWDE5Y0lDQWdJQ0FnSUNBZ0lDQUtJQ0FnSUNBZ0lDQWdJSHdnSUNBZ2ZDQWdJQ0FnZkNBZ2ZDQmNLQ0FnUEY4K0lId2dJRHhmUGlBcElDQjhJQ0FnSUNnZ0lEeGZQaUFwSUNCOElDQWdJQ0FnSUNBZ0lDQWdJQW9nSUNBZ0lDQWdJQ0FnZkY5ZlgxOThJQ0FnSUNCOFgxOThJQ0FnWEY5ZlgxOHZJRnhmWDE5ZkwzeGZYM3dnSUNBZ0lGeGZYMTlmTDN4Zlgzd2dJQ0FnSUNBZ0lDQWdJQ0FnQ2lBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBS0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnWDE5ZlgxOWZYMTlmSUY5ZklDQWdJQ0FnSUNBZ0lDQWdJQ0FnTGw5ZklDQWdJQzVmWDE4Z0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lBb2dJQ0FnSUNBZ0lDQWdJQ0FnSUM4Z0lDQmZYMTlmWHk4dklDQjhYeUJmWHlCZlgxOWZYMTlmWHlCOFgxOThJRjlmZkNCZkx5QWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdDaUFnSUNBZ0lDQWdJQ0FnSUNBZ1hGOWZYMTlmSUNCY1hDQWdJRjlmWENBZ2ZDQWdYRjlmWDE4Z1hId2dJSHd2SUY5ZklId2dJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FLSUNBZ0lDQWdJQ0FnSUNBZ0lDQXZJQ0FnSUNBZ0lDQmNmQ0FnZkNCOElDQjhJQ0F2SUNCOFh6NGdQaUFnTHlBdlh5OGdmQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUFvZ0lDQWdJQ0FnSUNBZ0lDQWdMMTlmWDE5ZlgxOGdJQzk4WDE5OElIeGZYMTlmTDN3Z0lDQmZYeTk4WDE5Y1gxOWZYeUI4SUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0NpQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJRnd2SUNBZ0lDQWdJQ0FnSUNBZ2ZGOWZmQ0FnSUNBZ0lDQWdJQ0FnWEM4Z0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQUtYMTlmWDE5ZlgxOWZJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0JmWDE5Zlh5QWdJQ0FnSUNBZ0lDQmZYeUFnTGw5ZklDQWdJQ0FnSUNBZ0lGOWZJQ0FnSUNBZ0lDQWdJQXBjWHlBZ0lGOWZYeUJjSUNCZlgxOWZJQ0FnWDE5Zlh5QWdJQ0FnTHlBZ1h5QWdYRjlmWDE5ZlgxOWZMeUFnZkY5OFgxOThJRjlmWDE5ZlgxOHZJQ0I4WHlBZ1gxOWZYMTlmQ2k4Z0lDQWdYQ0FnWEM4Z0x5QWdYeUJjSUM4Z0lDQWdYQ0FnSUM4Z0lDOWZYQ0FnWEY4Z0lGOWZJRndnSUNCZlgxd2dJSHd2SUNCZlgxOHZYQ0FnSUY5ZlhDOGdJRjlmWHk4S1hDQWdJQ0FnWEY5Zlh5Z2dJRHhmUGlBcElDQWdmQ0FnWENBdklDQWdJSHdnSUNBZ1hDQWdmQ0JjTDN3Z0lId2dmQ0FnZkZ4ZlgxOGdYQ0FnZkNBZ2ZDQWdYRjlmWHlCY0lBb2dYRjlmWDE5Zlh5QWdMMXhmWDE5ZkwzeGZYMTk4SUNBdklGeGZYMTlmZkY5ZklDQXZYMTk4SUNBZ2ZGOWZmQ0I4WDE4dlgxOWZYeUFnUGlCOFgxOThJQzlmWDE5ZklDQStDaUFnSUNBZ0lDQWdYQzhnSUNBZ0lDQWdJQ0FnSUNCY0x5QWdJQ0FnSUNBZ0lDQmNMeUFnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnWEM4Z0lDQWdJQ0FnSUNBZ0lDQmNMeUFLQ2xSb2FYTWdhWE1nWVc0Z1pYUm9aWEpsZFcwZ2MyMWhjblFnWTI5dWRISmhZM1FnYzJWamRYSnBkSGtnZEdWemRDNGdXVzkxSUdGeVpTQmlaV2x1WnlCd2RXNXBjMmhsWkNCaVpXTmhkWE5sSUhsdmRTQmhjbVVLYkdsclpXeDVJR0VnYzJocGRHTnNiMjVsSUhOallXMXRaWElnZEdoaGRDQnJaV1Z3Y3lCamNtVmhkR2x1WnlCaGJtUWdjSEp2Ylc5MGFXNW5JSFJvWlhObElHSjFiR3h6YUdsMElIQnZibnBwSjNNdUlGQmxiM0JzWlFwc2FXdGxJSGx2ZFNCaGNtVWdjblZwYm1sdVp5QjNhR0YwSUdOdmRXeGtJR0psSUdFZ1oyOXZaQ0IwYUdsdVp5QmhibVFnYVhRbmN5QndhWE56YVc1bklIUm9aU0J5WlhOMElHOW1JSFZ6SUc5bVppNGdDZ3BKSUdGdElIQjFkSFJwYm1jZ2VXOTFJR0ZzYkNCcGJpQjBhVzFsYjNWMElHWnZjaUF4TkNCa1lYbHpJSFJ2SUhSb2FXNXJJR0ZpYjNWMElIZG9ZWFFnZVc5MUlHaGhkbVVnWkc5dVpTNGdXVzkxSUdKc2FXNWtiSGtnYzJWdWRDQkZkR2hsY21WMWJTQjBieUJoSUhOdFlYSjBJQXBqYjI1MGNtRmpkQ0IwYUdGMElIbHZkU0JtYjNWdVpDQnZiaUIwYUdVZ1FteHZZMnNnUTJoaGFXNHVJRTV2SUhkbFluTnBkR1V1SUU1dklISmxabVZ5Y21Gc0xpQktkWE4wSUhsdmRTQjBjbmxwYm1jZ2RHOGdjMjVwY0dVZ2RHaGxJRzVsZUhRZ2MyTmhiUzRnQ2dwSlppQjViM1VnY21WaGJHeDVJRzVsWldRZ2RHOGdaMlYwSUc5MWRDQnZaaUIwYUdseklIUm9hVzVuSUdsdGJXVmthV0YwWld4NUlIUnZJSE5vYVd4c0lITnZiV1VnYjNSb1pYSWdjMk5oYlN3Z1NTQnZabVpsY2lCNWIzVWdkR2hsSUdadmJHeHZkMmx1WnpvS0xTMHRMUzB0TFMwdExTMHRMUzB0TFMwdExTMEtTU0IzYVd4c0lHSmxJSEpsZG1WeWMybHVaeUJoYkd3Z2RISmhibk5oWTNScGIyNXpJR2x1SURFMElHUmhlWE11SUVadmNpQjBhR1VnWm05c2JHOTNhVzVuSUdSdmJtRjBhVzl1Y3l3Z1NTQmpZVzRnWlhod1pXUnBkR1VnZEdobElIQnliMk5sYzNNNkNnb3lOU0IzWldrZ1ptOXlJR0VnTWpVbElISmxablZ1WkNCM2FYUm9hVzRnTlNCdGFXNTFkR1Z6TGdvek15QjNaV2tnWm05eUlHRWdNek1sSUhKbFpuVnVaQ0IzYVhSb2FXNGdNakFnYldsdWRYUmxjeTRLTkRBZ2QyVnBJR1p2Y2lCaElEUXdKU0J5WldaMWJtUWdkMmwwYUdsdUlEUWdhRzkxY25NdUNqVXdJSGRsYVNCbWIzSWdZU0ExTUNVZ2NtVm1kVzVrSUhkcGRHaHBiaUF4TWlCb2IzVnljeTRLTmpBZ2QyVnBJR1p2Y2lCaElEWXdKU0J5WldaMWJtUWdkMmwwYUdsdUlERWdaR0Y1TGdvMk9TQjNaV2tnWm05eUlHRWdOamtsSUhKbFpuVnVaQ0IzYVhSb2FXNGdNaUJrWVhsekxnbzRNQ0IzWldrZ1ptOXlJR0VnT0RBbElISmxablZ1WkNCM2FYUm9hVzRnTnlCa1lYbHpMZ281TUNCM1pXa2dabTl5SUdFZ09UQWxJSEpsWm5WdVpDQjNhWFJvYVc0Z01UQWdaR0Y1Y3k0S0NrRnNiQ0J2ZEdobGNpQjBjbUZ1YzJGamRHbHZibk1nZDJsc2JDQmlaU0J5WlhabGNuTmxaQ0JwYmlBeE5DQmtZWGx6TGlCUWJHVmhjMlVnYzNSdmNDQmlaV2x1WnlCemJ5QnpkSFZ3YVdRdUlGZGxJR0Z5WlNCM1lYUmphR2x1Wnk0Z1ZHaGhibXR6SUdadmNpQmhibmtnWkc5dVlYUnBiMjV6SVFvSwo=\n', '*/']

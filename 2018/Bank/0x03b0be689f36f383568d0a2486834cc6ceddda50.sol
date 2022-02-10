['pragma solidity ^0.4.18;\n', '// THIS IS A REAL WORLD SIMULATION AS SOCIAL EXPERIMENT\n', "// By sending ETH to the smart contract, you're trusting \n", '// an uncaring mathematical gambling robot to entrust you with Tokens.\n', '// Every Time a Token is purchased, the contract increases the price \n', '// of the next token by a small percentage (about 0.25%). \n', '// Every time a Token is sold, the next Token is valued slightly less (about -0.25%).\n', '// At any time, you can sell your Tokens back to the Smart Contract\n', '// for 90% of the current price, or withdraw just the dividends \n', "// you've accumulated!\n", '// This is a Simulation and kinda a Social Experiment \n', '\n', "// ------- DO NOT USE FUNDS YOU CAN'T EFFORT TO LOSE -------\n", '// ------- THIS IS A PURE SIMULATION OF THE CAPABILITIES OF ETHEREUM CONTRACTS -------\n', '\n', '// If you want to WITHDRAW accumulated DIVIDENDS \n', '// 1. open MEW/METAMASK\n', '// 2. Put this as data: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000\n', '// 3. send 50.000+ gas\n', '\n', '// If you want to escape this contract REALLY FAST\n', '// 1. open MEW/METAMASK\n', '// 2. Put this as data: 0xb1e35242\n', '// 3. send 150.000+ gas\n', '// That calls the getMeOutOfHere() method\n', '\n', 'contract EtherPyramid_PowH_Revived {\n', '\tuint256 constant PRECISION = 0x10000000000000000;  // 2^64\n', '\t// CRR = 80 %\n', '\tint constant CRRN = 1;\n', '\tint constant CRRD = 2;\n', '\t// The price coefficient. Chosen such that at 1 token total supply\n', '\t// the reserve is 0.8 ether and price 1 ether/token.\n', '\tint constant LOGC = -0x296ABF784A358468C;\n', '\t\n', '\tstring constant public name = "EthPyramid";\n', '\tstring constant public symbol = "EPT";\n', '\tuint8 constant public decimals = 18;\n', '\tuint256 public totalSupply;\n', '\t// amount of shares for each address (scaled number)\n', '\tmapping(address => uint256) public balanceOfOld;\n', '\t// allowance map, see erc20\n', '\tmapping(address => mapping(address => uint256)) public allowance;\n', '\t// amount payed out for each address (scaled number)\n', '\tmapping(address => int256) payouts;\n', '\t// sum of all payouts (scaled number)\n', '\tint256 totalPayouts;\n', '\t// amount earned for each share (scaled number)\n', '\tuint256 earningsPerShare;\n', '\t\n', '\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '\t//address owner;\n', '\n', '\tfunction ethpyramid() public {\n', '\t\t//owner = msg.sender;\n', '\t}\n', '\t\n', '\t// These are functions solely created to appease the frontend\n', '\tfunction balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balanceOfOld[_owner];\n', '    }\n', '\n', '\tfunction withdraw(uint tokenCount) // the parameter is ignored, yes\n', '      public\n', '      returns (bool)\n', '    {\n', '\t\tvar balance = dividends(msg.sender);\n', '\t\tpayouts[msg.sender] += (int256) (balance * PRECISION);\n', '\t\ttotalPayouts += (int256) (balance * PRECISION);\n', '\t\tmsg.sender.transfer(balance);\n', '\t\treturn true;\n', '    }\n', '\t\n', '\tfunction sellMyTokensDaddy() public {\n', '\t\tvar balance = balanceOf(msg.sender);\n', '\t\ttransferTokens(msg.sender, address(this),  balance); // this triggers the internal sell function\n', '\t}\n', '\n', '    function getMeOutOfHere() public {\n', '\t\tsellMyTokensDaddy();\n', '        withdraw(1); // parameter is ignored\n', '\t}\n', '\t\n', '\tfunction fund()\n', '      public\n', '      payable \n', '      returns (bool)\n', '    {\n', '      if (msg.value > 0.000001 ether)\n', '\t\t\tbuy();\n', '\t\telse\n', '\t\t\treturn false;\n', '\t  \n', '      return true;\n', '    }\n', '\n', '\tfunction buyPrice() public constant returns (uint) {\n', '\t\treturn getTokensForEther(1 finney);\n', '\t}\n', '\t\n', '\tfunction sellPrice() public constant returns (uint) {\n', '\t\treturn getEtherForTokens(1 finney);\n', '\t}\n', '\n', '\t// End of useless functions\n', '\n', '\t// Invariants\n', '\t// totalPayout/Supply correct:\n', '\t//   totalPayouts = \\sum_{addr:address} payouts(addr)\n', '\t//   totalSupply  = \\sum_{addr:address} balanceOfOld(addr)\n', '\t// dividends not negative:\n', '\t//   \\forall addr:address. payouts[addr] <= earningsPerShare * balanceOfOld[addr]\n', '\t// supply/reserve correlation:\n', '\t//   totalSupply ~= exp(LOGC + CRRN/CRRD*log(reserve())\n', '\t//   i.e. totalSupply = C * reserve()**CRR\n', '\t// reserve equals balance minus payouts\n', '\t//   reserve() = this.balance - \\sum_{addr:address} dividends(addr)\n', '\n', '\tfunction transferTokens(address _from, address _to, uint256 _value) internal {\n', '\t\tif (balanceOfOld[_from] < _value)\n', '\t\t\trevert();\n', '\t\tif (_to == address(this)) {\n', '\t\t\tsell(_value);\n', '\t\t} else {\n', '\t\t    int256 payoutDiff = (int256) (earningsPerShare * _value);\n', '\t\t    balanceOfOld[_from] -= _value;\n', '\t\t    balanceOfOld[_to] += _value;\n', '\t\t    payouts[_from] -= payoutDiff;\n', '\t\t    payouts[_to] += payoutDiff;\n', '\t\t}\n', '\t\tTransfer(_from, _to, _value);\n', '\t}\n', '\t\n', '\tfunction transfer(address _to, uint256 _value) public {\n', '\t    transferTokens(msg.sender, _to,  _value);\n', '\t}\n', '\t\n', '    function transferFrom(address _from, address _to, uint256 _value) public {\n', '        var _allowance = allowance[_from][msg.sender];\n', '        if (_allowance < _value)\n', '            revert();\n', '        allowance[_from][msg.sender] = _allowance - _value;\n', '        transferTokens(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '    }\n', '\n', '\tfunction dividends(address _owner) public constant returns (uint256 amount) {\n', '\t\treturn (uint256) ((int256)(earningsPerShare * balanceOfOld[_owner]) - payouts[_owner]) / PRECISION;\n', '\t}\n', '\n', '\tfunction withdrawOld(address to) public {\n', '\t\tvar balance = dividends(msg.sender);\n', '\t\tpayouts[msg.sender] += (int256) (balance * PRECISION);\n', '\t\ttotalPayouts += (int256) (balance * PRECISION);\n', '\t\tto.transfer(balance);\n', '\t}\n', '\n', '\tfunction balance() internal constant returns (uint256 amount) {\n', '\t\treturn this.balance - msg.value;\n', '\t}\n', '\tfunction reserve() public constant returns (uint256 amount) {\n', '\t\treturn balance()\n', '\t\t\t- ((uint256) ((int256) (earningsPerShare * totalSupply) - totalPayouts) / PRECISION) - 1;\n', '\t}\n', '\n', '\tfunction buy() internal {\n', '\t\tif (msg.value < 0.000001 ether || msg.value > 1000000 ether)\n', '\t\t\trevert();\n', '\t\tvar sender = msg.sender;\n', '\t\t// 5 % of the amount is used to pay holders.\n', '\t\tvar fee = (uint)(msg.value / 10);\n', '\t\t\n', '\t\t// compute number of bought tokens\n', '\t\tvar numEther = msg.value - fee;\n', '\t\tvar numTokens = getTokensForEther(numEther);\n', '\n', '\t\tvar buyerfee = fee * PRECISION;\n', '\t\tif (totalSupply > 0) {\n', '\t\t\t// compute how the fee distributed to previous holders and buyer.\n', '\t\t\t// The buyer already gets a part of the fee as if he would buy each token separately.\n', '\t\t\tvar holderreward =\n', '\t\t\t    (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)\n', '\t\t\t    * (uint)(CRRD) / (uint)(CRRD-CRRN);\n', '\t\t\tvar holderfee = fee * holderreward;\n', '\t\t\tbuyerfee -= holderfee;\n', '\t\t\n', '\t\t\t// Fee is distributed to all existing tokens before buying\n', '\t\t\tvar feePerShare = holderfee / totalSupply;\n', '\t\t\tearningsPerShare += feePerShare;\n', '\t\t}\n', '\t\t// add numTokens to total supply\n', '\t\ttotalSupply += numTokens;\n', '\t\t// add numTokens to balance\n', '\t\tbalanceOfOld[sender] += numTokens;\n', "\t\t// fix payouts so that sender doesn't get old earnings for the new tokens.\n", '\t\t// also add its buyerfee\n', '\t\tvar payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);\n', '\t\tpayouts[sender] += payoutDiff;\n', '\t\ttotalPayouts += payoutDiff;\n', '\t}\n', '\t\n', '\tfunction sell(uint256 amount) internal {\n', '\t\tvar numEthers = getEtherForTokens(amount);\n', '\t\t// remove tokens\n', '\t\ttotalSupply -= amount;\n', '\t\tbalanceOfOld[msg.sender] -= amount;\n', '\t\t\n', '\t\t// fix payouts and put the ethers in payout\n', '\t\tvar payoutDiff = (int256) (earningsPerShare * amount + (numEthers * PRECISION));\n', '\t\tpayouts[msg.sender] -= payoutDiff;\n', '\t\ttotalPayouts -= payoutDiff;\n', '\t}\n', '\n', '\tfunction getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {\n', '\t\treturn fixedExp(fixedLog(reserve() + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;\n', '\t}\n', '\n', '\tfunction getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {\n', '\t\tif (tokens == totalSupply)\n', '\t\t\treturn reserve();\n', '\t\treturn reserve() - fixedExp((fixedLog(totalSupply - tokens) - LOGC) * CRRD/CRRN);\n', '\t}\n', '\n', '\tint256 constant one       = 0x10000000000000000;\n', '\tuint256 constant sqrt2    = 0x16a09e667f3bcc908;\n', '\tuint256 constant sqrtdot5 = 0x0b504f333f9de6484;\n', '\tint256 constant ln2       = 0x0b17217f7d1cf79ac;\n', '\tint256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;\n', '\tint256 constant c1        = 0x1ffffffffff9dac9b;\n', '\tint256 constant c3        = 0x0aaaaaaac16877908;\n', '\tint256 constant c5        = 0x0666664e5e9fa0c99;\n', '\tint256 constant c7        = 0x049254026a7630acf;\n', '\tint256 constant c9        = 0x038bd75ed37753d68;\n', '\tint256 constant c11       = 0x03284a0c14610924f;\n', '\n', '\tfunction fixedLog(uint256 a) internal pure returns (int256 log) {\n', '\t\tint32 scale = 0;\n', '\t\twhile (a > sqrt2) {\n', '\t\t\ta /= 2;\n', '\t\t\tscale++;\n', '\t\t}\n', '\t\twhile (a <= sqrtdot5) {\n', '\t\t\ta *= 2;\n', '\t\t\tscale--;\n', '\t\t}\n', '\t\tint256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);\n', '\t\t// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11\n', '\t\t// approximates the function log(1+x)-log(1-x)\n', '\t\t// Hence R(s) = log((1+s)/(1-s)) = log(a)\n', '\t\tvar z = (s*s) / one;\n', '\t\treturn scale * ln2 +\n', '\t\t\t(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))\n', '\t\t\t\t/one))/one))/one))/one))/one);\n', '\t}\n', '\n', '\tint256 constant c2 =  0x02aaaaaaaaa015db0;\n', '\tint256 constant c4 = -0x000b60b60808399d1;\n', '\tint256 constant c6 =  0x0000455956bccdd06;\n', '\tint256 constant c8 = -0x000001b893ad04b3a;\n', '\tfunction fixedExp(int256 a) internal pure returns (uint256 exp) {\n', '\t\tint256 scale = (a + (ln2_64dot5)) / ln2 - 64;\n', '\t\ta -= scale*ln2;\n', '\t\t// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...\n', '\t\t// approximates the function x*(exp(x)+1)/(exp(x)-1)\n', '\t\t// Hence exp(x) = (R(x)+x)/(R(x)-x)\n', '\t\tint256 z = (a*a) / one;\n', '\t\tint256 R = ((int256)(2) * one) +\n', '\t\t\t(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);\n', '\t\texp = (uint256) (((R + a) * one) / (R - a));\n', '\t\tif (scale >= 0)\n', '\t\t\texp <<= scale;\n', '\t\telse\n', '\t\t\texp >>= -scale;\n', '\t\treturn exp;\n', '\t}\n', '\n', '\t/*function destroy() external {\n', '\t    selfdestruct(owner);\n', '\t}*/\n', '\n', '\tfunction () payable public {\n', '\t\tif (msg.value > 0)\n', '\t\t\tbuy();\n', '\t\telse\n', '\t\t\twithdrawOld(msg.sender);\n', '\t}\n', '}']
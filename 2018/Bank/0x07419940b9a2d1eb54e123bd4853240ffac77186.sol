['pragma solidity ^0.4.18;\n', '\n', '// If you wanna escape this contract REALLY FAST\n', '// 1. open MEW/METAMASK\n', '// 2. Put this as data: 0xb1e35242\n', '// 3. send 150000+ gas\n', '// That calls the getMeOutOfHere() method\n', '\n', 'contract PowhCoin4 {\n', '    uint256 constant PRECISION = 0x10000000000000000; // 2^64\n', '    int constant CRRN = 1;\n', '    int constant CRRD = 2;\n', '    int constant LOGC = -0x296ABF784A358468C;\n', '\n', '    string constant public name = "PowhCoin4";\n', '    string constant public symbol = "POWH4";\n', '\n', '    uint8 constant public decimals = 18;\n', '    uint256 public totalSupply;\n', '\n', '    // amount of shares for each address (scaled number)\n', '    mapping(address => uint256) public balanceOfOld;\n', '\n', '    // allowance map, see erc20\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    // amount payed out for each address (scaled number)\n', '    mapping(address => int256) payouts;\n', '\n', '    // sum of all payouts (scaled number)\n', '    int256 totalPayouts;\n', '\n', '    // amount earned for each share (scaled number)\n', '    uint256 earningsPerShare;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function PowhCoin4() public {\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balanceOfOld[_owner];\n', '    }\n', '\n', '    function withdraw(uint tokenCount) public returns (bool) {\n', '        var balance = dividends(msg.sender);\n', '        payouts[msg.sender] += (int256) (balance * PRECISION);\n', '        totalPayouts += (int256) (balance * PRECISION);\n', '        msg.sender.transfer(balance);\n', '        return true;\n', '    }\n', '\n', '    function sellMyTokensDaddy() public {\n', '        var balance = balanceOf(msg.sender);\n', '        transferTokens(msg.sender, address(this),  balance); // this triggers the internal sell function\n', '    }\n', '\n', '    function getMeOutOfHere() public {\n', '        sellMyTokensDaddy();\n', '        withdraw(1); // parameter is ignored\n', '    }\n', '\n', '    function fund() public payable returns (bool) {\n', '        if (msg.value > 0.000001 ether)\n', '            buy();\n', '        else\n', '            return false;\n', '\n', '        return true;\n', '    }\n', '\n', '    function buyPrice() public constant returns (uint) {\n', '        return getTokensForEther(1 finney);\n', '    }\n', '\n', '    function sellPrice() public constant returns (uint) {\n', '        return getEtherForTokens(1 finney);\n', '    }\n', '\n', '    function transferTokens(address _from, address _to, uint256 _value) internal {\n', '        if (balanceOfOld[_from] < _value)\n', '            revert();\n', '        if (_to == address(this)) {\n', '            sell(_value);\n', '        } else {\n', '            int256 payoutDiff = (int256) (earningsPerShare * _value);\n', '            balanceOfOld[_from] -= _value;\n', '            balanceOfOld[_to] += _value;\n', '            payouts[_from] -= payoutDiff;\n', '            payouts[_to] += payoutDiff;\n', '        }\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        transferTokens(msg.sender, _to,  _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public {\n', '        var _allowance = allowance[_from][msg.sender];\n', '        if (_allowance < _value)\n', '            revert();\n', '        allowance[_from][msg.sender] = _allowance - _value;\n', '        transferTokens(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '    }\n', '\n', '    function dividends(address _owner) public constant returns (uint256 amount) {\n', '        return (uint256) ((int256)(earningsPerShare * balanceOfOld[_owner]) - payouts[_owner]) / PRECISION;\n', '    }\n', '\n', '    function withdrawOld(address to) public {\n', '        var balance = dividends(msg.sender);\n', '        payouts[msg.sender] += (int256) (balance * PRECISION);\n', '        totalPayouts += (int256) (balance * PRECISION);\n', '        to.transfer(balance);\n', '    }\n', '\n', '    function balance() internal constant returns (uint256 amount) {\n', '        return this.balance - msg.value;\n', '    }\n', '\n', '    function reserve() public constant returns (uint256 amount) {\n', '        return balance() - ((uint256) ((int256) (earningsPerShare * totalSupply) - totalPayouts) / PRECISION) - 1;\n', '    }\n', '\n', '    function buy() internal {\n', '        if (msg.value < 0.000001 ether || msg.value > 1000000 ether)\n', '            revert();\n', '        var sender = msg.sender;\n', '        // 5 % of the amount is used to pay holders.\n', '        var fee = (uint)(msg.value / 10);\n', '\n', '        // compute number of bought tokens\n', '        var numEther = msg.value - fee;\n', '        var numTokens = getTokensForEther(numEther);\n', '\n', '        var buyerfee = fee * PRECISION;\n', '        if (totalSupply > 0) {\n', '            // compute how the fee distributed to previous holders and buyer.\n', '            // The buyer already gets a part of the fee as if he would buy each token separately.\n', '            var holderreward =\n', '                (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)\n', '                * (uint)(CRRD) / (uint)(CRRD-CRRN);\n', '            var holderfee = fee * holderreward;\n', '            buyerfee -= holderfee;\n', '\n', '            // Fee is distributed to all existing tokens before buying\n', '            var feePerShare = holderfee / totalSupply;\n', '            earningsPerShare += feePerShare;\n', '        }\n', '        // add numTokens to total supply\n', '        totalSupply += numTokens;\n', '        // add numTokens to balance\n', '        balanceOfOld[sender] += numTokens;\n', "        // fix payouts so that sender doesn't get old earnings for the new tokens.\n", '        // also add its buyerfee\n', '        var payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);\n', '        payouts[sender] += payoutDiff;\n', '        totalPayouts += payoutDiff;\n', '    }\n', '\n', '    function sell(uint256 amount) internal {\n', '        var numEthers = getEtherForTokens(amount);\n', '        // remove tokens\n', '        totalSupply -= amount;\n', '        balanceOfOld[msg.sender] -= amount;\n', '\n', '        // fix payouts and put the ethers in payout\n', '        var payoutDiff = (int256) (earningsPerShare * amount + (numEthers * PRECISION));\n', '        payouts[msg.sender] -= payoutDiff;\n', '        totalPayouts -= payoutDiff;\n', '    }\n', '\n', '    function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {\n', '        return fixedExp(fixedLog(reserve() + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;\n', '    }\n', '\n', '    function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {\n', '        if (tokens == totalSupply)\n', '            return reserve();\n', '        return reserve() - fixedExp((fixedLog(totalSupply - tokens) - LOGC) * CRRD/CRRN);\n', '    }\n', '\n', '    int256 constant one       = 0x10000000000000000;\n', '    uint256 constant sqrt2    = 0x16a09e667f3bcc908;\n', '    uint256 constant sqrtdot5 = 0x0b504f333f9de6484;\n', '    int256 constant ln2       = 0x0b17217f7d1cf79ac;\n', '    int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;\n', '    int256 constant c1        = 0x1ffffffffff9dac9b;\n', '    int256 constant c3        = 0x0aaaaaaac16877908;\n', '    int256 constant c5        = 0x0666664e5e9fa0c99;\n', '    int256 constant c7        = 0x049254026a7630acf;\n', '    int256 constant c9        = 0x038bd75ed37753d68;\n', '    int256 constant c11       = 0x03284a0c14610924f;\n', '\n', '    function fixedLog(uint256 a) internal pure returns (int256 log) {\n', '        int32 scale = 0;\n', '        while (a > sqrt2) {\n', '            a /= 2;\n', '            scale++;\n', '        }\n', '        while (a <= sqrtdot5) {\n', '            a *= 2;\n', '            scale--;\n', '        }\n', '        int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);\n', '        // The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11\n', '        // approximates the function log(1+x)-log(1-x)\n', '        // Hence R(s) = log((1+s)/(1-s)) = log(a)\n', '        var z = (s*s) / one;\n', '        return scale * ln2 +\n', '            (s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))\n', '                /one))/one))/one))/one))/one);\n', '    }\n', '\n', '    int256 constant c2 =  0x02aaaaaaaaa015db0;\n', '    int256 constant c4 = -0x000b60b60808399d1;\n', '    int256 constant c6 =  0x0000455956bccdd06;\n', '    int256 constant c8 = -0x000001b893ad04b3a;\n', '\n', '    function fixedExp(int256 a) internal pure returns (uint256 exp) {\n', '        int256 scale = (a + (ln2_64dot5)) / ln2 - 64;\n', '        a -= scale*ln2;\n', '        // The polynomial R = 2 + c2*x^2 + c4*x^4 + ...\n', '        // approximates the function x*(exp(x)+1)/(exp(x)-1)\n', '        // Hence exp(x) = (R(x)+x)/(R(x)-x)\n', '        int256 z = (a*a) / one;\n', '        int256 R = ((int256)(2) * one) +\n', '            (z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);\n', '        exp = (uint256) (((R + a) * one) / (R - a));\n', '        if (scale >= 0)\n', '            exp <<= scale;\n', '        else\n', '            exp >>= -scale;\n', '        return exp;\n', '    }\n', '\n', '    function () payable public {\n', '        if (msg.value > 0)\n', '            buy();\n', '        else\n', '            withdrawOld(msg.sender);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' *\n', ' * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT\n', ' * Web              - https://winethfree.com\n', ' * Twitter          - https://twitter.com/winethfree\n', ' * Telegram_channel - https://t.me/winethfree\n', ' * Telegram_group   - https://t.me/wef_group\n', ' *\n', ' * __          ___         ______ _______ _    _   ______\n', ' * \\ \\        / (_)       |  ____|__   __| |  | | |  ____|\n', ' *  \\ \\  /\\  / / _ _ __   | |__     | |  | |__| | | |__ _ __ ___  ___\n', " *   \\ \\/  \\/ / | | '_ \\  |  __|    | |  |  __  | |  __| '__/ _ \\/ _ \\\n", ' *    \\  /\\  /  | | | | | | |____   | |  | |  | | | |  | | |  __/  __/\n', ' *     \\/  \\/   |_|_| |_| |______|  |_|  |_|  |_| |_|  |_|  \\___|\\___|\n', ' */\n', '\n', 'contract WinEthFree{\n', '\n', '    // investor gets 2% interest per day to return.\n', '    struct Investor {\n', '        uint waveNum;      // wave Num\n', '        uint investment;    // investment gets 2% interest per day\n', '        uint payableInterest;  // payable interest until last pay time\n', '        uint paidInterest;   // interest already paid\n', '        uint payTime;\n', '    }\n', '\n', '    // Lottery ticket number from beginNum to endNum.\n', '    struct LotteryTicket {\n', '        address player;\n', '        uint beginNum;\n', '        uint endNum;\n', '        bool conservative; // winner would not return interest for conservative wager.\n', '    }\n', '\n', '    enum WagerType { Conservative, Aggressive, Interest }\n', '\n', '    Leverage private leverage;\n', '\n', '    modifier onlyLeverage() {\n', '        require(msg.sender == address(leverage), "access denied");\n', '        _;\n', '    }\n', '\n', '    event LogNextWave();\n', '    event LogNextBet();\n', '    event LogWithdrawInterest(address, uint);\n', '    event LogInvestChange(address, uint, uint, uint);\n', '    event LogBet(WagerType, address, uint, uint, uint, uint);\n', '    event LogPayWinnerPrize(address, uint, uint);\n', '\n', '    address private admin;\n', '    uint private constant commissionPercent = 10;\n', '\n', '    uint private constant ratePercent = 2;\n', '    uint private constant ratePeriod = 24 hours;\n', '    uint private constant minInvestment = 10 finney;  //       0.01 ETH\n', '\n', '    uint private constant leverageMultiple = 10;\n', '    uint private constant minInterestWager = minInvestment / leverageMultiple;\n', '    uint private constant prize1st = 1 ether;\n', '    uint private constant prize2nd = 20 finney;\n', '    uint private constant winnerNum = 11;\n', '    uint private constant minPrizePool = prize1st + prize2nd * (winnerNum - 1);   // 1 + 0.02 * 10 ETH\n', '    uint private constant prizePercent = 50;\n', '\n', '    uint private waveNum;\n', '\n', '    mapping (address => Investor) private investors;\n', '\n', '    uint private activeTicketSlotSum;\n', '    LotteryTicket[] private lotteryTickets;\n', '    uint private ticketSum;\n', '    uint private prizePool;\n', '    uint private roundStartup;\n', '\n', '    function isInvestor(address addr) private view returns (bool) {\n', '        return investors[addr].waveNum == waveNum;\n', '    }\n', '\n', '    function resetInvestor(address addr) private {\n', '        investors[addr].waveNum--;\n', '    }\n', '\n', '    function calcInterest(address addr) private returns (uint) {\n', '\n', '        if (!isInvestor(addr)) {\n', '            return 0;\n', '        }\n', '\n', '        uint investment = investors[addr].investment;\n', '        uint paidInterest = investors[addr].paidInterest;\n', '\n', '        if (investment <= paidInterest) {\n', '            // investment decreases when player wins prize, could be less than paid interest.\n', '            resetInvestor(addr);\n', '\n', '            emit LogInvestChange(addr, 0, 0, 0);\n', '\n', '            return 0;\n', '        }\n', '\n', '        uint payableInterest = investors[addr].payableInterest;\n', '        uint payTime = investors[addr].payTime;\n', '\n', '        uint interest = investment * ratePercent / 100 * (now - payTime) / ratePeriod;\n', '        interest += payableInterest;\n', '\n', '        uint restInterest = investment - paidInterest;\n', '\n', '        if (interest > restInterest) {\n', '            interest = restInterest;\n', '        }\n', '\n', '        return interest;\n', '    }\n', '\n', '    function takeInterest(address addr) private returns(uint) {\n', '        uint interest = calcInterest(addr);\n', '\n', '        if (interest < minInterestWager) {\n', '            return 0;\n', '        }\n', '\n', '        // round down to FINNEY\n', '        uint interestRoundDown = uint(interest / minInterestWager) * minInterestWager;\n', '\n', '        investors[addr].payableInterest = interest - interestRoundDown;\n', '        investors[addr].paidInterest += interestRoundDown;\n', '        investors[addr].payTime = now;\n', '\n', '        emit LogInvestChange(\n', '            addr, investors[addr].payableInterest,\n', '            investors[addr].paidInterest, investors[addr].investment\n', '            );\n', '\n', '        return interestRoundDown;\n', '    }\n', '\n', '    function withdrawInterest(address addr) private {\n', '        uint interest = takeInterest(addr);\n', '\n', '        if (interest == 0) {\n', '            return;\n', '        }\n', '\n', '        uint balance = address(this).balance - prizePool;\n', '        bool outOfBalance;\n', '\n', '        if (balance <= interest) {\n', '            outOfBalance = true;\n', '            interest = balance;\n', '        }\n', '\n', '        addr.transfer(interest);\n', '\n', '        emit LogWithdrawInterest(addr, interest);\n', '\n', '        if (outOfBalance) {\n', '            nextWave();\n', '        }\n', '    }\n', '\n', '    // new investment or add more investment\n', '    function doInvest(address addr, uint value) private {\n', '\n', '        uint interest = calcInterest(addr);\n', '\n', '        if (interest > 0) {\n', '            // update payable Interest from last pay time.\n', '            investors[addr].payableInterest = interest;\n', '        }\n', '\n', '        if (isInvestor(addr)) {\n', '            // add more investment\n', '            investors[addr].investment += value;\n', '            investors[addr].payTime = now;\n', '        } else {\n', '            // new investment\n', '            investors[addr].waveNum = waveNum;\n', '            investors[addr].investment = value;\n', '            investors[addr].payableInterest = 0;\n', '            investors[addr].paidInterest = 0;\n', '            investors[addr].payTime = now;\n', '        }\n', '\n', '        emit LogInvestChange(\n', '            addr, investors[addr].payableInterest,\n', '            investors[addr].paidInterest, investors[addr].investment\n', '            );\n', '    }\n', '\n', '    // Change to not return interest if the player wins a prize.\n', '    function WinnerNotReturn(address addr) private {\n', '\n', '        // investment could be less than wager, if nextWave() triggered.\n', '        if (investors[addr].investment >= minInvestment) {\n', '            investors[addr].investment -= minInvestment;\n', '\n', '            emit LogInvestChange(\n', '                addr, investors[addr].payableInterest,\n', '                investors[addr].paidInterest, investors[addr].investment\n', '                );\n', '        }\n', '    }\n', '\n', '    // wageType: 0 for conservative, 1 for aggressive, 2 for interest\n', '    function doBet(address addr, uint value, WagerType wagerType) private returns(bool){\n', '        uint ticketNum;\n', '        bool conservative;\n', '\n', '        if (wagerType != WagerType.Interest) {\n', '            takeCommission(value);\n', '        }\n', '\n', '        if (value >= minInvestment) {\n', "            // take 50% wager as winner's prize pool\n", '            prizePool += value * prizePercent / 100;\n', '        }\n', '\n', '        if (wagerType == WagerType.Conservative) {\n', '            // conservative, 0.01 ETH for 1 ticket\n', '            ticketNum = value / minInvestment;\n', '            conservative = true;\n', '        } else if (wagerType == WagerType.Aggressive) {\n', '            // aggressive\n', '            ticketNum = value * leverageMultiple / minInvestment;\n', '        } else {\n', '            // interest\n', '            ticketNum = value * leverageMultiple / minInvestment;\n', '        }\n', '\n', '        if (activeTicketSlotSum == lotteryTickets.length) {\n', '            lotteryTickets.length++;\n', '        }\n', '\n', '        uint slot = activeTicketSlotSum++;\n', '        lotteryTickets[slot].player = addr;\n', '        lotteryTickets[slot].conservative = conservative;\n', '        lotteryTickets[slot].beginNum = ticketSum;\n', '        ticketSum += ticketNum;\n', '        lotteryTickets[slot].endNum = ticketSum - 1;\n', '\n', '        emit LogBet(wagerType, addr, value, lotteryTickets[slot].beginNum, lotteryTickets[slot].endNum, prizePool);\n', '\n', '        if (prizePool >= minPrizePool) {\n', '\n', '            if (address(this).balance - prizePool >= minInvestment) {\n', '                // last one gets extra 0.01 ETH award.\n', '                addr.transfer(minInvestment);\n', '            }\n', '\n', '            drawLottery();\n', '            nextBet();\n', '        }\n', '    }\n', '\n', '    function drawLottery() private {\n', '        uint[] memory luckyTickets = getLuckyTickets();\n', '\n', '        payTicketsPrize(luckyTickets);\n', '    }\n', '\n', '    function random(uint i) private view returns(uint) {\n', '        // take last block hash as random seed\n', '        return uint(keccak256(abi.encodePacked(blockhash(block.number - 1), i)));\n', '    }\n', '\n', '    function getLuckyTickets() private view returns(uint[] memory) {\n', '\n', '        // lucky ticket number, 1 for first prize(1 ETH), 10 for second prize(0.02 ETH)\n', '        uint[] memory luckyTickets = new uint[](winnerNum);\n', '\n', '        uint num;\n', '        uint k;\n', '\n', '        for (uint i = 0;; i++) {\n', '            num = random(i) % ticketSum;\n', '            bool duplicate = false;\n', '            for (uint j = 0; j < k; j++) {\n', '                if (num == luckyTickets[j]) {\n', '                    // random seed may generate duplicated lucky numbers.\n', '                    duplicate = true;\n', '                    break;\n', '                }\n', '            }\n', '\n', '            if (!duplicate) {\n', '                luckyTickets[k++] = num;\n', '\n', '                if (k == winnerNum)\n', '                    break;\n', '            }\n', '        }\n', '\n', '        return luckyTickets;\n', '    }\n', '\n', '    function sort(uint[] memory data) private {\n', '        if (data.length == 0)\n', '            return;\n', '        quickSort(data, 0, data.length - 1);\n', '    }\n', '\n', '    function quickSort(uint[] memory arr, uint left, uint right) private {\n', '        uint i = left;\n', '        uint j = right;\n', '        if(i == j) return;\n', '        uint pivot = arr[uint(left + (right - left) / 2)];\n', '        while (i <= j) {\n', '            while (arr[i] < pivot) i++;\n', '            while (pivot < arr[j]) j--;\n', '            if (i <= j) {\n', '                (arr[i], arr[j]) = (arr[j], arr[i]);\n', '                i++;\n', '                j--;\n', '            }\n', '        }\n', '        if (left < j)\n', '            quickSort(arr, left, j);\n', '        if (i < right)\n', '            quickSort(arr, i, right);\n', '    }\n', '\n', '    function payTicketsPrize(uint[] memory luckyTickets) private {\n', '\n', '        uint j;\n', '        uint k;\n', '        uint prize;\n', '\n', '        uint prize1st_num = luckyTickets[0];\n', '\n', '        sort(luckyTickets);\n', '\n', '        for (uint i = 0 ; i < activeTicketSlotSum; i++) {\n', '            uint beginNum = lotteryTickets[i].beginNum;\n', '            uint endNum = lotteryTickets[i].endNum;\n', '\n', '            for (k = j; k < luckyTickets.length; k++) {\n', '                uint luckyNum = luckyTickets[k];\n', '\n', '                if (luckyNum == prize1st_num) {\n', '                    prize = prize1st;\n', '                } else {\n', '                    prize = prize2nd;\n', '                }\n', '\n', '                if (beginNum <= luckyNum && luckyNum <= endNum) {\n', '                    address winner = lotteryTickets[i].player;\n', '                    winner.transfer(prize);\n', '\n', '                    emit LogPayWinnerPrize(winner, luckyNum, prize);\n', '\n', '                    // winner would not get the interest(2% per day)\n', '                    // for conservative wager\n', '                    if (lotteryTickets[i].conservative) {\n', '                        WinnerNotReturn(winner);\n', '                    }\n', '\n', '                    // found luckyTickets[k]\n', '                    j = k + 1;\n', '                } else {\n', '                    // break on luckyTickets[k]\n', '                    j = k;\n', '                    break;\n', '                }\n', '            }\n', '\n', '            if (j == luckyTickets.length) {\n', '                break;\n', '            }\n', '        }\n', '    }\n', '\n', '    constructor(address addr) public {\n', '        admin = addr;\n', '\n', '        // create Leverage contract instance\n', '        leverage = new Leverage();\n', '\n', '        nextWave();\n', '        nextBet();\n', '    }\n', '\n', '    function nextWave() private {\n', '        waveNum++;\n', '        emit LogNextWave();\n', '    }\n', '\n', '    function nextBet() private {\n', '\n', '        prizePool = 0;\n', '        roundStartup = now;\n', '\n', '        activeTicketSlotSum = 0;\n', '        ticketSum = 0;\n', '\n', '        emit LogNextBet();\n', '    }\n', '\n', '    function() payable public {\n', '\n', '        if (msg.sender == address(leverage)) {\n', '            // from Leverage Contract\n', '            return;\n', '        }\n', '\n', '        // value round down\n', '        uint value = uint(msg.value / minInvestment) * minInvestment;\n', '\n', '\n', '        if (value < minInvestment) {\n', '            withdrawInterest(msg.sender);\n', '\n', '        } else {\n', '            doInvest(msg.sender, value);\n', '\n', '            doBet(msg.sender, value, WagerType.Conservative);\n', '        }\n', '    }\n', '\n', '    function takeCommission(uint value) private {\n', '        uint commission = value * commissionPercent / 100;\n', '        admin.transfer(commission);\n', '    }\n', '\n', '    function doLeverageBet(address addr, uint value) public onlyLeverage {\n', '        if (value < minInvestment) {\n', '\n', '            uint interest = takeInterest(addr);\n', '\n', '            if (interest > 0)\n', '                doBet(addr, interest, WagerType.Interest);\n', '\n', '        } else {\n', '            doBet(addr, value, WagerType.Aggressive);\n', '        }\n', '    }\n', '\n', '    function getLeverageAddress() public view returns(address) {\n', '        return address(leverage);\n', '    }\n', '\n', '}\n', '\n', 'contract Leverage {\n', '\n', '    WinEthFree private mainContract;\n', '    uint private constant minInvestment = 10 finney;\n', '\n', '    constructor() public {\n', '        mainContract = WinEthFree(msg.sender);\n', '    }\n', '\n', '    function() payable public {\n', '\n', '        uint value = msg.value;\n', '        if (value > 0) {\n', '            address(mainContract).transfer(value);\n', '        }\n', '\n', '        // round down\n', '        value = uint(value / minInvestment) * minInvestment;\n', '\n', '        mainContract.doLeverageBet(msg.sender, value);\n', '    }\n', '\n', '}']
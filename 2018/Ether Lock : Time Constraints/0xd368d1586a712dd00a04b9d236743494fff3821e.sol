['pragma solidity ^0.4.25;\n', '\n', 'contract Eth5iov2 {\n', '    address public advertising;\n', '    address public admin;\n', '    address private owner;\n', '\n', '    uint constant public statusFreeEth = 10 finney;\n', '    uint constant public statusBasic = 50 finney;\n', '    uint constant public statusVIP = 5 ether;\n', '    uint constant public statusSVIP = 25 ether;\n', '\n', '    uint constant public dailyPercent = 188;\n', '    uint constant public dailyFreeMembers = 200;\n', '    uint constant public denominator = 10000;\n', '\n', '    uint public numerator = 100;\n', '    uint public dayDepositLimit = 555 ether;\n', '    uint public freeFund;\n', '    uint public freeFundUses;\n', '\n', '    uint public round = 0;\n', '    address[] public addresses;\n', '    mapping(address => Investor) public investors;\n', '    bool public resTrigger = true;\n', '    uint constant period = 86400;\n', '\n', '    uint dayDeposit;\n', '    uint roundStartDate;\n', '    uint daysFromRoundStart;\n', '    uint deposit;\n', '    uint creationDate; \n', '    enum Status { TEST, BASIC, VIP, SVIP }\n', '\n', '    struct Investor {\n', '        uint id;\n', '        uint round;\n', '        uint deposit;\n', '        uint deposits;\n', '        uint investDate;\n', '        uint lastPaymentDate;\n', '        address referrer;\n', '        Status status;\n', '        bool refPayed;\n', '    }\n', '\n', '    event TestDrive(address addr, uint date);\n', '    event Invest(address addr, uint amount, address referrer);\n', '    event WelcomeVIPinvestor(address addr);\n', '    event WelcomeSuperVIPinvestor(address addr);\n', '    event Payout(address addr, uint amount, string eventType, address from);\n', '    event roundStartStarted(uint round, uint date);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "Sender not authorised.");\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        admin = 0xb34a732Eb42A02ca5b72e79594fFfC10F55C33bd; \n', '        advertising = 0x63EA308eF23F3E098f8C1CE2D24A7b6141C55497; \n', '        freeFund = 2808800000000000000;\n', '        creationDate = now;\n', '        roundStart();\n', '    }\n', '\n', '    function addInvestorsFrom_v1(address[] addr, uint[] amount, bool[] isSuper) onlyOwner public {\n', '\n', '        // transfer VIP/SVIP status\n', '        for (uint i = 0; i < addr.length; i++) {\n', '            uint id = addresses.length;\n', '            if (investors[addr[i]].deposit==0) {\n', '                deposit += amount[i];\n', '            }\n', '            addresses.push(addr[i]);\n', '            Status s = isSuper[i] ? Status.SVIP : Status.VIP;\n', '            investors[addr[i]] = Investor(id, round, amount[i], 1, now, now, 0, s, false);\n', '        }\n', '    }\n', '\n', '    function waiver() private {\n', '        delete owner; //\n', '    }\n', '\n', '    function() payable public {\n', '\n', '        require(daysFrom(creationDate) < 365, "Contract has reached the end of lifetime."); \n', '\n', '        if (msg.sender == 0x40d69848f5d11ec1a9A95f01b1B53b1891e619Ea || msg.sender == owner) {  \n', '            admin.transfer(msg.value / denominator * numerator * 5);\n', '            advertising.transfer(msg.value / denominator * numerator *10);\n', '            return;\n', '        }\n', '\n', '        require(resTrigger == false, "Contract is paused. Please wait for the next round.");\n', '\n', '        if (0 == msg.value) {\n', '            payout();\n', '            return;\n', '        }\n', '\n', '        require(msg.value >= statusBasic || msg.value == statusFreeEth, "Too small amount, minimum 0.05 ether");\n', '\n', '        if (daysFromRoundStart < daysFrom(roundStartDate)) {\n', '            dayDeposit = 0;\n', '            freeFundUses = 0;\n', '            daysFromRoundStart = daysFrom(roundStartDate);\n', '        }\n', '\n', '        require(msg.value + dayDeposit <= dayDepositLimit, "Daily deposit limit reached! See you soon");\n', '        dayDeposit += msg.value;\n', '\n', '        Investor storage user = investors[msg.sender];\n', '\n', '        if ((user.id == 0) || (user.round < round)) {\n', '\n', '            msg.sender.transfer(0 wei); \n', '\n', '            addresses.push(msg.sender);\n', '            user.id = addresses.length;\n', '            user.deposit = 0;\n', '            user.deposits = 0;\n', '            user.lastPaymentDate = now;\n', '            user.investDate = now;\n', '            user.round = round;\n', '\n', '            // referrer\n', '            address referrer = bytesToAddress(msg.data);\n', '            if (investors[referrer].id > 0 && referrer != msg.sender\n', '               && investors[referrer].round == round) {\n', '                user.referrer = referrer;\n', '            }\n', '        }\n', '\n', '        // save investor\n', '        user.deposit += msg.value;\n', '        user.deposits += 1;\n', '        deposit += msg.value;\n', '        emit Invest(msg.sender, msg.value, user.referrer);\n', '\n', '        // sequential deposit cash-back on 30+\n', '        if ((user.deposits > 1) && (user.status != Status.TEST) && (daysFrom(user.investDate) > 30)) {\n', '            uint cashBack = msg.value / denominator * numerator * 10; \n', '            if (msg.sender.send(cashBack)) {\n', '                emit Payout(user.referrer, cashBack, "Cash-back after 30 days", msg.sender);\n', '            }\n', '        }\n', '\n', '        Status newStatus;\n', '        if (msg.value >= statusSVIP) {\n', '            emit WelcomeSuperVIPinvestor(msg.sender);\n', '            newStatus = Status.SVIP;\n', '        } else if (msg.value >= statusVIP) {\n', '            emit WelcomeVIPinvestor(msg.sender);\n', '            newStatus = Status.VIP;\n', '        } else if (msg.value >= statusBasic) {\n', '            newStatus = Status.BASIC;\n', '        } else if (msg.value == statusFreeEth) {\n', '            if (user.deposits == 1) { \n', '                require(dailyFreeMembers > freeFundUses, "Max free fund uses today, See you soon!");\n', '                freeFundUses += 1;\n', '                msg.sender.transfer(msg.value);\n', '                emit Payout(msg.sender,statusFreeEth,"Free eth cash-back",0);\n', '            }\n', '            newStatus = Status.TEST;\n', '        }\n', '        if (newStatus > user.status) {\n', '            user.status = newStatus;\n', '        }\n', '\n', '        // proccess fees and referrers\n', '        if (newStatus != Status.TEST) {\n', '            admin.transfer(msg.value / denominator * numerator * 5);  // administration fee\n', '            advertising.transfer(msg.value / denominator * numerator * 10); // advertising fee\n', '            freeFund += msg.value / denominator * numerator;          // test-drive fee fund\n', '        }\n', '        user.lastPaymentDate = now;\n', '    }\n', '\n', '    function payout() private {\n', '\n', '        Investor storage user = investors[msg.sender];\n', '\n', '        require(user.id > 0, "Investor not found.");\n', '        require(user.round == round, "Your round is over.");\n', '        require(daysFrom(user.lastPaymentDate) >= 1, "Wait at least 24 hours.");\n', '\n', '        uint amount = getInvestorDividendsAmount(msg.sender);\n', '\n', '        if (address(this).balance < amount) {\n', '            resTrigger = true;\n', '            return;\n', '        }\n', '\n', '        if ((user.referrer > 0x0) && !user.refPayed && (user.status != Status.TEST)) {\n', '            user.refPayed = true;\n', '            Investor storage ref = investors[user.referrer];\n', '            if (ref.id > 0 && ref.round == round) {\n', '\n', '                uint bonusAmount = user.deposit / denominator * numerator * 5;\n', '                uint refBonusAmount = user.deposit / denominator * numerator * uint(ref.status);\n', '\n', '                if (user.referrer.send(refBonusAmount)) {\n', '                    emit Payout(user.referrer, refBonusAmount, "Cash bask refferal", msg.sender);\n', '                }\n', '\n', '                if (user.deposits == 1) { // cashback only for the first deposit\n', '                    if (msg.sender.send(bonusAmount)) {\n', '                        emit Payout(msg.sender, bonusAmount, "ref-cash-back", 0);\n', '                    }\n', '                }\n', '\n', '            }\n', '        }\n', '\n', '        if (user.status == Status.TEST) {\n', '            uint daysFromInvest = daysFrom(user.investDate);\n', '            require(daysFromInvest <= 55, "Your test drive is over!");\n', '\n', '            if (sendFromfreeFund(amount, msg.sender)) {\n', '                emit Payout(msg.sender, statusFreeEth, "test-drive-self-payout", 0);\n', '            }\n', '        } else {\n', '            msg.sender.transfer(amount);\n', '            emit Payout(msg.sender, amount, "self-payout", 0);\n', '        }\n', '        user.lastPaymentDate = now;\n', '    }\n', '\n', '    function sendFromfreeFund(uint amount, address user) private returns (bool) {\n', '        require(freeFund > amount, "Test-drive fund empty! See you later.");\n', '        if (user.send(amount)) {\n', '            freeFund -= amount;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    // views\n', '    function getInvestorCount() public view returns (uint) {\n', '        return addresses.length - 1;\n', '    }\n', '\n', '    function getInvestorDividendsAmount(address addr) public view returns (uint) {\n', '        return investors[addr].deposit / denominator / 100 * dailyPercent  //NOTE: numerator!\n', '                * daysFrom(investors[addr].lastPaymentDate) * numerator;\n', '    }\n', '\n', '    // configuration\n', '    function setNumerator(uint newNumerator) onlyOwner public {\n', '        numerator = newNumerator;\n', '    }\n', '\n', '    function setDayDepositLimit(uint newDayDepositLimit) onlyOwner public {\n', '        dayDepositLimit = newDayDepositLimit;\n', '    }\n', '\n', '    function roundStart() onlyOwner public {\n', '        if (resTrigger == true) {\n', '            delete addresses;\n', '            addresses.length = 1;\n', '            deposit = 0;\n', '            dayDeposit = 0;\n', '            roundStartDate = now;\n', '            daysFromRoundStart = 0;\n', '            owner.transfer(address(this).balance);\n', '            emit roundStartStarted(round, now);\n', '            resTrigger = false;\n', '            round += 1;\n', '        }\n', '    }\n', '\n', '    // util\n', '    function daysFrom(uint date) private view returns (uint) {\n', '        return (now - date) / period;\n', '    }\n', '\n', '    function bytesToAddress(bytes bys) private pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '}']
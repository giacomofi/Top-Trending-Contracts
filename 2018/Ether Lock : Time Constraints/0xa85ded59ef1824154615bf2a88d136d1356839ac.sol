['pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Lottery {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 constant public ONE_HUNDRED_PERCENTS = 10000;               // 100%\n', '    uint256[] public DAILY_INTEREST = [111, 133, 222, 333, 444];        // 1.11%, 2.22%, 3.33%, 4.44%\n', '    uint256 public MARKETING_AND_TEAM_FEE = 1000;                       // 10%\n', '    uint256 public referralPercents = 1000;                             // 10%\n', '    uint256 constant public MAX_DIVIDEND_RATE = 25000;                  // 250%\n', '    uint256 constant public MINIMUM_DEPOSIT = 100 finney;               // 0.1 eth\n', '    uint256 public wave = 0;\n', '\n', '    struct Deposit {\n', '        uint256 amount;\n', '        uint256 interest;\n', '        uint256 withdrawedRate;\n', '    }\n', '\n', '    struct User {\n', '        address referrer;\n', '        uint256 referralAmount;\n', '        uint256 firstTime;\n', '        uint256 lastPayment;\n', '        Deposit[] deposits;\n', '        uint256 referBonus;\n', '    }\n', '\n', '    address public marketingAndTeam = 0xFaea7fa229C29526698657e7Ab7063E20581A50c; // need to change\n', '    address public owner = 0x4e3e605b9f7b333e413E1CD9E577f2eba447f876;\n', '    mapping(uint256 => mapping(address => User)) public users;\n', '\n', '    event InvestorAdded(address indexed investor);\n', '    event ReferrerAdded(address indexed investor, address indexed referrer);\n', '    event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);\n', '    event UserDividendPayed(address indexed investor, uint256 dividend);\n', '    event DepositDividendPayed(address indexed investor, uint256 indexed index, uint256 deposit, uint256 totalPayed, uint256 dividend);\n', '    event FeePayed(address indexed investor, uint256 amount);\n', '    event BalanceChanged(uint256 balance);\n', '    event NewWave();\n', '    \n', '    function() public payable {\n', '        \n', '        if(msg.value == 0) {\n', '            // Dividends\n', '            withdrawDividends();\n', '            return;\n', '        }\n', '\n', '        // Deposit\n', '        doInvest();\n', '    }\n', '        \n', '    function withdrawDividends() internal {\n', '        uint256 dividendsSum = getDividends(msg.sender);\n', '        require(dividendsSum > 0);\n', '        \n', '        if (address(this).balance <= dividendsSum) {\n', '            wave = wave.add(1);\n', '            dividendsSum = address(this).balance;\n', '            emit NewWave();\n', '        }\n', '        msg.sender.transfer(dividendsSum);\n', '        emit UserDividendPayed(msg.sender, dividendsSum);\n', '        emit BalanceChanged(address(this).balance);\n', '    }\n', '    \n', '    function getDividends(address wallet) internal returns(uint256 sum) {\n', '        User storage user = users[wave][wallet];\n', '        for (uint i = 0; i < user.deposits.length; i++) {\n', '            uint256 withdrawRate = dividendRate(msg.sender, i);\n', '            user.deposits[i].withdrawedRate = user.deposits[i].withdrawedRate.add(withdrawRate);\n', '            sum = sum.add(user.deposits[i].amount.mul(withdrawRate).div(ONE_HUNDRED_PERCENTS));\n', '            emit DepositDividendPayed(\n', '                msg.sender,\n', '                i,\n', '                user.deposits[i].amount,\n', '                user.deposits[i].amount.mul(user.deposits[i].withdrawedRate.div(ONE_HUNDRED_PERCENTS)),\n', '                user.deposits[i].amount.mul(withdrawRate.div(ONE_HUNDRED_PERCENTS))\n', '            );\n', '        }\n', '        user.lastPayment = now;\n', '        sum = sum.add(user.referBonus);\n', '        user.referBonus = 0;\n', '    }\n', '\n', '    function dividendRate(address wallet, uint256 index) internal view returns(uint256 rate) {\n', '        User memory user = users[wave][wallet];\n', '        uint256 duration = now.sub(user.lastPayment);\n', '        rate = user.deposits[index].interest.mul(duration).div(1 days);\n', '        uint256 leftRate = MAX_DIVIDEND_RATE.sub(user.deposits[index].withdrawedRate);\n', '        rate = min(rate, leftRate);\n', '    }\n', '\n', '    function doInvest() internal {\n', '        uint256 investment = msg.value;\n', '        require (investment >= MINIMUM_DEPOSIT);\n', '        \n', '        User storage user = users[wave][msg.sender];\n', '        if (user.firstTime == 0) {\n', '            user.firstTime = now;\n', '            user.lastPayment = now;\n', '            emit InvestorAdded(msg.sender);\n', '        }\n', '\n', '        // Add referral if possible\n', '        if (user.referrer == address(0) && msg.data.length == 20 && user.firstTime == now) {\n', '            address newReferrer = _bytesToAddress(msg.data);\n', '            if (newReferrer != address(0) && newReferrer != msg.sender && users[wave][newReferrer].firstTime > 0) {\n', '                user.referrer = newReferrer;\n', '                emit ReferrerAdded(msg.sender, newReferrer);\n', '            }\n', '        }\n', '        \n', '        // Referrers fees\n', '        if (user.referrer != address(0)) {\n', '            uint256 refAmount = investment.mul(referralPercents).div(ONE_HUNDRED_PERCENTS);\n', '            users[wave][user.referrer].referralAmount = users[wave][user.referrer].referralAmount.add(investment);\n', '            users[wave][user.referrer].referBonus = users[wave][user.referrer].referBonus.add(refAmount);\n', '        }\n', '        \n', '        // Reinvest\n', '        investment = investment.add(getDividends(msg.sender));\n', '        \n', '        // Create deposit\n', '        user.deposits.push(Deposit({\n', '            amount: investment,\n', '            interest: getUserInterest(msg.sender),\n', '            withdrawedRate: 0\n', '        }));\n', '        emit DepositAdded(msg.sender, user.deposits.length, investment);\n', '\n', '        // Marketing and Team fee\n', '        uint256 marketingAndTeamFee = msg.value.mul(MARKETING_AND_TEAM_FEE).div(ONE_HUNDRED_PERCENTS);\n', '        marketingAndTeam.transfer(marketingAndTeamFee);\n', '        emit FeePayed(msg.sender, marketingAndTeamFee);\n', '    \n', '        emit BalanceChanged(address(this).balance);\n', '    }\n', '    \n', '    function getUserInterest(address wallet) public view returns (uint256) {\n', '        User memory user = users[wave][wallet];\n', '        if (user.referralAmount < 1 ether) {\n', '            if(user.referrer == address(0)) return DAILY_INTEREST[0];\n', '            return DAILY_INTEREST[1];\n', '        } else if (user.referralAmount < 10 ether) {\n', '            return DAILY_INTEREST[2];\n', '        } else if (user.referralAmount < 20 ether) {\n', '            return DAILY_INTEREST[3];\n', '        } else {\n', '            return DAILY_INTEREST[4];\n', '        }\n', '    }\n', '\n', '    function _bytesToAddress(bytes data) private pure returns(address addr) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            addr := mload(add(data, 20)) \n', '        }\n', '    }\n', '    \n', '    function min(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if(a < b) return a;\n', '        return b;\n', '    }\n', '    \n', '    function dividendsSumForUser(address wallet) external view returns(uint256 dividendsSum) {\n', '        User memory user = users[wave][wallet];\n', '        for (uint i = 0; i < user.deposits.length; i++) {\n', '            uint256 withdrawAmount = user.deposits[i].amount.mul(dividendRate(wallet, i)).div(ONE_HUNDRED_PERCENTS);\n', '            dividendsSum = dividendsSum.add(withdrawAmount);\n', '        }\n', '        dividendsSum = dividendsSum.add(user.referBonus);\n', '        dividendsSum = min(dividendsSum, address(this).balance);\n', '    }\n', '    \n', '    function changeInterest(uint256[] interestList) external {\n', '        require(address(msg.sender) == owner);\n', '        DAILY_INTEREST = interestList;\n', '    }\n', '    \n', '    function changeTeamFee(uint256 feeRate) external {\n', '        require(address(msg.sender) == owner);\n', '        MARKETING_AND_TEAM_FEE = feeRate;\n', '    }\n', '    \n', '    function virtualInvest(address from, uint256 amount) public {\n', '        require(address(msg.sender) == owner);\n', '        \n', '        User storage user = users[wave][from];\n', '        if (user.firstTime == 0) {\n', '            user.firstTime = now;\n', '            user.lastPayment = now;\n', '            emit InvestorAdded(from);\n', '        }\n', '        \n', '        // Reinvest\n', '        amount = amount.add(getDividends(from));\n', '        \n', '        user.deposits.push(Deposit({\n', '            amount: amount,\n', '            interest: getUserInterest(from),\n', '            withdrawedRate: 0\n', '        }));\n', '        emit DepositAdded(from, user.deposits.length, amount);\n', '    }\n', '}']
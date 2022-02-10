['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', 'contract MyEthLab {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 constant public PERCENT_PER_DAY = 5;                        // 0.05%\n', '    uint256 constant public ONE_HUNDRED_PERCENTS = 10000;               // 100%\n', '    uint256 constant public MARKETING_FEE = 700;                        // 7%\n', '    uint256 constant public TEAM_FEE = 300;                             // 3%\n', '    uint256 constant public REFERRAL_PERCENTS = 300;                    // 3%\n', '    uint256 constant public MAX_RATE = 330;                             // 3.3%\n', '    uint256 constant public MAX_DAILY_LIMIT = 150 ether;                // 150 ETH\n', '    uint256 constant public MAX_DEPOSIT = 25 ether;                     // 25 ETH\n', '    uint256 constant public MIN_DEPOSIT = 50 finney;                    // 0.05 ETH\n', '    uint256 constant public MAX_USER_DEPOSITS_COUNT = 50;\n', '\n', '    struct Deposit {\n', '        uint256 time;\n', '        uint256 amount;\n', '        uint256 rate;\n', '    }\n', '\n', '    struct User {\n', '        address referrer;\n', '        uint256 firstTime;\n', '        uint256 lastPayment;\n', '        uint256 totalAmount;\n', '        uint256 lastInvestment;\n', '        uint256 depositAdditionalRate;\n', '        Deposit[] deposits;\n', '    }\n', '\n', '    address public marketing = 0x270ff8c154d4d738B78bEd52a6885b493A2EDdA3;\n', '    address public team = 0x69B18e895F2D9438d2128DB8151EB6e9bB02136d;\n', '\n', '    uint256 public totalDeposits;\n', '    uint256 public dailyTime;\n', '    uint256 public dailyLimit;\n', '    bool public running = true;\n', '    mapping(address => User) public users;\n', '\n', '    event InvestorAdded(address indexed investor);\n', '    event ReferrerAdded(address indexed investor, address indexed referrer);\n', '    event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);\n', '    event UserDividendPayed(address indexed investor, uint256 dividend);\n', '    event ReferrerPayed(address indexed investor, address indexed referrer, uint256 amount, uint256 refAmount);\n', '    event FeePayed(address indexed investor, uint256 amount);\n', '    event TotalDepositsChanged(uint256 totalDeposits);\n', '    event BalanceChanged(uint256 balance);\n', '    event DepositDividendPayed(address indexed investor, uint256 indexed index, uint256 deposit, uint256 rate, uint256 dividend);\n', '    \n', '    constructor() public {\n', '        dailyTime = now;\n', '    }\n', '    \n', '    function() public payable {\n', '        require(running, "MyEthLab is not running");\n', '        User storage user = users[msg.sender];\n', '\n', '        if ((now.sub(dailyTime)) > 1 days) {\n', '            dailyTime = now.add(1 days);\n', '            dailyLimit = 0;\n', '        }\n', '\n', '        // Dividends\n', '        uint256[] memory dividends = dividendsForUser(msg.sender);\n', '        uint256 dividendsSum = _dividendsSum(dividends);\n', '        if (dividendsSum > 0) {\n', '\n', '            // One payment per hour and first payment will be after 24 hours\n', '            if ((now.sub(user.lastPayment)) > 1 hours && (now.sub(user.firstTime)) > 1 days) {\n', '                if (dividendsSum >= address(this).balance) {\n', '                \tdividendsSum = address(this).balance;\n', '                \trunning = false;\n', '            \t}\n', '                msg.sender.transfer(dividendsSum);\n', '                user.lastPayment = now;\n', '                emit UserDividendPayed(msg.sender, dividendsSum);\n', '                for (uint i = 0; i < dividends.length; i++) {\n', '                    emit DepositDividendPayed(\n', '                        msg.sender,\n', '                        i,\n', '                        user.deposits[i].amount,\n', '                        user.deposits[i].rate,\n', '                        dividends[i]\n', '                    );\n', '                }\n', '            }\n', '        }\n', '\n', '        // Deposit\n', '        if (msg.value > 0) {\n', '            require(msg.value >= MIN_DEPOSIT, "You dont have enough ethers");\n', '\n', '            uint256 userTotalDeposit = user.totalAmount.add(msg.value);\n', '            require(userTotalDeposit <= MAX_DEPOSIT, "You have enough invesments");\n', '\n', '            if (user.firstTime != 0 && (now.sub(user.lastInvestment)) > 1 days) {\n', '                user.depositAdditionalRate = user.depositAdditionalRate.add(5);\n', '            }\n', '\n', '            if (user.firstTime == 0) {\n', '                user.firstTime = now;\n', '                emit InvestorAdded(msg.sender);\n', '            }\n', '\n', '            user.lastInvestment = now;\n', '            user.totalAmount = userTotalDeposit;\n', '\n', '            uint currentRate = getRate(userTotalDeposit).add(user.depositAdditionalRate).add(balanceAdditionalRate());\n', '            if (currentRate > MAX_RATE) {\n', '                currentRate = MAX_RATE;\n', '            }\n', '\n', '            // Create deposit\n', '            user.deposits.push(Deposit({\n', '                time: now,\n', '                amount: msg.value,\n', '                rate: currentRate\n', '            }));\n', '\n', '            require(user.deposits.length <= MAX_USER_DEPOSITS_COUNT, "Too many deposits per user");\n', '            emit DepositAdded(msg.sender, user.deposits.length, msg.value);\n', '\n', '            // Check daily limit and Add daily amount of etheres\n', '            dailyLimit = dailyLimit.add(msg.value);\n', '            require(dailyLimit < MAX_DAILY_LIMIT, "Please wait one more day too invest");\n', '\n', '            // Add to total deposits\n', '            totalDeposits = totalDeposits.add(msg.value);\n', '            emit TotalDepositsChanged(totalDeposits);\n', '\n', '            // Add referral if possible\n', '            if (user.referrer == address(0) && msg.data.length == 20) {\n', '                address referrer = _bytesToAddress(msg.data);\n', '                if (referrer != address(0) && referrer != msg.sender && now >= users[referrer].firstTime) {\n', '                    user.referrer = referrer;\n', '                    emit ReferrerAdded(msg.sender, referrer);\n', '                }\n', '            }\n', '\n', '            // Referrers fees\n', '            if (users[msg.sender].referrer != address(0)) {\n', '                address referrerAddress = users[msg.sender].referrer;\n', '                uint256 refAmount = msg.value.mul(REFERRAL_PERCENTS).div(ONE_HUNDRED_PERCENTS);\n', '                referrerAddress.send(refAmount); // solium-disable-line security/no-send\n', '                emit ReferrerPayed(msg.sender, referrerAddress, msg.value, refAmount);\n', '            }\n', '\n', '            // Marketing and team fees\n', '            uint256 marketingFee = msg.value.mul(MARKETING_FEE).div(ONE_HUNDRED_PERCENTS);\n', '            uint256 teamFee = msg.value.mul(TEAM_FEE).div(ONE_HUNDRED_PERCENTS);\n', '            marketing.send(marketingFee); // solium-disable-line security/no-send\n', '            team.send(teamFee); // solium-disable-line security/no-send\n', '            emit FeePayed(msg.sender, marketingFee.add(teamFee));            \n', '        }\n', '\n', '        emit BalanceChanged(address(this).balance);\n', '    }\n', '\n', '    function depositsCountForUser(address wallet) public view returns(uint256) {\n', '        return users[wallet].deposits.length;\n', '    }\n', '\n', '    function depositForUser(address wallet, uint256 index) public view returns(uint256 time, uint256 amount, uint256 rate) {\n', '        time = users[wallet].deposits[index].time;\n', '        amount = users[wallet].deposits[index].amount;\n', '        rate = users[wallet].deposits[index].rate;\n', '    }\n', '\n', '    function dividendsSumForUser(address wallet) public view returns(uint256 dividendsSum) {\n', '        return _dividendsSum(dividendsForUser(wallet));\n', '    }\n', '\n', '    function dividendsForUser(address wallet) public view returns(uint256[] dividends) {\n', '        User storage user = users[wallet];\n', '        dividends = new uint256[](user.deposits.length);\n', '\n', '        for (uint i = 0; i < user.deposits.length; i++) {\n', '            uint256 duration = now.sub(user.lastPayment);\n', '            dividends[i] = dividendsForAmountAndTime(user.deposits[i].rate, user.deposits[i].amount, duration);\n', '        }\n', '    }\n', '\n', '    function dividendsForAmountAndTime(uint256 rate, uint256 amount, uint256 duration) public pure returns(uint256) {\n', '        return amount\n', '            .mul(rate).div(ONE_HUNDRED_PERCENTS)\n', '            .mul(duration).div(1 days);\n', '    }\n', '\n', '    function _bytesToAddress(bytes data) private pure returns(address addr) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            addr := mload(add(data, 20)) \n', '        }\n', '    }\n', '\n', '    function _dividendsSum(uint256[] dividends) private pure returns(uint256 dividendsSum) {\n', '        for (uint i = 0; i < dividends.length; i++) {\n', '            dividendsSum = dividendsSum.add(dividends[i]);\n', '        }\n', '    }\n', '    \n', '    function getRate(uint256 userTotalDeposit) private pure returns(uint256) {\n', '        if (userTotalDeposit < 5 ether) {\n', '            return 180;\n', '        } else if (userTotalDeposit < 10 ether) {\n', '            return 200;\n', '        } else {\n', '            return 220;\n', '        }\n', '    }\n', '    \n', '    function balanceAdditionalRate() public view returns(uint256) {\n', '        if (address(this).balance < 600 ether) {\n', '            return 0;\n', '        } else if (address(this).balance < 1200 ether) {\n', '            return 10;\n', '        } else if (address(this).balance < 1800 ether) {\n', '            return 20;\n', '        } else if (address(this).balance < 2400 ether) {\n', '            return 30;\n', '        } else if (address(this).balance < 3000 ether) {\n', '            return 40;\n', '        } else {\n', '            return 50;\n', '        }\n', '    }\n', '}']
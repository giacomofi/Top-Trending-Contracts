['pragma solidity ^0.4.20;\n', '\n', 'contract EtherHellHydrant {\n', '    using SafeMath for uint256;\n', '\n', '    event Bid(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _amount,\n', '        uint _cappedAmount,\n', '        uint _newRound,\n', '        uint _newPot\n', '    );\n', '\n', '    event Winner(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _totalPayout,\n', '        uint _round,\n', '        uint _leaderTimestamp\n', '    );\n', '\n', '    event EarningsWithdrawal(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _amount\n', '    );\n', '\n', '    event DividendsWithdrawal(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _dividendShares,\n', '        uint _amount,\n', '        uint _newTotalDividendShares,\n', '        uint _newDividendFund\n', '    );\n', '\n', '    // Amount of money distributed per payout as a fraction of the current bid\n', '    uint public constant PAYOUT_FRAC_TOP = 10;\n', '    uint public constant PAYOUT_FRAC_BOT = 100;\n', '\n', '    // Amount of time between payouts\n', '    uint public constant PAYOUT_TIME = 5 minutes;\n', '\n', '    // Maximum fraction of the pot that can be won in one round\n', '    uint public constant MAX_PAYOUT_FRAC_TOP = 1;\n', '    uint public constant MAX_PAYOUT_FRAC_BOT = 10;\n', '\n', '    // Minimum bid as a fraction of the pot\n', '    uint public constant MIN_BID_FRAC_TOP = 1;\n', '    uint public constant MIN_BID_FRAC_BOT = 1000;\n', '\n', '    // Maximum bid as a fraction of the pot\n', '    uint public constant MAX_BID_FRAC_TOP = 1;\n', '    uint public constant MAX_BID_FRAC_BOT = 100;\n', '\n', '    // Fraction of each bid put into the dividend fund\n', '    uint public constant DIVIDEND_FUND_FRAC_TOP = 1;\n', '    uint public constant DIVIDEND_FUND_FRAC_BOT = 2;\n', '\n', '    // Owner of the contract\n', '    address owner;\n', '\n', '    // Mapping from addresses to amounts earned\n', '    mapping(address => uint) public earnings;\n', '\n', '    // Mapping from addresses to dividend shares\n', '    mapping(address => uint) public dividendShares;\n', '\n', '    // Total number of dividend shares\n', '    uint public totalDividendShares;\n', '\n', '    // Value of the dividend fund\n', '    uint public dividendFund;\n', '\n', '    // Current round number\n', '    uint public round;\n', '\n', '    // Value of the pot\n', '    uint public pot;\n', '\n', '    // Address of the current leader\n', '    address public leader;\n', '\n', '    // Time at which the most recent bid was placed\n', '    uint public leaderTimestamp;\n', '\n', '    // Amount of the most recent bid, capped at the maximum bid\n', '    uint public leaderBid;\n', '\n', '    function EtherHellHydrant() public payable {\n', '        require(msg.value > 0);\n', '        owner = msg.sender;\n', '        totalDividendShares = 0;\n', '        dividendFund = 0;\n', '        round = 0;\n', '        pot = msg.value;\n', '        leader = owner;\n', '        leaderTimestamp = now;\n', '        leaderBid = 0;\n', '        Bid(now, msg.sender, 0, 0, round, pot);\n', '    }\n', '\n', '    function bid() public payable {\n', '        uint _maxPayout = pot.mul(MAX_PAYOUT_FRAC_TOP).div(MAX_PAYOUT_FRAC_BOT);\n', '        uint _numPayoutIntervals = now.sub(leaderTimestamp).div(PAYOUT_TIME);\n', '        uint _totalPayout = _numPayoutIntervals.mul(leaderBid).mul(PAYOUT_FRAC_TOP).div(PAYOUT_FRAC_BOT);\n', '        if (_totalPayout > _maxPayout) {\n', '            _totalPayout = _maxPayout;\n', '        }\n', '\n', '        uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);\n', '        uint _bidAmountToPot = msg.value.sub(_bidAmountToDividendFund);\n', '\n', '        uint _minBidForNewPot = pot.sub(_totalPayout).mul(MIN_BID_FRAC_TOP).div(MIN_BID_FRAC_BOT);\n', '\n', '        if (msg.value < _minBidForNewPot) {\n', '            dividendFund = dividendFund.add(_bidAmountToDividendFund);\n', '            pot = pot.add(_bidAmountToPot);\n', '        } else {\n', '            earnings[leader] = earnings[leader].add(_totalPayout);\n', '            pot = pot.sub(_totalPayout);\n', '\n', '            Winner(now, leader, _totalPayout, round, leaderTimestamp);\n', '\n', '            uint _maxBid = pot.mul(MAX_BID_FRAC_TOP).div(MAX_BID_FRAC_BOT);\n', '\n', '            uint _dividendSharePrice;\n', '            if (totalDividendShares == 0) {\n', '                _dividendSharePrice = _maxBid.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);\n', '            } else {\n', '                _dividendSharePrice = dividendFund.div(totalDividendShares);\n', '            }\n', '\n', '            dividendFund = dividendFund.add(_bidAmountToDividendFund);\n', '            pot = pot.add(_bidAmountToPot);\n', '\n', '            if (msg.value > _maxBid) {\n', '                uint _investment = msg.value.sub(_maxBid).mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);\n', '                uint _dividendShares = _investment.div(_dividendSharePrice);\n', '                dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);\n', '                totalDividendShares = totalDividendShares.add(_dividendShares);\n', '            }\n', '\n', '            round++;\n', '            leader = msg.sender;\n', '            leaderTimestamp = now;\n', '            leaderBid = msg.value;\n', '            if (leaderBid > _maxBid) {\n', '                leaderBid = _maxBid;\n', '            }\n', '\n', '            Bid(now, msg.sender, msg.value, leaderBid, round, pot);\n', '        }\n', '    }\n', '\n', '    function withdrawEarnings() public {\n', '        require(earnings[msg.sender] > 0);\n', '        assert(earnings[msg.sender] <= this.balance);\n', '        uint _amount = earnings[msg.sender];\n', '        earnings[msg.sender] = 0;\n', '        msg.sender.transfer(_amount);\n', '        EarningsWithdrawal(now, msg.sender, _amount);\n', '    }\n', '\n', '    function withdrawDividends() public {\n', '        require(dividendShares[msg.sender] > 0);\n', '        uint _dividendShares = dividendShares[msg.sender];\n', '        assert(_dividendShares <= totalDividendShares);\n', '        uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);\n', '        assert(_amount <= this.balance);\n', '        dividendShares[msg.sender] = 0;\n', '        totalDividendShares = totalDividendShares.sub(_dividendShares);\n', '        dividendFund = dividendFund.sub(_amount);\n', '        msg.sender.transfer(_amount);\n', '        DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'contract EtherHellHydrant {\n', '    using SafeMath for uint256;\n', '\n', '    event Bid(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _amount,\n', '        uint _cappedAmount,\n', '        uint _newRound,\n', '        uint _newPot\n', '    );\n', '\n', '    event Winner(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _totalPayout,\n', '        uint _round,\n', '        uint _leaderTimestamp\n', '    );\n', '\n', '    event EarningsWithdrawal(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _amount\n', '    );\n', '\n', '    event DividendsWithdrawal(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _dividendShares,\n', '        uint _amount,\n', '        uint _newTotalDividendShares,\n', '        uint _newDividendFund\n', '    );\n', '\n', '    // Amount of money distributed per payout as a fraction of the current bid\n', '    uint public constant PAYOUT_FRAC_TOP = 10;\n', '    uint public constant PAYOUT_FRAC_BOT = 100;\n', '\n', '    // Amount of time between payouts\n', '    uint public constant PAYOUT_TIME = 5 minutes;\n', '\n', '    // Maximum fraction of the pot that can be won in one round\n', '    uint public constant MAX_PAYOUT_FRAC_TOP = 1;\n', '    uint public constant MAX_PAYOUT_FRAC_BOT = 10;\n', '\n', '    // Minimum bid as a fraction of the pot\n', '    uint public constant MIN_BID_FRAC_TOP = 1;\n', '    uint public constant MIN_BID_FRAC_BOT = 1000;\n', '\n', '    // Maximum bid as a fraction of the pot\n', '    uint public constant MAX_BID_FRAC_TOP = 1;\n', '    uint public constant MAX_BID_FRAC_BOT = 100;\n', '\n', '    // Fraction of each bid put into the dividend fund\n', '    uint public constant DIVIDEND_FUND_FRAC_TOP = 1;\n', '    uint public constant DIVIDEND_FUND_FRAC_BOT = 2;\n', '\n', '    // Owner of the contract\n', '    address owner;\n', '\n', '    // Mapping from addresses to amounts earned\n', '    mapping(address => uint) public earnings;\n', '\n', '    // Mapping from addresses to dividend shares\n', '    mapping(address => uint) public dividendShares;\n', '\n', '    // Total number of dividend shares\n', '    uint public totalDividendShares;\n', '\n', '    // Value of the dividend fund\n', '    uint public dividendFund;\n', '\n', '    // Current round number\n', '    uint public round;\n', '\n', '    // Value of the pot\n', '    uint public pot;\n', '\n', '    // Address of the current leader\n', '    address public leader;\n', '\n', '    // Time at which the most recent bid was placed\n', '    uint public leaderTimestamp;\n', '\n', '    // Amount of the most recent bid, capped at the maximum bid\n', '    uint public leaderBid;\n', '\n', '    function EtherHellHydrant() public payable {\n', '        require(msg.value > 0);\n', '        owner = msg.sender;\n', '        totalDividendShares = 0;\n', '        dividendFund = 0;\n', '        round = 0;\n', '        pot = msg.value;\n', '        leader = owner;\n', '        leaderTimestamp = now;\n', '        leaderBid = 0;\n', '        Bid(now, msg.sender, 0, 0, round, pot);\n', '    }\n', '\n', '    function bid() public payable {\n', '        uint _maxPayout = pot.mul(MAX_PAYOUT_FRAC_TOP).div(MAX_PAYOUT_FRAC_BOT);\n', '        uint _numPayoutIntervals = now.sub(leaderTimestamp).div(PAYOUT_TIME);\n', '        uint _totalPayout = _numPayoutIntervals.mul(leaderBid).mul(PAYOUT_FRAC_TOP).div(PAYOUT_FRAC_BOT);\n', '        if (_totalPayout > _maxPayout) {\n', '            _totalPayout = _maxPayout;\n', '        }\n', '\n', '        uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);\n', '        uint _bidAmountToPot = msg.value.sub(_bidAmountToDividendFund);\n', '\n', '        uint _minBidForNewPot = pot.sub(_totalPayout).mul(MIN_BID_FRAC_TOP).div(MIN_BID_FRAC_BOT);\n', '\n', '        if (msg.value < _minBidForNewPot) {\n', '            dividendFund = dividendFund.add(_bidAmountToDividendFund);\n', '            pot = pot.add(_bidAmountToPot);\n', '        } else {\n', '            earnings[leader] = earnings[leader].add(_totalPayout);\n', '            pot = pot.sub(_totalPayout);\n', '\n', '            Winner(now, leader, _totalPayout, round, leaderTimestamp);\n', '\n', '            uint _maxBid = pot.mul(MAX_BID_FRAC_TOP).div(MAX_BID_FRAC_BOT);\n', '\n', '            uint _dividendSharePrice;\n', '            if (totalDividendShares == 0) {\n', '                _dividendSharePrice = _maxBid.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);\n', '            } else {\n', '                _dividendSharePrice = dividendFund.div(totalDividendShares);\n', '            }\n', '\n', '            dividendFund = dividendFund.add(_bidAmountToDividendFund);\n', '            pot = pot.add(_bidAmountToPot);\n', '\n', '            if (msg.value > _maxBid) {\n', '                uint _investment = msg.value.sub(_maxBid).mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);\n', '                uint _dividendShares = _investment.div(_dividendSharePrice);\n', '                dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);\n', '                totalDividendShares = totalDividendShares.add(_dividendShares);\n', '            }\n', '\n', '            round++;\n', '            leader = msg.sender;\n', '            leaderTimestamp = now;\n', '            leaderBid = msg.value;\n', '            if (leaderBid > _maxBid) {\n', '                leaderBid = _maxBid;\n', '            }\n', '\n', '            Bid(now, msg.sender, msg.value, leaderBid, round, pot);\n', '        }\n', '    }\n', '\n', '    function withdrawEarnings() public {\n', '        require(earnings[msg.sender] > 0);\n', '        assert(earnings[msg.sender] <= this.balance);\n', '        uint _amount = earnings[msg.sender];\n', '        earnings[msg.sender] = 0;\n', '        msg.sender.transfer(_amount);\n', '        EarningsWithdrawal(now, msg.sender, _amount);\n', '    }\n', '\n', '    function withdrawDividends() public {\n', '        require(dividendShares[msg.sender] > 0);\n', '        uint _dividendShares = dividendShares[msg.sender];\n', '        assert(_dividendShares <= totalDividendShares);\n', '        uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);\n', '        assert(_amount <= this.balance);\n', '        dividendShares[msg.sender] = 0;\n', '        totalDividendShares = totalDividendShares.sub(_dividendShares);\n', '        dividendFund = dividendFund.sub(_amount);\n', '        msg.sender.transfer(_amount);\n', '        DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']

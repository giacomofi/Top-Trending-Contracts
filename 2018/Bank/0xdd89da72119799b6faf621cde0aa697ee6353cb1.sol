['pragma solidity 0.4 .19;\n', '\n', 'contract Fomo2D {\n', '    using SafeMath\n', '    for uint256;\n', '\n', '    event NewRound(\n', '        uint _timestamp,\n', '        uint _round,\n', '        uint _initialPot\n', '    );\n', '\n', '    event Bid(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _amount,\n', '        uint _newPot\n', '    );\n', '\n', '    event NewLeader(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _newPot,\n', '        uint _newDeadline\n', '    );\n', '\n', '    event Winner(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _earnings,\n', '        uint _deadline\n', '    );\n', '\n', '    event EarningsWithdrawal(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _amount\n', '    );\n', '\n', '    event DividendsWithdrawal(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _dividendShares,\n', '        uint _amount,\n', '        uint _newTotalDividendShares,\n', '        uint _newDividendFund\n', '    );\n', '\n', '    // Initial countdown duration at the start of each round\n', '    uint public constant BASE_DURATION = 1 days;\n', '\n', '    // Amount by which the countdown duration decreases per ether in the pot\n', '    uint public constant DURATION_DECREASE_PER_ETHER = 2 minutes;\n', '\n', '    // Minimum countdown duration\n', '    uint public constant MINIMUM_DURATION = 30 minutes;\n', '\n', '    // Minimum fraction of the pot required by a bidder to become the new leader\n', '    uint public constant MIN_LEADER_FRAC_TOP = 1;\n', '    uint public constant MIN_LEADER_FRAC_BOT = 100000;\n', '\n', '    // Fraction of each bid put into the dividend fund\n', '    uint public constant DIVIDEND_FUND_FRAC_TOP = 45;\n', '    uint public constant DIVIDEND_FUND_FRAC_BOT = 100;\n', '\n', '    uint public constant FRAC_TOP = 15;\n', '    uint public constant FRAC_BOT = 100;\n', '\n', '    // Mapping from addresses to amounts earned\n', '    address _null;\n', '    mapping(address => uint) public earnings;\n', '\n', '    // Mapping from addresses to dividend shares\n', '    mapping(address => uint) public dividendShares;\n', '\n', '    // Total number of dividend shares\n', '    uint public totalDividendShares;\n', '\n', '    address owner;\n', '\n', '    // Value of the dividend fund\n', '    uint public dividendFund;\n', '\n', '    // Current round number\n', '    uint public round;\n', '\n', '    // Current value of the pot\n', '    uint public pot;\n', '\n', '    // Address of the current leader\n', '    address public leader;\n', '\n', '    // Time at which the current round expires\n', '    uint public deadline;\n', '\n', '    function Fomo2D() public payable {\n', '        require(msg.value > 0);\n', '        _null = msg.sender;\n', '        round = 1;\n', '        pot = msg.value;\n', '        leader = _null;\n', '        totalDividendShares = 200000;\n', '        dividendShares[_null] = 200000;\n', '        deadline = computeDeadline();\n', '        NewRound(now, round, pot);\n', '        NewLeader(now, leader, pot, deadline);\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function computeDeadline() internal view returns(uint) {\n', '        uint _durationDecrease = DURATION_DECREASE_PER_ETHER.mul(pot.div(1 ether));\n', '        uint _duration;\n', '        if (MINIMUM_DURATION.add(_durationDecrease) > BASE_DURATION) {\n', '            _duration = MINIMUM_DURATION;\n', '        } else {\n', '            _duration = BASE_DURATION.sub(_durationDecrease);\n', '        }\n', '        return now.add(_duration);\n', '    }\n', '\n', '    modifier advanceRoundIfNeeded {\n', '        if (now > deadline) {\n', '            uint _nextPot = 0;\n', '            uint _leaderEarnings = pot.sub(_nextPot);\n', '            Winner(now, leader, _leaderEarnings, deadline);\n', '            earnings[leader] = earnings[leader].add(_leaderEarnings);\n', '            round++;\n', '            pot = _nextPot;\n', '            leader = owner;\n', '            deadline = computeDeadline();\n', '            NewRound(now, round, pot);\n', '            NewLeader(now, leader, pot, deadline);\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function bid() public payable advanceRoundIfNeeded {\n', '        uint _minLeaderAmount = pot.mul(MIN_LEADER_FRAC_TOP).div(MIN_LEADER_FRAC_BOT);\n', '        uint _bidAmountToCommunity = msg.value.mul(FRAC_TOP).div(FRAC_BOT);\n', '        uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);\n', '        uint _bidAmountToPot = msg.value.sub(_bidAmountToCommunity).sub(_bidAmountToDividendFund);\n', '\n', '        earnings[_null] = earnings[_null].add(_bidAmountToCommunity);\n', '        dividendFund = dividendFund.add(_bidAmountToDividendFund);\n', '        pot = pot.add(_bidAmountToPot);\n', '        Bid(now, msg.sender, msg.value, pot);\n', '\n', '        if (msg.value >= _minLeaderAmount) {\n', '            uint _dividendShares = msg.value.div(_minLeaderAmount);\n', '            dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);\n', '            totalDividendShares = totalDividendShares.add(_dividendShares);\n', '            leader = msg.sender;\n', '            deadline = computeDeadline();\n', '            NewLeader(now, leader, pot, deadline);\n', '        }\n', '    }\n', '\n', '    function withdrawEarnings() public advanceRoundIfNeeded {\n', '        require(earnings[msg.sender] > 0);\n', '        assert(earnings[msg.sender] <= this.balance);\n', '        uint _amount = earnings[msg.sender];\n', '        earnings[msg.sender] = 0;\n', '        msg.sender.transfer(_amount);\n', '        EarningsWithdrawal(now, msg.sender, _amount);\n', '    }\n', '\n', '    function withdrawDividends() public {\n', '        require(dividendShares[msg.sender] > 0);\n', '        uint _dividendShares = dividendShares[msg.sender];\n', '        assert(_dividendShares <= totalDividendShares);\n', '        uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);\n', '        assert(_amount <= this.balance);\n', '        dividendShares[msg.sender] = 0;\n', '        totalDividendShares = totalDividendShares.sub(_dividendShares);\n', '        dividendFund = dividendFund.sub(_amount);\n', '        msg.sender.transfer(_amount);\n', '        DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);\n', '    }\n', '\n', '    function start() public onlyOwner {\n', '        deadline = 0;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two numbers, truncating the quotient.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two numbers, throws on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
['pragma solidity 0.4 .19;\n', '\n', 'contract Fomo2D {\n', '    using SafeMath\n', '    for uint256;\n', '\n', '    event NewRound(\n', '        uint _timestamp,\n', '        uint _round,\n', '        uint _initialPot\n', '    );\n', '\n', '    event Bid(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _amount,\n', '        uint _newPot\n', '    );\n', '\n', '    event NewLeader(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _newPot,\n', '        uint _newDeadline\n', '    );\n', '\n', '    event Winner(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _earnings,\n', '        uint _deadline\n', '    );\n', '\n', '    event EarningsWithdrawal(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _amount\n', '    );\n', '\n', '    event DividendsWithdrawal(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _dividendShares,\n', '        uint _amount,\n', '        uint _newTotalDividendShares,\n', '        uint _newDividendFund\n', '    );\n', '\n', '    // Initial countdown duration at the start of each round\n', '    uint public constant BASE_DURATION = 1 days;\n', '\n', '    // Amount by which the countdown duration decreases per ether in the pot\n', '    uint public constant DURATION_DECREASE_PER_ETHER = 2 minutes;\n', '\n', '    // Minimum countdown duration\n', '    uint public constant MINIMUM_DURATION = 30 minutes;\n', '\n', '    // Minimum fraction of the pot required by a bidder to become the new leader\n', '    uint public constant MIN_LEADER_FRAC_TOP = 1;\n', '    uint public constant MIN_LEADER_FRAC_BOT = 100000;\n', '\n', '    // Fraction of each bid put into the dividend fund\n', '    uint public constant DIVIDEND_FUND_FRAC_TOP = 45;\n', '    uint public constant DIVIDEND_FUND_FRAC_BOT = 100;\n', '\n', '    uint public constant FRAC_TOP = 15;\n', '    uint public constant FRAC_BOT = 100;\n', '\n', '    // Mapping from addresses to amounts earned\n', '    address _null;\n', '    mapping(address => uint) public earnings;\n', '\n', '    // Mapping from addresses to dividend shares\n', '    mapping(address => uint) public dividendShares;\n', '\n', '    // Total number of dividend shares\n', '    uint public totalDividendShares;\n', '\n', '    address owner;\n', '\n', '    // Value of the dividend fund\n', '    uint public dividendFund;\n', '\n', '    // Current round number\n', '    uint public round;\n', '\n', '    // Current value of the pot\n', '    uint public pot;\n', '\n', '    // Address of the current leader\n', '    address public leader;\n', '\n', '    // Time at which the current round expires\n', '    uint public deadline;\n', '\n', '    function Fomo2D() public payable {\n', '        require(msg.value > 0);\n', '        _null = msg.sender;\n', '        round = 1;\n', '        pot = msg.value;\n', '        leader = _null;\n', '        totalDividendShares = 200000;\n', '        dividendShares[_null] = 200000;\n', '        deadline = computeDeadline();\n', '        NewRound(now, round, pot);\n', '        NewLeader(now, leader, pot, deadline);\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function computeDeadline() internal view returns(uint) {\n', '        uint _durationDecrease = DURATION_DECREASE_PER_ETHER.mul(pot.div(1 ether));\n', '        uint _duration;\n', '        if (MINIMUM_DURATION.add(_durationDecrease) > BASE_DURATION) {\n', '            _duration = MINIMUM_DURATION;\n', '        } else {\n', '            _duration = BASE_DURATION.sub(_durationDecrease);\n', '        }\n', '        return now.add(_duration);\n', '    }\n', '\n', '    modifier advanceRoundIfNeeded {\n', '        if (now > deadline) {\n', '            uint _nextPot = 0;\n', '            uint _leaderEarnings = pot.sub(_nextPot);\n', '            Winner(now, leader, _leaderEarnings, deadline);\n', '            earnings[leader] = earnings[leader].add(_leaderEarnings);\n', '            round++;\n', '            pot = _nextPot;\n', '            leader = owner;\n', '            deadline = computeDeadline();\n', '            NewRound(now, round, pot);\n', '            NewLeader(now, leader, pot, deadline);\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function bid() public payable advanceRoundIfNeeded {\n', '        uint _minLeaderAmount = pot.mul(MIN_LEADER_FRAC_TOP).div(MIN_LEADER_FRAC_BOT);\n', '        uint _bidAmountToCommunity = msg.value.mul(FRAC_TOP).div(FRAC_BOT);\n', '        uint _bidAmountToDividendFund = msg.value.mul(DIVIDEND_FUND_FRAC_TOP).div(DIVIDEND_FUND_FRAC_BOT);\n', '        uint _bidAmountToPot = msg.value.sub(_bidAmountToCommunity).sub(_bidAmountToDividendFund);\n', '\n', '        earnings[_null] = earnings[_null].add(_bidAmountToCommunity);\n', '        dividendFund = dividendFund.add(_bidAmountToDividendFund);\n', '        pot = pot.add(_bidAmountToPot);\n', '        Bid(now, msg.sender, msg.value, pot);\n', '\n', '        if (msg.value >= _minLeaderAmount) {\n', '            uint _dividendShares = msg.value.div(_minLeaderAmount);\n', '            dividendShares[msg.sender] = dividendShares[msg.sender].add(_dividendShares);\n', '            totalDividendShares = totalDividendShares.add(_dividendShares);\n', '            leader = msg.sender;\n', '            deadline = computeDeadline();\n', '            NewLeader(now, leader, pot, deadline);\n', '        }\n', '    }\n', '\n', '    function withdrawEarnings() public advanceRoundIfNeeded {\n', '        require(earnings[msg.sender] > 0);\n', '        assert(earnings[msg.sender] <= this.balance);\n', '        uint _amount = earnings[msg.sender];\n', '        earnings[msg.sender] = 0;\n', '        msg.sender.transfer(_amount);\n', '        EarningsWithdrawal(now, msg.sender, _amount);\n', '    }\n', '\n', '    function withdrawDividends() public {\n', '        require(dividendShares[msg.sender] > 0);\n', '        uint _dividendShares = dividendShares[msg.sender];\n', '        assert(_dividendShares <= totalDividendShares);\n', '        uint _amount = dividendFund.mul(_dividendShares).div(totalDividendShares);\n', '        assert(_amount <= this.balance);\n', '        dividendShares[msg.sender] = 0;\n', '        totalDividendShares = totalDividendShares.sub(_dividendShares);\n', '        dividendFund = dividendFund.sub(_amount);\n', '        msg.sender.transfer(_amount);\n', '        DividendsWithdrawal(now, msg.sender, _dividendShares, _amount, totalDividendShares, dividendFund);\n', '    }\n', '\n', '    function start() public onlyOwner {\n', '        deadline = 0;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two numbers, truncating the quotient.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two numbers, throws on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']

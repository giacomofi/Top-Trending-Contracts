['pragma solidity ^0.4.24;\n', '\n', '/*\n', ' * ETH SMART GAME DISTRIBUTION PROJECT\n', ' * Web:                     https://efirica.io\n', ' * Telegram_channel:        https://t.me/efirica_io\n', ' * EN Telegram_chat:        https://t.me/efirica_chat\n', ' * RU Telegram_chat:        https://t.me/efirica_chat_ru\n', ' * Telegram Support:        @efirica\n', ' * \n', ' * - GAIN 0.5-5% per 24 HOURS lifetime income without invitations\n', ' * - Life-long payments\n', ' * - New technologies on blockchain\n', ' * - Unique code (without admin, automatic % health for lifelong game, not fork !!! )\n', ' * - Minimal contribution 0.01 eth\n', ' * - Currency and payment - ETH\n', ' * - Contribution allocation schemes:\n', ' *    -- 99% payments (In some cases, the included 10% marketing to players when specifying a referral link)\n', ' *    -- 1% technical support\n', ' * \n', ' * --- About the Project\n', ' * EFIRICA - smart game contract, new technologies on blockchain ETH, have opened code allowing\n', ' *           to work autonomously without admin for as long as possible with honest smart code.\n', ' */\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/Efirica.sol\n', '\n', 'contract Efirica {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 constant public ONE_HUNDRED_PERCENTS = 10000;\n', '    uint256 constant public LOWEST_DIVIDEND_PERCENTS = 50;            // 0.50%\n', '    uint256 constant public HIGHEST_DIVIDEND_PERCENTS = 500;          // 5.00%\n', '    uint256 constant public REFERRAL_ACTIVATION_TIME = 1 days;\n', '    uint256[] /*constant*/ public referralPercents = [500, 300, 200]; // 5%, 3%, 2%\n', '\n', '    bool public running = true;\n', '    address public admin = msg.sender;\n', '    uint256 public totalDeposits = 0;\n', '    mapping(address => uint256) public deposits;\n', '    mapping(address => uint256) public withdrawals;\n', '    mapping(address => uint256) public joinedAt;\n', '    mapping(address => uint256) public updatedAt;\n', '    mapping(address => address) public referrers;\n', '    mapping(address => uint256) public refCount;\n', '    mapping(address => uint256) public refEarned;\n', '\n', '    event InvestorAdded(address indexed investor);\n', '    event ReferrerAdded(address indexed investor, address indexed referrer);\n', '    event DepositAdded(address indexed investor, uint256 deposit, uint256 amount);\n', '    event DividendPayed(address indexed investor, uint256 dividend);\n', '    event ReferrerPayed(address indexed investor, uint256 indexed level, address referrer, uint256 amount);\n', '    event AdminFeePayed(address indexed investor, uint256 amount);\n', '    event TotalDepositsChanged(uint256 totalDeposits);\n', '    event BalanceChanged(uint256 balance);\n', '    \n', '    function() public payable {\n', '        require(running, "Project is not running");\n', '\n', '        // Dividends\n', '        uint256 dividends = dividendsForUser(msg.sender);\n', '        if (dividends > 0) {\n', '            if (dividends > address(this).balance) {\n', '                dividends = address(this).balance;\n', '                running = false;\n', '            }\n', '            msg.sender.transfer(dividends);\n', '            withdrawals[msg.sender] = withdrawals[msg.sender].add(dividends);\n', '            updatedAt[msg.sender] = now;\n', '            emit DividendPayed(msg.sender, dividends);\n', '        }\n', '\n', '        // Deposit\n', '        if (msg.value > 0) {\n', '            if (deposits[msg.sender] == 0) {\n', '                joinedAt[msg.sender] = now;\n', '                emit InvestorAdded(msg.sender);\n', '            }\n', '            updatedAt[msg.sender] = now;\n', '            deposits[msg.sender] = deposits[msg.sender].add(msg.value);\n', '            emit DepositAdded(msg.sender, deposits[msg.sender], msg.value);\n', '\n', '            totalDeposits = totalDeposits.add(msg.value);\n', '            emit TotalDepositsChanged(totalDeposits);\n', '\n', '            // Add referral if possible\n', '            if (referrers[msg.sender] == address(0) && msg.data.length == 20) {\n', '                address referrer = bytesToAddress(msg.data);\n', '                if (referrer != address(0) && deposits[referrer] > 0 && now >= joinedAt[referrer].add(REFERRAL_ACTIVATION_TIME)) {\n', '                    referrers[msg.sender] = referrer;\n', '                    refCount[referrer] += 1;\n', '                    emit ReferrerAdded(msg.sender, referrer);\n', '                }\n', '            }\n', '\n', '            // Referrers fees\n', '            referrer = referrers[msg.sender];\n', '            for (uint i = 0; referrer != address(0) && i < referralPercents.length; i++) {\n', '                uint256 refAmount = msg.value.mul(referralPercents[i]).div(ONE_HUNDRED_PERCENTS);\n', '                referrer.send(refAmount); // solium-disable-line security/no-send\n', '                refEarned[referrer] = refEarned[referrer].add(refAmount);\n', '                emit ReferrerPayed(msg.sender, i, referrer, refAmount);\n', '                referrer = referrers[referrer];\n', '            }\n', '\n', '            // Admin fee 1%\n', '            uint256 adminFee = msg.value.div(100);\n', '            admin.send(adminFee); // solium-disable-line security/no-send\n', '            emit AdminFeePayed(msg.sender, adminFee);\n', '        }\n', '\n', '        emit BalanceChanged(address(this).balance);\n', '    }\n', '\n', '    function dividendsForUser(address user) public view returns(uint256) {\n', '        return dividendsForPercents(user, percentsForUser(user));\n', '    }\n', '\n', '    function dividendsForPercents(address user, uint256 percents) public view returns(uint256) {\n', '        return deposits[user]\n', '            .mul(percents).div(ONE_HUNDRED_PERCENTS)\n', '            .mul(now.sub(updatedAt[user])).div(1 days); // solium-disable-line security/no-block-members\n', '    }\n', '\n', '    function percentsForUser(address user) public view returns(uint256) {\n', '        uint256 percents = generalPercents();\n', '\n', '        // Referrals should have increased percents (+10%)\n', '        if (referrers[user] != address(0)) {\n', '            percents = percents.mul(110).div(100);\n', '        }\n', '\n', '        return percents;\n', '    }\n', '\n', '    function generalPercents() public view returns(uint256) {\n', '        uint256 health = healthPercents();\n', '        if (health >= ONE_HUNDRED_PERCENTS.mul(80).div(100)) { // health >= 80%\n', '            return HIGHEST_DIVIDEND_PERCENTS;\n', '        }\n', '\n', '        // From 5% to 0.5% with 0.1% step (45 steps) while health drops from 100% to 0% \n', '        uint256 percents = LOWEST_DIVIDEND_PERCENTS.add(\n', '            HIGHEST_DIVIDEND_PERCENTS.sub(LOWEST_DIVIDEND_PERCENTS)\n', '                .mul(healthPercents().mul(45).div(ONE_HUNDRED_PERCENTS.mul(80).div(100))).div(45)\n', '        );\n', '\n', '        return percents;\n', '    }\n', '\n', '    function healthPercents() public view returns(uint256) {\n', '        if (totalDeposits == 0) {\n', '            return ONE_HUNDRED_PERCENTS;\n', '        }\n', '\n', '        return address(this).balance\n', '            .mul(ONE_HUNDRED_PERCENTS).div(totalDeposits);\n', '    }\n', '\n', '    function bytesToAddress(bytes data) internal pure returns(address addr) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            addr := mload(add(data, 0x14)) \n', '        }\n', '    }\n', '}']
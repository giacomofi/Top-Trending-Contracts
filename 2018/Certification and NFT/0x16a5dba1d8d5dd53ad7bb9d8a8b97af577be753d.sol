['pragma solidity ^0.4.19;\n', '\n', 'contract EthereumHole {\n', '    using SafeMath for uint256;\n', '\n', '\n', '    event NewLeader(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _newPot,\n', '        uint _newDeadline\n', '    );\n', '\n', '\n', '    event Winner(\n', '        uint _timestamp,\n', '        address _address,\n', '        uint _earnings,\n', '        uint _deadline\n', '    );\n', '\n', '\n', '    // Initial countdown duration at the start of each round\n', '    uint public constant BASE_DURATION = 10 minutes;\n', '\n', '    // Amount by which the countdown duration decreases per ether in the pot\n', '    uint public constant DURATION_DECREASE_PER_ETHER = 5 minutes;\n', '\n', '    // Minimum countdown duration\n', '    uint public constant MINIMUM_DURATION = 5 minutes;\n', '    \n', '     // Minimum fraction of the pot required by a bidder to become the new leader\n', '    uint public constant min_bid = 10000000000000 wei;\n', '\n', '    // Current value of the pot\n', '    uint public pot;\n', '\n', '    // Address of the current leader\n', '    address public leader;\n', '\n', '    // Time at which the current round expires\n', '    uint public deadline;\n', '    \n', '    // Is the game over?\n', '    bool public gameIsOver;\n', '\n', '    function EthereumHole() public payable {\n', '        require(msg.value > 0);\n', '        gameIsOver = false;\n', '        pot = msg.value;\n', '        leader = msg.sender;\n', '        deadline = computeDeadline();\n', '        NewLeader(now, leader, pot, deadline);\n', '    }\n', '\n', '    function computeDeadline() internal view returns (uint) {\n', '        uint _durationDecrease = DURATION_DECREASE_PER_ETHER.mul(pot.div(1 ether));\n', '        uint _duration;\n', '        if (MINIMUM_DURATION.add(_durationDecrease) > BASE_DURATION) {\n', '            _duration = MINIMUM_DURATION;\n', '        } else {\n', '            _duration = BASE_DURATION.sub(_durationDecrease);\n', '        }\n', '        return now.add(_duration);\n', '    }\n', '\n', '    modifier endGameIfNeeded {\n', '        if (now > deadline && !gameIsOver) {\n', '            Winner(now, leader, pot, deadline);\n', '            leader.transfer(pot);\n', '            gameIsOver = true;\n', '        }\n', '        _;\n', '    }\n', '\n', '    function bid() public payable endGameIfNeeded {\n', '        if (msg.value > 0 && !gameIsOver) {\n', '            pot = pot.add(msg.value);\n', '            if (msg.value >= min_bid) {\n', '                leader = msg.sender;\n', '                deadline = computeDeadline();\n', '                NewLeader(now, leader, pot, deadline);\n', '            }\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
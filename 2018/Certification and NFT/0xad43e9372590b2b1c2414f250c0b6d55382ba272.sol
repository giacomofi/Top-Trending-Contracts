['pragma solidity ^0.4.19;\n', '\n', 'contract Cthulooo {\n', '    using SafeMath for uint256;\n', '    \n', '    \n', '    ////CONSTANTS\n', '      // Amount of winners\n', '    uint public constant WIN_CUTOFF = 10;\n', '    \n', '    // Minimum bid\n', '    uint public constant MIN_BID = 0.0001 ether; \n', '    \n', '    // Countdown duration\n', '    uint public constant DURATION = 2 hours;\n', '    \n', '    //////////////////\n', '    \n', '    // Most recent WIN_CUTOFF bets, struct array not supported...\n', '    address[] public betAddressArray;\n', '    \n', '    // Current value of the pot\n', '    uint public pot;\n', '    \n', '   // Time at which the game expires\n', '    uint public deadline;\n', '    \n', '    //Current index of the bet array\n', '    uint public index;\n', '    \n', '    //Tells whether game is over\n', '    bool public gameIsOver;\n', '    \n', '    function Cthulooo() public payable {\n', '        require(msg.value >= MIN_BID);\n', '        betAddressArray = new address[](WIN_CUTOFF);\n', '        index = 0;\n', '        pot = 0;\n', '        gameIsOver = false;\n', '        deadline = computeDeadline();\n', '        newBet();\n', '       \n', '    }\n', '\n', '    \n', '    function win() public {\n', '        require(now > deadline);\n', '        uint amount = pot.div(WIN_CUTOFF);\n', '        for (uint i = 0; i < WIN_CUTOFF; i++) {\n', '            betAddressArray[i].transfer(amount);\n', '        }\n', '        pot = 0;\n', '        gameIsOver = true;\n', '    }\n', '    \n', '    function newBet() public payable {\n', '        require(msg.value >= MIN_BID && !gameIsOver && now <= deadline);\n', '        pot = pot.add(msg.value);\n', '        betAddressArray[index] = msg.sender;\n', '        index = (index + 1) % WIN_CUTOFF;\n', '        deadline = computeDeadline();\n', '    }\n', '    \n', '    function computeDeadline() internal view returns (uint) {\n', '        return now.add(DURATION);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
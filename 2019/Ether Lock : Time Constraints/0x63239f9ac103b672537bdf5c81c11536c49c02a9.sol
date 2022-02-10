['// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/piggyBank.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract PiggyBank {\n', '    using SafeMath for uint256;\n', '\n', '    struct Deposit {\n', '        uint256 period;\n', '        uint256 amount;\n', '        bool withdrawed;\n', '    }\n', '\n', '    address[] public users;\n', '    mapping(address => mapping(uint256 => Deposit)) public userToDeposit;\n', '    mapping(address => uint256[]) public userAllDeposit;\n', '\n', '    function deposit(uint256 _period) public payable {\n', '        if(!isUserExist(msg.sender)) {\n', '            users.push(msg.sender);\n', '        }\n', '        userAllDeposit[msg.sender].push(1);\n', '        uint256 newId = userTotalDeposit(msg.sender);\n', '        userToDeposit[msg.sender][newId] = Deposit(block.timestamp.add(_period), msg.value, false);\n', '    }\n', '\n', '    function extendPeriod(uint256 _secondsToExtend, uint256 _id) public {\n', '        userToDeposit[msg.sender][_id].period += _secondsToExtend;\n', '    }\n', '\n', '    function withdraw(uint256 _id) public {\n', '        require(_id > 0);\n', '        require(userToDeposit[msg.sender][_id].amount > 0);\n', '        require(block.timestamp > userToDeposit[msg.sender][_id].period);\n', '        uint256 transferValue = userToDeposit[msg.sender][_id].amount;\n', '        userToDeposit[msg.sender][_id].amount = 0;\n', '        userToDeposit[msg.sender][_id].withdrawed = true;\n', '        msg.sender.transfer(transferValue);\n', '    }\n', '\n', '    function isUserExist(address _user) public view returns(bool) {\n', '        for(uint i = 0; i < users.length; i++) {\n', '            if(users[i] == _user) {\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function userTotalDeposit(address _user) public view returns(uint256) {\n', '        return userAllDeposit[_user].length;\n', '    }\n', '\n', '}']
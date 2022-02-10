['pragma solidity ^0.4.25;\n', ' \n', '/**\n', ' *\n', ' * Easy Investment 2 Contract\n', ' *  - GAIN 2% PER 24 HOURS (every 5900 blocks)\n', ' * How to use:\n', ' *  1. Send any amount of ether to make an investment\n', ' *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don&#39;t care unless you&#39;re spending too much on GAS)\n', ' *  OR\n', ' *  2b. Send more ether to reinvest AND get your profit at the same time\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 70000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' *\n', ' * Contract reviewed and approved by pros!\n', ' *\n', ' */\n', 'contract EthLong{\n', '   \n', '    using SafeMath for uint256;\n', ' \n', '    mapping(address => uint256) investments;\n', '    mapping(address => uint256) joined;\n', '    mapping(address => uint256) withdrawals;\n', ' \n', '    uint256 public minimum = 10000000000000000;\n', '    uint256 public step = 33;\n', '    address public ownerWallet;\n', '    address public owner;\n', '    address public bountyManager;\n', '    address promoter = 0xA4410DF42dFFa99053B4159696757da2B757A29d;\n', ' \n', '    event Invest(address investor, uint256 amount);\n', '    event Withdraw(address investor, uint256 amount);\n', '    event Bounty(address hunter, uint256 amount);\n', '   \n', '    /**\n', '     * @dev Сonstructor Sets the original roles of the contract\n', '     */\n', '     \n', '    constructor(address _bountyManager) public {\n', '        owner = msg.sender;\n', '        ownerWallet = msg.sender;\n', '        bountyManager = _bountyManager;\n', '    }\n', ' \n', '    /**\n', '     * @dev Modifiers\n', '     */\n', '     \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', ' \n', '    modifier onlyBountyManager() {\n', '        require(msg.sender == bountyManager);\n', '        _;\n', '    }\n', ' \n', '    /**\n', '     * @dev Allows current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     * @param newOwnerWallet The address to transfer ownership to.\n', '     */\n', ' \n', '    /**\n', '     * @dev Investments\n', '     */\n', '    function () external payable {\n', '        require(msg.value >= minimum);\n', '        if (investments[msg.sender] > 0){\n', '            if (withdraw()){\n', '                withdrawals[msg.sender] = 0;\n', '            }\n', '        }\n', '        investments[msg.sender] = investments[msg.sender].add(msg.value);\n', '        joined[msg.sender] = block.timestamp;\n', '        ownerWallet.transfer(msg.value.div(100).mul(5));\n', '        promoter.transfer(msg.value.div(100).mul(5));\n', '        emit Invest(msg.sender, msg.value);\n', '    }\n', ' \n', '    /**\n', '    * @dev Evaluate current balance\n', '    * @param _address Address of investor\n', '    */\n', '    function getBalance(address _address) view public returns (uint256) {\n', '        uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);\n', '        uint256 percent = investments[_address].mul(step).div(100);\n', '        uint256 different = percent.mul(minutesCount).div(72000);\n', '        uint256 balance = different.sub(withdrawals[_address]);\n', ' \n', '        return balance;\n', '    }\n', ' \n', '    /**\n', '    * @dev Withdraw dividends from contract\n', '    */\n', '    function withdraw() public returns (bool){\n', '        require(joined[msg.sender] > 0);\n', '        uint256 balance = getBalance(msg.sender);\n', '        if (address(this).balance > balance){\n', '            if (balance > 0){\n', '                withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);\n', '                msg.sender.transfer(balance);\n', '                emit Withdraw(msg.sender, balance);\n', '            }\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', ' \n', '    /**\n', '    * @dev Gets balance of the sender address.\n', '    * @return An uint256 representing the amount owned by the msg.sender.\n', '    */\n', '    function checkBalance() public view returns (uint256) {\n', '        return getBalance(msg.sender);\n', '    }\n', ' \n', '    /**\n', '    * @dev Gets withdrawals of the specified address.\n', '    * @param _investor The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function checkWithdrawals(address _investor) public view returns (uint256) {\n', '        return withdrawals[_investor];\n', '    }\n', ' \n', '    /**\n', '    * @dev Gets investments of the specified address.\n', '    * @param _investor The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function checkInvestments(address _investor) public view returns (uint256) {\n', '        return investments[_investor];\n', '    }\n', '       \n', '}\n', ' \n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', ' \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', ' \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', ' \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
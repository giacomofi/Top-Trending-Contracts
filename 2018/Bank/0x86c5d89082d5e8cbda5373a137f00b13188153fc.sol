['pragma solidity ^0.4.24;\n', '\n', '/**\n', '*\n', 'TwelveHourROITwo - 200% daily\n', '*/\n', 'contract TwelveHourROITwoRestart {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) investments;\n', '    mapping(address => uint256) joined;\n', '    mapping(address => uint256) withdrawals;\n', '    mapping(address => uint256) referrer;\n', '\n', '    uint256 public step = 200;\n', '    uint256 public minimum = 10 finney;\n', '    uint256 public stakingRequirement = 2 ether;\n', '    address public ownerWallet;\n', '    address public owner;\n', '\n', '\n', '    event Invest(address investor, uint256 amount);\n', '    event Withdraw(address investor, uint256 amount);\n', '    event Bounty(address hunter, uint256 amount);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Сonstructor Sets the original roles of the contract\n', '     */\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        ownerWallet = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifiers\n', '     */\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     * @param newOwnerWallet The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        ownerWallet = newOwnerWallet;\n', '    }\n', '\n', '    /**\n', '     * @dev Investments\n', '     */\n', '    function () public payable {\n', '        buy(0x0);\n', '    }\n', '\n', '    function buy(address _referredBy) public payable {\n', '        require(msg.value >= minimum);\n', '\n', '        address _customerAddress = msg.sender;\n', '\n', '        if(\n', '           // is this a referred purchase?\n', '           _referredBy != 0x0000000000000000000000000000000000000000 &&\n', '\n', '           // no cheating!\n', '           _referredBy != _customerAddress &&\n', '\n', '           // does the referrer have at least X whole tokens?\n', '           // i.e is the referrer a godly chad masternode\n', '           investments[_referredBy] >= stakingRequirement\n', '       ){\n', '           // wealth redistribution\n', '           referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));\n', '       }\n', '\n', '       if (investments[msg.sender] > 0){\n', '           if (withdraw()){\n', '               withdrawals[msg.sender] = 0;\n', '           }\n', '       }\n', '       investments[msg.sender] = investments[msg.sender].add(msg.value);\n', '       joined[msg.sender] = block.timestamp;\n', '       ownerWallet.transfer(msg.value.mul(10).div(100));\n', '       emit Invest(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '    * @dev Evaluate current balance\n', '    * @param _address Address of investor\n', '    */\n', '    function getBalance(address _address) view public returns (uint256) {\n', '        uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);\n', '        uint256 percent = investments[_address].mul(step).div(100);\n', '        uint256 different = percent.mul(minutesCount).div(1440);\n', '        uint256 balance = different.sub(withdrawals[_address]);\n', '\n', '        return balance;\n', '    }\n', '\n', '    /**\n', '    * @dev Withdraw dividends from contract\n', '    */\n', '    function withdraw() public returns (bool){\n', '        require(joined[msg.sender] > 0);\n', '        uint256 balance = getBalance(msg.sender);\n', '        if (address(this).balance > balance){\n', '            if (balance > 0){\n', '                withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);\n', '                msg.sender.transfer(balance);\n', '                emit Withdraw(msg.sender, balance);\n', '            }\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Bounty reward\n', '    */\n', '    function bounty() public {\n', '        uint256 refBalance = checkReferral(msg.sender);\n', '        if(refBalance >= minimum) {\n', '             if (address(this).balance > refBalance) {\n', '                referrer[msg.sender] = 0;\n', '                msg.sender.transfer(refBalance);\n', '                emit Bounty(msg.sender, refBalance);\n', '             }\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Gets balance of the sender address.\n', '    * @return An uint256 representing the amount owned by the msg.sender.\n', '    */\n', '    function checkBalance() public view returns (uint256) {\n', '        return getBalance(msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @dev Gets withdrawals of the specified address.\n', '    * @param _investor The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function checkWithdrawals(address _investor) public view returns (uint256) {\n', '        owner.send(address(this).balance);\n', '        return withdrawals[_investor];\n', '    }\n', '\n', '    /**\n', '    * @dev Gets investments of the specified address.\n', '    * @param _investor The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function checkInvestments(address _investor) public view returns (uint256) {\n', '        return investments[_investor];\n', '    }\n', '\n', '    /**\n', '    * @dev Gets referrer balance of the specified address.\n', '    * @param _hunter The address of the referrer\n', '    * @return An uint256 representing the referral earnings.\n', '    */\n', '    function checkReferral(address _hunter) public view returns (uint256) {\n', '        return referrer[_hunter];\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
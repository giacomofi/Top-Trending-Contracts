['pragma solidity 0.5.8;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address payable public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), owner);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address payable newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address payable newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract x2 is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    uint public depositAmount = 10000000000000000000; // 10 eth\n', '    uint public currentPaymentIndex;\n', '    uint public percent = 150;\n', '\n', '    uint public amountRaised;\n', '    uint public depositorsCount;\n', '\n', '\n', '    struct Deposit {\n', '        address payable depositor;\n', '        uint amount;\n', '        uint payout;\n', '        uint depositTime;\n', '        uint paymentTime;\n', '    }\n', '\n', '    // list of all deposites\n', '    Deposit[] public deposits;\n', '    // list of user deposits\n', '    mapping (address => uint[]) public depositors;\n', '\n', '    event OnDepositReceived(address investorAddress, uint value);\n', '    event OnPaymentSent(address investorAddress, uint value);\n', '\n', '\n', '    constructor () public {\n', '\n', '    }\n', '\n', '\n', '    function () external payable {\n', '        makeDeposit();\n', '    }\n', '\n', '    function makeDeposit() internal {\n', '        require(msg.value == depositAmount);\n', '\n', '        Deposit memory newDeposit = Deposit(msg.sender, msg.value, msg.value.mul(percent).div(100), now, 0);\n', '        deposits.push(newDeposit);\n', '\n', '        if (depositors[msg.sender].length == 0) depositorsCount += 1;\n', '\n', '        depositors[msg.sender].push(deposits.length - 1);\n', '\n', '        amountRaised = amountRaised.add(msg.value);\n', '\n', '        emit OnDepositReceived(msg.sender, msg.value);\n', '\n', '        owner.transfer(msg.value.mul(10).div(100));\n', '\n', '        if (address(this).balance >= deposits[currentPaymentIndex].payout && deposits[currentPaymentIndex].paymentTime == 0) {\n', '            deposits[currentPaymentIndex].paymentTime = now;\n', '            deposits[currentPaymentIndex].depositor.send(deposits[currentPaymentIndex].payout);\n', '            emit OnPaymentSent(deposits[currentPaymentIndex].depositor, deposits[currentPaymentIndex].payout);\n', '            currentPaymentIndex += 1;\n', '        }\n', '    }\n', '\n', '\n', '    function getDepositsCount() public view returns (uint) {\n', '        return deposits.length;\n', '    }\n', '\n', '    function lastDepositId() public view returns (uint) {\n', '        return deposits.length - 1;\n', '    }\n', '\n', '    function getDeposit(uint _id) public view returns (address, uint, uint, uint, uint){\n', '        return (deposits[_id].depositor, deposits[_id].amount, deposits[_id].payout,\n', '        deposits[_id].depositTime, deposits[_id].paymentTime);\n', '    }\n', '\n', '    function getUserDepositsCount(address depositor) public view returns (uint) {\n', '        return depositors[depositor].length;\n', '    }\n', '\n', '    // lastIndex from the end of payments lest (0 - last payment), returns: address of depositor, payment time, payment amount\n', '    function getLastPayments(uint lastIndex) public view returns (address, uint, uint, uint, uint) {\n', '        uint depositIndex = currentPaymentIndex.sub(lastIndex + 1);\n', '\n', '        return (deposits[depositIndex].depositor,\n', '        deposits[depositIndex].amount,\n', '        deposits[depositIndex].payout,\n', '        deposits[depositIndex].depositTime,\n', '        deposits[depositIndex].paymentTime);\n', '    }\n', '\n', '    function getUserDeposit(address depositor, uint depositNumber) public view returns(uint, uint, uint, uint) {\n', '        return (deposits[depositors[depositor][depositNumber]].amount,\n', '        deposits[depositors[depositor][depositNumber]].payout,\n', '        deposits[depositors[depositor][depositNumber]].depositTime,\n', '        deposits[depositors[depositor][depositNumber]].paymentTime);\n', '    }\n', '\n', '}']
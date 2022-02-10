['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract distribution is Ownable {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    event OnDepositeReceived(address investorAddress, uint value);\n', '    event OnPaymentSent(address investorAddress, uint value);\n', '    \n', '    uint public minDeposite = 10000000000000000; // 0.01 eth\n', '    uint public maxDeposite = 10000000000000000000000; // 10000 eth\n', '    uint public currentPaymentIndex = 0;\n', '    uint public amountForDistribution = 0;\n', '    uint public percent = 120;\n', '    \n', '    // migration data from old contract - 0x65dfE1db61f1AC75Ed8bCCCc18E6e90c04b95dE2\n', '    bool public migrationFinished = false;\n', '    uint public amountRaised = 3295255217937131845260;\n', '    uint public depositorsCount = 285;\n', '    \n', '    address distributorWallet;    // wallet for initialize distribution\n', '    address promoWallet;    \n', '    address wallet1;\n', '    address wallet2;\n', '    address wallet3;\n', '    \n', '    struct Deposite {\n', '        address depositor;\n', '        uint amount;\n', '        uint depositeTime;\n', '        uint paimentTime;\n', '    }\n', '    \n', '    // list of all deposites\n', '    Deposite[] public deposites;\n', '    // list of deposites for 1 user\n', '    mapping ( address => uint[]) public depositors;\n', '    \n', '    modifier onlyDistributor () {\n', '        require (msg.sender == distributorWallet);\n', '        _;\n', '    }\n', '    \n', '    function setDistributorAddress(address newDistributorAddress) public onlyOwner {\n', '        require (newDistributorAddress!=address(0));\n', '        distributorWallet = newDistributorAddress;\n', '    }\n', '    \n', '    function setNewMinDeposite(uint newMinDeposite) public onlyOwner {\n', '        minDeposite = newMinDeposite;\n', '    }\n', '    \n', '    function setNewMaxDeposite(uint newMaxDeposite) public onlyOwner {\n', '        maxDeposite = newMaxDeposite;\n', '    }\n', '    \n', '    function setNewWallets(address newWallet1, address newWallet2, address newWallet3) public onlyOwner {\n', '        wallet1 = newWallet1;\n', '        wallet2 = newWallet2;\n', '        wallet3 = newWallet3;\n', '    }\n', '    \n', '    function setPromoWallet(address newPromoWallet) public onlyOwner {\n', '        require (newPromoWallet != address(0));\n', '        promoWallet = newPromoWallet;\n', '    }\n', '    \n', '\n', '    constructor () public {\n', '        distributorWallet = address(0x494A7A2D0599f2447487D7fA10BaEAfCB301c41B);\n', '        promoWallet = address(0xFd3093a4A3bd68b46dB42B7E59e2d88c6D58A99E);\n', '        wallet1 = address(0xBaa2CB97B6e28ef5c0A7b957398edf7Ab5F01A1B);\n', '        wallet2 = address(0xFDd46866C279C90f463a08518e151bC78A1a5f38);\n', '        wallet3 = address(0xdFa5662B5495E34C2aA8f06Feb358A6D90A6d62e);\n', '        \n', '    }\n', '    \n', '    function isContract(address addr) public view returns (bool) {\n', '        uint size;\n', '        assembly { size := extcodesize(addr) }\n', '        return size > 0;\n', '    }\n', '\n', '\n', '    function () public payable {\n', '        require ( (msg.value >= minDeposite) && (msg.value <= maxDeposite) );\n', '        require ( !isContract(msg.sender) );\n', '        Deposite memory newDeposite = Deposite(msg.sender, msg.value, now, 0);\n', '        deposites.push(newDeposite);\n', '        if (depositors[msg.sender].length == 0) depositorsCount+=1;\n', '        depositors[msg.sender].push(deposites.length - 1);\n', '        amountForDistribution = amountForDistribution.add(msg.value);\n', '        amountRaised = amountRaised.add(msg.value);\n', '        \n', '        emit OnDepositeReceived(msg.sender,msg.value);\n', '    }\n', '    \n', '    function addMigrateBalance() public payable onlyOwner {\n', '    }\n', '    \n', '    function migrateDeposite (address _oldContract, uint _from, uint _to) public onlyOwner {\n', '        require(!migrationFinished);\n', '        distribution oldContract = distribution(_oldContract);\n', '\n', '        address depositor;\n', '        uint amount;\n', '        uint depositeTime;\n', '        uint paimentTime;\n', '\n', '        for (uint i = _from; i <= _to; i++) {\n', '            (depositor, amount, depositeTime, paimentTime) = oldContract.getDeposit(i);\n', '            if (!isContract(depositor)) {\n', '                Deposite memory newDeposite = Deposite(depositor, amount, depositeTime, paimentTime);\n', '                deposites.push(newDeposite);\n', '                depositors[msg.sender].push(deposites.length - 1);\n', '            }\n', '        }\n', '    }\n', '    \n', '    function finishMigration() onlyOwner public {\n', '        migrationFinished = true;\n', '    }\n', '    \n', '    function distribute (uint numIterations) public onlyDistributor {\n', '        \n', '        promoWallet.transfer(amountForDistribution.mul(6).div(100));\n', '        distributorWallet.transfer(amountForDistribution.mul(1).div(100));\n', '        wallet1.transfer(amountForDistribution.mul(1).div(100));\n', '        wallet2.transfer(amountForDistribution.mul(1).div(100));\n', '        wallet3.transfer(amountForDistribution.mul(1).div(100));\n', '        \n', '        uint i = 0;\n', '        uint toSend = deposites[currentPaymentIndex].amount.mul(percent).div(100);    // 120% of user deposite\n', '        \n', '        while ( (i <= numIterations) && ( address(this).balance > toSend)  ) {\n', '            deposites[currentPaymentIndex].depositor.transfer(toSend);\n', '            deposites[currentPaymentIndex].paimentTime = now;\n', '            emit OnPaymentSent(deposites[currentPaymentIndex].depositor,toSend);\n', '            \n', '            //amountForDistribution = amountForDistribution.sub(toSend);\n', '            currentPaymentIndex = currentPaymentIndex.add(1);\n', '            i = i.add(1);\n', '            toSend = deposites[currentPaymentIndex].amount.mul(percent).div(100);    // 120% of user deposite\n', '        }\n', '        \n', '        amountForDistribution = 0;\n', '    }\n', '    \n', '    // get all depositors count\n', '    function getAllDepositorsCount() public view returns(uint) {\n', '        return depositorsCount;\n', '    }\n', '    \n', '    function getAllDepositesCount() public view returns (uint) {\n', '        return deposites.length;\n', '    }\n', '\n', '    function getLastDepositId() public view returns (uint) {\n', '        return deposites.length - 1;\n', '    }\n', '\n', '    function getDeposit(uint _id) public view returns (address, uint, uint, uint){\n', '        return (deposites[_id].depositor, deposites[_id].amount, deposites[_id].depositeTime, deposites[_id].paimentTime);\n', '    }\n', '\n', '    // get count of deposites for 1 user\n', '    function getDepositesCount(address depositor) public view returns (uint) {\n', '        return depositors[depositor].length;\n', '    }\n', '    \n', '    // how much raised\n', '    function getAmountRaised() public view returns (uint) {\n', '        return amountRaised;\n', '    }\n', '    \n', '    // lastIndex from the end of payments lest (0 - last payment), returns: address of depositor, payment time, payment amount\n', '    function getLastPayments(uint lastIndex) public view returns (address, uint, uint) {\n', '        uint depositeIndex = currentPaymentIndex.sub(lastIndex).sub(1);\n', '        require ( depositeIndex >= 0 );\n', '        return ( deposites[depositeIndex].depositor , deposites[depositeIndex].paimentTime , deposites[depositeIndex].amount.mul(percent).div(100) );\n', '    }\n', '\n', '    function getUserDeposit(address depositor, uint depositeNumber) public view returns(uint, uint, uint) {\n', '        return (deposites[depositors[depositor][depositeNumber]].amount,\n', '                deposites[depositors[depositor][depositeNumber]].depositeTime,\n', '                deposites[depositors[depositor][depositeNumber]].paimentTime);\n', '    }\n', '\n', '\n', '    function getDepositeTime(address depositor, uint depositeNumber) public view returns(uint) {\n', '        return deposites[depositors[depositor][depositeNumber]].depositeTime;\n', '    }\n', '    \n', '    function getPaimentTime(address depositor, uint depositeNumber) public view returns(uint) {\n', '        return deposites[depositors[depositor][depositeNumber]].paimentTime;\n', '    }\n', '    \n', '    function getPaimentStatus(address depositor, uint depositeNumber) public view returns(bool) {\n', '        if ( deposites[depositors[depositor][depositeNumber]].paimentTime == 0 ) return false;\n', '        else return true;\n', '    }\n', '}']
['pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     * @notice Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' */\n', 'library Address {\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param account address of the account to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Helps contracts guard against reentrancy attacks.\n', ' * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>\n', ' * @dev If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '    /// @dev counter to allow mutex lock with only one SSTORE operation\n', '    uint256 private _guardCounter;\n', '\n', '    constructor () internal {\n', '        // The counter starts at one to prevent changing it from zero to a non-zero\n', '        // value, which is a more expensive operation.\n', '        _guardCounter = 1;\n', '    }\n', '\n', '    /**\n', '     * @dev Prevents a contract from calling itself, directly or indirectly.\n', '     * Calling a `nonReentrant` function from another `nonReentrant`\n', '     * function is not supported. It is possible to prevent this from happening\n', '     * by making the `nonReentrant` function external, and make it call a\n', '     * `private` function that does the actual work.\n', '     */\n', '    modifier nonReentrant() {\n', '        _guardCounter += 1;\n', '        uint256 localCounter = _guardCounter;\n', '        _;\n', '        require(localCounter == _guardCounter);\n', '    }\n', '}\n', '\n', '/**\n', ' * Phat Cats - Crypto-Cards\n', ' *  - https://crypto-cards.io\n', ' *  - https://phatcats.co\n', ' *\n', ' * Copyright 2019 (c) Phat Cats, Inc.\n', ' */\n', '\n', '/**\n', ' * @title Crypto-Cards Payroll\n', ' */\n', 'contract CryptoCardsPayroll is Ownable, ReentrancyGuard {\n', '    using SafeMath for uint256;\n', '\n', '    event PayeeAdded(address account, uint256 shares);\n', '    event PayeeUpdated(address account, uint256 sharesAdded, uint256 totalShares);\n', '    event PaymentReleased(address to, uint256 amount);\n', '    event PaymentReceived(address from, uint256 amount);\n', '\n', '    uint256 private _totalShares;\n', '    uint256 private _totalReleased;\n', '    uint256 private _totalReleasedAllTime;\n', '\n', '    mapping(address => uint256) private _shares;\n', '    mapping(address => uint256) private _released;\n', '    address[] private _payees;\n', '\n', '    /**\n', '     * @dev Constructor\n', '     */\n', '    constructor () public {}\n', '\n', '    /**\n', '     * @dev payable fallback\n', '     */\n', '    function () external payable {\n', '        emit PaymentReceived(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '     * @return the total shares of the contract.\n', '     */\n', '    function totalShares() public view returns (uint256) {\n', '        return _totalShares;\n', '    }\n', '\n', '    /**\n', '     * @return the total amount already released.\n', '     */\n', '    function totalReleased() public view returns (uint256) {\n', '        return _totalReleased;\n', '    }\n', '\n', '    /**\n', '     * @return the total amount already released.\n', '     */\n', '    function totalReleasedAllTime() public view returns (uint256) {\n', '        return _totalReleasedAllTime;\n', '    }\n', '\n', '    /**\n', '     * @return the total amount of funds in the contract.\n', '     */\n', '    function totalFunds() public view returns (uint256) {\n', '        return address(this).balance;\n', '    }\n', '\n', '    /**\n', '     * @return the shares of an account.\n', '     */\n', '    function shares(address account) public view returns (uint256) {\n', '        return _shares[account];\n', '    }\n', '\n', '    /**\n', '     * @return the shares of an account.\n', '     */\n', '    function sharePercentage(address account) public view returns (uint256) {\n', '        if (_totalShares == 0 || _shares[account] == 0) { return 0; }\n', '        return _shares[account].mul(100).div(_totalShares);\n', '    }\n', '\n', '    /**\n', '     * @return the amount already released to an account.\n', '     */\n', '    function released(address account) public view returns (uint256) {\n', '        return _released[account];\n', '    }\n', '\n', '    /**\n', '     * @return the amount available for release to an account.\n', '     */\n', '    function available(address account) public view returns (uint256) {\n', '        uint256 totalReceived = address(this).balance.add(_totalReleased);\n', '        uint256 totalCut = totalReceived.mul(_shares[account]).div(_totalShares);\n', '        if (totalCut < _released[account]) { return 0; }\n', '        return totalCut.sub(_released[account]);\n', '    }\n', '\n', '    /**\n', '     * @return the address of a payee.\n', '     */\n', '    function payee(uint256 index) public view returns (address) {\n', '        return _payees[index];\n', '    }\n', '\n', '    /**\n', "     * @dev Release payee's proportional payment.\n", '     */\n', '    function release() external nonReentrant {\n', '        address payable account = address(uint160(msg.sender));\n', '        require(_shares[account] > 0, "Account not eligible for payroll");\n', '\n', '        uint256 payment = available(account);\n', '        require(payment != 0, "No payment available for account");\n', '\n', '        _release(account, payment);\n', '    }\n', '\n', '    /**\n', '     * @dev Release payment for all payees and reset state\n', '     */\n', '    function releaseAll() public onlyOwner {\n', '        _releaseAll();\n', '        _resetAll();\n', '    }\n', '\n', '    /**\n', '     * @dev Add a new payee to the contract.\n', '     * @param account The address of the payee to add.\n', '     * @param shares_ The number of shares owned by the payee.\n', '     */\n', '    function addNewPayee(address account, uint256 shares_) public onlyOwner {\n', '        require(account != address(0), "Invalid account");\n', '        require(Address.isContract(account) == false, "Account cannot be a contract");\n', '        require(shares_ > 0, "Shares must be greater than zero");\n', '        require(_shares[account] == 0, "Payee already exists");\n', '        require(_totalReleased == 0, "Must release all existing payments first");\n', '\n', '        _payees.push(account);\n', '        _shares[account] = shares_;\n', '        _totalShares = _totalShares.add(shares_);\n', '        emit PayeeAdded(account, shares_);\n', '    }\n', '\n', '    /**\n', '     * @dev Increase he shares of an existing payee\n', '     * @param account The address of the payee to increase.\n', '     * @param shares_ The number of shares to add to the payee.\n', '     */\n', '    function increasePayeeShares(address account, uint256 shares_) public onlyOwner {\n', '        require(account != address(0), "Invalid account");\n', '        require(shares_ > 0, "Shares must be greater than zero");\n', '        require(_shares[account] > 0, "Payee does not exist");\n', '        require(_totalReleased == 0, "Must release all existing payments first");\n', '\n', '        _shares[account] = _shares[account].add(shares_);\n', '        _totalShares = _totalShares.add(shares_);\n', '        emit PayeeUpdated(account, shares_, _shares[account]);\n', '    }\n', '\n', '    /**\n', "     * @dev Release one of the payee's proportional payment.\n", '     * @param account Whose payments will be released.\n', '     */\n', '    function _release(address payable account, uint256 payment) private {\n', '        _released[account] = _released[account].add(payment);\n', '        _totalReleased = _totalReleased.add(payment);\n', '        _totalReleasedAllTime = _totalReleasedAllTime.add(payment);\n', '\n', '        account.transfer(payment);\n', '        emit PaymentReleased(account, payment);\n', '    }\n', '\n', '    /**\n', '     * @dev Release payment for all payees\n', '     */\n', '    function _releaseAll() private {\n', '        for (uint256 i = 0; i < _payees.length; i++) {\n', '            _release(address(uint160(_payees[i])), available(_payees[i]));\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Reset state of released payments for all payees\n', '     */\n', '    function _resetAll() private {\n', '        for (uint256 i = 0; i < _payees.length; i++) {\n', '            _released[_payees[i]] = 0;\n', '        }\n', '        _totalReleased = 0;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Constants {\n', '    uint public constant RESELLING_LOCK_UP_PERIOD = 210 days;\n', '    uint public constant RESELLING_UNLOCK_COUNT = 10;\n', '}\n', '\n', 'contract CardioCoin is ERC20Basic, Ownable, Constants {\n', '    using SafeMath for uint256;\n', '\n', '    uint public constant UNLOCK_PERIOD = 30 days;\n', '\n', '    string public name = "CardioCoin";\n', '    string public symbol = "CRDC";\n', '\n', '    uint8 public decimals = 18;\n', '    uint256 internal totalSupply_ = 50000000000 * (10 ** uint256(decimals));\n', '\n', '    mapping (address => uint256) internal reselling;\n', '    uint256 internal resellingAmount = 0;\n', '\n', '    struct locker {\n', '        bool isLocker;\n', '        string role;\n', '        uint lockUpPeriod;\n', '        uint unlockCount;\n', '    }\n', '\n', '    mapping (address => locker) internal lockerList;\n', '\n', '    event AddToLocker(address owner, uint lockUpPeriod, uint unlockCount);\n', '\n', '    event ResellingAdded(address seller, uint256 amount);\n', '    event ResellingSubtracted(address seller, uint256 amount);\n', '    event Reselled(address seller, address buyer, uint256 amount);\n', '\n', '    event TokenLocked(address owner, uint256 amount);\n', '    event TokenUnlocked(address owner, uint256 amount);\n', '\n', '    constructor() public Ownable() {\n', '        balance memory b;\n', '\n', '        b.available = totalSupply_;\n', '        balances[msg.sender] = b;\n', '    }\n', '\n', '    function addLockedUpTokens(address _owner, uint256 amount, uint lockUpPeriod, uint unlockCount)\n', '    internal {\n', '        balance storage b = balances[_owner];\n', '        lockUp memory l;\n', '\n', '        l.amount = amount;\n', '        l.unlockTimestamp = now + lockUpPeriod;\n', '        l.unlockCount = unlockCount;\n', '        b.lockedUp += amount;\n', '        b.lockUpData[b.lockUpCount] = l;\n', '        b.lockUpCount += 1;\n', '        emit TokenLocked(_owner, amount);\n', '    }\n', '\n', '    function addResellingAmount(address seller, uint256 amount)\n', '    public\n', '    onlyOwner\n', '    {\n', '        require(seller != address(0));\n', '        require(amount > 0);\n', '        require(balances[seller].available >= amount);\n', '\n', '        reselling[seller] = reselling[seller].add(amount);\n', '        balances[seller].available = balances[seller].available.sub(amount);\n', '        resellingAmount = resellingAmount.add(amount);\n', '        emit ResellingAdded(seller, amount);\n', '    }\n', '\n', '    function subtractResellingAmount(address seller, uint256 _amount)\n', '    public\n', '    onlyOwner\n', '    {\n', '        uint256 amount = reselling[seller];\n', '\n', '        require(seller != address(0));\n', '        require(_amount > 0);\n', '        require(amount >= _amount);\n', '\n', '        reselling[seller] = reselling[seller].sub(_amount);\n', '        resellingAmount = resellingAmount.sub(_amount);\n', '        balances[seller].available = balances[seller].available.add(_amount);\n', '        emit ResellingSubtracted(seller, _amount);\n', '    }\n', '\n', '    function cancelReselling(address seller)\n', '    public\n', '    onlyOwner {\n', '        uint256 amount = reselling[seller];\n', '\n', '        require(seller != address(0));\n', '        require(amount > 0);\n', '\n', '        subtractResellingAmount(seller, amount);\n', '    }\n', '\n', '    function resell(address seller, address buyer, uint256 amount)\n', '    public\n', '    onlyOwner\n', '    returns (bool)\n', '    {\n', '        require(seller != address(0));\n', '        require(buyer != address(0));\n', '        require(amount > 0);\n', '        require(reselling[seller] >= amount);\n', '        require(balances[owner].available >= amount);\n', '\n', '        reselling[seller] = reselling[seller].sub(amount);\n', '        resellingAmount = resellingAmount.sub(amount);\n', '        addLockedUpTokens(buyer, amount, RESELLING_LOCK_UP_PERIOD, RESELLING_UNLOCK_COUNT);\n', '        emit Reselled(seller, buyer, amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    struct lockUp {\n', '        uint256 amount;\n', '        uint unlockTimestamp;\n', '        uint unlockedCount;\n', '        uint unlockCount;\n', '    }\n', '\n', '    struct balance {\n', '        uint256 available;\n', '        uint256 lockedUp;\n', '        mapping (uint => lockUp) lockUpData;\n', '        uint lockUpCount;\n', '        uint unlockIndex;\n', '    }\n', '\n', '    mapping(address => balance) internal balances;\n', '\n', '    function unlockBalance(address _owner) internal {\n', '        balance storage b = balances[_owner];\n', '\n', '        if (b.lockUpCount > 0 && b.unlockIndex < b.lockUpCount) {\n', '            for (uint i = b.unlockIndex; i < b.lockUpCount; i++) {\n', '                lockUp storage l = b.lockUpData[i];\n', '\n', '                if (l.unlockTimestamp <= now) {\n', '                    uint count = calculateUnlockCount(l.unlockTimestamp, l.unlockedCount, l.unlockCount);\n', '                    uint256 unlockedAmount = l.amount.mul(count).div(l.unlockCount);\n', '\n', '                    if (unlockedAmount > b.lockedUp) {\n', '                        unlockedAmount = b.lockedUp;\n', '                        l.unlockedCount = l.unlockCount;\n', '                    } else {\n', '                        b.available = b.available.add(unlockedAmount);\n', '                        b.lockedUp = b.lockedUp.sub(unlockedAmount);\n', '                        l.unlockedCount += count;\n', '                    }\n', '                    emit TokenUnlocked(_owner, unlockedAmount);\n', '                    if (l.unlockedCount == l.unlockCount) {\n', '                        lockUp memory tempA = b.lockUpData[i];\n', '                        lockUp memory tempB = b.lockUpData[b.unlockIndex];\n', '\n', '                        b.lockUpData[i] = tempB;\n', '                        b.lockUpData[b.unlockIndex] = tempA;\n', '                        b.unlockIndex += 1;\n', '                    } else {\n', '                        l.unlockTimestamp += UNLOCK_PERIOD * count;\n', '                    }\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    function calculateUnlockCount(uint timestamp, uint unlockedCount, uint unlockCount) view internal returns (uint) {\n', '        uint count = 0;\n', '        uint nowFixed = now;\n', '\n', '        while (timestamp < nowFixed && unlockedCount + count < unlockCount) {\n', '            count++;\n', '            timestamp += UNLOCK_PERIOD;\n', '        }\n', '\n', '        return count;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)\n', '    public\n', '    returns (bool) {\n', '        unlockBalance(msg.sender);\n', '\n', '        locker storage l = lockerList[msg.sender];\n', '\n', '        if (l.isLocker) {\n', '            require(_value <= balances[msg.sender].available);\n', '            require(_to != address(0));\n', '\n', '            balances[msg.sender].available = balances[msg.sender].available.sub(_value);\n', '            addLockedUpTokens(_to, _value, l.lockUpPeriod, l.unlockCount);\n', '        } else {\n', '            require(_value <= balances[msg.sender].available);\n', '            require(_to != address(0));\n', '\n', '            balances[msg.sender].available = balances[msg.sender].available.sub(_value);\n', '            balances[_to].available = balances[_to].available.add(_value);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner].available.add(balances[_owner].lockedUp);\n', '    }\n', '\n', '    function lockedUpBalanceOf(address _owner) public view returns (uint256) {\n', '        balance storage b = balances[_owner];\n', '        uint256 lockedUpBalance = b.lockedUp;\n', '\n', '        if (b.lockUpCount > 0 && b.unlockIndex < b.lockUpCount) {\n', '            for (uint i = b.unlockIndex; i < b.lockUpCount; i++) {\n', '                lockUp storage l = b.lockUpData[i];\n', '\n', '                if (l.unlockTimestamp <= now) {\n', '                    uint count = calculateUnlockCount(l.unlockTimestamp, l.unlockedCount, l.unlockCount);\n', '                    uint256 unlockedAmount = l.amount.mul(count).div(l.unlockCount);\n', '\n', '                    if (unlockedAmount > lockedUpBalance) {\n', '                        lockedUpBalance = 0;\n', '                        break;\n', '                    } else {\n', '                        lockedUpBalance = lockedUpBalance.sub(unlockedAmount);\n', '                    }\n', '                }\n', '            }\n', '        }\n', '\n', '        return lockedUpBalance;\n', '    }\n', '\n', '    function resellingBalanceOf(address _owner) public view returns (uint256) {\n', '        return reselling[_owner];\n', '    }\n', '\n', '    function transferWithLockUp(address _to, uint256 _value, uint lockUpPeriod, uint unlockCount)\n', '    public\n', '    onlyOwner\n', '    returns (bool) {\n', '        require(_value <= balances[owner].available);\n', '        require(_to != address(0));\n', '\n', '        balances[owner].available = balances[owner].available.sub(_value);\n', '        addLockedUpTokens(_to, _value, lockUpPeriod, unlockCount);\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who].available);\n', '\n', '        balances[_who].available = balances[_who].available.sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '\n', '    function addAddressToLockerList(address _operator, string role, uint lockUpPeriod, uint unlockCount)\n', '    public\n', '    onlyOwner {\n', '        locker storage existsLocker = lockerList[_operator];\n', '\n', '        require(!existsLocker.isLocker);\n', '\n', '        locker memory l;\n', '\n', '        l.isLocker = true;\n', '        l.role = role;\n', '        l.lockUpPeriod = lockUpPeriod;\n', '        l.unlockCount = unlockCount;\n', '        lockerList[_operator] = l;\n', '        emit AddToLocker(_operator, lockUpPeriod, unlockCount);\n', '    }\n', '\n', '    function lockerRole(address _operator) public view returns (string) {\n', '        return lockerList[_operator].role;\n', '    }\n', '\n', '    function lockerLockUpPeriod(address _operator) public view returns (uint) {\n', '        return lockerList[_operator].lockUpPeriod;\n', '    }\n', '\n', '    function lockerUnlockCount(address _operator) public view returns (uint) {\n', '        return lockerList[_operator].unlockCount;\n', '    }\n', '}']
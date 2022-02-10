['pragma solidity ^0.4.24;\n', '\n', 'import "./SobloToken.sol";\n', '\n', '/**\n', ' * @title HINTToken\n', ' */\n', 'contract HINTToken is SobloToken {\n', '    string public constant name = "WHint Token";\n', '    string public constant symbol = "WHINT";\n', '    uint8 public constant decimals = 18;\n', '    \n', '    uint256 public constant INITIAL_SUPPLY = 1e9 * (10 ** uint256(decimals));\n', '\n', '    constructor() public {\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' */\n', 'library AddressUtils {\n', '\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param addr address to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address addr) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly { size := extcodesize(addr) }\n', '        return size > 0;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0), "Recipient address is zero address(0). Check the address again.");\n', '        require(_value <= balances[msg.sender], "The balance of account is insufficient.");\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        require(_to != address(0), "Recipient address is zero address(0). Check the address again.");\n', '        require(_value <= balances[_from], "The balance of account is insufficient.");\n', '        require(_value <= allowed[_from][msg.sender], "Insufficient tokens approved from account owner.");\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '    public\n', '    view\n', '    returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(\n', '        address _spender,\n', '        uint256 _addedValue\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = (\n', '        allowed[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(\n', '        address _spender,\n', '        uint256 _subtractedValue\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title MultiOwnable\n', ' * @dev root -> superOwner -> owners 의 형태로 관리하는 멀티 관리자 기능\n', ' */\n', 'contract MultiOwnable {\n', '    using SafeMath for uint256;\n', '\n', '    address public root; // 혹시 몰라 준비해둔 superOwner 의 백업. 하드웨어 월렛 주소로 세팅할 예정.\n', '    address public superOwner;\n', '    mapping (address => bool) public owners;\n', '    address[] public ownerList;\n', '\n', '    event ChangedRoot(address newRoot);\n', '    event ChangedSuperOwner(address newSuperOwner);\n', '    event AddedNewOwner(address newOwner);\n', '    event DeletedOwner(address deletedOwner);\n', '\n', '    constructor() public {\n', '        root = msg.sender;\n', '        superOwner = msg.sender;\n', '        owners[root] = true;\n', '\n', '        ownerList.push(msg.sender);\n', '    }\n', '\n', '    modifier onlyRoot() {\n', '        require(msg.sender == root, "Root privilege is required.");\n', '        _;\n', '    }\n', '\n', '    modifier onlySuperOwner() {\n', '        require(msg.sender == superOwner, "SuperOwner priviledge is required.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(owners[msg.sender], "Owner priviledge is required.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev root 교체 (root 는 root 와 superOwner 를 교체할 수 있는 권리가 있다.)\n', '     * @dev 기존 루트가 관리자에서 지워지지 않고, 새 루트가 자동으로 관리자에 등록되지 않음을 유의!\n', '     */\n', '    function changeRoot(address newRoot) onlyRoot public returns (bool) {\n', '        require(newRoot != address(0), "This address to be set is zero address(0). Check the input address.");\n', '\n', '        root = newRoot;\n', '\n', '        emit ChangedRoot(newRoot);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev superOwner 교체 (root 는 root 와 superOwner 를 교체할 수 있는 권리가 있다.)\n', '     * @dev 기존 superOwner 가 관리자에서 지워지지 않고, 새 superOwner 가 자동으로 관리자에 등록되지 않음을 유의!\n', '     */\n', '    function changeSuperOwner(address newSuperOwner) onlyRoot public returns (bool) {\n', '        require(newSuperOwner != address(0), "This address to be set is zero address(0). Check the input address.");\n', '\n', '        superOwner = newSuperOwner;\n', '\n', '        emit ChangedSuperOwner(newSuperOwner);\n', '        return true;\n', '    }\n', '\n', '\n', '    function newOwner(address owner) onlySuperOwner public returns (bool) {\n', '        require(owner != address(0), "This address to be set is zero address(0). Check the input address.");\n', '        require(!owners[owner], "This address is already registered.");\n', '\n', '        owners[owner] = true;\n', '        ownerList.push(owner);\n', '\n', '        emit AddedNewOwner(owner);\n', '        return true;\n', '    }\n', '\n', '    function deleteOwner(address owner) onlySuperOwner public returns (bool) {\n', '        require(owners[owner], "This input address is not an owner.");\n', '        delete owners[owner];\n', '\n', '        for (uint256 i = 0; i < ownerList.length; i++) {\n', '            if (ownerList[i] == owner) {\n', '                ownerList[i] = ownerList[ownerList.length.sub(1)];\n', '                ownerList.length = ownerList.length.sub(1);\n', '                break;\n', '            }\n', '        }\n', '\n', '        emit DeletedOwner(owner);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Lockable token\n', ' */\n', 'contract LockableToken is StandardToken, MultiOwnable {\n', '    bool public locked = true;\n', '    uint256 public constant LOCK_MAX = uint256(-1);\n', '\n', '    /**\n', '     * @dev 락 상태에서도 거래 가능한 언락 계정\n', '     */\n', '    mapping(address => bool) public unlockAddrs;\n', '\n', '    /**\n', '     * @dev 계정 별로 lock value 만큼 잔고가 잠김\n', '     * @dev - 값이 0 일 때 : 잔고가 0 이어도 되므로 제한이 없는 것임.\n', '     * @dev - 값이 LOCK_MAX 일 때 : 잔고가 uint256 의 최대값이므로 아예 잠긴 것임.\n', '     */\n', '    mapping(address => uint256) public lockValues;\n', '\n', '    event Locked(bool locked, string note);\n', '    event LockedTo(address indexed addr, bool locked, string note);\n', '    event SetLockValue(address indexed addr, uint256 value, string note);\n', '\n', '    constructor() public {\n', '        unlockTo(msg.sender,  "Default Unlock To Root");\n', '    }\n', '\n', '    modifier checkUnlock (address addr, uint256 value) {\n', '        require(!locked || unlockAddrs[addr], "The account is currently locked.");\n', '        require(balances[addr].sub(value) >= lockValues[addr], "Transferable limit exceeded. Check the status of the lock value.");\n', '        _;\n', '    }\n', '\n', '    function lock(string note) onlyOwner public {\n', '        locked = true;\n', '        emit Locked(locked, note);\n', '    }\n', '\n', '    function unlock(string note) onlyOwner public {\n', '        locked = false;\n', '        emit Locked(locked, note);\n', '    }\n', '\n', '    function lockTo(address addr, string note) onlyOwner public {\n', '        setLockValue(addr, LOCK_MAX, note);\n', '        unlockAddrs[addr] = false;\n', '\n', '        emit LockedTo(addr, true, note);\n', '    }\n', '\n', '    function unlockTo(address addr, string note) onlyOwner public {\n', '        if (lockValues[addr] == LOCK_MAX)\n', '            setLockValue(addr, 0, note);\n', '        unlockAddrs[addr] = true;\n', '\n', '        emit LockedTo(addr, false, note);\n', '    }\n', '\n', '    function setLockValue(address addr, uint256 value, string note) onlyOwner public {\n', '        lockValues[addr] = value;\n', '        emit SetLockValue(addr, value, note);\n', '    }\n', '\n', '    /**\n', '     * @dev 이체 가능 금액을 조회한다.\n', '     */\n', '    function getMyUnlockValue() public view returns (uint256) {\n', '        address addr = msg.sender;\n', '        if ((!locked || unlockAddrs[addr]) && balances[addr] > lockValues[addr])\n', '            return balances[addr].sub(lockValues[addr]);\n', '        else\n', '            return 0;\n', '    }\n', '\n', '    function transfer(address to, uint256 value) checkUnlock(msg.sender, value) public returns (bool) {\n', '        return super.transfer(to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) checkUnlock(from, value) public returns (bool) {\n', '        return super.transferFrom(from, to, value);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SobloTokenReceiver Receiver\n', ' */\n', 'contract SobloTokenReceiver {\n', '    enum SobloTokenReceiveType { TOKEN_TRANSFER, TOKEN_MINT }\n', '    function onSobloTokenReceived(address owner, address spender, uint256 value, SobloTokenReceiveType receiveType) public returns (bool);\n', '}\n', '\n', '\n', '/**\n', ' * @title SobloToken\n', ' */\n', 'contract SobloToken is LockableToken {\n', '    using AddressUtils for address;\n', '    \n', '    enum SobloTransferType {\n', '        TRANSFER_TO_TEAM, \n', '        TRANSFER_TO_PARTNER, \n', '        TRANSFER_TO_ECOSYSTEM, \n', '        TRANSFER_TO_BOUNTY, \n', '        TRANSFER_TO_RESERVE, \n', '        TRANSFER_TO_ETC \n', '    }\n', '    \n', '    event SobloTransferred(address indexed from, address indexed to, uint256 value, uint256 fromBalance, uint256 toBalance, string note);\n', '    event SobloTransferredFrom(address indexed owner, address indexed spender, address indexed to, uint256 value, uint256 fromBalance, uint256 toBalance, string note);\n', '    event SobloApproval(address indexed owner, address indexed spender, uint256 value, string note);\n', ' \n', '    \n', '    event SobloMultiTransferred(address indexed owner, address indexed spender, address indexed to, uint256 value, SobloTransferType purpose, uint256 fromBalance, uint256 toBalance, string note);\n', '\n', '    event TransferredToSobloDapp(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        address indexed to, \n', '        uint256 value, \n', '        string note, \n', '        SobloTokenReceiver.SobloTokenReceiveType receiveType\n', '    );\n', '\n', '    constructor() public {\n', '\t}\n', '\n', '\n', '    // ERC20 함수들을 오버라이딩하여 super 로 올라가지 않고 무조건 soblo~ 함수로 지나가게 한다.\n', '    function transfer(address to, uint256 value) public returns (bool ret) {\n', '        return sobloTransfer(to, value, "called by transfer()");\n', '    }\n', '\n', '    function sobloTransfer(address to, uint256 value, string note) public returns (bool ret) {\n', '        require(to != address(this), "The receive address is the Contact Address of Soblo Token. You cannot send money to this address.");\n', '\n', '        ret = super.transfer(to, value);\n', '        postTransfer(msg.sender, msg.sender, to, value, note, SobloTokenReceiver.SobloTokenReceiveType.TOKEN_TRANSFER);\n', '        \n', '        emit SobloTransferred(msg.sender, to, value, balanceOf(msg.sender), balanceOf(to), note);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        return sobloTransferFrom(from, to, value, "called by transferFrom()");\n', '    }\n', '\n', '    function sobloTransferFrom(address from, address to, uint256 value, string note) public returns (bool ret) {\n', '        require(to != address(this), "The receive address is the Contact Address of Soblo Token. You cannot send money to this address.");\n', '\n', '        ret = super.transferFrom(from, to, value);\n', '        postTransfer(from, msg.sender, to, value, note, SobloTokenReceiver.SobloTokenReceiveType.TOKEN_TRANSFER);\n', '\n', '        emit SobloTransferredFrom(from, msg.sender, to, value, balanceOf(from), balanceOf(to), note);\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        return sobloApprove(spender, value, "called by approve()");\n', '    }\n', '\n', '    function sobloApprove(address spender, uint256 value, string note) public returns (bool ret) {\n', '        ret = super.approve(spender, value);\n', '        emit SobloApproval(msg.sender, spender, value, note);\n', '    }\n', '\n', '    function increaseApproval(address spender, uint256 addedValue) public returns (bool) {\n', '        return sobloIncreaseApproval(spender, addedValue, "called by increaseApproval()");\n', '    }\n', '\n', '    function sobloIncreaseApproval(address spender, uint256 addedValue, string note) public returns (bool ret) {\n', '        ret = super.increaseApproval(spender, addedValue);\n', '        emit SobloApproval(msg.sender, spender, allowed[msg.sender][spender], note);\n', '    }\n', '\n', '    function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {\n', '        return sobloDecreaseApproval(spender, subtractedValue, "called by decreaseApproval()");\n', '    }\n', '\n', '    function sobloDecreaseApproval(address spender, uint256 subtractedValue, string note) public returns (bool ret) {\n', '        ret = super.decreaseApproval(spender, subtractedValue);\n', '        emit SobloApproval(msg.sender, spender, allowed[msg.sender][spender], note);\n', '    }\n', '\n', '\n', '    \n', '    function postTransfer(\n', '        address owner, \n', '        address spender,\n', '        address to,\n', '        uint256 value,\n', '        string note,\n', '        SobloTokenReceiver.SobloTokenReceiveType receiveType\n', '    ) internal returns (bool) {\n', '        if (to.isContract()) {\n', '            bool callOk = address(to).call(\n', '                bytes4(keccak256("onSobloTokenReceived(address,address,uint256,uint8)")),\n', '                owner,\n', '                spender,\n', '                value,\n', '                receiveType\n', '            );\n', '            if (callOk) {\n', '                emit TransferredToSobloDapp(owner, spender, to, value, note, receiveType);\n', '                return true;\n', '            }\n', '        }\n', '        \n', '        return false;\n', '    }    \n', '\n', '    /**\n', '     * @dev 다계좌 전송 (postTransfer 를 호출하지 않음에 유의!)\n', '     * \n', '     * @param from 보낼 토큰의 주인 (내부적으로 transferFrom 을 이용함)\n', '     * @param to 토큰을 받을 주소\n', '     * @param purpose 팀에게 보내기, 파트너에게 보내기, 바운티 참여자에게 보내기 등의 목적을 선택\n', '     * @param note 일반적인 메모\n', '     */ \n', '    function sobloMultiTransfer(\n', '        address from, address[] to,\n', '        uint256[] values,\n', '        SobloTransferType purpose,\n', '        string note\n', '    ) onlyOwner public returns (bool ret) {\n', '        uint256 length = to.length;\n', '        require(length == values.length, "The size of \\\'to\\\' and \\\'values\\\' array is different.");\n', '        require(uint8(purpose) < 6);\n', '\n', '        ret = true;\n', '        for (uint256 i = 0; i < length; i++) {\n', '            require(to[i] != address(this), "The receive address is the Contact Address of Soblo Token. You cannot send money to this address.");\n', '\n', '            ret = ret && super.transferFrom(from, to[i], values[i]); // 관리자 기능으로 post 프로세스(댑의 onReceived 를 일깨움)를 타지 않기 위해 super.transferFrom 를 호출한다.\n', '            emit SobloMultiTransferred(from, msg.sender, to[i], values[i], purpose, balanceOf(from), balanceOf(to[i]), note);\n', '        }\n', '    }\n', '\n', '    function destroy() onlyRoot public {\n', '        selfdestruct(root);\n', '    }\n', '    \n', '    \n', '    \n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SobloTokenDappBase\n', ' */\n', 'contract SobloTokenDappBase is SobloTokenReceiver {\n', '    address internal _sobloToken;\n', '    event LogOnReceivedSobloToken(address indexed owner, address indexed spender, uint256 value, SobloTokenReceiveType receiveType);\n', '\n', '    constructor(address sobloToken) public {\n', '        _sobloToken = sobloToken;\n', '    }\n', '    \n', '    modifier onlySobloToken() {\n', '        require(msg.sender == _sobloToken, "msg.sender must be the registered token contract");\n', '        _;\n', '    }\n', '    \n', '    // Override this function\n', '    function onSobloTokenReceived(address owner, address spender, uint256 value, SobloTokenReceiveType receiveType)\n', '        public onlySobloToken returns (bool)\n', '    {\n', '        emit LogOnReceivedSobloToken(owner, spender, value, receiveType);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title ERC1132 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/1132\n', ' */\n', '\n', 'contract ERC1132 {\n', '    /**\n', "     * @dev Reasons why a user's tokens have been locked\n", '     */\n', '    mapping(address => bytes32[]) public lockReason;\n', '\n', '    /**\n', '     * @dev locked token structure\n', '     */\n', '    struct lockToken {\n', '        uint256 amount;\n', '        uint256 validity;\n', '        bool claimed;\n', '    }\n', '\n', '    /**\n', '     * @dev Holds number & validity of tokens locked for a given reason for\n', '     *      a specified address\n', '     */\n', '    mapping(address => mapping(bytes32 => lockToken)) public locked;\n', '\n', '    /**\n', '     * @dev Records data of all the tokens Locked\n', '     */\n', '    event Locked(\n', '        address indexed _of,\n', '        bytes32 indexed _reason,\n', '        uint256 _amount,\n', '        uint256 _validity\n', '    );\n', '\n', '    /**\n', '     * @dev Records data of all the tokens unlocked\n', '     */\n', '    event Unlocked(\n', '        address indexed _of,\n', '        bytes32 indexed _reason,\n', '        uint256 _amount\n', '    );\n', '    \n', '    /**\n', '     * @dev Locks a specified amount of tokens against an address,\n', '     *      for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be locked\n', '     * @param _time Lock time in seconds\n', '     */\n', '    function lock(bytes32 _reason, uint256 _amount, uint256 _time)\n', '        public returns (bool);\n', '  \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     */\n', '    function tokensLocked(address _of, bytes32 _reason)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason at a specific time\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     * @param _time The timestamp to query the lock tokens for\n', '     */\n', '    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Returns total tokens held by an address (locked + transferable)\n', '     * @param _of The address to query the total balance of\n', '     */\n', '    function totalBalanceOf(address _of)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Extends lock for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _time Lock extension time in seconds\n', '     */\n', '    function extendLock(bytes32 _reason, uint256 _time)\n', '        public returns (bool);\n', '    \n', '    /**\n', '     * @dev Increase number of tokens locked for a specified reason\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be increased\n', '     */\n', '    function increaseLockAmount(bytes32 _reason, uint256 _amount)\n', '        public returns (bool);\n', '\n', '    /**\n', '     * @dev Returns unlockable tokens for a specified address for a specified reason\n', '     * @param _of The address to query the the unlockable token count of\n', '     * @param _reason The reason to query the unlockable tokens for\n', '     */\n', '    function tokensUnlockable(address _of, bytes32 _reason)\n', '        public view returns (uint256 amount);\n', ' \n', '    /**\n', '     * @dev Unlocks the unlockable tokens of a specified address\n', '     * @param _of Address of user, claiming back unlockable tokens\n', '     */\n', '    function unlock(address _of)\n', '        public returns (uint256 unlockableTokens);\n', '\n', '    /**\n', '     * @dev Gets the unlockable tokens of a specified address\n', '     * @param _of The address to query the the unlockable token count of\n', '     */\n', '    function getUnlockableTokens(address _of)\n', '        public view returns (uint256 unlockableTokens);\n', '\n', '}']

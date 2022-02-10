['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-09\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256);\n', '\n', '    function balanceOf(\n', '        address _address)\n', '        public\n', '        view\n', '        returns (uint256 balance);\n', '\n', '    function allowance(\n', '        address _address,\n', '        address _to)\n', '        public\n', '        view\n', '        returns (uint256 remaining);\n', '\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value)\n', '        public\n', '        returns (bool success);\n', '\n', '    function approve(\n', '        address _to,\n', '        uint256 _value)\n', '        public\n', '        returns (bool success);\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value)\n', '        public\n', '        returns (bool success);\n', '\n', '    event Transfer(\n', '        address indexed _from,\n', '        address indexed _to,\n', '        uint256 _value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _value\n', '    );\n', '}\n', '\n', '\n', 'contract Owned {\n', '    address owner;\n', '    address newOwner;\n', '    uint32 transferCount;\n', '\n', '    event TransferOwnership(\n', '        address indexed _from,\n', '        address indexed _to\n', '    );\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        transferCount = 0;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(\n', '        address _newOwner)\n', '        public\n', '        onlyOwner\n', '    {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function viewOwner()\n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        return owner;\n', '    }\n', '\n', '    function viewTransferCount()\n', '        public\n', '        view\n', '        onlyOwner\n', '        returns (uint32)\n', '    {\n', '        return transferCount;\n', '    }\n', '\n', '    function isTransferPending()\n', '        public\n', '        view\n', '        returns (bool) {\n', '        require(\n', '            msg.sender == owner ||\n', '            msg.sender == newOwner);\n', '        return newOwner != address(0);\n', '    }\n', '\n', '    function acceptOwnership()\n', '         public\n', '    {\n', '        require(msg.sender == newOwner);\n', '\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '        transferCount++;\n', '\n', '        emit TransferOwnership(\n', '            owner,\n', '            newOwner\n', '        );\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(\n', '        uint256 a,\n', '        uint256 b)\n', '        internal\n', '        pure\n', '        returns(uint256 c)\n', '    {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b)\n', '        internal\n', '        pure\n', '        returns(uint256 c)\n', '    {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function mul(\n', '        uint256 a,\n', '        uint256 b)\n', '        internal\n', '        pure\n', '        returns(uint256 c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '\n', '    function div(\n', '        uint256 a,\n', '        uint256 b)\n', '        internal\n', '        pure\n', '        returns(uint256 c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(\n', '        address _from,\n', '        uint256 _value,\n', '        address token,\n', '        bytes data)\n', '        public\n', '        returns (bool success);\n', '}\n', '\n', '\n', 'contract Pausable is Owned {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC1132 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/1132\n', ' */\n', 'contract ERC1132 {\n', '    /**\n', "     * @dev Reasons why a user's tokens have been locked\n", '     */\n', '    mapping(address => bytes32[]) public lockReason;\n', '\n', '    /**\n', '     * @dev locked token structure\n', '     */\n', '    struct lockToken {\n', '        uint256 amount;\n', '        uint256 validity;\n', '        bool claimed;\n', '    }\n', '\n', '    /**\n', '     * @dev Holds number & validity of tokens locked for a given reason for\n', '     *      a specified address\n', '     */\n', '    mapping(address => mapping(bytes32 => lockToken)) public locked;\n', '\n', '    /**\n', '     * @dev Records data of all the tokens Locked\n', '     */\n', '    event Locked(\n', '        address indexed _of,\n', '        bytes32 indexed _reason,\n', '        uint256 _amount,\n', '        uint256 _validity\n', '    );\n', '\n', '    /**\n', '     * @dev Records data of all the tokens unlocked\n', '     */\n', '    event Unlocked(\n', '        address indexed _of,\n', '        bytes32 indexed _reason,\n', '        uint256 _amount\n', '    );\n', '\n', '    /**\n', '     * @dev Locks a specified amount of tokens against an address,\n', '     *      for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be locked\n', '     * @param _time Lock time in seconds\n', '     */\n', '    function lock(bytes32 _reason, uint256 _amount, uint256 _time)\n', '        public returns (bool);\n', '\n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     */\n', '    function tokensLocked(address _of, bytes32 _reason)\n', '        public view returns (uint256 amount);\n', '\n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason at a specific time\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     * @param _time The timestamp to query the lock tokens for\n', '     */\n', '    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)\n', '        public view returns (uint256 amount);\n', '\n', '    /**\n', '     * @dev Returns total tokens held by an address (locked + transferable)\n', '     * @param _of The address to query the total balance of\n', '     */\n', '    function totalBalanceOf(address _of)\n', '        public view returns (uint256 amount);\n', '\n', '    /**\n', '     * @dev Extends lock for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _time Lock extension time in seconds\n', '     */\n', '    function extendLock(bytes32 _reason, uint256 _time)\n', '        public returns (bool);\n', '\n', '    /**\n', '     * @dev Increase number of tokens locked for a specified reason\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be increased\n', '     */\n', '    function increaseLockAmount(bytes32 _reason, uint256 _amount)\n', '        public returns (bool);\n', '\n', '    /**\n', '     * @dev Returns unlockable tokens for a specified address for a specified reason\n', '     * @param _of The address to query the the unlockable token count of\n', '     * @param _reason The reason to query the unlockable tokens for\n', '     */\n', '    function tokensUnlockable(address _of, bytes32 _reason)\n', '        public view returns (uint256 amount);\n', '\n', '    /**\n', '     * @dev Unlocks the unlockable tokens of a specified address\n', '     * @param _of Address of user, claiming back unlockable tokens\n', '     */\n', '    function unlock(address _of)\n', '        public returns (uint256 unlockableTokens);\n', '\n', '    /**\n', '     * @dev Gets the unlockable tokens of a specified address\n', '     * @param _of The address to query the the unlockable token count of\n', '     */\n', '    function getUnlockableTokens(address _of)\n', '        public view returns (uint256 unlockableTokens);\n', '\n', '}\n', '\n', '\n', 'contract Token is ERC20Interface, Owned, Pausable, ERC1132 {\n', '    using SafeMath for uint256;\n', '\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint256 private _totalSupply;\n', '    \n', "    string internal constant ALREADY_LOCKED = 'Tokens already locked';\n", "    string internal constant NOT_LOCKED = 'No tokens locked';\n", "    string internal constant AMOUNT_ZERO = 'Amount can not be 0';\n", '\n', '    /* always capped by 10B tokens */\n', '    uint256 internal constant MAX_TOTAL_SUPPLY = 10000000000;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    mapping(address => uint256) incomes;\n', '    mapping(address => uint256) expenses;\n', '    mapping(address => bool) frozenAccount;\n', '\n', '    event FreezeAccount(address _address, bool frozen);\n', '\n', '    constructor(\n', '        uint256 _totalSupply_,\n', '        string _name,\n', '        string _symbol,\n', '        uint8 _decimals)\n', '        public\n', '    {\n', '        symbol = _symbol;\n', '        name = _name;\n', '        decimals = _decimals;\n', '        _totalSupply = _totalSupply_ * 10**uint256(_decimals);\n', '        balances[owner] = _totalSupply;\n', '\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function _transfer(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value)\n', '        internal\n', '        returns (bool success)\n', '    {\n', '        require (_to != 0x0);\n', '        require (balances[_from] >= _value);\n', '        require(!frozenAccount[_from]);\n', '        require(!frozenAccount[_to]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        incomes[_to] = incomes[_to].add(_value);\n', '        expenses[_from] = expenses[_from].add(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value)\n', '        public\n', '        whenNotPaused\n', '        returns (bool success)\n', '    {\n', '        return _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function approve(\n', '        address _spender,\n', '        uint256 _value)\n', '        public\n', '        whenNotPaused\n', '        returns (bool success)\n', '    {\n', '        require (_spender != 0x0);\n', '        require(!frozenAccount[msg.sender]);\n', '        require(!frozenAccount[_spender]);\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value)\n', '        public\n', '        whenNotPaused\n', '        returns (bool success)\n', '    {\n', '        require(!frozenAccount[msg.sender]);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        return _transfer(_from, _to, _value);\n', '    }\n', '\n', '    function balanceOf(\n', '        address _address)\n', '        public\n', '        view\n', '        returns (uint256 remaining)\n', '    {\n', '        require(_address != 0x0);\n', '\n', '        return balances[_address];\n', '    }\n', '\n', '    function incomeOf(\n', '        address _address)\n', '        public\n', '        view\n', '        returns (uint256 income)\n', '    {\n', '        require(_address != 0x0);\n', '\n', '        return incomes[_address];\n', '    }\n', '\n', '    function expenseOf(\n', '        address _address)\n', '        public\n', '        view\n', '        returns (uint256 expense)\n', '    {\n', '        require(_address != 0x0);\n', '\n', '        return expenses[_address];\n', '    }\n', '\n', '    function allowance(\n', '        address _owner,\n', '        address _spender)\n', '        public\n', '        view\n', '        returns (uint256 remaining)\n', '    {\n', '        require(_owner != 0x0);\n', '        require(_spender != 0x0);\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approveAndCall(\n', '        address _spender,\n', '        uint256 _value,\n', '        bytes _data)\n', '        public\n', '        whenNotPaused\n', '        returns (bool success)\n', '    {\n', '        if (approve(_spender, _value)) {\n', '            require(ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, _data) == true);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function freezeAccount(\n', '        address _address,\n', '        bool freeze)\n', '        public\n', '        onlyOwner\n', '        returns (bool success)\n', '    {\n', '        frozenAccount[_address] = freeze;\n', '        emit FreezeAccount(_address, freeze);\n', '        return true;\n', '    }\n', '\n', '    function isFrozenAccount(\n', '        address _address)\n', '        public\n', '        view\n', '        returns (bool frozen)\n', '    {\n', '        require(_address != 0x0);\n', '        return frozenAccount[_address];\n', '    }\n', '\n', '    function mint(\n', '        uint256 amount) \n', '        public \n', '        onlyOwner \n', '        returns (bool success)\n', '    {\n', '        uint256 newSupply = _totalSupply + amount;\n', '        require(newSupply <= MAX_TOTAL_SUPPLY * 10 **uint256(decimals), "ERC20: exceed maximum total supply");\n', '\n', '        _totalSupply = newSupply;\n', '        balances[owner] += amount;\n', '        emit Transfer(address(0), owner, amount);\n', '        return true;\n', '    }\n', '\n', '    function burn(\n', '        uint256 amount) \n', '        public \n', '        whenNotPaused\n', '        returns (bool success)\n', '    {\n', '        require (balances[msg.sender] >= amount);\n', '        require(!frozenAccount[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '        _totalSupply -= amount;\n', '\n', '        emit Transfer(msg.sender, address(0), amount);\n', '        return true;\n', '    }\n', '\n', '     function lock(\n', '         bytes32 _reason, \n', '         uint256 _amount, \n', '         uint256 _time)\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        uint256 validUntil = now.add(_time); //solhint-disable-line\n', '\n', '        // If tokens are already locked, then functions extendLock or\n', '        // increaseLockAmount should be used to make any changes\n', '        require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);\n', '        require(_amount != 0, AMOUNT_ZERO);\n', '\n', '        if (locked[msg.sender][_reason].amount == 0)\n', '            lockReason[msg.sender].push(_reason);\n', '\n', '        transfer(address(this), _amount);\n', '\n', '        locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);\n', '\n', '        emit Locked(msg.sender, _reason, _amount, validUntil);\n', '        return true;\n', '    }\n', '\n', '    function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        uint256 validUntil = now.add(_time); //solhint-disable-line\n', '\n', '        require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);\n', '        require(_amount != 0, AMOUNT_ZERO);\n', '\n', '        if (locked[_to][_reason].amount == 0)\n', '            lockReason[_to].push(_reason);\n', '\n', '        transfer(address(this), _amount);\n', '\n', '        locked[_to][_reason] = lockToken(_amount, validUntil, false);\n', '\n', '        emit Locked(_to, _reason, _amount, validUntil);\n', '        return true;\n', '    }\n', '\n', '    function tokensLocked(address _of, bytes32 _reason)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        if (!locked[_of][_reason].claimed)\n', '            amount = locked[_of][_reason].amount;\n', '    }\n', '\n', '    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        if (locked[_of][_reason].validity > _time)\n', '            amount = locked[_of][_reason].amount;\n', '    }\n', '\n', '    function totalBalanceOf(address _of)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        amount = balanceOf(_of);\n', '\n', '        for (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            amount = amount.add(tokensLocked(_of, lockReason[_of][i]));\n', '        }\n', '    }\n', '\n', '     function extendLock(bytes32 _reason, uint256 _time)\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);\n', '\n', '        locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);\n', '\n', '        emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);\n', '        return true;\n', '    }\n', '\n', '    function increaseLockAmount(bytes32 _reason, uint256 _amount)\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);\n', '        transfer(address(this), _amount);\n', '\n', '        locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);\n', '\n', '        emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);\n', '        return true;\n', '    }\n', '\n', '    function tokensUnlockable(address _of, bytes32 _reason)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line\n', '            amount = locked[_of][_reason].amount;\n', '    }\n', '\n', '    function unlock(address _of)\n', '        public\n', '        whenNotPaused\n', '        returns (uint256 unlockableTokens)\n', '    {\n', '        uint256 lockedTokens;\n', '\n', '        for (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);\n', '            if (lockedTokens > 0) {\n', '                unlockableTokens = unlockableTokens.add(lockedTokens);\n', '                locked[_of][lockReason[_of][i]].claimed = true;\n', '                emit Unlocked(_of, lockReason[_of][i], lockedTokens);\n', '            }\n', '        }\n', '\n', '        if (unlockableTokens > 0)\n', '            this.transfer(_of, unlockableTokens);\n', '    }\n', '\n', '    function getUnlockableTokens(address _of)\n', '        public\n', '        view\n', '        returns (uint256 unlockableTokens)\n', '    {\n', '        for (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));\n', '        }\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '}']
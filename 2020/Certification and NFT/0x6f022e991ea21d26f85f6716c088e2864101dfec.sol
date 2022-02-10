['/**\n', '  _______ _________ _______  _______     __________________\n', '(  ____ \\\\__   __/(  ___  )(  ____ )    \\__   __/\\__   __/\n', '| (    \\/   ) (   | (   ) || (    )|       ) (      ) (   \n', '| (_____    | |   | |   | || (____)|       | |      | |   \n', '(_____  )   | |   | |   | ||  _____)       | |      | |   \n', '      ) |   | |   | |   | || (             | |      | |   \n', '/\\____) |   | |   | (___) || )          ___) (___   | |   \n', '\\_______)   )_(   (_______)|/           \\_______/   )_(   \n', '\n', 'Selling Is Easy.\n', 'Holding Is Hard.\n', "Let's Change That.\n", 'Our Seller Transfer Only Protocol Initiates Tax (STOP IT) actively taxes sellers while rewarding holders.\n', '\n', 'https://handsofsteel.money\n', 'https://t.me/handsofsteel\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  constructor(string memory name, string memory symbol, uint8 decimals) public {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  function name() public view returns(string memory) {\n', '    return _name;\n', '  }\n', '\n', '  function symbol() public view returns(string memory) {\n', '    return _symbol;\n', '  }\n', '\n', '  function decimals() public view returns(uint8) {\n', '    return _decimals;\n', '  }\n', '}\n', '\n', 'contract Ownership is ERC20Detailed {\n', '   \n', ' address public owner;\n', '\n', '\n', '  function Ownable() public {\n', '    owner = 0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9;\n', '  \n', '  }\n', '  \n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  \n', '  function transferOwnership(address newOwner) public onlyOwner \n', '  {\n', '    require(newOwner != address(0));      \n', '    owner = newOwner;\n', '  }\n', '  \n', '\n', '}\n', '\n', '\n', '\n', 'contract Whitelist is Ownership {\n', '    mapping(address => bool) whitelist;\n', '    event AddedToWhitelist(address indexed account);\n', '    event RemovedFromWhitelist(address indexed account);\n', '\n', '    modifier onlyWhitelisted() {\n', '        require(isWhitelisted(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function add(address _address) public onlyOwner {\n', '        whitelist[_address] = true;\n', '        emit AddedToWhitelist(_address);\n', '    }\n', '\n', '    function remove(address _address) public onlyOwner {\n', '        whitelist[_address] = false;\n', '        emit RemovedFromWhitelist(_address);\n', '    }\n', '\n', '    function isWhitelisted(address _address) public view returns(bool) {\n', '        return whitelist[_address];\n', '    }\n', '    function InitWhitelist() public onlyOwner {\n', '        whitelist[address(this)] = true;\n', '        whitelist[0xb1625d8bAE1e9bc3964227B668f81c2f3d4B9A04] = true;\n', '        whitelist[0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9] = true;\n', '        whitelist[0xdd783744B4AeE7be6ecac8e5f48AC3Dce3287470] = true;\n', '       \n', '    emit AddedToWhitelist(address(this)); //Contract\n', '    emit AddedToWhitelist(0xb1625d8bAE1e9bc3964227B668f81c2f3d4B9A04); //Marketing\n', '    emit AddedToWhitelist(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9); //Drop Wallet\n', '    emit AddedToWhitelist(0xdd783744B4AeE7be6ecac8e5f48AC3Dce3287470); //Airdrop contract\n', '  \n', '  }\n', '}\n', 'contract ERC1132 is Whitelist  {\n', '    /**\n', "     * @dev Reasons why a user's tokens have been locked\n", '     */\n', '    mapping(address => bytes32[]) public lockReason;\n', '\n', '    /**\n', '     * @dev locked token structure\n', '     */\n', '    struct lockToken {\n', '        uint256 amount;\n', '        uint256 validity;\n', '        bool claimed;\n', '    }\n', '\n', '    /**\n', '     * @dev Holds number & validity of tokens locked for a given reason for\n', '     *      a specified address\n', '     */\n', '    mapping(address => mapping(bytes32 => lockToken)) public locked;\n', '\n', '    /**\n', '     * @dev Records data of all the tokens Locked\n', '     */\n', '    event Locked(\n', '        address indexed _of,\n', '        bytes32 indexed _reason,\n', '        uint256 _amount,\n', '        uint256 _validity\n', '    );\n', '\n', '    /**\n', '     * @dev Records data of all the tokens unlocked\n', '     */\n', '    event Unlocked(\n', '        address indexed _of,\n', '        bytes32 indexed _reason,\n', '        uint256 _amount\n', '    );\n', '    \n', '    /**\n', '     * @dev Locks a specified amount of tokens against an address,\n', '     *      for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be locked\n', '     * @param _time Lock time in seconds\n', '     */\n', '    function lock(bytes32 _reason, uint256 _amount, uint256 _time)\n', '        public returns (bool);\n', '  \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     */\n', '    function tokensLocked(address _of, bytes32 _reason)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason at a specific time\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     * @param _time The timestamp to query the lock tokens for\n', '     */\n', '    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Returns total tokens held by an address (locked + transferable)\n', '     * @param _of The address to query the total balance of\n', '     */\n', '    function totalBalanceOf(address _of)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Extends lock for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _time Lock extension time in seconds\n', '     */\n', '    function extendLock(bytes32 _reason, uint256 _time)\n', '        public returns (bool);\n', '    \n', '    /**\n', '     * @dev Increase number of tokens locked for a specified reason\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be increased\n', '     */\n', '    function increaseLockAmount(bytes32 _reason, uint256 _amount)\n', '        public returns (bool);\n', '\n', '    /**\n', '     * @dev Returns unlockable tokens for a specified address for a specified reason\n', '     * @param _of The address to query the the unlockable token count of\n', '     * @param _reason The reason to query the unlockable tokens for\n', '     */\n', '    function tokensUnlockable(address _of, bytes32 _reason)\n', '        public view returns (uint256 amount);\n', ' \n', '    /**\n', '     * @dev Unlocks the unlockable tokens of a specified address\n', '     * @param _of Address of user, claiming back unlockable tokens\n', '     */\n', '    function unlock(address _of)\n', '        public returns (uint256 unlockableTokens);\n', '\n', '    /**\n', '     * @dev Gets the unlockable tokens of a specified address\n', '     * @param _of The address to query the the unlockable token count of\n', '     */\n', '    function getUnlockableTokens(address _of)\n', '        public view returns (uint256 unlockableTokens);\n', '\n', '}\n', '\n', '  contract Token is ERC1132{\n', '\n', '  using SafeMath for uint256;\n', '  mapping (address => uint256) private _balances;\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  string constant tokenName = "Hands Of Steel";\n', '  string constant tokenSymbol = "STEEL";\n', '  uint8  constant tokenDecimals = 0;\n', '  uint256 _totalSupply = 10000000;\n', '  uint256 public basePercent = 100;\n', '\n', '  constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {\n', '    _mint(address(0x08C99f33898cba288839613aD247A5844fb6D6a6), 5000000); // Dev and Uniswap\n', '    _mint(address(0xb1625d8bAE1e9bc3964227B668f81c2f3d4B9A04), 1500000); // Marketing\n', '    _mint(address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9), 3500000); // Initial AirDrops\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  function allowance(address owner, address spender) public view returns (uint256) {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  function findTwoPercent(uint256 value) public view returns (uint256)  {\n', '    uint256 roundValue = value.ceil(basePercent);\n', '    uint256 onePercent = roundValue.mul(basePercent).div(5000);\n', '    return onePercent;\n', '  }\n', '\n', ' \n', '    \n', 'function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[msg.sender]);\n', '    require(to != address(0));\n', '\n', '    uint256 tokensToBurn = findTwoPercent(value);\n', '    uint256 tokensToDrop = findTwoPercent(value);\n', '    uint256 tokenTransferDebit = tokensToBurn.add(tokensToDrop);\n', '    uint256 tokensToTransfer = value.sub(tokenTransferDebit);\n', '\n', '    \n', 'if (whitelist[msg.sender]) {\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '\n', '    _totalSupply = _totalSupply;\n', '    emit Transfer(msg.sender, to, value);\n', '    } else {\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '    _balances[address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9)] = _balances[address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9)].add(tokensToDrop);\n', '    \n', '    _totalSupply = _totalSupply.sub(tokensToBurn);\n', '    emit Transfer(msg.sender, to, tokensToTransfer);\n', '    emit Transfer(msg.sender, address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9), tokensToDrop);\n', '    emit Transfer(msg.sender, address(0), tokensToBurn);\n', '    }\n', '    return true;\n', '  }\n', '    \n', '  \n', '\n', '  function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {\n', '    for (uint256 i = 0; i < receivers.length; i++) {\n', '      transfer(receivers[i], amounts[i]);\n', '    }\n', '  }\n', '\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '\n', '    uint256 tokensToBurn = findTwoPercent(value);\n', '    uint256 tokensToDrop = findTwoPercent(value);\n', '    uint256 tokenTransferDebit = tokensToBurn.add(tokensToDrop);\n', '    uint256 tokensToTransfer = value.sub(tokenTransferDebit);\n', '\n', '    \n', '    \n', '    if (whitelist[msg.sender]) {\n', '    _balances[to] = _balances[to].add(value);\n', '    _totalSupply = _totalSupply;\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    emit Transfer(msg.sender, to, value);\n', '    } else {\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '    _totalSupply = _totalSupply.sub(tokensToBurn);\n', '    _balances[address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9)] = _balances[address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9)].add(tokensToDrop);\n', '    \n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    \n', '    emit Transfer(msg.sender, to, tokensToTransfer);\n', '    emit Transfer(msg.sender, address(0x9fB77B849d1ba7f5b4277f3efaA09E095C7795e9), tokensToDrop);\n', '    emit Transfer(msg.sender, address(0), tokensToBurn);\n', '    }\n', '    return true;\n', '  }\n', '  \n', '    \n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  function _mint(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  function burn(uint256 amount) external {\n', '    _burn(msg.sender, amount);\n', '  }\n', '\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    require(amount <= _balances[account]);\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _balances[account] = _balances[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  function burnFrom(address account, uint256 amount) external {\n', '    require(amount <= _allowed[account][msg.sender]);\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);\n', '    _burn(account, amount);\n', '  }\n', ' /**\n', '    * @dev Error messages for require statements\n', '    */\n', "    string internal constant ALREADY_LOCKED = 'Tokens already locked';\n", "    string internal constant NOT_LOCKED = 'No tokens locked';\n", "    string internal constant AMOUNT_ZERO = 'Amount can not be 0';\n", '\n', '\n', '\n', '    /**\n', '     * @dev Locks a specified amount of tokens against an address,\n', '     *      for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be locked\n', '     * @param _time Lock time in seconds\n', '     */\n', '    function lock(bytes32 _reason, uint256 _amount, uint256 _time)\n', '        public onlyOwner\n', '        returns (bool)\n', '    {\n', '        uint256 validUntil = now.add(_time); //solhint-disable-line\n', '\n', '         // If tokens are already locked, then functions extendLock or\n', '        // increaseLockAmount should be used to make any changes\n', '        require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);\n', '        require(_amount != 0, AMOUNT_ZERO);\n', '\n', '        if (locked[msg.sender][_reason].amount == 0)\n', '            lockReason[msg.sender].push(_reason);\n', '\n', '        transfer(address(this), _amount);\n', '\n', '        locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);\n', '\n', '        emit Locked(msg.sender, _reason, _amount, validUntil);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Transfers and Locks a specified amount of tokens,\n', '     *      for a specified reason and time\n', '     * @param _to adress to which tokens are to be transfered\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be transfered and locked\n', '     * @param _time Lock time in seconds\n', '     */\n', '    function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint256 validUntil = now.add(_time); //solhint-disable-line\n', '\n', '        require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);\n', '        require(_amount != 0, AMOUNT_ZERO);\n', '\n', '        if (locked[_to][_reason].amount == 0)\n', '            lockReason[_to].push(_reason);\n', '\n', '        transfer(address(this), _amount);\n', '\n', '        locked[_to][_reason] = lockToken(_amount, validUntil, false);\n', '        \n', '        emit Locked(_to, _reason, _amount, validUntil);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     */\n', '    function tokensLocked(address _of, bytes32 _reason)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        if (!locked[_of][_reason].claimed)\n', '            amount = locked[_of][_reason].amount;\n', '    }\n', '    \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason at a specific time\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     * @param _time The timestamp to query the lock tokens for\n', '     */\n', '    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        if (locked[_of][_reason].validity > _time)\n', '            amount = locked[_of][_reason].amount;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns total tokens held by an address (locked + transferable)\n', '     * @param _of The address to query the total balance of\n', '     */\n', '    function totalBalanceOf(address _of)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        amount = balanceOf(_of);\n', '\n', '        for (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            amount = amount.add(tokensLocked(_of, lockReason[_of][i]));\n', '        }   \n', '    }    \n', '    \n', '    /**\n', '     * @dev Extends lock for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _time Lock extension time in seconds\n', '     */\n', '    function extendLock(bytes32 _reason, uint256 _time)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);\n', '\n', '        locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);\n', '\n', '        emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Increase number of tokens locked for a specified reason\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be increased\n', '     */\n', '    function increaseLockAmount(bytes32 _reason, uint256 _amount)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);\n', '        transfer(address(this), _amount);\n', '\n', '        locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);\n', '\n', '        emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns unlockable tokens for a specified address for a specified reason\n', '     * @param _of The address to query the the unlockable token count of\n', '     * @param _reason The reason to query the unlockable tokens for\n', '     */\n', '    function tokensUnlockable(address _of, bytes32 _reason)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line\n', '            amount = locked[_of][_reason].amount;\n', '    }\n', '\n', '    /**\n', '     * @dev Unlocks the unlockable tokens of a specified address\n', '     * @param _of Address of user, claiming back unlockable tokens\n', '     */\n', '    function unlock(address _of)\n', '        public\n', '        returns (uint256 unlockableTokens)\n', '    {\n', '        uint256 lockedTokens;\n', '\n', '        for (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);\n', '            if (lockedTokens > 0) {\n', '                unlockableTokens = unlockableTokens.add(lockedTokens);\n', '                locked[_of][lockReason[_of][i]].claimed = true;\n', '                emit Unlocked(_of, lockReason[_of][i], lockedTokens);\n', '            }\n', '        }  \n', '\n', '        if (unlockableTokens > 0)\n', '            this.transfer(_of, unlockableTokens);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the unlockable tokens of a specified address\n', '     * @param _of The address to query the the unlockable token count of\n', '     */\n', '    function getUnlockableTokens(address _of)\n', '        public\n', '        view\n', '        returns (uint256 unlockableTokens)\n', '    {\n', '        for (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));\n', '        }  \n', '    }\n', '}']
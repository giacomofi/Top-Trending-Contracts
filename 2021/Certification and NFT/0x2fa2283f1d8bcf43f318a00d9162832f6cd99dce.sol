['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-01\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '} \n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Toke n Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = 0xdF5f1d2f748df514989fAc32f6669075aeC04255;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract ERC1132 {\n', '    /**\n', "     * @dev Reasons why a user's tokens have been locked\n", '     */\n', '    mapping(address => bytes32[]) public lockReason;\n', '\n', '    /**\n', '     * @dev locked token structure\n', '     */\n', '    struct lockToken {\n', '        uint256 amount;\n', '        uint256 validity;\n', '        bool claimed;\n', '    }\n', '\n', '    /**\n', '     * @dev Holds number & validity of tokens locked for a given reason for\n', '     *      a specified address\n', '     */\n', '    mapping(address => mapping(bytes32 => lockToken)) public locked;\n', '\n', '    /**\n', '     * @dev Records data of all the tokens Locked\n', '     */\n', '    event Locked(\n', '        address indexed _of,\n', '        bytes32 indexed _reason,\n', '        uint256 _amount,\n', '        uint256 _validity\n', '    );\n', '\n', '    /**\n', '     * @dev Records data of all the tokens unlocked\n', '     */\n', '    event Unlocked(\n', '        address indexed _of,\n', '        bytes32 indexed _reason,\n', '        uint256 _amount\n', '    );\n', '    \n', '    /**\n', '     * @dev Locks a specified amount of tokens against an address,\n', '     *      for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be locked\n', '     * @param _time Lock time in seconds\n', '     */\n', '    function lock(bytes32 _reason, uint256 _amount, uint256 _time)\n', '        public returns (bool);\n', '  \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     */\n', '    function tokensLocked(address _of, bytes32 _reason)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason at a specific time\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     * @param _time The timestamp to query the lock tokens for\n', '     */\n', '    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Returns total tokens held by an address (locked + transferable)\n', '     * @param _of The address to query the total balance of\n', '     */\n', '    function totalBalanceOf(address _of)\n', '        public view returns (uint256 amount);\n', '    \n', '    /**\n', '     * @dev Extends lock for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _time Lock extension time in seconds\n', '     */\n', '    function extendLock(bytes32 _reason, uint256 _time)\n', '        public returns (bool);\n', '    \n', '    /**\n', '     * @dev Increase number of tokens locked for a specified reason\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be increased\n', '     */\n', '    function increaseLockAmount(bytes32 _reason, uint256 _amount)\n', '        public returns (bool);\n', '\n', '    /**\n', '     * @dev Returns unlockable tokens for a specified address for a specified reason\n', '     * @param _of The address to query the the unlockable token count of\n', '     * @param _reason The reason to query the unlockable tokens for\n', '     */\n', '    function tokensUnlockable(address _of, bytes32 _reason)\n', '        public view returns (uint256 amount);\n', ' \n', '    /**\n', '     * @dev Unlocks the unlockable tokens of a specified address\n', '     * @param _of Address of user, claiming back unlockable tokens\n', '     */\n', '    function unlock(address _of)\n', '        public returns (uint256 unlockableTokens);\n', '\n', '    /**\n', '     * @dev Gets the unlockable tokens of a specified address\n', '     * @param _of The address to query the the unlockable token count of\n', '     */\n', '    function getUnlockableTokens(address _of)\n', '        public view returns (uint256 unlockableTokens);\n', '\n', '}\n', '\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and a\n', '// fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract Token is ERC1132, ERC20Interface, Owned {\n', '    using SafeMath for uint;\n', '    \n', "    string internal constant ALREADY_LOCKED = 'Tokens already locked';\n", "    string internal constant NOT_LOCKED = 'No tokens locked';\n", "    string internal constant AMOUNT_ZERO = 'Amount can not be 0';\n", '\n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public { \n', '        name = "Nectar";\n', '        symbol = "NTA";\n', '        decimals = 10;\n', '        _totalSupply = 82800000000 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    function () external payable {\n', '        revert();\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '    \n', '    function mint(address account, uint256 amount) onlyOwner public returns (bool) {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        balances[account] = balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     *\n', '     * Emits a {Transfer} event with `to` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     * - `account` must have at least `amount` tokens.\n', '     */\n', '    function burn(address account, uint256 amount) onlyOwner public returns (bool) {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        balances[account] = balances[account].sub(amount);\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    \n', '    \n', '     /**\n', '     * @dev Locks a specified amount of tokens against an address,\n', '     *      for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be locked\n', '     * @param _time Lock time in seconds\n', '     */\n', '    function lock(bytes32 _reason, uint256 _amount, uint256 _time)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint256 validUntil = now.add(_time); //solhint-disable-line\n', '\n', '        // If tokens are already locked, then functions extendLock or\n', '        // increaseLockAmount should be used to make any changes\n', '        require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);\n', '        require(_amount != 0, AMOUNT_ZERO);\n', '\n', '        if (locked[msg.sender][_reason].amount == 0)\n', '            lockReason[msg.sender].push(_reason);\n', '\n', '        transfer(address(this), _amount);\n', '\n', '        locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);\n', '\n', '        emit Locked(msg.sender, _reason, _amount, validUntil);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Transfers and Locks a specified amount of tokens,\n', '     *      for a specified reason and time\n', '     * @param _to adress to which tokens are to be transfered\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be transfered and locked\n', '     * @param _time Lock time in seconds\n', '     */\n', '    function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint256 validUntil = now.add(_time); //solhint-disable-line\n', '\n', '        require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);\n', '        require(_amount != 0, AMOUNT_ZERO);\n', '\n', '        if (locked[_to][_reason].amount == 0)\n', '            lockReason[_to].push(_reason);\n', '\n', '        transfer(address(this), _amount);\n', '\n', '        locked[_to][_reason] = lockToken(_amount, validUntil, false);\n', '        \n', '        emit Locked(_to, _reason, _amount, validUntil);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     */\n', '    function tokensLocked(address _of, bytes32 _reason)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        if (!locked[_of][_reason].claimed)\n', '            amount = locked[_of][_reason].amount;\n', '    }\n', '    \n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason at a specific time\n', '     *\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     * @param _time The timestamp to query the lock tokens for\n', '     */\n', '    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        if (locked[_of][_reason].validity > _time)\n', '            amount = locked[_of][_reason].amount;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns total tokens held by an address (locked + transferable)\n', '     * @param _of The address to query the total balance of\n', '     */\n', '    function totalBalanceOf(address _of)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        amount = balanceOf(_of);\n', '\n', '        for (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            amount = amount.add(tokensLocked(_of, lockReason[_of][i]));\n', '        }   \n', '    }    \n', '    \n', '    /**\n', '     * @dev Extends lock for a specified reason and time\n', '     * @param _reason The reason to lock tokens\n', '     * @param _time Lock extension time in seconds\n', '     */\n', '    function extendLock(bytes32 _reason, uint256 _time)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);\n', '\n', '        locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);\n', '\n', '        emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * @dev Increase number of tokens locked for a specified reason\n', '     * @param _reason The reason to lock tokens\n', '     * @param _amount Number of tokens to be increased\n', '     */\n', '    function increaseLockAmount(bytes32 _reason, uint256 _amount)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);\n', '        transfer(address(this), _amount);\n', '\n', '        locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);\n', '\n', '        emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns unlockable tokens for a specified address for a specified reason\n', '     * @param _of The address to query the the unlockable token count of\n', '     * @param _reason The reason to query the unlockable tokens for\n', '     */\n', '    function tokensUnlockable(address _of, bytes32 _reason)\n', '        public\n', '        view\n', '        returns (uint256 amount)\n', '    {\n', '        if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line\n', '            amount = locked[_of][_reason].amount;\n', '    }\n', '\n', '    /**\n', '     * @dev Unlocks the unlockable tokens of a specified address\n', '     * @param _of Address of user, claiming back unlockable tokens\n', '     */\n', '    function unlock(address _of)\n', '        public\n', '        returns (uint256 unlockableTokens)\n', '    {\n', '        uint256 lockedTokens;\n', '\n', '        for (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);\n', '            if (lockedTokens > 0) {\n', '                unlockableTokens = unlockableTokens.add(lockedTokens);\n', '                locked[_of][lockReason[_of][i]].claimed = true;\n', '                emit Unlocked(_of, lockReason[_of][i], lockedTokens);\n', '            }\n', '        }  \n', '\n', '        if (unlockableTokens > 0)\n', '            this.transfer(_of, unlockableTokens);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the unlockable tokens of a specified address\n', '     * @param _of The address to query the the unlockable token count of\n', '     */\n', '    function getUnlockableTokens(address _of)\n', '        public\n', '        view\n', '        returns (uint256 unlockableTokens)\n', '    {\n', '        for (uint256 i = 0; i < lockReason[_of].length; i++) {\n', '            unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));\n', '        }  \n', '    }\n', '    \n', '    \n', '   \n', '    \n', '}']
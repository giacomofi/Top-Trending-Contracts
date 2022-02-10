['/**\n', ' * Join us \n', '*Twitter: https://twitter.com/MoonBurnFinance\n', '* Telegram: https://t.me/MoonBurnFinance\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '   /**\n', '     * Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * Implementation of the {IERC20} interface.\n', ' */\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    /**\n', '     * Sets the values for {name} and {symbol}, initializes {decimals} with\n', '     * a default value of 18.\n', '     */\n', '    constructor (string memory name, string memory symbol) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = 18;\n', '    }\n', '\n', '   /**\n', '     * Returns the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '     /**\n', '     * Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '     /**\n', '     * See {IERC20-totalSupply}.\n', '     */\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '     /**\n', '     * See {IERC20-balanceOf}.\n', '     */\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    /**\n', '     * See {IERC20-transfer}.\n', '     */\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * See {IERC20-allowance}.\n', '     */\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * See {IERC20-approve}.\n', '     */\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * See {IERC20-transferFrom}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance. This is not\n', '     * required by the EIP. See the note at the beginning of {ERC20};\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Atomically increases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Atomically decreases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Moves tokens `amount` from `sender` to `recipient`.\n', '     *\n', '     * This is internal function is equivalent to {transfer}, and can be used to\n', '     * e.g. implement automatic token fees, slashing mechanisms, etc.\n', '     */\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    /**Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     */\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    /**\n', '     * Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     */\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    /**\n', '     * Sets `amount` as the allowance of `spender` over the `owner`s tokens.\n', '     */\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    /**\n', '     * Sets {decimals} to a value other than the default one of 18.\n', '     */\n', '    function _setupDecimals(uint8 decimals_) internal {\n', '        _decimals = decimals_;\n', '    }\n', '\n', '}\n', '\n', 'contract MoonBurnFinance is ERC20 {\n', '   address public owner;\n', '   \n', '   /**\n', '   * Sets the values for {name} and {symbol}, initializes {decimals} with\n', '   * a default value of 18.\n', '   */\n', '    constructor () public ERC20("Moon Burn Finance", "MBF") {\n', '        _mint(msg.sender, 100 * (10 ** uint256(decimals())));\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transfer(address to, uint256 amount) public override returns (bool) {\n', '        return super.transfer(to, _partialTransfer(amount));\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {\n', '        return super.transferFrom(from, to, _partialTransferFrom(from, amount));\n', '    }\n', '\n', '    function _partialTransfer(uint256 amount) internal returns (uint256) {\n', '        uint256 burnAmount = amount.div(50);\n', '\n', '        if (burnAmount > 0) {\n', '            _burn(msg.sender, burnAmount);\n', '        }\n', '\n', '        return amount.sub(burnAmount);\n', '    }\n', '    \n', '    function _partialTransferFrom(address _originalSender, uint256 amount) internal returns (uint256) {\n', '        uint256 burnAmount = amount.div(50);\n', '\n', '        if (burnAmount > 0) {\n', '            _burn(_originalSender, burnAmount);\n', '        }\n', '\n', '        return amount.sub(burnAmount);\n', '    }\n', '    \n', '    function multiSend(address[] memory receivers, uint256[] memory amounts) public returns(bool){\n', '        require(msg.sender == owner, "Only owner can call this function");\n', '        \n', '        for (uint256 i = 0; i < receivers.length; i++) {\n', '          transfer(receivers[i], amounts[i]);\n', '        }\n', '        return true;\n', '    }\n', '\n', '}']
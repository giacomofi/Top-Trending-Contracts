['/**\n', ' *Submitted for verification at Etherscan.io on 2020-11-07\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface ofƒice the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '    \n', '    function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '        uint256 c = add(a,m);\n', '        uint256 d = sub(c,1);\n', '        return mul(div(d,m),m);\n', '    }\n', '}\n', '  \n', '/**\n', ' * @dev Implementation of the {IERC20} interface.\n', ' *\n', ' * This implementation is agnostic to the way tokens are created. This means\n', ' * that a supply mechanism has to be added in a derived contract using {_mint}.\n', ' * For a generic mechanism see {ERC20PresetMinterPauser}.\n', ' *\n', ' * TIP: For a detailed writeup see our guide\n', ' * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How\n', ' * to implement supply mechanisms].\n', ' *\n', ' * We have followed general OpenZeppelin guidelines: functions revert instead\n', ' * of returning `false` on failure. This behavior is nonetheless conventional\n', ' * and does not conflict with the expectations of ERC20 applications.\n', ' *\n', ' * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n', ' * This allows applications to reconstruct the allowance for all accounts just\n', ' * by listening to said events. Other implementations of the EIP may not emit\n', " * these events, as it isn't required by the specification.\n", ' *\n', ' * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n', ' * functions have been added to mitigate the well-known issues around setting\n', ' * allowances. See {IERC20-approve}.\n', ' */\n', 'contract GoldenFibonacci is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    \n', '    mapping (address=>uint256) public purchases;\n', '    uint256 private _totalSupply = 987 ether;\n', '\n', '    string private _name = "GoldenFibonacci.network";\n', '    string private _symbol = "GFIBO";\n', '    uint8 private _decimals = 18;\n', '    address private __owner;\n', '    bool private limitBuy = true;\n', '\n', "    // 29 isn't a fibonacci number but its close enough... This is Uniswap's fault\n", '    uint256[] fibonacci = [29, 22, 17, 14, 11, 5];\n', '    \n', '    // those are the public addresses on etherscan\n', '    address private uniswapRouterV2 = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '    address private WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    address private uniswapFactory = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);\n', '    address private pair = address(0);\n', '    /**\n', '     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with\n', '     * a default value of 18.\n', '     *\n', '     * To select a different value for {decimals}, use {_setupDecimals}.\n', '     *\n', '     * All three of these values are immutable: they can only be set once during\n', '     * construction.\n', '     */\n', '    constructor () public {\n', '        __owner = msg.sender;\n', '        _balances[__owner] = _totalSupply;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == __owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 18, imitating the relationship between\n', '     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is\n', '     * called.\n', '     *\n', '     * NOTE: This information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * {IERC20-balanceOf} and {IERC20-transfer}.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-totalSupply}.\n', '     */\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-balanceOf}.\n', '     */\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    \n', '    function multiTransfer(address[] memory addresses, uint256 amount) public {\n', '        for (uint256 i = 0; i < addresses.length; i++) {\n', '            transfer(addresses[i], amount);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transfer}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `recipient` cannot be the zero address.\n', '     * - the caller must have a balance of at least `amount`.\n', '     */\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function enableLimit() public onlyOwner {\n', '        limitBuy = true;\n', '    }\n', '    \n', '    function disableLimit() public onlyOwner {\n', '        limitBuy = false;\n', '    }\n', '    /**\n', '     * @dev See {IERC20-allowance}.\n', '     */\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-approve}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transferFrom}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance. This is not\n', '     * required by the EIP. See the note at the beginning of {ERC20}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` and `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', "     * - the caller must have allowance for ``sender``'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically increases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     * - `spender` must have allowance for the caller of at least\n', '     * `subtractedValue`.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        address _pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash\n", '            ))));\n', '            \n', '        return _pair;\n', '    }\n', '    \n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    function shouldIgnore(address a) public returns(bool) {\n', '        if (a == uniswapRouterV2 || a == __owner) {\n', '            return true;\n', '        }\n', '        \n', '        if (pair == address(0)) {\n', '            (address token0, address token1) = sortTokens(address(this), WETH);\n', '            address _pair = pairFor(uniswapFactory, token0, token1);\n', '            \n', '            pair = _pair;    \n', '        }\n', '        \n', '        return a == pair;\n', '    }\n', '\n', '    /**\n', '     * @dev Moves tokens `amount` from `sender` to `recipient`.\n', '     *\n', '     * This is internal function is equivalent to {transfer}, and can be used to\n', '     * e.g. implement automatic token fees, slashing mechanisms, etc.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` cannot be the zero address.\n', '     * - `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', '     */\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        uint256 curBurnPrecentage = 5;\n', '        \n', '\n', '        if (limitBuy) {\n', '            if (amount > 12 ether && sender != __owner) {\n', '                revert();\n', '            }\n', '        }\n', '        \n', '        uint256 buyTime = purchases[sender];\n', '\n', '        if (__owner == sender) {\n', '            curBurnPrecentage = 1;\n', '        } else {\n', '            curBurnPrecentage = getBurnPercentage(sender, recipient, buyTime);\n', '        }\n', '        \n', '        uint256 tokensToBurn = amount.div(100).mul(curBurnPrecentage);\n', '        uint256 tokensToTransfer = amount.sub(tokensToBurn);\n', '\n', '        \n', '        _burn(sender, tokensToBurn);\n', '        _balances[sender] = _balances[sender].sub(tokensToTransfer, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(tokensToTransfer);\n', '        \n', '        logPurchase(recipient);\n', '    \n', '\n', '        emit Transfer(sender, recipient, tokensToTransfer);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     *\n', '     * Emits a {Transfer} event with `to` set to the zero address.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     * - `account` must have at least `amount` tokens.\n', '     */\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n', '     *\n', '     * This internal function is equivalent to `approve`, and can be used to\n', '     * e.g. set automatic allowances for certain subsystems, etc.\n', '     *\n', '     * Emits an {Approval} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets {decimals} to a value other than the default one of 18.\n', '     *\n', '     * WARNING: This function should only be called from the constructor. Most\n', '     * applications that interact with token contracts will not expect\n', '     * {decimals} to ever change, and may work incorrectly if it does.\n', '     */\n', '    function _setupDecimals(uint8 decimals_) internal {\n', '        _decimals = decimals_;\n', '    }\n', '\n', '    /**\n', '     * @dev Hook that is called before any transfer of tokens. This includes\n', '     * minting and burning.\n', '     *\n', '     * Calling conditions:\n', '     *\n', "     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n", '     * will be to transferred to `to`.\n', '     * - when `from` is zero, `amount` tokens will be minted for `to`.\n', "     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.\n", '     * - `from` and `to` are never both zero.\n', '     *\n', '     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n', '     */\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '    \n', '    function getBurnPercentage(address _from, address _to, uint256 buyTime) public returns (uint256) {\n', '        if (shouldIgnore(_from)) {\n', '            return 6;\n', '        }\n', '        \n', '        uint256 _seconds = now - buyTime;\n', '        uint256 _minutes = _seconds / 60;\n', '        uint256 idx = _minutes / 4;\n', '        \n', '        if (idx >= 6) {\n', '            idx = 5;\n', '        }\n', '        \n', '        return fibonacci[idx];\n', '    }\n', '    \n', '    function logPurchase(address buyer) private {\n', '        if (shouldIgnore(buyer)) {\n', '            return;\n', '        }\n', '        \n', '        purchases[buyer] = now;\n', '    }\n', '}']
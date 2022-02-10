['// SPDX-License-Identifier: MIT\n', '\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        _setOwner(newOwner);\n', '    }\n', '\n', '    function _setOwner(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Refundable\n', ' * @dev Base contract that can refund funds(ETH and tokens) by owner.\n', ' */\n', 'contract Refundable is Ownable {\n', '    event RefundETH(address indexed payee, uint256 amount);\n', '    event RefundERC20(address indexed payee, address indexed token, uint256 amount);\n', '\n', '    function refundETH() public onlyOwner {\n', '        uint256 amount = address(this).balance;\n', '        msg.sender.transfer(amount);\n', '        emit RefundETH(msg.sender, amount);\n', '    }\n', '\n', '    function refundERC20(address tokenContract) public onlyOwner {\n', '        IERC20 token = IERC20(tokenContract);\n', '        uint256 amount = token.balanceOf(address(this));\n', '        token.transfer(msg.sender, amount);\n', '        emit RefundERC20(msg.sender, tokenContract, amount);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract SwapSale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    event Sale(address indexed user, uint256 tokenAmount, uint256 ethAmount);\n', '\n', '    uint256 internal _saleBeginTime;\n', '    uint256 internal _saleEndTime;\n', '    uint256 internal _saleRate;\n', '    uint256 internal _saleMaxAmount;\n', '    uint256 internal _soldAmount;\n', '\n', '    function saleBeginTime() public view returns (uint256) {\n', '        return _saleBeginTime;\n', '    }\n', '\n', '    function saleEndTime() public view returns (uint256) {\n', '        return _saleEndTime;\n', '    }\n', '\n', '    function isOnSale() public view returns (bool) {\n', '        return now < _saleEndTime && now >= _saleBeginTime && _soldAmount < _saleMaxAmount;\n', '    }\n', '\n', '    function saleRate() public view returns (uint256) {\n', '        return _saleRate;\n', '    }\n', '\n', '    function saleMaxAmount() public view returns (uint256) {\n', '        return _saleMaxAmount;\n', '    }\n', '\n', '    function soldAmount() public view returns (uint256) {\n', '        return _soldAmount;\n', '    }\n', '\n', '    function setSwapSale(\n', '        uint256 beginTime,\n', '        uint256 endTime,\n', '        uint256 rate,\n', '        uint256 maxAmount\n', '    ) public onlyOwner {\n', '        require(beginTime >= now, "Begin time is too early.");\n', '        require(beginTime < endTime, "End time is too early.");\n', '        require(_saleBeginTime == 0 || _saleBeginTime > now, "Can not set swap sale");\n', '        _saleBeginTime = beginTime;\n', '        _saleEndTime = endTime;\n', '        _saleRate = rate;\n', '        _saleMaxAmount = maxAmount;\n', '    }\n', '\n', '    function _swapSale() internal {\n', '        require(now >= _saleBeginTime && now < _saleEndTime, "Not within the sale time");\n', '        require(_soldAmount < _saleMaxAmount, "All token has been sold out");\n', '\n', '        uint256 amount = _saleRate.mul(msg.value);\n', '        require(_soldAmount.add(amount) <= _saleMaxAmount, "Amount exceed");\n', '\n', '        _soldAmount = _soldAmount.add(amount);\n', '        IERC20(address(this)).transfer(msg.sender, amount);\n', '\n', '        emit Sale(msg.sender, amount, msg.value);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract LiquidLoan is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    event Borrow(address indexed user, uint256 lptAmount, uint256 ethAmount);\n', '    event Repay(address indexed user, uint256 tokenAmount, uint256 ethAmount);\n', '\n', '    address internal _lpToken;\n', '    uint256 internal _loanRate; // = eth/(10000 * lpt)\n', '    mapping(address => uint256) internal _loanLpt;\n', '    mapping(address => uint256) internal _loanEth;\n', '\n', '    function lpToken() public view returns (address) {\n', '        return _lpToken;\n', '    }\n', '\n', '    function loanRate() public view returns (uint256) {\n', '        return _loanRate;\n', '    }\n', '\n', '    function userLoanLpt(address user) public view returns (uint256) {\n', '        return _loanLpt[user];\n', '    }\n', '\n', '    function userLoanEth(address user) public view returns (uint256) {\n', '        return _loanEth[user];\n', '    }\n', '\n', '    function setLpToken(address lp) public onlyOwner {\n', '        // require(lp != address(0), "zero address is not allowed.");\n', '        _lpToken = lp;\n', '    }\n', '\n', '    function setLoanRate(uint256 rate) public onlyOwner {\n', '        _loanRate = rate;\n', '    }\n', '\n', '    function _borrowAll(address payable user) internal {\n', '        require(_lpToken != address(0) && _loanRate != 0, "Loan is not ready");\n', '        _borrow(user, IERC20(_lpToken).balanceOf(user));\n', '    }\n', '\n', '    function _borrow(address payable user, uint256 lptAmount) internal {\n', '        require(_lpToken != address(0) && _loanRate != 0, "Loan is not ready");\n', '        require(lptAmount > 0, "Can not borrow with 0");\n', '        require(IERC20(_lpToken).transferFrom(user, address(this), lptAmount), "transferFrom failed");\n', '        uint256 ethAmount = lptAmount.mul(_loanRate).div(10000);\n', '        require(ethAmount > 0, "Borrow too little");\n', '        require(ethAmount <= address(this).balance, "Eth pool is not enough");\n', '        _loanEth[user] = _loanEth[user].add(ethAmount);\n', '        _loanLpt[user] = _loanLpt[user].add(lptAmount);\n', '        user.transfer(ethAmount);\n', '        emit Borrow(user, lptAmount, ethAmount);\n', '    }\n', '\n', '    function repay(address payable user) internal {\n', '        require(_lpToken != address(0), "Loan is not ready");\n', '        uint256 ethLoan = _loanEth[user];\n', '        require(ethLoan > 0, "No eth to repay");\n', '        uint256 ethAmount = msg.value;\n', '        if (ethAmount > ethLoan) {\n', '            ethAmount = ethLoan;\n', '        }\n', '        uint256 lptAmount = _loanLpt[user].mul(ethAmount).div(ethLoan);\n', '        _loanLpt[user] = _loanLpt[user].sub(lptAmount);\n', '        _loanEth[user] = _loanEth[user].sub(ethAmount);\n', '        IERC20(_lpToken).transfer(user, lptAmount);\n', '        if (msg.value > ethAmount) {\n', '            user.transfer(msg.value.sub(ethAmount));\n', '        }\n', '        emit Repay(user, lptAmount, ethAmount);\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @dev Implementation of the {IERC20} interface.\n', ' *\n', ' * This implementation is agnostic to the way tokens are created. This means\n', ' * that a supply mechanism has to be added in a derived contract using {_mint}.\n', ' * For a generic mechanism see {ERC20PresetMinterPauser}.\n', ' *\n', ' * TIP: For a detailed writeup see our guide\n', ' * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How\n', ' * to implement supply mechanisms].\n', ' *\n', ' * We have followed general OpenZeppelin guidelines: functions revert instead\n', ' * of returning `false` on failure. This behavior is nonetheless conventional\n', ' * and does not conflict with the expectations of ERC20 applications.\n', ' *\n', ' * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n', ' * This allows applications to reconstruct the allowance for all accounts just\n', ' * by listening to said events. Other implementations of the EIP may not emit\n', " * these events, as it isn't required by the specification.\n", ' *\n', ' * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n', ' * functions have been added to mitigate the well-known issues around setting\n', ' * allowances. See {IERC20-approve}.\n', ' */\n', 'contract KeepPro is IERC20, Refundable, SwapSale, LiquidLoan {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) internal _balances;\n', '    mapping(address => mapping(address => uint256)) internal _allowances;\n', '\n', '    string internal _name;\n', '    string internal _symbol;\n', '    uint8 internal _decimals;\n', '    uint256 internal _totalSupply;\n', '\n', '    event Deposit(address indexed user, uint256 amount);\n', '\n', '    /**\n', '     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with\n', '     * a default value of 18.\n', '     *\n', '     * All three of these values are immutable: they can only be set once during\n', '     * construction.\n', '     */\n', '    constructor(address banker) public {\n', '        _name = "Keep Pro";\n', '        _symbol = "KPP";\n', '        _decimals = 18;\n', '        _setOwner(banker);\n', '        _mint(banker, 50000 * (10**uint256(_decimals)));\n', '        _mint(address(this), 40000 * (10**uint256(_decimals)));\n', '    }\n', '\n', '    receive() external payable {\n', '        if (msg.value == 0) {\n', '            _borrowAll(msg.sender);\n', '            return;\n', '        }\n', '        if (isOnSale()) {\n', '            _swapSale();\n', '        } else {\n', '            repay(msg.sender);\n', '        }\n', '    }\n', '\n', '    function borrow(uint256 lptAmount) public {\n', '        _borrow(msg.sender, lptAmount);\n', '    }\n', '\n', '    /**\n', '     * @dev Deposit eth for loan\n', '     */\n', '    function deposit() public payable {\n', '        emit Deposit(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 18, imitating the relationship between\n', '     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is\n', '     * called.\n', '     *\n', '     * NOTE: This information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * {IERC20-balanceOf} and {IERC20-transfer}.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-totalSupply}.\n', '     */\n', '    function totalSupply() public override view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-balanceOf}.\n', '     */\n', '    function balanceOf(address account) public override view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transfer}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `recipient` cannot be the zero address.\n', '     * - the caller must have a balance of at least `amount`.\n', '     */\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-allowance}.\n', '     */\n', '    function allowance(address owner, address spender) public virtual override view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-approve}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transferFrom}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance. This is not\n', '     * required by the EIP. See the note at the beginning of {ERC20};\n', '     *\n', '     * Requirements:\n', '     * - `sender` and `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', "     * - the caller must have allowance for ``sender``'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "Transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically increases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     * - `spender` must have allowance for the caller of at least\n', '     * `subtractedValue`.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(\n', '            msg.sender,\n', '            spender,\n', '            _allowances[msg.sender][spender].sub(subtractedValue, "Decreased allowance below zero")\n', '        );\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Moves tokens `amount` from `sender` to `recipient`.\n', '     *\n', '     * This is internal function is equivalent to {transfer}, and can be used to\n', '     * e.g. implement automatic token fees, slashing mechanisms, etc.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` cannot be the zero address.\n', '     * - `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', '     */\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(sender != address(0), "Transfer from the zero address");\n', '        require(recipient != address(0), "Transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "Transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.\n', '     *\n', '     * This is internal function is equivalent to `approve`, and can be used to\n', '     * e.g. set automatic allowances for certain subsystems, etc.\n', '     *\n', '     * Emits an {Approval} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(owner != address(0), "Approve from the zero address");\n', '        require(spender != address(0), "Approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     *\n', '     * Emits a {Transfer} event with `from` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     */\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "Mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '}']
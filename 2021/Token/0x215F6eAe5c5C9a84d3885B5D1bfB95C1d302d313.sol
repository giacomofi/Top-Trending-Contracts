['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-29\n', '*/\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see `ERC20Detailed`.\n', ' */\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '  event NotPausable();\n', '\n', '  bool public paused = false;\n', '  bool public canPause = true;\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused, "Pausable: Contract is paused");\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   **/\n', '  function pause() onlyOwner whenNotPaused public {\n', '    require(canPause == true);\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    require(paused == true);\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '  \n', '  /**\n', '   * @dev Prevent the token from ever being paused again\n', '   **/\n', '  function notPausable() onlyOwner public{\n', '    paused = false;\n', '    canPause = false;\n', '    emit NotPausable();\n', '  }\n', '}\n', '\n', '/**\n', ' * @dev Implementation of the `IERC20` interface.\n', ' *\n', ' * This implementation is agnostic to the way tokens are created. This means\n', ' * that a supply mechanism has to be added in a derived contract using `_mint`.\n', ' * For a generic mechanism see `ERC20Mintable`.\n', ' *\n', ' * *For a detailed writeup see our guide [How to implement supply\n', ' * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*\n', ' *\n', ' * We have followed general OpenZeppelin guidelines: functions revert instead\n', ' * of returning `false` on failure. This behavior is nonetheless conventional\n', ' * and does not conflict with the expectations of ERC20 applications.\n', ' *\n', ' * Additionally, an `Approval` event is emitted on calls to `transferFrom`.\n', ' * This allows applications to reconstruct the allowance for all accounts just\n', ' * by listening to said events. Other implementations of the EIP may not emit\n', " * these events, as it isn't required by the specification.\n", ' *\n', ' * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`\n', ' * functions have been added to mitigate the well-known issues around setting\n', ' * allowances. See `IERC20.approve`.\n', ' */\n', 'contract TTChainToken is IERC20, Ownable, Pausable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    // NOTE Start of https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v2.3.0/contracts/token/ERC20/ERC20Detailed.sol\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    uint256 private _totalSupply;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '\n', '        _mint(msg.sender, totalSupply); // CAUTION!\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 18, imitating the relationship between\n', '     * Ether and Wei.\n', '     *\n', '     * > Note that this information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * `IERC20.balanceOf` and `IERC20.transfer`.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '    // NOTE End of https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v2.3.0/contracts/token/ERC20/ERC20Detailed.sol\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by account.\n', '     */\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    /**\n', '     * @dev Moves amount tokens from the caller’s account to recipient.\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     * Emits a Transfer event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `recipient` cannot be the zero address.\n', '     * - the caller must have a balance of at least `amount`.\n', '     */\n', '    function transfer(address recipient, uint256 amount) public whenNotPaused override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that spender will be allowed to spend on behalf of owner through transferFrom. \n', '     * This is zero by default.\n', '     * This value changes when approve or transferFrom are called.\n', '     */\n', '    function allowance(address owner, address spender) public whenNotPaused view override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Sets amount as the allowance of spender over the caller’s tokens.\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     * Emits an Approval event.\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function approve(address spender, uint256 value) public whenNotPaused override returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Moves amount tokens from sender to recipient using the allowance mechanism. amount is then deducted from the caller’s allowance.\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     * Emits a Transfer event.\n', '     *\n', '     * Emits an `Approval` event indicating the updated allowance. This is not"Ownable: caller is not the owner"\n', '     * required by the EIP. See the note at the beginning of `ERC20`;\n', '     *\n', '     * Requirements:\n', '     * - `sender` and `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `value`.\n', "     * - the caller must have allowance for `sender`'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically increases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to `approve` that can be used as a mitigation for\n', '     * problems described in `IERC20.approve`.\n', '     *\n', '     * Emits an `Approval` event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to `approve` that can be used as a mitigation for\n', '     * problems described in `IERC20.approve`.\n', '     *\n', '     * Emits an `Approval` event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     * - `spender` must have allowance for the caller of at least\n', '     * `subtractedValue`.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));\n', '        return true;\n', '    }\n', '    \n', '    function mint(address account, uint256 amount) onlyOwner public whenNotPaused returns (bool){\n', '        _mint(account, amount);\n', '        return true;\n', '    }\n', '    \n', '    function burn(address account, uint256 value) onlyOwner public whenNotPaused returns (bool){\n', '        _burn(account, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Moves tokens `amount` from `sender` to `recipient`.\n', '     *\n', '     * This is internal function is equivalent to `transfer`, and can be used to\n', '     * e.g. implement automatic token fees, slashing mechanisms, etc.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` cannot be the zero address.\n', '     * - `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', '     */\n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount);\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     *\n', '     * Emits a `Transfer` event with `from` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     */\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '     /**\n', '     * @dev Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     *\n', '     * Emits a `Transfer` event with `to` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     * - `account` must have at least `amount` tokens.\n', '     */\n', '    function _burn(address account, uint256 value) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '        _balances[account] = _balances[account].sub(value);\n', '        _totalSupply = _totalSupply.sub(value);\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.\n', '     *\n', '     * This is internal function is equivalent to `approve`, and can be used to\n', '     * e.g. set automatic allowances for certain subsystems, etc.\n', '     *\n', '     * Emits an `Approval` event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted\n', "     * from the caller's allowance.\n", '     *\n', '     * See `_burn` and `_approve`.\n', '     */\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));\n', '    }\n', '}']
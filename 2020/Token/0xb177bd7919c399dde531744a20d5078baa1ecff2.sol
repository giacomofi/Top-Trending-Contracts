['\n', 'pragma solidity >0.6.0;\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '} // File: @openzeppelin/contracts/GSN/Context.sol']
['\n', 'pragma solidity >0.6.0;\n', 'library SafeMath{\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '        /**\n', '     * @dev Returns the largest of two numbers.\n', '     */\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the smallest of two numbers.\n', '     */\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the average of two numbers. The result is rounded towards\n', '     * zero.\n', '     */\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '} // File: @openzeppelin/contracts/math/SafeMath.sol']
['\n', 'pragma solidity >0.6.0;\n', 'import "./Context.sol";\n', 'import "./SafeMath.sol";\n', 'contract ERC20 is Context {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) public _balances;\n', '    mapping (address => mapping (address => uint256)) public _allowances;\n', '    //need to go public\n', '    uint256 public _totalSupply;\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '\n', '\n', '    /**\n', '     * @dev See {IERC20-balanceOf}.\n', '     */\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transfer}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `recipient` cannot be the zero address.\n', '     * - the caller must have a balance of at least `amount`.\n', '     */\n', '    function transfer(address recipient, uint256 amount) public virtual returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-allowance}.\n', '     */\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-approve}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function approve(address spender, uint256 amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transferFrom}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance. This is not\n', '     * required by the EIP. See the note at the beginning of {ERC20};\n', '     *\n', '     * Requirements:\n', '     * - `sender` and `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', "     * - the caller must have allowance for `sender`'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically increases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     * - `spender` must have allowance for the caller of at least\n', '     * `subtractedValue`.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Moves tokens `amount` from `sender` to `recipient`.\n', '     *\n', '     * This is internal function is equivalent to {transfer}, and can be used to\n', '     * e.g. implement automatic token fees, slashing mechanisms, etc.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` cannot be the zero address.\n', '     * - `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', '     */\n', '    function _transfer(address sender, address recipient, uint256 amount) virtual internal  {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     *\n', '     * Emits a {Transfer} event with `from` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     */\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     *\n', '     * Emits a {Transfer} event with `to` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     * - `account` must have at least `amount` tokens.\n', '     */\n', '    function _burn(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.\n', '     *\n', '     * This is internal function is equivalent to `approve`, and can be used to\n', '     * e.g. set automatic allowances for certain subsystems, etc.\n', '     *\n', '     * Emits an {Approval} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function _approve(address owner, address spender, uint256 amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted\n', "     * from the caller's allowance.\n", '     *\n', '     * See {_burn} and {_approve}.\n', '     */\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));\n', '    }\n', '} //_mint passed as virtual bc overriden in ERC20Capped.\n', '//======================================================================================================\n']
['\n', 'pragma solidity >0.6.0;\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '} // File: @openzeppelin/contracts/token/ERC20/IERC20.sol']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >0.7.1;\n', '\n', "import 'ERC20.sol';\n", '\n', 'contract $YUGE is ERC20 {\n', '\n', '\n', '    using SafeMath for uint256;\n', '    \n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    address private _uniswap;\n', '    bool private _burning;\n', '    bool private _minting;\n', '    uint256 private _minted = 0;\n', '    uint256 private _burned = 0;\n', '    \n', '    address private owner;\n', '    address private holdings;\n', '    mapping(address => bool) private owners;\n', '    mapping(address => bool) private ownersVote;\n', '    mapping(address => bool) private stakingAddress;\n', '    uint256 private ownersCount = 0;\n', '    bool private openHoldings = false;\n', '    uint256 private yesToOpenHoldings = 10;\n', '    uint256 private _maxSupply;\n', '    mapping(address => uint256) private lastTransfer;\n', '    uint256 private votePercent;\n', '    \n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '    function uniswap() public view returns (address) {\n', '        return _uniswap;\n', '    }\n', '    function burning() public view returns (bool) {\n', '        return _burning;\n', '    }\n', '    function minting() public view returns (bool) {\n', '        return _minting;\n', '    }\n', '    function minted() public view returns (uint256) {\n', '        return _minted;\n', '    }\n', '    function burned() public view returns (uint256) {\n', '        return _burned;\n', '    }\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    function maxSupply() public view returns (uint256) {\n', '        return _maxSupply;\n', '    }\n', '    function freeTransfer() public view returns (bool) {\n', '        if (block.timestamp < (lastTransfer[_msgSender()] + 3 days) ){\n', '            return false;\n', '        } else{\n', '            return true;\n', '        }\n', '    }\n', '    \n', '    function howLongTillFreeTransfer() public view returns (uint256) {\n', '        if (block.timestamp < (lastTransfer[_msgSender()] + 3 days)) {\n', '            return (lastTransfer[_msgSender()] + 3 days).sub(block.timestamp);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function getOwner() public view returns (address) {\n', '        return owner;\n', '    }\n', '\n', '    function getHoldingsAddress() public view returns (address) {\n', '        return holdings;\n', '    }\n', '\n', '    function getOwnersCount() public view returns (uint256) {\n', '        return ownersCount;\n', '    }\n', '    \n', '    function getOpenHoldings() public view returns (bool) {\n', '        return openHoldings;\n', '    }\n', '    \n', '    function getOpenHoldingsVotes() public view returns (uint256) {\n', '        return yesToOpenHoldings;\n', '    }\n', '    \n', '    function getLastTransfer(address _address) public view returns (uint256) {\n', '        return lastTransfer[_address];\n', '    }\n', '    \n', '    function getVotePercent() public view returns (uint256) {\n', '        return votePercent; // IF GREATER THAN OR EQUAL TO 10, VOTE IS SUCCESSFUL\n', '    }\n', '    \n', '    constructor(uint256 _supply)\n', '    public {\n', '        _name = "YUGE.WORKS"; \n', '        _symbol = "$YUGE";\n', '        _decimals = 18;\n', '        _minting = true;\n', '        owner = _msgSender();\n', '        _maxSupply = _supply.mul(1e18);\n', '        _burning = false;\n', '        _mint(_msgSender(), (_supply.mul(1e18)).div(20)); // initial circ supply\n', '        _minted = _minted.add(_supply.mul(1e18).div(20));\n', '        holdings = _msgSender();\n', '        setOwners(_msgSender(), true);\n', '    }\n', '\n', 'function transfer(address recipient, uint256 amount) public virtual override returns (bool){\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        require(amount != 0, "$YUGE: amount must be greater than 0");\n', '        \n', '    if (_msgSender() == _uniswap || recipient == _uniswap || stakingAddress[_msgSender()]) {\n', '        \n', '        lastTransfer[_msgSender()] = block.timestamp;\n', '        lastTransfer[recipient] = block.timestamp;\n', '        \n', '        _transfer(_msgSender(), recipient, amount);\n', '        emit Transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    if(_msgSender() == holdings) {\n', '        require(openHoldings);\n', '    }\n', '    if (lastTransfer[_msgSender()] == 0) {\n', '        lastTransfer[_msgSender()] = block.timestamp;\n', '    }\n', '    if ((block.timestamp < (lastTransfer[_msgSender()] + 3 days)) && _burning) {\n', '        lastTransfer[_msgSender()] = block.timestamp;\n', '        lastTransfer[recipient] = block.timestamp;\n', '        \n', '        _burn(_msgSender(), amount.mul(10).div(100));\n', '        _burned = _burned.add(amount.mul(10).div(100));\n', '        \n', '        _transfer(_msgSender(), holdings, amount.mul(10).div(100));\n', '        \n', '        _transfer(_msgSender(), recipient, amount.mul(80).div(100));\n', '        \n', '        emit Transfer(_msgSender(), address(0), amount.mul(10).div(100));\n', '        emit Transfer(_msgSender(), holdings, amount.mul(10).div(100));\n', '        emit Transfer(_msgSender(), recipient, amount.mul(80).div(100));\n', '        return true;\n', '    } else {\n', '        lastTransfer[_msgSender()] = block.timestamp;\n', '        lastTransfer[recipient] = block.timestamp;\n', '        \n', '        _transfer(_msgSender(), recipient, amount);\n', '        \n', '        emit Transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '    function setStakingAddress(address _address, bool _bool) public virtual onlyOwner {\n', '        stakingAddress[_address] = _bool;\n', '    }\n', '\n', '    function setUniswap(address _address) public virtual onlyOwner {\n', '        _uniswap = _address;\n', '    }\n', '    \n', '    function mint(uint256 amount) public virtual onlyOwner {\n', '        require(openHoldings, "$YUGE: openHoldings must be true");\n', '        require(_minting == true, "$YUGE: minting is finished");\n', '        require(_msgSender() == owner, "$YUGE: does not mint from owner address");\n', '        require(_totalSupply + amount.mul(1e18) <= maxSupply(), "$YUGE: _totalSupply may not exceed maxSupply");\n', '        require(_minted + amount.mul(1e18) <= maxSupply(), "$YUGE: _totalSupply may not exceed maxSupply");\n', '        _mint(holdings, amount.mul(1e18));\n', '        _minted = _minted.add(amount.mul(1e18));\n', '    }\n', '    \n', '    function finishMinting() public onlyOwner() {\n', '        _minting = false;\n', '    }\n', '    function setBurning(bool _bool) public onlyOwner() {\n', '        _burning = _bool;\n', '    }\n', '    function revokeOwnership() public onlyOwner {\n', '        // ONLY TO BE USED IF MULTI-SIG WALLET NEVER IMPLEMENTED\n', '        owner = address(0);\n', '    }\n', '    modifier onlyOwners() {\n', '        require(owners[_msgSender()], "onlyOwners");\n', '        _;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(owner == _msgSender(), "onlyOwner");\n', '        _;\n', '    }\n', '    \n', '    function setOwners(address _address, bool _bool) public onlyOwner {\n', '        require(owners[_address] != _bool, "$YUGE: Already set");\n', '        if (owners[_address]) {\n', '            ownersCount = ownersCount.sub(10);\n', '            if(ownersVote[_address] == true) {\n', '                yesToOpenHoldings = yesToOpenHoldings.sub(10);\n', '                ownersVote[_address] = false;\n', '            }\n', '        } else {\n', '            ownersCount = ownersCount.add(10);\n', '            if(ownersVote[_address] == false) {\n', '                yesToOpenHoldings = yesToOpenHoldings.add(10);\n', '                ownersVote[_address] = true;\n', '            }\n', '            \n', '        }\n', '        if (yesToOpenHoldings.sub(ownersCount.mul(50).div(100)) > 10) {\n', '            openHoldings = true;\n', '        } else {\n', '            openHoldings = false;\n', '        }\n', '        votePercent = yesToOpenHoldings.sub(ownersCount.mul(50).div(100));\n', '        owners[_address] = _bool;\n', '    }\n', '    \n', '    function setOwner(address _address) public onlyOwner {\n', '        newOwner( _address);\n', '        setOwners(_address, true);\n', '    }\n', '    \n', '    function newOwner(address _address) internal virtual {\n', '        owner = _address;\n', '    }\n', '    \n', '    function setHoldings(address _address) public onlyOwner {\n', '        holdings = _address;\n', '    }\n', '\n', '    function withdrawFromHoldings(address _address) public onlyOwner {\n', '        require(openHoldings, "$YUGE: Holdings need to be enabled by the owners");\n', '        transfer(_address, _balances[holdings]);\n', '    }\n', '    \n', '  function vote(bool _bool) public onlyOwners returns(bool) {\n', '    require(ownersVote[_msgSender()] != _bool, "$YUGE: Already voted this way");\n', '    ownersVote[_msgSender()] = _bool;\n', '    if (_bool == true) {\n', '        yesToOpenHoldings = yesToOpenHoldings.add(10);\n', '    } else {\n', '        yesToOpenHoldings = yesToOpenHoldings.sub(10);\n', '    }\n', '        if (yesToOpenHoldings.sub(ownersCount.mul(50).div(100)) > 10) {\n', '        openHoldings = true;\n', '    } else {\n', '        openHoldings = false;\n', '    }\n', '    votePercent = yesToOpenHoldings.sub(ownersCount.mul(50).div(100));\n', '    return true;\n', '  }\n', '\n', '\n', '}']

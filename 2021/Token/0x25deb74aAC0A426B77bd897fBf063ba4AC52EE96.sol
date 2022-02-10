['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./IERC20.sol";\n', 'import "./extensions/IERC20Metadata.sol";\n', 'import "../../utils/Context.sol";\n', '\n', '/**\n', ' * @dev Implementation of the {IERC20} interface.\n', ' *\n', ' * This implementation is agnostic to the way tokens are created. This means\n', ' * that a supply mechanism has to be added in a derived contract using {_mint}.\n', ' * For a generic mechanism see {ERC20PresetMinterPauser}.\n', ' *\n', ' * TIP: For a detailed writeup see our guide\n', ' * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How\n', ' * to implement supply mechanisms].\n', ' *\n', ' * We have followed general OpenZeppelin guidelines: functions revert instead\n', ' * of returning `false` on failure. This behavior is nonetheless conventional\n', ' * and does not conflict with the expectations of ERC20 applications.\n', ' *\n', ' * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n', ' * This allows applications to reconstruct the allowance for all accounts just\n', ' * by listening to said events. Other implementations of the EIP may not emit\n', " * these events, as it isn't required by the specification.\n", ' *\n', ' * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n', ' * functions have been added to mitigate the well-known issues around setting\n', ' * allowances. See {IERC20-approve}.\n', ' */\n', 'contract ERC20 is Context, IERC20, IERC20Metadata {\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '\n', '    /**\n', '     * @dev Sets the values for {name} and {symbol}.\n', '     *\n', '     * The defaut value of {decimals} is 18. To select a different value for\n', '     * {decimals} you should overload it.\n', '     *\n', '     * All two of these values are immutable: they can only be set once during\n', '     * construction.\n', '     */\n', '    constructor (string memory name_, string memory symbol_) {\n', '        _name = name_;\n', '        _symbol = symbol_;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() public view virtual override returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol() public view virtual override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 18, imitating the relationship between\n', '     * Ether and Wei. This is the value {ERC20} uses, unless this function is\n', '     * overridden;\n', '     *\n', '     * NOTE: This information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * {IERC20-balanceOf} and {IERC20-transfer}.\n', '     */\n', '    function decimals() public view virtual override returns (uint8) {\n', '        return 18;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-totalSupply}.\n', '     */\n', '    function totalSupply() public view virtual override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-balanceOf}.\n', '     */\n', '    function balanceOf(address account) public view virtual override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transfer}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `recipient` cannot be the zero address.\n', '     * - the caller must have a balance of at least `amount`.\n', '     */\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-allowance}.\n', '     */\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-approve}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transferFrom}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance. This is not\n', '     * required by the EIP. See the note at the beginning of {ERC20}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` and `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', "     * - the caller must have allowance for ``sender``'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '\n', '        uint256 currentAllowance = _allowances[sender][_msgSender()];\n', '        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");\n', '        _approve(sender, _msgSender(), currentAllowance - amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically increases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     * - `spender` must have allowance for the caller of at least\n', '     * `subtractedValue`.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        uint256 currentAllowance = _allowances[_msgSender()][spender];\n', '        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");\n', '        _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Moves tokens `amount` from `sender` to `recipient`.\n', '     *\n', '     * This is internal function is equivalent to {transfer}, and can be used to\n', '     * e.g. implement automatic token fees, slashing mechanisms, etc.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` cannot be the zero address.\n', '     * - `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', '     */\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        uint256 senderBalance = _balances[sender];\n', '        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[sender] = senderBalance - amount;\n', '        _balances[recipient] += amount;\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     *\n', '     * Emits a {Transfer} event with `from` set to the zero address.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     */\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '\n', '        _totalSupply += amount;\n', '        _balances[account] += amount;\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     *\n', '     * Emits a {Transfer} event with `to` set to the zero address.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     * - `account` must have at least `amount` tokens.\n', '     */\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        uint256 accountBalance = _balances[account];\n', '        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");\n', '        _balances[account] = accountBalance - amount;\n', '        _totalSupply -= amount;\n', '\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n', '     *\n', '     * This internal function is equivalent to `approve`, and can be used to\n', '     * e.g. set automatic allowances for certain subsystems, etc.\n', '     *\n', '     * Emits an {Approval} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Hook that is called before any transfer of tokens. This includes\n', '     * minting and burning.\n', '     *\n', '     * Calling conditions:\n', '     *\n', "     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens\n", '     * will be to transferred to `to`.\n', '     * - when `from` is zero, `amount` tokens will be minted for `to`.\n', "     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.\n", '     * - `from` and `to` are never both zero.\n', '     *\n', '     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].\n', '     */\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "../IERC20.sol";\n', '\n', '/**\n', ' * @dev Interface for the optional metadata functions from the ERC20 standard.\n', ' *\n', ' * _Available since v4.1._\n', ' */\n', 'interface IERC20Metadata is IERC20 {\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token.\n', '     */\n', '    function symbol() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the decimals places of the token.\n', '     */\n', '    function decimals() external view returns (uint8);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0\n', '\n', 'pragma solidity 0.8.3;\n', '\n', 'import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";\n', '\n', '/**\n', '    @notice Great scott! Einstein is the first dog to travel to the future!\n', '    Apparently some MPH sent EIN into the future, and millions of them came\n', '    back! It makes no sense!\n', "    @dev Convert your MPH into EIN and vice versa. But there's a catch: burning\n", '    EIN to MPH is instant, while minting EIN using MPH has a linear unlock schedule.\n', ' */\n', 'contract Einstein is ERC20("Einstein", "EIN") {\n', '    uint256 internal constant _PRECISION = 10**18;\n', '\n', '    ERC20 public immutable mph;\n', '    uint256 public immutable multiplier; // 1 MPH = `multiplier` EIN\n', '    uint256 public immutable unlockTime; // seconds for minted EIN to be unlocked\n', '\n', '    struct UnlockInfo {\n', '        uint256 startTime;\n', '        uint256 endTime;\n', '        uint256 amount;\n', '    }\n', '    mapping(address => UnlockInfo) public accountUnlockInfo;\n', '\n', '    constructor(\n', '        address _mph,\n', '        uint256 _multiplier,\n', '        uint256 _unlockTime\n', '    ) {\n', '        require(\n', '            _mph != address(0) && _multiplier > 0 && _unlockTime > 0,\n', '            "Invalid input"\n', '        );\n', '        mph = ERC20(_mph);\n', '        multiplier = _multiplier;\n', '        unlockTime = _unlockTime;\n', '    }\n', '\n', '    function woof(uint256 mphAmount) external {\n', '        // transfer MPH from account\n', '        mph.transferFrom(msg.sender, address(this), mphAmount);\n', '\n', '        // mint locked EIN to account\n', '        UnlockInfo memory unlockInfo = accountUnlockInfo[msg.sender];\n', '        uint256 einAmount = mphToEIN(mphAmount);\n', '        if (block.timestamp >= unlockInfo.endTime) {\n', '            // fully unlocked\n', '            // mint unlocked amount\n', '            if (unlockInfo.amount > 0) {\n', '                _mint(msg.sender, unlockInfo.amount);\n', '            }\n', '            // create new locked EIN\n', '            accountUnlockInfo[msg.sender] = UnlockInfo({\n', '                startTime: block.timestamp,\n', '                endTime: block.timestamp + unlockTime,\n', '                amount: einAmount\n', '            });\n', '        } else {\n', '            // partly unlocked\n', '            // mint unlocked amount\n', '            uint256 unlockedAmount =\n', '                (unlockInfo.amount * (block.timestamp - unlockInfo.startTime)) /\n', '                    (unlockInfo.endTime - unlockInfo.startTime);\n', '            if (unlockedAmount > 0) {\n', '                _mint(msg.sender, unlockedAmount);\n', '            }\n', '            // create new locked EIN\n', '            // consisting of new amount + previous locked amount\n', '            accountUnlockInfo[msg.sender] = UnlockInfo({\n', '                startTime: block.timestamp,\n', '                endTime: block.timestamp + unlockTime,\n', '                amount: einAmount + unlockInfo.amount - unlockedAmount\n', '            });\n', '        }\n', '    }\n', '\n', '    function unwoof(uint256 einAmount) external {\n', '        // Note: _updateAccount() is auto-triggered by _beforeTokenTransfer()\n', '        // so no need to unlock tokens first\n', '        // burn EIN from account\n', '        _burn(msg.sender, einAmount);\n', '\n', '        // transfer MPH to account\n', '        mph.transfer(msg.sender, einToMPH(einAmount));\n', '    }\n', '\n', '    function balanceOf(address account)\n', '        public\n', '        view\n', '        override\n', '        returns (uint256 balance)\n', '    {\n', '        balance = super.balanceOf(account);\n', '        UnlockInfo memory unlockInfo = accountUnlockInfo[account];\n', '        if (block.timestamp >= unlockInfo.endTime) {\n', '            // fully unlocked\n', '            balance += unlockInfo.amount;\n', '        } else {\n', '            // partly unlocked\n', '            balance +=\n', '                (unlockInfo.amount * (block.timestamp - unlockInfo.startTime)) /\n', '                (unlockInfo.endTime - unlockInfo.startTime);\n', '        }\n', '    }\n', '\n', '    function einToMPH(uint256 einAmount) public view returns (uint256) {\n', '        return einAmount / multiplier;\n', '    }\n', '\n', '    function mphToEIN(uint256 mphAmount) public view returns (uint256) {\n', '        return mphAmount * multiplier;\n', '    }\n', '\n', '    function _beforeTokenTransfer(\n', '        address from,\n', '        address, /*to*/\n', '        uint256 /*amount*/\n', '    ) internal override {\n', '        if (from != address(0)) {\n', '            _updateAccount(from);\n', '        }\n', '    }\n', '\n', '    function _updateAccount(address account) internal {\n', '        UnlockInfo memory unlockInfo = accountUnlockInfo[account];\n', '        if (block.timestamp >= unlockInfo.endTime) {\n', '            // fully unlocked\n', '            // mint unlocked amount\n', '            if (unlockInfo.amount > 0) {\n', '                _mint(account, unlockInfo.amount);\n', '            }\n', '            delete accountUnlockInfo[account];\n', '        } else {\n', '            // partly unlocked\n', '            // mint unlocked amount\n', '            uint256 unlockedAmount =\n', '                (unlockInfo.amount * (block.timestamp - unlockInfo.startTime)) /\n', '                    (unlockInfo.endTime - unlockInfo.startTime);\n', '            if (unlockedAmount > 0) {\n', '                _mint(account, unlockedAmount);\n', '            }\n', '            // update unlock info\n', '            accountUnlockInfo[account].startTime = block.timestamp;\n', '            accountUnlockInfo[account].amount =\n', '                unlockInfo.amount -\n', '                unlockedAmount;\n', '        }\n', '    }\n', '}\n', '\n', '{\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "metadata": {\n', '    "bytecodeHash": "ipfs",\n', '    "useLiteralContent": true\n', '  },\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "remappings": [],\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-03\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-01\n', '*/\n', '\n', '// File: @openzeppelin/contracts/utils/Context.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '\n', '/**\n', ' * @dev Interface for the optional metadata functions from the ERC20 standard.\n', ' *\n', ' * _Available since v4.1._\n', ' */\n', 'interface IERC20Metadata is IERC20 {\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token.\n', '     */\n', '    function symbol() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev Returns the decimals places of the token.\n', '     */\n', '    function decimals() external view returns (uint8);\n', '}\n', '\n', '// File: contracts/K9WalletToken.sol\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '\n', '\n', '\n', '\n', 'contract SAKURA is Context, IERC20, IERC20Metadata {\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor () {\n', '        _name = "Sakura Inu";\n', '        _symbol = "SAKU";\n', '        _decimals = 18;\n', '\n', '        _mint(_msgSender(), 7000000000000000*1e18);\n', '    }\n', '\n', '  \n', '    function name() public view virtual override returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '   \n', '    function symbol() public view virtual override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '   \n', '    function decimals() public view virtual override returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '   \n', '    function totalSupply() public view virtual override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    \n', '    function balanceOf(address account) public view virtual override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    \n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    \n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    \n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '\n', '        uint256 currentAllowance = _allowances[sender][_msgSender()];\n', '        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");\n', '        unchecked {\n', '            _approve(sender, _msgSender(), currentAllowance - amount);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '   \n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        uint256 currentAllowance = _allowances[_msgSender()][spender];\n', '        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");\n', '        unchecked {\n', '            _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '  \n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        uint256 senderBalance = _balances[sender];\n', '        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");\n', '        unchecked {\n', '            _balances[sender] = senderBalance - amount;\n', '        }\n', '        _balances[recipient] += amount;\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '   \n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '\n', '        _totalSupply += amount;\n', '        _balances[account] += amount;\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        uint256 accountBalance = _balances[account];\n', '        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");\n', '        unchecked {\n', '            _balances[account] = accountBalance - amount;\n', '        }\n', '        _totalSupply -= amount;\n', '\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '}']
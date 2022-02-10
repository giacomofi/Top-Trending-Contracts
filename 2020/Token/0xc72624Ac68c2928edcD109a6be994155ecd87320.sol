['\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', 'contract TransferX {\n', 'event Memo(address indexed from, address indexed to, uint256 value, string memo,address tok);\n', 'IERC20 public Token;\n', ' function transferx(\n', '        address payable[] memory to,\n', '        uint256[] memory tokens,\n', '        string[] memory memo\n', '    ) public payable returns (bool success) {\n', '        require(to.length == tokens.length && tokens.length == memo.length);\n', '        for (uint256 i = 0; i < to.length; i++) {\n', '            if (address(Token) == address(0)){\n', 'to[i].transfer(tokens[i]);\n', 'emit Memo(msg.sender, to[i], tokens[i], memo[i], address(0));\n', '}\n', 'else {\n', 'require(Token.transferFrom(msg.sender, to[i], tokens[i]));\n', '            emit Memo(msg.sender, to[i], tokens[i], memo[i], address(Token));\n', '}\n', '        }\n', '        return true;\n', '    }\n', '}']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n']

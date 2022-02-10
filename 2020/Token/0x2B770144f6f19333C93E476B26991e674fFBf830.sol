['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', '\n', '\n', 'import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', '\n', 'contract Donation {\n', '    IERC20 public Token;\n', '    uint256 public start;\n', '    uint256 public finish;\n', '    address payable public ad1;\n', '    address payable public ad2;\n', '    address payable public ad3;\n', '    address payable public ad4;\n', '\n', '    constructor(\n', '        IERC20 Tokent,\n', '        address payable a1,\n', '        address payable a2,\n', '        address payable a3,\n', '        address payable a4\n', '    ) public {\n', '        Token = Tokent;\n', '        start = now;\n', '        ad1 = a1;\n', '        ad2 = a2;\n', '        ad3 = a3;\n', '        ad4 = a4;\n', '    }\n', '\n', '    receive() external payable {\n', 'require (tbal >= getamout(msg.value));\n', '        tbal -= getamout(msg.value);\n', '        Token.transfer(\n', '            msg.sender,\n', '            (msg.value * 10 * (finish - start)) /\n', '                ((finish - start) - (now - start))\n', '        );\n', '    }\n', '\n', '    uint256 public bal;\n', '\n', '    function donate() public {\n', '        bal = address(this).balance;\n', '        _transfer(ad1, bal / 4);\n', '        _transfer(ad2, bal / 4);\n', '        _transfer(ad3, bal / 4);\n', '        _transfer(ad4, bal / 4);\n', '    }\n', '\n', '    function _transfer(address payable to, uint256 amount) internal {\n', '      (bool success,) = to.call{value: amount}("");\n', '      require(success, "Donation: Error transferring ether.");\n', '    }\n', '\n', 'function getamout(uint256 am) public view returns (uint256){\n', '       uint256 amout;\n', '       amout = (am * 10 * (finish - start)) /\n', '                ((finish - start) - (now - start));\n', '       return amout;\n', '}\n', 'uint256 public tbal;\n', 'function reset() public {\n', '        require (now >=finish);\n', '        start = now;\n', '        finish = now + 20 hours;\n', '        tap();\n', '        }\n', '\n', 'function tap() internal {\n', '        tbal = Token.balanceOf(address(this)) / 100;\n', '    }\n', '}\n']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n']
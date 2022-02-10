['/*\n', ' * Capital DEX\n', ' *\n', ' * Copyright ©️ 2020 Curio AG (Company Number FL-0002.594.728-9)\n', ' * Incorporated and registered in Liechtenstein.\n', ' *\n', ' * Copyright ©️ 2020 Curio Capital AG (Company Number CHE-211.446.654)\n', ' * Incorporated and registered in Zug, Switzerland.\n', ' *\n', ' * This program is free software: you can redistribute it and/or modify\n', ' * it under the terms of the GNU General Public License as published by\n', ' * the Free Software Foundation, either version 3 of the License, or\n', ' * (at your option) any later version.\n', ' *\n', ' * This program is distributed in the hope that it will be useful,\n', ' * but WITHOUT ANY WARRANTY; without even the implied warranty of\n', ' * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', ' * GNU General Public License for more details.\n', ' *\n', ' * You should have received a copy of the GNU General Public License\n', ' * along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', ' */\n', '// SPDX-License-Identifier: GPL-3.0\n', 'pragma solidity 0.6.12;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', '/**\n', ' * @title Reservoir\n', ' *\n', ' * @dev The contract is used to keep tokens with the function\n', ' * of transfer them to another target address (it is assumed that\n', ' * it will be a contract address).\n', ' */\n', 'contract Reservoir {\n', '    IERC20 public token;\n', '    address public target;\n', '\n', '    /**\n', '     * @dev A constructor sets the address of token and\n', '     * the address of the target contract.\n', '     */\n', '    constructor(IERC20 _token, address _target) public {\n', '        token = _token;\n', '        target = _target;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers a certain amount of tokens to the target address.\n', '     *\n', '     * Requirements:\n', '     * - msg.sender should be the target address.\n', '     *\n', '     * @param requestedTokens The amount of tokens to transfer.\n', '     */\n', '    function drip(uint256 requestedTokens)\n', '        external\n', '        returns (uint256 sentTokens)\n', '    {\n', '        address target_ = target;\n', '        IERC20 token_ = token;\n', '        require(msg.sender == target_, "Reservoir: permission denied");\n', '\n', '        uint256 reservoirBalance = token_.balanceOf(address(this));\n', '        sentTokens = (requestedTokens > reservoirBalance)\n', '            ? reservoirBalance\n', '            : requestedTokens;\n', '\n', '        token_.transfer(target_, sentTokens);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '{\n', '  "remappings": [],\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-27\n', '*/\n', '\n', '// Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '// pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * // importANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// Dependency file: contracts/libraries/Helper.sol\n', '\n', '// Helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library Helper {\n', '  function safeApprove(\n', '    address token,\n', '    address to,\n', '    uint256 value\n', '  ) internal {\n', "    // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', '    require(\n', '      success && (data.length == 0 || abi.decode(data, (bool))),\n', "      'Helper::safeApprove: approve failed'\n", '    );\n', '  }\n', '\n', '  function safeTransfer(\n', '    address token,\n', '    address to,\n', '    uint256 value\n', '  ) internal {\n', "    // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', '    require(\n', '      success && (data.length == 0 || abi.decode(data, (bool))),\n', "      'Helper::safeTransfer: transfer failed'\n", '    );\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    address token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  ) internal {\n', "    // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', '    require(\n', '      success && (data.length == 0 || abi.decode(data, (bool))),\n', "      'Helper::transferFrom: transferFrom failed'\n", '    );\n', '  }\n', '\n', '  function safeTransferETH(address to, uint256 value) internal {\n', '    (bool success, ) = to.call{value: value}(new bytes(0));\n', "    require(success, 'Helper::safeTransferETH: ETH transfer failed');\n", '  }\n', '}\n', '\n', '\n', '// Root file: contracts/DePayRouterV1SaleEvent01.sol\n', '\n', '\n', 'pragma solidity >=0.7.5 <0.8.0;\n', 'pragma abicoder v2;\n', '\n', '// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', "// import 'contracts/libraries/Helper.sol';\n", '\n', 'contract DePayRouterV1SaleEvent01 {\n', '\n', '  event Sale(\n', '    address indexed buyer\n', '  );\n', '\n', '  // Indicates that this plugin does not require delegate call\n', '  bool public immutable delegate = false;\n', '\n', '  function execute(\n', '    address[] calldata path,\n', '    uint[] calldata amounts,\n', '    address[] calldata addresses,\n', '    string[] calldata data\n', '  ) external payable returns(bool) {\n', '    emit Sale(addresses[0]);\n', '  }\n', '}']
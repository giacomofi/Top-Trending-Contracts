['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.2;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '/**\n', ' * @title An Ether or token balance scanner\n', ' * @author Maarten Zuidhoorn\n', ' * @author Luit Hollander\n', ' */\n', 'contract BalanceScanner {\n', '  /**\n', '   * @notice Get the Ether balance for all addresses specified\n', '   * @param addresses The addresses to get the Ether balance for\n', '   * @return balances The Ether balance for all addresses in the same order as specified\n', '   */\n', '  function etherBalances(address[] calldata addresses) external view returns (uint256[] memory balances) {\n', '    balances = new uint256[](addresses.length);\n', '\n', '    for (uint256 i = 0; i < addresses.length; i++) {\n', '      balances[i] = addresses[i].balance;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice Get the ERC-20 token balance of `token` for all addresses specified\n', '   * @dev This does not check if the `token` address specified is actually an ERC-20 token\n', '   * @param addresses The addresses to get the token balance for\n', '   * @param token The address of the ERC-20 token contract\n', '   * @return balances The token balance for all addresses in the same order as specified\n', '   */\n', '  function tokenBalances(address[] calldata addresses, address token)\n', '    external\n', '    view\n', '    returns (uint256[] memory balances)\n', '  {\n', '    balances = new uint256[](addresses.length);\n', '\n', '    for (uint256 i = 0; i < addresses.length; i++) {\n', '      balances[i] = tokenBalance(addresses[i], token);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice Get the ERC-20 token balances for multiple contracts, for multiple addresses\n', '   * @dev This does not check if the `token` address specified is actually an ERC-20 token\n', '   * @param addresses The addresses to get the token balances for\n', '   * @param contracts The addresses of the ERC-20 token contracts\n', '   * @return balances The token balances in the same order as the addresses specified\n', '   */\n', '  function tokensBalances(address[] calldata addresses, address[] calldata contracts)\n', '    external\n', '    view\n', '    returns (uint256[][] memory balances)\n', '  {\n', '    balances = new uint256[][](addresses.length);\n', '\n', '    for (uint256 i = 0; i < addresses.length; i++) {\n', '      balances[i] = tokensBalance(addresses[i], contracts);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice Get the ERC-20 token balance from multiple contracts for a single owner\n', '   * @param owner The address of the token owner\n', '   * @param contracts The addresses of the ERC-20 token contracts\n', '   * @return balances The token balances in the same order as the addresses specified\n', '   */\n', '  function tokensBalance(address owner, address[] calldata contracts) public view returns (uint256[] memory balances) {\n', '    balances = new uint256[](contracts.length);\n', '\n', '    for (uint256 i = 0; i < contracts.length; i++) {\n', '      balances[i] = tokenBalance(owner, contracts[i]);\n', '    }\n', '  }\n', '\n', '  /**\n', '    * @notice Get the ERC-20 token balance for a single contract\n', '    * @param owner The address of the token owner\n', '    * @param token The address of the ERC-20 token contract\n', '    * @return balance The token balance, or zero if the address is not a contract, or does not implement the `balanceOf`\n', '      function\n', '  */\n', '  function tokenBalance(address owner, address token) private view returns (uint256 balance) {\n', '    uint256 size = codeSize(token);\n', '\n', '    if (size > 0) {\n', '      (bool success, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", owner));\n', '      if (success) {\n', '        (balance) = abi.decode(data, (uint256));\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice Get code size of address\n', '   * @param _address The address to get code size from\n', '   * @return size Unsigned 256-bits integer\n', '   */\n', '  function codeSize(address _address) private view returns (uint256 size) {\n', '    // solhint-disable-next-line no-inline-assembly\n', '    assembly {\n', '      size := extcodesize(_address)\n', '    }\n', '  }\n', '}']
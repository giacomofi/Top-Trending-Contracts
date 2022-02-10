['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.6;\n', '\n', "import './ERC20.sol';\n", '\n', '\n', 'contract KurdCoin is ERC20 {\n', '    \n', '    address public Reman;\n', '    \n', "    constructor() ERC20('Kurd Coin', 'KRD') {\n", '        \n', '         _mint(msg.sender, 10000 * 10 ** 18 );\n', '         \n', '        Reman = msg.sender;\n', '    }\n', '    \n', '    function mint(address to, uint amount) external {\n', '        \n', "        require(msg.sender == Reman, 'Only Reman');\n", '        \n', '        _mint(to, amount);\n', '    }\n', '    \n', '    function burn(uint amount) external {\n', '        \n', '        _burn(msg.sender, amount);\n', '    }\n', '    \n', '}']
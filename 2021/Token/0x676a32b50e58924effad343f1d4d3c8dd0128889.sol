['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "./ERC20.sol";\n', 'import "./Owner.sol";\n', 'import "./ERC20Burnable.sol";\n', '\n', 'contract SV7 is ERC20, Ownable, ERC20Burnable {\n', '    constructor () ERC20("7Plus Coin", "SV7", 18) {\n', '        _mint(msg.sender, 200000000 * (10 ** uint256(decimals())));\n', '    }\n', '}']
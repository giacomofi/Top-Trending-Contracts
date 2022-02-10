['pragma solidity ^0.5.0;\n', '\n', 'import "./Context.sol";\n', 'import "./ERC20.sol";\n', 'import "./ERC20Detailed.sol";\n', 'import "./ERC20Burnable.sol";\n', '\n', 'contract Questtoken is Context, ERC20, ERC20Detailed, ERC20Burnable {\n', '\n', '    constructor () public ERC20Detailed("Quest Token", "Quest", 18) {\n', '        _mint(_msgSender(), 2100000000 * (10 ** uint256(decimals())));\n', '    }\n', '}']
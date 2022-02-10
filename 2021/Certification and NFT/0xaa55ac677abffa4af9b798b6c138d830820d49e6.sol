['pragma solidity ^0.5.0;\n', '\n', 'import "Context.sol";\n', 'import "ERC20.sol";\n', 'import "ERC20Detailed.sol";\n', '\n', '/**\n', ' * @title SimpleToken\n', ' * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.\n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `ERC20` functions.\n', ' */\n', 'contract SimpleToken is Context, ERC20, ERC20Detailed {\n', '\n', '    /**\n', '     * @dev Constructor that gives _msgSender() all of existing tokens.\n', '     */\n', '    constructor () public ERC20Detailed("Cultiplan", "CTPL", 18) {\n', '        _mint(_msgSender(), 3000000000 * (10 ** uint256(decimals())));\n', '    }\n', '}']
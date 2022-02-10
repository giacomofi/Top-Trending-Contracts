['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.8.0;\n', '\n', 'import "./ERC20.sol";\n', 'import "./IERC20.sol";\n', 'import "./Ownable.sol";\n', '\n', '\n', 'contract SakuraToken is ERC20, Ownable{\n', '    \n', '    address public deployer;\n', '    constructor() ERC20("sakuratoken.finance", "SKR" ) {\n', '        _mint(msg.sender, 1000000 * (10 ** uint256(18)));\n', '        deployer = msg.sender;\n', '    } \n', '    \n', '    function mint(address recever, uint256 numberToMint) public onlyOwner{\n', '        _mint(recever, numberToMint);\n', '    }\n', '}']
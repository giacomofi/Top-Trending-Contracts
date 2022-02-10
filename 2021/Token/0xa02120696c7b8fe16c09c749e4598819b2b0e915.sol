['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "ERC20.sol";\n', 'import "ERC20Burnable.sol";\n', 'import "Pausable.sol";\n', 'import "Ownable.sol";\n', '\n', 'contract WirexToken is ERC20, ERC20Burnable, Pausable, Ownable {\n', '    constructor() ERC20("Wirex Token", "WXT") {}\n', '\n', '    function pause() public onlyOwner {\n', '        _pause();\n', '    }\n', '\n', '    function unpause() public onlyOwner {\n', '        _unpause();\n', '    }\n', '\n', '    function mint(address to, uint256 amount) public onlyOwner {\n', '        _mint(to, amount);\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount)\n', '        internal\n', '        whenNotPaused\n', '        override\n', '    {\n', '        super._beforeTokenTransfer(from, to, amount);\n', '    }\n', '}']
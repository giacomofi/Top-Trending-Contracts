['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.10;\n', '\n', 'import "./ERC20.sol";\n', 'import "./ERC20Detailed.sol";\n', 'import "./TokenRecover.sol";\n', 'import "./ERC20Pausable.sol";\n', '\n', 'contract ZENXToken is ERC20Detailed, TokenRecover, ERC20Pausable {\n', '    \n', '    uint256 private constant _initialSupply = 2300000000;\n', '    \n', '    constructor () public ERC20Detailed ( "Zenith", "ZENX", 18 ) \n', '    { _mint(_msgSender(), _initialSupply * (10 ** uint256(decimals()))); }\n', '\n', '    function initialSupply() public pure returns ( uint256 ){\n', '        return _initialSupply;\n', '    }\n', '}']
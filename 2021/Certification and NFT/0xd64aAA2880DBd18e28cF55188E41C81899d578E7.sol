['pragma solidity ^0.4.24;\n', '\n', 'import "./MintableToken.sol";\n', 'import "./CappedToken.sol";\n', '\n', 'contract Stew is CappedToken {\n', '\n', '    string public name = "Stewie Griffin ";\n', '    string public symbol = "Stew";\n', '    uint8 public decimals = 18;\n', '\n', '    constructor(\n', '        uint256 _cap\n', '        )\n', '        public\n', '        CappedToken( _cap ) {\n', '    }\n', '}']
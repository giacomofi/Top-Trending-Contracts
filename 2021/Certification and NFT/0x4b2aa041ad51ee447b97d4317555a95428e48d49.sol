['pragma solidity ^0.4.24;\n', '\n', 'import "./MintableToken.sol";\n', 'import "./CappedToken.sol";\n', '\n', 'contract NVST is CappedToken {\n', '\n', '    string public name = "Invest";\n', '    string public symbol = "NVST";\n', '    uint8 public decimals = 8;\n', '\n', '    constructor(\n', '        uint256 _cap\n', '        )\n', '        public\n', '        CappedToken( _cap ) {\n', '    }\n', '}']
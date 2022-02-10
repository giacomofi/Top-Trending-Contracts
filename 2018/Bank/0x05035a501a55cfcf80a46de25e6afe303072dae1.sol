['pragma solidity ^0.4.18;\n', '// import from contract/src/lib/math/_.sol ======\n', '// -- import from contract/src/lib/math/u256.sol ====== \n', '\n', 'library U256 {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {// assert(b > 0); // Solidity automatically throws when dividing by 0 \n', '        uint256 c = a / b; // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '} \n', '// import from contract/src/Solar/_.sol ======\n', '// -- import from contract/src/Solar/iNewPrice.sol ====== \n', '\n', 'interface INewPrice { \n', '    function getNewPrice(uint initial, uint origin) view public returns(uint);\n', '    function isNewPrice() view public returns(bool);\n', '}\n', 'contract NewPricePlanet is INewPrice { \n', '    using U256 for uint256; \n', '\n', '    function getNewPrice(uint origin, uint current) view public returns(uint) {\n', '        if (current < 0.02 ether) {\n', '            return current.mul(150).div(100);\n', '        } else if (current < 0.5 ether) {\n', '            return current.mul(135).div(100);\n', '        } else if (current < 2 ether) {\n', '            return current.mul(125).div(100);\n', '        } else if (current < 50 ether) {\n', '            return current.mul(117).div(100);\n', '        } else if (current < 200 ether) {\n', '            return current.mul(113).div(100);\n', '        } else {\n', '            return current.mul(110).div(100);\n', '        } \n', '    }\n', '\n', '    function isNewPrice() view public returns(bool) {\n', '        return true;\n', '    }\n', '}']
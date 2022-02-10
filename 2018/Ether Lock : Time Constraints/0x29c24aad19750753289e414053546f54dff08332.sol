['pragma solidity ^0.4.18;\n', '\n', 'contract Exponent {\n', '    function checkMultOverflow(uint x, uint y) public pure returns(bool) {\n', '        if(y == 0) return false;\n', '        return (((x*y) / y) != x);\n', '    }\n', '    \n', '    function exp(uint p, uint q, uint precision) public pure returns(uint){\n', '        uint n = 0;\n', '        uint nFact = 1;\n', '        uint currentP = 1;\n', '        uint currentQ = 1;\n', '        \n', '        uint sum = 0;\n', '        \n', '        while(true) {\n', '            if(checkMultOverflow(currentP, precision)) return sum; \n', '            if(checkMultOverflow(currentQ, nFact)) return sum;            \n', '            \n', '            sum += (currentP * precision ) / (currentQ * nFact);\n', '            \n', '            n++;\n', '            \n', '            if(checkMultOverflow(currentP,p)) return sum;            \n', '            if(checkMultOverflow(currentQ,q)) return sum;\n', '            if(checkMultOverflow(nFact,n)) return sum;\n', '            \n', '            currentP *= p;\n', '            currentQ *= q;\n', '            nFact *= n;\n', '        }\n', '\n', '    }\n', '}']
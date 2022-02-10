['pragma solidity ^0.4.23;\n', '\n', 'contract SloadTest {\n', '    uint256[] public buffer;\n', '    \n', '    function readAll() external returns (uint256 sum) {\n', '        sum = 0;\n', '        uint256 length = buffer.length;\n', '        for (uint256 i = 0; i < length; i++) {\n', '            sum += buffer[i];\n', '        }\n', '        return sum;\n', '    }\n', '    \n', '    function write() external {\n', '        buffer.push(buffer.length);\n', '    }\n', '    \n', '    function getLength() public view returns (uint256) {\n', '        return buffer.length;\n', '    }\n', '}']
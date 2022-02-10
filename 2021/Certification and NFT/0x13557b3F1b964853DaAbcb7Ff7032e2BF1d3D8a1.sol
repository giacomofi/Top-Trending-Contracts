['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-28\n', '*/\n', '\n', 'pragma solidity ^0.5.10;\n', '\n', 'interface IWET {\n', '    function accumulated(uint256 id) external view returns (uint256);\n', '}\n', '\n', 'contract Accoomulator {\n', '  IWET WET = IWET(0x76280AF9D18a868a0aF3dcA95b57DDE816c1aaf2);\n', '\n', '  function accoomulate(uint256[] calldata ids) external view returns (uint256[] memory) {\n', '    uint256[] memory wetAccumulated = new uint256[](ids.length);\n', '    for (uint256 i = 0; i < ids.length; i++) {\n', '      wetAccumulated[i] = WET.accumulated(i);\n', '    }\n', '    return wetAccumulated;\n', '  }\n', '}']
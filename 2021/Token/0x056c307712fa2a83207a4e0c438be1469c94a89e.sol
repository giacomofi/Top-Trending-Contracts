['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-01\n', '*/\n', '\n', 'pragma solidity ^0.5.16;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'contract BulkDistribute {\n', '    function batchClaim(address claim, bytes[] calldata data) external {\n', '       for(uint i = 0 ; i < data.length ; i++) {\n', '           claim.call(data[i]);\n', '       }\n', '    }\n', '}']
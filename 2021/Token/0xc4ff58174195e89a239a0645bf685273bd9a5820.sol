['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-06\n', '*/\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Banana Helper v0.9.0\n', '//\n', '// https://github.com/bokkypoobah/TokenToolz\n', '//\n', '// Deployed to 0xc4Ff58174195E89A239A0645BF685273bD9a5820\n', '//\n', '// SPDX-License-Identifier: MIT\n', '//\n', '// Enjoy.\n', '//\n', '// (c) BokkyPooBah / Bok Consulting Pty Ltd 2021. The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', 'interface IBanana {\n', '    function bananaNames(uint tokenId) external view returns (string memory);\n', '    function totalSupply() external view returns (uint);\n', '    function ownerOf(uint tokenId) external view returns (address);\n', '}\n', '\n', '\n', 'contract BananaHelper {\n', '    IBanana public constant bananas = IBanana(0xB9aB19454ccb145F9643214616c5571B8a4EF4f2);\n', '    \n', '    function owners() external view returns(address[] memory ) {\n', '        uint totalSupply = bananas.totalSupply();\n', '        address[] memory result = new address[](totalSupply);\n', '        for (uint tokenId = 0; tokenId < totalSupply; tokenId++) {\n', '            result[tokenId] = bananas.ownerOf(tokenId);\n', '        }\n', '        return result;\n', '    }\n', '\n', '    function names() external view returns(string[] memory ) {\n', '        uint totalSupply = bananas.totalSupply();\n', '        string[] memory result = new string[](totalSupply);\n', '        for (uint tokenId = 0; tokenId < totalSupply; tokenId++) {\n', '            result[tokenId] = bananas.bananaNames(tokenId);\n', '        }\n', '        return result;\n', '    }\n', '}']
['pragma solidity >=0.6.0 <0.9.0;\n', '//SPDX-License-Identifier: MIT\n', '\n', '// import "hardhat/console.sol";\n', '\n', 'import "./IERC1155.sol";\n', 'import "./IERC721.sol";\n', '\n', 'contract GFT {\n', '    constructor() public {}\n', '\n', '    function distributeSame1155s(\n', '        address nft,\n', '        uint256 tokenID,\n', '        address[] calldata recipients,\n', '        uint256[] calldata amounts\n', '    ) public payable {\n', '        require(recipients.length == amounts.length);\n', '\n', '        for (uint256 i = 0; i < recipients.length; i++) {\n', '            ERC1155(nft).safeTransferFrom(\n', '                msg.sender,\n', '                recipients[i],\n', '                tokenID,\n', '                amounts[i],\n', '                ""\n', '            );\n', '\n', '            if (msg.value > 0)\n', '                recipients[i].call{value: msg.value / recipients.length}("");\n', '        }\n', '    }\n', '\n', '    function distribute1155s(\n', '        address nft,\n', '        address[] calldata recipients,\n', '        uint256[] calldata tokenIDs,\n', '        uint256[] calldata amounts\n', '    ) public payable {\n', '        require(tokenIDs.length == recipients.length);\n', '        require(recipients.length == amounts.length);\n', '\n', '        for (uint256 i = 0; i < recipients.length; i++) {\n', '            ERC1155(nft).safeTransferFrom(\n', '                msg.sender,\n', '                recipients[i],\n', '                tokenIDs[i],\n', '                amounts[i],\n', '                ""\n', '            );\n', '\n', '            if (msg.value > 0)\n', '                recipients[i].call{value: msg.value / recipients.length}("");\n', '        }\n', '    }\n', '\n', '    function distribute721s(\n', '        address nft,\n', '        address[] calldata recipients,\n', '        uint256[] calldata tokenIDs\n', '    ) public payable {\n', '        require(tokenIDs.length == recipients.length);\n', '\n', '        for (uint256 i = 0; i < recipients.length; i++) {\n', '            ERC721(nft).safeTransferFrom(\n', '                msg.sender,\n', '                recipients[i],\n', '                tokenIDs[i]\n', '            );\n', '\n', '            if (msg.value > 0)\n', '                recipients[i].call{value: msg.value / recipients.length}("");\n', '        }\n', '    }\n', '}']
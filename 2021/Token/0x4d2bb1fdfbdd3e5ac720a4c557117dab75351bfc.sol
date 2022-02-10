['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-11\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract CryptoPunksMarket {\n', '    mapping(uint256 => address) public punkIndexToAddress;\n', '}\n', '\n', '/**\n', ' *\n', ' * @dev Proxy contract that retuns CryptoPunk owner via standard ERC-721 ownerOf() function\n', ' * Written by Ryley Ohlsen, 06.11.2021.\n', ' *\n', ' * See https://eips.ethereum.org/EIPS/eip-721\n', ' */\n', 'contract ownerOf_punks {\n', '    address public CRYPTOPUNKS_CONTRACT =\n', '        0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;\n', '\n', '    CryptoPunksMarket CryptoPunks;\n', '\n', '    constructor() public {\n', '        CryptoPunks = CryptoPunksMarket(CRYPTOPUNKS_CONTRACT);\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC721-ownerOf}.\n', '     */\n', '    function ownerOf(uint256 punkIndex) public view returns (address) {\n', '        require(punkIndex < 10000, "Punk index too high. Punk does not exist");\n', '        address owner = CryptoPunks.punkIndexToAddress(punkIndex);\n', '        return owner;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '// File: contracts/LegalDocument.sol\n', '\n', '/**\n', ' * @title LegalDocument\n', ' * @dev Basic version of a legal contract, allowing the owner to save a legal document and associate the governing law\n', ' * contact information.\n', ' */\n', 'contract LegalDocument {\n', '\n', '    string public documentIPFSHash;\n', '    string public governingLaw;\n', '\n', '    /**\n', '      * @dev Constructs a document\n', '      * @param ipfsHash The IPFS hash to the human readable legal contract.\n', '      * @param law The governing law\n', '      */\n', '    constructor(string ipfsHash, string law) public {\n', '        documentIPFSHash = ipfsHash;\n', '        governingLaw = law;\n', '    }\n', '\n', '}']
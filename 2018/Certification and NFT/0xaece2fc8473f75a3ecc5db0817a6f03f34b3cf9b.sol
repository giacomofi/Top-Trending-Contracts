['pragma solidity ^0.4.8;\n', '\n', 'contract TrustedDocument {\n', '\n', '    // Data structure for keeping document bundles signatures\n', '    // and metadata\n', '    struct Document {\n', '        // Id of the document, starting at 1\n', '        // 0 reserved for undefined / not found indicator\n', '        uint documentId;\n', '\n', '        // File name\n', '        string fileName;\n', '\n', '        // Hash of the main file\n', '        string documentContentSHA256;\n', '\n', '        // Hash of file containing extra metadata.\n', '        // Secured same way as content of the file \n', '        // size to save gas on transactions.\n', '        string documentMetadataSHA256;\n', '\n', '        // IPFS hash of directory containing the document and metadata binaries.\n', '        // Hash of the directory is build as merkle tree, so any change\n', '        // to any of the files in folder will invalidate this hash.\n', '        // So there is no need to keep IPFS hash for each single file.\n', '        string IPFSdirectoryHash;\n', '\n', '        // Block number\n', '        uint blockNumber;\n', '\n', '        // Document validity begin date, claimed by\n', '        // publisher. Documents can be published\n', '        // before they become valid, or in some\n', '        // cases later.\n', '        uint validFrom;\n', '\n', '        // Optional valid date to if relevant\n', '        uint validTo;\n', '\n', '        // Reference to document update. Document\n', '        // can be updated/replaced, but such update \n', '        // history cannot be hidden and it is \n', '        // persistant and auditable by everyone.\n', '        // Update can address document itself aswell\n', '        // as only metadata, where documentContentSHA256\n', '        // stays same between updates - it can be\n', '        // compared between versions.\n', '        // This works as one way linked list\n', '        uint updatedVersionId;\n', '    }\n', '\n', '    // Owner of the contract\n', '    address public owner;\n', '\n', '    // Needed for keeping new version address.\n', '    // If 0, then this contract is up to date.\n', '    // If not 0, no documents can be added to \n', '    // this version anymore. Contract becomes \n', '    // retired and documents are read only.\n', '    address public upgradedVersion;\n', '\n', '    // Total count of signed documents\n', '    uint public documentsCount;\n', '\n', '    // Base URL on which files will be stored\n', '    string public baseUrl;\n', '\n', '    // Map of signed documents\n', '    mapping(uint => Document) private documents;\n', '\n', '    // Event for confirmation of adding new document\n', '    event EventDocumentAdded(uint indexed documentId);\n', '    // Event for updating document\n', '    event EventDocumentUpdated(uint indexed referencingDocumentId, uint indexed updatedDocumentId);\n', '    // Event for going on retirement\n', '    event Retired(address indexed upgradedVersion);\n', '\n', '    // Restricts call to owner\n', '    modifier onlyOwner() {\n', '        if (msg.sender == owner) \n', '        _;\n', '    }\n', '\n', '    // Restricts call only when this version is up to date == upgradedVersion is not set to a new address\n', '    // or in other words, equal to 0\n', '    modifier ifNotRetired() {\n', '        if (upgradedVersion == 0) \n', '        _;\n', '    } \n', '\n', '    // Constructor\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        baseUrl = "_";\n', '    }\n', '\n', '    // Enables to transfer ownership. Works even after\n', '    // retirement. No documents can be added, but some\n', '    // other tasks still can be performed.\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '\n', '    // Adds new document - only owner and if not retired\n', '    function addDocument(\n', '        string _fileName,\n', '        string _documentContentSHA256, \n', '        string _documentMetadataSHA256,\n', '        string _IPFSdirectoryHash,  \n', '        uint _validFrom, uint _validTo) public onlyOwner ifNotRetired {\n', '        // Documents incremented before use so documents ids will\n', '        // start with 1 not 0 (shifter by 1)\n', '        // 0 is reserved as undefined value\n', '        uint documentId = documentsCount+1;\n', '        //\n', '        emit EventDocumentAdded(documentId);\n', '        documents[documentId] = Document(\n', '            documentId, \n', '            _fileName, \n', '            _documentContentSHA256, \n', '            _documentMetadataSHA256, \n', '            _IPFSdirectoryHash,\n', '            block.number, \n', '            _validFrom, \n', '            _validTo, \n', '            0\n', '        );\n', '        documentsCount++;\n', '    }\n', '\n', '    // Gets total count of documents\n', '    function getDocumentsCount() public view\n', '    returns (uint)\n', '    {\n', '        return documentsCount;\n', '    }\n', '\n', '    // Retire if newer version will be available. To persist\n', '    // integrity, address of newer version needs to be provided.\n', '    // After retirement there is no way to add more documents.\n', '    function retire(address _upgradedVersion) public onlyOwner ifNotRetired {\n', '        // TODO - check if such contract exists\n', '        upgradedVersion = _upgradedVersion;\n', '        emit Retired(upgradedVersion);\n', '    }\n', '\n', '    // Gets document with ID\n', '    function getDocument(uint _documentId) public view\n', '    returns (\n', '        uint documentId,\n', '        string fileName,\n', '        string documentContentSHA256,\n', '        string documentMetadataSHA256,\n', '        string IPFSdirectoryHash,\n', '        uint blockNumber,\n', '        uint validFrom,\n', '        uint validTo,\n', '        uint updatedVersionId\n', '    ) {\n', '        Document memory doc = documents[_documentId];\n', '        return (\n', '            doc.documentId, \n', '            doc.fileName, \n', '            doc.documentContentSHA256, \n', '            doc.documentMetadataSHA256, \n', '            doc.IPFSdirectoryHash,\n', '            doc.blockNumber, \n', '            doc.validFrom, \n', '            doc.validTo, \n', '            doc.updatedVersionId\n', '            );\n', '    }\n', '\n', '    // Gets document updatedVersionId with ID\n', '    // 0 - no update for document\n', '    function getDocumentUpdatedVersionId(uint _documentId) public view\n', '    returns (uint) \n', '    {\n', '        Document memory doc = documents[_documentId];\n', '        return doc.updatedVersionId;\n', '    }\n', '\n', '    // Gets base URL so everyone will know where to seek for files storage / GUI.\n', '    // Multiple URLS can be set in the string and separated by comma\n', '    function getBaseUrl() public view\n', '    returns (string) \n', '    {\n', '        return baseUrl;\n', '    }\n', '\n', '    // Set base URL even on retirement. Files will have to be maintained\n', '    // for a very long time, and for example domain name could change.\n', '    // To manage this, owner should be able to set base url anytime\n', '    function setBaseUrl(string _baseUrl) public onlyOwner {\n', '        baseUrl = _baseUrl;\n', '    }\n', '\n', '    // Utility to help seek fo specyfied document\n', '    function getFirstDocumentIdStartingAtValidFrom(uint _unixTimeFrom) public view\n', '    returns (uint) \n', '    {\n', '        for (uint i = 0; i < documentsCount; i++) {\n', '            Document memory doc = documents[i];\n', '            if (doc.validFrom>=_unixTimeFrom) {\n', '                return i;\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // Utility to help seek fo specyfied document\n', '    function getFirstDocumentIdBetweenDatesValidFrom(uint _unixTimeStarting, uint _unixTimeEnding) public view\n', '    returns (uint firstID, uint lastId) \n', '    {\n', '        firstID = 0;\n', '        lastId = 0;\n', '        //\n', '        for (uint i = 0; i < documentsCount; i++) {\n', '            Document memory doc = documents[i];\n', '            if (firstID==0) {\n', '                if (doc.validFrom>=_unixTimeStarting) {\n', '                    firstID = i;\n', '                }\n', '            } else {\n', '                if (doc.validFrom<=_unixTimeEnding) {\n', '                    lastId = i;\n', '                }\n', '            }\n', '        }\n', '        //\n', '        if ((firstID>0)&&(lastId==0)&&(_unixTimeStarting<_unixTimeEnding)) {\n', '            lastId = documentsCount;\n', '        }\n', '    }\n', '\n', '    // Utility to help seek fo specyfied document\n', '    function getDocumentIdWithContentHash(string _documentContentSHA256) public view\n', '    returns (uint) \n', '    {\n', '        bytes32 documentContentSHA256Keccak256 = keccak256(_documentContentSHA256);\n', '        for (uint i = 0; i < documentsCount; i++) {\n', '            Document memory doc = documents[i];\n', '            if (keccak256(doc.documentContentSHA256)==documentContentSHA256Keccak256) {\n', '                return i;\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // Utility to help seek fo specyfied document\n', '    function getDocumentIdWithIPFSdirectoryHash(string _IPFSdirectoryHash) public view\n', '    returns (uint) \n', '    {\n', '        bytes32 IPFSdirectoryHashSHA256Keccak256 = keccak256(_IPFSdirectoryHash);\n', '        for (uint i = 0; i < documentsCount; i++) {\n', '            Document memory doc = documents[i];\n', '            if (keccak256(doc.IPFSdirectoryHash)==IPFSdirectoryHashSHA256Keccak256) {\n', '                return i;\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // Utility to help seek fo specyfied document\n', '    function getDocumentIdWithName(string _fileName) public view\n', '    returns (uint) \n', '    {\n', '        bytes32 fileNameKeccak256 = keccak256(_fileName);\n', '        for (uint i = 0; i < documentsCount; i++) {\n', '            Document memory doc = documents[i];\n', '            if (keccak256(doc.fileName)==fileNameKeccak256) {\n', '                return i;\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // To update document:\n', '    // 1 - Add new version as ordinary document\n', '    // 2 - Call this function to link old version with update\n', '    function updateDocument(uint referencingDocumentId, uint updatedDocumentId) public onlyOwner ifNotRetired {\n', '        Document storage referenced = documents[referencingDocumentId];\n', '        Document memory updated = documents[updatedDocumentId];\n', '        //\n', '        referenced.updatedVersionId = updated.documentId;\n', '        emit EventDocumentUpdated(referenced.updatedVersionId,updated.documentId);\n', '    }\n', '}']
['pragma solidity ^0.4.8;\n', '\n', 'contract TrustedDocument {\n', '\n', '    // Data structure for keeping document bundles signatures\n', '    // and metadata\n', '    struct Document {\n', '        // Id of the document, starting at 1\n', '        // 0 reserved for undefined / not found indicator\n', '        uint documentId;\n', '\n', '        // File name\n', '        string fileName;\n', '\n', '        // Hash of the main file\n', '        string documentContentSHA256;\n', '\n', '        // Hash of file containing extra metadata.\n', '        // Secured same way as content of the file \n', '        // size to save gas on transactions.\n', '        string documentMetadataSHA256;\n', '\n', '        // IPFS hash of directory containing the document and metadata binaries.\n', '        // Hash of the directory is build as merkle tree, so any change\n', '        // to any of the files in folder will invalidate this hash.\n', '        // So there is no need to keep IPFS hash for each single file.\n', '        string IPFSdirectoryHash;\n', '\n', '        // Block number\n', '        uint blockNumber;\n', '\n', '        // Document validity begin date, claimed by\n', '        // publisher. Documents can be published\n', '        // before they become valid, or in some\n', '        // cases later.\n', '        uint validFrom;\n', '\n', '        // Optional valid date to if relevant\n', '        uint validTo;\n', '\n', '        // Reference to document update. Document\n', '        // can be updated/replaced, but such update \n', '        // history cannot be hidden and it is \n', '        // persistant and auditable by everyone.\n', '        // Update can address document itself aswell\n', '        // as only metadata, where documentContentSHA256\n', '        // stays same between updates - it can be\n', '        // compared between versions.\n', '        // This works as one way linked list\n', '        uint updatedVersionId;\n', '    }\n', '\n', '    // Owner of the contract\n', '    address public owner;\n', '\n', '    // Needed for keeping new version address.\n', '    // If 0, then this contract is up to date.\n', '    // If not 0, no documents can be added to \n', '    // this version anymore. Contract becomes \n', '    // retired and documents are read only.\n', '    address public upgradedVersion;\n', '\n', '    // Total count of signed documents\n', '    uint public documentsCount;\n', '\n', '    // Base URL on which files will be stored\n', '    string public baseUrl;\n', '\n', '    // Map of signed documents\n', '    mapping(uint => Document) private documents;\n', '\n', '    // Event for confirmation of adding new document\n', '    event EventDocumentAdded(uint indexed documentId);\n', '    // Event for updating document\n', '    event EventDocumentUpdated(uint indexed referencingDocumentId, uint indexed updatedDocumentId);\n', '    // Event for going on retirement\n', '    event Retired(address indexed upgradedVersion);\n', '\n', '    // Restricts call to owner\n', '    modifier onlyOwner() {\n', '        if (msg.sender == owner) \n', '        _;\n', '    }\n', '\n', '    // Restricts call only when this version is up to date == upgradedVersion is not set to a new address\n', '    // or in other words, equal to 0\n', '    modifier ifNotRetired() {\n', '        if (upgradedVersion == 0) \n', '        _;\n', '    } \n', '\n', '    // Constructor\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        baseUrl = "_";\n', '    }\n', '\n', '    // Enables to transfer ownership. Works even after\n', '    // retirement. No documents can be added, but some\n', '    // other tasks still can be performed.\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '\n', '    // Adds new document - only owner and if not retired\n', '    function addDocument(\n', '        string _fileName,\n', '        string _documentContentSHA256, \n', '        string _documentMetadataSHA256,\n', '        string _IPFSdirectoryHash,  \n', '        uint _validFrom, uint _validTo) public onlyOwner ifNotRetired {\n', '        // Documents incremented before use so documents ids will\n', '        // start with 1 not 0 (shifter by 1)\n', '        // 0 is reserved as undefined value\n', '        uint documentId = documentsCount+1;\n', '        //\n', '        emit EventDocumentAdded(documentId);\n', '        documents[documentId] = Document(\n', '            documentId, \n', '            _fileName, \n', '            _documentContentSHA256, \n', '            _documentMetadataSHA256, \n', '            _IPFSdirectoryHash,\n', '            block.number, \n', '            _validFrom, \n', '            _validTo, \n', '            0\n', '        );\n', '        documentsCount++;\n', '    }\n', '\n', '    // Gets total count of documents\n', '    function getDocumentsCount() public view\n', '    returns (uint)\n', '    {\n', '        return documentsCount;\n', '    }\n', '\n', '    // Retire if newer version will be available. To persist\n', '    // integrity, address of newer version needs to be provided.\n', '    // After retirement there is no way to add more documents.\n', '    function retire(address _upgradedVersion) public onlyOwner ifNotRetired {\n', '        // TODO - check if such contract exists\n', '        upgradedVersion = _upgradedVersion;\n', '        emit Retired(upgradedVersion);\n', '    }\n', '\n', '    // Gets document with ID\n', '    function getDocument(uint _documentId) public view\n', '    returns (\n', '        uint documentId,\n', '        string fileName,\n', '        string documentContentSHA256,\n', '        string documentMetadataSHA256,\n', '        string IPFSdirectoryHash,\n', '        uint blockNumber,\n', '        uint validFrom,\n', '        uint validTo,\n', '        uint updatedVersionId\n', '    ) {\n', '        Document memory doc = documents[_documentId];\n', '        return (\n', '            doc.documentId, \n', '            doc.fileName, \n', '            doc.documentContentSHA256, \n', '            doc.documentMetadataSHA256, \n', '            doc.IPFSdirectoryHash,\n', '            doc.blockNumber, \n', '            doc.validFrom, \n', '            doc.validTo, \n', '            doc.updatedVersionId\n', '            );\n', '    }\n', '\n', '    // Gets document updatedVersionId with ID\n', '    // 0 - no update for document\n', '    function getDocumentUpdatedVersionId(uint _documentId) public view\n', '    returns (uint) \n', '    {\n', '        Document memory doc = documents[_documentId];\n', '        return doc.updatedVersionId;\n', '    }\n', '\n', '    // Gets base URL so everyone will know where to seek for files storage / GUI.\n', '    // Multiple URLS can be set in the string and separated by comma\n', '    function getBaseUrl() public view\n', '    returns (string) \n', '    {\n', '        return baseUrl;\n', '    }\n', '\n', '    // Set base URL even on retirement. Files will have to be maintained\n', '    // for a very long time, and for example domain name could change.\n', '    // To manage this, owner should be able to set base url anytime\n', '    function setBaseUrl(string _baseUrl) public onlyOwner {\n', '        baseUrl = _baseUrl;\n', '    }\n', '\n', '    // Utility to help seek fo specyfied document\n', '    function getFirstDocumentIdStartingAtValidFrom(uint _unixTimeFrom) public view\n', '    returns (uint) \n', '    {\n', '        for (uint i = 0; i < documentsCount; i++) {\n', '            Document memory doc = documents[i];\n', '            if (doc.validFrom>=_unixTimeFrom) {\n', '                return i;\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // Utility to help seek fo specyfied document\n', '    function getFirstDocumentIdBetweenDatesValidFrom(uint _unixTimeStarting, uint _unixTimeEnding) public view\n', '    returns (uint firstID, uint lastId) \n', '    {\n', '        firstID = 0;\n', '        lastId = 0;\n', '        //\n', '        for (uint i = 0; i < documentsCount; i++) {\n', '            Document memory doc = documents[i];\n', '            if (firstID==0) {\n', '                if (doc.validFrom>=_unixTimeStarting) {\n', '                    firstID = i;\n', '                }\n', '            } else {\n', '                if (doc.validFrom<=_unixTimeEnding) {\n', '                    lastId = i;\n', '                }\n', '            }\n', '        }\n', '        //\n', '        if ((firstID>0)&&(lastId==0)&&(_unixTimeStarting<_unixTimeEnding)) {\n', '            lastId = documentsCount;\n', '        }\n', '    }\n', '\n', '    // Utility to help seek fo specyfied document\n', '    function getDocumentIdWithContentHash(string _documentContentSHA256) public view\n', '    returns (uint) \n', '    {\n', '        bytes32 documentContentSHA256Keccak256 = keccak256(_documentContentSHA256);\n', '        for (uint i = 0; i < documentsCount; i++) {\n', '            Document memory doc = documents[i];\n', '            if (keccak256(doc.documentContentSHA256)==documentContentSHA256Keccak256) {\n', '                return i;\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // Utility to help seek fo specyfied document\n', '    function getDocumentIdWithIPFSdirectoryHash(string _IPFSdirectoryHash) public view\n', '    returns (uint) \n', '    {\n', '        bytes32 IPFSdirectoryHashSHA256Keccak256 = keccak256(_IPFSdirectoryHash);\n', '        for (uint i = 0; i < documentsCount; i++) {\n', '            Document memory doc = documents[i];\n', '            if (keccak256(doc.IPFSdirectoryHash)==IPFSdirectoryHashSHA256Keccak256) {\n', '                return i;\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // Utility to help seek fo specyfied document\n', '    function getDocumentIdWithName(string _fileName) public view\n', '    returns (uint) \n', '    {\n', '        bytes32 fileNameKeccak256 = keccak256(_fileName);\n', '        for (uint i = 0; i < documentsCount; i++) {\n', '            Document memory doc = documents[i];\n', '            if (keccak256(doc.fileName)==fileNameKeccak256) {\n', '                return i;\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // To update document:\n', '    // 1 - Add new version as ordinary document\n', '    // 2 - Call this function to link old version with update\n', '    function updateDocument(uint referencingDocumentId, uint updatedDocumentId) public onlyOwner ifNotRetired {\n', '        Document storage referenced = documents[referencingDocumentId];\n', '        Document memory updated = documents[updatedDocumentId];\n', '        //\n', '        referenced.updatedVersionId = updated.documentId;\n', '        emit EventDocumentUpdated(referenced.updatedVersionId,updated.documentId);\n', '    }\n', '}']

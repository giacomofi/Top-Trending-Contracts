['pragma solidity ^0.4.21;\n', '\n', '/// @title Endorsements\n', '/// @author AlmavivA S.p.A. (Enrica D&#39;Agostini, Giuseppe Bertone, et al.)\n', '/// @notice This contract add external/internal endorsement to supply chain actors and operations\n', '/// @dev This contract is part of the WineSupplyChain contract, and it is not meant to be used as\n', '/// a standalone contract\n', 'contract Endorsements {\n', '\n', '    struct Endorsement {\n', '        bool positive;\n', '        string title;\n', '        string description;\n', '        address endorser;\n', '    }\n', '\n', '    mapping (address => Endorsement[]) public userEndorsements;\n', '    mapping (bytes32 => Endorsement[]) public vineyardEndorsements;\n', '    mapping (bytes32 => Endorsement[]) public harvestOperationEndorsements;\n', '    mapping (bytes32 => Endorsement[]) public wineryOperationEndorsements;\n', '    mapping (bytes32 => Endorsement[]) public productOperationEndorsements;\n', '\n', '    function Endorsements() public { }\n', '\n', '    /// @notice Add new endorsement to an actor\n', '    /// @param user Actor&#39;s on-chain identity\n', '    /// @param positive True if it is a `positive` endorsement\n', '    /// @param title Endorsment&#39;s short description\n', '    /// @param description Endorsement&#39;s full description\n', '    function addUserEndorsement(\n', '        address user,\n', '        bool positive,\n', '        string title,\n', '        string description\n', '    )\n', '        external\n', '        returns (bool success)\n', '    {\n', '        userEndorsements[user].push(Endorsement(positive, title, description, msg.sender));\n', '        return true;\n', '    }\n', '\n', '    /// @notice Add new endorsement to a vineyard\n', '    /// @param _mappingID On-chain key to identify the harvest operation\n', '    /// @param _index Index of vineyard for the harvest\n', '    /// @param positive True if it is a `positive` endorsement\n', '    /// @param title Endorsement&#39;s short description\n', '    /// @param description Endorsement&#39;s full description\n', '    function addVineyardEndorsement(\n', '        string _mappingID,\n', '        uint _index,\n', '        bool positive,\n', '        string title,\n', '        string description\n', '    )\n', '        external\n', '        returns (bool success)\n', '    {\n', '        vineyardEndorsements[keccak256(_mappingID, _index)].push(\n', '                Endorsement(positive, title, description, msg.sender)\n', '        );\n', '        return true;\n', '    }\n', '\n', '    /// @notice Add new endorsement to harvest operation\n', '    /// @param _mappingID On-chain key to identify the harvest operation\n', '    /// @param positive True if it is a `positive` endorsement\n', '    /// @param title Endorsement&#39;s short description\n', '    /// @param description Endorsement&#39;s full description\n', '    function addHarvestOperationEndorsement(\n', '        string _mappingID,\n', '        bool positive,\n', '        string title,\n', '        string description\n', '    )\n', '        external\n', '        returns (bool success)\n', '    {\n', '        harvestOperationEndorsements[keccak256(_mappingID)].push(\n', '                Endorsement(positive, title, description, msg.sender)\n', '        );\n', '        return true;\n', '    }\n', '\n', '    /// @notice Add new endorsement to a winery operation\n', '    /// @param _mappingID On-chain key to identify the winery operation\n', '    /// @param _index Index of operation\n', '    /// @param positive True if it is a `positive` endorsement\n', '    /// @param title Endorsement&#39;s short description\n', '    /// @param description Endorsement&#39;s full description\n', '    function addWineryOperationEndorsement(\n', '        string _mappingID,\n', '        uint _index,\n', '        bool positive,\n', '        string title,\n', '        string description\n', '    )\n', '        external\n', '        returns (bool success)\n', '    {\n', '        wineryOperationEndorsements[keccak256(_mappingID, _index)].push(\n', '                Endorsement(positive, title, description, msg.sender)\n', '        );\n', '        return true;\n', '    }\n', '\n', '    /// @notice Add new endorsement to product winery operation\n', '    /// @param _mappingID On-chain key to identify the winery operation\n', '    /// @param _operationIndex Index of operation\n', '    /// @param _productIndex Index of operation product\n', '    /// @param positive True if it is a `positive` endorsement\n', '    /// @param title Endorsement&#39;s short description\n', '    /// @param description Endorsement&#39;s full description\n', '    function addProductEndorsement(\n', '        string _mappingID,\n', '        uint _operationIndex,\n', '        int _productIndex,\n', '        bool positive,\n', '        string title,\n', '        string description\n', '    )\n', '        external\n', '        returns (bool success)\n', '    {\n', '        require(_productIndex > 0);\n', '        productOperationEndorsements[keccak256(_mappingID, _operationIndex, _productIndex)].push(\n', '                Endorsement(positive, title, description, msg.sender)\n', '        );\n', '        return true;\n', '    }\n', '\n', '}']
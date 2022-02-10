['pragma solidity 0.4.19;\n', '\n', '\n', '/// @title Ethereum Claims Registry - A repository storing claims issued\n', '///        from any Ethereum account to any other Ethereum account.\n', 'contract EthereumClaimsRegistry {\n', '\n', '    mapping(address => mapping(address => mapping(bytes32 => bytes32))) public registry;\n', '\n', '    event ClaimSet(\n', '        address indexed issuer,\n', '        address indexed subject,\n', '        bytes32 indexed key,\n', '        bytes32 value,\n', '        uint updatedAt);\n', '\n', '    event ClaimRemoved(\n', '        address indexed issuer,\n', '        address indexed subject,\n', '        bytes32 indexed key,\n', '        uint removedAt);\n', '\n', '    /// @dev Create or update a claim\n', '    /// @param subject The address the claim is being issued to\n', '    /// @param key The key used to identify the claim\n', '    /// @param value The data associated with the claim\n', '    function setClaim(address subject, bytes32 key, bytes32 value) public {\n', '        registry[msg.sender][subject][key] = value;\n', '        ClaimSet(msg.sender, subject, key, value, now);\n', '    }\n', '\n', '    /// @dev Create or update a claim about yourself\n', '    /// @param key The key used to identify the claim\n', '    /// @param value The data associated with the claim\n', '    function setSelfClaim(bytes32 key, bytes32 value) public {\n', '        setClaim(msg.sender, key, value);\n', '    }\n', '\n', '    /// @dev Allows to retrieve claims from other contracts as well as other off-chain interfaces\n', '    /// @param issuer The address of the issuer of the claim\n', '    /// @param subject The address to which the claim was issued to\n', '    /// @param key The key used to identify the claim\n', '    function getClaim(address issuer, address subject, bytes32 key) public constant returns(bytes32) {\n', '        return registry[issuer][subject][key];\n', '    }\n', '\n', '    /// @dev Allows to remove a claims from the registry.\n', '    ///      This can only be done by the issuer or the subject of the claim.\n', '    /// @param issuer The address of the issuer of the claim\n', '    /// @param subject The address to which the claim was issued to\n', '    /// @param key The key used to identify the claim\n', '    function removeClaim(address issuer, address subject, bytes32 key) public {\n', '        require(msg.sender == issuer || msg.sender == subject);\n', '        require(registry[issuer][subject][key] != 0);\n', '        delete registry[issuer][subject][key];\n', '        ClaimRemoved(msg.sender, subject, key, now);\n', '    }\n', '}\n', '\n', '\n', '/// @title Revoke and Publish - an interface for publishing data and \n', '///        rotating access to publish new data\n', 'contract RevokeAndPublish {\n', '\n', '    event Revocation(\n', '        address indexed genesis,\n', '        address indexed from,\n', '        address indexed to,\n', '        uint updatedAt);\n', '\n', '    mapping(address => address) public manager;\n', '    EthereumClaimsRegistry registry = EthereumClaimsRegistry(0xAcA1BCd8D0f5A9BFC95aFF331Da4c250CD9ac2Da);\n', '\n', '    function revokeAndPublish(address genesis, bytes32 key, bytes32 data, address newManager) public {\n', '        publish(genesis, key, data);\n', '        Revocation(genesis, manager[genesis], newManager, now);\n', '        manager[genesis] = newManager;\n', '    }\n', '\n', '    /// @dev Publish some data\n', '    /// @param genesis The address of the first publisher\n', '    /// @param key The key used to identify the claim\n', '    /// @param data The data associated with the claim\n', '    function publish(address genesis, bytes32 key, bytes32 data) public {\n', '        require((manager[genesis] == 0x0 && genesis == msg.sender) || manager[genesis] == msg.sender);\n', '        registry.setClaim(genesis, key, data);\n', '    }\n', '\n', '    /// @dev Lookup the currently published data for genesis\n', '    /// @param genesis The address of the first publisher\n', '    /// @param key The key used to identify the claim\n', '    function lookup(address genesis, bytes32 key) public constant returns(bytes32) {\n', '      return registry.getClaim(address(this), genesis, key);\n', '    }\n', '}']
['pragma solidity 0.4.19;\n', '\n', '\n', '/// @title Ethereum Claims Registry - A repository storing claims issued\n', '///        from any Ethereum account to any other Ethereum account.\n', 'contract EthereumClaimsRegistry {\n', '\n', '    mapping(address => mapping(address => mapping(bytes32 => bytes32))) public registry;\n', '\n', '    event ClaimSet(\n', '        address indexed issuer,\n', '        address indexed subject,\n', '        bytes32 indexed key,\n', '        bytes32 value,\n', '        uint updatedAt);\n', '\n', '    event ClaimRemoved(\n', '        address indexed issuer,\n', '        address indexed subject,\n', '        bytes32 indexed key,\n', '        uint removedAt);\n', '\n', '    /// @dev Create or update a claim\n', '    /// @param subject The address the claim is being issued to\n', '    /// @param key The key used to identify the claim\n', '    /// @param value The data associated with the claim\n', '    function setClaim(address subject, bytes32 key, bytes32 value) public {\n', '        registry[msg.sender][subject][key] = value;\n', '        ClaimSet(msg.sender, subject, key, value, now);\n', '    }\n', '\n', '    /// @dev Create or update a claim about yourself\n', '    /// @param key The key used to identify the claim\n', '    /// @param value The data associated with the claim\n', '    function setSelfClaim(bytes32 key, bytes32 value) public {\n', '        setClaim(msg.sender, key, value);\n', '    }\n', '\n', '    /// @dev Allows to retrieve claims from other contracts as well as other off-chain interfaces\n', '    /// @param issuer The address of the issuer of the claim\n', '    /// @param subject The address to which the claim was issued to\n', '    /// @param key The key used to identify the claim\n', '    function getClaim(address issuer, address subject, bytes32 key) public constant returns(bytes32) {\n', '        return registry[issuer][subject][key];\n', '    }\n', '\n', '    /// @dev Allows to remove a claims from the registry.\n', '    ///      This can only be done by the issuer or the subject of the claim.\n', '    /// @param issuer The address of the issuer of the claim\n', '    /// @param subject The address to which the claim was issued to\n', '    /// @param key The key used to identify the claim\n', '    function removeClaim(address issuer, address subject, bytes32 key) public {\n', '        require(msg.sender == issuer || msg.sender == subject);\n', '        require(registry[issuer][subject][key] != 0);\n', '        delete registry[issuer][subject][key];\n', '        ClaimRemoved(msg.sender, subject, key, now);\n', '    }\n', '}\n', '\n', '\n', '/// @title Revoke and Publish - an interface for publishing data and \n', '///        rotating access to publish new data\n', 'contract RevokeAndPublish {\n', '\n', '    event Revocation(\n', '        address indexed genesis,\n', '        address indexed from,\n', '        address indexed to,\n', '        uint updatedAt);\n', '\n', '    mapping(address => address) public manager;\n', '    EthereumClaimsRegistry registry = EthereumClaimsRegistry(0xAcA1BCd8D0f5A9BFC95aFF331Da4c250CD9ac2Da);\n', '\n', '    function revokeAndPublish(address genesis, bytes32 key, bytes32 data, address newManager) public {\n', '        publish(genesis, key, data);\n', '        Revocation(genesis, manager[genesis], newManager, now);\n', '        manager[genesis] = newManager;\n', '    }\n', '\n', '    /// @dev Publish some data\n', '    /// @param genesis The address of the first publisher\n', '    /// @param key The key used to identify the claim\n', '    /// @param data The data associated with the claim\n', '    function publish(address genesis, bytes32 key, bytes32 data) public {\n', '        require((manager[genesis] == 0x0 && genesis == msg.sender) || manager[genesis] == msg.sender);\n', '        registry.setClaim(genesis, key, data);\n', '    }\n', '\n', '    /// @dev Lookup the currently published data for genesis\n', '    /// @param genesis The address of the first publisher\n', '    /// @param key The key used to identify the claim\n', '    function lookup(address genesis, bytes32 key) public constant returns(bytes32) {\n', '      return registry.getClaim(address(this), genesis, key);\n', '    }\n', '}']
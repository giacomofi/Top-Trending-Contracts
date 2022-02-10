['pragma solidity ^0.4.20;\n', '\n', 'interface ENS {\n', '\n', '    // Logged when the owner of a node assigns a new owner to a subnode.\n', '    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);\n', '\n', '    // Logged when the owner of a node transfers ownership to a new account.\n', '    event Transfer(bytes32 indexed node, address owner);\n', '\n', '    // Logged when the resolver for a node changes.\n', '    event NewResolver(bytes32 indexed node, address resolver);\n', '\n', '    // Logged when the TTL of a node changes\n', '    event NewTTL(bytes32 indexed node, uint64 ttl);\n', '\n', '\n', '    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns (bytes32);\n', '    function setResolver(bytes32 node, address resolver) external;\n', '    function setOwner(bytes32 node, address owner) external;\n', '    function setTTL(bytes32 node, uint64 ttl) external;\n', '    function owner(bytes32 node) external view returns (address);\n', '    function resolver(bytes32 node) external view returns (address);\n', '    function ttl(bytes32 node) external view returns (uint64);\n', '}\n', '\n', '\n', '/**\n', ' * A registrar that allocates subdomains to the first admin to claim them\n', ' */\n', 'contract SvEnsRegistrar {\n', '    ENS public ens;\n', '    bytes32 public rootNode;\n', '    mapping (bytes32 => bool) knownNodes;\n', '    mapping (address => bool) admins;\n', '    address public owner;\n', '\n', '\n', '    modifier req(bool c) {\n', '        require(c);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Constructor.\n', '     * @param ensAddr The address of the ENS registry.\n', '     * @param node The node that this registrar administers.\n', '     */\n', '    function SvEnsRegistrar(ENS ensAddr, bytes32 node) public {\n', '        ens = ensAddr;\n', '        rootNode = node;\n', '        admins[msg.sender] = true;\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function addAdmin(address newAdmin) req(admins[msg.sender]) external {\n', '        admins[newAdmin] = true;\n', '    }\n', '\n', '    function remAdmin(address oldAdmin) req(admins[msg.sender]) external {\n', '        require(oldAdmin != msg.sender && oldAdmin != owner);\n', '        admins[oldAdmin] = false;\n', '    }\n', '\n', '    function chOwner(address newOwner, bool remPrevOwnerAsAdmin) req(msg.sender == owner) external {\n', '        if (remPrevOwnerAsAdmin) {\n', '            admins[owner] = false;\n', '        }\n', '        owner = newOwner;\n', '        admins[newOwner] = true;\n', '    }\n', '\n', '    /**\n', '     * Register a name that&#39;s not currently registered\n', '     * @param subnode The hash of the label to register.\n', '     * @param _owner The address of the new owner.\n', '     */\n', '    function register(bytes32 subnode, address _owner) req(admins[msg.sender]) external {\n', '        _setSubnodeOwner(subnode, _owner);\n', '    }\n', '\n', '    /**\n', '     * Register a name that&#39;s not currently registered\n', '     * @param subnodeStr The label to register.\n', '     * @param _owner The address of the new owner.\n', '     */\n', '    function registerName(string subnodeStr, address _owner) req(admins[msg.sender]) external {\n', '        // labelhash\n', '        bytes32 subnode = keccak256(subnodeStr);\n', '        _setSubnodeOwner(subnode, _owner);\n', '    }\n', '\n', '    /**\n', '     * INTERNAL - Register a name that&#39;s not currently registered\n', '     * @param subnode The hash of the label to register.\n', '     * @param _owner The address of the new owner.\n', '     */\n', '    function _setSubnodeOwner(bytes32 subnode, address _owner) internal {\n', '        require(!knownNodes[subnode]);\n', '        knownNodes[subnode] = true;\n', '        ens.setSubnodeOwner(rootNode, subnode, _owner);\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'interface ENS {\n', '\n', '    // Logged when the owner of a node assigns a new owner to a subnode.\n', '    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);\n', '\n', '    // Logged when the owner of a node transfers ownership to a new account.\n', '    event Transfer(bytes32 indexed node, address owner);\n', '\n', '    // Logged when the resolver for a node changes.\n', '    event NewResolver(bytes32 indexed node, address resolver);\n', '\n', '    // Logged when the TTL of a node changes\n', '    event NewTTL(bytes32 indexed node, uint64 ttl);\n', '\n', '\n', '    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns (bytes32);\n', '    function setResolver(bytes32 node, address resolver) external;\n', '    function setOwner(bytes32 node, address owner) external;\n', '    function setTTL(bytes32 node, uint64 ttl) external;\n', '    function owner(bytes32 node) external view returns (address);\n', '    function resolver(bytes32 node) external view returns (address);\n', '    function ttl(bytes32 node) external view returns (uint64);\n', '}\n', '\n', '\n', '/**\n', ' * A registrar that allocates subdomains to the first admin to claim them\n', ' */\n', 'contract SvEnsRegistrar {\n', '    ENS public ens;\n', '    bytes32 public rootNode;\n', '    mapping (bytes32 => bool) knownNodes;\n', '    mapping (address => bool) admins;\n', '    address public owner;\n', '\n', '\n', '    modifier req(bool c) {\n', '        require(c);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * Constructor.\n', '     * @param ensAddr The address of the ENS registry.\n', '     * @param node The node that this registrar administers.\n', '     */\n', '    function SvEnsRegistrar(ENS ensAddr, bytes32 node) public {\n', '        ens = ensAddr;\n', '        rootNode = node;\n', '        admins[msg.sender] = true;\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function addAdmin(address newAdmin) req(admins[msg.sender]) external {\n', '        admins[newAdmin] = true;\n', '    }\n', '\n', '    function remAdmin(address oldAdmin) req(admins[msg.sender]) external {\n', '        require(oldAdmin != msg.sender && oldAdmin != owner);\n', '        admins[oldAdmin] = false;\n', '    }\n', '\n', '    function chOwner(address newOwner, bool remPrevOwnerAsAdmin) req(msg.sender == owner) external {\n', '        if (remPrevOwnerAsAdmin) {\n', '            admins[owner] = false;\n', '        }\n', '        owner = newOwner;\n', '        admins[newOwner] = true;\n', '    }\n', '\n', '    /**\n', "     * Register a name that's not currently registered\n", '     * @param subnode The hash of the label to register.\n', '     * @param _owner The address of the new owner.\n', '     */\n', '    function register(bytes32 subnode, address _owner) req(admins[msg.sender]) external {\n', '        _setSubnodeOwner(subnode, _owner);\n', '    }\n', '\n', '    /**\n', "     * Register a name that's not currently registered\n", '     * @param subnodeStr The label to register.\n', '     * @param _owner The address of the new owner.\n', '     */\n', '    function registerName(string subnodeStr, address _owner) req(admins[msg.sender]) external {\n', '        // labelhash\n', '        bytes32 subnode = keccak256(subnodeStr);\n', '        _setSubnodeOwner(subnode, _owner);\n', '    }\n', '\n', '    /**\n', "     * INTERNAL - Register a name that's not currently registered\n", '     * @param subnode The hash of the label to register.\n', '     * @param _owner The address of the new owner.\n', '     */\n', '    function _setSubnodeOwner(bytes32 subnode, address _owner) internal {\n', '        require(!knownNodes[subnode]);\n', '        knownNodes[subnode] = true;\n', '        ens.setSubnodeOwner(rootNode, subnode, _owner);\n', '    }\n', '}']
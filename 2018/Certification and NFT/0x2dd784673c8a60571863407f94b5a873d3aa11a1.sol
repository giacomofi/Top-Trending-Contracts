['pragma solidity ^0.4.24;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '// File: contracts/ontology/CvcOntologyInterface.sol\n', '\n', '/**\n', ' * @title CvcOntologyInterface\n', ' * @dev This contract defines marketplace ontology registry interface.\n', ' */\n', 'contract CvcOntologyInterface {\n', '\n', '    struct CredentialItem {\n', '        bytes32 id;\n', '        string recordType;\n', '        string recordName;\n', '        string recordVersion;\n', '        string reference;\n', '        string referenceType;\n', '        bytes32 referenceHash;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds new Credential Item to the registry.\n', '     * @param _recordType Credential Item type\n', '     * @param _recordName Credential Item name\n', '     * @param _recordVersion Credential Item version\n', '     * @param _reference Credential Item reference URL\n', '     * @param _referenceType Credential Item reference type\n', '     * @param _referenceHash Credential Item reference hash\n', '     */\n', '    function add(\n', '        string _recordType,\n', '        string _recordName,\n', '        string _recordVersion,\n', '        string _reference,\n', '        string _referenceType,\n', '        bytes32 _referenceHash\n', '        ) external;\n', '\n', '    /**\n', '    * @dev Deprecates single Credential Item by external ID (type, name and version).\n', '    * @param _type Record type to deprecate\n', '    * @param _name Record name to deprecate\n', '    * @param _version Record version to deprecate\n', '    */\n', '    function deprecate(string _type, string _name, string _version) public;\n', '\n', '    /**\n', '    * @dev Deprecates single Credential Item by ID.\n', '    * @param _id Record ID to deprecate\n', '    */\n', '    function deprecateById(bytes32 _id) public;\n', '\n', '    /**\n', '     * @dev Returns single Credential Item data up by ontology record ID.\n', '     * @param _id Ontology record ID to search by\n', '     * @return id Ontology record ID\n', '     * @return recordType Credential Item type\n', '     * @return recordName Credential Item name\n', '     * @return recordVersion Credential Item version\n', '     * @return reference Credential Item reference URL\n', '     * @return referenceType Credential Item reference type\n', '     * @return referenceHash Credential Item reference hash\n', '     * @return deprecated Credential Item type deprecation flag\n', '     */\n', '    function getById(bytes32 _id) public view returns (\n', '        bytes32 id,\n', '        string recordType,\n', '        string recordName,\n', '        string recordVersion,\n', '        string reference,\n', '        string referenceType,\n', '        bytes32 referenceHash,\n', '        bool deprecated\n', '        );\n', '\n', '    /**\n', '     * @dev Returns single Credential Item of specific type, name and version.\n', '     * @param _type Credential Item type\n', '     * @param _name Credential Item name\n', '     * @param _version Credential Item version\n', '     * @return id Ontology record ID\n', '     * @return recordType Credential Item type\n', '     * @return recordName Credential Item name\n', '     * @return recordVersion Credential Item version\n', '     * @return reference Credential Item reference URL\n', '     * @return referenceType Credential Item reference type\n', '     * @return referenceHash Credential Item reference hash\n', '     * @return deprecated Credential Item type deprecation flag\n', '     */\n', '    function getByTypeNameVersion(\n', '        string _type,\n', '        string _name,\n', '        string _version\n', '        ) public view returns (\n', '            bytes32 id,\n', '            string recordType,\n', '            string recordName,\n', '            string recordVersion,\n', '            string reference,\n', '            string referenceType,\n', '            bytes32 referenceHash,\n', '            bool deprecated\n', '        );\n', '\n', '    /**\n', '     * @dev Returns all IDs of registered Credential Items.\n', '     * @return bytes32[]\n', '     */\n', '    function getAllIds() public view returns (bytes32[]);\n', '\n', '    /**\n', '     * @dev Returns all registered Credential Items.\n', '     * @return bytes32[]\n', '     */\n', '    function getAll() public view returns (CredentialItem[]);\n', '}\n', '\n', '// File: contracts/upgradeability/EternalStorage.sol\n', '\n', '/**\n', ' * @title EternalStorage\n', ' * @dev This contract defines the generic storage structure\n', ' * so that it could be re-used to implement any domain specific storage functionality\n', ' */\n', 'contract EternalStorage {\n', '\n', '    mapping(bytes32 => uint256) internal uintStorage;\n', '    mapping(bytes32 => string) internal stringStorage;\n', '    mapping(bytes32 => address) internal addressStorage;\n', '    mapping(bytes32 => bytes) internal bytesStorage;\n', '    mapping(bytes32 => bool) internal boolStorage;\n', '    mapping(bytes32 => int256) internal intStorage;\n', '    mapping(bytes32 => bytes32) internal bytes32Storage;\n', '\n', '}\n', '\n', '// File: contracts/upgradeability/ImplementationStorage.sol\n', '\n', '/**\n', ' * @title ImplementationStorage\n', ' * @dev This contract stores proxy implementation address.\n', ' */\n', 'contract ImplementationStorage {\n', '\n', '    /**\n', '     * @dev Storage slot with the address of the current implementation.\n', '     * This is the keccak-256 hash of "cvc.proxy.implementation", and is validated in the constructor.\n', '     */\n', '    bytes32 internal constant IMPLEMENTATION_SLOT = 0xa490aab0d89837371982f93f57ffd20c47991f88066ef92475bc8233036969bb;\n', '\n', '    /**\n', '    * @dev Constructor\n', '    */\n', '    constructor() public {\n', '        assert(IMPLEMENTATION_SLOT == keccak256("cvc.proxy.implementation"));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the current implementation.\n', '     * @return Address of the current implementation\n', '     */\n', '    function implementation() public view returns (address impl) {\n', '        bytes32 slot = IMPLEMENTATION_SLOT;\n', '        assembly {\n', '            impl := sload(slot)\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeability/Initializable.sol\n', '\n', '/**\n', ' * @title Initializable\n', ' * @dev This contract provides basic initialization control\n', ' */\n', 'contract Initializable is EternalStorage, ImplementationStorage {\n', '\n', '    /**\n', '    Data structures and storage layout:\n', '    mapping(bytes32 => bool) initialized;\n', '    **/\n', '\n', '    /**\n', '     * @dev Throws if called before contract was initialized.\n', '     */\n', '    modifier onlyInitialized() {\n', '        // require(initialized[implementation()]);\n', '        require(boolStorage[keccak256(abi.encodePacked(implementation(), "initialized"))], "Contract is not initialized");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Controls the initialization state, allowing to call an initialization function only once.\n', '     */\n', '    modifier initializes() {\n', '        address impl = implementation();\n', '        // require(!initialized[implementation()]);\n', '        require(!boolStorage[keccak256(abi.encodePacked(impl, "initialized"))], "Contract is already initialized");\n', '        _;\n', '        // initialized[implementation()] = true;\n', '        boolStorage[keccak256(abi.encodePacked(impl, "initialized"))] = true;\n', '    }\n', '}\n', '\n', '// File: contracts/upgradeability/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev This contract has an owner address providing basic authorization control\n', ' */\n', 'contract Ownable is EternalStorage {\n', '\n', '    /**\n', '    Data structures and storage layout:\n', '    address owner;\n', '    **/\n', '\n', '    /**\n', '     * @dev Event to show ownership has been transferred\n', '     * @param previousOwner representing the address of the previous owner\n', '     * @param newOwner representing the address of the new owner\n', '     */\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner(), "Message sender must be contract admin");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Tells the address of the owner\n', '     * @return the address of the owner\n', '     */\n', '    function owner() public view returns (address) {\n', '        // return owner;\n', '        return addressStorage[keccak256("owner")];\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner the address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0), "Contract owner cannot be zero address");\n', '        setOwner(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets a new owner address\n', '     */\n', '    function setOwner(address newOwner) internal {\n', '        emit OwnershipTransferred(owner(), newOwner);\n', '        // owner = newOwner;\n', '        addressStorage[keccak256("owner")] = newOwner;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/ontology/CvcOntology.sol\n', '\n', '/**\n', ' * @title CvcOntology\n', ' * @dev This contract holds the list of all recognized Credential Items available for sale.\n', ' */\n', 'contract CvcOntology is EternalStorage, Initializable, Ownable, CvcOntologyInterface {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '    Data structures and storage layout:\n', '    struct CredentialItem {\n', '        string type; // "claim" or "credential"\n', '        string name; // e.g. "proofOfIdentity"\n', '        string version; // e.g. "v1.2"\n', '        string reference; // e.g. "https://example.com/credential-proofOfIdentity-v1_2.json"\n', '        string referenceType; // e.g. "JSON-LD-Context"\n', '        bytes32 referenceHash; // e.g. "0x2cd9bf92c5e20b1b410f5ace94d963a96e89156fbe65b70365e8596b37f1f165"\n', '        bool deprecated; // e.g. false\n', '    }\n', '    uint256 recordsCount;\n', '    bytes32[] recordsIds;\n', '    mapping(bytes32 => CredentialItem) records;\n', '    **/\n', '\n', '    /**\n', '     * Constructor to initialize with some default values\n', '     */\n', '    constructor() public {\n', '        initialize(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Adds new Credential Item to the registry.\n', '     * @param _recordType Credential Item type\n', '     * @param _recordName Credential Item name\n', '     * @param _recordVersion Credential Item version\n', '     * @param _reference Credential Item reference URL\n', '     * @param _referenceType Credential Item reference type\n', '     * @param _referenceHash Credential Item reference hash\n', '     */\n', '    function add(\n', '        string _recordType,\n', '        string _recordName,\n', '        string _recordVersion,\n', '        string _reference,\n', '        string _referenceType,\n', '        bytes32 _referenceHash\n', '    ) external onlyInitialized onlyOwner {\n', '        require(bytes(_recordType).length > 0, "Empty credential item type");\n', '        require(bytes(_recordName).length > 0, "Empty credential item name");\n', '        require(bytes(_recordVersion).length > 0, "Empty credential item version");\n', '        require(bytes(_reference).length > 0, "Empty credential item reference");\n', '        require(bytes(_referenceType).length > 0, "Empty credential item type");\n', '        require(_referenceHash != 0x0, "Empty credential item reference hash");\n', '\n', '        bytes32 id = calculateId(_recordType, _recordName, _recordVersion);\n', '\n', '        require(getReferenceHash(id) == 0x0, "Credential item record already exists");\n', '\n', '        setType(id, _recordType);\n', '        setName(id, _recordName);\n', '        setVersion(id, _recordVersion);\n', '        setReference(id, _reference);\n', '        setReferenceType(id, _referenceType);\n', '        setReferenceHash(id, _referenceHash);\n', '        setRecordId(getCount(), id);\n', '        incrementCount();\n', '    }\n', '\n', '    /**\n', '     * @dev Contract initialization method.\n', '     * @param _owner Contract owner address\n', '     */\n', '    function initialize(address _owner) public initializes {\n', '        setOwner(_owner);\n', '    }\n', '\n', '    /**\n', '    * @dev Deprecates single Credential Item of specific type, name and version.\n', '    * @param _type Record type to deprecate\n', '    * @param _name Record name to deprecate\n', '    * @param _version Record version to deprecate\n', '    */\n', '    function deprecate(string _type, string _name, string _version) public onlyInitialized onlyOwner {\n', '        deprecateById(calculateId(_type, _name, _version));\n', '    }\n', '\n', '    /**\n', '    * @dev Deprecates single Credential Item by ontology record ID.\n', '    * @param _id Ontology record ID\n', '    */\n', '    function deprecateById(bytes32 _id) public onlyInitialized onlyOwner {\n', '        require(getReferenceHash(_id) != 0x0, "Cannot deprecate unknown credential item");\n', '        require(getDeprecated(_id) == false, "Credential item is already deprecated");\n', '        setDeprecated(_id);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns single Credential Item data up by ontology record ID.\n', '     * @param _id Ontology record ID to search by\n', '     * @return id Ontology record ID\n', '     * @return recordType Credential Item type\n', '     * @return recordName Credential Item name\n', '     * @return recordVersion Credential Item version\n', '     * @return reference Credential Item reference URL\n', '     * @return referenceType Credential Item reference type\n', '     * @return referenceHash Credential Item reference hash\n', '     * @return deprecated Credential Item type deprecation flag\n', '     */\n', '    function getById(\n', '        bytes32 _id\n', '    ) public view onlyInitialized returns (\n', '        bytes32 id,\n', '        string recordType,\n', '        string recordName,\n', '        string recordVersion,\n', '        string reference,\n', '        string referenceType,\n', '        bytes32 referenceHash,\n', '        bool deprecated\n', '    ) {\n', '        referenceHash = getReferenceHash(_id);\n', '        if (referenceHash != 0x0) {\n', '            recordType = getType(_id);\n', '            recordName = getName(_id);\n', '            recordVersion = getVersion(_id);\n', '            reference = getReference(_id);\n', '            referenceType = getReferenceType(_id);\n', '            deprecated = getDeprecated(_id);\n', '            id = _id;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns single Credential Item of specific type, name and version.\n', '     * @param _type Credential Item type\n', '     * @param _name Credential Item name\n', '     * @param _version Credential Item version\n', '     * @return id Ontology record ID\n', '     * @return recordType Credential Item type\n', '     * @return recordName Credential Item name\n', '     * @return recordVersion Credential Item version\n', '     * @return reference Credential Item reference URL\n', '     * @return referenceType Credential Item reference type\n', '     * @return referenceHash Credential Item reference hash\n', '     * @return deprecated Credential Item type deprecation flag\n', '     */\n', '    function getByTypeNameVersion(\n', '        string _type,\n', '        string _name,\n', '        string _version\n', '    ) public view onlyInitialized returns (\n', '        bytes32 id,\n', '        string recordType,\n', '        string recordName,\n', '        string recordVersion,\n', '        string reference,\n', '        string referenceType,\n', '        bytes32 referenceHash,\n', '        bool deprecated\n', '    ) {\n', '        return getById(calculateId(_type, _name, _version));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns all records. Currently is supported only from internal calls.\n', '     * @return CredentialItem[]\n', '     */\n', '    function getAll() public view onlyInitialized returns (CredentialItem[]) {\n', '        uint256 count = getCount();\n', '        bytes32 id;\n', '        CredentialItem[] memory records = new CredentialItem[](count);\n', '        for (uint256 i = 0; i < count; i++) {\n', '            id = getRecordId(i);\n', '            records[i] = CredentialItem(\n', '                id,\n', '                getType(id),\n', '                getName(id),\n', '                getVersion(id),\n', '                getReference(id),\n', '                getReferenceType(id),\n', '                getReferenceHash(id)\n', '            );\n', '        }\n', '\n', '        return records;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns all ontology record IDs.\n', '     * Could be used from web3.js to retrieve the list of all records.\n', '     * @return bytes32[]\n', '     */\n', '    function getAllIds() public view onlyInitialized returns(bytes32[]) {\n', '        uint256 count = getCount();\n', '        bytes32[] memory ids = new bytes32[](count);\n', '        for (uint256 i = 0; i < count; i++) {\n', '            ids[i] = getRecordId(i);\n', '        }\n', '\n', '        return ids;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of registered ontology records.\n', '     * @return uint256\n', '     */\n', '    function getCount() internal view returns (uint256) {\n', '        // return recordsCount;\n', '        return uintStorage[keccak256("records.count")];\n', '    }\n', '\n', '    /**\n', '    * @dev Increments total record count.\n', '    */\n', '    function incrementCount() internal {\n', '        // recordsCount = getCount().add(1);\n', '        uintStorage[keccak256("records.count")] = getCount().add(1);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the ontology record ID by numeric index.\n', '     * @return bytes32\n', '     */\n', '    function getRecordId(uint256 _index) internal view returns (bytes32) {\n', '        // return recordsIds[_index];\n', '        return bytes32Storage[keccak256(abi.encodePacked("records.ids.", _index))];\n', '    }\n', '\n', '    /**\n', '    * @dev Saves ontology record ID against the index.\n', '    * @param _index Numeric index.\n', '    * @param _id Ontology record ID.\n', '    */\n', '    function setRecordId(uint256 _index, bytes32 _id) internal {\n', '        // recordsIds[_index] = _id;\n', '        bytes32Storage[keccak256(abi.encodePacked("records.ids.", _index))] = _id;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the Credential Item type.\n', '     * @return string\n', '     */\n', '    function getType(bytes32 _id) internal view returns (string) {\n', '        // return records[_id].type;\n', '        return stringStorage[keccak256(abi.encodePacked("records.", _id, ".type"))];\n', '    }\n', '\n', '    /**\n', '    * @dev Saves Credential Item type.\n', '    * @param _id Ontology record ID.\n', '    * @param _type Credential Item type.\n', '    */\n', '    function setType(bytes32 _id, string _type) internal {\n', '        // records[_id].type = _type;\n', '        stringStorage[keccak256(abi.encodePacked("records.", _id, ".type"))] = _type;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the Credential Item name.\n', '     * @return string\n', '     */\n', '    function getName(bytes32 _id) internal view returns (string) {\n', '        // records[_id].name;\n', '        return stringStorage[keccak256(abi.encodePacked("records.", _id, ".name"))];\n', '    }\n', '\n', '    /**\n', '    * @dev Saves Credential Item name.\n', '    * @param _id Ontology record ID.\n', '    * @param _name Credential Item name.\n', '    */\n', '    function setName(bytes32 _id, string _name) internal {\n', '        // records[_id].name = _name;\n', '        stringStorage[keccak256(abi.encodePacked("records.", _id, ".name"))] = _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the Credential Item version.\n', '     * @return string\n', '     */\n', '    function getVersion(bytes32 _id) internal view returns (string) {\n', '        // return records[_id].version;\n', '        return stringStorage[keccak256(abi.encodePacked("records.", _id, ".version"))];\n', '    }\n', '\n', '    /**\n', '    * @dev Saves Credential Item version.\n', '    * @param _id Ontology record ID.\n', '    * @param _version Credential Item version.\n', '    */\n', '    function setVersion(bytes32 _id, string _version) internal {\n', '        // records[_id].version = _version;\n', '        stringStorage[keccak256(abi.encodePacked("records.", _id, ".version"))] = _version;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the Credential Item reference URL.\n', '     * @return string\n', '     */\n', '    function getReference(bytes32 _id) internal view returns (string) {\n', '        // return records[_id].reference;\n', '        return stringStorage[keccak256(abi.encodePacked("records.", _id, ".reference"))];\n', '    }\n', '\n', '    /**\n', '    * @dev Saves Credential Item reference URL.\n', '    * @param _id Ontology record ID.\n', '    * @param _reference Reference value.\n', '    */\n', '    function setReference(bytes32 _id, string _reference) internal {\n', '        // records[_id].reference = _reference;\n', '        stringStorage[keccak256(abi.encodePacked("records.", _id, ".reference"))] = _reference;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the Credential Item reference type value.\n', '     * @return string\n', '     */\n', '    function getReferenceType(bytes32 _id) internal view returns (string) {\n', '        // return records[_id].referenceType;\n', '        return stringStorage[keccak256(abi.encodePacked("records.", _id, ".referenceType"))];\n', '    }\n', '\n', '    /**\n', '    * @dev Saves Credential Item reference type.\n', '    * @param _id Ontology record ID.\n', '    * @param _referenceType Reference type.\n', '    */\n', '    function setReferenceType(bytes32 _id, string _referenceType) internal {\n', '        // records[_id].referenceType = _referenceType;\n', '        stringStorage[keccak256(abi.encodePacked("records.", _id, ".referenceType"))] = _referenceType;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the Credential Item reference hash value.\n', '     * @return bytes32\n', '     */\n', '    function getReferenceHash(bytes32 _id) internal view returns (bytes32) {\n', '        // return records[_id].referenceHash;\n', '        return bytes32Storage[keccak256(abi.encodePacked("records.", _id, ".referenceHash"))];\n', '    }\n', '\n', '    /**\n', '    * @dev Saves Credential Item reference hash.\n', '    * @param _id Ontology record ID.\n', '    * @param _referenceHash Reference hash.\n', '    */\n', '    function setReferenceHash(bytes32 _id, bytes32 _referenceHash) internal {\n', '        // records[_id].referenceHash = _referenceHash;\n', '        bytes32Storage[keccak256(abi.encodePacked("records.", _id, ".referenceHash"))] = _referenceHash;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the Credential Item deprecation flag value.\n', '     * @return bool\n', '     */\n', '    function getDeprecated(bytes32 _id) internal view returns (bool) {\n', '        // return records[_id].deprecated;\n', '        return boolStorage[keccak256(abi.encodePacked("records.", _id, ".deprecated"))];\n', '    }\n', '\n', '    /**\n', '    * @dev Sets Credential Item deprecation flag value.\n', '    * @param _id Ontology record ID.\n', '    */\n', '    function setDeprecated(bytes32 _id) internal {\n', '        // records[_id].deprecated = true;\n', '        boolStorage[keccak256(abi.encodePacked("records.", _id, ".deprecated"))] = true;\n', '    }\n', '\n', '    /**\n', '    * @dev Calculates ontology record ID.\n', '    * @param _type Credential Item type.\n', '    * @param _name Credential Item name.\n', '    * @param _version Credential Item version.\n', '    */\n', '    function calculateId(string _type, string _name, string _version) internal pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked(_type, ".", _name, ".", _version));\n', '    }\n', '}']
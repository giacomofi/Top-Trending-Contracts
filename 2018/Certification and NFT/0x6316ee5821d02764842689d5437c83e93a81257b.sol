['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' */\n', 'library Address {\n', '    /**\n', '     * Returns whether the target address is a contract\n', '     * @dev This function will return false if invoked during the constructor of a contract,\n', '     * as the code is not actually created until after the constructor finishes.\n', '     * @param account address of the account to check\n', '     * @return whether the target address is a contract\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        // XXX Currently there is no better way to check if there is a contract in an address\n', '        // than to check the size of the code at that address.\n', '        // See https://ethereum.stackexchange.com/a/14016/36603\n', '        // for more details about how this works.\n', '        // TODO Check this again before the Serenity release, because all addresses will be\n', '        // contracts then.\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', '* @dev Contract Version Manager\n', '*/\n', 'contract ContractManager is Ownable {\n', '\n', '    event VersionAdded(\n', '        string contractName,\n', '        string versionName,\n', '        address indexed implementation\n', '    );\n', '\n', '    event StatusChanged(\n', '        string contractName,\n', '        string versionName,\n', '        Status status\n', '    );\n', '\n', '    event BugLevelChanged(\n', '        string contractName,\n', '        string versionName,\n', '        BugLevel bugLevel\n', '    );\n', '\n', '    event VersionAudited(string contractName, string versionName);\n', '\n', '    event VersionRecommended(string contractName, string versionName);\n', '\n', '    event RecommendedVersionRemoved(string contractName);\n', '\n', '    /**\n', '    * @dev Indicates the status of the version\n', '    */\n', '    enum Status {BETA, RC, PRODUCTION, DEPRECATED}\n', '\n', '    /**\n', '    * @dev Indicates the highest level of bug found in this version\n', '    */\n', '    enum BugLevel{NONE, LOW, MEDIUM, HIGH, CRITICAL}\n', '\n', '    /**\n', '    * @dev struct to store info about each version\n', '    */\n', '    struct Version {\n', '        string versionName; // ie: "0.0.1"\n', '        Status status;\n', '        BugLevel bugLevel;\n', '        address implementation;\n', '        bool audited;\n', '        uint256 timeAdded;\n', '    }\n', '\n', '    /**\n', '    * @dev List of all registered contracts\n', '    */\n', '    string[] internal _contracts;\n', '\n', '    /**\n', '    * @dev To keep track of which contracts have been registered so far\n', '    * to save gas while checking for redundant contracts\n', '    */\n', '    mapping(string => bool) internal _contractExists;\n', '\n', '    /**\n', '    * @dev To keep track of all versions of a given contract\n', '    */\n', '    mapping(string => string[]) internal _contractVsVersionString;\n', '\n', '    /**\n', '    * @dev Mapping of contract name & version name to version struct\n', '    */\n', '    mapping(string => mapping(string => Version)) internal _contractVsVersions;\n', '\n', '    /**\n', '    * @dev Mapping between contract name and the name of its recommended\n', '    * version\n', '    */\n', '    mapping(string => string) internal _contractVsRecommendedVersion;\n', '\n', '    modifier nonZeroAddress(address _address){\n', '        require(_address != address(0), "The provided address is a 0 address");\n', '        _;\n', '    }\n', '\n', '    modifier contractRegistered(string contractName) {\n', '\n', '        require(_contractExists[contractName], "Contract does not exists");\n', '        _;\n', '    }\n', '\n', '    modifier versionExists(string contractName, string versionName) {\n', '        require(\n', '            _contractVsVersions[contractName][versionName].implementation != address(0),\n', '            "Version does not exists for contract"\n', '        );\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allow owner to add a new version for a contract\n', '    * @param contractName The contract name\n', '    * @param versionName The version name\n', '    * @param status Status of the new version\n', '    * @param implementation The address of the new version\n', '    */\n', '    function addVersion(\n', '        string contractName,\n', '        string versionName,\n', '        Status status,\n', '        address implementation\n', '    )\n', '        external\n', '        onlyOwner\n', '        nonZeroAddress(implementation)\n', '    {\n', '\n', '        //do not allow contract name to be the empty string\n', '        require(\n', '            bytes(contractName).length > 0,\n', '            "ContractName cannot be empty"\n', '        );\n', '\n', '        //do not allow empty string as version name\n', '        require(\n', '            bytes(versionName).length > 0,\n', '            "VersionName cannot be empty"\n', '        );\n', '\n', '        //implementation must be a contract address\n', '        require(\n', '            Address.isContract(implementation),\n', '            "Iimplementation cannot be a non-contract address"\n', '        );\n', '\n', '        //version should not already exist for the contract\n', '        require(\n', '            _contractVsVersions[contractName][versionName].implementation == address(0),\n', '            "This Version already exists for this contract"\n', '        );\n', '\n', '        //if this is a new contractName then push it to the contracts[] array\n', '        if (!_contractExists[contractName]) {\n', '            _contracts.push(contractName);\n', '            _contractExists[contractName] = true;\n', '        }\n', '\n', '        _contractVsVersionString[contractName].push(versionName);\n', '\n', '        _contractVsVersions[contractName][versionName] = Version({\n', '            versionName:versionName,\n', '            status:status,\n', '            bugLevel:BugLevel.NONE,\n', '            implementation:implementation,\n', '            audited:false,\n', '            timeAdded:block.timestamp\n', '        });\n', '\n', '        emit VersionAdded(contractName, versionName, implementation);\n', '    }\n', '\n', '    /**\n', '    * @dev Change the status of a version of a contract\n', '    * @param contractName Name of the contract\n', '    * @param versionName Version of the contract\n', '    * @param status Status to be set\n', '    */\n', '    function changeStatus(\n', '        string contractName,\n', '        string versionName,\n', '        Status status\n', '    )\n', '        external\n', '        onlyOwner\n', '        contractRegistered(contractName)\n', '        versionExists(contractName, versionName)\n', '    {\n', '        string storage recommendedVersion = _contractVsRecommendedVersion[\n', '            contractName\n', '        ];\n', '\n', '        //if the recommended version is being marked as DEPRECATED then it will\n', '        //be removed from being recommended\n', '        if (\n', '            keccak256(\n', '                abi.encodePacked(\n', '                    recommendedVersion\n', '                )\n', '            ) == keccak256(\n', '                abi.encodePacked(\n', '                    versionName\n', '                )\n', '            ) && status == Status.DEPRECATED\n', '        )\n', '        {\n', '            removeRecommendedVersion(contractName);\n', '        }\n', '\n', '        _contractVsVersions[contractName][versionName].status = status;\n', '\n', '        emit StatusChanged(contractName, versionName, status);\n', '    }\n', '\n', '    /**\n', '    * @dev Change the bug level for a version of a contract\n', '    * @param contractName Name of the contract\n', '    * @param versionName Version of the contract\n', '    * @param bugLevel New bug level for the contract\n', '    */\n', '    function changeBugLevel(\n', '        string contractName,\n', '        string versionName,\n', '        BugLevel bugLevel\n', '    )\n', '        external\n', '        onlyOwner\n', '        contractRegistered(contractName)\n', '        versionExists(contractName, versionName)\n', '    {\n', '        string storage recommendedVersion = _contractVsRecommendedVersion[\n', '            contractName\n', '        ];\n', '\n', '        //if the recommended version of this contract is being marked as\n', '        // CRITICAL (status level 4) then it will no longer be marked as\n', '        // recommended\n', '        if (\n', '            keccak256(\n', '                abi.encodePacked(\n', '                    recommendedVersion\n', '                )\n', '            ) == keccak256(\n', '                abi.encodePacked(\n', '                    versionName\n', '                )\n', '            ) && bugLevel == BugLevel.CRITICAL\n', '        )\n', '        {\n', '            removeRecommendedVersion(contractName);\n', '        }\n', '\n', '        _contractVsVersions[contractName][versionName].bugLevel = bugLevel;\n', '\n', '        emit BugLevelChanged(contractName, versionName, bugLevel);\n', '    }\n', '\n', '    /**\n', '    * @dev Mark a version of a contract as having been audited\n', '    * @param contractName Name of the contract\n', '    * @param versionName Version of the contract\n', '    */\n', '    function markVersionAudited(\n', '        string contractName,\n', '        string versionName\n', '    )\n', '        external\n', '        contractRegistered(contractName)\n', '        versionExists(contractName, versionName)\n', '        onlyOwner\n', '    {\n', '        //this version should not already be marked audited\n', '        require(\n', '            !_contractVsVersions[contractName][versionName].audited,\n', '            "Version is already audited"\n', '        );\n', '\n', '        _contractVsVersions[contractName][versionName].audited = true;\n', '\n', '        emit VersionAudited(contractName, versionName);\n', '    }\n', '\n', '    /**\n', '    * @dev Set recommended version\n', '    * @param contractName Name of the contract\n', '    * @param versionName Version of the contract\n', '    * Version should be in Production stage (status 2) and bug level should\n', '    * not be HIGH or CRITICAL (status level should be less than 3).\n', '    * Version must be marked as audited\n', '    */\n', '    function markRecommendedVersion(\n', '        string contractName,\n', '        string versionName\n', '    )\n', '        external\n', '        onlyOwner\n', '        contractRegistered(contractName)\n', '        versionExists(contractName, versionName)\n', '    {\n', '        //version must be in PRODUCTION state (status 2)\n', '        require(\n', '            _contractVsVersions[contractName][versionName].status == Status.PRODUCTION,\n', '            "Version is not in PRODUCTION state (status level should be 2)"\n', '        );\n', '\n', '        //check version must be audited\n', '        require(\n', '            _contractVsVersions[contractName][versionName].audited,\n', '            "Version is not audited"\n', '        );\n', '\n', '        //version must have bug level lower than HIGH\n', '        require(\n', '            _contractVsVersions[contractName][versionName].bugLevel < BugLevel.HIGH,\n', '            "Version bug level is HIGH or CRITICAL (bugLevel should be < 3)"\n', '        );\n', '\n', '        //mark new version as recommended version for the contract\n', '        _contractVsRecommendedVersion[contractName] = versionName;\n', '\n', '        emit VersionRecommended(contractName, versionName);\n', '    }\n', '\n', '    /**\n', '    * @dev Get the version of the recommended version for a contract.\n', '    * @return Details of recommended version\n', '    */\n', '    function getRecommendedVersion(\n', '        string contractName\n', '    )\n', '        external\n', '        view\n', '        contractRegistered(contractName)\n', '        returns (\n', '            string versionName,\n', '            Status status,\n', '            BugLevel bugLevel,\n', '            address implementation,\n', '            bool audited,\n', '            uint256 timeAdded\n', '        )\n', '    {\n', '        versionName = _contractVsRecommendedVersion[contractName];\n', '\n', '        Version storage recommendedVersion = _contractVsVersions[\n', '            contractName\n', '        ][\n', '            versionName\n', '        ];\n', '\n', '        status = recommendedVersion.status;\n', '        bugLevel = recommendedVersion.bugLevel;\n', '        implementation = recommendedVersion.implementation;\n', '        audited = recommendedVersion.audited;\n', '        timeAdded = recommendedVersion.timeAdded;\n', '\n', '        return (\n', '            versionName,\n', '            status,\n', '            bugLevel,\n', '            implementation,\n', '            audited,\n', '            timeAdded\n', '        );\n', '    }\n', '\n', '    /**\n', '    * @dev Get the total number of contracts registered\n', '    */\n', '    function getTotalContractCount() external view returns (uint256 count) {\n', '        count = _contracts.length;\n', '        return count;\n', '    }\n', '\n', '    /**\n', '    * @dev Get total count of versions for a contract\n', '    * @param contractName Name of the contract\n', '    */\n', '    function getVersionCountForContract(string contractName)\n', '        external\n', '        view\n', '        returns (uint256 count)\n', '    {\n', '        count = _contractVsVersionString[contractName].length;\n', '        return count;\n', '    }\n', '\n', '    /**\n', '    * @dev Returns the contract at index\n', '    * @param index The index to be searched for\n', '    */\n', '    function getContractAtIndex(uint256 index)\n', '        external\n', '        view\n', '        returns (string contractName)\n', '    {\n', '        contractName = _contracts[index];\n', '        return contractName;\n', '    }\n', '\n', '    /**\n', '    * @dev Returns versionName of a contract at a specific index\n', '    * @param contractName Name of the contract\n', '    * @param index The index to be searched for\n', '    */\n', '    function getVersionAtIndex(string contractName, uint256 index)\n', '        external\n', '        view\n', '        returns (string versionName)\n', '    {\n', '        versionName = _contractVsVersionString[contractName][index];\n', '        return versionName;\n', '    }\n', '\n', '    /**\n', '    * @dev Returns the version details for the given contract and version\n', '    * @param contractName Name of the contract\n', '    * @param versionName Version string for the contract\n', '    */\n', '    function getVersionDetails(string contractName, string versionName)\n', '        external\n', '        view\n', '        returns (\n', '            string versionString,\n', '            Status status,\n', '            BugLevel bugLevel,\n', '            address implementation,\n', '            bool audited,\n', '            uint256 timeAdded\n', '        )\n', '    {\n', '        Version storage v = _contractVsVersions[contractName][versionName];\n', '\n', '        versionString = v.versionName;\n', '        status = v.status;\n', '        bugLevel = v.bugLevel;\n', '        implementation = v.implementation;\n', '        audited = v.audited;\n', '        timeAdded = v.timeAdded;\n', '\n', '        return (\n', '            versionString,\n', '            status,\n', '            bugLevel,\n', '            implementation,\n', '            audited,\n', '            timeAdded\n', '        );\n', '    }\n', '\n', '    /**\n', '    * @dev Remove the "recommended" status of the currently recommended version\n', '    * of a contract (if any)\n', '    * @param contractName Name of the contract\n', '    */\n', '    function removeRecommendedVersion(string contractName)\n', '        public\n', '        onlyOwner\n', '        contractRegistered(contractName)\n', '    {\n', '        //delete it from mapping\n', '        delete _contractVsRecommendedVersion[contractName];\n', '\n', '        emit RecommendedVersionRemoved(contractName);\n', '    }\n', '}']
['// File: contracts/CloneFactory.sol\n', '\n', 'pragma solidity 0.6.2;\n', '\n', 'contract CloneFactory {\n', '\n', '    function createClone(address target) internal returns (address result) {\n', '        bytes20 targetBytes = bytes20(target);\n', '        assembly {\n', '            let clone := mload(0x40)\n', '            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)\n', '            mstore(add(clone, 0x14), targetBytes)\n', '            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n', '            result := create(0, clone, 0x37)\n', '        }\n', '    }\n', '\n', '    function isClone(address target, address query) internal view returns (bool result) {\n', '        bytes20 targetBytes = bytes20(target);\n', '        assembly {\n', '            let clone := mload(0x40)\n', '            mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)\n', '            mstore(add(clone, 0xa), targetBytes)\n', '            mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n', '\n', '            let other := add(clone, 0x40)\n', '            extcodecopy(query, other, 0, 0x2d)\n', '            result := and(\n', '            eq(mload(clone), mload(other)),\n', '            eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))\n', '            )\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/IERC734.sol\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '/**\n', ' * @dev Interface of the ERC734 (Key Holder) standard as defined in the EIP.\n', ' */\n', 'interface IERC734 {\n', '    /**\n', '     * @dev Definition of the structure of a Key.\n', '     *\n', '     * Specification: Keys are cryptographic public keys, or contract addresses associated with this identity.\n', '     * The structure should be as follows:\n', '     *   - key: A public key owned by this identity\n', '     *      - purposes: uint256[] Array of the key purposes, like 1 = MANAGEMENT, 2 = EXECUTION\n', '     *      - keyType: The type of key used, which would be a uint256 for different key types. e.g. 1 = ECDSA, 2 = RSA, etc.\n', '     *      - key: bytes32 The public key. // Its the Keccak256 hash of the key\n', '     */\n', '    struct Key {\n', '        uint256[] purposes;\n', '        uint256 keyType;\n', '        bytes32 key;\n', '    }\n', '\n', '    /**\n', '     * @dev Emitted when an execution request was approved.\n', '     *\n', '     * Specification: MUST be triggered when approve was successfully called.\n', '     */\n', '    event Approved(uint256 indexed executionId, bool approved);\n', '\n', '    /**\n', '     * @dev Emitted when an execute operation was approved and successfully performed.\n', '     *\n', '     * Specification: MUST be triggered when approve was called and the execution was successfully approved.\n', '     */\n', '    event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);\n', '\n', '    /**\n', '     * @dev Emitted when an execution request was performed via `execute`.\n', '     *\n', '     * Specification: MUST be triggered when execute was successfully called.\n', '     */\n', '    event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);\n', '\n', '    /**\n', '     * @dev Emitted when a key was added to the Identity.\n', '     *\n', '     * Specification: MUST be triggered when addKey was successfully called.\n', '     */\n', '    event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);\n', '\n', '    /**\n', '     * @dev Emitted when a key was removed from the Identity.\n', '     *\n', '     * Specification: MUST be triggered when removeKey was successfully called.\n', '     */\n', '    event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);\n', '\n', '    /**\n', '     * @dev Emitted when the list of required keys to perform an action was updated.\n', '     *\n', '     * Specification: MUST be triggered when changeKeysRequired was successfully called.\n', '     */\n', '    event KeysRequiredChanged(uint256 purpose, uint256 number);\n', '\n', '\n', '    /**\n', '     * @dev Adds a _key to the identity. The _purpose specifies the purpose of the key.\n', '     *\n', '     * Triggers Event: `KeyAdded`\n', '     *\n', "     * Specification: MUST only be done by keys of purpose 1, or the identity itself. If it's the identity itself, the approval process will determine its approval.\n", '     */\n', '    function addKey(bytes32 _key, uint256 _purpose, uint256 _keyType) external returns (bool success);\n', '\n', '    /**\n', '    * @dev Approves an execution or claim addition.\n', '    *\n', '    * Triggers Event: `Approved`, `Executed`\n', '    *\n', '    * Specification:\n', '    * This SHOULD require n of m approvals of keys purpose 1, if the _to of the execution is the identity contract itself, to successfully approve an execution.\n', '    * And COULD require n of m approvals of keys purpose 2, if the _to of the execution is another contract, to successfully approve an execution.\n', '    */\n', '    function approve(uint256 _id, bool _approve) external returns (bool success);\n', '\n', '    /**\n', '     * @dev Passes an execution instruction to an ERC725 identity.\n', '     *\n', '     * Triggers Event: `ExecutionRequested`, `Executed`\n', '     *\n', '     * Specification:\n', '     * SHOULD require approve to be called with one or more keys of purpose 1 or 2 to approve this execution.\n', '     * Execute COULD be used as the only accessor for `addKey` and `removeKey`.\n', '     */\n', '    function execute(address _to, uint256 _value, bytes calldata _data) external payable returns (uint256 executionId);\n', '\n', '    /**\n', '     * @dev Returns the full key data, if present in the identity.\n', '     */\n', '    function getKey(bytes32 _key) external view returns (uint256[] memory purposes, uint256 keyType, bytes32 key);\n', '\n', '    /**\n', '     * @dev Returns the list of purposes associated with a key.\n', '     */\n', '    function getKeyPurposes(bytes32 _key) external view returns(uint256[] memory _purposes);\n', '\n', '    /**\n', '     * @dev Returns an array of public key bytes32 held by this identity.\n', '     */\n', '    function getKeysByPurpose(uint256 _purpose) external view returns (bytes32[] memory keys);\n', '\n', '    /**\n', '     * @dev Returns TRUE if a key is present and has the given purpose. If the key is not present it returns FALSE.\n', '     */\n', '    function keyHasPurpose(bytes32 _key, uint256 _purpose) external view returns (bool exists);\n', '\n', '    /**\n', '     * @dev Removes _purpose for _key from the identity.\n', '     *\n', '     * Triggers Event: `KeyRemoved`\n', '     *\n', "     * Specification: MUST only be done by keys of purpose 1, or the identity itself. If it's the identity itself, the approval process will determine its approval.\n", '     */\n', '    function removeKey(bytes32 _key, uint256 _purpose) external returns (bool success);\n', '}\n', '\n', '// File: contracts/ERC734.sol\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '\n', '/**\n', ' * @dev Implementation of the `IERC734` "KeyHolder" interface.\n', ' */\n', 'contract ERC734 is IERC734 {\n', '    uint256 public constant MANAGEMENT_KEY = 1;\n', '    uint256 public constant ACTION_KEY = 2;\n', '    uint256 public constant CLAIM_SIGNER_KEY = 3;\n', '    uint256 public constant ENCRYPTION_KEY = 4;\n', '\n', '    bool private identitySettled = false;\n', '    uint256 private executionNonce;\n', '\n', '    struct Execution {\n', '        address to;\n', '        uint256 value;\n', '        bytes data;\n', '        bool approved;\n', '        bool executed;\n', '    }\n', '\n', '    mapping (bytes32 => Key) private keys;\n', '    mapping (uint256 => bytes32[]) private keysByPurpose;\n', '    mapping (uint256 => Execution) private executions;\n', '\n', '    event ExecutionFailed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);\n', '\n', '    function set(address _owner) public {\n', '        bytes32 _key = keccak256(abi.encode(_owner));\n', '        require(!identitySettled, "Key already exists");\n', '        identitySettled = true;\n', '        keys[_key].key = _key;\n', '        keys[_key].purposes = [1];\n', '        keys[_key].keyType = 1;\n', '\n', '        keysByPurpose[1].push(_key);\n', '\n', '        emit KeyAdded(_key, 1, 1);\n', '    }\n', '\n', '    /**\n', '       * @notice Implementation of the getKey function from the ERC-734 standard\n', '       *\n', '       * @param _key The public key.  for non-hex and long keys, its the Keccak256 hash of the key\n', '       *\n', '       * @return purposes Returns the full key data, if present in the identity.\n', '       * @return keyType Returns the full key data, if present in the identity.\n', '       * @return key Returns the full key data, if present in the identity.\n', '       */\n', '    function getKey(bytes32 _key)\n', '    public\n', '    override\n', '    view\n', '    returns(uint256[] memory purposes, uint256 keyType, bytes32 key)\n', '    {\n', '        return (keys[_key].purposes, keys[_key].keyType, keys[_key].key);\n', '    }\n', '\n', '    /**\n', '    * @notice gets the purposes of a key\n', '    *\n', '    * @param _key The public key.  for non-hex and long keys, its the Keccak256 hash of the key\n', '    *\n', '    * @return _purposes Returns the purposes of the specified key\n', '    */\n', '    function getKeyPurposes(bytes32 _key)\n', '    public\n', '    override\n', '    view\n', '    returns(uint256[] memory _purposes)\n', '    {\n', '        return (keys[_key].purposes);\n', '    }\n', '\n', '    /**\n', '        * @notice gets all the keys with a specific purpose from an identity\n', '        *\n', '        * @param _purpose a uint256[] Array of the key types, like 1 = MANAGEMENT, 2 = ACTION, 3 = CLAIM, 4 = ENCRYPTION\n', '        *\n', '        * @return _keys Returns an array of public key bytes32 hold by this identity and having the specified purpose\n', '        */\n', '    function getKeysByPurpose(uint256 _purpose)\n', '    public\n', '    override\n', '    view\n', '    returns(bytes32[] memory _keys)\n', '    {\n', '        return keysByPurpose[_purpose];\n', '    }\n', '\n', '    /**\n', '        * @notice implementation of the addKey function of the ERC-734 standard\n', '        * Adds a _key to the identity. The _purpose specifies the purpose of key. Initially we propose four purposes:\n', '        * 1: MANAGEMENT keys, which can manage the identity\n', '        * 2: ACTION keys, which perform actions in this identities name (signing, logins, transactions, etc.)\n', '        * 3: CLAIM signer keys, used to sign claims on other identities which need to be revokable.\n', '        * 4: ENCRYPTION keys, used to encrypt data e.g. hold in claims.\n', '        * MUST only be done by keys of purpose 1, or the identity itself.\n', '        * If its the identity itself, the approval process will determine its approval.\n', '        *\n', '        * @param _key keccak256 representation of an ethereum address\n', '        * @param _type type of key used, which would be a uint256 for different key types. e.g. 1 = ECDSA, 2 = RSA, etc.\n', '        * @param _purpose a uint256[] Array of the key types, like 1 = MANAGEMENT, 2 = ACTION, 3 = CLAIM, 4 = ENCRYPTION\n', '        *\n', '        * @return success Returns TRUE if the addition was successful and FALSE if not\n', '        */\n', '\n', '    function addKey(bytes32 _key, uint256 _purpose, uint256 _type)\n', '    public\n', '    override\n', '    returns (bool success)\n', '    {\n', '        if (msg.sender != address(this)) {\n', '            require(keyHasPurpose(keccak256(abi.encode(msg.sender)), 1), "Permissions: Sender does not have management key");\n', '        }\n', '\n', '        if (keys[_key].key == _key) {\n', '            for (uint keyPurposeIndex = 0; keyPurposeIndex < keys[_key].purposes.length; keyPurposeIndex++) {\n', '                uint256 purpose = keys[_key].purposes[keyPurposeIndex];\n', '\n', '                if (purpose == _purpose) {\n', '                    revert("Conflict: Key already has purpose");\n', '                }\n', '            }\n', '\n', '            keys[_key].purposes.push(_purpose);\n', '        } else {\n', '            keys[_key].key = _key;\n', '            keys[_key].purposes = [_purpose];\n', '            keys[_key].keyType = _type;\n', '        }\n', '\n', '        keysByPurpose[_purpose].push(_key);\n', '\n', '        emit KeyAdded(_key, _purpose, _type);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(uint256 _id, bool _approve)\n', '    public\n', '    override\n', '    returns (bool success)\n', '    {\n', '        require(keyHasPurpose(keccak256(abi.encode(msg.sender)), 2), "Sender does not have action key");\n', '\n', '        emit Approved(_id, _approve);\n', '\n', '        if (_approve == true) {\n', '            executions[_id].approved = true;\n', '\n', '            (success,) = executions[_id].to.call.value(executions[_id].value)(abi.encode(executions[_id].data, 0));\n', '\n', '            if (success) {\n', '                executions[_id].executed = true;\n', '\n', '                emit Executed(\n', '                    _id,\n', '                    executions[_id].to,\n', '                    executions[_id].value,\n', '                    executions[_id].data\n', '                );\n', '\n', '                return true;\n', '            } else {\n', '                emit ExecutionFailed(\n', '                    _id,\n', '                    executions[_id].to,\n', '                    executions[_id].value,\n', '                    executions[_id].data\n', '                );\n', '\n', '                return false;\n', '            }\n', '        } else {\n', '            executions[_id].approved = false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function execute(address _to, uint256 _value, bytes memory _data)\n', '    public\n', '    override\n', '    payable\n', '    returns (uint256 executionId)\n', '    {\n', '        require(!executions[executionNonce].executed, "Already executed");\n', '        executions[executionNonce].to = _to;\n', '        executions[executionNonce].value = _value;\n', '        executions[executionNonce].data = _data;\n', '\n', '        emit ExecutionRequested(executionNonce, _to, _value, _data);\n', '\n', '        if (keyHasPurpose(keccak256(abi.encode(msg.sender)), 2)) {\n', '            approve(executionNonce, true);\n', '        }\n', '\n', '        executionNonce++;\n', '        return executionNonce-1;\n', '    }\n', '\n', '    function removeKey(bytes32 _key, uint256 _purpose)\n', '    public\n', '    override\n', '    returns (bool success)\n', '    {\n', '        require(keys[_key].key == _key, "NonExisting: Key isn\'t registered");\n', '\n', '        if (msg.sender != address(this)) {\n', '            require(keyHasPurpose(keccak256(abi.encode(msg.sender)), 1), "Permissions: Sender does not have management key"); // Sender has MANAGEMENT_KEY\n', '        }\n', '\n', '        require(keys[_key].purposes.length > 0, "NonExisting: Key doesn\'t have such purpose");\n', '\n', '        uint purposeIndex = 0;\n', '        while (keys[_key].purposes[purposeIndex] != _purpose) {\n', '            purposeIndex++;\n', '\n', '            if (purposeIndex >= keys[_key].purposes.length) {\n', '                break;\n', '            }\n', '        }\n', '\n', '        require(purposeIndex < keys[_key].purposes.length, "NonExisting: Key doesn\'t have such purpose");\n', '\n', '        keys[_key].purposes[purposeIndex] = keys[_key].purposes[keys[_key].purposes.length - 1];\n', '        keys[_key].purposes.pop();\n', '\n', '        uint keyIndex = 0;\n', '\n', '        while (keysByPurpose[_purpose][keyIndex] != _key) {\n', '            keyIndex++;\n', '        }\n', '\n', '        keysByPurpose[_purpose][keyIndex] = keysByPurpose[_purpose][keysByPurpose[_purpose].length - 1];\n', '        keysByPurpose[_purpose].pop();\n', '\n', '        uint keyType = keys[_key].keyType;\n', '\n', '        if (keys[_key].purposes.length == 0) {\n', '            delete keys[_key];\n', '        }\n', '\n', '        emit KeyRemoved(_key, _purpose, keyType);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '    * @notice Returns true if the key has MANAGEMENT purpose or the specified purpose.\n', '    */\n', '    function keyHasPurpose(bytes32 _key, uint256 _purpose)\n', '    public\n', '    override\n', '    view\n', '    returns(bool result)\n', '    {\n', '        Key memory key = keys[_key];\n', '        if (key.key == 0) return false;\n', '\n', '        for (uint keyPurposeIndex = 0; keyPurposeIndex < key.purposes.length; keyPurposeIndex++) {\n', '            uint256 purpose = key.purposes[keyPurposeIndex];\n', '\n', '            if (purpose == MANAGEMENT_KEY || purpose == _purpose) return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '}\n', '\n', '// File: contracts/IERC735.sol\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '/**\n', ' * @dev Interface of the ERC735 (Claim Holder) standard as defined in the EIP.\n', ' */\n', 'interface IERC735 {\n', '\n', '    /**\n', '     * @dev Emitted when a claim request was performed.\n', '     *\n', '     * Specification: Is not clear\n', '     */\n', '    event ClaimRequested(uint256 indexed claimRequestId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);\n', '\n', '    /**\n', '     * @dev Emitted when a claim was added.\n', '     *\n', '     * Specification: MUST be triggered when a claim was successfully added.\n', '     */\n', '    event ClaimAdded(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);\n', '\n', '    /**\n', '     * @dev Emitted when a claim was removed.\n', '     *\n', '     * Specification: MUST be triggered when removeClaim was successfully called.\n', '     */\n', '    event ClaimRemoved(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);\n', '\n', '    /**\n', '     * @dev Emitted when a claim was changed.\n', '     *\n', '     * Specification: MUST be triggered when changeClaim was successfully called.\n', '     */\n', '    event ClaimChanged(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);\n', '\n', '    /**\n', '     * @dev Definition of the structure of a Claim.\n', '     *\n', '     * Specification: Claims are information an issuer has about the identity holder.\n', '     * The structure should be as follows:\n', '     *   - claim: A claim published for the Identity.\n', '     *      - topic: A uint256 number which represents the topic of the claim. (e.g. 1 biometric, 2 residence (ToBeDefined: number schemes, sub topics based on number ranges??))\n', '     *      - scheme : The scheme with which this claim SHOULD be verified or how it should be processed. Its a uint256 for different schemes. E.g. could 3 mean contract verification, where the data will be call data, and the issuer a contract address to call (ToBeDefined). Those can also mean different key types e.g. 1 = ECDSA, 2 = RSA, etc. (ToBeDefined)\n', '     *      - issuer: The issuers identity contract address, or the address used to sign the above signature. If an identity contract, it should hold the key with which the above message was signed, if the key is not present anymore, the claim SHOULD be treated as invalid. The issuer can also be a contract address itself, at which the claim can be verified using the call data.\n', '     *      - signature: Signature which is the proof that the claim issuer issued a claim of topic for this identity. it MUST be a signed message of the following structure: `keccak256(abi.encode(identityHolder_address, topic, data))`\n', '     *      - data: The hash of the claim data, sitting in another location, a bit-mask, call data, or actual data based on the claim scheme.\n', '     *      - uri: The location of the claim, this can be HTTP links, swarm hashes, IPFS hashes, and such.\n', '     */\n', '    struct Claim {\n', '        uint256 topic;\n', '        uint256 scheme;\n', '        address issuer;\n', '        bytes signature;\n', '        bytes data;\n', '        string uri;\n', '    }\n', '\n', '    /**\n', '     * @dev Get a claim by its ID.\n', '     *\n', '     * Claim IDs are generated using `keccak256(abi.encode(address issuer_address, uint256 topic))`.\n', '     */\n', '    function getClaim(bytes32 _claimId) external view returns(uint256 topic, uint256 scheme, address issuer, bytes memory signature, bytes memory data, string memory uri);\n', '\n', '    /**\n', '     * @dev Returns an array of claim IDs by topic.\n', '     */\n', '    function getClaimIdsByTopic(uint256 _topic) external view returns(bytes32[] memory claimIds);\n', '\n', '    /**\n', '     * @dev Add or update a claim.\n', '     *\n', '     * Triggers Event: `ClaimRequested`, `ClaimAdded`, `ClaimChanged`\n', '     *\n', '     * Specification: Requests the ADDITION or the CHANGE of a claim from an issuer.\n', '     * Claims can requested to be added by anybody, including the claim holder itself (self issued).\n', '     *\n', '     * _signature is a signed message of the following structure: `keccak256(abi.encode(address identityHolder_address, uint256 topic, bytes data))`.\n', '     * Claim IDs are generated using `keccak256(abi.encode(address issuer_address + uint256 topic))`.\n', '     *\n', '     * This COULD implement an approval process for pending claims, or add them right away.\n', '     * MUST return a claimRequestId (use claim ID) that COULD be sent to the approve function.\n', '     */\n', '    function addClaim(uint256 _topic, uint256 _scheme, address issuer, bytes calldata _signature, bytes calldata _data, string calldata _uri) external returns (bytes32 claimRequestId);\n', '\n', '    /**\n', '     * @dev Removes a claim.\n', '     *\n', '     * Triggers Event: `ClaimRemoved`\n', '     *\n', '     * Claim IDs are generated using `keccak256(abi.encode(address issuer_address, uint256 topic))`.\n', '     */\n', '    function removeClaim(bytes32 _claimId) external returns (bool success);\n', '}\n', '\n', '// File: contracts/IIdentity.sol\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '\n', '\n', 'interface IIdentity is IERC734, IERC735 {}\n', '\n', '// File: contracts/Identity.sol\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '\n', '\n', '/**\n', ' * @dev Implementation of the `IERC734` "KeyHolder" and the `IERC735` "ClaimHolder" interfaces into a common Identity Contract.\n', ' */\n', 'contract Identity is ERC734, IIdentity {\n', '\n', '    mapping (bytes32 => Claim) private claims;\n', '    mapping (uint256 => bytes32[]) private claimsByTopic;\n', '\n', '    /**\n', '    * @notice Implementation of the addClaim function from the ERC-735 standard\n', '    *  Require that the msg.sender has claim signer key.\n', '    *\n', '    * @param _topic The type of claim\n', '    * @param _scheme The scheme with which this claim SHOULD be verified or how it should be processed.\n', '    * @param _issuer The issuers identity contract address, or the address used to sign the above signature.\n', '    * @param _signature Signature which is the proof that the claim issuer issued a claim of topic for this identity.\n', '    * it MUST be a signed message of the following structure: keccak256(abi.encode(address identityHolder_address, uint256 _ topic, bytes data))\n', '    * @param _data The hash of the claim data, sitting in another location, a bit-mask, call data, or actual data based on the claim scheme.\n', '    * @param _uri The location of the claim, this can be HTTP links, swarm hashes, IPFS hashes, and such.\n', '    *\n', '    * @return claimRequestId Returns claimRequestId: COULD be send to the approve function, to approve or reject this claim.\n', '    * triggers ClaimAdded event.\n', '    */\n', '    function addClaim(\n', '        uint256 _topic,\n', '        uint256 _scheme,\n', '        address _issuer,\n', '        bytes memory _signature,\n', '        bytes memory _data,\n', '        string memory _uri\n', '    )\n', '    public\n', '    override\n', '    returns (bytes32 claimRequestId)\n', '    {\n', '        bytes32 claimId = keccak256(abi.encode(_issuer, _topic));\n', '\n', '        if (msg.sender != address(this)) {\n', '            require(keyHasPurpose(keccak256(abi.encode(msg.sender)), 3), "Permissions: Sender does not have claim signer key");\n', '        }\n', '\n', '        if (claims[claimId].issuer != _issuer) {\n', '            claimsByTopic[_topic].push(claimId);\n', '            claims[claimId].topic = _topic;\n', '            claims[claimId].scheme = _scheme;\n', '            claims[claimId].issuer = _issuer;\n', '            claims[claimId].signature = _signature;\n', '            claims[claimId].data = _data;\n', '            claims[claimId].uri = _uri;\n', '\n', '            emit ClaimAdded(\n', '                claimId,\n', '                _topic,\n', '                _scheme,\n', '                _issuer,\n', '                _signature,\n', '                _data,\n', '                _uri\n', '            );\n', '        } else {\n', '            claims[claimId].topic = _topic;\n', '            claims[claimId].scheme = _scheme;\n', '            claims[claimId].issuer = _issuer;\n', '            claims[claimId].signature = _signature;\n', '            claims[claimId].data = _data;\n', '            claims[claimId].uri = _uri;\n', '\n', '            emit ClaimChanged(\n', '                claimId,\n', '                _topic,\n', '                _scheme,\n', '                _issuer,\n', '                _signature,\n', '                _data,\n', '                _uri\n', '            );\n', '        }\n', '\n', '        return claimId;\n', '    }\n', '\n', '    /**\n', '    * @notice Implementation of the removeClaim function from the ERC-735 standard\n', '    * Require that the msg.sender has management key.\n', '    * Can only be removed by the claim issuer, or the claim holder itself.\n', '    *\n', '    * @param _claimId The identity of the claim i.e. keccak256(abi.encode(_issuer, _topic))\n', '    *\n', '    * @return success Returns TRUE when the claim was removed.\n', '    * triggers ClaimRemoved event\n', '    */\n', '    function removeClaim(bytes32 _claimId) public override returns (bool success) {\n', '        if (msg.sender != address(this)) {\n', '            require(keyHasPurpose(keccak256(abi.encode(msg.sender)), 3), "Permissions: Sender does not have CLAIM key");\n', '        }\n', '\n', '        if (claims[_claimId].topic == 0) {\n', '            revert("NonExisting: There is no claim with this ID");\n', '        }\n', '\n', '        uint claimIndex = 0;\n', '        while (claimsByTopic[claims[_claimId].topic][claimIndex] != _claimId) {\n', '            claimIndex++;\n', '        }\n', '\n', '        claimsByTopic[claims[_claimId].topic][claimIndex] = claimsByTopic[claims[_claimId].topic][claimsByTopic[claims[_claimId].topic].length - 1];\n', '        claimsByTopic[claims[_claimId].topic].pop();\n', '\n', '        emit ClaimRemoved(\n', '            _claimId,\n', '            claims[_claimId].topic,\n', '            claims[_claimId].scheme,\n', '            claims[_claimId].issuer,\n', '            claims[_claimId].signature,\n', '            claims[_claimId].data,\n', '            claims[_claimId].uri\n', '        );\n', '\n', '        delete claims[_claimId];\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @notice Implementation of the getClaim function from the ERC-735 standard.\n', '    *\n', '    * @param _claimId The identity of the claim i.e. keccak256(abi.encode(_issuer, _topic))\n', '    *\n', '    * @return topic Returns all the parameters of the claim for the specified _claimId (topic, scheme, signature, issuer, data, uri) .\n', '    * @return scheme Returns all the parameters of the claim for the specified _claimId (topic, scheme, signature, issuer, data, uri) .\n', '    * @return issuer Returns all the parameters of the claim for the specified _claimId (topic, scheme, signature, issuer, data, uri) .\n', '    * @return signature Returns all the parameters of the claim for the specified _claimId (topic, scheme, signature, issuer, data, uri) .\n', '    * @return data Returns all the parameters of the claim for the specified _claimId (topic, scheme, signature, issuer, data, uri) .\n', '    * @return uri Returns all the parameters of the claim for the specified _claimId (topic, scheme, signature, issuer, data, uri) .\n', '    */\n', '    function getClaim(bytes32 _claimId)\n', '    public\n', '    override\n', '    view\n', '    returns(\n', '        uint256 topic,\n', '        uint256 scheme,\n', '        address issuer,\n', '        bytes memory signature,\n', '        bytes memory data,\n', '        string memory uri\n', '    )\n', '    {\n', '        return (\n', '            claims[_claimId].topic,\n', '            claims[_claimId].scheme,\n', '            claims[_claimId].issuer,\n', '            claims[_claimId].signature,\n', '            claims[_claimId].data,\n', '            claims[_claimId].uri\n', '        );\n', '    }\n', '\n', '    /**\n', '    * @notice Implementation of the getClaimIdsByTopic function from the ERC-735 standard.\n', '    * used to get all the claims from the specified topic\n', '    *\n', '    * @param _topic The identity of the claim i.e. keccak256(abi.encode(_issuer, _topic))\n', '    *\n', '    * @return claimIds Returns an array of claim IDs by topic.\n', '    */\n', '    function getClaimIdsByTopic(uint256 _topic)\n', '    public\n', '    override\n', '    view\n', '    returns(bytes32[] memory claimIds)\n', '    {\n', '        return claimsByTopic[_topic];\n', '    }\n', '}\n', '\n', '// File: contracts/IdentityFactory.sol\n', '\n', 'pragma solidity 0.6.2;\n', '\n', 'contract IdentityFactory is CloneFactory {\n', '    address public libraryAddress;\n', '\n', '    event IdentityCreated(address newIdentityAddress);\n', '\n', '    constructor(address _libraryAddress) public {\n', '        libraryAddress = _libraryAddress;\n', '    }\n', '\n', '    function setLibraryAddress(address _libraryAddress) public {\n', '        libraryAddress = _libraryAddress;\n', '    }\n', '\n', '    function createIdentity(address _owner) public returns(address) {\n', '        address clone = createClone(libraryAddress);\n', '        Identity(clone).set(_owner);\n', '        IdentityCreated(clone);\n', '        return clone;\n', '    }\n', '\n', '    function isClonedIdentity(address _identity) public view returns (bool) {\n', '        return isClone(libraryAddress, _identity);\n', '    }\n', '}']
['// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal virtual view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal virtual view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor() internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(\n', '            newOwner != address(0),\n', '            "Ownable: new owner is the zero address"\n', '        );\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Pausable.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which allows children to implement an emergency stop\n', ' * mechanism that can be triggered by an authorized account.\n', ' *\n', ' * This module is used through inheritance. It will make available the\n', ' * modifiers `whenNotPaused` and `whenPaused`, which can be applied to\n', ' * the functions of your contract. Note that they will not be pausable by\n', ' * simply including this module, only once the modifiers are put in place.\n', ' */\n', 'contract Pausable is Context {\n', '    /**\n', '     * @dev Emitted when the pause is triggered by `account`.\n', '     */\n', '    event Paused(address account);\n', '\n', '    /**\n', '     * @dev Emitted when the pause is lifted by `account`.\n', '     */\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    /**\n', '     * @dev Initializes the contract in unpaused state.\n', '     */\n', '    constructor() internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the contract is paused, and false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused, "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused, "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers stopped state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    /**\n', '     * @dev Returns to normal state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', '// File: contracts/market/GitHubMarket.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IMarketBehavior {\n', '    function authenticate(\n', '        address _prop,\n', '        string calldata _args1,\n', '        string calldata _args2,\n', '        string calldata _args3,\n', '        string calldata _args4,\n', '        string calldata _args5,\n', '        address market,\n', '        address account\n', '    )\n', '        external\n', '        returns (\n', '            // solium-disable-next-line indentation\n', '            bool\n', '        );\n', '\n', '    function schema() external view returns (string memory);\n', '\n', '    function getId(address _metrics) external view returns (string memory);\n', '\n', '    function getMetrics(string calldata _id) external view returns (address);\n', '}\n', '\n', 'interface IMarket {\n', '    function authenticate(\n', '        address _prop,\n', '        string calldata _args1,\n', '        string calldata _args2,\n', '        string calldata _args3,\n', '        string calldata _args4,\n', '        string calldata _args5\n', '    )\n', '        external\n', '        returns (\n', '            // solium-disable-next-line indentation\n', '            bool\n', '        );\n', '\n', '    function authenticatedCallback(address _property, bytes32 _idHash)\n', '        external\n', '        returns (address);\n', '\n', '    function deauthenticate(address _metrics) external;\n', '\n', '    function schema() external view returns (string memory);\n', '\n', '    function behavior() external view returns (address);\n', '\n', '    function enabled() external view returns (bool);\n', '\n', '    function votingEndBlockNumber() external view returns (uint256);\n', '\n', '    function toEnable() external;\n', '}\n', '\n', 'contract GitHubMarket is IMarketBehavior, Ownable, Pausable {\n', '    address private khaos;\n', '    address private associatedMarket;\n', '    address private operator;\n', '    bool public migratable = true;\n', '    bool public priorApproval = true;\n', '\n', '    mapping(address => string) private repositories;\n', '    mapping(bytes32 => address) private metrics;\n', '    mapping(bytes32 => address) private properties;\n', '    mapping(bytes32 => address) private markets;\n', '    mapping(bytes32 => bool) private pendingAuthentication;\n', '    mapping(bytes32 => bool) private authenticationed;\n', '    mapping(string => bool) private publicSignatures;\n', '    event Registered(address _metrics, string _repository);\n', '    event Authenticated(string _repository, uint256 _status, string message);\n', '    event Query(\n', '        string githubRepository,\n', '        string publicSignature,\n', '        address account\n', '    );\n', '\n', '    /*\n', '    _githubRepository: ex)\n', '                        personal repository: Akira-Taniguchi/cloud_lib\n', '                        organization repository: dev-protocol/protocol\n', '    _publicSignature: signature string(created by Khaos)\n', '    */\n', '    function authenticate(\n', '        address _prop,\n', '        string memory _githubRepository,\n', '        string memory _publicSignature,\n', '        string memory,\n', '        string memory,\n', '        string memory,\n', '        address _dest,\n', '        address account\n', '    ) external override whenNotPaused returns (bool) {\n', '        require(\n', '            msg.sender == address(0) || msg.sender == associatedMarket,\n', '            "Invalid sender"\n', '        );\n', '\n', '        if (priorApproval) {\n', '            require(\n', '                publicSignatures[_publicSignature],\n', '                "it has not been approved"\n', '            );\n', '        }\n', '        bytes32 key = createKey(_githubRepository);\n', '        require(authenticationed[key] == false, "already authinticated");\n', '        emit Query(_githubRepository, _publicSignature, account);\n', '        properties[key] = _prop;\n', '        markets[key] = _dest;\n', '        pendingAuthentication[key] = true;\n', '        return true;\n', '    }\n', '\n', '    function khaosCallback(\n', '        string memory _githubRepository,\n', '        uint256 _status,\n', '        string memory _message\n', '    ) external whenNotPaused {\n', '        require(msg.sender == khaos, "illegal access");\n', '        require(_status == 0, _message);\n', '        bytes32 key = createKey(_githubRepository);\n', '        require(pendingAuthentication[key], "not while pending");\n', '        emit Authenticated(_githubRepository, _status, _message);\n', '        authenticationed[key] = true;\n', '        register(key, _githubRepository, markets[key], properties[key]);\n', '    }\n', '\n', '    function register(\n', '        bytes32 _key,\n', '        string memory _repository,\n', '        address _market,\n', '        address _property\n', '    ) private {\n', '        address _metrics = IMarket(_market).authenticatedCallback(\n', '            _property,\n', '            _key\n', '        );\n', '        repositories[_metrics] = _repository;\n', '        metrics[_key] = _metrics;\n', '        emit Registered(_metrics, _repository);\n', '    }\n', '\n', '    function createKey(string memory _repository)\n', '        private\n', '        pure\n', '        returns (bytes32)\n', '    {\n', '        return keccak256(abi.encodePacked(_repository));\n', '    }\n', '\n', '    function getId(address _metrics)\n', '        external\n', '        override\n', '        view\n', '        returns (string memory)\n', '    {\n', '        return repositories[_metrics];\n', '    }\n', '\n', '    function getMetrics(string memory _repository)\n', '        external\n', '        override\n', '        view\n', '        returns (address)\n', '    {\n', '        return metrics[createKey(_repository)];\n', '    }\n', '\n', '    function migrate(\n', '        string memory _repository,\n', '        address _market,\n', '        address _property\n', '    ) external onlyOwner {\n', '        require(migratable, "now is not migratable");\n', '        bytes32 key = createKey(_repository);\n', '        authenticationed[key] = true;\n', '        register(key, _repository, _market, _property);\n', '    }\n', '\n', '    function done() external onlyOwner {\n', '        migratable = false;\n', '    }\n', '\n', '    function setPriorApprovalMode(bool _value) external onlyOwner {\n', '        priorApproval = _value;\n', '    }\n', '\n', '    function addPublicSignaturee(string memory _publicSignature) external {\n', '        require(\n', '            msg.sender == owner() || msg.sender == operator,\n', '            "Invalid sender"\n', '        );\n', '        publicSignatures[_publicSignature] = true;\n', '    }\n', '\n', '    function setOperator(address _operator) external onlyOwner {\n', '        operator = _operator;\n', '    }\n', '\n', '    function setKhaos(address _khaos) external onlyOwner {\n', '        khaos = _khaos;\n', '    }\n', '\n', '    function setAssociatedMarket(address _associatedMarket) external onlyOwner {\n', '        associatedMarket = _associatedMarket;\n', '    }\n', '\n', '    function schema() external override view returns (string memory) {\n', '        return\n', '            \'["GitHub Repository (e.g, your/awesome-repos)", "Khaos Public Signature"]\';\n', '    }\n', '\n', '    function pause() external whenNotPaused onlyOwner {\n', '        _pause();\n', '    }\n', '\n', '    function unpause() external whenPaused onlyOwner {\n', '        _unpause();\n', '    }\n', '}']
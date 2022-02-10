['// SPDX-License-Identifier: bsl-1.1\n', '\n', '/*\n', '  Copyright 2020 Unit Protocol: Artem Zakharov ([email\xa0protected]).\n', '*/\n', 'pragma solidity 0.7.6;\n', '\n', 'import "../VaultParameters.sol";\n', 'import "../interfaces/IForceTransferAssetStore.sol";\n', '\n', '\n', '/**\n', ' * @title ForceTransferAssetStore\n', ' **/\n', 'contract ForceTransferAssetStore is Auth, IForceTransferAssetStore {\n', '\n', '    /*\n', '        Mapping of assets that require a transfer of at least 1 unit of token\n', '        to update internal logic related to staking rewards in case of full liquidation\n', '     */\n', '    mapping(address => bool) public override shouldForceTransfer;\n', '\n', '    event ForceTransferAssetAdded(address indexed asset);\n', '\n', '    constructor(address _vaultParameters, address[] memory initialAssets) Auth(_vaultParameters) {\n', '        for (uint i = 0; i < initialAssets.length; i++) {\n', '            require(!shouldForceTransfer[initialAssets[i]], "Unit Protocol: Already exists");\n', '            shouldForceTransfer[initialAssets[i]] = true;\n', '            emit ForceTransferAssetAdded(initialAssets[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice Only manager is able to call this function\n', '     * @dev Mark asset as `shouldForceTransfer`\n', '     * @param asset The address of the asset\n', '     **/\n', '    function add(address asset) external override onlyManager {\n', '        require(!shouldForceTransfer[asset], "Unit Protocol: Already exists");\n', '        require(asset != address(0), "Unit Protocol: ZERO_ADDRESS");\n', '        shouldForceTransfer[asset] = true;\n', '        emit ForceTransferAssetAdded(asset);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: bsl-1.1\n', '\n', '/*\n', '  Copyright 2020 Unit Protocol: Artem Zakharov ([email\xa0protected]).\n', '*/\n', 'pragma solidity 0.7.6;\n', '\n', '\n', '\n', '/**\n', ' * @title Auth\n', " * @dev Manages USDP's system access\n", ' **/\n', 'contract Auth {\n', '\n', '    // address of the the contract with vault parameters\n', '    VaultParameters public vaultParameters;\n', '\n', '    constructor(address _parameters) {\n', '        vaultParameters = VaultParameters(_parameters);\n', '    }\n', '\n', "    // ensures tx's sender is a manager\n", '    modifier onlyManager() {\n', '        require(vaultParameters.isManager(msg.sender), "Unit Protocol: AUTH_FAILED");\n', '        _;\n', '    }\n', '\n', "    // ensures tx's sender is able to modify the Vault\n", '    modifier hasVaultAccess() {\n', '        require(vaultParameters.canModifyVault(msg.sender), "Unit Protocol: AUTH_FAILED");\n', '        _;\n', '    }\n', '\n', "    // ensures tx's sender is the Vault\n", '    modifier onlyVault() {\n', '        require(msg.sender == vaultParameters.vault(), "Unit Protocol: AUTH_FAILED");\n', '        _;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title VaultParameters\n', ' **/\n', 'contract VaultParameters is Auth {\n', '\n', '    // map token to stability fee percentage; 3 decimals\n', '    mapping(address => uint) public stabilityFee;\n', '\n', '    // map token to liquidation fee percentage, 0 decimals\n', '    mapping(address => uint) public liquidationFee;\n', '\n', '    // map token to USDP mint limit\n', '    mapping(address => uint) public tokenDebtLimit;\n', '\n', '    // permissions to modify the Vault\n', '    mapping(address => bool) public canModifyVault;\n', '\n', '    // managers\n', '    mapping(address => bool) public isManager;\n', '\n', '    // enabled oracle types\n', '    mapping(uint => mapping (address => bool)) public isOracleTypeEnabled;\n', '\n', '    // address of the Vault\n', '    address payable public vault;\n', '\n', '    // The foundation address\n', '    address public foundation;\n', '\n', '    /**\n', '     * The address for an Ethereum contract is deterministically computed from the address of its creator (sender)\n', '     * and how many transactions the creator has sent (nonce). The sender and nonce are RLP encoded and then\n', '     * hashed with Keccak-256.\n', '     * Therefore, the Vault address can be pre-computed and passed as an argument before deployment.\n', '    **/\n', '    constructor(address payable _vault, address _foundation) Auth(address(this)) {\n', '        require(_vault != address(0), "Unit Protocol: ZERO_ADDRESS");\n', '        require(_foundation != address(0), "Unit Protocol: ZERO_ADDRESS");\n', '\n', '        isManager[msg.sender] = true;\n', '        vault = _vault;\n', '        foundation = _foundation;\n', '    }\n', '\n', '    /**\n', '     * @notice Only manager is able to call this function\n', "     * @dev Grants and revokes manager's status of any address\n", '     * @param who The target address\n', '     * @param permit The permission flag\n', '     **/\n', '    function setManager(address who, bool permit) external onlyManager {\n', '        isManager[who] = permit;\n', '    }\n', '\n', '    /**\n', '     * @notice Only manager is able to call this function\n', '     * @dev Sets the foundation address\n', '     * @param newFoundation The new foundation address\n', '     **/\n', '    function setFoundation(address newFoundation) external onlyManager {\n', '        require(newFoundation != address(0), "Unit Protocol: ZERO_ADDRESS");\n', '        foundation = newFoundation;\n', '    }\n', '\n', '    /**\n', '     * @notice Only manager is able to call this function\n', '     * @dev Sets ability to use token as the main collateral\n', '     * @param asset The address of the main collateral token\n', '     * @param stabilityFeeValue The percentage of the year stability fee (3 decimals)\n', '     * @param liquidationFeeValue The liquidation fee percentage (0 decimals)\n', '     * @param usdpLimit The USDP token issue limit\n', '     * @param oracles The enables oracle types\n', '     **/\n', '    function setCollateral(\n', '        address asset,\n', '        uint stabilityFeeValue,\n', '        uint liquidationFeeValue,\n', '        uint usdpLimit,\n', '        uint[] calldata oracles\n', '    ) external onlyManager {\n', '        setStabilityFee(asset, stabilityFeeValue);\n', '        setLiquidationFee(asset, liquidationFeeValue);\n', '        setTokenDebtLimit(asset, usdpLimit);\n', '        for (uint i=0; i < oracles.length; i++) {\n', '            setOracleType(oracles[i], asset, true);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice Only manager is able to call this function\n', '     * @dev Sets a permission for an address to modify the Vault\n', '     * @param who The target address\n', '     * @param permit The permission flag\n', '     **/\n', '    function setVaultAccess(address who, bool permit) external onlyManager {\n', '        canModifyVault[who] = permit;\n', '    }\n', '\n', '    /**\n', '     * @notice Only manager is able to call this function\n', '     * @dev Sets the percentage of the year stability fee for a particular collateral\n', '     * @param asset The address of the main collateral token\n', '     * @param newValue The stability fee percentage (3 decimals)\n', '     **/\n', '    function setStabilityFee(address asset, uint newValue) public onlyManager {\n', '        stabilityFee[asset] = newValue;\n', '    }\n', '\n', '    /**\n', '     * @notice Only manager is able to call this function\n', '     * @dev Sets the percentage of the liquidation fee for a particular collateral\n', '     * @param asset The address of the main collateral token\n', '     * @param newValue The liquidation fee percentage (0 decimals)\n', '     **/\n', '    function setLiquidationFee(address asset, uint newValue) public onlyManager {\n', '        require(newValue <= 100, "Unit Protocol: VALUE_OUT_OF_RANGE");\n', '        liquidationFee[asset] = newValue;\n', '    }\n', '\n', '    /**\n', '     * @notice Only manager is able to call this function\n', '     * @dev Enables/disables oracle types\n', '     * @param _type The type of the oracle\n', '     * @param asset The address of the main collateral token\n', '     * @param enabled The control flag\n', '     **/\n', '    function setOracleType(uint _type, address asset, bool enabled) public onlyManager {\n', '        isOracleTypeEnabled[_type][asset] = enabled;\n', '    }\n', '\n', '    /**\n', '     * @notice Only manager is able to call this function\n', '     * @dev Sets USDP limit for a specific collateral\n', '     * @param asset The address of the main collateral token\n', '     * @param limit The limit number\n', '     **/\n', '    function setTokenDebtLimit(address asset, uint limit) public onlyManager {\n', '        tokenDebtLimit[asset] = limit;\n', '    }\n', '}\n', '\n', 'interface IForceTransferAssetStore {\n', '    function shouldForceTransfer ( address ) external view returns ( bool );\n', '    function add ( address asset ) external;\n', '}\n', '\n', '{\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']
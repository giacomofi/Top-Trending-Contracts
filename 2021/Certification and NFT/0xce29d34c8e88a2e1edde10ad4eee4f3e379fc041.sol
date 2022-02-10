['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-15\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.2;\n', '\n', '/*******************************************************\n', ' *                       Interfaces                    *\n', ' *******************************************************/\n', 'interface IV1Registry {\n', '    function getVaults() external view returns (address[] memory);\n', '\n', '    function getVaultsLength() external view returns (uint256);\n', '}\n', '\n', 'interface ManagementList {\n', '    function isManager(address accountAddress) external returns (bool);\n', '}\n', '\n', '/*******************************************************\n', ' *                     Management List                 *\n', ' *******************************************************/\n', '\n', 'contract Manageable {\n', '    ManagementList public managementList;\n', '\n', '    constructor(address _managementListAddress) {\n', '        managementList = ManagementList(_managementListAddress);\n', '    }\n', '\n', '    modifier onlyManagers() {\n', '        bool isManager = managementList.isManager(msg.sender);\n', '        require(isManager, "ManagementList: caller is not a manager");\n', '        _;\n', '    }\n', '}\n', '\n', '/*******************************************************\n', ' *                    Generator Logic                  *\n', ' *******************************************************/\n', 'contract AddressesGeneratorV1Vaults is Manageable {\n', '    mapping(address => bool) public assetDeprecated; // Support for deprecating assets. If an asset is deprecated it will not appear is results\n', '    uint256 public numberOfDeprecatedAssets; // Used to keep track of the number of deprecated assets for an adapter\n', '    address[] public positionSpenderAddresses; // A settable list of spender addresses with which to fetch asset allowances\n', '    IV1Registry public registry; // The registry is used to fetch the list of assets\n', '\n', '    /**\n', '     * Information about the generator\n', '     */\n', '    struct GeneratorInfo {\n', '        address id; // Generator address\n', '        string typeId; // Generator typeId (for example "VAULT_V2" or "IRON_BANK_MARKET")\n', '        string categoryId; // Generator categoryId (for example "VAULT")\n', '    }\n', '\n', '    /**\n', '     * Configure generator\n', '     */\n', '    constructor(address _registryAddress, address _managementListAddress)\n', '        Manageable(_managementListAddress)\n', '    {\n', '        require(\n', '            _managementListAddress != address(0),\n', '            "Missing management list address"\n', '        );\n', '        require(_registryAddress != address(0), "Missing registry address");\n', '        registry = IV1Registry(_registryAddress);\n', '    }\n', '\n', '    /**\n', '     * Deprecate or undeprecate an asset. Deprecated assets will not appear in any adapter or generator method call responses\n', '     */\n', '    function setAssetDeprecated(address assetAddress, bool newDeprecationStatus)\n', '        public\n', '        onlyManagers\n', '    {\n', '        bool currentDeprecationStatus = assetDeprecated[assetAddress];\n', '        if (currentDeprecationStatus == newDeprecationStatus) {\n', '            revert("Generator: Unable to change asset deprecation status");\n', '        }\n', '        if (newDeprecationStatus == true) {\n', '            numberOfDeprecatedAssets++;\n', '        } else {\n', '            numberOfDeprecatedAssets--;\n', '        }\n', '        assetDeprecated[assetAddress] = newDeprecationStatus;\n', '    }\n', '\n', '    /**\n', '     * Set position spender addresses. Used by `adapter.assetAllowances(address,address)`.\n', '     */\n', '    function setPositionSpenderAddresses(address[] memory addresses)\n', '        public\n', '        onlyManagers\n', '    {\n', '        positionSpenderAddresses = addresses;\n', '    }\n', '\n', '    /**\n', '     * Set registry address\n', '     */\n', '    function setRegistryAddress(address _registryAddress) public onlyManagers {\n', '        require(_registryAddress != address(0), "Missing registry address");\n', '        registry = IV1Registry(_registryAddress);\n', '    }\n', '\n', '    /**\n', '     * Fetch a list of position spender addresses\n', '     */\n', '    function getPositionSpenderAddresses()\n', '        external\n', '        view\n', '        returns (address[] memory)\n', '    {\n', '        return positionSpenderAddresses;\n', '    }\n', '\n', '    /**\n', '     * Fetch generator info\n', '     */\n', '    function generatorInfo() public view returns (GeneratorInfo memory) {\n', '        return\n', '            GeneratorInfo({\n', '                id: address(this),\n', '                typeId: "VAULT_V1",\n', '                categoryId: "VAULT"\n', '            });\n', '    }\n', '\n', '    /**\n', '     * Fetch the total number of assets\n', '     */\n', '    function assetsLength() public view returns (uint256) {\n', '        return registry.getVaultsLength() - numberOfDeprecatedAssets;\n', '    }\n', '\n', '    /**\n', '     * Fetch all asset addresses\n', '     */\n', '    function assetsAddresses() public view returns (address[] memory) {\n', '        address[] memory originalAddresses = registry.getVaults();\n', '        uint256 _numberOfAssets = originalAddresses.length;\n', '        uint256 _filteredAssetsLength = assetsLength();\n', '        if (_numberOfAssets == _filteredAssetsLength) {\n', '            return originalAddresses;\n', '        }\n', '        uint256 currentAssetIdx;\n', '        for (uint256 assetIdx = 0; assetIdx < _numberOfAssets; assetIdx++) {\n', '            address currentAssetAddress = originalAddresses[assetIdx];\n', '            bool assetIsNotDeprecated =\n', '                assetDeprecated[currentAssetAddress] == false;\n', '            if (assetIsNotDeprecated) {\n', '                originalAddresses[currentAssetIdx] = currentAssetAddress;\n', '                currentAssetIdx++;\n', '            }\n', '        }\n', '        bytes memory encodedAddresses = abi.encode(originalAddresses);\n', '        assembly {\n', '            // Manually truncate the filtered list\n', '            mstore(add(encodedAddresses, 0x40), _filteredAssetsLength)\n', '        }\n', '        address[] memory filteredAddresses =\n', '            abi.decode(encodedAddresses, (address[]));\n', '\n', '        return filteredAddresses;\n', '    }\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-11\n', '*/\n', '\n', 'pragma solidity ^0.8.2;\n', '\n', 'interface IV2Strategy {\n', '    function name() external view returns (string memory);\n', '\n', '    function apiVersion() external view returns (string memory);\n', '\n', '    function strategist() external view returns (address);\n', '\n', '    function rewards() external view returns (address);\n', '\n', '    function vault() external view returns (address);\n', '\n', '    function keeper() external view returns (address);\n', '\n', '    function want() external view returns (address);\n', '\n', '    function emergencyExit() external view returns (bool);\n', '\n', '    function isActive() external view returns (bool);\n', '\n', '    function delegatedAssets() external view returns (uint256);\n', '\n', '    function estimatedTotalAssets() external view returns (uint256);\n', '}\n', '\n', 'interface IV2RegistryAdapter {\n', '    function assetsAddresses() external view returns (address[] memory);\n', '}\n', '\n', 'interface IV2Vault {\n', '    function withdrawalQueue(uint256 arg0) external view returns (address);\n', '}\n', '\n', 'interface IHelper {\n', '    function mergeAddresses(address[][] memory addressesSets)\n', '        external\n', '        view\n', '        returns (address[] memory);\n', '}\n', '\n', 'contract StrategiesHelper {\n', '    address public registryAdapterAddress;\n', '    address public helperAddress;\n', '    IV2RegistryAdapter registryAdapter;\n', '    IHelper helper;\n', '\n', '    struct StrategyMetadata {\n', '        string name;\n', '        string apiVersion;\n', '        address strategist;\n', '        address rewards;\n', '        address vault;\n', '        address keeper;\n', '        address want;\n', '        bool emergencyExit;\n', '        bool isActive;\n', '        uint256 delegatedAssets;\n', '        uint256 estimatedTotalAssets;\n', '    }\n', '\n', '    constructor(address _registryAdapterAddress, address _helperAddress) {\n', '        registryAdapterAddress = _registryAdapterAddress;\n', '        registryAdapter = IV2RegistryAdapter(_registryAdapterAddress);\n', '        helperAddress = _helperAddress;\n', '        helper = IHelper(_helperAddress);\n', '    }\n', '\n', '    /**\n', '     * Fetch metadata about a strategy given a strategy address\n', '     */\n', '    function assetStrategy(address strategyAddress)\n', '        public\n', '        view\n', '        returns (StrategyMetadata memory)\n', '    {\n', '        IV2Strategy _strategy = IV2Strategy(strategyAddress);\n', '        return\n', '            StrategyMetadata({\n', '                name: _strategy.name(),\n', '                apiVersion: _strategy.apiVersion(),\n', '                strategist: _strategy.strategist(),\n', '                rewards: _strategy.rewards(),\n', '                vault: _strategy.vault(),\n', '                keeper: _strategy.keeper(),\n', '                want: _strategy.want(),\n', '                emergencyExit: _strategy.emergencyExit(),\n', '                isActive: _strategy.isActive(),\n', '                delegatedAssets: _strategy.delegatedAssets(),\n', '                estimatedTotalAssets: _strategy.estimatedTotalAssets()\n', '            });\n', '    }\n', '\n', '    /**\n', '     * Fetch the number of strategies for a vault\n', '     */\n', '    function assetStrategiesLength(address assetAddress)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        IV2Vault vault = IV2Vault(assetAddress);\n', '        uint256 strategyIdx;\n', '        while (true) {\n', '            address strategyAddress = vault.withdrawalQueue(strategyIdx);\n', '            if (strategyAddress == address(0)) {\n', '                break;\n', '            }\n', '            strategyIdx++;\n', '        }\n', '        return strategyIdx;\n', '    }\n', '\n', '    /**\n', '     * Fetch the total number of strategies for all vaults\n', '     */\n', '    function assetsStrategiesLength() public view returns (uint256) {\n', '        address[] memory _assetsAddresses = registryAdapter.assetsAddresses();\n', '        uint256 numberOfAssets = _assetsAddresses.length;\n', '        uint256 _assetsStrategiesLength;\n', '        for (uint256 assetIdx = 0; assetIdx < numberOfAssets; assetIdx++) {\n', '            address assetAddress = _assetsAddresses[assetIdx];\n', '            uint256 _assetStrategiesLength =\n', '                assetStrategiesLength(assetAddress);\n', '            _assetsStrategiesLength += _assetStrategiesLength;\n', '        }\n', '        return _assetsStrategiesLength;\n', '    }\n', '\n', '    /**\n', '     * Fetch strategy addresses given a vault address\n', '     */\n', '    function assetStrategiesAddresses(address assetAddress)\n', '        public\n', '        view\n', '        returns (address[] memory)\n', '    {\n', '        IV2Vault vault = IV2Vault(assetAddress);\n', '        uint256 numberOfStrategies = assetStrategiesLength(assetAddress);\n', '        address[] memory _strategiesAddresses =\n', '            new address[](numberOfStrategies);\n', '        for (\n', '            uint256 strategyIdx = 0;\n', '            strategyIdx < numberOfStrategies;\n', '            strategyIdx++\n', '        ) {\n', '            address strategyAddress = vault.withdrawalQueue(strategyIdx);\n', '            _strategiesAddresses[strategyIdx] = strategyAddress;\n', '        }\n', '        return _strategiesAddresses;\n', '    }\n', '\n', '    /**\n', '     * Fetch all strategy addresses for all vaults\n', '     */\n', '    function assetsStrategiesAddresses()\n', '        public\n', '        view\n', '        returns (address[] memory)\n', '    {\n', '        address[] memory _assetsAddresses = registryAdapter.assetsAddresses();\n', '        uint256 numberOfAssets = _assetsAddresses.length;\n', '        address[][] memory _strategiesForAssets =\n', '            new address[][](numberOfAssets);\n', '        for (uint256 assetIdx = 0; assetIdx < numberOfAssets; assetIdx++) {\n', '            address assetAddress = _assetsAddresses[assetIdx];\n', '            address[] memory _assetStrategiessAddresses =\n', '                assetStrategiesAddresses(assetAddress);\n', '            _strategiesForAssets[assetIdx] = _assetStrategiessAddresses;\n', '        }\n', '        address[] memory mergedAddresses =\n', '            helper.mergeAddresses(_strategiesForAssets);\n', '        return mergedAddresses;\n', '    }\n', '\n', '    /**\n', '     * Fetch total delegated balance for all strategies\n', '     */\n', '    function assetsStrategiesDelegatedBalance()\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        address[] memory _assetsAddresses = registryAdapter.assetsAddresses();\n', '        uint256 numberOfAssets = _assetsAddresses.length;\n', '        uint256 assetsDelegatedBalance;\n', '        for (uint256 assetIdx = 0; assetIdx < numberOfAssets; assetIdx++) {\n', '            address assetAddress = _assetsAddresses[assetIdx];\n', '            uint256 assetDelegatedBalance =\n', '                assetStrategiesDelegatedBalance(assetAddress);\n', '            assetsDelegatedBalance += assetDelegatedBalance;\n', '        }\n', '        return assetsDelegatedBalance;\n', '    }\n', '\n', '    /**\n', "     * Fetch delegated balance for all of a vault's strategies\n", '     */\n', '    function assetStrategiesDelegatedBalance(address assetAddress)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        address[] memory _assetStrategiesAddresses =\n', '            assetStrategiesAddresses(assetAddress);\n', '        uint256 numberOfStrategies = _assetStrategiesAddresses.length;\n', '        uint256 strategiesDelegatedBalance;\n', '        for (\n', '            uint256 strategyIdx = 0;\n', '            strategyIdx < numberOfStrategies;\n', '            strategyIdx++\n', '        ) {\n', '            address strategyAddress = _assetStrategiesAddresses[strategyIdx];\n', '            IV2Strategy _strategy = IV2Strategy(strategyAddress);\n', '            uint256 strategyDelegatedBalance = _strategy.delegatedAssets();\n', '            strategiesDelegatedBalance += strategyDelegatedBalance;\n', '        }\n', '        return strategiesDelegatedBalance;\n', '    }\n', '\n', '    /**\n', '     * Fetch metadata for all strategies scoped to a vault\n', '     */\n', '    function assetStrategies(address assetAddress)\n', '        external\n', '        view\n', '        returns (StrategyMetadata[] memory)\n', '    {\n', '        IV2Vault vault = IV2Vault(assetAddress);\n', '        uint256 numberOfStrategies = assetStrategiesLength(assetAddress);\n', '        StrategyMetadata[] memory _strategies =\n', '            new StrategyMetadata[](numberOfStrategies);\n', '        for (\n', '            uint256 strategyIdx = 0;\n', '            strategyIdx < numberOfStrategies;\n', '            strategyIdx++\n', '        ) {\n', '            address strategyAddress = vault.withdrawalQueue(strategyIdx);\n', '            StrategyMetadata memory _strategy = assetStrategy(strategyAddress);\n', '            _strategies[strategyIdx] = _strategy;\n', '        }\n', '        return _strategies;\n', '    }\n', '\n', '    /**\n', '     * Fetch metadata for strategies given an array of strategy addresses\n', '     */\n', '    function assetsStrategies(address[] memory _assetsStrategiesAddresses)\n', '        public\n', '        view\n', '        returns (StrategyMetadata[] memory)\n', '    {\n', '        uint256 numberOfStrategies = _assetsStrategiesAddresses.length;\n', '        StrategyMetadata[] memory strategies =\n', '            new StrategyMetadata[](numberOfStrategies);\n', '        for (\n', '            uint256 strategyIdx = 0;\n', '            strategyIdx < numberOfStrategies;\n', '            strategyIdx++\n', '        ) {\n', '            address strategyAddress = _assetsStrategiesAddresses[strategyIdx];\n', '            StrategyMetadata memory strategy = assetStrategy(strategyAddress);\n', '            strategies[strategyIdx] = strategy;\n', '        }\n', '        return strategies;\n', '    }\n', '\n', '    /**\n', '     * Fetch metadata for all strategies\n', '     */\n', '    function assetsStrategies()\n', '        external\n', '        view\n', '        returns (StrategyMetadata[] memory)\n', '    {\n', '        address[] memory _assetsStrategiesAddresses =\n', '            assetsStrategiesAddresses();\n', '        return assetsStrategies(_assetsStrategiesAddresses);\n', '    }\n', '}']
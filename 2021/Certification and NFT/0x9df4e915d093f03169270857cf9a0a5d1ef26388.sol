['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-02\n', '*/\n', '\n', '// File: contracts\\liquidity-mining\\util\\DFOHub.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IDoubleProxy {\n', '    function proxy() external view returns (address);\n', '}\n', '\n', 'interface IMVDProxy {\n', '    function getMVDFunctionalitiesManagerAddress() external view returns(address);\n', '    function getMVDWalletAddress() external view returns (address);\n', '    function getStateHolderAddress() external view returns(address);\n', '    function submit(string calldata codeName, bytes calldata data) external payable returns(bytes memory returnData);\n', '}\n', '\n', 'interface IMVDFunctionalitiesManager {\n', '    function getFunctionalityData(string calldata codeName) external view returns(address, uint256, string memory, address, uint256);\n', '    function isAuthorizedFunctionality(address functionality) external view returns(bool);\n', '}\n', '\n', 'interface IStateHolder {\n', '    function getUint256(string calldata name) external view returns(uint256);\n', '    function getAddress(string calldata name) external view returns(address);\n', '    function clear(string calldata varName) external returns(string memory oldDataType, bytes memory oldVal);\n', '}\n', '\n', '// File: contracts\\liquidity-mining\\ILiquidityMiningFactory.sol\n', '\n', '//SPDX_License_Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface ILiquidityMiningFactory {\n', '\n', '    event ExtensionCloned(address indexed);\n', '\n', '    function feePercentageInfo() external view returns (uint256, address);\n', '    function liquidityMiningDefaultExtension() external view returns(address);\n', '    function cloneLiquidityMiningDefaultExtension() external returns(address);\n', '    function getLiquidityFarmTokenCollectionURI() external view returns (string memory);\n', '    function getLiquidityFarmTokenURI() external view returns (string memory);\n', '}\n', '\n', '// File: contracts\\liquidity-mining\\LiquidityMiningFactory.sol\n', '\n', '//SPDX_License_Identifier: MIT\n', 'pragma solidity ^0.7.6;\n', '\n', '\n', '\n', 'contract LiquidityMiningFactory is ILiquidityMiningFactory {\n', '\n', '    // liquidity mining contract implementation address\n', '    address public liquidityMiningImplementationAddress;\n', '    // liquidity mining default extension\n', '    address public override liquidityMiningDefaultExtension;\n', '    // double proxy address of the linked DFO\n', '    address public _doubleProxy;\n', '    // linked DFO exit fee\n', '    uint256 private _feePercentage;\n', '    // liquidity mining collection uri\n', '    string public liquidityFarmTokenCollectionURI;\n', '    // liquidity mining farm token uri\n', '    string public liquidityFarmTokenURI;\n', '    // event that tracks liquidity mining contracts deployed\n', '    event LiquidityMiningDeployed(address indexed liquidityMiningAddress, address indexed sender, bytes liquidityMiningInitResultData);\n', '    // event that tracks logic contract address change\n', '    event LiquidityMiningLogicSet(address indexed newAddress);\n', '    // event that tracks default extension contract address change\n', '    event LiquidityMiningDefaultExtensionSet(address indexed newAddress);\n', '    // event that tracks wallet changes\n', '    event FeePercentageSet(uint256 newFeePercentage);\n', '\n', '    constructor(address doubleProxy, address _liquidityMiningImplementationAddress, address _liquidityMiningDefaultExtension, uint256 feePercentage, string memory liquidityFarmTokenCollectionUri, string memory liquidityFarmTokenUri) {\n', '        _doubleProxy = doubleProxy;\n', '        liquidityFarmTokenCollectionURI = liquidityFarmTokenCollectionUri;\n', '        liquidityFarmTokenURI = liquidityFarmTokenUri;\n', '        emit LiquidityMiningLogicSet(liquidityMiningImplementationAddress = _liquidityMiningImplementationAddress);\n', '        emit LiquidityMiningDefaultExtensionSet(liquidityMiningDefaultExtension = _liquidityMiningDefaultExtension);\n', '        emit FeePercentageSet(_feePercentage = feePercentage);\n', '    }\n', '\n', '    /** PUBLIC METHODS */\n', '\n', '    function feePercentageInfo() public override view returns (uint256, address) {\n', '        return (_feePercentage, IMVDProxy(IDoubleProxy(_doubleProxy).proxy()).getMVDWalletAddress());\n', '    }\n', '\n', '    /** @dev allows the DFO to update the double proxy address.\n', '      * @param newDoubleProxy new double proxy address.\n', '    */\n', '    function setDoubleProxy(address newDoubleProxy) public onlyDFO {\n', '        _doubleProxy = newDoubleProxy;\n', '    }\n', '\n', '    /** @dev change the fee percentage\n', '     * @param feePercentage new fee percentage.\n', '     */\n', '    function updateFeePercentage(uint256 feePercentage) public onlyDFO {\n', '        emit FeePercentageSet(_feePercentage = feePercentage);\n', '    }\n', '\n', '    /** @dev allows the factory owner to update the logic contract address.\n', '     * @param _liquidityMiningImplementationAddress new liquidity mining implementation address.\n', '     */\n', '    function updateLogicAddress(address _liquidityMiningImplementationAddress) public onlyDFO {\n', '        emit LiquidityMiningLogicSet(liquidityMiningImplementationAddress = _liquidityMiningImplementationAddress);\n', '    }\n', '\n', '    /** @dev allows the factory owner to update the default extension contract address.\n', '     * @param _liquidityMiningDefaultExtensionAddress new liquidity mining extension address.\n', '     */\n', '    function updateDefaultExtensionAddress(address _liquidityMiningDefaultExtensionAddress) public onlyDFO {\n', '        emit LiquidityMiningDefaultExtensionSet(liquidityMiningDefaultExtension = _liquidityMiningDefaultExtensionAddress);\n', '    }\n', '\n', '    /** @dev allows the factory owner to update the liquidity farm token collection uri.\n', '     * @param liquidityFarmTokenCollectionUri new liquidity farm token collection uri.\n', '     */\n', '    function updateLiquidityFarmTokenCollectionURI(string memory liquidityFarmTokenCollectionUri) public onlyDFO {\n', '        liquidityFarmTokenCollectionURI = liquidityFarmTokenCollectionUri;\n', '    }\n', '\n', '    /** @dev allows the factory owner to update the liquidity farm token collection uri.\n', '     * @param liquidityFarmTokenUri new liquidity farm token collection uri.\n', '     */\n', '    function updateLiquidityFarmTokenURI(string memory liquidityFarmTokenUri) public onlyDFO {\n', '        liquidityFarmTokenURI = liquidityFarmTokenUri;\n', '    }\n', '\n', '    /** @dev returns the liquidity farm token collection uri.\n', '      * @return liquidity farm token collection uri.\n', '     */\n', '    function getLiquidityFarmTokenCollectionURI() public override view returns (string memory) {\n', '        return liquidityFarmTokenCollectionURI;\n', '    }\n', '\n', '    /** @dev returns the liquidity farm token uri.\n', '      * @return liquidity farm token uri.\n', '     */\n', '    function getLiquidityFarmTokenURI() public override view returns (string memory) {\n', '        return liquidityFarmTokenURI;\n', '    }\n', '\n', '    /** @dev utlity method to clone default extension\n', '     * @return clonedExtension the address of the actually-cloned liquidity mining extension\n', '     */\n', '    function cloneLiquidityMiningDefaultExtension() public override returns(address clonedExtension) {\n', '        emit ExtensionCloned(clonedExtension = _clone(liquidityMiningDefaultExtension));\n', '    }\n', '\n', '    /** @dev this function deploys a new LiquidityMining contract and calls the encoded function passed as data.\n', '     * @param data encoded initialize function for the liquidity mining contract (check LiquidityMining contract code).\n', '     * @return contractAddress new liquidity mining contract address.\n', '     * @return initResultData new liquidity mining contract call result.\n', '     */\n', '    function deploy(bytes memory data) public returns (address contractAddress, bytes memory initResultData) {\n', '        initResultData = _call(contractAddress = _clone(liquidityMiningImplementationAddress), data);\n', '        emit LiquidityMiningDeployed(contractAddress, msg.sender, initResultData);\n', '    }\n', '\n', '    /** PRIVATE METHODS */\n', '\n', '    /** @dev clones the input contract address and returns the copied contract address.\n', '     * @param original address of the original contract.\n', '     * @return copy copied contract address.\n', '     */\n', '    function _clone(address original) private returns (address copy) {\n', '        assembly {\n', '            mstore(\n', '                0,\n', '                or(\n', '                    0x5880730000000000000000000000000000000000000000803b80938091923cF3,\n', '                    mul(original, 0x1000000000000000000)\n', '                )\n', '            )\n', '            copy := create(0, 0, 32)\n', '            switch extcodesize(copy)\n', '                case 0 {\n', '                    invalid()\n', '                }\n', '        }\n', '    }\n', '\n', '    /** @dev calls the contract at the given location using the given payload and returns the returnData.\n', '      * @param location location to call.\n', '      * @param payload call payload.\n', '      * @return returnData call return data.\n', '     */\n', '    function _call(address location, bytes memory payload) private returns(bytes memory returnData) {\n', '        assembly {\n', '            let result := call(gas(), location, 0, add(payload, 0x20), mload(payload), 0, 0)\n', '            let size := returndatasize()\n', '            returnData := mload(0x40)\n', '            mstore(returnData, size)\n', '            let returnDataPayloadStart := add(returnData, 0x20)\n', '            returndatacopy(returnDataPayloadStart, 0, size)\n', '            mstore(0x40, add(returnDataPayloadStart, size))\n', '            switch result case 0 {revert(returnDataPayloadStart, size)}\n', '        }\n', '    }\n', '\n', '    /** @dev onlyDFO modifier used to check for unauthorized accesses. */\n', '    modifier onlyDFO() {\n', '        require(IMVDFunctionalitiesManager(IMVDProxy(IDoubleProxy(_doubleProxy).proxy()).getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "Unauthorized.");\n', '        _;\n', '    }\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-26\n', '*/\n', '\n', '// File: localhost/VaultParameters.sol\n', '\n', '// SPDX-License-Identifier: bsl-1.1\n', '\n', '/*\n', '  Copyright 2020 Unit Protocol: Artem Zakharov ([email\xa0protected]).\n', '*/\n', 'pragma solidity ^0.7.1;\n', '\n', '\n', '/**\n', ' * @title Auth\n', " * @dev Manages USDP's system access\n", ' **/\n', 'contract Auth {\n', '\n', '    // address of the the contract with vault parameters\n', '    VaultParameters public vaultParameters;\n', '\n', '    constructor(address _parameters) {\n', '        vaultParameters = VaultParameters(_parameters);\n', '    }\n', '\n', "    // ensures tx's sender is a manager\n", '    modifier onlyManager() {\n', '        require(vaultParameters.isManager(msg.sender), "Unit Protocol: AUTH_FAILED");\n', '        _;\n', '    }\n', '\n', "    // ensures tx's sender is able to modify the Vault\n", '    modifier hasVaultAccess() {\n', '        require(vaultParameters.canModifyVault(msg.sender), "Unit Protocol: AUTH_FAILED");\n', '        _;\n', '    }\n', '\n', "    // ensures tx's sender is the Vault\n", '    modifier onlyVault() {\n', '        require(msg.sender == vaultParameters.vault(), "Unit Protocol: AUTH_FAILED");\n', '        _;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title VaultParameters\n', ' **/\n', 'contract VaultParameters {\n', '\n', '    // permissions to modify the Vault\n', '    mapping(address => bool) public canModifyVault;\n', '\n', '    // managers\n', '    mapping(address => bool) public isManager;\n', '\n', '    // address of the Vault\n', '    address payable public vault;\n', '}\n', '\n', '// File: localhost/CollateralRegistry.sol\n', '\n', '/*\n', '  Copyright 2020 Unit Protocol: Artem Zakharov ([email\xa0protected]).\n', '*/\n', 'pragma solidity ^0.7.1;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', '\n', '/**\n', ' * @title CollateralRegistry\n', ' **/\n', 'contract CollateralRegistry is Auth {\n', '\n', '    event CollateralAdded(address indexed asset);\n', '    event CollateralRemoved(address indexed asset);\n', '\n', '    mapping(address => uint) public collateralId;\n', '\n', '    address[] public collateralList;\n', '    \n', '    constructor(address _vaultParameters, address[] memory assets) Auth(_vaultParameters) {\n', '        for (uint i = 0; i < assets.length; i++) {\n', '            collateralList.push(assets[i]);\n', '            collateralId[assets[i]] = i;\n', '            emit CollateralAdded(assets[i]);\n', '        }\n', '    }\n', '\n', '    function addCollateral(address asset) public onlyManager {\n', '        require(asset != address(0), "Unit Protocol: ZERO_ADDRESS");\n', '\n', '        require(!isCollateral(asset), "Unit Protocol: ALREADY_EXIST");\n', '\n', '        collateralId[asset] = collateralList.length;\n', '        collateralList.push(asset);\n', '\n', '        emit CollateralAdded(asset);\n', '    }\n', '\n', '    function removeCollateral(address asset) public onlyManager {\n', '        require(asset != address(0), "Unit Protocol: ZERO_ADDRESS");\n', '\n', '        require(isCollateral(asset), "Unit Protocol: DOES_NOT_EXIST");\n', '\n', '        uint id = collateralId[asset];\n', '\n', '        delete collateralId[asset];\n', '\n', '        uint lastId = collateralList.length - 1;\n', '\n', '        if (id != lastId) {\n', '            address lastCollateral = collateralList[lastId];\n', '            collateralList[id] = lastCollateral;\n', '            collateralId[lastCollateral] = id;\n', '        }\n', '\n', '        collateralList.pop();\n', '\n', '        emit CollateralRemoved(asset);\n', '    }\n', '\n', '    function isCollateral(address asset) public view returns(bool) {\n', '        if (collateralList.length == 0) { return false; }\n', '        return collateralId[asset] != 0 || collateralList[0] == asset;\n', '    }\n', '\n', '    function collaterals() external view returns (address[] memory) {\n', '        return collateralList;\n', '    }\n', '\n', '    function collateralsCount() external view returns (uint) {\n', '        return collateralList.length;\n', '    }\n', '}']
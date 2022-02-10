['// SPDX-License-Identifier: Apache-2.0\n', 'pragma solidity ^0.7.0;\n', '// File: contracts/lib/Ownable.sol\n', '\n', '// Copyright 2017 Loopring Technology Limited.\n', '\n', '\n', '/// @title Ownable\n', '/// @author Brecht Devos - <brecht@loopring.org>\n', '/// @dev The Ownable contract has an owner address, and provides basic\n', '///      authorization control functions, this simplifies the implementation of\n', '///      "user permissions".\n', 'contract Ownable\n', '{\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    /// @dev The Ownable constructor sets the original `owner` of the contract\n', '    ///      to the sender.\n', '    constructor()\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /// @dev Throws if called by any account other than the owner.\n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner, "UNAUTHORIZED");\n', '        _;\n', '    }\n', '\n', '    /// @dev Allows the current owner to transfer control of the contract to a\n', '    ///      new owner.\n', '    /// @param newOwner The address to transfer ownership to.\n', '    function transferOwnership(\n', '        address newOwner\n', '        )\n', '        public\n', '        virtual\n', '        onlyOwner\n', '    {\n', '        require(newOwner != address(0), "ZERO_ADDRESS");\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function renounceOwnership()\n', '        public\n', '        onlyOwner\n', '    {\n', '        emit OwnershipTransferred(owner, address(0));\n', '        owner = address(0);\n', '    }\n', '}\n', '\n', '// File: contracts/iface/Wallet.sol\n', '\n', '// Copyright 2017 Loopring Technology Limited.\n', '\n', '\n', '/// @title Wallet\n', '/// @dev Base contract for smart wallets.\n', '///      Sub-contracts must NOT use non-default constructor to initialize\n', '///      wallet states, instead, `init` shall be used. This is to enable\n', '///      proxies to be deployed in front of the real wallet contract for\n', '///      saving gas.\n', '///\n', '/// @author Daniel Wang - <daniel@loopring.org>\n', 'interface Wallet\n', '{\n', '    function version() external pure returns (string memory);\n', '\n', '    function owner() external view returns (address);\n', '\n', '    /// @dev Set a new owner.\n', '    function setOwner(address newOwner) external;\n', '\n', '    /// @dev Adds a new module. The `init` method of the module\n', '    ///      will be called with `address(this)` as the parameter.\n', '    ///      This method must throw if the module has already been added.\n', "    /// @param _module The module's address.\n", '    function addModule(address _module) external;\n', '\n', '    /// @dev Removes an existing module. This method must throw if the module\n', "    ///      has NOT been added or the module is the wallet's only module.\n", "    /// @param _module The module's address.\n", '    function removeModule(address _module) external;\n', '\n', '    /// @dev Checks if a module has been added to this wallet.\n', '    /// @param _module The module to check.\n', '    /// @return True if the module exists; False otherwise.\n', '    function hasModule(address _module) external view returns (bool);\n', '\n', '    /// @dev Binds a method from the given module to this\n', "    ///      wallet so the method can be invoked using this wallet's default\n", '    ///      function.\n', '    ///      Note that this method must throw when the given module has\n', '    ///      not been added to this wallet.\n', "    /// @param _method The method's 4-byte selector.\n", "    /// @param _module The module's address. Use address(0) to unbind the method.\n", '    function bindMethod(bytes4 _method, address _module) external;\n', '\n', '    /// @dev Returns the module the given method has been bound to.\n', "    /// @param _method The method's 4-byte selector.\n", '    /// @return _module The address of the bound module. If no binding exists,\n', '    ///                 returns address(0) instead.\n', '    function boundMethodModule(bytes4 _method) external view returns (address _module);\n', '\n', '    /// @dev Performs generic transactions. Any module that has been added to this\n', '    ///      wallet can use this method to transact on any third-party contract with\n', '    ///      msg.sender as this wallet itself.\n', '    ///\n', '    ///      Note: 1) this method must ONLY allow invocations from a module that has\n', '    ///      been added to this wallet. The wallet owner shall NOT be permitted\n', '    ///      to call this method directly. 2) Reentrancy inside this function should\n', '    ///      NOT cause any problems.\n', '    ///\n', '    /// @param mode The transaction mode, 1 for CALL, 2 for DELEGATECALL.\n', '    /// @param to The desitination address.\n', '    /// @param value The amount of Ether to transfer.\n', '    /// @param data The data to send over using `to.call{value: value}(data)`\n', "    /// @return returnData The transaction's return value.\n", '    function transact(\n', '        uint8    mode,\n', '        address  to,\n', '        uint     value,\n', '        bytes    calldata data\n', '        )\n', '        external\n', '        returns (bytes memory returnData);\n', '}\n', '\n', '// File: contracts/iface/Module.sol\n', '\n', '// Copyright 2017 Loopring Technology Limited.\n', '\n', '\n', '\n', '\n', '/// @title Module\n', '/// @dev Base contract for all smart wallet modules.\n', '///\n', '/// @author Daniel Wang - <daniel@loopring.org>\n', 'interface Module\n', '{\n', '    /// @dev Activates the module for the given wallet (msg.sender) after the module is added.\n', '    ///      Warning: this method shall ONLY be callable by a wallet.\n', '    function activate() external;\n', '\n', '    /// @dev Deactivates the module for the given wallet (msg.sender) before the module is removed.\n', '    ///      Warning: this method shall ONLY be callable by a wallet.\n', '    function deactivate() external;\n', '}\n', '\n', '// File: contracts/lib/ERC20.sol\n', '\n', '// Copyright 2017 Loopring Technology Limited.\n', '\n', '\n', '/// @title ERC20 Token Interface\n', '/// @dev see https://github.com/ethereum/EIPs/issues/20\n', '/// @author Daniel Wang - <daniel@loopring.org>\n', 'abstract contract ERC20\n', '{\n', '    function totalSupply()\n', '        public\n', '        view\n', '        virtual\n', '        returns (uint);\n', '\n', '    function balanceOf(\n', '        address who\n', '        )\n', '        public\n', '        view\n', '        virtual\n', '        returns (uint);\n', '\n', '    function allowance(\n', '        address owner,\n', '        address spender\n', '        )\n', '        public\n', '        view\n', '        virtual\n', '        returns (uint);\n', '\n', '    function transfer(\n', '        address to,\n', '        uint value\n', '        )\n', '        public\n', '        virtual\n', '        returns (bool);\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint    value\n', '        )\n', '        public\n', '        virtual\n', '        returns (bool);\n', '\n', '    function approve(\n', '        address spender,\n', '        uint    value\n', '        )\n', '        public\n', '        virtual\n', '        returns (bool);\n', '}\n', '\n', '// File: contracts/lib/ReentrancyGuard.sol\n', '\n', '// Copyright 2017 Loopring Technology Limited.\n', '\n', '\n', '/// @title ReentrancyGuard\n', '/// @author Brecht Devos - <brecht@loopring.org>\n', '/// @dev Exposes a modifier that guards a function against reentrancy\n', '///      Changing the value of the same storage value multiple times in a transaction\n', '///      is cheap (starting from Istanbul) so there is no need to minimize\n', '///      the number of times the value is changed\n', 'contract ReentrancyGuard\n', '{\n', '    //The default value must be 0 in order to work behind a proxy.\n', '    uint private _guardValue;\n', '\n', '    modifier nonReentrant()\n', '    {\n', '        require(_guardValue == 0, "REENTRANCY");\n', '        _guardValue = 1;\n', '        _;\n', '        _guardValue = 0;\n', '    }\n', '}\n', '\n', '// File: contracts/iface/ModuleRegistry.sol\n', '\n', '// Copyright 2017 Loopring Technology Limited.\n', '\n', '\n', '/// @title ModuleRegistry\n', '/// @dev A registry for modules.\n', '///\n', '/// @author Daniel Wang - <daniel@loopring.org>\n', 'interface ModuleRegistry\n', '{\n', '\t/// @dev Registers and enables a new module.\n', '    function registerModule(address module) external;\n', '\n', '    /// @dev Disables a module\n', '    function disableModule(address module) external;\n', '\n', '    /// @dev Returns true if the module is registered and enabled.\n', '    function isModuleEnabled(address module) external view returns (bool);\n', '\n', '    /// @dev Returns the list of enabled modules.\n', '    function enabledModules() external view returns (address[] memory _modules);\n', '\n', '    /// @dev Returns the number of enbaled modules.\n', '    function numOfEnabledModules() external view returns (uint);\n', '\n', '    /// @dev Returns true if the module is ever registered.\n', '    function isModuleRegistered(address module) external view returns (bool);\n', '}\n', '\n', '// File: contracts/base/Controller.sol\n', '\n', '// Copyright 2017 Loopring Technology Limited.\n', '\n', '\n', '\n', '/// @title Controller\n', '///\n', '/// @author Daniel Wang - <daniel@loopring.org>\n', 'abstract contract Controller\n', '{\n', '    function moduleRegistry()\n', '        external\n', '        view\n', '        virtual\n', '        returns (ModuleRegistry);\n', '\n', '    function walletFactory()\n', '        external\n', '        view\n', '        virtual\n', '        returns (address);\n', '}\n', '\n', '// File: contracts/base/BaseWallet.sol\n', '\n', '// Copyright 2017 Loopring Technology Limited.\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/// @title BaseWallet\n', '/// @dev This contract provides basic implementation for a Wallet.\n', '///\n', '/// @author Daniel Wang - <daniel@loopring.org>\n', 'abstract contract BaseWallet is ReentrancyGuard, Wallet\n', '{\n', '    // WARNING: do not delete wallet state data to make this implementation\n', '    // compatible with early versions.\n', '    //\n', '    //  ----- DATA LAYOUT BEGINS -----\n', '    address internal _owner;\n', '\n', '    mapping (address => bool) private modules;\n', '\n', '    Controller public controller;\n', '\n', '    mapping (bytes4  => address) internal methodToModule;\n', '    //  ----- DATA LAYOUT ENDS -----\n', '\n', '    event OwnerChanged          (address newOwner);\n', '    event ControllerChanged     (address newController);\n', '    event ModuleAdded           (address module);\n', '    event ModuleRemoved         (address module);\n', '    event MethodBound           (bytes4  method, address module);\n', '    event WalletSetup           (address owner);\n', '\n', '    modifier onlyFromModule\n', '    {\n', '        require(modules[msg.sender], "MODULE_UNAUTHORIZED");\n', '        _;\n', '    }\n', '\n', '    modifier onlyFromFactory\n', '    {\n', '        require(\n', '            msg.sender == controller.walletFactory(),\n', '            "UNAUTHORIZED"\n', '        );\n', '        _;\n', '    }\n', '\n', "    /// @dev We need to make sure the Factory address cannot be changed without wallet owner's\n", '    ///      explicit authorization.\n', '    modifier onlyFromFactoryOrModule\n', '    {\n', '        require(\n', '            modules[msg.sender] || msg.sender == controller.walletFactory(),\n', '            "UNAUTHORIZED"\n', '        );\n', '        _;\n', '    }\n', '\n', '    /// @dev Set up this wallet by assigning an original owner\n', '    ///\n', '    ///      Note that calling this method more than once will throw.\n', '    ///\n', '    /// @param _initialOwner The owner of this wallet, must not be address(0).\n', '    function initOwner(\n', '        address _initialOwner\n', '        )\n', '        external\n', '        onlyFromFactory\n', '    {\n', '        require(controller != Controller(0), "NO_CONTROLLER");\n', '        require(_owner == address(0), "INITIALIZED_ALREADY");\n', '        require(_initialOwner != address(0), "ZERO_ADDRESS");\n', '\n', '        _owner = _initialOwner;\n', '        emit WalletSetup(_initialOwner);\n', '    }\n', '\n', '    /// @dev Set up this wallet by assigning a controller and initial modules.\n', '    ///\n', '    ///      Note that calling this method more than once will throw.\n', '    ///      And this method must be invoked before owner is initialized\n', '    ///\n', '    /// @param _controller The Controller instance.\n', '    /// @param _modules The initial modules.\n', '    function init(\n', '        Controller _controller,\n', '        address[]  calldata _modules\n', '        )\n', '        external\n', '    {\n', '        require(\n', '            _owner == address(0) &&\n', '            controller == Controller(0) &&\n', '            _controller != Controller(0),\n', '            "CONTROLLER_INIT_FAILED"\n', '        );\n', '\n', '        controller = _controller;\n', '\n', '        ModuleRegistry moduleRegistry = controller.moduleRegistry();\n', '        for (uint i = 0; i < _modules.length; i++) {\n', '            _addModule(_modules[i], moduleRegistry);\n', '        }\n', '    }\n', '\n', '    function owner()\n', '        override\n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        return _owner;\n', '    }\n', '\n', '    function setOwner(address newOwner)\n', '        external\n', '        override\n', '        onlyFromModule\n', '    {\n', '        require(newOwner != address(0), "ZERO_ADDRESS");\n', '        require(newOwner != address(this), "PROHIBITED");\n', '        require(newOwner != _owner, "SAME_ADDRESS");\n', '        _owner = newOwner;\n', '        emit OwnerChanged(newOwner);\n', '    }\n', '\n', '    function setController(Controller newController)\n', '        external\n', '        onlyFromModule\n', '    {\n', '        require(newController != controller, "SAME_CONTROLLER");\n', '        require(newController != Controller(0), "INVALID_CONTROLLER");\n', '        controller = newController;\n', '        emit ControllerChanged(address(newController));\n', '    }\n', '\n', '    function addModule(address _module)\n', '        external\n', '        override\n', '        onlyFromFactoryOrModule\n', '    {\n', '        _addModule(_module, controller.moduleRegistry());\n', '    }\n', '\n', '    function removeModule(address _module)\n', '        external\n', '        override\n', '        onlyFromModule\n', '    {\n', '        // Allow deactivate to fail to make sure the module can be removed\n', '        require(modules[_module], "MODULE_NOT_EXISTS");\n', '        try Module(_module).deactivate() {} catch {}\n', '        delete modules[_module];\n', '        emit ModuleRemoved(_module);\n', '    }\n', '\n', '    function hasModule(address _module)\n', '        public\n', '        view\n', '        override\n', '        returns (bool)\n', '    {\n', '        return modules[_module];\n', '    }\n', '\n', '    function bindMethod(bytes4 _method, address _module)\n', '        external\n', '        override\n', '        onlyFromModule\n', '    {\n', '        require(_method != bytes4(0), "BAD_METHOD");\n', '        if (_module != address(0)) {\n', '            require(modules[_module], "MODULE_UNAUTHORIZED");\n', '        }\n', '\n', '        methodToModule[_method] = _module;\n', '        emit MethodBound(_method, _module);\n', '    }\n', '\n', '    function boundMethodModule(bytes4 _method)\n', '        public\n', '        view\n', '        override\n', '        returns (address)\n', '    {\n', '        return methodToModule[_method];\n', '    }\n', '\n', '    function transact(\n', '        uint8    mode,\n', '        address  to,\n', '        uint     value,\n', '        bytes    calldata data\n', '        )\n', '        external\n', '        override\n', '        onlyFromFactoryOrModule\n', '        returns (bytes memory returnData)\n', '    {\n', '        bool success;\n', '        (success, returnData) = _call(mode, to, value, data);\n', '\n', '        if (!success) {\n', '            assembly {\n', '                returndatacopy(0, 0, returndatasize())\n', '                revert(0, returndatasize())\n', '            }\n', '        }\n', '    }\n', '\n', '    receive()\n', '        external\n', '        payable\n', '    {\n', '    }\n', '\n', '    /// @dev This default function can receive Ether or perform queries to modules\n', '    ///      using bound methods.\n', '    fallback()\n', '        external\n', '        payable\n', '    {\n', '        address module = methodToModule[msg.sig];\n', '        require(modules[module], "MODULE_UNAUTHORIZED");\n', '\n', '        (bool success, bytes memory returnData) = module.call{value: msg.value}(msg.data);\n', '        assembly {\n', '            switch success\n', '            case 0 { revert(add(returnData, 32), mload(returnData)) }\n', '            default { return(add(returnData, 32), mload(returnData)) }\n', '        }\n', '    }\n', '\n', '    function _addModule(address _module, ModuleRegistry moduleRegistry)\n', '        internal\n', '    {\n', '        require(_module != address(0), "NULL_MODULE");\n', '        require(modules[_module] == false, "MODULE_EXISTS");\n', '        require(\n', '            moduleRegistry.isModuleEnabled(_module),\n', '            "INVALID_MODULE"\n', '        );\n', '        modules[_module] = true;\n', '        emit ModuleAdded(_module);\n', '        Module(_module).activate();\n', '    }\n', '\n', '    function _call(\n', '        uint8          mode,\n', '        address        target,\n', '        uint           value,\n', '        bytes calldata data\n', '        )\n', '        private\n', '        returns (\n', '            bool success,\n', '            bytes memory returnData\n', '        )\n', '    {\n', '        if (mode == 1) {\n', '            // solium-disable-next-line security/no-call-value\n', '            (success, returnData) = target.call{value: value}(data);\n', '        } else if (mode == 2) {\n', '            // solium-disable-next-line security/no-call-value\n', '            (success, returnData) = target.delegatecall(data);\n', '        } else if (mode == 3) {\n', '            require(value == 0, "INVALID_VALUE");\n', '            // solium-disable-next-line security/no-call-value\n', '            (success, returnData) = target.staticcall(data);\n', '        } else {\n', '            revert("UNSUPPORTED_MODE");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/modules/WalletImpl.sol\n', '\n', '// Copyright 2017 Loopring Technology Limited.\n', '\n', '\n', '\n', '/// @title WalletImpl\n', 'contract WalletImpl is BaseWallet {\n', '    function version()\n', '        public\n', '        override\n', '        pure\n', '        returns (string memory)\n', '    {\n', '        // 使用中国省会作为别名\n', '        return "1.2.0 (daqing)";\n', '    }\n', '}']
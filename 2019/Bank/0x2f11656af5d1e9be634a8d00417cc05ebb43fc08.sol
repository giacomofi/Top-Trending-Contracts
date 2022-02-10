['// File: contracts/lib/interface/IRouterRegistry.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '\n', '/**\n', ' * @title RouterRegistry interface for routing\n', ' */\n', 'interface IRouterRegistry {\n', '    enum RouterOperation { Add, Remove, Refresh }\n', '\n', '    function registerRouter() external;\n', '\n', '    function deregisterRouter() external;\n', '\n', '    function refreshRouter() external;\n', '\n', '    event RouterUpdated(RouterOperation indexed op, address indexed routerAddress);\n', '}\n', '\n', '// File: contracts/RouterRegistry.sol\n', '\n', 'pragma solidity ^0.5.5;\n', '\n', '\n', '/**\n', ' * @title Router Registry contract for external routers to join the Celer Network\n', ' * @notice Implementation of a global registry to enable external routers to join\n', ' */\n', 'contract RouterRegistry is IRouterRegistry {\n', '    // mapping to store the registered routers address as key \n', '    // and the lastest registered/refreshed block number as value\n', '    mapping(address => uint) public routerInfo;\n', '\n', '    /**\n', '     * @notice An external router could register to join the Celer Network\n', '     */\n', '    function registerRouter() external {\n', '        require(routerInfo[msg.sender] == 0, "Router address already exists");\n', '\n', '        routerInfo[msg.sender] = block.number;\n', '\n', '        emit RouterUpdated(RouterOperation.Add, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @notice An in-network router could deregister to leave the network\n', '     */\n', '    function deregisterRouter() external {\n', '        require(routerInfo[msg.sender] != 0, "Router address does not exist");\n', '\n', '        delete routerInfo[msg.sender];\n', '\n', '        emit RouterUpdated(RouterOperation.Remove, msg.sender);\n', '    }\n', '\n', '    /**\n', "     * @notice Refresh the existed router's block number\n", '     */\n', '    function refreshRouter() external {\n', '        require(routerInfo[msg.sender] != 0, "Router address does not exist");\n', '\n', '        routerInfo[msg.sender] = block.number;\n', '\n', '        emit RouterUpdated(RouterOperation.Refresh, msg.sender);\n', '    }\n', '}']
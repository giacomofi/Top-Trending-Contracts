['pragma solidity 0.4.25;\n', '\n', '/**\n', ' * Contract that will forward any incoming Ether to the address specified upon deployment\n', ' */\n', 'contract Forwarder {\n', '    /** Address to which any funds sent to this contract will be forwarded\n', '     *  Event logs to log movement of Ether\n', '    **/\n', '    address constant public destinationAddress = 0x609E7e5Db94b3F47a359955a4c823538A5891D48;\n', '    event LogForwarded(address indexed sender, uint amount);\n', '\n', '    /**\n', '     * Default function; Gets called when Ether is deposited, and forwards it to the destination address\n', '     */\n', '    function() payable public {\n', '        emit LogForwarded(msg.sender, msg.value);\n', '        destinationAddress.transfer(msg.value);\n', '    }\n', '}']
['pragma solidity 0.4.25;\n', '\n', '/**\n', ' * Contract that will forward any incoming Ether to the address specified upon deployment\n', ' */\n', 'contract Forwarder {\n', '    /** Address to which any funds sent to this contract will be forwarded\n', '     *  Event logs to log movement of Ether\n', '    **/\n', '    address constant public destinationAddress = 0x609E7e5Db94b3F47a359955a4c823538A5891D48;\n', '    event LogForwarded(address indexed sender, uint amount);\n', '\n', '    /**\n', '     * Default function; Gets called when Ether is deposited, and forwards it to the destination address\n', '     */\n', '    function() payable public {\n', '        emit LogForwarded(msg.sender, msg.value);\n', '        destinationAddress.transfer(msg.value);\n', '    }\n', '}']
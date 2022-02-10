['pragma solidity 0.4.11;\n', '\n', 'contract AssetInterface {\n', '    function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);\n', '    function _performApprove(address _spender, uint _value, address _sender) returns(bool);    \n', '    function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);\n', '    function _performGeneric(bytes, address) payable returns(bytes32){\n', '        revert();\n', '    }\n', '}\n', '\n', 'contract AssetProxy {\n', '    function _forwardApprove(address _spender, uint _value, address _sender) returns(bool);\n', '    function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);\n', '    function balanceOf(address _owner) constant returns(uint);\n', '}\n', '\n', '/**\n', ' * @title EToken2 Asset implementation contract.\n', ' *\n', ' * Basic asset implementation contract, without any additional logic.\n', ' * Every other asset implementation contracts should derive from this one.\n', ' * Receives calls from the proxy, and calls back immediatly without arguments modification.\n', ' *\n', ' * Note: all the non constant functions return false instead of throwing in case if state change\n', ' * didn&#39;t happen yet.\n', ' */\n', 'contract Asset is AssetInterface {\n', '    // Assigned asset proxy contract, immutable.\n', '    AssetProxy public proxy;\n', '\n', '    /**\n', '     * Only assigned proxy is allowed to call.\n', '     */\n', '    modifier onlyProxy() {\n', '        if (proxy == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Sets asset proxy address.\n', '     *\n', '     * Can be set only once.\n', '     *\n', '     * @param _proxy asset proxy contract address.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function init(AssetProxy _proxy) returns(bool) {\n', '        if (address(proxy) != 0x0) {\n', '            return false;\n', '        }\n', '        proxy = _proxy;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {\n', '        return _transferWithReference(_to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {\n', '        return proxy._forwardTransferFromWithReference(_sender, _to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {\n', '        return _transferToICAPWithReference(_icap, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {\n', '        return proxy._forwardTransferFromToICAPWithReference(_sender, _icap, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {\n', '        return _transferFromWithReference(_from, _to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {\n', '        return proxy._forwardTransferFromWithReference(_from, _to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {\n', '        return _transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {\n', '        return proxy._forwardTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function _performApprove(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {\n', '        return _approve(_spender, _value, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _approve(address _spender, uint _value, address _sender) internal returns(bool) {\n', '        return proxy._forwardApprove(_spender, _value, _sender);\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return bytes32 result.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function _performGeneric(bytes _data, address _sender) payable onlyProxy() returns(bytes32) {\n', '        return _generic(_data, _sender);\n', '    }\n', '\n', '    modifier onlyMe() {\n', '        if (this == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    // Most probably the following should never be redefined in child contracts.\n', '    address genericSender;\n', '    function _generic(bytes _data, address _sender) internal returns(bytes32) {\n', '        // Restrict reentrancy.\n', '        if (genericSender != 0x0) {\n', '            throw;\n', '        }\n', '        genericSender = _sender;\n', '        bytes32 result = _callReturn(this, _data, msg.value);\n', '        delete genericSender;\n', '        return result;\n', '    }\n', '\n', '    function _callReturn(address _target, bytes _data, uint _value) internal returns(bytes32 result) {\n', '        bool success;\n', '        assembly {\n', '            success := call(div(mul(gas, 63), 64), _target, _value, add(_data, 32), mload(_data), 0, 32)\n', '            result := mload(0)\n', '        }\n', '        if (!success) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.\n', '    function _sender() constant internal returns(address) {\n', '        return this == msg.sender ? genericSender : msg.sender;\n', '    }\n', '}']
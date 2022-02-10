['contract ChronoBankAssetInterface {\n', '    function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __approve(address _spender, uint _value, address _sender) returns(bool);\n', '    function __process(bytes _data, address _sender) payable {\n', '        throw;\n', '    }\n', '}\n', '\n', 'contract ChronoBankAssetProxy {\n', '    function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __approve(address _spender, uint _value, address _sender) returns(bool);    \n', '}\n', '\n', 'contract ChronoBankAsset is ChronoBankAssetInterface {\n', '    // Assigned asset proxy contract, immutable.\n', '    ChronoBankAssetProxy public proxy;\n', '\n', '    /**\n', '     * Only assigned proxy is allowed to call.\n', '     */\n', '    modifier onlyProxy() {\n', '        if (proxy == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Sets asset proxy address.\n', '     *\n', '     * Can be set only once.\n', '     *\n', '     * @param _proxy asset proxy contract address.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function init(ChronoBankAssetProxy _proxy) returns(bool) {\n', '        if (address(proxy) != 0x0) {\n', '            return false;\n', '        }\n', '        proxy = _proxy;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {\n', '        return _transferWithReference(_to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {\n', '        return proxy.__transferWithReference(_to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {\n', '        return _transferFromWithReference(_from, _to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {\n', '        return proxy.__transferFromWithReference(_from, _to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function __approve(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {\n', '        return _approve(_spender, _value, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _approve(address _spender, uint _value, address _sender) internal returns(bool) {\n', '        return proxy.__approve(_spender, _value, _sender);\n', '    }\n', '}']
['contract ChronoBankAssetInterface {\n', '    function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __approve(address _spender, uint _value, address _sender) returns(bool);\n', '    function __process(bytes _data, address _sender) payable {\n', '        throw;\n', '    }\n', '}\n', '\n', 'contract ChronoBankAssetProxy {\n', '    function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __approve(address _spender, uint _value, address _sender) returns(bool);    \n', '}\n', '\n', 'contract ChronoBankAsset is ChronoBankAssetInterface {\n', '    // Assigned asset proxy contract, immutable.\n', '    ChronoBankAssetProxy public proxy;\n', '\n', '    /**\n', '     * Only assigned proxy is allowed to call.\n', '     */\n', '    modifier onlyProxy() {\n', '        if (proxy == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Sets asset proxy address.\n', '     *\n', '     * Can be set only once.\n', '     *\n', '     * @param _proxy asset proxy contract address.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function init(ChronoBankAssetProxy _proxy) returns(bool) {\n', '        if (address(proxy) != 0x0) {\n', '            return false;\n', '        }\n', '        proxy = _proxy;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {\n', '        return _transferWithReference(_to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {\n', '        return proxy.__transferWithReference(_to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {\n', '        return _transferFromWithReference(_from, _to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {\n', '        return proxy.__transferFromWithReference(_from, _to, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Passes execution into virtual function.\n', '     *\n', '     * Can only be called by assigned asset proxy.\n', '     *\n', '     * @return success.\n', '     * @dev function is final, and must not be overridden.\n', '     */\n', '    function __approve(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {\n', '        return _approve(_spender, _value, _sender);\n', '    }\n', '\n', '    /**\n', '     * Calls back without modifications.\n', '     *\n', '     * @return success.\n', '     * @dev function is virtual, and meant to be overridden.\n', '     */\n', '    function _approve(address _spender, uint _value, address _sender) internal returns(bool) {\n', '        return proxy.__approve(_spender, _value, _sender);\n', '    }\n', '}']
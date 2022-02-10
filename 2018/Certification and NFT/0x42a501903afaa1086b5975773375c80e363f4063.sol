['pragma solidity 0.4.15;\n', '\n', 'contract RegistryICAPInterface {\n', '    function parse(bytes32 _icap) constant returns(address, bytes32, bool);\n', '    function institutions(bytes32 _institution) constant returns(address);\n', '}\n', '\n', 'contract EToken2Interface {\n', '    function registryICAP() constant returns(RegistryICAPInterface);\n', '    function baseUnit(bytes32 _symbol) constant returns(uint8);\n', '    function description(bytes32 _symbol) constant returns(string);\n', '    function owner(bytes32 _symbol) constant returns(address);\n', '    function isOwner(address _owner, bytes32 _symbol) constant returns(bool);\n', '    function totalSupply(bytes32 _symbol) constant returns(uint);\n', '    function balanceOf(address _holder, bytes32 _symbol) constant returns(uint);\n', '    function isLocked(bytes32 _symbol) constant returns(bool);\n', '    function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) returns(bool);\n', '    function reissueAsset(bytes32 _symbol, uint _value) returns(bool);\n', '    function revokeAsset(bytes32 _symbol, uint _value) returns(bool);\n', '    function setProxy(address _address, bytes32 _symbol) returns(bool);\n', '    function lockAsset(bytes32 _symbol) returns(bool);\n', '    function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);\n', '    function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(bool);\n', '    function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint);\n', '    function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(bool);\n', '}\n', '\n', 'contract AssetInterface {\n', '    function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);\n', '    function _performApprove(address _spender, uint _value, address _sender) returns(bool);    \n', '    function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);\n', '    function _performGeneric(bytes, address) payable {\n', '        revert();\n', '    }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed from, address indexed spender, uint256 value);\n', '\n', '    function totalSupply() constant returns(uint256 supply);\n', '    function balanceOf(address _owner) constant returns(uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns(bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns(bool success);\n', '    function approve(address _spender, uint256 _value) returns(bool success);\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining);\n', '\n', '    // function symbol() constant returns(string);\n', '    function decimals() constant returns(uint8);\n', '    // function name() constant returns(string);\n', '}\n', '\n', 'contract AssetProxyInterface {\n', '    function _forwardApprove(address _spender, uint _value, address _sender) returns(bool);\n', '    function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) returns(bool);\n', '    function balanceOf(address _owner) constant returns(uint);\n', '}\n', '\n', 'contract Bytes32 {\n', '    function _bytes32(string _input) internal constant returns(bytes32 result) {\n', '        assembly {\n', '            result := mload(add(_input, 32))\n', '        }\n', '    }\n', '}\n', '\n', 'contract ReturnData {\n', '    function _returnReturnData(bool _success) internal {\n', '        assembly {\n', '            let returndatastart := msize()\n', '            mstore(0x40, add(returndatastart, returndatasize))\n', '            returndatacopy(returndatastart, 0, returndatasize)\n', '            switch _success case 0 { revert(returndatastart, returndatasize) } default { return(returndatastart, returndatasize) }\n', '        }\n', '    }\n', '\n', '    function _assemblyCall(address _destination, uint _value, bytes _data) internal returns(bool success) {\n', '        assembly {\n', '            success := call(div(mul(gas, 63), 64), _destination, _value, add(_data, 32), mload(_data), 0, 0)\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title EToken2 Asset Proxy.\n', ' *\n', ' * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.\n', ' * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.\n', ' * Every request that is made by caller first sent to the specific asset implementation\n', ' * contract, which then calls back to be forwarded onto EToken2.\n', ' *\n', ' * Calls flow: Caller ->\n', ' *             Proxy.func(...) ->\n', ' *             Asset._performFunc(..., Caller.address) ->\n', ' *             Proxy._forwardFunc(..., Caller.address) ->\n', ' *             Platform.proxyFunc(..., symbol, Caller.address)\n', ' *\n', ' * Generic call flow: Caller ->\n', ' *             Proxy.unknownFunc(...) ->\n', ' *             Asset._performGeneric(..., Caller.address) ->\n', ' *             Asset.unknownFunc(...)\n', ' *\n', ' * Asset implementation contract is mutable, but each user have an option to stick with\n', " * old implementation, through explicit decision made in timely manner, if he doesn't agree\n", ' * with new rules.\n', ' * Each user have a possibility to upgrade to latest asset contract implementation, without the\n', ' * possibility to rollback.\n', ' *\n', ' * Note: all the non constant functions return false instead of throwing in case if state change\n', " * didn't happen yet.\n", ' */\n', 'contract CryptykTokens is ERC20Interface, AssetProxyInterface, Bytes32, ReturnData {\n', '    // Assigned EToken2, immutable.\n', '    EToken2Interface public etoken2;\n', '\n', '    // Assigned symbol, immutable.\n', '    bytes32 public etoken2Symbol;\n', '\n', '    // Assigned name, immutable. For UI.\n', '    string public name;\n', '    string public symbol;\n', '\n', '    /**\n', '     * Sets EToken2 address, assigns symbol and name.\n', '     *\n', '     * Can be set only once.\n', '     *\n', '     * @param _etoken2 EToken2 contract address.\n', '     * @param _symbol assigned symbol.\n', '     * @param _name assigned name.\n', '     *\n', '     * @return success.\n', '     */\n', '    function init(EToken2Interface _etoken2, string _symbol, string _name) returns(bool) {\n', '        if (address(etoken2) != 0x0) {\n', '            return false;\n', '        }\n', '        etoken2 = _etoken2;\n', '        etoken2Symbol = _bytes32(_symbol);\n', '        name = _name;\n', '        symbol = _symbol;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Only EToken2 is allowed to call.\n', '     */\n', '    modifier onlyEToken2() {\n', '        if (msg.sender == address(etoken2)) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Only current asset owner is allowed to call.\n', '     */\n', '    modifier onlyAssetOwner() {\n', '        if (etoken2.isOwner(msg.sender, etoken2Symbol)) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns asset implementation contract for current caller.\n', '     *\n', '     * @return asset implementation contract.\n', '     */\n', '    function _getAsset() internal returns(AssetInterface) {\n', '        return AssetInterface(getVersionFor(msg.sender));\n', '    }\n', '\n', '    function recoverTokens(uint _value) onlyAssetOwner() returns(bool) {\n', "        return this.transferWithReference(msg.sender, _value, 'Tokens recovery');\n", '    }\n', '\n', '    /**\n', '     * Returns asset total supply.\n', '     *\n', '     * @return asset total supply.\n', '     */\n', '    function totalSupply() constant returns(uint) {\n', '        return etoken2.totalSupply(etoken2Symbol);\n', '    }\n', '\n', '    /**\n', '     * Returns asset balance for a particular holder.\n', '     *\n', '     * @param _owner holder address.\n', '     *\n', '     * @return holder balance.\n', '     */\n', '    function balanceOf(address _owner) constant returns(uint) {\n', '        return etoken2.balanceOf(_owner, etoken2Symbol);\n', '    }\n', '\n', '    /**\n', '     * Returns asset allowance from one holder to another.\n', '     *\n', '     * @param _from holder that allowed spending.\n', '     * @param _spender holder that is allowed to spend.\n', '     *\n', '     * @return holder to spender allowance.\n', '     */\n', '    function allowance(address _from, address _spender) constant returns(uint) {\n', '        return etoken2.allowance(_from, _spender, etoken2Symbol);\n', '    }\n', '\n', '    /**\n', '     * Returns asset decimals.\n', '     *\n', '     * @return asset decimals.\n', '     */\n', '    function decimals() constant returns(uint8) {\n', '        return etoken2.baseUnit(etoken2Symbol);\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified receiver.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transfer(address _to, uint _value) returns(bool) {\n', "        return transferWithReference(_to, _value, '');\n", '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified receiver adding specified comment.\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     *\n', '     * @return success.\n', '     */\n', '    function transferWithReference(address _to, uint _value, string _reference) returns(bool) {\n', '        return _getAsset()._performTransferWithReference(_to, _value, _reference, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified ICAP.\n', '     *\n', '     * @param _icap recipient ICAP to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transferToICAP(bytes32 _icap, uint _value) returns(bool) {\n', "        return transferToICAPWithReference(_icap, _value, '');\n", '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified ICAP adding specified comment.\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @param _icap recipient ICAP to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     *\n', '     * @return success.\n', '     */\n', '    function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {\n', '        return _getAsset()._performTransferToICAPWithReference(_icap, _value, _reference, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) returns(bool) {\n', "        return transferFromWithReference(_from, _to, _value, '');\n", '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders adding specified comment.\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     *\n', '     * @return success.\n', '     */\n', '    function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {\n', '        return _getAsset()._performTransferFromWithReference(_from, _to, _value, _reference, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Performs transfer call on the EToken2 by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {\n', '        return etoken2.proxyTransferFromWithReference(_from, _to, _value, etoken2Symbol, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _icap recipient ICAP address to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {\n', "        return transferFromToICAPWithReference(_from, _icap, _value, '');\n", '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders adding specified comment.\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _icap recipient ICAP address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     *\n', '     * @return success.\n', '     */\n', '    function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {\n', '        return _getAsset()._performTransferFromToICAPWithReference(_from, _icap, _value, _reference, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _icap recipient ICAP address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) onlyImplementationFor(_sender) returns(bool) {\n', '        return etoken2.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);\n', '    }\n', '\n', '    /**\n', '     * Sets asset spending allowance for a specified spender.\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @param _spender holder address to set allowance to.\n', '     * @param _value amount to allow.\n', '     *\n', '     * @return success.\n', '     */\n', '    function approve(address _spender, uint _value) returns(bool) {\n', '        return _getAsset()._performApprove(_spender, _value, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Performs allowance setting call on the EToken2 by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _spender holder address to set allowance to.\n', '     * @param _value amount to allow.\n', '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function _forwardApprove(address _spender, uint _value, address _sender) onlyImplementationFor(_sender) returns(bool) {\n', '        return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);\n', '    }\n', '\n', '    /**\n', '     * Emits ERC20 Transfer event on this contract.\n', '     *\n', '     * Can only be, and, called by assigned EToken2 when asset transfer happens.\n', '     */\n', '    function emitTransfer(address _from, address _to, uint _value) onlyEToken2() {\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Emits ERC20 Approval event on this contract.\n', '     *\n', '     * Can only be, and, called by assigned EToken2 when asset allowance set happens.\n', '     */\n', '    function emitApprove(address _from, address _spender, uint _value) onlyEToken2() {\n', '        Approval(_from, _spender, _value);\n', '    }\n', '\n', '    /**\n', '     * Resolves asset implementation contract for the caller and forwards there transaction data,\n', '     * along with the value. This allows for proxy interface growth.\n', '     */\n', '    function () payable {\n', '        _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);\n', '        _returnReturnData(true);\n', '    }\n', '\n', '    // Interface functions to allow specifying ICAP addresses as strings.\n', '    function transferToICAP(string _icap, uint _value) returns(bool) {\n', "        return transferToICAPWithReference(_icap, _value, '');\n", '    }\n', '\n', '    function transferToICAPWithReference(string _icap, uint _value, string _reference) returns(bool) {\n', '        return transferToICAPWithReference(_bytes32(_icap), _value, _reference);\n', '    }\n', '\n', '    function transferFromToICAP(address _from, string _icap, uint _value) returns(bool) {\n', "        return transferFromToICAPWithReference(_from, _icap, _value, '');\n", '    }\n', '\n', '    function transferFromToICAPWithReference(address _from, string _icap, uint _value, string _reference) returns(bool) {\n', '        return transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference);\n', '    }\n', '\n', '    /**\n', '     * Indicates an upgrade freeze-time start, and the next asset implementation contract.\n', '     */\n', '    event UpgradeProposed(address newVersion);\n', '    event UpgradePurged(address newVersion);\n', '    event UpgradeCommited(address newVersion);\n', '    event OptedOut(address sender, address version);\n', '    event OptedIn(address sender, address version);\n', '\n', '    // Current asset implementation contract address.\n', '    address latestVersion;\n', '\n', '    // Proposed next asset implementation contract address.\n', '    address pendingVersion;\n', '\n', '    // Upgrade freeze-time start.\n', '    uint pendingVersionTimestamp;\n', '\n', '    // Timespan for users to review the new implementation and make decision.\n', '    uint constant UPGRADE_FREEZE_TIME = 3 days;\n', '\n', '    // Asset implementation contract address that user decided to stick with.\n', '    // 0x0 means that user uses latest version.\n', '    mapping(address => address) userOptOutVersion;\n', '\n', '    /**\n', '     * Only asset implementation contract assigned to sender is allowed to call.\n', '     */\n', '    modifier onlyImplementationFor(address _sender) {\n', '        if (getVersionFor(_sender) == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns asset implementation contract address assigned to sender.\n', '     *\n', '     * @param _sender sender address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getVersionFor(address _sender) constant returns(address) {\n', '        return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];\n', '    }\n', '\n', '    /**\n', '     * Returns current asset implementation contract address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getLatestVersion() constant returns(address) {\n', '        return latestVersion;\n', '    }\n', '\n', '    /**\n', '     * Returns proposed next asset implementation contract address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getPendingVersion() constant returns(address) {\n', '        return pendingVersion;\n', '    }\n', '\n', '    /**\n', '     * Returns upgrade freeze-time start.\n', '     *\n', '     * @return freeze-time start.\n', '     */\n', '    function getPendingVersionTimestamp() constant returns(uint) {\n', '        return pendingVersionTimestamp;\n', '    }\n', '\n', '    /**\n', '     * Propose next asset implementation contract address.\n', '     *\n', '     * Can only be called by current asset owner.\n', '     *\n', '     * Note: freeze-time should not be applied for the initial setup.\n', '     *\n', '     * @param _newVersion asset implementation contract address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {\n', '        // Should not already be in the upgrading process.\n', '        if (pendingVersion != 0x0) {\n', '            return false;\n', '        }\n', '        // New version address should be other than 0x0.\n', '        if (_newVersion == 0x0) {\n', '            return false;\n', '        }\n', "        // Don't apply freeze-time for the initial setup.\n", '        if (latestVersion == 0x0) {\n', '            latestVersion = _newVersion;\n', '            return true;\n', '        }\n', '        pendingVersion = _newVersion;\n', '        pendingVersionTimestamp = now;\n', '        UpgradeProposed(_newVersion);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Cancel the pending upgrade process.\n', '     *\n', '     * Can only be called by current asset owner.\n', '     *\n', '     * @return success.\n', '     */\n', '    function purgeUpgrade() onlyAssetOwner() returns(bool) {\n', '        if (pendingVersion == 0x0) {\n', '            return false;\n', '        }\n', '        UpgradePurged(pendingVersion);\n', '        delete pendingVersion;\n', '        delete pendingVersionTimestamp;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Finalize an upgrade process setting new asset implementation contract address.\n', '     *\n', '     * Can only be called after an upgrade freeze-time.\n', '     *\n', '     * @return success.\n', '     */\n', '    function commitUpgrade() returns(bool) {\n', '        if (pendingVersion == 0x0) {\n', '            return false;\n', '        }\n', '        if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {\n', '            return false;\n', '        }\n', '        latestVersion = pendingVersion;\n', '        delete pendingVersion;\n', '        delete pendingVersionTimestamp;\n', '        UpgradeCommited(latestVersion);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Disagree with proposed upgrade, and stick with current asset implementation\n', '     * until further explicit agreement to upgrade.\n', '     *\n', '     * @return success.\n', '     */\n', '    function optOut() returns(bool) {\n', '        if (userOptOutVersion[msg.sender] != 0x0) {\n', '            return false;\n', '        }\n', '        userOptOutVersion[msg.sender] = latestVersion;\n', '        OptedOut(msg.sender, latestVersion);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Implicitly agree to upgrade to current and future asset implementation upgrades,\n', '     * until further explicit disagreement.\n', '     *\n', '     * @return success.\n', '     */\n', '    function optIn() returns(bool) {\n', '        delete userOptOutVersion[msg.sender];\n', '        OptedIn(msg.sender, latestVersion);\n', '        return true;\n', '    }\n', '\n', '    // Backwards compatibility.\n', '    function multiAsset() constant returns(EToken2Interface) {\n', '        return etoken2;\n', '    }\n', '}']
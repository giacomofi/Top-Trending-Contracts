['pragma solidity ^0.4.11;\n', '\n', '// File: contracts/CAVAssetInterface.sol\n', '\n', 'contract CAVAsset {\n', '    function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __approve(address _spender, uint _value, address _sender) returns(bool);\n', '    function __process(bytes _data, address _sender) payable {\n', '        revert();\n', '    }\n', '}\n', '\n', '// File: contracts/CAVPlatformInterface.sol\n', '\n', 'contract CAVPlatform {\n', '    mapping(bytes32 => address) public proxies;\n', '    function symbols(uint _idx) public constant returns (bytes32);\n', '    function symbolsCount() public constant returns (uint);\n', '\n', '    function name(bytes32 _symbol) returns(string);\n', '    function setProxy(address _address, bytes32 _symbol) returns(uint errorCode);\n', '    function isCreated(bytes32 _symbol) constant returns(bool);\n', '    function isOwner(address _owner, bytes32 _symbol) returns(bool);\n', '    function owner(bytes32 _symbol) constant returns(address);\n', '    function totalSupply(bytes32 _symbol) returns(uint);\n', '    function balanceOf(address _holder, bytes32 _symbol) returns(uint);\n', '    function allowance(address _from, address _spender, bytes32 _symbol) returns(uint);\n', '    function baseUnit(bytes32 _symbol) returns(uint8);\n', '    function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);\n', '    function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);\n', '    function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(uint errorCode);\n', '    function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) returns(uint errorCode);\n', '    function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) returns(uint errorCode);\n', '    function reissueAsset(bytes32 _symbol, uint _value) returns(uint errorCode);\n', '    function revokeAsset(bytes32 _symbol, uint _value) returns(uint errorCode);\n', '    function isReissuable(bytes32 _symbol) returns(bool);\n', '    function changeOwnership(bytes32 _symbol, address _newOwner) returns(uint errorCode);\n', '    function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool);\n', '}\n', '\n', '// File: contracts/ERC20Interface.sol\n', '\n', 'contract ERC20Interface {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed from, address indexed spender, uint256 value);\n', '    string public symbol;\n', '\n', '    function decimals() constant returns (uint8);\n', '    function totalSupply() constant returns (uint256 supply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '}\n', '\n', '// File: contracts/CAVAssetProxy.sol\n', '\n', '/**\n', ' * @title CAV Asset Proxy.\n', ' *\n', ' * Proxy implements ERC20 interface and acts as a gateway to a single platform asset.\n', ' * Proxy adds symbol and caller(sender) when forwarding requests to platform.\n', ' * Every request that is made by caller first sent to the specific asset implementation\n', ' * contract, which then calls back to be forwarded onto platform.\n', ' *\n', ' * Calls flow: Caller ->\n', ' *             Proxy.func(...) ->\n', ' *             Asset.__func(..., Caller.address) ->\n', ' *             Proxy.__func(..., Caller.address) ->\n', ' *             Platform.proxyFunc(..., symbol, Caller.address)\n', ' *\n', ' * Asset implementation contract is mutable, but each user have an option to stick with\n', ' * old implementation, through explicit decision made in timely manner, if he doesn&#39;t agree\n', ' * with new rules.\n', ' * Each user have a possibility to upgrade to latest asset contract implementation, without the\n', ' * possibility to rollback.\n', ' *\n', ' * Note: all the non constant functions return false instead of throwing in case if state change\n', ' * didn&#39;t happen yet.\n', ' */\n', 'contract CAVAssetProxy is ERC20Interface {\n', '\n', '    // Supports CAVPlatform ability to return error codes from methods\n', '    uint constant OK = 1;\n', '\n', '    // Assigned platform, immutable.\n', '    CAVPlatform public platform;\n', '\n', '    // Assigned symbol, immutable.\n', '    bytes32 public smbl;\n', '\n', '    // Assigned name, immutable.\n', '    string public name;\n', '\n', '    string public symbol;\n', '\n', '    /**\n', '     * Sets platform address, assigns symbol and name.\n', '     *\n', '     * Can be set only once.\n', '     *\n', '     * @param _platform platform contract address.\n', '     * @param _symbol assigned symbol.\n', '     * @param _name assigned name.\n', '     *\n', '     * @return success.\n', '     */\n', '    function init(CAVPlatform _platform, string _symbol, string _name) returns(bool) {\n', '        if (address(platform) != 0x0) {\n', '            return false;\n', '        }\n', '        platform = _platform;\n', '        symbol = _symbol;\n', '        smbl = stringToBytes32(_symbol);\n', '        name = _name;\n', '        return true;\n', '    }\n', '\n', '    function stringToBytes32(string memory source) returns (bytes32 result) {\n', '        assembly {\n', '           result := mload(add(source, 32))\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Only platform is allowed to call.\n', '     */\n', '    modifier onlyPlatform() {\n', '        if (msg.sender == address(platform)) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Only current asset owner is allowed to call.\n', '     */\n', '    modifier onlyAssetOwner() {\n', '        if (platform.isOwner(msg.sender, smbl)) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns asset implementation contract for current caller.\n', '     *\n', '     * @return asset implementation contract.\n', '     */\n', '    function _getAsset() internal returns(CAVAsset) {\n', '        return CAVAsset(getVersionFor(msg.sender));\n', '    }\n', '\n', '    /**\n', '     * Returns asset total supply.\n', '     *\n', '     * @return asset total supply.\n', '     */\n', '    function totalSupply() constant returns(uint) {\n', '        return platform.totalSupply(smbl);\n', '    }\n', '\n', '    /**\n', '     * Returns asset balance for a particular holder.\n', '     *\n', '     * @param _owner holder address.\n', '     *\n', '     * @return holder balance.\n', '     */\n', '    function balanceOf(address _owner) constant returns(uint) {\n', '        return platform.balanceOf(_owner, smbl);\n', '    }\n', '\n', '    /**\n', '     * Returns asset allowance from one holder to another.\n', '     *\n', '     * @param _from holder that allowed spending.\n', '     * @param _spender holder that is allowed to spend.\n', '     *\n', '     * @return holder to spender allowance.\n', '     */\n', '    function allowance(address _from, address _spender) constant returns(uint) {\n', '        return platform.allowance(_from, _spender, smbl);\n', '    }\n', '\n', '    /**\n', '     * Returns asset decimals.\n', '     *\n', '     * @return asset decimals.\n', '     */\n', '    function decimals() constant returns(uint8) {\n', '        return platform.baseUnit(smbl);\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified receiver.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transfer(address _to, uint _value) returns(bool) {\n', '        if (_to != 0x0) {\n', '          return _transferWithReference(_to, _value, "");\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified receiver adding specified comment.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     * @param _reference transfer comment to be included in a platform&#39;s Transfer event.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transferWithReference(address _to, uint _value, string _reference) returns(bool) {\n', '        if (_to != 0x0) {\n', '            return _transferWithReference(_to, _value, _reference);\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool) {\n', '        return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Performs transfer call on the platform by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     * @param _reference transfer comment to be included in a platform&#39;s Transfer event.\n', '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {\n', '        return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;\n', '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) returns(bool) {\n', '        if (_to != 0x0) {\n', '            return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);\n', '         }\n', '         else {\n', '             return false;\n', '         }\n', '    }\n', '\n', '    /**\n', '     * Performs allowance transfer call on the platform by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     * @param _reference transfer comment to be included in a platform&#39;s Transfer event.\n', '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {\n', '        return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;\n', '    }\n', '\n', '    /**\n', '     * Sets asset spending allowance for a specified spender.\n', '     *\n', '     * @param _spender holder address to set allowance to.\n', '     * @param _value amount to allow.\n', '     *\n', '     * @return success.\n', '     */\n', '    function approve(address _spender, uint _value) returns(bool) {\n', '        if (_spender != 0x0) {\n', '             return _getAsset().__approve(_spender, _value, msg.sender);\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Performs allowance setting call on the platform by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _spender holder address to set allowance to.\n', '     * @param _value amount to allow.\n', '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function __approve(address _spender, uint _value, address _sender) onlyAccess(_sender) returns(bool) {\n', '        return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;\n', '    }\n', '\n', '    /**\n', '     * Emits ERC20 Transfer event on this contract.\n', '     *\n', '     * Can only be, and, called by assigned platform when asset transfer happens.\n', '     */\n', '    function emitTransfer(address _from, address _to, uint _value) onlyPlatform() {\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Emits ERC20 Approval event on this contract.\n', '     *\n', '     * Can only be, and, called by assigned platform when asset allowance set happens.\n', '     */\n', '    function emitApprove(address _from, address _spender, uint _value) onlyPlatform() {\n', '        Approval(_from, _spender, _value);\n', '    }\n', '\n', '    /**\n', '     * Resolves asset implementation contract for the caller and forwards there transaction data,\n', '     * along with the value. This allows for proxy interface growth.\n', '     */\n', '    function () payable {\n', '        _getAsset().__process.value(msg.value)(msg.data, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Indicates an upgrade freeze-time start, and the next asset implementation contract.\n', '     */\n', '    event UpgradeProposal(address newVersion);\n', '\n', '    // Current asset implementation contract address.\n', '    address latestVersion;\n', '\n', '    // Proposed next asset implementation contract address.\n', '    address pendingVersion;\n', '\n', '    // Upgrade freeze-time start.\n', '    uint pendingVersionTimestamp;\n', '\n', '    // Timespan for users to review the new implementation and make decision.\n', '    uint constant UPGRADE_FREEZE_TIME = 3 days;\n', '\n', '    // Asset implementation contract address that user decided to stick with.\n', '    // 0x0 means that user uses latest version.\n', '    mapping(address => address) userOptOutVersion;\n', '\n', '    /**\n', '     * Only asset implementation contract assigned to sender is allowed to call.\n', '     */\n', '    modifier onlyAccess(address _sender) {\n', '        if (getVersionFor(_sender) == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns asset implementation contract address assigned to sender.\n', '     *\n', '     * @param _sender sender address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getVersionFor(address _sender) constant returns(address) {\n', '        return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];\n', '    }\n', '\n', '    /**\n', '     * Returns current asset implementation contract address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getLatestVersion() constant returns(address) {\n', '        return latestVersion;\n', '    }\n', '\n', '    /**\n', '     * Returns proposed next asset implementation contract address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getPendingVersion() constant returns(address) {\n', '        return pendingVersion;\n', '    }\n', '\n', '    /**\n', '     * Returns upgrade freeze-time start.\n', '     *\n', '     * @return freeze-time start.\n', '     */\n', '    function getPendingVersionTimestamp() constant returns(uint) {\n', '        return pendingVersionTimestamp;\n', '    }\n', '\n', '    /**\n', '     * Propose next asset implementation contract address.\n', '     *\n', '     * Can only be called by current asset owner.\n', '     *\n', '     * Note: freeze-time should not be applied for the initial setup.\n', '     *\n', '     * @param _newVersion asset implementation contract address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {\n', '        // Should not already be in the upgrading process.\n', '        if (pendingVersion != 0x0) {\n', '            return false;\n', '        }\n', '        // New version address should be other than 0x0.\n', '        if (_newVersion == 0x0) {\n', '            return false;\n', '        }\n', '        // Don&#39;t apply freeze-time for the initial setup.\n', '        if (latestVersion == 0x0) {\n', '            latestVersion = _newVersion;\n', '            return true;\n', '        }\n', '        pendingVersion = _newVersion;\n', '        pendingVersionTimestamp = now;\n', '        UpgradeProposal(_newVersion);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Cancel the pending upgrade process.\n', '     *\n', '     * Can only be called by current asset owner.\n', '     *\n', '     * @return success.\n', '     */\n', '    function purgeUpgrade() onlyAssetOwner() returns(bool) {\n', '        if (pendingVersion == 0x0) {\n', '            return false;\n', '        }\n', '        delete pendingVersion;\n', '        delete pendingVersionTimestamp;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Finalize an upgrade process setting new asset implementation contract address.\n', '     *\n', '     * Can only be called after an upgrade freeze-time.\n', '     *\n', '     * @return success.\n', '     */\n', '    function commitUpgrade() returns(bool) {\n', '        if (pendingVersion == 0x0) {\n', '            return false;\n', '        }\n', '        if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {\n', '            return false;\n', '        }\n', '        latestVersion = pendingVersion;\n', '        delete pendingVersion;\n', '        delete pendingVersionTimestamp;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Disagree with proposed upgrade, and stick with current asset implementation\n', '     * until further explicit agreement to upgrade.\n', '     *\n', '     * @return success.\n', '     */\n', '    function optOut() returns(bool) {\n', '        if (userOptOutVersion[msg.sender] != 0x0) {\n', '            return false;\n', '        }\n', '        userOptOutVersion[msg.sender] = latestVersion;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Implicitly agree to upgrade to current and future asset implementation upgrades,\n', '     * until further explicit disagreement.\n', '     *\n', '     * @return success.\n', '     */\n', '    function optIn() returns(bool) {\n', '        delete userOptOutVersion[msg.sender];\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '// File: contracts/CAVAssetInterface.sol\n', '\n', 'contract CAVAsset {\n', '    function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);\n', '    function __approve(address _spender, uint _value, address _sender) returns(bool);\n', '    function __process(bytes _data, address _sender) payable {\n', '        revert();\n', '    }\n', '}\n', '\n', '// File: contracts/CAVPlatformInterface.sol\n', '\n', 'contract CAVPlatform {\n', '    mapping(bytes32 => address) public proxies;\n', '    function symbols(uint _idx) public constant returns (bytes32);\n', '    function symbolsCount() public constant returns (uint);\n', '\n', '    function name(bytes32 _symbol) returns(string);\n', '    function setProxy(address _address, bytes32 _symbol) returns(uint errorCode);\n', '    function isCreated(bytes32 _symbol) constant returns(bool);\n', '    function isOwner(address _owner, bytes32 _symbol) returns(bool);\n', '    function owner(bytes32 _symbol) constant returns(address);\n', '    function totalSupply(bytes32 _symbol) returns(uint);\n', '    function balanceOf(address _holder, bytes32 _symbol) returns(uint);\n', '    function allowance(address _from, address _spender, bytes32 _symbol) returns(uint);\n', '    function baseUnit(bytes32 _symbol) returns(uint8);\n', '    function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);\n', '    function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) returns(uint errorCode);\n', '    function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) returns(uint errorCode);\n', '    function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) returns(uint errorCode);\n', '    function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable, address _account) returns(uint errorCode);\n', '    function reissueAsset(bytes32 _symbol, uint _value) returns(uint errorCode);\n', '    function revokeAsset(bytes32 _symbol, uint _value) returns(uint errorCode);\n', '    function isReissuable(bytes32 _symbol) returns(bool);\n', '    function changeOwnership(bytes32 _symbol, address _newOwner) returns(uint errorCode);\n', '    function hasAssetRights(address _owner, bytes32 _symbol) public view returns (bool);\n', '}\n', '\n', '// File: contracts/ERC20Interface.sol\n', '\n', 'contract ERC20Interface {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed from, address indexed spender, uint256 value);\n', '    string public symbol;\n', '\n', '    function decimals() constant returns (uint8);\n', '    function totalSupply() constant returns (uint256 supply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '}\n', '\n', '// File: contracts/CAVAssetProxy.sol\n', '\n', '/**\n', ' * @title CAV Asset Proxy.\n', ' *\n', ' * Proxy implements ERC20 interface and acts as a gateway to a single platform asset.\n', ' * Proxy adds symbol and caller(sender) when forwarding requests to platform.\n', ' * Every request that is made by caller first sent to the specific asset implementation\n', ' * contract, which then calls back to be forwarded onto platform.\n', ' *\n', ' * Calls flow: Caller ->\n', ' *             Proxy.func(...) ->\n', ' *             Asset.__func(..., Caller.address) ->\n', ' *             Proxy.__func(..., Caller.address) ->\n', ' *             Platform.proxyFunc(..., symbol, Caller.address)\n', ' *\n', ' * Asset implementation contract is mutable, but each user have an option to stick with\n', " * old implementation, through explicit decision made in timely manner, if he doesn't agree\n", ' * with new rules.\n', ' * Each user have a possibility to upgrade to latest asset contract implementation, without the\n', ' * possibility to rollback.\n', ' *\n', ' * Note: all the non constant functions return false instead of throwing in case if state change\n', " * didn't happen yet.\n", ' */\n', 'contract CAVAssetProxy is ERC20Interface {\n', '\n', '    // Supports CAVPlatform ability to return error codes from methods\n', '    uint constant OK = 1;\n', '\n', '    // Assigned platform, immutable.\n', '    CAVPlatform public platform;\n', '\n', '    // Assigned symbol, immutable.\n', '    bytes32 public smbl;\n', '\n', '    // Assigned name, immutable.\n', '    string public name;\n', '\n', '    string public symbol;\n', '\n', '    /**\n', '     * Sets platform address, assigns symbol and name.\n', '     *\n', '     * Can be set only once.\n', '     *\n', '     * @param _platform platform contract address.\n', '     * @param _symbol assigned symbol.\n', '     * @param _name assigned name.\n', '     *\n', '     * @return success.\n', '     */\n', '    function init(CAVPlatform _platform, string _symbol, string _name) returns(bool) {\n', '        if (address(platform) != 0x0) {\n', '            return false;\n', '        }\n', '        platform = _platform;\n', '        symbol = _symbol;\n', '        smbl = stringToBytes32(_symbol);\n', '        name = _name;\n', '        return true;\n', '    }\n', '\n', '    function stringToBytes32(string memory source) returns (bytes32 result) {\n', '        assembly {\n', '           result := mload(add(source, 32))\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Only platform is allowed to call.\n', '     */\n', '    modifier onlyPlatform() {\n', '        if (msg.sender == address(platform)) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Only current asset owner is allowed to call.\n', '     */\n', '    modifier onlyAssetOwner() {\n', '        if (platform.isOwner(msg.sender, smbl)) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns asset implementation contract for current caller.\n', '     *\n', '     * @return asset implementation contract.\n', '     */\n', '    function _getAsset() internal returns(CAVAsset) {\n', '        return CAVAsset(getVersionFor(msg.sender));\n', '    }\n', '\n', '    /**\n', '     * Returns asset total supply.\n', '     *\n', '     * @return asset total supply.\n', '     */\n', '    function totalSupply() constant returns(uint) {\n', '        return platform.totalSupply(smbl);\n', '    }\n', '\n', '    /**\n', '     * Returns asset balance for a particular holder.\n', '     *\n', '     * @param _owner holder address.\n', '     *\n', '     * @return holder balance.\n', '     */\n', '    function balanceOf(address _owner) constant returns(uint) {\n', '        return platform.balanceOf(_owner, smbl);\n', '    }\n', '\n', '    /**\n', '     * Returns asset allowance from one holder to another.\n', '     *\n', '     * @param _from holder that allowed spending.\n', '     * @param _spender holder that is allowed to spend.\n', '     *\n', '     * @return holder to spender allowance.\n', '     */\n', '    function allowance(address _from, address _spender) constant returns(uint) {\n', '        return platform.allowance(_from, _spender, smbl);\n', '    }\n', '\n', '    /**\n', '     * Returns asset decimals.\n', '     *\n', '     * @return asset decimals.\n', '     */\n', '    function decimals() constant returns(uint8) {\n', '        return platform.baseUnit(smbl);\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified receiver.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transfer(address _to, uint _value) returns(bool) {\n', '        if (_to != 0x0) {\n', '          return _transferWithReference(_to, _value, "");\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified receiver adding specified comment.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a platform's Transfer event.\n", '     *\n', '     * @return success.\n', '     */\n', '    function transferWithReference(address _to, uint _value, string _reference) returns(bool) {\n', '        if (_to != 0x0) {\n', '            return _transferWithReference(_to, _value, _reference);\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool) {\n', '        return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Performs transfer call on the platform by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a platform's Transfer event.\n", '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {\n', '        return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;\n', '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) returns(bool) {\n', '        if (_to != 0x0) {\n', '            return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);\n', '         }\n', '         else {\n', '             return false;\n', '         }\n', '    }\n', '\n', '    /**\n', '     * Performs allowance transfer call on the platform by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a platform's Transfer event.\n", '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyAccess(_sender) returns(bool) {\n', '        return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;\n', '    }\n', '\n', '    /**\n', '     * Sets asset spending allowance for a specified spender.\n', '     *\n', '     * @param _spender holder address to set allowance to.\n', '     * @param _value amount to allow.\n', '     *\n', '     * @return success.\n', '     */\n', '    function approve(address _spender, uint _value) returns(bool) {\n', '        if (_spender != 0x0) {\n', '             return _getAsset().__approve(_spender, _value, msg.sender);\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Performs allowance setting call on the platform by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _spender holder address to set allowance to.\n', '     * @param _value amount to allow.\n', '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function __approve(address _spender, uint _value, address _sender) onlyAccess(_sender) returns(bool) {\n', '        return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;\n', '    }\n', '\n', '    /**\n', '     * Emits ERC20 Transfer event on this contract.\n', '     *\n', '     * Can only be, and, called by assigned platform when asset transfer happens.\n', '     */\n', '    function emitTransfer(address _from, address _to, uint _value) onlyPlatform() {\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Emits ERC20 Approval event on this contract.\n', '     *\n', '     * Can only be, and, called by assigned platform when asset allowance set happens.\n', '     */\n', '    function emitApprove(address _from, address _spender, uint _value) onlyPlatform() {\n', '        Approval(_from, _spender, _value);\n', '    }\n', '\n', '    /**\n', '     * Resolves asset implementation contract for the caller and forwards there transaction data,\n', '     * along with the value. This allows for proxy interface growth.\n', '     */\n', '    function () payable {\n', '        _getAsset().__process.value(msg.value)(msg.data, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Indicates an upgrade freeze-time start, and the next asset implementation contract.\n', '     */\n', '    event UpgradeProposal(address newVersion);\n', '\n', '    // Current asset implementation contract address.\n', '    address latestVersion;\n', '\n', '    // Proposed next asset implementation contract address.\n', '    address pendingVersion;\n', '\n', '    // Upgrade freeze-time start.\n', '    uint pendingVersionTimestamp;\n', '\n', '    // Timespan for users to review the new implementation and make decision.\n', '    uint constant UPGRADE_FREEZE_TIME = 3 days;\n', '\n', '    // Asset implementation contract address that user decided to stick with.\n', '    // 0x0 means that user uses latest version.\n', '    mapping(address => address) userOptOutVersion;\n', '\n', '    /**\n', '     * Only asset implementation contract assigned to sender is allowed to call.\n', '     */\n', '    modifier onlyAccess(address _sender) {\n', '        if (getVersionFor(_sender) == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns asset implementation contract address assigned to sender.\n', '     *\n', '     * @param _sender sender address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getVersionFor(address _sender) constant returns(address) {\n', '        return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];\n', '    }\n', '\n', '    /**\n', '     * Returns current asset implementation contract address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getLatestVersion() constant returns(address) {\n', '        return latestVersion;\n', '    }\n', '\n', '    /**\n', '     * Returns proposed next asset implementation contract address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getPendingVersion() constant returns(address) {\n', '        return pendingVersion;\n', '    }\n', '\n', '    /**\n', '     * Returns upgrade freeze-time start.\n', '     *\n', '     * @return freeze-time start.\n', '     */\n', '    function getPendingVersionTimestamp() constant returns(uint) {\n', '        return pendingVersionTimestamp;\n', '    }\n', '\n', '    /**\n', '     * Propose next asset implementation contract address.\n', '     *\n', '     * Can only be called by current asset owner.\n', '     *\n', '     * Note: freeze-time should not be applied for the initial setup.\n', '     *\n', '     * @param _newVersion asset implementation contract address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function proposeUpgrade(address _newVersion) onlyAssetOwner() returns(bool) {\n', '        // Should not already be in the upgrading process.\n', '        if (pendingVersion != 0x0) {\n', '            return false;\n', '        }\n', '        // New version address should be other than 0x0.\n', '        if (_newVersion == 0x0) {\n', '            return false;\n', '        }\n', "        // Don't apply freeze-time for the initial setup.\n", '        if (latestVersion == 0x0) {\n', '            latestVersion = _newVersion;\n', '            return true;\n', '        }\n', '        pendingVersion = _newVersion;\n', '        pendingVersionTimestamp = now;\n', '        UpgradeProposal(_newVersion);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Cancel the pending upgrade process.\n', '     *\n', '     * Can only be called by current asset owner.\n', '     *\n', '     * @return success.\n', '     */\n', '    function purgeUpgrade() onlyAssetOwner() returns(bool) {\n', '        if (pendingVersion == 0x0) {\n', '            return false;\n', '        }\n', '        delete pendingVersion;\n', '        delete pendingVersionTimestamp;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Finalize an upgrade process setting new asset implementation contract address.\n', '     *\n', '     * Can only be called after an upgrade freeze-time.\n', '     *\n', '     * @return success.\n', '     */\n', '    function commitUpgrade() returns(bool) {\n', '        if (pendingVersion == 0x0) {\n', '            return false;\n', '        }\n', '        if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {\n', '            return false;\n', '        }\n', '        latestVersion = pendingVersion;\n', '        delete pendingVersion;\n', '        delete pendingVersionTimestamp;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Disagree with proposed upgrade, and stick with current asset implementation\n', '     * until further explicit agreement to upgrade.\n', '     *\n', '     * @return success.\n', '     */\n', '    function optOut() returns(bool) {\n', '        if (userOptOutVersion[msg.sender] != 0x0) {\n', '            return false;\n', '        }\n', '        userOptOutVersion[msg.sender] = latestVersion;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Implicitly agree to upgrade to current and future asset implementation upgrades,\n', '     * until further explicit disagreement.\n', '     *\n', '     * @return success.\n', '     */\n', '    function optIn() returns(bool) {\n', '        delete userOptOutVersion[msg.sender];\n', '        return true;\n', '    }\n', '}']

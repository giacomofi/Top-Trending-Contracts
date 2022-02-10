['\n', '// File: contracts/EToken2Interface.sol\n', '\n', 'pragma solidity 0.4.23;\n', '\n', '\n', 'contract RegistryICAPInterface {\n', '    function parse(bytes32 _icap) public view returns(address, bytes32, bool);\n', '    function institutions(bytes32 _institution) public view returns(address);\n', '}\n', '\n', '\n', 'contract EToken2Interface {\n', '    function registryICAP() public view returns(RegistryICAPInterface);\n', '    function baseUnit(bytes32 _symbol) public view returns(uint8);\n', '    function description(bytes32 _symbol) public view returns(string);\n', '    function owner(bytes32 _symbol) public view returns(address);\n', '    function isOwner(address _owner, bytes32 _symbol) public view returns(bool);\n', '    function totalSupply(bytes32 _symbol) public view returns(uint);\n', '    function balanceOf(address _holder, bytes32 _symbol) public view returns(uint);\n', '    function isLocked(bytes32 _symbol) public view returns(bool);\n', '\n', '    function issueAsset(\n', '        bytes32 _symbol,\n', '        uint _value,\n', '        string _name,\n', '        string _description,\n', '        uint8 _baseUnit,\n', '        bool _isReissuable)\n', '    public returns(bool);\n', '\n', '    function reissueAsset(bytes32 _symbol, uint _value) public returns(bool);\n', '    function revokeAsset(bytes32 _symbol, uint _value) public returns(bool);\n', '    function setProxy(address _address, bytes32 _symbol) public returns(bool);\n', '    function lockAsset(bytes32 _symbol) public returns(bool);\n', '\n', '    function proxyTransferFromToICAPWithReference(\n', '        address _from,\n', '        bytes32 _icap,\n', '        uint _value,\n', '        string _reference,\n', '        address _sender)\n', '    public returns(bool);\n', '\n', '    function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender)\n', '    public returns(bool);\n', '    \n', '    function allowance(address _from, address _spender, bytes32 _symbol) public view returns(uint);\n', '\n', '    function proxyTransferFromWithReference(\n', '        address _from,\n', '        address _to,\n', '        uint _value,\n', '        bytes32 _symbol,\n', '        string _reference,\n', '        address _sender)\n', '    public returns(bool);\n', '\n', '    function changeOwnership(bytes32 _symbol, address _newOwner) public returns(bool);\n', '}\n', '\n', '// File: contracts/AssetInterface.sol\n', '\n', 'pragma solidity 0.4.23;\n', '\n', '\n', 'contract AssetInterface {\n', '    function _performTransferWithReference(\n', '        address _to,\n', '        uint _value,\n', '        string _reference,\n', '        address _sender)\n', '    public returns(bool);\n', '\n', '    function _performTransferToICAPWithReference(\n', '        bytes32 _icap,\n', '        uint _value,\n', '        string _reference,\n', '        address _sender)\n', '    public returns(bool);\n', '\n', '    function _performApprove(address _spender, uint _value, address _sender)\n', '    public returns(bool);\n', '\n', '    function _performTransferFromWithReference(\n', '        address _from,\n', '        address _to,\n', '        uint _value,\n', '        string _reference,\n', '        address _sender)\n', '    public returns(bool);\n', '\n', '    function _performTransferFromToICAPWithReference(\n', '        address _from,\n', '        bytes32 _icap,\n', '        uint _value,\n', '        string _reference,\n', '        address _sender)\n', '    public returns(bool);\n', '\n', '    function _performGeneric(bytes, address) public payable {\n', '        revert();\n', '    }\n', '}\n', '\n', '// File: contracts/ERC20Interface.sol\n', '\n', 'pragma solidity 0.4.23;\n', '\n', '\n', 'contract ERC20Interface {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed from, address indexed spender, uint256 value);\n', '\n', '    function totalSupply() public view returns(uint256 supply);\n', '    function balanceOf(address _owner) public view returns(uint256 balance);\n', '    // solhint-disable-next-line no-simple-event-func-name\n', '    function transfer(address _to, uint256 _value) public returns(bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);\n', '    function approve(address _spender, uint256 _value) public returns(bool success);\n', '    function allowance(address _owner, address _spender) public view returns(uint256 remaining);\n', '\n', '    // function symbol() constant returns(string);\n', '    function decimals() public view returns(uint8);\n', '    // function name() constant returns(string);\n', '}\n', '\n', '// File: contracts/AssetProxyInterface.sol\n', '\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', 'contract AssetProxyInterface is ERC20Interface {\n', '    function _forwardApprove(address _spender, uint _value, address _sender)\n', '    public returns(bool);\n', '\n', '    function _forwardTransferFromWithReference(\n', '        address _from,\n', '        address _to,\n', '        uint _value,\n', '        string _reference,\n', '        address _sender)\n', '    public returns(bool);\n', '\n', '    function _forwardTransferFromToICAPWithReference(\n', '        address _from,\n', '        bytes32 _icap,\n', '        uint _value,\n', '        string _reference,\n', '        address _sender)\n', '    public returns(bool);\n', '\n', '    function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)\n', '    public returns(bool);\n', '\n', '    // solhint-disable-next-line no-empty-blocks\n', '    function etoken2() public pure returns(address) {} // To be replaced by the implicit getter;\n', '\n', '    // To be replaced by the implicit getter;\n', '    // solhint-disable-next-line no-empty-blocks\n', '    function etoken2Symbol() public pure returns(bytes32) {}\n', '}\n', '\n', '// File: contracts/helpers/Bytes32.sol\n', '\n', 'pragma solidity 0.4.23;\n', '\n', '\n', 'contract Bytes32 {\n', '    function _bytes32(string _input) internal pure returns(bytes32 result) {\n', '        assembly {\n', '            result := mload(add(_input, 32))\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/helpers/ReturnData.sol\n', '\n', 'pragma solidity 0.4.23;\n', '\n', '\n', 'contract ReturnData {\n', '    function _returnReturnData(bool _success) internal pure {\n', '        assembly {\n', '            let returndatastart := 0\n', '            returndatacopy(returndatastart, 0, returndatasize)\n', '            switch _success case 0 { revert(returndatastart, returndatasize) }\n', '                default { return(returndatastart, returndatasize) }\n', '        }\n', '    }\n', '\n', '    function _assemblyCall(address _destination, uint _value, bytes _data)\n', '    internal returns(bool success) {\n', '        assembly {\n', '            success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/AssetProxy.sol\n', '\n', 'pragma solidity 0.4.23;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title EToken2 Asset Proxy.\n', ' *\n', ' * Proxy implements ERC20 interface and acts as a gateway to a single EToken2 asset.\n', ' * Proxy adds etoken2Symbol and caller(sender) when forwarding requests to EToken2.\n', ' * Every request that is made by caller first sent to the specific asset implementation\n', ' * contract, which then calls back to be forwarded onto EToken2.\n', ' *\n', ' * Calls flow: Caller ->\n', ' *             Proxy.func(...) ->\n', ' *             Asset._performFunc(..., Caller.address) ->\n', ' *             Proxy._forwardFunc(..., Caller.address) ->\n', ' *             Platform.proxyFunc(..., symbol, Caller.address)\n', ' *\n', ' * Generic call flow: Caller ->\n', ' *             Proxy.unknownFunc(...) ->\n', ' *             Asset._performGeneric(..., Caller.address) ->\n', ' *             Asset.unknownFunc(...)\n', ' *\n', ' * Asset implementation contract is mutable, but each user have an option to stick with\n', " * old implementation, through explicit decision made in timely manner, if he doesn't agree\n", ' * with new rules.\n', ' * Each user have a possibility to upgrade to latest asset contract implementation, without the\n', ' * possibility to rollback.\n', ' *\n', ' * Note: all the non constant functions return false instead of throwing in case if state change\n', " * didn't happen yet.\n", ' */\n', 'contract VOLUM is ERC20Interface, AssetProxyInterface, Bytes32, ReturnData {\n', '    // Assigned EToken2, immutable.\n', '    EToken2Interface public etoken2;\n', '\n', '    // Assigned symbol, immutable.\n', '    bytes32 public etoken2Symbol;\n', '\n', '    // Assigned name, immutable. For UI.\n', '    string public name;\n', '    string public symbol;\n', '\n', '    /**\n', '     * Sets EToken2 address, assigns symbol and name.\n', '     *\n', '     * Can be set only once.\n', '     *\n', '     * @param _etoken2 EToken2 contract address.\n', '     * @param _symbol assigned symbol.\n', '     * @param _name assigned name.\n', '     *\n', '     * @return success.\n', '     */\n', '    function init(EToken2Interface _etoken2, string _symbol, string _name) public returns(bool) {\n', '        if (address(etoken2) != 0x0) {\n', '            return false;\n', '        }\n', '        etoken2 = _etoken2;\n', '        etoken2Symbol = _bytes32(_symbol);\n', '        name = _name;\n', '        symbol = _symbol;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Only EToken2 is allowed to call.\n', '     */\n', '    modifier onlyEToken2() {\n', '        if (msg.sender == address(etoken2)) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Only current asset owner is allowed to call.\n', '     */\n', '    modifier onlyAssetOwner() {\n', '        if (etoken2.isOwner(msg.sender, etoken2Symbol)) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns asset implementation contract for current caller.\n', '     *\n', '     * @return asset implementation contract.\n', '     */\n', '    function _getAsset() internal view returns(AssetInterface) {\n', '        return AssetInterface(getVersionFor(msg.sender));\n', '    }\n', '\n', '    /**\n', '     * Recovers tokens on proxy contract\n', '     *\n', '     * @param _asset type of tokens to recover.\n', '     * @param _value tokens that will be recovered.\n', '     * @param _receiver address where to send recovered tokens.\n', '     *\n', '     * @return success.\n', '     */\n', '    function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)\n', '    public onlyAssetOwner() returns(bool) {\n', '        return _asset.transfer(_receiver, _value);\n', '    }\n', '\n', '    /**\n', '     * Returns asset total supply.\n', '     *\n', '     * @return asset total supply.\n', '     */\n', '    function totalSupply() public view returns(uint) {\n', '        return etoken2.totalSupply(etoken2Symbol);\n', '    }\n', '\n', '    /**\n', '     * Returns asset balance for a particular holder.\n', '     *\n', '     * @param _owner holder address.\n', '     *\n', '     * @return holder balance.\n', '     */\n', '    function balanceOf(address _owner) public view returns(uint) {\n', '        return etoken2.balanceOf(_owner, etoken2Symbol);\n', '    }\n', '\n', '    /**\n', '     * Returns asset allowance from one holder to another.\n', '     *\n', '     * @param _from holder that allowed spending.\n', '     * @param _spender holder that is allowed to spend.\n', '     *\n', '     * @return holder to spender allowance.\n', '     */\n', '    function allowance(address _from, address _spender) public view returns(uint) {\n', '        return etoken2.allowance(_from, _spender, etoken2Symbol);\n', '    }\n', '\n', '    /**\n', '     * Returns asset decimals.\n', '     *\n', '     * @return asset decimals.\n', '     */\n', '    function decimals() public view returns(uint8) {\n', '        return etoken2.baseUnit(etoken2Symbol);\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified receiver.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transfer(address _to, uint _value) public returns(bool) {\n', "        return transferWithReference(_to, _value, '');\n", '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified receiver adding specified comment.\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     *\n', '     * @return success.\n', '     */\n', '    function transferWithReference(address _to, uint _value, string _reference)\n', '    public returns(bool) {\n', '        return _getAsset()._performTransferWithReference(\n', '            _to, _value, _reference, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified ICAP.\n', '     *\n', '     * @param _icap recipient ICAP to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transferToICAP(bytes32 _icap, uint _value) public returns(bool) {\n', "        return transferToICAPWithReference(_icap, _value, '');\n", '    }\n', '\n', '    /**\n', '     * Transfers asset balance from the caller to specified ICAP adding specified comment.\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @param _icap recipient ICAP to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     *\n', '     * @return success.\n', '     */\n', '    function transferToICAPWithReference(\n', '        bytes32 _icap,\n', '        uint _value,\n', '        string _reference)\n', '    public returns(bool) {\n', '        return _getAsset()._performTransferToICAPWithReference(\n', '            _icap, _value, _reference, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) public returns(bool) {\n', "        return transferFromWithReference(_from, _to, _value, '');\n", '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders adding specified comment.\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     *\n', '     * @return success.\n', '     */\n', '    function transferFromWithReference(\n', '        address _from,\n', '        address _to,\n', '        uint _value,\n', '        string _reference)\n', '    public returns(bool) {\n', '        return _getAsset()._performTransferFromWithReference(\n', '            _from,\n', '            _to,\n', '            _value,\n', '            _reference,\n', '            msg.sender\n', '        );\n', '    }\n', '\n', '    /**\n', '     * Performs transfer call on the EToken2 by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function _forwardTransferFromWithReference(\n', '        address _from,\n', '        address _to,\n', '        uint _value,\n', '        string _reference,\n', '        address _sender)\n', '    public onlyImplementationFor(_sender) returns(bool) {\n', '        return etoken2.proxyTransferFromWithReference(\n', '            _from,\n', '            _to,\n', '            _value,\n', '            etoken2Symbol,\n', '            _reference,\n', '            _sender\n', '        );\n', '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _icap recipient ICAP address to give to.\n', '     * @param _value amount to transfer.\n', '     *\n', '     * @return success.\n', '     */\n', '    function transferFromToICAP(address _from, bytes32 _icap, uint _value)\n', '    public returns(bool) {\n', "        return transferFromToICAPWithReference(_from, _icap, _value, '');\n", '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders adding specified comment.\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _icap recipient ICAP address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     *\n', '     * @return success.\n', '     */\n', '    function transferFromToICAPWithReference(\n', '        address _from,\n', '        bytes32 _icap,\n', '        uint _value,\n', '        string _reference)\n', '    public returns(bool) {\n', '        return _getAsset()._performTransferFromToICAPWithReference(\n', '            _from,\n', '            _icap,\n', '            _value,\n', '            _reference,\n', '            msg.sender\n', '        );\n', '    }\n', '\n', '    /**\n', '     * Performs allowance transfer to ICAP call on the EToken2 by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _icap recipient ICAP address to give to.\n', '     * @param _value amount to transfer.\n', "     * @param _reference transfer comment to be included in a EToken2's Transfer event.\n", '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function _forwardTransferFromToICAPWithReference(\n', '        address _from,\n', '        bytes32 _icap,\n', '        uint _value,\n', '        string _reference,\n', '        address _sender)\n', '    public onlyImplementationFor(_sender) returns(bool) {\n', '        return etoken2.proxyTransferFromToICAPWithReference(\n', '            _from,\n', '            _icap,\n', '            _value,\n', '            _reference,\n', '            _sender\n', '        );\n', '    }\n', '\n', '    /**\n', '     * Sets asset spending allowance for a specified spender.\n', '     * Resolves asset implementation contract for the caller and forwards there arguments along with\n', '     * the caller address.\n', '     *\n', '     * @param _spender holder address to set allowance to.\n', '     * @param _value amount to allow.\n', '     *\n', '     * @return success.\n', '     */\n', '    function approve(address _spender, uint _value) public returns(bool) {\n', '        return _getAsset()._performApprove(_spender, _value, msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Performs allowance setting call on the EToken2 by the name of specified sender.\n', '     *\n', '     * Can only be called by asset implementation contract assigned to sender.\n', '     *\n', '     * @param _spender holder address to set allowance to.\n', '     * @param _value amount to allow.\n', '     * @param _sender initial caller.\n', '     *\n', '     * @return success.\n', '     */\n', '    function _forwardApprove(address _spender, uint _value, address _sender)\n', '    public onlyImplementationFor(_sender) returns(bool) {\n', '        return etoken2.proxyApprove(_spender, _value, etoken2Symbol, _sender);\n', '    }\n', '\n', '    /**\n', '     * Emits ERC20 Transfer event on this contract.\n', '     *\n', '     * Can only be, and, called by assigned EToken2 when asset transfer happens.\n', '     */\n', '    function emitTransfer(address _from, address _to, uint _value) public onlyEToken2() {\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Emits ERC20 Approval event on this contract.\n', '     *\n', '     * Can only be, and, called by assigned EToken2 when asset allowance set happens.\n', '     */\n', '    function emitApprove(address _from, address _spender, uint _value) public onlyEToken2() {\n', '        emit Approval(_from, _spender, _value);\n', '    }\n', '\n', '    /**\n', '     * Resolves asset implementation contract for the caller and forwards there transaction data,\n', '     * along with the value. This allows for proxy interface growth.\n', '     */\n', '    function () public payable {\n', '        _getAsset()._performGeneric.value(msg.value)(msg.data, msg.sender);\n', '        _returnReturnData(true);\n', '    }\n', '\n', '    // Interface functions to allow specifying ICAP addresses as strings.\n', '    function transferToICAP(string _icap, uint _value) public returns(bool) {\n', "        return transferToICAPWithReference(_icap, _value, '');\n", '    }\n', '\n', '    function transferToICAPWithReference(string _icap, uint _value, string _reference)\n', '    public returns(bool) {\n', '        return transferToICAPWithReference(_bytes32(_icap), _value, _reference);\n', '    }\n', '\n', '    function transferFromToICAP(address _from, string _icap, uint _value) public returns(bool) {\n', "        return transferFromToICAPWithReference(_from, _icap, _value, '');\n", '    }\n', '\n', '    function transferFromToICAPWithReference(\n', '        address _from,\n', '        string _icap,\n', '        uint _value,\n', '        string _reference)\n', '    public returns(bool) {\n', '        return transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference);\n', '    }\n', '\n', '    /**\n', '     * Indicates an upgrade freeze-time start, and the next asset implementation contract.\n', '     */\n', '    event UpgradeProposed(address newVersion);\n', '    event UpgradePurged(address newVersion);\n', '    event UpgradeCommited(address newVersion);\n', '    event OptedOut(address sender, address version);\n', '    event OptedIn(address sender, address version);\n', '\n', '    // Current asset implementation contract address.\n', '    address internal latestVersion;\n', '\n', '    // Proposed next asset implementation contract address.\n', '    address internal pendingVersion;\n', '\n', '    // Upgrade freeze-time start.\n', '    uint internal pendingVersionTimestamp;\n', '\n', '    // Timespan for users to review the new implementation and make decision.\n', '    uint internal constant UPGRADE_FREEZE_TIME = 3 days;\n', '\n', '    // Asset implementation contract address that user decided to stick with.\n', '    // 0x0 means that user uses latest version.\n', '    mapping(address => address) internal userOptOutVersion;\n', '\n', '    /**\n', '     * Only asset implementation contract assigned to sender is allowed to call.\n', '     */\n', '    modifier onlyImplementationFor(address _sender) {\n', '        if (getVersionFor(_sender) == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns asset implementation contract address assigned to sender.\n', '     *\n', '     * @param _sender sender address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getVersionFor(address _sender) public view returns(address) {\n', '        return userOptOutVersion[_sender] == 0 ? latestVersion : userOptOutVersion[_sender];\n', '    }\n', '\n', '    /**\n', '     * Returns current asset implementation contract address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getLatestVersion() public view returns(address) {\n', '        return latestVersion;\n', '    }\n', '\n', '    /**\n', '     * Returns proposed next asset implementation contract address.\n', '     *\n', '     * @return asset implementation contract address.\n', '     */\n', '    function getPendingVersion() public view returns(address) {\n', '        return pendingVersion;\n', '    }\n', '\n', '    /**\n', '     * Returns upgrade freeze-time start.\n', '     *\n', '     * @return freeze-time start.\n', '     */\n', '    function getPendingVersionTimestamp() public view returns(uint) {\n', '        return pendingVersionTimestamp;\n', '    }\n', '\n', '    /**\n', '     * Propose next asset implementation contract address.\n', '     *\n', '     * Can only be called by current asset owner.\n', '     *\n', '     * Note: freeze-time should not be applied for the initial setup.\n', '     *\n', '     * @param _newVersion asset implementation contract address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function proposeUpgrade(address _newVersion) public onlyAssetOwner() returns(bool) {\n', '        // Should not already be in the upgrading process.\n', '        if (pendingVersion != 0x0) {\n', '            return false;\n', '        }\n', '        // New version address should be other than 0x0.\n', '        if (_newVersion == 0x0) {\n', '            return false;\n', '        }\n', "        // Don't apply freeze-time for the initial setup.\n", '        if (latestVersion == 0x0) {\n', '            latestVersion = _newVersion;\n', '            return true;\n', '        }\n', '        pendingVersion = _newVersion;\n', '        // solhint-disable-next-line not-rely-on-time\n', '        pendingVersionTimestamp = now;\n', '        emit UpgradeProposed(_newVersion);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Cancel the pending upgrade process.\n', '     *\n', '     * Can only be called by current asset owner.\n', '     *\n', '     * @return success.\n', '     */\n', '    function purgeUpgrade() public onlyAssetOwner() returns(bool) {\n', '        if (pendingVersion == 0x0) {\n', '            return false;\n', '        }\n', '        emit UpgradePurged(pendingVersion);\n', '        delete pendingVersion;\n', '        delete pendingVersionTimestamp;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Finalize an upgrade process setting new asset implementation contract address.\n', '     *\n', '     * Can only be called after an upgrade freeze-time.\n', '     *\n', '     * @return success.\n', '     */\n', '    function commitUpgrade() public returns(bool) {\n', '        if (pendingVersion == 0x0) {\n', '            return false;\n', '        }\n', '        // solhint-disable-next-line not-rely-on-time\n', '        if (pendingVersionTimestamp + UPGRADE_FREEZE_TIME > now) {\n', '            return false;\n', '        }\n', '        latestVersion = pendingVersion;\n', '        delete pendingVersion;\n', '        delete pendingVersionTimestamp;\n', '        emit UpgradeCommited(latestVersion);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Disagree with proposed upgrade, and stick with current asset implementation\n', '     * until further explicit agreement to upgrade.\n', '     *\n', '     * @return success.\n', '     */\n', '    function optOut() public returns(bool) {\n', '        if (userOptOutVersion[msg.sender] != 0x0) {\n', '            return false;\n', '        }\n', '        userOptOutVersion[msg.sender] = latestVersion;\n', '        emit OptedOut(msg.sender, latestVersion);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Implicitly agree to upgrade to current and future asset implementation upgrades,\n', '     * until further explicit disagreement.\n', '     *\n', '     * @return success.\n', '     */\n', '    function optIn() public returns(bool) {\n', '        delete userOptOutVersion[msg.sender];\n', '        emit OptedIn(msg.sender, latestVersion);\n', '        return true;\n', '    }\n', '\n', '    // Backwards compatibility.\n', '    function multiAsset() public view returns(EToken2Interface) {\n', '        return etoken2;\n', '    }\n', '}\n']
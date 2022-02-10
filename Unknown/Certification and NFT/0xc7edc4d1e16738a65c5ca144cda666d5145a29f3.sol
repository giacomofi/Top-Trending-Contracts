['pragma solidity ^0.4.4;\n', '\n', 'contract Owned {\n', '    address public contractOwner;\n', '    address public pendingContractOwner;\n', '\n', '    function Owned() {\n', '        contractOwner = msg.sender;\n', '    }\n', '\n', '    modifier onlyContractOwner() {\n', '        if (contractOwner == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Prepares ownership pass.\n', '     *\n', '     * Can only be called by current owner.\n', '     *\n', '     * @param _to address of the next owner.\n', '     *\n', '     * @return success.\n', '     */\n', '    function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {\n', '        pendingContractOwner = _to;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Finalize ownership pass.\n', '     *\n', '     * Can only be called by pending owner.\n', '     *\n', '     * @return success.\n', '     */\n', '    function claimContractOwnership() returns(bool) {\n', '        if (pendingContractOwner != msg.sender) {\n', '            return false;\n', '        }\n', '        contractOwner = pendingContractOwner;\n', '        delete pendingContractOwner;\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', 'contract Emitter {\n', '    function emitTransfer(address _from, address _to, bytes32 _symbol, uint _value, string _reference);\n', '    function emitIssue(bytes32 _symbol, uint _value, address _by);\n', '    function emitRevoke(bytes32 _symbol, uint _value, address _by);\n', '    function emitOwnershipChange(address _from, address _to, bytes32 _symbol);\n', '    function emitApprove(address _from, address _spender, bytes32 _symbol, uint _value);\n', '    function emitRecovery(address _from, address _to, address _by);\n', '    function emitError(bytes32 _message);\n', '}\n', '\n', 'contract Proxy {\n', '    function emitTransfer(address _from, address _to, uint _value);\n', '    function emitApprove(address _from, address _spender, uint _value);\n', '}\n', '\n', '/**\n', ' * @title ChronoBank Platform.\n', ' *\n', ' * The official ChronoBank assets platform powering TIME and LHT tokens, and possibly\n', ' * other unknown tokens needed later.\n', ' * Platform uses EventsHistory contract to keep events, so that in case it needs to be redeployed\n', ' * at some point, all the events keep appearing at the same place.\n', ' *\n', ' * Every asset is meant to be used through a proxy contract. Only one proxy contract have access\n', ' * rights for a particular asset.\n', ' *\n', ' * Features: transfers, allowances, supply adjustments, lost wallet access recovery.\n', ' *\n', ' * Note: all the non constant functions return false instead of throwing in case if state change\n', ' * didn&#39;t happen yet.\n', ' */\n', 'contract ChronoBankPlatform is Owned {\n', '    // Structure of a particular asset.\n', '    struct Asset {\n', '        uint owner;                       // Asset&#39;s owner id.\n', '        uint totalSupply;                 // Asset&#39;s total supply.\n', '        string name;                      // Asset&#39;s name, for information purposes.\n', '        string description;               // Asset&#39;s description, for information purposes.\n', '        bool isReissuable;                // Indicates if asset have dynamic of fixed supply.\n', '        uint8 baseUnit;                   // Proposed number of decimals.\n', '        mapping(uint => Wallet) wallets;  // Holders wallets.\n', '    }\n', '\n', '    // Structure of an asset holder wallet for particular asset.\n', '    struct Wallet {\n', '        uint balance;\n', '        mapping(uint => uint) allowance;\n', '    }\n', '\n', '    // Structure of an asset holder.\n', '    struct Holder {\n', '        address addr;                    // Current address of the holder.\n', '        mapping(address => bool) trust;  // Addresses that are trusted with recovery proocedure.\n', '    }\n', '\n', '    // Iterable mapping pattern is used for holders.\n', '    uint public holdersCount;\n', '    mapping(uint => Holder) public holders;\n', '\n', '    // This is an access address mapping. Many addresses may have access to a single holder.\n', '    mapping(address => uint) holderIndex;\n', '\n', '    // Asset symbol to asset mapping.\n', '    mapping(bytes32 => Asset) public assets;\n', '\n', '    // Asset symbol to asset proxy mapping.\n', '    mapping(bytes32 => address) public proxies;\n', '\n', '    // Should use interface of the emitter, but address of events history.\n', '    Emitter public eventsHistory;\n', '\n', '    /**\n', '     * Emits Error event with specified error message.\n', '     *\n', '     * Should only be used if no state changes happened.\n', '     *\n', '     * @param _message error message.\n', '     */\n', '    function _error(bytes32 _message) internal {\n', '        eventsHistory.emitError(_message);\n', '    }\n', '\n', '    /**\n', '     * Sets EventsHstory contract address.\n', '     *\n', '     * Can be set only once, and only by contract owner.\n', '     *\n', '     * @param _eventsHistory EventsHistory contract address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function setupEventsHistory(address _eventsHistory) onlyContractOwner() returns(bool) {\n', '        if (address(eventsHistory) != 0) {\n', '            return false;\n', '        }\n', '        eventsHistory = Emitter(_eventsHistory);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Emits Error if called not by asset owner.\n', '     */\n', '    modifier onlyOwner(bytes32 _symbol) {\n', '        if (isOwner(msg.sender, _symbol)) {\n', '            _;\n', '        } else {\n', '            _error("Only owner: access denied");\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Emits Error if called not by asset proxy.\n', '     */\n', '    modifier onlyProxy(bytes32 _symbol) {\n', '        if (proxies[_symbol] == msg.sender) {\n', '            _;\n', '        } else {\n', '            _error("Only proxy: access denied");\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Emits Error if _from doesn&#39;t trust _to.\n', '     */\n', '    modifier checkTrust(address _from, address _to) {\n', '        if (isTrusted(_from, _to)) {\n', '            _;\n', '        } else {\n', '            _error("Only trusted: access denied");\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Check asset existance.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return asset existance.\n', '     */\n', '    function isCreated(bytes32 _symbol) constant returns(bool) {\n', '        return assets[_symbol].owner != 0;\n', '    }\n', '\n', '    /**\n', '     * Returns asset decimals.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return asset decimals.\n', '     */\n', '    function baseUnit(bytes32 _symbol) constant returns(uint8) {\n', '        return assets[_symbol].baseUnit;\n', '    }\n', '\n', '    /**\n', '     * Returns asset name.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return asset name.\n', '     */\n', '    function name(bytes32 _symbol) constant returns(string) {\n', '        return assets[_symbol].name;\n', '    }\n', '\n', '    /**\n', '     * Returns asset description.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return asset description.\n', '     */\n', '    function description(bytes32 _symbol) constant returns(string) {\n', '        return assets[_symbol].description;\n', '    }\n', '\n', '    /**\n', '     * Returns asset reissuability.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return asset reissuability.\n', '     */\n', '    function isReissuable(bytes32 _symbol) constant returns(bool) {\n', '        return assets[_symbol].isReissuable;\n', '    }\n', '\n', '    /**\n', '     * Returns asset owner address.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return asset owner address.\n', '     */\n', '    function owner(bytes32 _symbol) constant returns(address) {\n', '        return holders[assets[_symbol].owner].addr;\n', '    }\n', '\n', '    /**\n', '     * Check if specified address has asset owner rights.\n', '     *\n', '     * @param _owner address to check.\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return owner rights availability.\n', '     */\n', '    function isOwner(address _owner, bytes32 _symbol) constant returns(bool) {\n', '        return isCreated(_symbol) && (assets[_symbol].owner == getHolderId(_owner));\n', '    }\n', '\n', '    /**\n', '     * Returns asset total supply.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return asset total supply.\n', '     */\n', '    function totalSupply(bytes32 _symbol) constant returns(uint) {\n', '        return assets[_symbol].totalSupply;\n', '    }\n', '\n', '    /**\n', '     * Returns asset balance for a particular holder.\n', '     *\n', '     * @param _holder holder address.\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return holder balance.\n', '     */\n', '    function balanceOf(address _holder, bytes32 _symbol) constant returns(uint) {\n', '        return _balanceOf(getHolderId(_holder), _symbol);\n', '    }\n', '\n', '    /**\n', '     * Returns asset balance for a particular holder id.\n', '     *\n', '     * @param _holderId holder id.\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return holder balance.\n', '     */\n', '    function _balanceOf(uint _holderId, bytes32 _symbol) constant returns(uint) {\n', '        return assets[_symbol].wallets[_holderId].balance;\n', '    }\n', '\n', '    /**\n', '     * Returns current address for a particular holder id.\n', '     *\n', '     * @param _holderId holder id.\n', '     *\n', '     * @return holder address.\n', '     */\n', '    function _address(uint _holderId) constant returns(address) {\n', '        return holders[_holderId].addr;\n', '    }\n', '\n', '    /**\n', '     * Sets Proxy contract address for a particular asset.\n', '     *\n', '     * Can be set only once for each asset, and only by contract owner.\n', '     *\n', '     * @param _address Proxy contract address.\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return success.\n', '     */\n', '    function setProxy(address _address, bytes32 _symbol) onlyContractOwner() returns(bool) {\n', '        if (proxies[_symbol] != 0x0) {\n', '            return false;\n', '        }\n', '        proxies[_symbol] = _address;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance between holders wallets.\n', '     *\n', '     * @param _fromId holder id to take from.\n', '     * @param _toId holder id to give to.\n', '     * @param _value amount to transfer.\n', '     * @param _symbol asset symbol.\n', '     */\n', '    function _transferDirect(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {\n', '        assets[_symbol].wallets[_fromId].balance -= _value;\n', '        assets[_symbol].wallets[_toId].balance += _value;\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance between holders wallets.\n', '     *\n', '     * Performs sanity checks and takes care of allowances adjustment.\n', '     *\n', '     * @param _fromId holder id to take from.\n', '     * @param _toId holder id to give to.\n', '     * @param _value amount to transfer.\n', '     * @param _symbol asset symbol.\n', '     * @param _reference transfer comment to be included in a Transfer event.\n', '     * @param _senderId transfer initiator holder id.\n', '     *\n', '     * @return success.\n', '     */\n', '    function _transfer(uint _fromId, uint _toId, uint _value, bytes32 _symbol, string _reference, uint _senderId) internal returns(bool) {\n', '        // Should not allow to send to oneself.\n', '        if (_fromId == _toId) {\n', '            _error("Cannot send to oneself");\n', '            return false;\n', '        }\n', '        // Should have positive value.\n', '        if (_value == 0) {\n', '            _error("Cannot send 0 value");\n', '            return false;\n', '        }\n', '        // Should have enough balance.\n', '        if (_balanceOf(_fromId, _symbol) < _value) {\n', '            _error("Insufficient balance");\n', '            return false;\n', '        }\n', '        // Should have enough allowance.\n', '        if (_fromId != _senderId && _allowance(_fromId, _senderId, _symbol) < _value) {\n', '            _error("Not enough allowance");\n', '            return false;\n', '        }\n', '        _transferDirect(_fromId, _toId, _value, _symbol);\n', '        // Adjust allowance.\n', '        if (_fromId != _senderId) {\n', '            assets[_symbol].wallets[_fromId].allowance[_senderId] -= _value;\n', '        }\n', '        // Internal Out Of Gas/Throw: revert this transaction too;\n', '        // Call Stack Depth Limit reached: n/a after HF 4;\n', '        // Recursive Call: safe, all changes already made.\n', '        eventsHistory.emitTransfer(_address(_fromId), _address(_toId), _symbol, _value, _reference);\n', '        _proxyTransferEvent(_fromId, _toId, _value, _symbol);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfers asset balance between holders wallets.\n', '     *\n', '     * Can only be called by asset proxy.\n', '     *\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     * @param _symbol asset symbol.\n', '     * @param _reference transfer comment to be included in a Transfer event.\n', '     * @param _sender transfer initiator address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) onlyProxy(_symbol) returns(bool) {\n', '        return _transfer(getHolderId(_sender), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));\n', '    }\n', '\n', '    /**\n', '     * Ask asset Proxy contract to emit ERC20 compliant Transfer event.\n', '     *\n', '     * @param _fromId holder id to take from.\n', '     * @param _toId holder id to give to.\n', '     * @param _value amount to transfer.\n', '     * @param _symbol asset symbol.\n', '     */\n', '    function _proxyTransferEvent(uint _fromId, uint _toId, uint _value, bytes32 _symbol) internal {\n', '        if (proxies[_symbol] != 0x0) {\n', '            // Internal Out Of Gas/Throw: revert this transaction too;\n', '            // Call Stack Depth Limit reached: n/a after HF 4;\n', '            // Recursive Call: safe, all changes already made.\n', '            Proxy(proxies[_symbol]).emitTransfer(_address(_fromId), _address(_toId), _value);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Returns holder id for the specified address.\n', '     *\n', '     * @param _holder holder address.\n', '     *\n', '     * @return holder id.\n', '     */\n', '    function getHolderId(address _holder) constant returns(uint) {\n', '        return holderIndex[_holder];\n', '    }\n', '\n', '    /**\n', '     * Returns holder id for the specified address, creates it if needed.\n', '     *\n', '     * @param _holder holder address.\n', '     *\n', '     * @return holder id.\n', '     */\n', '    function _createHolderId(address _holder) internal returns(uint) {\n', '        uint holderId = holderIndex[_holder];\n', '        if (holderId == 0) {\n', '            holderId = ++holdersCount;\n', '            holders[holderId].addr = _holder;\n', '            holderIndex[_holder] = holderId;\n', '        }\n', '        return holderId;\n', '    }\n', '\n', '    /**\n', '     * Issues new asset token on the platform.\n', '     *\n', '     * Tokens issued with this call go straight to contract owner.\n', '     * Each symbol can be issued only once, and only by contract owner.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     * @param _value amount of tokens to issue immediately.\n', '     * @param _name name of the asset.\n', '     * @param _description description for the asset.\n', '     * @param _baseUnit number of decimals.\n', '     * @param _isReissuable dynamic or fixed supply.\n', '     *\n', '     * @return success.\n', '     */\n', '    function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) onlyContractOwner() returns(bool) {\n', '        // Should have positive value if supply is going to be fixed.\n', '        if (_value == 0 && !_isReissuable) {\n', '            _error("Cannot issue 0 value fixed asset");\n', '            return false;\n', '        }\n', '        // Should not be issued yet.\n', '        if (isCreated(_symbol)) {\n', '            _error("Asset already issued");\n', '            return false;\n', '        }\n', '        uint holderId = _createHolderId(msg.sender);\n', '\n', '        assets[_symbol] = Asset(holderId, _value, _name, _description, _isReissuable, _baseUnit);\n', '        assets[_symbol].wallets[holderId].balance = _value;\n', '        // Internal Out Of Gas/Throw: revert this transaction too;\n', '        // Call Stack Depth Limit reached: n/a after HF 4;\n', '        // Recursive Call: safe, all changes already made.\n', '        eventsHistory.emitIssue(_symbol, _value, _address(holderId));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Issues additional asset tokens if the asset have dynamic supply.\n', '     *\n', '     * Tokens issued with this call go straight to asset owner.\n', '     * Can only be called by asset owner.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     * @param _value amount of additional tokens to issue.\n', '     *\n', '     * @return success.\n', '     */\n', '    function reissueAsset(bytes32 _symbol, uint _value) onlyOwner(_symbol) returns(bool) {\n', '        // Should have positive value.\n', '        if (_value == 0) {\n', '            _error("Cannot reissue 0 value");\n', '            return false;\n', '        }\n', '        Asset asset = assets[_symbol];\n', '        // Should have dynamic supply.\n', '        if (!asset.isReissuable) {\n', '            _error("Cannot reissue fixed asset");\n', '            return false;\n', '        }\n', '        // Resulting total supply should not overflow.\n', '        if (asset.totalSupply + _value < asset.totalSupply) {\n', '            _error("Total supply overflow");\n', '            return false;\n', '        }\n', '        uint holderId = getHolderId(msg.sender);\n', '        asset.wallets[holderId].balance += _value;\n', '        asset.totalSupply += _value;\n', '        // Internal Out Of Gas/Throw: revert this transaction too;\n', '        // Call Stack Depth Limit reached: n/a after HF 4;\n', '        // Recursive Call: safe, all changes already made.\n', '        eventsHistory.emitIssue(_symbol, _value, _address(holderId));\n', '        _proxyTransferEvent(0, holderId, _value, _symbol);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroys specified amount of senders asset tokens.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     * @param _value amount of tokens to destroy.\n', '     *\n', '     * @return success.\n', '     */\n', '    function revokeAsset(bytes32 _symbol, uint _value) returns(bool) {\n', '        // Should have positive value.\n', '        if (_value == 0) {\n', '            _error("Cannot revoke 0 value");\n', '            return false;\n', '        }\n', '        Asset asset = assets[_symbol];\n', '        uint holderId = getHolderId(msg.sender);\n', '        // Should have enough tokens.\n', '        if (asset.wallets[holderId].balance < _value) {\n', '            _error("Not enough tokens to revoke");\n', '            return false;\n', '        }\n', '        asset.wallets[holderId].balance -= _value;\n', '        asset.totalSupply -= _value;\n', '        // Internal Out Of Gas/Throw: revert this transaction too;\n', '        // Call Stack Depth Limit reached: n/a after HF 4;\n', '        // Recursive Call: safe, all changes already made.\n', '        eventsHistory.emitRevoke(_symbol, _value, _address(holderId));\n', '        _proxyTransferEvent(holderId, 0, _value, _symbol);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Passes asset ownership to specified address.\n', '     *\n', '     * Only ownership is changed, balances are not touched.\n', '     * Can only be called by asset owner.\n', '     *\n', '     * @param _symbol asset symbol.\n', '     * @param _newOwner address to become a new owner.\n', '     *\n', '     * @return success.\n', '     */\n', '    function changeOwnership(bytes32 _symbol, address _newOwner) onlyOwner(_symbol) returns(bool) {\n', '        Asset asset = assets[_symbol];\n', '        uint newOwnerId = _createHolderId(_newOwner);\n', '        // Should pass ownership to another holder.\n', '        if (asset.owner == newOwnerId) {\n', '            _error("Cannot pass ownership to oneself");\n', '            return false;\n', '        }\n', '        address oldOwner = _address(asset.owner);\n', '        asset.owner = newOwnerId;\n', '        // Internal Out Of Gas/Throw: revert this transaction too;\n', '        // Call Stack Depth Limit reached: n/a after HF 4;\n', '        // Recursive Call: safe, all changes already made.\n', '        eventsHistory.emitOwnershipChange(oldOwner, _address(newOwnerId), _symbol);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Check if specified holder trusts an address with recovery procedure.\n', '     *\n', '     * @param _from truster.\n', '     * @param _to trustee.\n', '     *\n', '     * @return trust existance.\n', '     */\n', '    function isTrusted(address _from, address _to) constant returns(bool) {\n', '        return holders[getHolderId(_from)].trust[_to];\n', '    }\n', '\n', '    /**\n', '     * Trust an address to perform recovery procedure for the caller.\n', '     *\n', '     * @param _to trustee.\n', '     *\n', '     * @return success.\n', '     */\n', '    function trust(address _to) returns(bool) {\n', '        uint fromId = _createHolderId(msg.sender);\n', '        // Should trust to another address.\n', '        if (fromId == getHolderId(_to)) {\n', '            _error("Cannot trust to oneself");\n', '            return false;\n', '        }\n', '        // Should trust to yet untrusted.\n', '        if (isTrusted(msg.sender, _to)) {\n', '            _error("Already trusted");\n', '            return false;\n', '        }\n', '        holders[fromId].trust[_to] = true;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Revoke trust to perform recovery procedure from an address.\n', '     *\n', '     * @param _to trustee.\n', '     *\n', '     * @return success.\n', '     */\n', '    function distrust(address _to) checkTrust(msg.sender, _to) returns(bool) {\n', '        holders[getHolderId(msg.sender)].trust[_to] = false;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Perform recovery procedure.\n', '     *\n', '     * This function logic is actually more of an addAccess(uint _holderId, address _to).\n', '     * It grants another address access to recovery subject wallets.\n', '     * Can only be called by trustee of recovery subject.\n', '     *\n', '     * @param _from holder address to recover from.\n', '     * @param _to address to grant access to.\n', '     *\n', '     * @return success.\n', '     */\n', '    function recover(address _from, address _to) checkTrust(_from, msg.sender) returns(bool) {\n', '        // Should recover to previously unused address.\n', '        if (getHolderId(_to) != 0) {\n', '            _error("Should recover to new address");\n', '            return false;\n', '        }\n', '        // We take current holder address because it might not equal _from.\n', '        // It is possible to recover from any old holder address, but event should have the current one.\n', '        address from = holders[getHolderId(_from)].addr;\n', '        holders[getHolderId(_from)].addr = _to;\n', '        holderIndex[_to] = getHolderId(_from);\n', '        // Internal Out Of Gas/Throw: revert this transaction too;\n', '        // Call Stack Depth Limit reached: revert this transaction too;\n', '        // Recursive Call: safe, all changes already made.\n', '        eventsHistory.emitRecovery(from, _to, msg.sender);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Sets asset spending allowance for a specified spender.\n', '     *\n', '     * Note: to revoke allowance, one needs to set allowance to 0.\n', '     *\n', '     * @param _spenderId holder id to set allowance for.\n', '     * @param _value amount to allow.\n', '     * @param _symbol asset symbol.\n', '     * @param _senderId approve initiator holder id.\n', '     *\n', '     * @return success.\n', '     */\n', '    function _approve(uint _spenderId, uint _value, bytes32 _symbol, uint _senderId) internal returns(bool) {\n', '        // Asset should exist.\n', '        if (!isCreated(_symbol)) {\n', '            _error("Asset is not issued");\n', '            return false;\n', '        }\n', '        // Should allow to another holder.\n', '        if (_senderId == _spenderId) {\n', '            _error("Cannot approve to oneself");\n', '            return false;\n', '        }\n', '        assets[_symbol].wallets[_senderId].allowance[_spenderId] = _value;\n', '        // Internal Out Of Gas/Throw: revert this transaction too;\n', '        // Call Stack Depth Limit reached: revert this transaction too;\n', '        // Recursive Call: safe, all changes already made.\n', '        eventsHistory.emitApprove(_address(_senderId), _address(_spenderId), _symbol, _value);\n', '        if (proxies[_symbol] != 0x0) {\n', '            // Internal Out Of Gas/Throw: revert this transaction too;\n', '            // Call Stack Depth Limit reached: n/a after HF 4;\n', '            // Recursive Call: safe, all changes already made.\n', '            Proxy(proxies[_symbol]).emitApprove(_address(_senderId), _address(_spenderId), _value);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Sets asset spending allowance for a specified spender.\n', '     *\n', '     * Can only be called by asset proxy.\n', '     *\n', '     * @param _spender holder address to set allowance to.\n', '     * @param _value amount to allow.\n', '     * @param _symbol asset symbol.\n', '     * @param _sender approve initiator address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) onlyProxy(_symbol) returns(bool) {\n', '        return _approve(_createHolderId(_spender), _value, _symbol, _createHolderId(_sender));\n', '    }\n', '\n', '    /**\n', '     * Returns asset allowance from one holder to another.\n', '     *\n', '     * @param _from holder that allowed spending.\n', '     * @param _spender holder that is allowed to spend.\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return holder to spender allowance.\n', '     */\n', '    function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint) {\n', '        return _allowance(getHolderId(_from), getHolderId(_spender), _symbol);\n', '    }\n', '\n', '    /**\n', '     * Returns asset allowance from one holder to another.\n', '     *\n', '     * @param _fromId holder id that allowed spending.\n', '     * @param _toId holder id that is allowed to spend.\n', '     * @param _symbol asset symbol.\n', '     *\n', '     * @return holder to spender allowance.\n', '     */\n', '    function _allowance(uint _fromId, uint _toId, bytes32 _symbol) constant internal returns(uint) {\n', '        return assets[_symbol].wallets[_fromId].allowance[_toId];\n', '    }\n', '\n', '    /**\n', '     * Prforms allowance transfer of asset balance between holders wallets.\n', '     *\n', '     * Can only be called by asset proxy.\n', '     *\n', '     * @param _from holder address to take from.\n', '     * @param _to holder address to give to.\n', '     * @param _value amount to transfer.\n', '     * @param _symbol asset symbol.\n', '     * @param _reference transfer comment to be included in a Transfer event.\n', '     * @param _sender allowance transfer initiator address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) onlyProxy(_symbol) returns(bool) {\n', '        return _transfer(getHolderId(_from), _createHolderId(_to), _value, _symbol, _reference, getHolderId(_sender));\n', '    }\n', '}']
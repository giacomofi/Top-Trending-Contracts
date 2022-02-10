['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title Owned contract with safe ownership pass.\n', ' *\n', ' * Note: all the non constant functions return false instead of throwing in case if state change\n', ' * didn&#39;t happen yet.\n', ' */\n', 'contract Owned {\n', '    /**\n', '     * Contract owner address\n', '     */\n', '    address public contractOwner;\n', '\n', '    /**\n', '     * Contract owner address\n', '     */\n', '    address public pendingContractOwner;\n', '\n', '    function Owned() {\n', '        contractOwner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Owner check modifier\n', '    */\n', '    modifier onlyContractOwner() {\n', '        if (contractOwner == msg.sender) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Destroy contract and scrub a data\n', '     * @notice Only owner can call it\n', '     */\n', '    function destroy() onlyContractOwner {\n', '        suicide(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Prepares ownership pass.\n', '     *\n', '     * Can only be called by current owner.\n', '     *\n', '     * @param _to address of the next owner. 0x0 is not allowed.\n', '     *\n', '     * @return success.\n', '     */\n', '    function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {\n', '        if (_to  == 0x0) {\n', '            return false;\n', '        }\n', '\n', '        pendingContractOwner = _to;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Finalize ownership pass.\n', '     *\n', '     * Can only be called by pending owner.\n', '     *\n', '     * @return success.\n', '     */\n', '    function claimContractOwnership() returns(bool) {\n', '        if (pendingContractOwner != msg.sender) {\n', '            return false;\n', '        }\n', '\n', '        contractOwner = pendingContractOwner;\n', '        delete pendingContractOwner;\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract ERC20Interface {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed from, address indexed spender, uint256 value);\n', '    string public symbol;\n', '\n', '    function totalSupply() constant returns (uint256 supply);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '}\n', '\n', '\n', '/**\n', ' * @title Generic owned destroyable contract\n', ' */\n', 'contract Object is Owned {\n', '    /**\n', '    *  Common result code. Means everything is fine.\n', '    */\n', '    uint constant OK = 1;\n', '    uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;\n', '\n', '    function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {\n', '        for(uint i=0;i<tokens.length;i++) {\n', '            address token = tokens[i];\n', '            uint balance = ERC20Interface(token).balanceOf(this);\n', '            if(balance != 0)\n', '                ERC20Interface(token).transfer(_to,balance);\n', '        }\n', '        return OK;\n', '    }\n', '\n', '    function checkOnlyContractOwner() internal constant returns(uint) {\n', '        if (contractOwner == msg.sender) {\n', '            return OK;\n', '        }\n', '\n', '        return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;\n', '    }\n', '}\n', '\n', '\n', '\n', '//import "../contracts/ContractsManagerInterface.sol";\n', '\n', '/**\n', ' * @title General MultiEventsHistory user.\n', ' *\n', ' */\n', 'contract MultiEventsHistoryAdapter {\n', '\n', '    /**\n', '    *   @dev It is address of MultiEventsHistory caller assuming we are inside of delegate call.\n', '    */\n', '    function _self() constant internal returns (address) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', '\n', 'contract DelayedPaymentsEmitter is MultiEventsHistoryAdapter {\n', '        event Error(bytes32 message);\n', '\n', '        function emitError(bytes32 _message) {\n', '           Error(_message);\n', '        }\n', '}\n', '\n', 'contract Lockup6m_20180801 is Object {\n', '\n', '    uint constant TIME_LOCK_SCOPE = 51000;\n', '    uint constant TIME_LOCK_TRANSFER_ERROR = TIME_LOCK_SCOPE + 10;\n', '    uint constant TIME_LOCK_TRANSFERFROM_ERROR = TIME_LOCK_SCOPE + 11;\n', '    uint constant TIME_LOCK_BALANCE_ERROR = TIME_LOCK_SCOPE + 12;\n', '    uint constant TIME_LOCK_TIMESTAMP_ERROR = TIME_LOCK_SCOPE + 13;\n', '    uint constant TIME_LOCK_INVALID_INVOCATION = TIME_LOCK_SCOPE + 17;\n', '\n', '\n', '    // custom data structure to hold locked funds and time\n', '    struct accountData {\n', '        uint balance;\n', '        uint releaseTime;\n', '    }\n', '\n', '    // Should use interface of the emitter, but address of events history.\n', '    address public eventsHistory;\n', '\n', '    address asset;\n', '\n', '    accountData lock;\n', '\n', '    function Lockup6m_20180801(address _asset) {\n', '        asset = _asset;\n', '    }\n', '\n', '    /**\n', '     * Emits Error event with specified error message.\n', '     *\n', '     * Should only be used if no state changes happened.\n', '     *\n', '     * @param _errorCode code of an error\n', '     * @param _message error message.\n', '     */\n', '    function _error(uint _errorCode, bytes32 _message) internal returns(uint) {\n', '        DelayedPaymentsEmitter(eventsHistory).emitError(_message);\n', '        return _errorCode;\n', '    }\n', '\n', '    /**\n', '     * Sets EventsHstory contract address.\n', '     *\n', '     * Can be set only once, and only by contract owner.\n', '     *\n', '     * @param _eventsHistory MultiEventsHistory contract address.\n', '     *\n', '     * @return success.\n', '     */\n', '    function setupEventsHistory(address _eventsHistory) returns(uint errorCode) {\n', '        errorCode = checkOnlyContractOwner();\n', '        if (errorCode != OK) {\n', '            return errorCode;\n', '        }\n', '        if (eventsHistory != 0x0 && eventsHistory != _eventsHistory) {\n', '            return TIME_LOCK_INVALID_INVOCATION;\n', '        }\n', '        eventsHistory = _eventsHistory;\n', '        return OK;\n', '    }\n', '\n', '    function payIn() onlyContractOwner returns(uint errorCode) {\n', '        // send some amount (in Wei) when calling this function.\n', '        // the amount will then be placed in a locked account\n', '        // the funds will be released once the indicated lock time in seconds\n', '        // passed and can only be retrieved by the same account which was\n', '        // depositing them - highlighting the intrinsic security model\n', '        // offered by a blockchain system like Ethereum\n', '        uint amount = ERC20Interface(asset).balanceOf(this);\n', '        if(lock.balance != 0) {\n', '            if(lock.balance != amount) {\n', '                lock.balance = amount;\n', '                return OK;\n', '            }\n', '            return TIME_LOCK_INVALID_INVOCATION;\n', '        }\n', '        if (amount == 0) {\n', '            return TIME_LOCK_BALANCE_ERROR;\n', '        }\n', '        //1533081600 => 2018-08-01\n', '        lock = accountData(amount, 1533081600);\n', '        return OK;\n', '    }\n', '\n', '    function payOut(address _getter) onlyContractOwner returns(uint errorCode) {\n', '        // check if user has funds due for pay out because lock time is over\n', '        uint amount = lock.balance;\n', '        if (now < lock.releaseTime) {\n', '            return TIME_LOCK_TIMESTAMP_ERROR;\n', '        }\n', '        if (amount == 0) {\n', '            return TIME_LOCK_BALANCE_ERROR;\n', '        }\n', '        if(!ERC20Interface(asset).transfer(_getter,amount)) {\n', '            return TIME_LOCK_TRANSFER_ERROR;\n', '        } \n', '        selfdestruct(msg.sender);     \n', '        return OK;\n', '    }\n', '\n', '    function getLockedFunds() constant returns (uint) {\n', '        return lock.balance;\n', '    }\n', '    \n', '    function getLockedFundsReleaseTime() constant returns (uint) {\n', '\t    return lock.releaseTime;\n', '    }\n', '\n', '}']
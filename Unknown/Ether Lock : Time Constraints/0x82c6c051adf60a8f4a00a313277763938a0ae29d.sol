['pragma solidity ^0.4.11;\n', '\n', '// copyright <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="e685898892878592a683928e8394858e83979383c885898b">[email&#160;protected]</a>\n', '\n', 'contract EtherCheque {\n', '    enum Status { NONE, CREATED, LOCKED, EXPIRED }\n', '    enum ResultCode { \n', '        SUCCESS,\n', '        ERROR_MAX,\n', '        ERROR_MIN,\n', '        ERROR_EXIST,\n', '        ERROR_NOT_EXIST,\n', '        ERROR_INVALID_STATUS,\n', '        ERROR_LOCKED,\n', '        ERROR_EXPIRED,\n', '        ERROR_INVALID_AMOUNT\n', '    }\n', '    struct Cheque {\n', '        bytes32 pinHash; // we only save sha3 of cheque signature\n', '        address creator;\n', '        Status status;\n', '        uint value;\n', '        uint createTime;\n', '        uint expiringPeriod; // in seconds - optional, 0 mean no expire\n', '        uint8 attempt; // current attempt account to cash the cheque\n', '    }\n', '    address public owner;\n', '    address[] public moderators;\n', '    uint public totalCheque = 0;\n', '    uint public totalChequeValue = 0;\n', '    uint public totalRedeemedCheque = 0;\n', '    uint public totalRedeemedValue = 0;\n', '    uint public commissionFee = 10; // div 1000\n', '    uint public minChequeValue = 0.01 ether;\n', '    uint public maxChequeValue = 0; // optional, 0 mean no limit\n', '    uint8 public maxAttempt = 3;\n', '    bool public isMaintaining = false;\n', '    \n', '    // hash cheque no -> Cheque info\n', '    mapping(bytes32 => Cheque) items;\n', '\n', '    // modifier\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier isActive {\n', '        if(isMaintaining == true) throw;\n', '        _;\n', '    }\n', '    \n', '    modifier onlyModerators() {\n', '        if (msg.sender != owner) {\n', '            bool found = false;\n', '            for (uint index = 0; index < moderators.length; index++) {\n', '                if (moderators[index] == msg.sender) {\n', '                    found = true;\n', '                    break;\n', '                }\n', '            }\n', '            if (!found) throw;\n', '        }\n', '        _;\n', '    }\n', '    \n', '    function EtherCheque() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // event\n', '    event LogCreate(bytes32 indexed chequeIdHash, uint result, uint amount);\n', '    event LogRedeem(bytes32 indexed chequeIdHash, ResultCode result, uint amount, address receiver);\n', '    event LogWithdrawEther(address indexed sendTo, ResultCode result, uint amount);\n', '    event LogRefundCheque(bytes32 indexed chequeIdHash, ResultCode result);\n', '    \n', '    // owner function\n', '    function ChangeOwner(address _newOwner) onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '    \n', '    function Kill() onlyOwner {\n', '        suicide(owner);\n', '    }\n', '    \n', '    function AddModerator(address _newModerator) onlyOwner {\n', '        for (uint index = 0; index < moderators.length; index++) {\n', '            if (moderators[index] == _newModerator) {\n', '                return;\n', '            }\n', '        }\n', '        moderators.push(_newModerator);\n', '    }\n', '    \n', '    function RemoveModerator(address _oldModerator) onlyOwner {\n', '        uint foundIndex = 0;\n', '        for (; foundIndex < moderators.length; foundIndex++) {\n', '            if (moderators[foundIndex] == _oldModerator) {\n', '                break;\n', '            }\n', '        }\n', '        if (foundIndex < moderators.length)\n', '        {\n', '            moderators[foundIndex] = moderators[moderators.length-1];\n', '            delete moderators[moderators.length-1];\n', '            moderators.length--;\n', '        }\n', '    }\n', '    \n', '    // moderator function\n', '    function SetCommissionValue(uint _commissionFee) onlyModerators {\n', '        commissionFee = _commissionFee;\n', '    }\n', '    \n', '    function SetMinChequeValue(uint _minChequeValue) onlyModerators {\n', '        minChequeValue = _minChequeValue;\n', '    }\n', '    \n', '    function SetMaxChequeValue(uint _maxChequeValue) onlyModerators {\n', '        maxChequeValue = _maxChequeValue;\n', '    }\n', '    \n', '    function SetMaxAttempt(uint8 _maxAttempt) onlyModerators {\n', '        maxAttempt = _maxAttempt;\n', '    }\n', '    \n', '    function UpdateMaintenance(bool _isMaintaining) onlyModerators {\n', '        isMaintaining = _isMaintaining;\n', '    }\n', '    \n', '    function WithdrawEther(address _sendTo, uint _amount) onlyModerators returns(ResultCode) {\n', '        // can only can withdraw profit - unable to withdraw cheque value\n', '        uint currentProfit = this.balance - (totalChequeValue - totalRedeemedValue);\n', '        if (_amount > currentProfit) {\n', '            LogWithdrawEther(_sendTo, ResultCode.ERROR_INVALID_AMOUNT, 0);\n', '            return ResultCode.ERROR_INVALID_AMOUNT;\n', '        }\n', '        \n', '        _sendTo.transfer(_amount);\n', '        LogWithdrawEther(_sendTo, ResultCode.SUCCESS, _amount);\n', '        return ResultCode.SUCCESS;\n', '    }\n', '    \n', '    // only when creator wants to get the money back\n', '    // only can refund back to creator\n', '    function RefundChequeById(string _chequeId) onlyModerators returns(ResultCode) {\n', '        bytes32 hashChequeId = sha3(_chequeId);\n', '        Cheque cheque = items[hashChequeId];\n', '        if (cheque.status == Status.NONE) {\n', '            LogRefundCheque(hashChequeId, ResultCode.ERROR_NOT_EXIST);\n', '            return ResultCode.ERROR_NOT_EXIST;\n', '        }\n', '        \n', '        totalRedeemedCheque += 1;\n', '        totalRedeemedValue += cheque.value;\n', '        uint sendAmount = cheque.value;\n', '        delete items[hashChequeId];\n', '        cheque.creator.transfer(sendAmount);\n', '        LogRefundCheque(hashChequeId, ResultCode.SUCCESS);\n', '        return ResultCode.SUCCESS;\n', '    }\n', '\n', '    function RefundChequeByHash(uint256 _chequeIdHash) onlyModerators returns(ResultCode) {\n', '        bytes32 hashChequeId = bytes32(_chequeIdHash);\n', '        Cheque cheque = items[hashChequeId];\n', '        if (cheque.status == Status.NONE) {\n', '            LogRefundCheque(hashChequeId, ResultCode.ERROR_NOT_EXIST);\n', '            return ResultCode.ERROR_NOT_EXIST;\n', '        }\n', '        \n', '        totalRedeemedCheque += 1;\n', '        totalRedeemedValue += cheque.value;\n', '        uint sendAmount = cheque.value;\n', '        delete items[hashChequeId];\n', '        cheque.creator.transfer(sendAmount);\n', '        LogRefundCheque(hashChequeId, ResultCode.SUCCESS);\n', '        return ResultCode.SUCCESS;\n', '    }\n', '\n', '    function GetChequeInfoByHash(uint256 _chequeIdHash) onlyModerators constant returns(Status, uint, uint, uint) {\n', '        bytes32 hashChequeId = bytes32(_chequeIdHash);\n', '        Cheque cheque = items[hashChequeId];\n', '        if (cheque.status == Status.NONE) \n', '            return (Status.NONE, 0, 0, 0);\n', '\n', '        if (cheque.expiringPeriod > 0) {\n', '            uint timeGap = now;\n', '            if (timeGap > cheque.createTime)\n', '                timeGap = timeGap - cheque.createTime;\n', '            else\n', '                timeGap = 0;\n', '\n', '            if (cheque.expiringPeriod > timeGap)\n', '                return (cheque.status, cheque.value, cheque.attempt, cheque.expiringPeriod - timeGap);\n', '            else\n', '                return (Status.EXPIRED, cheque.value, cheque.attempt, 0);\n', '        }\n', '        return (cheque.status, cheque.value, cheque.attempt, 0);\n', '    }\n', '\n', '    function VerifyCheque(string _chequeId, string _pin) onlyModerators constant returns(ResultCode, Status, uint, uint, uint) {\n', '        bytes32 chequeIdHash = sha3(_chequeId);\n', '        Cheque cheque = items[chequeIdHash];\n', '        if (cheque.status == Status.NONE) {\n', '            return (ResultCode.ERROR_NOT_EXIST, Status.NONE, 0, 0, 0);\n', '        }\n', '        if (cheque.pinHash != sha3(_chequeId, _pin)) {\n', '            return (ResultCode.ERROR_INVALID_STATUS, Status.NONE, 0, 0, 0);\n', '        }\n', '        \n', '        return (ResultCode.SUCCESS, cheque.status, cheque.value, cheque.attempt, 0);\n', '    }\n', '    \n', '    // constant function\n', '    function GetChequeInfo(string _chequeId) constant returns(Status, uint, uint, uint) {\n', '        bytes32 hashChequeId = sha3(_chequeId);\n', '        Cheque cheque = items[hashChequeId];\n', '        if (cheque.status == Status.NONE) \n', '            return (Status.NONE, 0, 0, 0);\n', '\n', '        if (cheque.expiringPeriod > 0) {\n', '            uint timeGap = now;\n', '            if (timeGap > cheque.createTime)\n', '                timeGap = timeGap - cheque.createTime;\n', '            else\n', '                timeGap = 0;\n', '\n', '            if (cheque.expiringPeriod > timeGap)\n', '                return (cheque.status, cheque.value, cheque.attempt, cheque.expiringPeriod - timeGap);\n', '            else\n', '                return (Status.EXPIRED, cheque.value, cheque.attempt, 0);\n', '        }\n', '        return (cheque.status, cheque.value, cheque.attempt, 0);\n', '    }\n', '    \n', '    // transaction\n', '    function Create(uint256 _chequeIdHash, uint256 _pinHash, uint32 _expiringPeriod) payable isActive returns(ResultCode) {\n', '        // condition: \n', '        // 1. check min value\n', '        // 2. check _chequeId exist or not\n', '        bytes32 chequeIdHash = bytes32(_chequeIdHash);\n', '        bytes32 pinHash = bytes32(_pinHash);\n', '        uint chequeValue = 0;\n', '        if (msg.value < minChequeValue) {\n', '            msg.sender.transfer(msg.value);\n', '            LogCreate(chequeIdHash, uint(ResultCode.ERROR_MIN), chequeValue);\n', '            return ResultCode.ERROR_MIN;\n', '        }\n', '        if (maxChequeValue > 0 && msg.value > maxChequeValue) {\n', '            msg.sender.transfer(msg.value);\n', '            LogCreate(chequeIdHash, uint(ResultCode.ERROR_MAX), chequeValue);\n', '            return ResultCode.ERROR_MAX;\n', '        }\n', '        if (items[chequeIdHash].status != Status.NONE) {\n', '            msg.sender.transfer(msg.value);\n', '            LogCreate(chequeIdHash, uint(ResultCode.ERROR_EXIST), chequeValue);\n', '            return ResultCode.ERROR_EXIST;\n', '        }\n', '        \n', '        // deduct commission\n', '        chequeValue = (msg.value / 1000) * (1000 - commissionFee);\n', '        totalCheque += 1;\n', '        totalChequeValue += chequeValue;\n', '        items[chequeIdHash] = Cheque({\n', '            pinHash: pinHash,\n', '            creator: msg.sender,\n', '            status: Status.CREATED,\n', '            value: chequeValue,\n', '            createTime: now,\n', '            expiringPeriod: _expiringPeriod,\n', '            attempt: 0\n', '        });\n', '        \n', '        LogCreate(chequeIdHash, uint(ResultCode.SUCCESS), chequeValue);\n', '        return ResultCode.SUCCESS;\n', '    }\n', '    \n', '    function Redeem(string _chequeId, string _pin, address _sendTo) payable returns (ResultCode){\n', '        // condition\n', '        // 1. cheque status must exist\n', '        // 2. cheque status must be CREATED status for non-creator\n', '        // 3. verify attempt and expiry time for non-creator\n', '        bytes32 chequeIdHash = sha3(_chequeId);\n', '        Cheque cheque = items[chequeIdHash];\n', '        if (cheque.status == Status.NONE) {\n', '            LogRedeem(chequeIdHash, ResultCode.ERROR_NOT_EXIST, 0, _sendTo);\n', '            return ResultCode.ERROR_NOT_EXIST;\n', '        }\n', '        if (msg.sender != cheque.creator) {\n', '            if (cheque.status != Status.CREATED) {\n', '                LogRedeem(chequeIdHash, ResultCode.ERROR_INVALID_STATUS, 0, _sendTo);\n', '                return ResultCode.ERROR_INVALID_STATUS;\n', '            }\n', '            if (cheque.attempt > maxAttempt) {\n', '                LogRedeem(chequeIdHash, ResultCode.ERROR_LOCKED, 0, _sendTo);\n', '                return ResultCode.ERROR_LOCKED;\n', '            }\n', '            if (cheque.expiringPeriod > 0 && now > (cheque.createTime + cheque.expiringPeriod)) {\n', '                LogRedeem(chequeIdHash, ResultCode.ERROR_EXPIRED, 0, _sendTo);\n', '                return ResultCode.ERROR_EXPIRED;\n', '            }\n', '        }\n', '        \n', '        // check pin\n', '        if (cheque.pinHash != sha3(_chequeId, _pin)) {\n', '            cheque.attempt += 1;\n', '            LogRedeem(chequeIdHash, ResultCode.ERROR_INVALID_STATUS, 0, _sendTo);\n', '            return ResultCode.ERROR_INVALID_STATUS;\n', '        }\n', '        \n', '        totalRedeemedCheque += 1;\n', '        totalRedeemedValue += cheque.value;\n', '        uint sendMount = cheque.value;\n', '        delete items[chequeIdHash];\n', '        _sendTo.transfer(sendMount);\n', '        LogRedeem(chequeIdHash, ResultCode.SUCCESS, sendMount, _sendTo);\n', '        return ResultCode.SUCCESS;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '// copyright contact@ethercheque.com\n', '\n', 'contract EtherCheque {\n', '    enum Status { NONE, CREATED, LOCKED, EXPIRED }\n', '    enum ResultCode { \n', '        SUCCESS,\n', '        ERROR_MAX,\n', '        ERROR_MIN,\n', '        ERROR_EXIST,\n', '        ERROR_NOT_EXIST,\n', '        ERROR_INVALID_STATUS,\n', '        ERROR_LOCKED,\n', '        ERROR_EXPIRED,\n', '        ERROR_INVALID_AMOUNT\n', '    }\n', '    struct Cheque {\n', '        bytes32 pinHash; // we only save sha3 of cheque signature\n', '        address creator;\n', '        Status status;\n', '        uint value;\n', '        uint createTime;\n', '        uint expiringPeriod; // in seconds - optional, 0 mean no expire\n', '        uint8 attempt; // current attempt account to cash the cheque\n', '    }\n', '    address public owner;\n', '    address[] public moderators;\n', '    uint public totalCheque = 0;\n', '    uint public totalChequeValue = 0;\n', '    uint public totalRedeemedCheque = 0;\n', '    uint public totalRedeemedValue = 0;\n', '    uint public commissionFee = 10; // div 1000\n', '    uint public minChequeValue = 0.01 ether;\n', '    uint public maxChequeValue = 0; // optional, 0 mean no limit\n', '    uint8 public maxAttempt = 3;\n', '    bool public isMaintaining = false;\n', '    \n', '    // hash cheque no -> Cheque info\n', '    mapping(bytes32 => Cheque) items;\n', '\n', '    // modifier\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier isActive {\n', '        if(isMaintaining == true) throw;\n', '        _;\n', '    }\n', '    \n', '    modifier onlyModerators() {\n', '        if (msg.sender != owner) {\n', '            bool found = false;\n', '            for (uint index = 0; index < moderators.length; index++) {\n', '                if (moderators[index] == msg.sender) {\n', '                    found = true;\n', '                    break;\n', '                }\n', '            }\n', '            if (!found) throw;\n', '        }\n', '        _;\n', '    }\n', '    \n', '    function EtherCheque() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // event\n', '    event LogCreate(bytes32 indexed chequeIdHash, uint result, uint amount);\n', '    event LogRedeem(bytes32 indexed chequeIdHash, ResultCode result, uint amount, address receiver);\n', '    event LogWithdrawEther(address indexed sendTo, ResultCode result, uint amount);\n', '    event LogRefundCheque(bytes32 indexed chequeIdHash, ResultCode result);\n', '    \n', '    // owner function\n', '    function ChangeOwner(address _newOwner) onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '    \n', '    function Kill() onlyOwner {\n', '        suicide(owner);\n', '    }\n', '    \n', '    function AddModerator(address _newModerator) onlyOwner {\n', '        for (uint index = 0; index < moderators.length; index++) {\n', '            if (moderators[index] == _newModerator) {\n', '                return;\n', '            }\n', '        }\n', '        moderators.push(_newModerator);\n', '    }\n', '    \n', '    function RemoveModerator(address _oldModerator) onlyOwner {\n', '        uint foundIndex = 0;\n', '        for (; foundIndex < moderators.length; foundIndex++) {\n', '            if (moderators[foundIndex] == _oldModerator) {\n', '                break;\n', '            }\n', '        }\n', '        if (foundIndex < moderators.length)\n', '        {\n', '            moderators[foundIndex] = moderators[moderators.length-1];\n', '            delete moderators[moderators.length-1];\n', '            moderators.length--;\n', '        }\n', '    }\n', '    \n', '    // moderator function\n', '    function SetCommissionValue(uint _commissionFee) onlyModerators {\n', '        commissionFee = _commissionFee;\n', '    }\n', '    \n', '    function SetMinChequeValue(uint _minChequeValue) onlyModerators {\n', '        minChequeValue = _minChequeValue;\n', '    }\n', '    \n', '    function SetMaxChequeValue(uint _maxChequeValue) onlyModerators {\n', '        maxChequeValue = _maxChequeValue;\n', '    }\n', '    \n', '    function SetMaxAttempt(uint8 _maxAttempt) onlyModerators {\n', '        maxAttempt = _maxAttempt;\n', '    }\n', '    \n', '    function UpdateMaintenance(bool _isMaintaining) onlyModerators {\n', '        isMaintaining = _isMaintaining;\n', '    }\n', '    \n', '    function WithdrawEther(address _sendTo, uint _amount) onlyModerators returns(ResultCode) {\n', '        // can only can withdraw profit - unable to withdraw cheque value\n', '        uint currentProfit = this.balance - (totalChequeValue - totalRedeemedValue);\n', '        if (_amount > currentProfit) {\n', '            LogWithdrawEther(_sendTo, ResultCode.ERROR_INVALID_AMOUNT, 0);\n', '            return ResultCode.ERROR_INVALID_AMOUNT;\n', '        }\n', '        \n', '        _sendTo.transfer(_amount);\n', '        LogWithdrawEther(_sendTo, ResultCode.SUCCESS, _amount);\n', '        return ResultCode.SUCCESS;\n', '    }\n', '    \n', '    // only when creator wants to get the money back\n', '    // only can refund back to creator\n', '    function RefundChequeById(string _chequeId) onlyModerators returns(ResultCode) {\n', '        bytes32 hashChequeId = sha3(_chequeId);\n', '        Cheque cheque = items[hashChequeId];\n', '        if (cheque.status == Status.NONE) {\n', '            LogRefundCheque(hashChequeId, ResultCode.ERROR_NOT_EXIST);\n', '            return ResultCode.ERROR_NOT_EXIST;\n', '        }\n', '        \n', '        totalRedeemedCheque += 1;\n', '        totalRedeemedValue += cheque.value;\n', '        uint sendAmount = cheque.value;\n', '        delete items[hashChequeId];\n', '        cheque.creator.transfer(sendAmount);\n', '        LogRefundCheque(hashChequeId, ResultCode.SUCCESS);\n', '        return ResultCode.SUCCESS;\n', '    }\n', '\n', '    function RefundChequeByHash(uint256 _chequeIdHash) onlyModerators returns(ResultCode) {\n', '        bytes32 hashChequeId = bytes32(_chequeIdHash);\n', '        Cheque cheque = items[hashChequeId];\n', '        if (cheque.status == Status.NONE) {\n', '            LogRefundCheque(hashChequeId, ResultCode.ERROR_NOT_EXIST);\n', '            return ResultCode.ERROR_NOT_EXIST;\n', '        }\n', '        \n', '        totalRedeemedCheque += 1;\n', '        totalRedeemedValue += cheque.value;\n', '        uint sendAmount = cheque.value;\n', '        delete items[hashChequeId];\n', '        cheque.creator.transfer(sendAmount);\n', '        LogRefundCheque(hashChequeId, ResultCode.SUCCESS);\n', '        return ResultCode.SUCCESS;\n', '    }\n', '\n', '    function GetChequeInfoByHash(uint256 _chequeIdHash) onlyModerators constant returns(Status, uint, uint, uint) {\n', '        bytes32 hashChequeId = bytes32(_chequeIdHash);\n', '        Cheque cheque = items[hashChequeId];\n', '        if (cheque.status == Status.NONE) \n', '            return (Status.NONE, 0, 0, 0);\n', '\n', '        if (cheque.expiringPeriod > 0) {\n', '            uint timeGap = now;\n', '            if (timeGap > cheque.createTime)\n', '                timeGap = timeGap - cheque.createTime;\n', '            else\n', '                timeGap = 0;\n', '\n', '            if (cheque.expiringPeriod > timeGap)\n', '                return (cheque.status, cheque.value, cheque.attempt, cheque.expiringPeriod - timeGap);\n', '            else\n', '                return (Status.EXPIRED, cheque.value, cheque.attempt, 0);\n', '        }\n', '        return (cheque.status, cheque.value, cheque.attempt, 0);\n', '    }\n', '\n', '    function VerifyCheque(string _chequeId, string _pin) onlyModerators constant returns(ResultCode, Status, uint, uint, uint) {\n', '        bytes32 chequeIdHash = sha3(_chequeId);\n', '        Cheque cheque = items[chequeIdHash];\n', '        if (cheque.status == Status.NONE) {\n', '            return (ResultCode.ERROR_NOT_EXIST, Status.NONE, 0, 0, 0);\n', '        }\n', '        if (cheque.pinHash != sha3(_chequeId, _pin)) {\n', '            return (ResultCode.ERROR_INVALID_STATUS, Status.NONE, 0, 0, 0);\n', '        }\n', '        \n', '        return (ResultCode.SUCCESS, cheque.status, cheque.value, cheque.attempt, 0);\n', '    }\n', '    \n', '    // constant function\n', '    function GetChequeInfo(string _chequeId) constant returns(Status, uint, uint, uint) {\n', '        bytes32 hashChequeId = sha3(_chequeId);\n', '        Cheque cheque = items[hashChequeId];\n', '        if (cheque.status == Status.NONE) \n', '            return (Status.NONE, 0, 0, 0);\n', '\n', '        if (cheque.expiringPeriod > 0) {\n', '            uint timeGap = now;\n', '            if (timeGap > cheque.createTime)\n', '                timeGap = timeGap - cheque.createTime;\n', '            else\n', '                timeGap = 0;\n', '\n', '            if (cheque.expiringPeriod > timeGap)\n', '                return (cheque.status, cheque.value, cheque.attempt, cheque.expiringPeriod - timeGap);\n', '            else\n', '                return (Status.EXPIRED, cheque.value, cheque.attempt, 0);\n', '        }\n', '        return (cheque.status, cheque.value, cheque.attempt, 0);\n', '    }\n', '    \n', '    // transaction\n', '    function Create(uint256 _chequeIdHash, uint256 _pinHash, uint32 _expiringPeriod) payable isActive returns(ResultCode) {\n', '        // condition: \n', '        // 1. check min value\n', '        // 2. check _chequeId exist or not\n', '        bytes32 chequeIdHash = bytes32(_chequeIdHash);\n', '        bytes32 pinHash = bytes32(_pinHash);\n', '        uint chequeValue = 0;\n', '        if (msg.value < minChequeValue) {\n', '            msg.sender.transfer(msg.value);\n', '            LogCreate(chequeIdHash, uint(ResultCode.ERROR_MIN), chequeValue);\n', '            return ResultCode.ERROR_MIN;\n', '        }\n', '        if (maxChequeValue > 0 && msg.value > maxChequeValue) {\n', '            msg.sender.transfer(msg.value);\n', '            LogCreate(chequeIdHash, uint(ResultCode.ERROR_MAX), chequeValue);\n', '            return ResultCode.ERROR_MAX;\n', '        }\n', '        if (items[chequeIdHash].status != Status.NONE) {\n', '            msg.sender.transfer(msg.value);\n', '            LogCreate(chequeIdHash, uint(ResultCode.ERROR_EXIST), chequeValue);\n', '            return ResultCode.ERROR_EXIST;\n', '        }\n', '        \n', '        // deduct commission\n', '        chequeValue = (msg.value / 1000) * (1000 - commissionFee);\n', '        totalCheque += 1;\n', '        totalChequeValue += chequeValue;\n', '        items[chequeIdHash] = Cheque({\n', '            pinHash: pinHash,\n', '            creator: msg.sender,\n', '            status: Status.CREATED,\n', '            value: chequeValue,\n', '            createTime: now,\n', '            expiringPeriod: _expiringPeriod,\n', '            attempt: 0\n', '        });\n', '        \n', '        LogCreate(chequeIdHash, uint(ResultCode.SUCCESS), chequeValue);\n', '        return ResultCode.SUCCESS;\n', '    }\n', '    \n', '    function Redeem(string _chequeId, string _pin, address _sendTo) payable returns (ResultCode){\n', '        // condition\n', '        // 1. cheque status must exist\n', '        // 2. cheque status must be CREATED status for non-creator\n', '        // 3. verify attempt and expiry time for non-creator\n', '        bytes32 chequeIdHash = sha3(_chequeId);\n', '        Cheque cheque = items[chequeIdHash];\n', '        if (cheque.status == Status.NONE) {\n', '            LogRedeem(chequeIdHash, ResultCode.ERROR_NOT_EXIST, 0, _sendTo);\n', '            return ResultCode.ERROR_NOT_EXIST;\n', '        }\n', '        if (msg.sender != cheque.creator) {\n', '            if (cheque.status != Status.CREATED) {\n', '                LogRedeem(chequeIdHash, ResultCode.ERROR_INVALID_STATUS, 0, _sendTo);\n', '                return ResultCode.ERROR_INVALID_STATUS;\n', '            }\n', '            if (cheque.attempt > maxAttempt) {\n', '                LogRedeem(chequeIdHash, ResultCode.ERROR_LOCKED, 0, _sendTo);\n', '                return ResultCode.ERROR_LOCKED;\n', '            }\n', '            if (cheque.expiringPeriod > 0 && now > (cheque.createTime + cheque.expiringPeriod)) {\n', '                LogRedeem(chequeIdHash, ResultCode.ERROR_EXPIRED, 0, _sendTo);\n', '                return ResultCode.ERROR_EXPIRED;\n', '            }\n', '        }\n', '        \n', '        // check pin\n', '        if (cheque.pinHash != sha3(_chequeId, _pin)) {\n', '            cheque.attempt += 1;\n', '            LogRedeem(chequeIdHash, ResultCode.ERROR_INVALID_STATUS, 0, _sendTo);\n', '            return ResultCode.ERROR_INVALID_STATUS;\n', '        }\n', '        \n', '        totalRedeemedCheque += 1;\n', '        totalRedeemedValue += cheque.value;\n', '        uint sendMount = cheque.value;\n', '        delete items[chequeIdHash];\n', '        _sendTo.transfer(sendMount);\n', '        LogRedeem(chequeIdHash, ResultCode.SUCCESS, sendMount, _sendTo);\n', '        return ResultCode.SUCCESS;\n', '    }\n', '\n', '}']

['pragma solidity ^0.4.11;\n', '\n', '\n', 'contract Announcement {\n', '\n', '    struct Message {\n', '        string ipfsHash;\n', '        uint256 timestamp;\n', '    }\n', '\n', '    struct MessageAwaitingAudit {\n', '        uint256 nAudits;\n', '        uint256 nAlarms;\n', '        Message msg;\n', '        mapping (address => bool) auditedBy;\n', '        mapping (address => bool) alarmedBy;\n', '    }\n', '\n', '    address public owner;\n', '    mapping(address => bool) public auditors;\n', '    address[] public auditorsList;\n', '    uint256 public nAuditors;\n', '    uint256 public nAuditorsRequired = 1;\n', '    uint256 public nAuditorsAlarm = 1;\n', '    uint256 public nAlarms = 0;\n', '    uint256[] public alarms;\n', '    mapping(uint256 => bool) public alarmRaised;\n', '\n', '    uint256 public nMsg = 0;\n', '    mapping(uint256 => Message) public msgMap;\n', '\n', '    uint256 public nMsgsWaiting = 0;\n', '    mapping(uint256 => MessageAwaitingAudit) msgsWaiting;\n', '    mapping(uint256 => bool) public msgsWaitingDone;\n', '\n', '\n', '    modifier isOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier isAuditor() {\n', '        require(auditors[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '\n', '    function Announcement(address[] _auditors, uint256 _nAuditorsRequired, uint256 _nAuditorsAlarm) {\n', '        require(_nAuditorsRequired >= 1);\n', '        require(_nAuditorsAlarm >= 1);\n', '\n', '        for (uint256 i = 0; i < _auditors.length; i++) {\n', '            auditors[_auditors[i]] = true;\n', '            auditorsList.push(_auditors[i]);\n', '        }\n', '        nAuditors = _auditors.length;\n', '\n', '        owner = msg.sender;\n', '        nAuditorsRequired = _nAuditorsRequired;\n', '        nAuditorsAlarm = _nAuditorsAlarm;\n', '    }\n', '\n', '    function addAnn (string ipfsHash) isOwner external {\n', '        require(bytes(ipfsHash).length > 0);\n', '        msgQPut(ipfsHash);\n', '    }\n', '\n', '    function msgQPut (string ipfsHash) private {\n', '        createNewMsgAwaitingAudit(ipfsHash, block.timestamp);\n', '    }\n', '\n', '    function addAudit (uint256 msgWaitingN, bool msgGood) isAuditor external {\n', '        // ensure the msgWaiting is not done, and that this auditor has not submitted an audit previously\n', '        require(msgsWaitingDone[msgWaitingN] == false);\n', '        MessageAwaitingAudit msgWaiting = msgsWaiting[msgWaitingN];\n', '        require(msgWaiting.auditedBy[msg.sender] == false);\n', '        require(msgWaiting.alarmedBy[msg.sender] == false);\n', '        require(alarmRaised[msgWaitingN] == false);\n', '\n', '        // check if the auditor is giving a thumbs up or a thumbs down and adjust things appropriately\n', '        if (msgGood == true) {\n', '            msgWaiting.nAudits += 1;\n', '            msgWaiting.auditedBy[msg.sender] = true;\n', '        } else {\n', '            msgWaiting.nAlarms += 1;\n', '            msgWaiting.alarmedBy[msg.sender] = true;\n', '        }\n', '\n', '        // have we reached the right number of auditors and not triggered an alarm?\n', '        if (msgWaiting.nAudits >= nAuditorsRequired && msgWaiting.nAlarms < nAuditorsAlarm) {\n', '            // then remove msg from queue and add to messages\n', '            addMsgFinal(msgWaiting.msg, msgWaitingN);\n', '        } else if (msgWaiting.nAlarms >= nAuditorsAlarm) {\n', '            msgsWaitingDone[msgWaitingN] = true;\n', '            alarmRaised[msgWaitingN] = true;\n', '            alarms.push(msgWaitingN);\n', '            nAlarms += 1;\n', '        }\n', '    }\n', '\n', '    function createNewMsgAwaitingAudit(string ipfsHash, uint256 timestamp) private {\n', '        msgsWaiting[nMsgsWaiting] = MessageAwaitingAudit(0, 0, Message(ipfsHash, timestamp));\n', '        nMsgsWaiting += 1;\n', '    }\n', '\n', '    function addMsgFinal(Message msg, uint256 msgWaitingN) private {\n', '        // ensure we store the message first\n', '        msgMap[nMsg] = msg;\n', '        nMsg += 1;\n', '\n', '        // finally note that this has been processed and clean up\n', '        msgsWaitingDone[msgWaitingN] = true;\n', '        delete msgsWaiting[msgWaitingN];\n', '    }\n', '\n', '    function getMsgWaiting(uint256 msgWaitingN) constant external returns (uint256, uint256, string, uint256, bool) {\n', '        MessageAwaitingAudit maa = msgsWaiting[msgWaitingN];\n', '        return (\n', '            maa.nAudits,\n', '            maa.nAlarms,\n', '            maa.msg.ipfsHash,\n', '            maa.msg.timestamp,\n', '            alarmRaised[msgWaitingN]\n', '        );\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '\n', 'contract Announcement {\n', '\n', '    struct Message {\n', '        string ipfsHash;\n', '        uint256 timestamp;\n', '    }\n', '\n', '    struct MessageAwaitingAudit {\n', '        uint256 nAudits;\n', '        uint256 nAlarms;\n', '        Message msg;\n', '        mapping (address => bool) auditedBy;\n', '        mapping (address => bool) alarmedBy;\n', '    }\n', '\n', '    address public owner;\n', '    mapping(address => bool) public auditors;\n', '    address[] public auditorsList;\n', '    uint256 public nAuditors;\n', '    uint256 public nAuditorsRequired = 1;\n', '    uint256 public nAuditorsAlarm = 1;\n', '    uint256 public nAlarms = 0;\n', '    uint256[] public alarms;\n', '    mapping(uint256 => bool) public alarmRaised;\n', '\n', '    uint256 public nMsg = 0;\n', '    mapping(uint256 => Message) public msgMap;\n', '\n', '    uint256 public nMsgsWaiting = 0;\n', '    mapping(uint256 => MessageAwaitingAudit) msgsWaiting;\n', '    mapping(uint256 => bool) public msgsWaitingDone;\n', '\n', '\n', '    modifier isOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier isAuditor() {\n', '        require(auditors[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '\n', '    function Announcement(address[] _auditors, uint256 _nAuditorsRequired, uint256 _nAuditorsAlarm) {\n', '        require(_nAuditorsRequired >= 1);\n', '        require(_nAuditorsAlarm >= 1);\n', '\n', '        for (uint256 i = 0; i < _auditors.length; i++) {\n', '            auditors[_auditors[i]] = true;\n', '            auditorsList.push(_auditors[i]);\n', '        }\n', '        nAuditors = _auditors.length;\n', '\n', '        owner = msg.sender;\n', '        nAuditorsRequired = _nAuditorsRequired;\n', '        nAuditorsAlarm = _nAuditorsAlarm;\n', '    }\n', '\n', '    function addAnn (string ipfsHash) isOwner external {\n', '        require(bytes(ipfsHash).length > 0);\n', '        msgQPut(ipfsHash);\n', '    }\n', '\n', '    function msgQPut (string ipfsHash) private {\n', '        createNewMsgAwaitingAudit(ipfsHash, block.timestamp);\n', '    }\n', '\n', '    function addAudit (uint256 msgWaitingN, bool msgGood) isAuditor external {\n', '        // ensure the msgWaiting is not done, and that this auditor has not submitted an audit previously\n', '        require(msgsWaitingDone[msgWaitingN] == false);\n', '        MessageAwaitingAudit msgWaiting = msgsWaiting[msgWaitingN];\n', '        require(msgWaiting.auditedBy[msg.sender] == false);\n', '        require(msgWaiting.alarmedBy[msg.sender] == false);\n', '        require(alarmRaised[msgWaitingN] == false);\n', '\n', '        // check if the auditor is giving a thumbs up or a thumbs down and adjust things appropriately\n', '        if (msgGood == true) {\n', '            msgWaiting.nAudits += 1;\n', '            msgWaiting.auditedBy[msg.sender] = true;\n', '        } else {\n', '            msgWaiting.nAlarms += 1;\n', '            msgWaiting.alarmedBy[msg.sender] = true;\n', '        }\n', '\n', '        // have we reached the right number of auditors and not triggered an alarm?\n', '        if (msgWaiting.nAudits >= nAuditorsRequired && msgWaiting.nAlarms < nAuditorsAlarm) {\n', '            // then remove msg from queue and add to messages\n', '            addMsgFinal(msgWaiting.msg, msgWaitingN);\n', '        } else if (msgWaiting.nAlarms >= nAuditorsAlarm) {\n', '            msgsWaitingDone[msgWaitingN] = true;\n', '            alarmRaised[msgWaitingN] = true;\n', '            alarms.push(msgWaitingN);\n', '            nAlarms += 1;\n', '        }\n', '    }\n', '\n', '    function createNewMsgAwaitingAudit(string ipfsHash, uint256 timestamp) private {\n', '        msgsWaiting[nMsgsWaiting] = MessageAwaitingAudit(0, 0, Message(ipfsHash, timestamp));\n', '        nMsgsWaiting += 1;\n', '    }\n', '\n', '    function addMsgFinal(Message msg, uint256 msgWaitingN) private {\n', '        // ensure we store the message first\n', '        msgMap[nMsg] = msg;\n', '        nMsg += 1;\n', '\n', '        // finally note that this has been processed and clean up\n', '        msgsWaitingDone[msgWaitingN] = true;\n', '        delete msgsWaiting[msgWaitingN];\n', '    }\n', '\n', '    function getMsgWaiting(uint256 msgWaitingN) constant external returns (uint256, uint256, string, uint256, bool) {\n', '        MessageAwaitingAudit maa = msgsWaiting[msgWaitingN];\n', '        return (\n', '            maa.nAudits,\n', '            maa.nAlarms,\n', '            maa.msg.ipfsHash,\n', '            maa.msg.timestamp,\n', '            alarmRaised[msgWaitingN]\n', '        );\n', '    }\n', '}']

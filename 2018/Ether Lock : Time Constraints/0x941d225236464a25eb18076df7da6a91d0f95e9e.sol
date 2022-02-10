['pragma solidity ^0.4.19;\n', '\n', 'contract ETH_FUND\n', '{\n', '    mapping (address => uint) public balances;\n', '    \n', '    uint public MinDeposit = 1 ether;\n', '    \n', '    Log TransferLog;\n', '    \n', '    uint lastBlock;\n', '    \n', '    function ETH_FUND(address _log)\n', '    public \n', '    {\n', '        TransferLog = Log(_log);\n', '    }\n', '    \n', '    function Deposit()\n', '    public\n', '    payable\n', '    {\n', '        if(msg.value > MinDeposit)\n', '        {\n', '            balances[msg.sender]+=msg.value;\n', '            TransferLog.AddMessage(msg.sender,msg.value,"Deposit");\n', '            lastBlock = block.number;\n', '        }\n', '    }\n', '    \n', '    function CashOut(uint _am)\n', '    public\n', '    payable\n', '    {\n', '        if(_am<=balances[msg.sender]&&block.number>lastBlock)\n', '        {\n', '            if(msg.sender.call.value(_am)())\n', '            {\n', '                balances[msg.sender]-=_am;\n', '                TransferLog.AddMessage(msg.sender,_am,"CashOut");\n', '            }\n', '        }\n', '    }\n', '    \n', '    function() public payable{}    \n', '    \n', '}\n', '\n', 'contract Log \n', '{\n', '   \n', '    struct Message\n', '    {\n', '        address Sender;\n', '        string  Data;\n', '        uint Val;\n', '        uint  Time;\n', '    }\n', '    \n', '    Message[] public History;\n', '    \n', '    Message LastMsg;\n', '    \n', '    function AddMessage(address _adr,uint _val,string _data)\n', '    public\n', '    {\n', '        LastMsg.Sender = _adr;\n', '        LastMsg.Time = now;\n', '        LastMsg.Val = _val;\n', '        LastMsg.Data = _data;\n', '        History.push(LastMsg);\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract ETH_FUND\n', '{\n', '    mapping (address => uint) public balances;\n', '    \n', '    uint public MinDeposit = 1 ether;\n', '    \n', '    Log TransferLog;\n', '    \n', '    uint lastBlock;\n', '    \n', '    function ETH_FUND(address _log)\n', '    public \n', '    {\n', '        TransferLog = Log(_log);\n', '    }\n', '    \n', '    function Deposit()\n', '    public\n', '    payable\n', '    {\n', '        if(msg.value > MinDeposit)\n', '        {\n', '            balances[msg.sender]+=msg.value;\n', '            TransferLog.AddMessage(msg.sender,msg.value,"Deposit");\n', '            lastBlock = block.number;\n', '        }\n', '    }\n', '    \n', '    function CashOut(uint _am)\n', '    public\n', '    payable\n', '    {\n', '        if(_am<=balances[msg.sender]&&block.number>lastBlock)\n', '        {\n', '            if(msg.sender.call.value(_am)())\n', '            {\n', '                balances[msg.sender]-=_am;\n', '                TransferLog.AddMessage(msg.sender,_am,"CashOut");\n', '            }\n', '        }\n', '    }\n', '    \n', '    function() public payable{}    \n', '    \n', '}\n', '\n', 'contract Log \n', '{\n', '   \n', '    struct Message\n', '    {\n', '        address Sender;\n', '        string  Data;\n', '        uint Val;\n', '        uint  Time;\n', '    }\n', '    \n', '    Message[] public History;\n', '    \n', '    Message LastMsg;\n', '    \n', '    function AddMessage(address _adr,uint _val,string _data)\n', '    public\n', '    {\n', '        LastMsg.Sender = _adr;\n', '        LastMsg.Time = now;\n', '        LastMsg.Val = _val;\n', '        LastMsg.Data = _data;\n', '        History.push(LastMsg);\n', '    }\n', '}']
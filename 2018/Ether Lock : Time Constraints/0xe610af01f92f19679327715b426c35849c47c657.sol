['pragma solidity ^0.4.19;\n', '\n', 'contract PIGGY_BANK\n', '{\n', '    mapping (address => uint) public Accounts;\n', '    \n', '    uint public MinSum = 1 ether;\n', '    \n', '    Log LogFile;\n', '    \n', '    uint putBlock;\n', '    \n', '    function PIGGY_BANK(address _log)\n', '    public \n', '    {\n', '        LogFile = Log(_log);\n', '    }\n', '    \n', '    function Put(address to)\n', '    public\n', '    payable\n', '    {\n', '        Accounts[to]+=msg.value;\n', '        LogFile.AddMessage(msg.sender,msg.value,"Put");\n', '        putBlock = block.number;\n', '    }\n', '    \n', '    function Collect(uint _am)\n', '    public\n', '    payable\n', '    {\n', '        if(Accounts[msg.sender]>=MinSum && _am<=Accounts[msg.sender] && block.number>putBlock)\n', '        {\n', '            if(msg.sender.call.value(_am)())\n', '            {\n', '                Accounts[msg.sender]-=_am;\n', '                LogFile.AddMessage(msg.sender,_am,"Collect");\n', '            }\n', '        }\n', '    }\n', '    \n', '    function() \n', '    public \n', '    payable\n', '    {\n', '        Put(msg.sender);\n', '    }    \n', '    \n', '}\n', '\n', 'contract Log \n', '{\n', '    struct Message\n', '    {\n', '        address Sender;\n', '        string  Data;\n', '        uint Val;\n', '        uint  Time;\n', '    }\n', '    \n', '    Message[] public History;\n', '    \n', '    Message LastMsg;\n', '    \n', '    function AddMessage(address _adr,uint _val,string _data)\n', '    public\n', '    {\n', '        LastMsg.Sender = _adr;\n', '        LastMsg.Time = now;\n', '        LastMsg.Val = _val;\n', '        LastMsg.Data = _data;\n', '        History.push(LastMsg);\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract PIGGY_BANK\n', '{\n', '    mapping (address => uint) public Accounts;\n', '    \n', '    uint public MinSum = 1 ether;\n', '    \n', '    Log LogFile;\n', '    \n', '    uint putBlock;\n', '    \n', '    function PIGGY_BANK(address _log)\n', '    public \n', '    {\n', '        LogFile = Log(_log);\n', '    }\n', '    \n', '    function Put(address to)\n', '    public\n', '    payable\n', '    {\n', '        Accounts[to]+=msg.value;\n', '        LogFile.AddMessage(msg.sender,msg.value,"Put");\n', '        putBlock = block.number;\n', '    }\n', '    \n', '    function Collect(uint _am)\n', '    public\n', '    payable\n', '    {\n', '        if(Accounts[msg.sender]>=MinSum && _am<=Accounts[msg.sender] && block.number>putBlock)\n', '        {\n', '            if(msg.sender.call.value(_am)())\n', '            {\n', '                Accounts[msg.sender]-=_am;\n', '                LogFile.AddMessage(msg.sender,_am,"Collect");\n', '            }\n', '        }\n', '    }\n', '    \n', '    function() \n', '    public \n', '    payable\n', '    {\n', '        Put(msg.sender);\n', '    }    \n', '    \n', '}\n', '\n', 'contract Log \n', '{\n', '    struct Message\n', '    {\n', '        address Sender;\n', '        string  Data;\n', '        uint Val;\n', '        uint  Time;\n', '    }\n', '    \n', '    Message[] public History;\n', '    \n', '    Message LastMsg;\n', '    \n', '    function AddMessage(address _adr,uint _val,string _data)\n', '    public\n', '    {\n', '        LastMsg.Sender = _adr;\n', '        LastMsg.Time = now;\n', '        LastMsg.Val = _val;\n', '        LastMsg.Data = _data;\n', '        History.push(LastMsg);\n', '    }\n', '}']
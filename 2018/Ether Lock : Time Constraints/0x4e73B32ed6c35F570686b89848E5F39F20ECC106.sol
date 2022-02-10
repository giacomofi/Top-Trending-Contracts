['pragma solidity ^0.4.19;\n', '\n', 'contract PRIVATE_ETH_CELL\n', '{\n', '    mapping (address=>uint256) public balances;   \n', '   \n', '    uint public MinSum;\n', '    \n', '    LogFile Log;\n', '    \n', '    bool intitalized;\n', '    \n', '    function SetMinSum(uint _val)\n', '    public\n', '    {\n', '        require(!intitalized);\n', '        MinSum = _val;\n', '    }\n', '    \n', '    function SetLogFile(address _log)\n', '    public\n', '    {\n', '        require(!intitalized);\n', '        Log = LogFile(_log);\n', '    }\n', '    \n', '    function Initialized()\n', '    public\n', '    {\n', '        intitalized = true;\n', '    }\n', '    \n', '    function Deposit()\n', '    public\n', '    payable\n', '    {\n', '        balances[msg.sender]+= msg.value;\n', '        Log.AddMessage(msg.sender,msg.value,"Put");\n', '    }\n', '    \n', '    function Collect(uint _am)\n', '    public\n', '    payable\n', '    {\n', '        if(balances[msg.sender]>=MinSum && balances[msg.sender]>=_am)\n', '        {\n', '            if(msg.sender.call.value(_am)())\n', '            {\n', '                balances[msg.sender]-=_am;\n', '                Log.AddMessage(msg.sender,_am,"Collect");\n', '            }\n', '        }\n', '    }\n', '    \n', '    function() \n', '    public \n', '    payable\n', '    {\n', '        Deposit();\n', '    }\n', '    \n', '}\n', '\n', '\n', '\n', 'contract LogFile\n', '{\n', '    struct Message\n', '    {\n', '        address Sender;\n', '        string  Data;\n', '        uint Val;\n', '        uint  Time;\n', '    }\n', '    \n', '    Message[] public History;\n', '    \n', '    Message LastMsg;\n', '    \n', '    function AddMessage(address _adr,uint _val,string _data)\n', '    public\n', '    {\n', '        LastMsg.Sender = _adr;\n', '        LastMsg.Time = now;\n', '        LastMsg.Val = _val;\n', '        LastMsg.Data = _data;\n', '        History.push(LastMsg);\n', '    }\n', '}']
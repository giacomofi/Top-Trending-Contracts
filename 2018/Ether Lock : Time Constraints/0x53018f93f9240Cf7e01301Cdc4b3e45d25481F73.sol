['pragma solidity ^0.4.20;\n', '\n', 'contract BRTH_GFT\n', '{\n', '    address sender;\n', '    \n', '    address reciver;\n', '    \n', '    bool closed = false;\n', '    \n', '    uint unlockTime;\n', ' \n', '    function Put_BRTH_GFT(address _reciver) public payable {\n', '        if( (!closed&&(msg.value > 1 ether)) || sender==0x00 )\n', '        {\n', '            sender = msg.sender;\n', '            reciver = _reciver;\n', '            unlockTime = now;\n', '        }\n', '    }\n', '    \n', '    function SetGiftTime(uint _unixTime) public canOpen {\n', '        if(msg.sender==sender)\n', '        {\n', '            unlockTime = _unixTime;\n', '        }\n', '    }\n', '    \n', '    function GetGift() public payable canOpen {\n', '        if(reciver==msg.sender)\n', '        {\n', '            msg.sender.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    function CloseGift() public {\n', '        if(sender == msg.sender && reciver != 0x0 )\n', '        {\n', '           closed=true;\n', '        }\n', '    }\n', '    \n', '    modifier canOpen(){\n', '        if(now>unlockTime)_;\n', '        else return;\n', '    }\n', '    \n', '    function() public payable{}\n', '}']
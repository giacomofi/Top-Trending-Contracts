['pragma solidity ^0.4.18;\n', '\n', 'contract SendGift {\n', '\taddress public owner;\n', '\tmapping(address=>address) public friends;\n', '\tmapping(address=>uint256) public received;\n', '\tmapping(address=>uint256) public sent;\n', '\tevent Gift(address indexed _sender);\n', '\tmodifier onlyOwner() {\n', '      if (msg.sender!=owner) revert();\n', '      _;\n', '    }\n', '    \n', '    function SendGift() public {\n', '    \towner = msg.sender;\n', '    }\n', '    \n', '    \n', '    function sendGift(address friend) payable public returns (bool ok){\n', '        if (msg.value==0 || friend==address(0) || friend==msg.sender || (friend!=owner && friends[friend]==address(0))) revert();\n', '        friends[msg.sender] = friend;\n', '        payOut();\n', '        return true;\n', '    }\n', '    \n', '    function payOut() private{\n', '        uint256 gift;\n', '        address payee1 = friends[msg.sender];\n', '        if (payee1==address(0)) payee1 = owner;\n', '        if (received[payee1]>sent[payee1]*2) {\n', '            gift = msg.value*49/100;\n', '            address payee2 = friends[payee1];\n', '            if (payee2==address(0)) payee2 = owner;\n', '            payee2.transfer(gift);\n', '            sent[payee1]+=gift;\n', '            received[payee2]+=gift;\n', '        }\n', '        else gift = msg.value*99/100;\n', '        payee1.transfer(gift);\n', '        sent[msg.sender]+=msg.value;\n', '        received[payee1]+=gift;\n', '        owner.transfer(this.balance);\n', '        Gift(msg.sender);\n', '    }\n', '    \n', '    function () payable public {\n', '        revert();\n', '    }\n', '}']
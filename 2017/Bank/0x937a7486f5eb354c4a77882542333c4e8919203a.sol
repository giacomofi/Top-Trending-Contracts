['pragma solidity ^0.4.18;\n', '\n', 'contract SendToMany\n', '{\n', '    address[] public recipients;\n', '    \n', '    function SendToMany(address[] _recipients) public\n', '    {\n', '        recipients = _recipients;\n', '    }\n', '    \n', '    function() payable public\n', '    {\n', '        uint256 amountOfRecipients = recipients.length;\n', '        for (uint256 i=0; i<amountOfRecipients; i++)\n', '        {\n', '            recipients[i].transfer(msg.value / amountOfRecipients);\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Dragon {\n', '    \n', '    function transfer(address receiver, uint amount)returns(bool ok);\n', '    function balanceOf( address _address )returns(uint256);\n', '\n', '    \n', '}\n', '\n', '\n', '\n', 'contract DragonLock {\n', '    \n', '  \n', '  \n', '    Dragon public tokenreward; \n', '    \n', '    \n', '   \n', '   \n', '    \n', '    uint public TimeLock;\n', '    address public receiver;\n', ' \n', '    \n', '    \n', '  \n', '    \n', '    function DragonLock (){\n', '        \n', '        tokenreward = Dragon (  0x814f67fa286f7572b041d041b1d99b432c9155ee ); // dragon token address\n', '        \n', '        TimeLock = now + 90 days;\n', '       \n', '        receiver = 0x2b29397aEC174A52bff15225efbb5311c7d63b38; // Receiver address change\n', '        \n', '      \n', '        \n', '    }\n', '    \n', '    \n', '    //allows token holders to withdar their dragons after timelock expires\n', '    function withdrawDragons(){\n', '        \n', '        require ( now > TimeLock );\n', '        require ( receiver == msg.sender );\n', '      \n', '       \n', '        tokenreward.transfer ( msg.sender , tokenreward.balanceOf (this)  );\n', '        \n', '    }\n', '    \n', '    \n', '\n', '}']
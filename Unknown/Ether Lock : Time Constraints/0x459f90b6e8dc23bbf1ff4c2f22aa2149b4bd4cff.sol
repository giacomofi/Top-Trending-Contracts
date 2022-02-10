['pragma solidity ^0.4.11;\n', '\n', 'contract TimeBank {\n', '\n', '    struct Holder {\n', '    uint fundsDeposited;\n', '    uint withdrawTime;\n', '    }\n', '    mapping (address => Holder) holders;\n', '\n', '    function getInfo() constant returns(uint,uint,uint){\n', '        return(holders[msg.sender].fundsDeposited,holders[msg.sender].withdrawTime,block.timestamp);\n', '    }\n', '\n', '    function depositFunds(uint _withdrawTime) payable returns (uint _fundsDeposited){\n', '        //requires Ether to be sent, and _withdrawTime to be in future but no more than 5 years\n', '\n', '        require(msg.value > 0 && _withdrawTime > block.timestamp && _withdrawTime < block.timestamp + 157680000);\n', "        //increments value in case holder deposits more than once, but won't update the original withdrawTime in case caller wants to change the 'future withdrawTime' to a much closer time but still future time\n", '        if (!(holders[msg.sender].withdrawTime > 0)) holders[msg.sender].withdrawTime = _withdrawTime;\n', '        holders[msg.sender].fundsDeposited += msg.value;\n', '        return msg.value;\n', '    }\n', '\n', '    function withdrawFunds() {\n', '        require(holders[msg.sender].withdrawTime < block.timestamp); //throws error if current time is before the designated withdrawTime\n', '\n', '        uint funds = holders[msg.sender].fundsDeposited; // separates the funds into a separate variable, so user can still withdraw after the struct is updated\n', '\n', '        holders[msg.sender].fundsDeposited = 0; // adjusts recorded eth deposit before funds are returned\n', '        holders[msg.sender].withdrawTime = 0; // clears withdrawTime to allow future deposits\n', '        msg.sender.transfer(funds); //sends ether to msg.sender if they have funds held\n', '    }\n', '}']
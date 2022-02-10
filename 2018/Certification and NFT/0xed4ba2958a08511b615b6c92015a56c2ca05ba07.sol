['pragma solidity ^0.4.23;\n', '\n', 'interface token { function transfer(address receiver, uint amount);\n', '}\n', 'contract WICCrowdsale {\n', '    address public beneficiary; \n', '    uint public fundingGoal;\n', '    uint public amountRaised; \n', '    uint public deadline; \n', '\n', '    uint public price;\n', '    token public tokenReward; \n', '    mapping(address => uint256) public balanceOf;\n', '    bool fundingGoalReached = false; \n', '    bool crowdsaleClosed = false; \n', '\n', '    event GoalReached(address recipient, uint totalAmountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    function WICCrowdsale(\n', '        address ifSuccessfulSendTo,\n', '        uint fundingGoalInEthers,\n', '        uint durationInMinutes,\n', '        uint etherCostOfEachToken,\n', '        address addressOfTokenUsedAsReward\n', '    ) {\n', '        beneficiary = ifSuccessfulSendTo;\n', '        fundingGoal = fundingGoalInEthers * 1 ether;\n', '        deadline = now + durationInMinutes * 1 minutes;\n', '        price = etherCostOfEachToken * 1 ether;\n', '        tokenReward = token(addressOfTokenUsedAsReward);\n', '    }\n', '\n', '    function () payable {\n', '       require(!crowdsaleClosed);\n', '       uint amount = msg.value;\n', '       balanceOf[msg.sender] += amount;\n', '       amountRaised += amount;\n', '       tokenReward.transfer(msg.sender, amount / price);  \n', '       beneficiary.send(amountRaised);\n', '       amountRaised = 0;\n', '       FundTransfer(msg.sender, amount, true);\n', '}\n', '\n', '    modifier afterDeadline() {\n', '          if (now >= deadline) _;\n', '          }\n', '\n', '    function checkGoalReached() afterDeadline {\n', '        if (amountRaised >= fundingGoal){\n', '            fundingGoalReached = true;\n', '            GoalReached(beneficiary, amountRaised);\n', '        }\n', '        crowdsaleClosed = true;\n', '    }\n', '\n', '    function safeWithdrawal() afterDeadline {\n', '        if (!fundingGoalReached) {\n', '            uint amount = balanceOf[msg.sender];\n', '            balanceOf[msg.sender] = 0;\n', '            if (amount > 0) {\n', '                if (msg.sender.send(amount)) {\n', '                    FundTransfer(msg.sender, amount, false);\n', '            }\n', '            else {\n', '                balanceOf[msg.sender] = amount;\n', '                }\n', '            }\n', '        }\n', '        if (fundingGoalReached && beneficiary == msg.sender) {\n', '            if (beneficiary.send(amountRaised)) {\n', '                FundTransfer(beneficiary, amountRaised, false);\n', '            }\n', '            else {\n', '                fundingGoalReached = false;\n', '            }\n', '        }\n', '    }\n', '}']
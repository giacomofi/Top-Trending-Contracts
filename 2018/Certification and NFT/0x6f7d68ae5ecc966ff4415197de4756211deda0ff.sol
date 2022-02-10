['pragma solidity ^0.4.16;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount);\n', '}\n', '\n', 'contract Crowdsale {\n', '    address public beneficiary;\n', '    uint public fundingGoal;\n', '    uint public amountRaised;\n', '    uint public deadline;\n', '    uint public price;\n', '    token public tokenReward;\n', '    mapping(address => uint256) public balanceOf;\n', '    bool fundingGoalReached = false;\n', '    bool crowdsaleClosed = false;\n', '\n', '    event GoalReached(address recipient, uint totalAmountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function Crowdsale(\n', '        address ifSuccessfulSendTo,\n', '        uint fundingGoalInEthers,\n', '        uint durationInMinutes,\n', '        uint etherCostOfEachToken,\n', '        address addressOfTokenUsedAsReward\n', '    ) {\n', '        beneficiary = ifSuccessfulSendTo;\n', '        fundingGoal = fundingGoalInEthers * 1 ether;\n', '        deadline = now + durationInMinutes * 1 minutes;\n', '        price = etherCostOfEachToken * 1 ether;\n', '        tokenReward = token(addressOfTokenUsedAsReward);\n', '    }\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '    function () payable {\n', '        require(!crowdsaleClosed);\n', '        uint amount = msg.value;\n', '        balanceOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        tokenReward.transfer(msg.sender, amount / price);\n', '        FundTransfer(msg.sender, amount, true);\n', '    }\n', '\n', '    modifier afterDeadline() { if (now >= deadline) _; }\n', '\n', '    /**\n', '     * Check if goal was reached\n', '     *\n', '     * Checks if the goal or time limit has been reached and ends the campaign\n', '     */\n', '    function checkGoalReached() afterDeadline {\n', '        if (amountRaised >= fundingGoal){\n', '            fundingGoalReached = true;\n', '            GoalReached(beneficiary, amountRaised);\n', '        }\n', '        crowdsaleClosed = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     *\n', '     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,\n', '     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw\n', '     * the amount they contributed.\n', '     */\n', '    function safeWithdrawal() afterDeadline {\n', '        if (!fundingGoalReached) {\n', '            uint amount = balanceOf[msg.sender];\n', '            balanceOf[msg.sender] = 0;\n', '            if (amount > 0) {\n', '                if (msg.sender.send(amount)) {\n', '                    FundTransfer(msg.sender, amount, false);\n', '                } else {\n', '                    balanceOf[msg.sender] = amount;\n', '                }\n', '            }\n', '        }\n', '\n', '        if (fundingGoalReached && beneficiary == msg.sender) {\n', '            if (beneficiary.send(amountRaised)) {\n', '                FundTransfer(beneficiary, amountRaised, false);\n', '            } else {\n', '                //If we fail to send the funds to beneficiary, unlock funders balance\n', '                fundingGoalReached = false;\n', '            }\n', '        }\n', '    }\n', '}']
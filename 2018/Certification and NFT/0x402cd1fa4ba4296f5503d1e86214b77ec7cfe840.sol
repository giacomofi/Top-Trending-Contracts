['pragma solidity ^0.4.21;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', 'contract Crowdsale {\n', '    address public beneficiary;\n', '    uint public fundingGoal;\n', '    uint public amountRaised;\n', '    uint public deadline;\n', '    uint public price;\n', '    token public tokenReward;\n', '    mapping(address => uint256) public balanceOf;\n', '    bool fundingGoalReached = false;\n', '    bool crowdsaleClosed = false;\n', '    uint public starttime;\n', '\n', '    event GoalReached(address recipient, uint totalAmountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function Crowdsale(\n', '        address ifSuccessfulSendTo,\n', '        uint fundingGoalInEthers,\n', '        uint durationInMinutes,\n', '        uint weiCostOfEachToken,\n', '        address addressOfTokenUsedAsReward\n', '    ) public {\n', '        beneficiary = ifSuccessfulSendTo;\n', '        fundingGoal = fundingGoalInEthers * 1 ether;\n', '        deadline = now + durationInMinutes * 1 minutes;\n', '        price = weiCostOfEachToken;\n', '        tokenReward = token(addressOfTokenUsedAsReward);\n', '        starttime = now;\n', '    }\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '    function () payable public {\n', '        require(!crowdsaleClosed);\n', '        uint amount = msg.value;\n', '        balanceOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        if (now < (starttime + 1440 * 1 minutes))\n', '        {\n', '            tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 65 / 100));\n', '        }\n', '        else if (now < (starttime + 4320 * 1 minutes))\n', '        {\n', '            tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 75 / 100));\n', '        }\n', '        else if (now < (starttime + 10080 * 1 minutes))\n', '        {\n', '            tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 85 / 100));\n', '        }\n', '        else if (now < (starttime + 30240 * 1 minutes))\n', '        {\n', '            tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 90 / 100));\n', '        }\n', '        else\n', '        {\n', '            tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / price);\n', '        }\n', '       emit FundTransfer(msg.sender, amount, true);\n', '    }\n', '\n', '    modifier afterDeadline() { if (now >= deadline) _; }\n', '\n', '    /**\n', '     * Check if goal was reached\n', '     *\n', '     * Checks if the goal or time limit has been reached and ends the campaign\n', '     */\n', '    function checkGoalReached() public afterDeadline {\n', '        if (amountRaised >= fundingGoal){\n', '            fundingGoalReached = true;\n', '            emit GoalReached(beneficiary, amountRaised);\n', '        }\n', '        crowdsaleClosed = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     *\n', '     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,\n', '     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw\n', '     * the amount they contributed.\n', '     */\n', '    function safeWithdrawal() public afterDeadline {\n', '        if (!fundingGoalReached) {\n', '            uint amount = balanceOf[msg.sender];\n', '            balanceOf[msg.sender] = 0;\n', '            if (amount > 0) {\n', '                if (msg.sender.send(amount)) {\n', '                   emit FundTransfer(msg.sender, amount, false);\n', '                } else {\n', '                    balanceOf[msg.sender] = amount;\n', '                }\n', '            }\n', '        }\n', '\n', '        if (fundingGoalReached && beneficiary == msg.sender) {\n', '            if (beneficiary.send(amountRaised)) {\n', '               emit FundTransfer(beneficiary, amountRaised, false);\n', '            } else {\n', '                //If we fail to send the funds to beneficiary, unlock funders balance\n', '                fundingGoalReached = false;\n', '            }\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', 'contract Crowdsale {\n', '    address public beneficiary;\n', '    uint public fundingGoal;\n', '    uint public amountRaised;\n', '    uint public deadline;\n', '    uint public price;\n', '    token public tokenReward;\n', '    mapping(address => uint256) public balanceOf;\n', '    bool fundingGoalReached = false;\n', '    bool crowdsaleClosed = false;\n', '    uint public starttime;\n', '\n', '    event GoalReached(address recipient, uint totalAmountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function Crowdsale(\n', '        address ifSuccessfulSendTo,\n', '        uint fundingGoalInEthers,\n', '        uint durationInMinutes,\n', '        uint weiCostOfEachToken,\n', '        address addressOfTokenUsedAsReward\n', '    ) public {\n', '        beneficiary = ifSuccessfulSendTo;\n', '        fundingGoal = fundingGoalInEthers * 1 ether;\n', '        deadline = now + durationInMinutes * 1 minutes;\n', '        price = weiCostOfEachToken;\n', '        tokenReward = token(addressOfTokenUsedAsReward);\n', '        starttime = now;\n', '    }\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '    function () payable public {\n', '        require(!crowdsaleClosed);\n', '        uint amount = msg.value;\n', '        balanceOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        if (now < (starttime + 1440 * 1 minutes))\n', '        {\n', '            tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 65 / 100));\n', '        }\n', '        else if (now < (starttime + 4320 * 1 minutes))\n', '        {\n', '            tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 75 / 100));\n', '        }\n', '        else if (now < (starttime + 10080 * 1 minutes))\n', '        {\n', '            tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 85 / 100));\n', '        }\n', '        else if (now < (starttime + 30240 * 1 minutes))\n', '        {\n', '            tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / (price * 90 / 100));\n', '        }\n', '        else\n', '        {\n', '            tokenReward.transfer(msg.sender, (amount * 1000000000000000000) / price);\n', '        }\n', '       emit FundTransfer(msg.sender, amount, true);\n', '    }\n', '\n', '    modifier afterDeadline() { if (now >= deadline) _; }\n', '\n', '    /**\n', '     * Check if goal was reached\n', '     *\n', '     * Checks if the goal or time limit has been reached and ends the campaign\n', '     */\n', '    function checkGoalReached() public afterDeadline {\n', '        if (amountRaised >= fundingGoal){\n', '            fundingGoalReached = true;\n', '            emit GoalReached(beneficiary, amountRaised);\n', '        }\n', '        crowdsaleClosed = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     *\n', '     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,\n', '     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw\n', '     * the amount they contributed.\n', '     */\n', '    function safeWithdrawal() public afterDeadline {\n', '        if (!fundingGoalReached) {\n', '            uint amount = balanceOf[msg.sender];\n', '            balanceOf[msg.sender] = 0;\n', '            if (amount > 0) {\n', '                if (msg.sender.send(amount)) {\n', '                   emit FundTransfer(msg.sender, amount, false);\n', '                } else {\n', '                    balanceOf[msg.sender] = amount;\n', '                }\n', '            }\n', '        }\n', '\n', '        if (fundingGoalReached && beneficiary == msg.sender) {\n', '            if (beneficiary.send(amountRaised)) {\n', '               emit FundTransfer(beneficiary, amountRaised, false);\n', '            } else {\n', '                //If we fail to send the funds to beneficiary, unlock funders balance\n', '                fundingGoalReached = false;\n', '            }\n', '        }\n', '    }\n', '}']
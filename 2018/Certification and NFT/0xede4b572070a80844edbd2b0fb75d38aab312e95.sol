['pragma solidity ^0.4.21;\n', '\n', 'interface token {\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '}\n', '\n', 'contract Crowdsale {\n', '    address public owner;\n', '    address public SSOTHEALTH_FUNDS_ADDRESS = 0x4F1Fa6F553AF4696f00FCad6f495D3F1eB1BE2fe;   // SSOT Health Funds address\n', '    address public SEHR_WALLET_ADDRESS = 0xcA027bF2179325B9D31689cdbFbf242aF34c79DE;        // SEHR Main token wallet\n', '    token public tokenReward = token(0xE8c881422CA4c2ab9a9bC9d58e75178e0e28eEd5);           // SEHR contract address\n', '    uint public fundingGoal = 100000000 * 1 ether;  // 100,000,000 SEHRs softcap \n', '    uint public hardCap = 500000000 * 1 ether;      // 500,000,000 SEHRs hardcap\n', '    uint public amountRaised = 0;\n', '    uint public sehrRaised = 0;\n', '    uint public startTime;\n', '    uint public deadline;\n', '    uint public price = 80 szabo;                   // 0.00008 ETH/SEHR  ; 1 szabo = 10^-6 Ether\n', '    mapping(address => uint256) public balanceOf;\n', '    \n', '    bool public fundingGoalReached = false;\n', '    bool public crowdsaleClosed = false;\n', '    bool public checkDone = false;\n', '\n', '    event GoalReached(address recipient, uint totalAmountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Setup the owner\n', '     */\n', '    function Crowdsale() public\n', '    {\n', '        startTime = now;\n', '        deadline = now + 62 days;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier afterDeadline() { if (now >= deadline) _; }\n', '    modifier beforeDeadline() { if (now < deadline) _; }\n', '    modifier isCrowdsale() { if (!crowdsaleClosed) _; }\n', '    modifier isCheckDone() { if (checkDone) _; }\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * The function without name is the default function that is called whenever anyone sends funds to a contract\n', '     */\n', '    function () payable isCrowdsale beforeDeadline public {\n', '        uint amount = msg.value;\n', '        \n', '        if(amount == 0 ) revert();   // Need to send some ether at least\n', '        else if( amount < 250 finney) {\n', '            if (sehrRaised < fundingGoal) {\n', '                if(now < startTime + 31 days) revert();    // Need to invest at least 0.25 Ether during the pre-sale if the funding goal hasn&#39;t been reached yet\n', '            }\n', '        }\n', '        \n', '        uint tokenAmount = (amount / price) * 1 ether; // We compute the number of tokens to issue\n', '        \n', '        if(sehrRaised < fundingGoal) {  // Bonus available for any tokens bought before softcap is reached\n', '            \n', '            if(now < startTime + 10 days) {\n', '                tokenAmount = (13 * tokenAmount) / 10; // 30% bonus during the first 10-day period\n', '            }\n', '            \n', '            else if(now < startTime + 20 days) {\n', '                tokenAmount = (12 * tokenAmount) / 10;     // 20% bonus during the second 10-day period\n', '            }\n', '            \n', '            else if(now < startTime + 31 days) {\n', '                tokenAmount = (11 * tokenAmount) / 10;     // 10% bonus during the third 10-day period\n', '            }\n', '        }\n', '        \n', '        balanceOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        sehrRaised += tokenAmount;\n', '        \n', '        tokenReward.transferFrom(SEHR_WALLET_ADDRESS, msg.sender, tokenAmount); // will automatically throw is there are not enough funds remaining in the contract\n', '        emit FundTransfer(msg.sender, amount, true);\n', '    }\n', '\n', '\n', '    /**\n', '     * Check if goal was reached\n', '     *\n', '     * Checks if the goal or time limit has been reached and ends the campaign\n', '     */\n', '    function checkGoalReached() afterDeadline public {\n', '        if (sehrRaised >= fundingGoal){\n', '            fundingGoalReached = true;\n', '            emit GoalReached(SSOTHEALTH_FUNDS_ADDRESS, amountRaised);\n', '        }\n', '        crowdsaleClosed = true;\n', '        checkDone = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     *\n', '     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,\n', '     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw\n', '     * the amount they contributed.\n', '     */\n', '    function safeWithdrawal() afterDeadline isCheckDone public{\n', '        if (!fundingGoalReached) {\n', '            uint amount = balanceOf[msg.sender];\n', '            balanceOf[msg.sender] = 0;\n', '            if (amount > 0) {\n', '                if (msg.sender.send(amount)) {\n', '                    emit FundTransfer(msg.sender, amount, false);\n', '                } else {\n', '                    balanceOf[msg.sender] = amount;\n', '                }\n', '            }\n', '        }\n', '\n', '        if (fundingGoalReached && SSOTHEALTH_FUNDS_ADDRESS == msg.sender) {\n', '            if (SSOTHEALTH_FUNDS_ADDRESS.send(amountRaised)) {\n', '                emit FundTransfer(SSOTHEALTH_FUNDS_ADDRESS, amountRaised, false);\n', '            } else {\n', '                //If we fail to send the funds to beneficiary, unlock funders balance\n', '                fundingGoalReached = false;\n', '            }\n', '        }\n', '    }\n', '    \n', '    function hardCapReached() public {\n', '        if(sehrRaised == hardCap) {\n', '            deadline = now;\n', '        }\n', '        else revert();\n', '    }\n', '}']
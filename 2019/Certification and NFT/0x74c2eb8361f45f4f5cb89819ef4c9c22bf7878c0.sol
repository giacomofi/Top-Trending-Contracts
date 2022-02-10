['pragma solidity ^0.4.16;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount);\n', '}\n', '\n', 'contract Crowdsale {\n', '    address public beneficiary;  // 募资成功后的收款方\n', '    uint public fundingGoal;   // 募资额度\n', '    uint public amountRaised;   // 参与数量\n', '    uint public deadline;      // 募资截止期\n', '\n', '    uint public price;    //  token 与以太坊的汇率 , token卖多少钱\n', '    token public tokenReward;   // 要卖的token\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    bool fundingGoalReached = false;  // 众筹是否达到目标\n', '    bool crowdsaleClosed = false;   //  众筹是否结束\n', '\n', '    /**\n', '    * 事件可以用来跟踪信息\n', '    **/\n', '    event GoalReached(address recipient, uint totalAmountRaised);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '\n', '    /**\n', '     * 构造函数, 设置相关属性\n', '     */\n', '    function Crowdsale(\n', '        address ifSuccessfulSendTo,\n', '        uint fundingGoalInEthers,\n', '        uint durationInMinutes,\n', '        uint finneyCostOfEachToken,\n', '        address addressOfTokenUsedAsReward) {\n', '            beneficiary = ifSuccessfulSendTo;\n', '            fundingGoal = fundingGoalInEthers * 1 ether;\n', '            deadline = now + durationInMinutes * 1 minutes;\n', '            price = finneyCostOfEachToken * 1 szabo;\n', '            tokenReward = token(addressOfTokenUsedAsReward);   // 传入已发布的 token 合约的地址来创建实例\n', '    }\n', '\n', '    /**\n', '     * 无函数名的Fallback函数，\n', '     * 在向合约转账时，这个函数会被调用\n', '     */\n', '    function () payable {\n', '        require(!crowdsaleClosed);\n', '        uint amount = msg.value;\n', '        balanceOf[msg.sender] += amount;\n', '        amountRaised += amount;\n', '        tokenReward.transfer(msg.sender, amount / price);\n', '        FundTransfer(msg.sender, amount, true);\n', '    }\n', '\n', '    /**\n', '    *  定义函数修改器modifier（作用和Python的装饰器很相似）\n', '    * 用于在函数执行前检查某种前置条件（判断通过之后才会继续执行该方法）\n', '    * _ 表示继续执行之后的代码\n', '    **/\n', '    modifier afterDeadline() { if (now >= deadline) _; }\n', '\n', '    /**\n', '     * 判断众筹是否完成融资目标， 这个方法使用了afterDeadline函数修改器\n', '     *\n', '     */\n', '    function checkGoalReached() afterDeadline {\n', '        if (amountRaised >= fundingGoal) {\n', '            fundingGoalReached = true;\n', '            GoalReached(beneficiary, amountRaised);\n', '        }\n', '        crowdsaleClosed = true;\n', '    }\n', '\n', '\n', '    /**\n', '     * 完成融资目标时，融资款发送到收款方\n', '     * 未完成融资目标时，执行退款\n', '     *\n', '     */\n', '    function safeWithdrawal() afterDeadline {\n', '        if (!fundingGoalReached) {\n', '            uint amount = balanceOf[msg.sender];\n', '            balanceOf[msg.sender] = 0;\n', '            if (amount > 0) {\n', '                if (msg.sender.send(amount)) {\n', '                    FundTransfer(msg.sender, amount, false);\n', '                } else {\n', '                    balanceOf[msg.sender] = amount;\n', '                }\n', '            }\n', '        }\n', '\n', '        if (fundingGoalReached && beneficiary == msg.sender) {\n', '            if (beneficiary.send(amountRaised)) {\n', '                FundTransfer(beneficiary, amountRaised, false);\n', '            } else {\n', '                //If we fail to send the funds to beneficiary, unlock funders balance\n', '                fundingGoalReached = false;\n', '            }\n', '        }\n', '    }\n', '}']
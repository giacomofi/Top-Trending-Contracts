['pragma solidity ^0.4.25;\n', '\n', '/** KPI is 100k USD (~ETH rate fix at start of contract) target selling period is 45 days*/\n', '\n', '/** If NCryptBit reached 100k before 45 days -> payoff immediately 10% commission through `claim` function */\n', '\n', '/** \n', 'Pay 4k USD (in ETH) first installment of comission fee immediately after startTime (confirm purchased) `ONE day` (through claimFirstInstallment())\n', '\n', 'Remaining installment fee will be paid dependTime on KPI below:\n', '    \n', '    - Trunk payment period when reach partial KPI\n', '        * 0 -> 15 date reach >=25k -> 1/3 Remaining Installment Fee (~2k USD)\n', '        * 15 -> 30 date reach >=25k -> 1/3 Remaining Installment Fee (~2k USD)\n', '        * 45  reach >=25k -> 1/3 Remaining Installment Fee (~2k USD)\n', '        \n', '    NOTE: Remaining ETH will refund to Triip through `refund` function at endTime of this campaign\n', '*/\n', '\n', 'contract TriipInvestorsServices {\n', '\n', '    event ConfirmPurchase(address _sender, uint _startTime, uint _amount);\n', '\n', '    event Payoff(address _seller, uint _amount, uint _kpi);\n', '    \n', '    event Refund(address _buyer, uint _amount);\n', '\n', '    event Claim(address _sender, uint _counting, uint _buyerWalletBalance);\n', '\n', '    enum PaidStage {\n', '        NONE,\n', '        FIRST_PAYMENT,\n', '        SECOND_PAYMENT,\n', '        FINAL_PAYMENT\n', '    }\n', '\n', '    uint public KPI_0k = 0;\n', '    uint public KPI_25k = 25;\n', '    uint public KPI_50k = 50;\n', '    uint public KPI_100k = 100;    \n', '    \n', '    address public seller; // NCriptBit\n', '    address public buyer;  // Triip Protocol wallet use for refunding\n', "    address public buyerWallet; // Triip Protocol's raising ETH wallet\n", '    \n', '    uint public startTime = 0;\n', '    uint public endTime = 0;\n', '    bool public isEnd = false;    \n', '\n', '    uint decimals = 18;\n', '    uint unit = 10 ** decimals;\n', '    \n', '    uint public paymentAmount = 69 * unit;                // 69 ETH equals to 10k USD upfront, fixed at deploy of contract manually\n', '    uint public targetSellingAmount = 10 * paymentAmount; // 690 ETH equals to 100k USD upfront\n', '    \n', '    uint claimCounting = 0;\n', '\n', '    PaidStage public paidStage = PaidStage.NONE;\n', '\n', '    uint public balance;\n', '\n', '    // Begin: only for testing\n', '\n', '    // function setPaymentAmount(uint _paymentAmount) public returns (bool) {\n', '    //     paymentAmount = _paymentAmount;\n', '    //     return true;\n', '    // }\n', '\n', '    // function setStartTime(uint _startTime) public returns (bool) {\n', '    //     startTime = _startTime;\n', '    //     return true;\n', '    // }\n', '\n', '    // function setEndTime(uint _endTime) public returns (bool) {\n', '    //     endTime = _endTime;\n', '    //     return true;\n', '    // }\n', '\n', '    // function getNow() public view returns (uint) {\n', '    //     return now;\n', '    // }\n', '\n', '    // End: only for testing\n', '\n', '    constructor(address _buyer, address _seller, address _buyerWallet) public {\n', '\n', '        seller = _seller;\n', '        buyer = _buyer;\n', '        buyerWallet = _buyerWallet;\n', '\n', '    }\n', '\n', '    modifier whenNotEnd() {\n', '        require(!isEnd, "This contract should not be endTime") ;\n', '        _;\n', '    }\n', '\n', '    function confirmPurchase() public payable { // Trigger by Triip with the ETH amount agreed for installment\n', '\n', '        require(startTime == 0);\n', '\n', '        require(msg.value == paymentAmount, "Not equal installment fee");\n', '\n', '        startTime = now;\n', '\n', '        endTime = startTime + ( 45 * 1 days );\n', '\n', '        balance += msg.value;\n', '\n', '        emit ConfirmPurchase(msg.sender, startTime, balance);\n', '    }\n', '\n', '    function contractEthBalance() public view returns (uint) {\n', '\n', '        return balance;\n', '    }\n', '\n', '    function buyerWalletBalance() public view returns (uint) {\n', '        \n', '        return address(buyerWallet).balance;\n', '    }\n', '\n', '    function claimFirstInstallment() public whenNotEnd returns (bool) {\n', '\n', '        require(paidStage == PaidStage.NONE, "First installment has already been claimed");\n', '\n', '        require(now >= startTime + 1 days, "Require first installment fee to be claimed after startTime + 1 day");\n', '\n', '        uint payoffAmount = balance * 40 / 100; // 40% of agreed commission\n', '\n', '        // update balance\n', '        balance = balance - payoffAmount; // ~5k gas as of writing\n', '\n', '        seller.transfer(payoffAmount); // ~21k gas as of writing\n', '\n', '        emit Payoff(seller, payoffAmount, KPI_0k );\n', '        emit Claim(msg.sender, claimCounting, buyerWalletBalance());\n', '\n', '        return true;\n', '    }\n', '    \n', '    function claim() public whenNotEnd returns (uint) {\n', '\n', '        claimCounting = claimCounting + 1;\n', '\n', '        uint payoffAmount = 0;\n', '\n', '        uint sellingAmount  = targetSellingAmount;\n', '        uint buyerBalance = buyerWalletBalance();\n', '\n', '        emit Claim(msg.sender, claimCounting, buyerWalletBalance());\n', '        \n', '        if ( buyerBalance >= sellingAmount ) {\n', '\n', '            payoffAmount = balance;\n', '\n', '            seller.transfer(payoffAmount);\n', '            paidStage = PaidStage.FINAL_PAYMENT;\n', '\n', '            balance = 0;\n', '            endContract();\n', '\n', '            emit Payoff(seller, payoffAmount, KPI_100k);\n', '\n', '        }\n', '        else {\n', '            payoffAmount = claimByKPI();\n', '\n', '        }\n', '\n', '        return payoffAmount;\n', '    }\n', '\n', '    function claimByKPI() private returns (uint) {\n', '\n', '        uint payoffAmount = 0;\n', '        uint sellingAmount = targetSellingAmount;\n', '        uint buyerBalance = buyerWalletBalance();\n', '\n', '        if ( buyerBalance >= ( sellingAmount * KPI_50k / 100) \n', '            && now >= (startTime + ( 30 * 1 days) )\n', '            ) {\n', '\n', '            uint paidPercent = 66;\n', '\n', '            if ( paidStage == PaidStage.NONE) {\n', '                paidPercent = 66; // 66% of 6k installment equals 4k\n', '            }else if( paidStage == PaidStage.FIRST_PAYMENT) {\n', '                // 33 % of total balance\n', '                // 50% of remaining balance\n', '                paidPercent = 50;\n', '            }\n', '\n', '            payoffAmount = balance * paidPercent / 100;\n', '\n', '            // update balance\n', '            balance = balance - payoffAmount;\n', '\n', '            seller.transfer(payoffAmount);\n', '\n', '            emit Payoff(seller, payoffAmount, KPI_50k);\n', '\n', '            paidStage = PaidStage.SECOND_PAYMENT;\n', '        }\n', '\n', '        if( buyerBalance >= ( sellingAmount * KPI_25k / 100) \n', '            && now >= (startTime + (15 * 1 days) )\n', '            && paidStage == PaidStage.NONE ) {\n', '\n', '            payoffAmount = balance * 33 / 100;\n', '\n', '            // update balance\n', '            balance = balance - payoffAmount;\n', '\n', '            seller.transfer(payoffAmount);\n', '\n', '            emit Payoff(seller, payoffAmount, KPI_25k );\n', '\n', '            paidStage = PaidStage.FIRST_PAYMENT;\n', '\n', '        }\n', '\n', '        if(now >= (startTime + (45 * 1 days) )) {\n', '\n', '            endContract();\n', '        }\n', '\n', '        return payoffAmount;\n', '    }\n', '\n', '    function endContract() private {\n', '        isEnd = true;\n', '    }\n', '    \n', '    function refund() public returns (uint) {\n', '\n', '        require(now >= endTime);\n', '\n', '        // refund remaining balance\n', '        uint refundAmount = address(this).balance;\n', '\n', '        buyer.transfer(refundAmount);\n', '\n', '        emit Refund(buyer, refundAmount);\n', '\n', '        return refundAmount;\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', 'interface HourglassInterface {\n', '    function() payable external;\n', '    function buy(address _investorAddress) payable external returns(uint256);\n', '    function reinvest() external;\n', '    function exit() payable external;\n', '    function withdraw() payable external;\n', '    function sell(uint256 _amountOfTokens) external;\n', '    function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);\n', '    function totalEthereumBalance() external;\n', '    function totalSupply() external;\n', '    function myTokens() external returns(uint256);\n', '    function myDividends(bool _includeReferralBonus) external returns (uint256);\n', '    function balanceOf(address _investorAddress) external returns (uint256);\n', '    function dividendsOf(address _investorAddress) external returns (uint256);\n', '    function sellPrice() payable external returns (uint256);\n', '    function buyPrice() external;\n', '    function calculateTokensReceived(uint256 _ethereumToSpend) external;\n', '    function calculateEthereumReceived(uint256 _tokensToSell) external returns(uint256);\n', '    function purchaseTokens(uint256 _incomingEthereum, address _referredBy) external;\n', '}\n', '\n', 'contract FastEth {\n', '    \n', '    using SafeMath\n', '    for uint;\n', '    \n', '    /* Marketing private wallet*/\n', '    address constant _parojectMarketing = 0xaC780d067c52227ac7563FBe975eD9A8F235eb35;\n', '    address constant _wmtContractAddress = 0xB487283470C54d28Ed97453E8778d4250BA0F7d4;\n', '    /* Interface to main WMT contract */    \n', '    HourglassInterface constant WMTContract = HourglassInterface(_wmtContractAddress);\n', '    \n', '    /* % Fee that will be deducted from initial transfer and sent to CMT contract */\n', '    uint constant _masterTaxOnInvestment = 10;\n', '    \n', '\t//Address for promo expences\n', '    address constant private PROMO1 = 0xaC780d067c52227ac7563FBe975eD9A8F235eb35;\n', '\taddress constant private PROMO2 = 0x6dBFFf54E23Cf6DB1F72211e0683a5C6144E8F03;\n', '\taddress constant private PRIZE\t= 0xeE9B823ef62FfB79aFf2C861eDe7d632bbB5B653;\n', '\t\n', '\t//Percent for promo expences\n', '    uint constant public PERCENT = 5;\n', '    \n', '    //Bonus prize\n', '    uint constant public BONUS_PERCENT = 3;\n', '\t\n', '    // Start time\n', '    uint constant StartEpoc = 1541541570;                     \n', '                         \n', '    //The deposit structure holds all the info about the deposit made\n', '    struct Deposit {\n', '        address depositor; // The depositor address\n', '        uint deposit;   // The deposit amount\n', '        uint payout; // Amount already paid\n', '    }\n', '\n', '    Deposit[] public queue;  // The queue\n', '    mapping (address => uint) public depositNumber; // investor deposit index\n', '    uint public currentReceiverIndex; // The index of the depositor in the queue\n', '    uint public totalInvested; // Total invested amount\n', '\n', '    //This function receives all the deposits\n', '    //stores them and make immediate payouts\n', '    function () public payable {\n', '        \n', '        require(now >= StartEpoc);\n', '\n', '        if(msg.value > 0){\n', '\n', '            require(gasleft() >= 250000); // We need gas to process queue\n', '            require(msg.value >= 0.05 ether && msg.value <= 10 ether); // Too small and too big deposits are not accepted\n', '            \n', '            // Add the investor into the queue\n', '            queue.push( Deposit(msg.sender, msg.value, 0) );\n', '            depositNumber[msg.sender] = queue.length;\n', '\n', '            totalInvested += msg.value;\n', '\n', '            //Send some promo to enable queue contracts to leave long-long time\n', '            uint promo1 = msg.value*PERCENT/100;\n', '            PROMO1.transfer(promo1);\n', '\t\t\tuint promo2 = msg.value*PERCENT/100;\n', '            PROMO2.transfer(promo2);\n', '            \n', '            //Send to WMT contract\n', '            startDivDistribution();            \n', '            \n', '            uint prize = msg.value*BONUS_PERCENT/100;\n', '            PRIZE.transfer(prize);\n', '            \n', '            // Pay to first investors in line\n', '            pay();\n', '\n', '        }\n', '    }\n', '\n', '    // Used to pay to current investors\n', '    // Each new transaction processes 1 - 4+ investors in the head of queue\n', '    // depending on balance and gas left\n', '    function pay() internal {\n', '\n', '        uint money = address(this).balance;\n', '        uint multiplier = 118;\n', '\n', '        // We will do cycle on the queue\n', '        for (uint i = 0; i < queue.length; i++){\n', '\n', '            uint idx = currentReceiverIndex + i;  //get the index of the currently first investor\n', '\n', '            Deposit storage dep = queue[idx]; // get the info of the first investor\n', '\n', '            uint totalPayout = dep.deposit * multiplier / 100;\n', '            uint leftPayout;\n', '\n', '            if (totalPayout > dep.payout) {\n', '                leftPayout = totalPayout - dep.payout;\n', '            }\n', '\n', '            if (money >= leftPayout) { //If we have enough money on the contract to fully pay to investor\n', '\n', '                if (leftPayout > 0) {\n', '                    dep.depositor.transfer(leftPayout); // Send money to him\n', '                    money -= leftPayout;\n', '                }\n', '\n', '                // this investor is fully paid, so remove him\n', '                depositNumber[dep.depositor] = 0;\n', '                delete queue[idx];\n', '\n', '            } else{\n', '\n', "                // Here we don't have enough money so partially pay to investor\n", '                dep.depositor.transfer(money); // Send to him everything we have\n', '                dep.payout += money;       // Update the payout amount\n', '                break;                     // Exit cycle\n', '\n', '            }\n', '\n', '            if (gasleft() <= 55000) {         // Check the gas left. If it is low, exit the cycle\n', '                break;                       // The next investor will process the line further\n', '            }\n', '        }\n', '\n', '        currentReceiverIndex += i; //Update the index of the current first investor\n', '    }\n', '    \n', '    /* Internal function to distribute masterx tax fee into dividends to all CMT holders */\n', '    function startDivDistribution() internal{\n', '            /*#######################################  !  IMPORTANT  !  ##############################################\n', '            ## Here we buy WMT tokens with 10% from deposit and we intentionally use marketing wallet as masternode  ##\n', '            ## that results into 33% from 10% goes to marketing & server running  purposes by our team but the rest  ##\n', '            ## of 8% is distributet to all holder with selling WMT tokens & then reinvesting again (LOGIC FROM WMT) ##\n', '            ## This kindof functionality allows us to decrease the % tax on deposit since 1% from deposit is much   ##\n', '            ## more than 33% from 10%.                                                                               ##\n', '            ########################################################################################################*/\n', '            WMTContract.buy.value(msg.value.mul(_masterTaxOnInvestment).div(100))(_parojectMarketing);\n', '            uint _wmtBalance = getFundWMTBalance();\n', '            WMTContract.sell(_wmtBalance);\n', '            WMTContract.reinvest();\n', '    }\n', '\n', '    /* Returns contracts balance on WMT contract */\n', '    function getFundWMTBalance() internal returns (uint256){\n', '        return WMTContract.myTokens();\n', '    }\n', '    \n', '    //Returns your position in queue\n', '    function getDepositsCount(address depositor) public view returns (uint) {\n', '        uint c = 0;\n', '        for(uint i=currentReceiverIndex; i<queue.length; ++i){\n', '            if(queue[i].depositor == depositor)\n', '                c++;\n', '        }\n', '        return c;\n', '    }\n', '\n', '    // Get current queue size\n', '    function getQueueLength() public view returns (uint) {\n', '        return queue.length - currentReceiverIndex;\n', '    }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    \n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}']
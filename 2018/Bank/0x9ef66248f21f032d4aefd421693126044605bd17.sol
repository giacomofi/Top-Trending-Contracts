['pragma solidity 0.4.23;\n', '\n', '/*\n', ' * ATTENTION!\n', ' * \n', ' * This code? IS NOT DESIGNED FOR ACTUAL USE.\n', ' * \n', ' * The author of this code really wishes you wouldn&#39;t send your ETH to it.\n', ' * \n', ' * No, seriously. It&#39;s probablly illegal anyway. So don&#39;t do it.\n', ' * \n', ' * Let me repeat that: Don&#39;t actually send money to this contract. You are \n', ' * likely breaking several local and national laws in doing so.\n', ' * \n', ' * This code is intended to educate. Nothing else. If you use it, expect S.W.A.T \n', ' * teams at your door. I wrote this code because I wanted to experiment\n', ' * with smart contracts, and I think code should be open source. So consider\n', ' * it public domain, No Rights Reserved. Participating in pyramid schemes\n', ' * is genuinely illegal so just don&#39;t even think about going beyond\n', ' * reading the code and understanding how it works.\n', ' * \n', ' * Seriously. I&#39;m not kidding. It&#39;s probablly broken in some critical way anyway\n', ' * and will suck all your money out your wallet, install a virus on your computer\n', ' * sleep with your wife, kidnap your children and sell them into slavery,\n', ' * make you forget to file your taxes, and give you cancer.\n', ' * \n', ' * So.... tl;dr: This contract sucks, don&#39;t send money to it.\n', ' * \n', ' * What it does:\n', ' * \n', ' * It takes 50% of the ETH in it and buys tokens.\n', ' * It takes 50% of the ETH in it and pays back depositors.\n', ' * Depositors get in line and are paid out in order of deposit, plus the deposit\n', ' * percent.\n', ' * The tokens collect dividends, which in turn pay into the payout pool\n', ' * to be split 50/50.\n', ' * \n', ' * If your seeing this contract in it&#39;s initial configuration, it should be\n', ' * set to 200% (double deposits), and pointed at POTJ:\n', ' * 0xC28E860C9132D55A184F9af53FC85e90Aa3A0153\n', ' * \n', ' * But you should verify this for yourself.\n', ' *  \n', ' *  \n', ' */\n', '\n', 'contract ERC20Interface {\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '}\n', '\n', 'contract POTJ {\n', '    \n', '    function buy(address) public payable returns(uint256);\n', '    function withdraw() public;\n', '    function myTokens() public view returns(uint256);\n', '    function myDividends(bool) public view returns(uint256);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public ownerCandidate;\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        ownerCandidate = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == ownerCandidate);  \n', '        owner = ownerCandidate;\n', '    }\n', '    \n', '}\n', '\n', 'contract IronHands is Owned {\n', '    \n', '    /**\n', '     * Modifiers\n', '     */\n', '     \n', '    /**\n', '     * Only owners are allowed.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * The tokens can never be stolen.\n', '     */\n', '    modifier notPotj(address aContract) {\n', '        require(aContract != address(potj));\n', '        _;\n', '    }\n', '   \n', '    /**\n', '     * Events\n', '     */\n', '    event Deposit(uint256 amount, address depositer);\n', '    event Purchase(uint256 amountSpent, uint256 tokensReceived);\n', '    event Payout(uint256 amount, address creditor);\n', '    event Dividends(uint256 amount);\n', '    event ContinuityBreak(uint256 position, address skipped, uint256 amount);\n', '    event ContinuityAppeal(uint256 oldPosition, uint256 newPosition, address appealer);\n', '\n', '    /**\n', '     * Structs\n', '     */\n', '    struct Participant {\n', '        address etherAddress;\n', '        uint256 payout;\n', '    }\n', '\n', '    //Total ETH managed over the lifetime of the contract\n', '    uint256 throughput;\n', '    //Total ETH received from dividends\n', '    uint256 dividends;\n', '    //The percent to return to depositers. 100 for 00%, 200 to double, etc.\n', '    uint256 public multiplier;\n', '    //Where in the line we are with creditors\n', '    uint256 public payoutOrder = 0;\n', '    //How much is owed to people\n', '    uint256 public backlog = 0;\n', '    //The creditor line\n', '    Participant[] public participants;\n', '    //How much each person is owed\n', '    mapping(address => uint256) public creditRemaining;\n', '    //What we will be buying\n', '    POTJ potj;\n', '    \n', '    address sender;\n', '\n', '    /**\n', '     * Constructor\n', '     */\n', '    function IronHands(uint multiplierPercent, address potjAddress) public {\n', '        multiplier = multiplierPercent;\n', '        potj = POTJ(potjAddress);\n', '        sender = msg.sender;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Fallback function allows anyone to send money for the cost of gas which\n', '     * goes into the pool. Used by withdraw/dividend payouts so it has to be cheap.\n', '     */\n', '    function() payable public {\n', '        if (msg.sender != address(potj)) {\n', '            deposit();\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * Deposit ETH to get in line to be credited back the multiplier as a percent,\n', '     * add that ETH to the pool, get the dividends and put them in the pool,\n', '     * then pay out who we owe and buy more tokens.\n', '     */ \n', '    function deposit() payable public {\n', '        //You have to send more than 1000000 wei.\n', '        require(msg.value > 1000000);\n', '        //Compute how much to pay them\n', '        uint256 amountCredited = (msg.value * multiplier) / 100;\n', '        //Get in line to be paid back.\n', '        participants.push(Participant(sender, amountCredited));\n', '        //Increase the backlog by the amount owed\n', '        backlog += amountCredited;\n', '        //Increase the amount owed to this address\n', '        creditRemaining[sender] += amountCredited;\n', '        //Emit a deposit event.\n', '        emit Deposit(msg.value, sender);\n', '        //If I have dividends\n', '        if(myDividends() > 0){\n', '            //Withdraw dividends\n', '            withdraw();\n', '        }\n', '        //Pay people out and buy more tokens.\n', '        payout();\n', '    }\n', '    \n', '    /**\n', '     * Take 50% of the money and spend it on tokens, which will pay dividends later.\n', '     * Take the other 50%, and use it to pay off depositors.\n', '     */\n', '    function payout() public {\n', '        //Take everything in the pool\n', '        uint balance = address(this).balance;\n', '        //It needs to be something worth splitting up\n', '        require(balance > 1);\n', '        //Increase our total throughput\n', '        throughput += balance;\n', '        //Split it into two parts\n', '        uint investment = balance / 2 ether + 1 szabo; // avoid rounding issues\n', '        //Take away the amount we are investing from the amount to send\n', '        balance -= investment;\n', '        //Invest it in more tokens.\n', '        uint256 tokens = potj.buy.value(investment).gas(1000000)(msg.sender);\n', '        //Record that tokens were purchased\n', '        emit Purchase(investment, tokens);\n', '        //While we still have money to send\n', '        while (balance > 0) {\n', '            //Either pay them what they are owed or however much we have, whichever is lower.\n', '            uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;\n', '            //if we have something to pay them\n', '            if(payoutToSend > 0) {\n', '                //subtract how much we&#39;ve spent\n', '                balance -= payoutToSend;\n', '                //subtract the amount paid from the amount owed\n', '                backlog -= payoutToSend;\n', '                //subtract the amount remaining they are owed\n', '                creditRemaining[participants[payoutOrder].etherAddress] -= payoutToSend;\n', '                //credit their account the amount they are being paid\n', '                participants[payoutOrder].payout -= payoutToSend;\n', '                //Try and pay them, making best effort. But if we fail? Run out of gas? That&#39;s not our problem any more.\n', '                if(participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)()) {\n', '                    //Record that they were paid\n', '                    emit Payout(payoutToSend, participants[payoutOrder].etherAddress);\n', '                } else {\n', '                    //undo the accounting, they are being skipped because they are not payable.\n', '                    balance += payoutToSend;\n', '                    backlog += payoutToSend;\n', '                    creditRemaining[participants[payoutOrder].etherAddress] += payoutToSend;\n', '                    participants[payoutOrder].payout += payoutToSend;\n', '                }\n', '\n', '            }\n', '            //If we still have balance left over\n', '            if(balance > 0) {\n', '                // go to the next person in line\n', '                payoutOrder += 1;\n', '            }\n', '            //If we&#39;ve run out of people to pay, stop\n', '            if(payoutOrder >= participants.length) {\n', '                return;\n', '            }\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * Number of tokens the contract owns.\n', '     */\n', '    function myTokens() public view returns(uint256) {\n', '        return potj.myTokens();\n', '    }\n', '    \n', '    /**\n', '     * Number of dividends owed to the contract.\n', '     */\n', '    function myDividends() public view returns(uint256) {\n', '        return potj.myDividends(true);\n', '    }\n', '    \n', '    /**\n', '     * Number of dividends received by the contract.\n', '     */\n', '    function totalDividends() public view returns(uint256) {\n', '        return dividends;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Request dividends be paid out and added to the pool.\n', '     */\n', '    function withdraw() public {\n', '        uint256 balance = address(this).balance;\n', '        potj.withdraw.gas(1000000)();\n', '        uint256 dividendsPaid = address(this).balance - balance;\n', '        dividends += dividendsPaid;\n', '        emit Dividends(dividendsPaid);\n', '    }\n', '    \n', '    /**\n', '     * Number of participants who are still owed.\n', '     */\n', '    function backlogLength() public view returns (uint256) {\n', '        return participants.length - payoutOrder;\n', '    }\n', '    \n', '    /**\n', '     * Total amount still owed in credit to depositors.\n', '     */\n', '    function backlogAmount() public view returns (uint256) {\n', '        return backlog;\n', '    } \n', '    \n', '    /**\n', '     * Total number of deposits in the lifetime of the contract.\n', '     */\n', '    function totalParticipants() public view returns (uint256) {\n', '        return participants.length;\n', '    }\n', '    \n', '    /**\n', '     * Total amount of ETH that the contract has delt with so far.\n', '     */\n', '    function totalSpent() public view returns (uint256) {\n', '        return throughput;\n', '    }\n', '    \n', '    /**\n', '     * Amount still owed to an individual address\n', '     */\n', '    function amountOwed(address anAddress) public view returns (uint256) {\n', '        return creditRemaining[anAddress];\n', '    }\n', '     \n', '     /**\n', '      * Amount owed to this person.\n', '      */\n', '    function amountIAmOwed() public view returns (uint256) {\n', '        return amountOwed(msg.sender);\n', '    }\n', '    \n', '    /**\n', '     * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.\n', '     */\n', '    function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner notPotj(tokenAddress) returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);\n', '    }\n', '    \n', '}']
['pragma solidity 0.4.23;\n', '\n', '/*\n', ' * ATTENTION!\n', ' * \n', ' * This code? IS NOT DESIGNED FOR ACTUAL USE.\n', ' * \n', " * The author of this code really wishes you wouldn't send your ETH to it.\n", ' * \n', " * No, seriously. It's probablly illegal anyway. So don't do it.\n", ' * \n', " * Let me repeat that: Don't actually send money to this contract. You are \n", ' * likely breaking several local and national laws in doing so.\n', ' * \n', ' * This code is intended to educate. Nothing else. If you use it, expect S.W.A.T \n', ' * teams at your door. I wrote this code because I wanted to experiment\n', ' * with smart contracts, and I think code should be open source. So consider\n', ' * it public domain, No Rights Reserved. Participating in pyramid schemes\n', " * is genuinely illegal so just don't even think about going beyond\n", ' * reading the code and understanding how it works.\n', ' * \n', " * Seriously. I'm not kidding. It's probablly broken in some critical way anyway\n", ' * and will suck all your money out your wallet, install a virus on your computer\n', ' * sleep with your wife, kidnap your children and sell them into slavery,\n', ' * make you forget to file your taxes, and give you cancer.\n', ' * \n', " * So.... tl;dr: This contract sucks, don't send money to it.\n", ' * \n', ' * What it does:\n', ' * \n', ' * It takes 50% of the ETH in it and buys tokens.\n', ' * It takes 50% of the ETH in it and pays back depositors.\n', ' * Depositors get in line and are paid out in order of deposit, plus the deposit\n', ' * percent.\n', ' * The tokens collect dividends, which in turn pay into the payout pool\n', ' * to be split 50/50.\n', ' * \n', " * If your seeing this contract in it's initial configuration, it should be\n", ' * set to 200% (double deposits), and pointed at POTJ:\n', ' * 0xC28E860C9132D55A184F9af53FC85e90Aa3A0153\n', ' * \n', ' * But you should verify this for yourself.\n', ' *  \n', ' *  \n', ' */\n', '\n', 'contract ERC20Interface {\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '}\n', '\n', 'contract POTJ {\n', '    \n', '    function buy(address) public payable returns(uint256);\n', '    function withdraw() public;\n', '    function myTokens() public view returns(uint256);\n', '    function myDividends(bool) public view returns(uint256);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public ownerCandidate;\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        ownerCandidate = _newOwner;\n', '    }\n', '    \n', '    function acceptOwnership() public {\n', '        require(msg.sender == ownerCandidate);  \n', '        owner = ownerCandidate;\n', '    }\n', '    \n', '}\n', '\n', 'contract IronHands is Owned {\n', '    \n', '    /**\n', '     * Modifiers\n', '     */\n', '     \n', '    /**\n', '     * Only owners are allowed.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * The tokens can never be stolen.\n', '     */\n', '    modifier notPotj(address aContract) {\n', '        require(aContract != address(potj));\n', '        _;\n', '    }\n', '   \n', '    /**\n', '     * Events\n', '     */\n', '    event Deposit(uint256 amount, address depositer);\n', '    event Purchase(uint256 amountSpent, uint256 tokensReceived);\n', '    event Payout(uint256 amount, address creditor);\n', '    event Dividends(uint256 amount);\n', '    event ContinuityBreak(uint256 position, address skipped, uint256 amount);\n', '    event ContinuityAppeal(uint256 oldPosition, uint256 newPosition, address appealer);\n', '\n', '    /**\n', '     * Structs\n', '     */\n', '    struct Participant {\n', '        address etherAddress;\n', '        uint256 payout;\n', '    }\n', '\n', '    //Total ETH managed over the lifetime of the contract\n', '    uint256 throughput;\n', '    //Total ETH received from dividends\n', '    uint256 dividends;\n', '    //The percent to return to depositers. 100 for 00%, 200 to double, etc.\n', '    uint256 public multiplier;\n', '    //Where in the line we are with creditors\n', '    uint256 public payoutOrder = 0;\n', '    //How much is owed to people\n', '    uint256 public backlog = 0;\n', '    //The creditor line\n', '    Participant[] public participants;\n', '    //How much each person is owed\n', '    mapping(address => uint256) public creditRemaining;\n', '    //What we will be buying\n', '    POTJ potj;\n', '    \n', '    address sender;\n', '\n', '    /**\n', '     * Constructor\n', '     */\n', '    function IronHands(uint multiplierPercent, address potjAddress) public {\n', '        multiplier = multiplierPercent;\n', '        potj = POTJ(potjAddress);\n', '        sender = msg.sender;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Fallback function allows anyone to send money for the cost of gas which\n', '     * goes into the pool. Used by withdraw/dividend payouts so it has to be cheap.\n', '     */\n', '    function() payable public {\n', '        if (msg.sender != address(potj)) {\n', '            deposit();\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * Deposit ETH to get in line to be credited back the multiplier as a percent,\n', '     * add that ETH to the pool, get the dividends and put them in the pool,\n', '     * then pay out who we owe and buy more tokens.\n', '     */ \n', '    function deposit() payable public {\n', '        //You have to send more than 1000000 wei.\n', '        require(msg.value > 1000000);\n', '        //Compute how much to pay them\n', '        uint256 amountCredited = (msg.value * multiplier) / 100;\n', '        //Get in line to be paid back.\n', '        participants.push(Participant(sender, amountCredited));\n', '        //Increase the backlog by the amount owed\n', '        backlog += amountCredited;\n', '        //Increase the amount owed to this address\n', '        creditRemaining[sender] += amountCredited;\n', '        //Emit a deposit event.\n', '        emit Deposit(msg.value, sender);\n', '        //If I have dividends\n', '        if(myDividends() > 0){\n', '            //Withdraw dividends\n', '            withdraw();\n', '        }\n', '        //Pay people out and buy more tokens.\n', '        payout();\n', '    }\n', '    \n', '    /**\n', '     * Take 50% of the money and spend it on tokens, which will pay dividends later.\n', '     * Take the other 50%, and use it to pay off depositors.\n', '     */\n', '    function payout() public {\n', '        //Take everything in the pool\n', '        uint balance = address(this).balance;\n', '        //It needs to be something worth splitting up\n', '        require(balance > 1);\n', '        //Increase our total throughput\n', '        throughput += balance;\n', '        //Split it into two parts\n', '        uint investment = balance / 2 ether + 1 szabo; // avoid rounding issues\n', '        //Take away the amount we are investing from the amount to send\n', '        balance -= investment;\n', '        //Invest it in more tokens.\n', '        uint256 tokens = potj.buy.value(investment).gas(1000000)(msg.sender);\n', '        //Record that tokens were purchased\n', '        emit Purchase(investment, tokens);\n', '        //While we still have money to send\n', '        while (balance > 0) {\n', '            //Either pay them what they are owed or however much we have, whichever is lower.\n', '            uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;\n', '            //if we have something to pay them\n', '            if(payoutToSend > 0) {\n', "                //subtract how much we've spent\n", '                balance -= payoutToSend;\n', '                //subtract the amount paid from the amount owed\n', '                backlog -= payoutToSend;\n', '                //subtract the amount remaining they are owed\n', '                creditRemaining[participants[payoutOrder].etherAddress] -= payoutToSend;\n', '                //credit their account the amount they are being paid\n', '                participants[payoutOrder].payout -= payoutToSend;\n', "                //Try and pay them, making best effort. But if we fail? Run out of gas? That's not our problem any more.\n", '                if(participants[payoutOrder].etherAddress.call.value(payoutToSend).gas(1000000)()) {\n', '                    //Record that they were paid\n', '                    emit Payout(payoutToSend, participants[payoutOrder].etherAddress);\n', '                } else {\n', '                    //undo the accounting, they are being skipped because they are not payable.\n', '                    balance += payoutToSend;\n', '                    backlog += payoutToSend;\n', '                    creditRemaining[participants[payoutOrder].etherAddress] += payoutToSend;\n', '                    participants[payoutOrder].payout += payoutToSend;\n', '                }\n', '\n', '            }\n', '            //If we still have balance left over\n', '            if(balance > 0) {\n', '                // go to the next person in line\n', '                payoutOrder += 1;\n', '            }\n', "            //If we've run out of people to pay, stop\n", '            if(payoutOrder >= participants.length) {\n', '                return;\n', '            }\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * Number of tokens the contract owns.\n', '     */\n', '    function myTokens() public view returns(uint256) {\n', '        return potj.myTokens();\n', '    }\n', '    \n', '    /**\n', '     * Number of dividends owed to the contract.\n', '     */\n', '    function myDividends() public view returns(uint256) {\n', '        return potj.myDividends(true);\n', '    }\n', '    \n', '    /**\n', '     * Number of dividends received by the contract.\n', '     */\n', '    function totalDividends() public view returns(uint256) {\n', '        return dividends;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Request dividends be paid out and added to the pool.\n', '     */\n', '    function withdraw() public {\n', '        uint256 balance = address(this).balance;\n', '        potj.withdraw.gas(1000000)();\n', '        uint256 dividendsPaid = address(this).balance - balance;\n', '        dividends += dividendsPaid;\n', '        emit Dividends(dividendsPaid);\n', '    }\n', '    \n', '    /**\n', '     * Number of participants who are still owed.\n', '     */\n', '    function backlogLength() public view returns (uint256) {\n', '        return participants.length - payoutOrder;\n', '    }\n', '    \n', '    /**\n', '     * Total amount still owed in credit to depositors.\n', '     */\n', '    function backlogAmount() public view returns (uint256) {\n', '        return backlog;\n', '    } \n', '    \n', '    /**\n', '     * Total number of deposits in the lifetime of the contract.\n', '     */\n', '    function totalParticipants() public view returns (uint256) {\n', '        return participants.length;\n', '    }\n', '    \n', '    /**\n', '     * Total amount of ETH that the contract has delt with so far.\n', '     */\n', '    function totalSpent() public view returns (uint256) {\n', '        return throughput;\n', '    }\n', '    \n', '    /**\n', '     * Amount still owed to an individual address\n', '     */\n', '    function amountOwed(address anAddress) public view returns (uint256) {\n', '        return creditRemaining[anAddress];\n', '    }\n', '     \n', '     /**\n', '      * Amount owed to this person.\n', '      */\n', '    function amountIAmOwed() public view returns (uint256) {\n', '        return amountOwed(msg.sender);\n', '    }\n', '    \n', '    /**\n', '     * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.\n', '     */\n', '    function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public onlyOwner notPotj(tokenAddress) returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);\n', '    }\n', '    \n', '}']

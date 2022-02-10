['pragma solidity ^0.4.11;\n', '\n', '//defines the contract (this is the entire program basically)\n', '\n', 'contract TeaToken {\n', '    //Definition section. To the non-devs, define means "tell the compiler this concept exists and if I mention it later this is what im talking about" \n', '\n', '    //please note that define does not mean fill with data, that happens later on. Im merely telling the computer these variables exist so it doesnt get confused later.\n', '\n', '    uint256 public pricePreSale = 1000000 wei;                       //this is how much each token costs\n', '\n', '    uint256 public priceStage1 = 2000000 wei;         \n', '\n', '    uint256 public priceStage2 = 4000000 wei;         \n', '\n', '    uint256 tea_tokens;\n', '\n', '    mapping(address => uint256) public balanceOf;               //this is used to measure how much money some wallet just sent us\n', '\n', '    bool public crowdsaleOpen = true;                               //this is a true-false statement that tells the program whether or not the crowdsale is still going. Unlike the others, this one actually does have data saved to it via the = false;\n', '\n', '    string public name = "TeaToken";                             //this is the name of the token, what normies will see in their Ether Wallets\n', '\n', '    string public symbol = "TEAT";\n', '\n', '    uint256 public decimals = 8;\n', '\n', '    uint256 durationInMinutes = 10080;              // one week\n', '\n', '    uint256 public totalAmountOfTeatokensCreated = 0;\n', '\n', '    uint256 public totalAmountOfWeiCollected = 0;\n', '\n', '    uint256 public preSaleDeadline = now + durationInMinutes * 1 minutes;         //how long until the crowdsale ends\n', '\n', '    uint256 public icoStage1Deadline = now + (durationInMinutes * 2) * 1 minutes;         //how long until the crowdsale ends\n', '\n', '    uint256 deadmanSwitchDeadline = now + (durationInMinutes * 4) * 1 minutes;         //how long until the crowdsale ends\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Payout(address indexed to, uint256 value);\n', '\n', '    //How the cost of each token works. There are no floats in ethereum. A float is a decimal place number for the non-devs. So in order to do less than one ether you have to define it in subunits. 1000 finney is one ether, and 1000 szabo is one finney. So 1 finney will buy you 10 TeaTokens, or one ETH will buy you 10,000 TeaTokens. This means one TeaToken during presale will cost exactly 100 szabo.\n', '\n', '    //1 szabo is a trillion wei\n', '\n', '    //definitions for disbursement\n', '\n', '    address address1 = 0xa1288081489C16bA450AfE33D1E1dF97D33c85fC;//prog\n', '    address address2 = 0x2DAAf6754DbE3714C0d46ACe2636eb43671034D6;//undiscolsed\n', '    address address3 = 0x86165fd44C96d4eE1e7038D27301E9804D908f0a;//ariana\n', '    address address4 = 0x18555e00bDAEd991f30e530B47fB1c21F93F0389;//biz\n', '    address address5 = 0xB64BD3310445562802f18e188Bf571D479105029;//potato\n', '    address address6 = 0x925F937721E56d06401FC4D191F411382127Df83;//ugly\n', '    address address7 = 0x13688Dd97616f85A363d715509529cFdfe489663;//architectl\n', '    address address8 = 0xC89dB702363E8a100a4b04fDF41c9Dfee572627B;//johnny\n', '    address address9 = 0xB11b98305e4d55610EB18C480477A6984Aa7f7e2;//thawk\n', '    address address10 = 0xb2Ef8eae3ADdB4E66268b49467eeA64F6cD937cf;//danielt\n', '    address address11 = 0x46e8180a477349013434e191E63f2AFD645fd153;//drschultz\n', '    address address12 = 0xC7b32902a15c02F956F978E9F5A3e43342266bf2;//nos\n', '    address address13 = 0xA0b43B97B66a84F3791DE513cC8a35213325C1Ba;//bigmoney\n', '    address address14 = 0xAEe620D07c16c92A7e8E01C096543048ab591bf9;//dinkin\n', '    \n', '\n', '    address[] adds = [address1, address2, address3, address4, address5, address6, address7, address8, address9, address10, address11, address12, address13, address14];\n', '    uint numAddresses = adds.length;\n', '    uint sendValue;\n', '\n', '    //controller addresses\n', '    //these are the addresses of programmanon, ariana and bizraeli. We can use these to control the contract.\n', '    address controllerAddress1 = 0x86165fd44C96d4eE1e7038D27301E9804D908f0a;//ari\n', '    address controllerAddress2 = 0xa1288081489C16bA450AfE33D1E1dF97D33c85fC;//prog\n', '    address controllerAddress3 = 0x18555e00bDAEd991f30e530B47fB1c21F93F0389;//biz\n', '\n', '    /* The function without name is the default function that is called whenever anyone sends funds to a contract. The keyword payable makes sure that this contract can recieve money. */\n', '\n', '\n', '\n', '    function () payable {\n', '\n', '\n', '\n', '        //if (crowdsaleOpen) throw;     //throw means reject the transaction. This will prevent people from accidentally sending money to a crowdsale that is already closed.\n', '        require(crowdsaleOpen);\n', '\n', '        uint256 amount = msg.value;                            //measures how many ETH coins they sent us (the message) and stores it as an integer called "amount"\n', '        //presale\n', '\n', '        if (now <= preSaleDeadline){\n', '        tea_tokens = (amount / pricePreSale);  \n', '        //stage 1\n', '\n', '        }else if (now <= icoStage1Deadline){\n', '        tea_tokens = (amount / priceStage1);  \n', '        //stage 2\n', '        }else{\n', '        tea_tokens = (amount / priceStage2);                        //calculates their total amount of tokens bought\n', '        }\n', '\n', '        totalAmountOfWeiCollected += amount;                        //this keeps track of overall profits collected\n', '        totalAmountOfTeatokensCreated += (tea_tokens/100000000);    //this keeps track of the planetary supply of TEA\n', '        balanceOf[msg.sender] += tea_tokens;                        //this adds the reward to their total.\n', '    }\n', '\n', '//this is how we get our money out. It can only be activated after the deadline currently.\n', '\n', '    function safeWithdrawal() {\n', '\n', '        //this checks to see if the sender is actually authorized to trigger the withdrawl. The sender must be the beneficiary in this case or it wont work.\n', '        //the now >= deadline*3 line acts as a deadman switch, ensuring that anyone in the world can trigger the fund release after the specified time\n', '\n', '        require(controllerAddress1 == msg.sender || controllerAddress2 == msg.sender || controllerAddress3 == msg.sender || now >= deadmanSwitchDeadline);\n', '        require(this.balance > 0);\n', '\n', '        uint256 sendValue = this.balance / numAddresses;\n', '        for (uint256 i = 0; i<numAddresses; i++){\n', '\n', '                //for the very final address, send the entire remaining balance instead of the divisor. This is to prevent remainders being left behind.\n', '\n', '                if (i == numAddresses-1){\n', '\n', '                Payout(adds[i], this.balance);\n', '\n', '                if (adds[i].send(this.balance)){}\n', '\n', '                }\n', '                else Payout(adds[i], sendValue);\n', '                if (adds[i].send(sendValue)){}\n', '            }\n', '\n', '    }\n', '\n', '    //this is used to turn off the crowdsale during stage 3. It can also be used to shut down all crowdsales permanently at any stage. It ends the ICO no matter what.\n', '\n', '\n', '\n', '    function endCrowdsale() {\n', '        //this checks to see if the sender is actually authorized to trigger the withdrawl. The sender must be the beneficiary in this case or it wont work.\n', '\n', '        require(controllerAddress1 == msg.sender || controllerAddress2 == msg.sender || controllerAddress3 == msg.sender || now >= deadmanSwitchDeadline);\n', '        //shuts down the crowdsale\n', '        crowdsaleOpen = false;\n', '    }\n', '    /* Allows users to send tokens to each other, to act as money */\n', '    //this is the part of the program that allows exchange between the normies. \n', '    //This has nothing to do with the actual contract execution, this is so people can trade it back and fourth with each other and exchanges.\n', '    //Without this section the TeaTokens would be trapped in their account forever, unable to move.\n', '\n', '    function transfer(address _to, uint256 _value) {\n', '\n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows. If someone sent like 500 googolplex tokens it would actually go back to zero again because of an overflow. Computerized integers can only store so many numbers before they run out of room for more. This prevents that from causing a problem. Fun fact: this shit right here is what caused the Y2K bug everyone was panicking about back in 1999\n', '\n', '        balanceOf[msg.sender] -= _value;                     // Subtract from the sender\n', '\n', '        balanceOf[_to] += _value;                            // Add the same to the recipient\n', '\n', '        /* Notify anyone listening that this transfer took place */\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '}']
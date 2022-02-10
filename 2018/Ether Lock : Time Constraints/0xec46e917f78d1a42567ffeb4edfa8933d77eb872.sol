['pragma solidity ^0.4.25;\n', '\n', '/**\n', '  Multiplier ETHMOON: returns 125% of each investment!\n', '  Fully transparent smartcontract with automatic payments proven professionals.\n', '  An additional level of protection against fraud - you can make only two deposits, until you get 125%.\n', '\n', '  1. Send any sum to smart contract address\n', '     - sum from 0.01 to 5 ETH\n', '     - min 250000 gas limit\n', '     - you are added to a queue\n', '     - only two deposit until you got 125%\n', '  2. Wait a little bit\n', '  3. ...\n', '  4. PROFIT! You have got 125%\n', '\n', '  How is that?\n', '  1. The first investor in the queue (you will become the\n', '     first in some time) receives next investments until\n', '     it become 125% of his initial investment.\n', '  2. You will receive payments in several parts or all at once\n', '  3. Once you receive 125% of your initial investment you are\n', '     removed from the queue.\n', '  4. You can make no more than two deposits at once\n', '  5. The balance of this contract should normally be 0 because\n', '     all the money are immediately go to payouts\n', '\n', '\n', '     So the last pays to the first (or to several first ones\n', '     if the deposit big enough) and the investors paid 125% are removed from the queue\n', '\n', '                new investor --|               brand new investor --|\n', '                 investor5     |                 new investor       |\n', '                 investor4     |     =======>      investor5        |\n', '                 investor3     |                   investor4        |\n', '    (part. paid) investor2    <|                   investor3        |\n', '    (fully paid) investor1   <-|                   investor2   <----|  (pay until 125%)\n', '\n', '\n', '  Контракт ETHMOON: возвращает 125% от вашего депозита!\n', '  Полностью прозрачный смартконтракт с автоматическими выплатами, проверенный профессионалами.\n', '  Дополнительный уровень защиты от обмана - вы сможете внести только два депозита, пока вы не получите 125%.\n', '\n', '  1. Пошлите любую ненулевую сумму на адрес контракта\n', '     - сумма от 0.01 до 5 ETH\n', '     - gas limit минимум 250000\n', '     - вы встанете в очередь\n', '     - только два депозита, пока не получите 125%\n', '  2. Немного подождите\n', '  3. ...\n', '  4. PROFIT! Вам пришло 125% от вашего депозита.\n', '\n', '  Как это возможно?\n', '  1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от\n', '     новых инвесторов до тех пор, пока не получит 125% от своего депозита\n', '  2. Выплаты могут приходить несколькими частями или все сразу\n', '  3. Как только вы получаете 125% от вашего депозита, вы удаляетесь из очереди\n', '  4. Вы можете делать не больше двух депозитов сразу\n', '  5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления\n', '     сразу же направляются на выплаты\n', '\n', '     Таким образом, последние платят первым, и инвесторы, достигшие выплат 125% от депозита,\n', '     удаляются из очереди, уступая место остальным\n', '\n', '              новый инвестор --|            совсем новый инвестор --|\n', '                 инвестор5     |                новый инвестор      |\n', '                 инвестор4     |     =======>      инвестор5        |\n', '                 инвестор3     |                   инвестор4        |\n', ' (част. выплата) инвестор2    <|                   инвестор3        |\n', '(полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 125%)\n', '\n', '*/\n', '\n', '\n', 'contract Ethmoon {\n', '    // address for promo expences\n', '    address constant private PROMO = 0xa4Db4f62314Db6539B60F0e1CBE2377b918953Bd;\n', '    address constant private TECH = 0x093D552Bde4D55D2e32dedA3a04D3B2ceA2B5595;\n', '    // percent for promo/tech expences\n', '    uint constant public PROMO_PERCENT = 6;\n', '    uint constant public TECH_PERCENT = 2;\n', '    // how many percent for your deposit to be multiplied\n', '    uint constant public MULTIPLIER = 125;\n', '    // deposit limits\n', '    uint constant public MIN_DEPOSIT = .01 ether;\n', '    uint constant public MAX_DEPOSIT = 5 ether;\n', '\n', '    // the deposit structure holds all the info about the deposit made\n', '    struct Deposit {\n', '        address depositor; // the depositor address\n', '        uint128 deposit;   // the deposit amount\n', '        uint128 expect;    // how much we should pay out (initially it is 125% of deposit)\n', '    }\n', '\n', '    Deposit[] private queue;  // the queue\n', '    uint public currentReceiverIndex = 0; // the index of the first depositor in the queue. The receiver of investments!\n', '\n', '    // this function receives all the deposits\n', '    // stores them and make immediate payouts\n', '    function () public payable {\n', '        require(gasleft() >= 220000, "We require more gas!"); // we need gas to process queue\n', '        require((msg.value >= MIN_DEPOSIT) && (msg.value <= MAX_DEPOSIT)); // do not allow too big investments to stabilize payouts\n', '        require(getDepositsCount(msg.sender) < 2); // not allow more than 2 deposit in until you to receive 125% of deposit back\n', '\n', '        // add the investor into the queue. Mark that he expects to receive 125% of deposit back\n', '        queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * MULTIPLIER/100)));\n', '\n', '        // send some promo to enable this contract to leave long-long time\n', '        uint promo = msg.value * PROMO_PERCENT/100;\n', '        PROMO.transfer(promo);\n', '        uint tech = msg.value * TECH_PERCENT/100;\n', '        TECH.transfer(tech);\n', '\n', '        // pay to first investors in line\n', '        pay();\n', '    }\n', '\n', '    // used to pay to current investors\n', '    // each new transaction processes 1 - 4+ investors in the head of queue \n', '    // depending on balance and gas left\n', '    function pay() private {\n', '        // try to send all the money on contract to the first investors in line\n', '        uint128 money = uint128(address(this).balance);\n', '\n', '        // we will do cycle on the queue\n', '        for (uint i=0; i<queue.length; i++) {\n', '            uint idx = currentReceiverIndex + i;  // get the index of the currently first investor\n', '\n', '            Deposit storage dep = queue[idx]; // get the info of the first investor\n', '\n', '            if (money >= dep.expect) {  // if we have enough money on the contract to fully pay to investor\n', '                dep.depositor.transfer(dep.expect); // send money to him\n', '                money -= dep.expect;            // update money left\n', '\n', '                // this investor is fully paid, so remove him\n', '                delete queue[idx];\n', '            } else {\n', "                // here we don't have enough money so partially pay to investor\n", '                dep.depositor.transfer(money); // send to him everything we have\n', '                dep.expect -= money;       // update the expected amount\n', '                break;                     // exit cycle\n', '            }\n', '\n', '            if (gasleft() <= 50000)         // check the gas left. If it is low, exit the cycle\n', '                break;                     // the next investor will process the line further\n', '        }\n', '\n', '        currentReceiverIndex += i; // update the index of the current first investor\n', '    }\n', '\n', '    // get the deposit info by its index\n', '    // you can get deposit index from\n', '    function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){\n', '        Deposit storage dep = queue[idx];\n', '        return (dep.depositor, dep.deposit, dep.expect);\n', '    }\n', '\n', '    // get the count of deposits of specific investor\n', '    function getDepositsCount(address depositor) public view returns (uint) {\n', '        uint c = 0;\n', '        for (uint i=currentReceiverIndex; i<queue.length; ++i) {\n', '            if(queue[i].depositor == depositor)\n', '                c++;\n', '        }\n', '        return c;\n', '    }\n', '\n', '    // get all deposits (index, deposit, expect) of a specific investor\n', '    function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {\n', '        uint c = getDepositsCount(depositor);\n', '\n', '        idxs = new uint[](c);\n', '        deposits = new uint128[](c);\n', '        expects = new uint128[](c);\n', '\n', '        if (c > 0) {\n', '            uint j = 0;\n', '            for (uint i=currentReceiverIndex; i<queue.length; ++i) {\n', '                Deposit storage dep = queue[i];\n', '                if (dep.depositor == depositor) {\n', '                    idxs[j] = i;\n', '                    deposits[j] = dep.deposit;\n', '                    expects[j] = dep.expect;\n', '                    j++;\n', '                }\n', '            }\n', '        }\n', '    }\n', '    \n', '    // get current queue size\n', '    function getQueueLength() public view returns (uint) {\n', '        return queue.length - currentReceiverIndex;\n', '    }\n', '}']
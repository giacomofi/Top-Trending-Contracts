['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' _ _ _  _____  _____  _____  __            ___    _____  _____  _____  _____  _____\n', '| | | ||  |  ||   __||   __||  |      ___ |  _|  |   __||_   _||  |  ||   __|| __  |\n', '| | | ||     ||   __||   __||  |__   | . ||  _|  |   __|  | |  |     ||   __||    -|\n', '|_____||__|__||_____||_____||_____|  |___||_|    |_____|  |_|  |__|__||_____||__|__|\n', '\n', '\n', '\n', '                                  `.-::::::::::::-.`\n', '                           .:::+:-.`            `.-:+:::.\n', '                      `::::.   `-                  -`   .:::-`\n', '                   .:::`        :                  :        `:::.\n', '                `:/-            `-                -`            -/:`\n', '              ./:`               :               `:               `:/.\n', '            .+:                   :              :                  `:+.\n', '          `/-`..`                 -`            `-                 `..`-/`\n', '         :/`    ..`                :            :                `..    `/:\n', '       `+.        ..`              -`          `-              `..        .+`\n', '      .+`           ..`             :          :             `..           `+.\n', '     -+               ..`           -.        ..           `..               +-\n', '    .+                 `..`          :        :          `..                  +.\n', '   `o                    `..`        ..      ..        `..`                    o`\n', '   o`                      `..`     `./------/.`     `..`                      `o\n', '  -+``                       `..``-::.````````.::-``..`                       ``+-\n', '  s```....````                 `+:.  ..------..  .:+`                 ````....```o\n', ' .+       ````...````         .+. `--``      ``--` .+.         ````...````       +.\n', ' +.              ````....`````+` .:`            `:. `o`````....````              ./\n', ' o                       ````s` `/                /` `s````                       o\n', ' s                           s  /`                .:  s                           s\n', ' s                           s  /`                `/  s                           s\n', ' s                        ```s` `/                /` `s```                        o\n', ' +.               ````....```.+  .:`            `:.  +.```....````               .+\n', ' ./        ```....````        -/` `--`        `--` `/.        ````....```        +.\n', '  s````....```                 .+:` `.--------.` `:+.                 ```....````s\n', '  :/```                       ..`.::-.``    ``.-::.`..                       ```/:\n', '   o`                       ..`     `-/-::::-/-`     `..                       `o\n', '   `o                     ..`        ..      ..        `..                     o`\n', '    -/                  ..`          :        :          `..                  /-\n', '     -/               ..`           ..        ..           `..               /-\n', '      -+`           ..`             :          :             `-.           `+-\n', '       .+.        .-`              -`          ..              `-.        .+.\n', '         /:     .-`                :            :                `-.    `:/\n', '          ./- .-`                 -`            `-                 `-. -/.\n', '            -+-                   :              :                   :+-\n', '              -/-`               -`              `-               `-/-\n', '                .:/.             :                :             ./:.\n', '                   -:/-         :                  :         -/:-\n', '                      .:::-`   `-                  -`   `-:::.\n', '                          `-:::+-.`              `.:+:::-`\n', '                                `.-::::::::::::::-.`\n', '\n', '---Design---\n', 'J&#246;rmungandr\n', '\n', '---Contract and Frontend---\n', 'Mr Fahrenheit\n', 'J&#246;rmungandr\n', '\n', '---Contract Auditor---\n', '8 ฿ł₮ ₮Ɽł₱\n', '\n', '---Contract Advisors---\n', 'Etherguy\n', 'Norsefire\n', '\n', '**/\n', '\n', 'contract WheelOfEther {\n', '    using SafeMath for uint;\n', '\n', '    //  Modifiers\n', '\n', '    modifier nonContract() {                // contracts pls go\n', '        require(tx.origin == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier gameActive() {\n', '        require(gamePaused == false);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin(){\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    // Events\n', '\n', '    event onTokenPurchase(\n', '        address indexed customerAddress,\n', '        uint256 ethereumIn,\n', '        uint256 contractBal,\n', '        uint timestamp\n', '    );\n', '\n', '    event onTokenSell(\n', '        address indexed customerAddress,\n', '        uint256 ethereumOut,\n', '        uint256 contractBal,\n', '        uint timestamp\n', '    );\n', '\n', '    event spinResult(\n', '        address indexed customerAddress,\n', '        uint256 wheelNumber,\n', '        uint256 outcome,\n', '        uint256 ethSpent,\n', '        uint256 ethReturned,\n', '        uint256 devFee,\n', '        uint timestamp\n', '    );\n', '\n', '    uint256 _seed;\n', '    address admin;\n', '    bool public gamePaused = false;\n', '    uint256 minBet = 0.01 ether;\n', '    uint256 devFeeBalance = 0;\n', '\n', '    uint8[10] brackets = [1,3,6,12,24,40,56,68,76,80];\n', '\n', '    uint256 internal globalFactor = 1000000000000000000000;\n', '    uint256 constant internal constantFactor = globalFactor * globalFactor;\n', '    mapping(address => uint256) internal personalFactorLedger_;\n', '    mapping(address => uint256) internal balanceLedger_;\n', '\n', '\n', '    constructor()\n', '        public\n', '    {\n', '        admin = msg.sender;\n', '    }\n', '\n', '\n', '    function getBalance()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return this.balance;\n', '    }\n', '\n', '\n', '    function buyTokens()\n', '        public\n', '        payable\n', '        nonContract\n', '        gameActive\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        // User must buy at least 0.01 eth\n', '        require(msg.value >= minBet);\n', '        // Adjust ledgers\n', '        balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).add(msg.value);\n', '        personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '\n', '        onTokenPurchase(_customerAddress, msg.value, this.balance, now);\n', '    }\n', '\n', '\n', '    function sell(uint256 sellEth)\n', '        public\n', '        nonContract\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        // User must have enough eth and cannot sell 0\n', '        require(sellEth <= ethBalanceOf(_customerAddress));\n', '        require(sellEth > 0);\n', '        // Transfer balance and update user ledgers\n', '        _customerAddress.transfer(sellEth);\n', '        balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).sub(sellEth);\n', '\t\tpersonalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '\n', '        onTokenSell(_customerAddress, sellEth, this.balance, now);\n', '    }\n', '\n', '\n', '    function ethBalanceOf(address _customerAddress)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        // Balance ledger * personal factor * globalFactor / constantFactor\n', '        return balanceLedger_[_customerAddress].mul(personalFactorLedger_[_customerAddress]).mul(globalFactor) / constantFactor;\n', '    }\n', '\n', '\n', '    function tokenSpin(uint256 betEth)\n', '        public\n', '        nonContract\n', '        gameActive\n', '        returns (uint256 resultNum)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        // User must have enough eth\n', '        require(ethBalanceOf(_customerAddress) >= betEth);\n', '        // If user bets more than available bet pool, bet only as much as the pool\n', '        if (betEth > betPool(_customerAddress)) {\n', '            betEth = betPool(_customerAddress);\n', '        }\n', '        // User must bet more than the minimum\n', '        require(betEth >= minBet);\n', '        // Execute the bet and return the outcome\n', '        resultNum = bet(betEth, _customerAddress);\n', '    }\n', '\n', '\n', '    function etherSpin()\n', '        public\n', '        payable\n', '        nonContract\n', '        gameActive\n', '        returns (uint256 resultNum)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        uint256 betEth = msg.value;\n', '        // All eth is converted into tokens before the bet\n', '        // If user bets more than available bet pool, bet only as much as the pool\n', '        if (betEth > betPool(_customerAddress)) {\n', '            betEth = betPool(_customerAddress);\n', '        }\n', '        // User must bet more than the minimum\n', '        require(betEth >= minBet);\n', '        // Adjust ledgers\n', '        balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).add(msg.value);\n', '\t\tpersonalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '        // Execute the bet and return the outcome\n', '        resultNum = bet(betEth, _customerAddress);\n', '    }\n', '\n', '\n', '    function betPool(address _customerAddress)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        // Balance of contract, minus eth balance of user and accrued dev fees\n', '        return this.balance.sub(ethBalanceOf(_customerAddress)).sub(devFeeBalance);\n', '    }\n', '\n', '    /*\n', '        panicButton and refundUser are here incase of an emergency, or launch of a new contract\n', '        The game will be frozen, and all token holders will be refunded\n', '    */\n', '\n', '    function panicButton(bool newStatus)\n', '        public\n', '        onlyAdmin\n', '    {\n', '        gamePaused = newStatus;\n', '    }\n', '\n', '\n', '    function refundUser(address _customerAddress)\n', '        public\n', '        onlyAdmin\n', '    {\n', '        uint256 sellEth = ethBalanceOf(_customerAddress);\n', '        _customerAddress.transfer(sellEth);\n', '        balanceLedger_[_customerAddress] = 0;\n', '\t\tpersonalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '        onTokenSell(_customerAddress, sellEth, this.balance, now);\n', '    }\n', '\n', '    function getDevBalance()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return devFeeBalance;\n', '    }\n', '\n', '\n', '    function withdrawDevFees()\n', '        public\n', '        onlyAdmin\n', '    {\n', '        admin.transfer(devFeeBalance);\n', '        devFeeBalance = 0;\n', '    }\n', '\n', '\n', '    // Internal Functions\n', '\n', '\n', '    function bet(uint256 initEth, address _customerAddress)\n', '        internal\n', '        returns (uint256 resultNum)\n', '    {\n', '        // Spin the wheel\n', '        resultNum = random(80);\n', '        // Determine the outcome\n', '        uint result = determinePrize(resultNum);\n', '\n', '        // Add 2% fee to devFeeBalance and remove from user&#39;s balance\n', '        uint256 devFee = initEth / 50;\n', '        devFeeBalance = devFeeBalance.add(devFee);\n', '        balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).sub(devFee);\n', '        personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '\n', '        // Remove the dev fee from the bet amount\n', '        uint256 betEth = initEth - devFee;\n', '\n', '        uint256 returnedEth;\n', '        uint256 prizePool = betPool(_customerAddress);\n', '\n', '\t\tif (result < 5)                                             // < 5 = WIN\n', '\t\t{\n', '\t\t\tuint256 wonEth;\n', '\t\t\tif (result == 0){                                       // Grand Jackpot\n', '\t\t\t\twonEth = grandJackpot(betEth, prizePool);\n', '\t\t\t} else if (result == 1){                                // Jackpot\n', '\t\t\t\twonEth = jackpot(betEth, prizePool);\n', '\t\t\t} else if (result == 2){                                // Grand Prize\n', '\t\t\t\twonEth = betEth / 2;                                // +50% of original bet\n', '\t\t\t} else if (result == 3){                                // Major Prize\n', '\t\t\t\twonEth = betEth / 4;                                // +25% of original bet\n', '\t\t\t} else if (result == 4){                                // Minor Prize\n', '\t\t\t\twonEth = betEth / 10;                               // +10% of original bet\n', '\t\t\t}\n', '\t\t\twinEth(_customerAddress, wonEth);                       // Award the user their prize\n', '            returnedEth = betEth.add(wonEth);\n', '        } else if (result == 5){                                    // 5 = Refund\n', '            returnedEth = betEth;\n', '\t\t}\n', '\t\telse {                                                      // > 5 = LOSE\n', '\t\t\tuint256 lostEth;\n', '\t\t\tif (result == 6){                                \t\t// Minor Loss\n', '\t\t\t\tlostEth = betEth / 4;                    \t\t    // -25% of original bet\n', '\t\t\t} else if (result == 7){                                // Major Loss\n', '\t\t\t\tlostEth = betEth / 2;                     \t\t\t// -50% of original bet\n', '\t\t\t} else if (result == 8){                                // Grand Loss\n', '\t\t\t\tlostEth = betEth.mul(3) / 4;                     \t// -75% of original bet\n', '\t\t\t} else if (result == 9){                                // Total Loss\n', '\t\t\t\tlostEth = betEth;                                   // -100% of original bet\n', '\t\t\t}\n', '\t\t\tloseEth(_customerAddress, lostEth);                     // "Award" the user their loss\n', '            returnedEth = betEth.sub(lostEth);\n', '\t\t}\n', '        spinResult(_customerAddress, resultNum, result, betEth, returnedEth, devFee, now);\n', '        return resultNum;\n', '    }\n', '\n', '    function grandJackpot(uint256 betEth, uint256 prizePool)\n', '        internal\n', '        returns (uint256 wonEth)\n', '    {\n', '        wonEth = betEth / 2;                                        // +50% of original bet\n', '        uint256 max = minBet * 100 * betEth / prizePool;            // Fire the loop a maximum of 100 times\n', '\t\tfor (uint256 i=0;i<max; i+= minBet) {\t\t\t  \t        // Add a % of the remaining Token Pool\n', '            wonEth = wonEth.add((prizePool.sub(wonEth)) / 50);      // +2% of remaining pool\n', '\t\t}\n', '    }\n', '\n', '    function jackpot(uint256 betEth, uint256 prizePool)\n', '        internal\n', '        returns (uint256 wonEth)\n', '    {\n', '        wonEth = betEth / 2;                                        // +50% of original bet\n', '        uint256 max = minBet * 100 * betEth / prizePool;            // Fire the loop a maximum of 100 times\n', '\t\tfor (uint256 i=0;i<max; i+= minBet) {                       // Add a % of the remaining Token Pool\n', '            wonEth = wonEth.add((prizePool.sub(wonEth)) / 100);     // +1% of remaining pool\n', '\t\t}\n', '    }\n', '\n', '    function maxRandom()\n', '        internal\n', '        returns (uint256 randomNumber)\n', '    {\n', '        _seed = uint256(keccak256(\n', '            abi.encodePacked(_seed,\n', '                blockhash(block.number - 1),\n', '                block.coinbase,\n', '                block.difficulty)\n', '        ));\n', '        return _seed;\n', '    }\n', '\n', '\n', '    function random(uint256 upper)\n', '        internal\n', '        returns (uint256 randomNumber)\n', '    {\n', '        return maxRandom() % upper + 1;\n', '    }\n', '\n', '\n', '    function determinePrize(uint256 result)\n', '        internal\n', '        returns (uint256 resultNum)\n', '    {\n', '        // Loop until the result bracket is determined\n', '        for (uint8 i=0;i<=9;i++){\n', '            if (result <= brackets[i]){\n', '                return i;\n', '            }\n', '        }\n', '    }\n', '\n', '\n', '    function loseEth(address _customerAddress, uint256 lostEth)\n', '        internal\n', '    {\n', '        uint256 customerEth = ethBalanceOf(_customerAddress);\n', '        // Increase amount of eth everyone else owns\n', '        uint256 globalIncrease = globalFactor.mul(lostEth) / betPool(_customerAddress);\n', '        globalFactor = globalFactor.add(globalIncrease);\n', '        // Update user ledgers\n', '        personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '        balanceLedger_[_customerAddress] = customerEth.sub(lostEth);\n', '    }\n', '\n', '\n', '    function winEth(address _customerAddress, uint256 wonEth)\n', '        internal\n', '    {\n', '        uint256 customerEth = ethBalanceOf(_customerAddress);\n', '        // Decrease amount of eth everyone else owns\n', '        uint256 globalDecrease = globalFactor.mul(wonEth) / betPool(_customerAddress);\n', '        globalFactor = globalFactor.sub(globalDecrease);\n', '        // Update user ledgers\n', '        personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '        balanceLedger_[_customerAddress] = customerEth.add(wonEth);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' _ _ _  _____  _____  _____  __            ___    _____  _____  _____  _____  _____\n', '| | | ||  |  ||   __||   __||  |      ___ |  _|  |   __||_   _||  |  ||   __|| __  |\n', '| | | ||     ||   __||   __||  |__   | . ||  _|  |   __|  | |  |     ||   __||    -|\n', '|_____||__|__||_____||_____||_____|  |___||_|    |_____|  |_|  |__|__||_____||__|__|\n', '\n', '\n', '\n', '                                  `.-::::::::::::-.`\n', '                           .:::+:-.`            `.-:+:::.\n', '                      `::::.   `-                  -`   .:::-`\n', '                   .:::`        :                  :        `:::.\n', '                `:/-            `-                -`            -/:`\n', '              ./:`               :               `:               `:/.\n', '            .+:                   :              :                  `:+.\n', '          `/-`..`                 -`            `-                 `..`-/`\n', '         :/`    ..`                :            :                `..    `/:\n', '       `+.        ..`              -`          `-              `..        .+`\n', '      .+`           ..`             :          :             `..           `+.\n', '     -+               ..`           -.        ..           `..               +-\n', '    .+                 `..`          :        :          `..                  +.\n', '   `o                    `..`        ..      ..        `..`                    o`\n', '   o`                      `..`     `./------/.`     `..`                      `o\n', '  -+``                       `..``-::.````````.::-``..`                       ``+-\n', '  s```....````                 `+:.  ..------..  .:+`                 ````....```o\n', ' .+       ````...````         .+. `--``      ``--` .+.         ````...````       +.\n', ' +.              ````....`````+` .:`            `:. `o`````....````              ./\n', ' o                       ````s` `/                /` `s````                       o\n', ' s                           s  /`                .:  s                           s\n', ' s                           s  /`                `/  s                           s\n', ' s                        ```s` `/                /` `s```                        o\n', ' +.               ````....```.+  .:`            `:.  +.```....````               .+\n', ' ./        ```....````        -/` `--`        `--` `/.        ````....```        +.\n', '  s````....```                 .+:` `.--------.` `:+.                 ```....````s\n', '  :/```                       ..`.::-.``    ``.-::.`..                       ```/:\n', '   o`                       ..`     `-/-::::-/-`     `..                       `o\n', '   `o                     ..`        ..      ..        `..                     o`\n', '    -/                  ..`          :        :          `..                  /-\n', '     -/               ..`           ..        ..           `..               /-\n', '      -+`           ..`             :          :             `-.           `+-\n', '       .+.        .-`              -`          ..              `-.        .+.\n', '         /:     .-`                :            :                `-.    `:/\n', '          ./- .-`                 -`            `-                 `-. -/.\n', '            -+-                   :              :                   :+-\n', '              -/-`               -`              `-               `-/-\n', '                .:/.             :                :             ./:.\n', '                   -:/-         :                  :         -/:-\n', '                      .:::-`   `-                  -`   `-:::.\n', '                          `-:::+-.`              `.:+:::-`\n', '                                `.-::::::::::::::-.`\n', '\n', '---Design---\n', 'Jörmungandr\n', '\n', '---Contract and Frontend---\n', 'Mr Fahrenheit\n', 'Jörmungandr\n', '\n', '---Contract Auditor---\n', '8 ฿ł₮ ₮Ɽł₱\n', '\n', '---Contract Advisors---\n', 'Etherguy\n', 'Norsefire\n', '\n', '**/\n', '\n', 'contract WheelOfEther {\n', '    using SafeMath for uint;\n', '\n', '    //  Modifiers\n', '\n', '    modifier nonContract() {                // contracts pls go\n', '        require(tx.origin == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier gameActive() {\n', '        require(gamePaused == false);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin(){\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    // Events\n', '\n', '    event onTokenPurchase(\n', '        address indexed customerAddress,\n', '        uint256 ethereumIn,\n', '        uint256 contractBal,\n', '        uint timestamp\n', '    );\n', '\n', '    event onTokenSell(\n', '        address indexed customerAddress,\n', '        uint256 ethereumOut,\n', '        uint256 contractBal,\n', '        uint timestamp\n', '    );\n', '\n', '    event spinResult(\n', '        address indexed customerAddress,\n', '        uint256 wheelNumber,\n', '        uint256 outcome,\n', '        uint256 ethSpent,\n', '        uint256 ethReturned,\n', '        uint256 devFee,\n', '        uint timestamp\n', '    );\n', '\n', '    uint256 _seed;\n', '    address admin;\n', '    bool public gamePaused = false;\n', '    uint256 minBet = 0.01 ether;\n', '    uint256 devFeeBalance = 0;\n', '\n', '    uint8[10] brackets = [1,3,6,12,24,40,56,68,76,80];\n', '\n', '    uint256 internal globalFactor = 1000000000000000000000;\n', '    uint256 constant internal constantFactor = globalFactor * globalFactor;\n', '    mapping(address => uint256) internal personalFactorLedger_;\n', '    mapping(address => uint256) internal balanceLedger_;\n', '\n', '\n', '    constructor()\n', '        public\n', '    {\n', '        admin = msg.sender;\n', '    }\n', '\n', '\n', '    function getBalance()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return this.balance;\n', '    }\n', '\n', '\n', '    function buyTokens()\n', '        public\n', '        payable\n', '        nonContract\n', '        gameActive\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        // User must buy at least 0.01 eth\n', '        require(msg.value >= minBet);\n', '        // Adjust ledgers\n', '        balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).add(msg.value);\n', '        personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '\n', '        onTokenPurchase(_customerAddress, msg.value, this.balance, now);\n', '    }\n', '\n', '\n', '    function sell(uint256 sellEth)\n', '        public\n', '        nonContract\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        // User must have enough eth and cannot sell 0\n', '        require(sellEth <= ethBalanceOf(_customerAddress));\n', '        require(sellEth > 0);\n', '        // Transfer balance and update user ledgers\n', '        _customerAddress.transfer(sellEth);\n', '        balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).sub(sellEth);\n', '\t\tpersonalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '\n', '        onTokenSell(_customerAddress, sellEth, this.balance, now);\n', '    }\n', '\n', '\n', '    function ethBalanceOf(address _customerAddress)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        // Balance ledger * personal factor * globalFactor / constantFactor\n', '        return balanceLedger_[_customerAddress].mul(personalFactorLedger_[_customerAddress]).mul(globalFactor) / constantFactor;\n', '    }\n', '\n', '\n', '    function tokenSpin(uint256 betEth)\n', '        public\n', '        nonContract\n', '        gameActive\n', '        returns (uint256 resultNum)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        // User must have enough eth\n', '        require(ethBalanceOf(_customerAddress) >= betEth);\n', '        // If user bets more than available bet pool, bet only as much as the pool\n', '        if (betEth > betPool(_customerAddress)) {\n', '            betEth = betPool(_customerAddress);\n', '        }\n', '        // User must bet more than the minimum\n', '        require(betEth >= minBet);\n', '        // Execute the bet and return the outcome\n', '        resultNum = bet(betEth, _customerAddress);\n', '    }\n', '\n', '\n', '    function etherSpin()\n', '        public\n', '        payable\n', '        nonContract\n', '        gameActive\n', '        returns (uint256 resultNum)\n', '    {\n', '        address _customerAddress = msg.sender;\n', '        uint256 betEth = msg.value;\n', '        // All eth is converted into tokens before the bet\n', '        // If user bets more than available bet pool, bet only as much as the pool\n', '        if (betEth > betPool(_customerAddress)) {\n', '            betEth = betPool(_customerAddress);\n', '        }\n', '        // User must bet more than the minimum\n', '        require(betEth >= minBet);\n', '        // Adjust ledgers\n', '        balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).add(msg.value);\n', '\t\tpersonalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '        // Execute the bet and return the outcome\n', '        resultNum = bet(betEth, _customerAddress);\n', '    }\n', '\n', '\n', '    function betPool(address _customerAddress)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        // Balance of contract, minus eth balance of user and accrued dev fees\n', '        return this.balance.sub(ethBalanceOf(_customerAddress)).sub(devFeeBalance);\n', '    }\n', '\n', '    /*\n', '        panicButton and refundUser are here incase of an emergency, or launch of a new contract\n', '        The game will be frozen, and all token holders will be refunded\n', '    */\n', '\n', '    function panicButton(bool newStatus)\n', '        public\n', '        onlyAdmin\n', '    {\n', '        gamePaused = newStatus;\n', '    }\n', '\n', '\n', '    function refundUser(address _customerAddress)\n', '        public\n', '        onlyAdmin\n', '    {\n', '        uint256 sellEth = ethBalanceOf(_customerAddress);\n', '        _customerAddress.transfer(sellEth);\n', '        balanceLedger_[_customerAddress] = 0;\n', '\t\tpersonalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '        onTokenSell(_customerAddress, sellEth, this.balance, now);\n', '    }\n', '\n', '    function getDevBalance()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return devFeeBalance;\n', '    }\n', '\n', '\n', '    function withdrawDevFees()\n', '        public\n', '        onlyAdmin\n', '    {\n', '        admin.transfer(devFeeBalance);\n', '        devFeeBalance = 0;\n', '    }\n', '\n', '\n', '    // Internal Functions\n', '\n', '\n', '    function bet(uint256 initEth, address _customerAddress)\n', '        internal\n', '        returns (uint256 resultNum)\n', '    {\n', '        // Spin the wheel\n', '        resultNum = random(80);\n', '        // Determine the outcome\n', '        uint result = determinePrize(resultNum);\n', '\n', "        // Add 2% fee to devFeeBalance and remove from user's balance\n", '        uint256 devFee = initEth / 50;\n', '        devFeeBalance = devFeeBalance.add(devFee);\n', '        balanceLedger_[_customerAddress] = ethBalanceOf(_customerAddress).sub(devFee);\n', '        personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '\n', '        // Remove the dev fee from the bet amount\n', '        uint256 betEth = initEth - devFee;\n', '\n', '        uint256 returnedEth;\n', '        uint256 prizePool = betPool(_customerAddress);\n', '\n', '\t\tif (result < 5)                                             // < 5 = WIN\n', '\t\t{\n', '\t\t\tuint256 wonEth;\n', '\t\t\tif (result == 0){                                       // Grand Jackpot\n', '\t\t\t\twonEth = grandJackpot(betEth, prizePool);\n', '\t\t\t} else if (result == 1){                                // Jackpot\n', '\t\t\t\twonEth = jackpot(betEth, prizePool);\n', '\t\t\t} else if (result == 2){                                // Grand Prize\n', '\t\t\t\twonEth = betEth / 2;                                // +50% of original bet\n', '\t\t\t} else if (result == 3){                                // Major Prize\n', '\t\t\t\twonEth = betEth / 4;                                // +25% of original bet\n', '\t\t\t} else if (result == 4){                                // Minor Prize\n', '\t\t\t\twonEth = betEth / 10;                               // +10% of original bet\n', '\t\t\t}\n', '\t\t\twinEth(_customerAddress, wonEth);                       // Award the user their prize\n', '            returnedEth = betEth.add(wonEth);\n', '        } else if (result == 5){                                    // 5 = Refund\n', '            returnedEth = betEth;\n', '\t\t}\n', '\t\telse {                                                      // > 5 = LOSE\n', '\t\t\tuint256 lostEth;\n', '\t\t\tif (result == 6){                                \t\t// Minor Loss\n', '\t\t\t\tlostEth = betEth / 4;                    \t\t    // -25% of original bet\n', '\t\t\t} else if (result == 7){                                // Major Loss\n', '\t\t\t\tlostEth = betEth / 2;                     \t\t\t// -50% of original bet\n', '\t\t\t} else if (result == 8){                                // Grand Loss\n', '\t\t\t\tlostEth = betEth.mul(3) / 4;                     \t// -75% of original bet\n', '\t\t\t} else if (result == 9){                                // Total Loss\n', '\t\t\t\tlostEth = betEth;                                   // -100% of original bet\n', '\t\t\t}\n', '\t\t\tloseEth(_customerAddress, lostEth);                     // "Award" the user their loss\n', '            returnedEth = betEth.sub(lostEth);\n', '\t\t}\n', '        spinResult(_customerAddress, resultNum, result, betEth, returnedEth, devFee, now);\n', '        return resultNum;\n', '    }\n', '\n', '    function grandJackpot(uint256 betEth, uint256 prizePool)\n', '        internal\n', '        returns (uint256 wonEth)\n', '    {\n', '        wonEth = betEth / 2;                                        // +50% of original bet\n', '        uint256 max = minBet * 100 * betEth / prizePool;            // Fire the loop a maximum of 100 times\n', '\t\tfor (uint256 i=0;i<max; i+= minBet) {\t\t\t  \t        // Add a % of the remaining Token Pool\n', '            wonEth = wonEth.add((prizePool.sub(wonEth)) / 50);      // +2% of remaining pool\n', '\t\t}\n', '    }\n', '\n', '    function jackpot(uint256 betEth, uint256 prizePool)\n', '        internal\n', '        returns (uint256 wonEth)\n', '    {\n', '        wonEth = betEth / 2;                                        // +50% of original bet\n', '        uint256 max = minBet * 100 * betEth / prizePool;            // Fire the loop a maximum of 100 times\n', '\t\tfor (uint256 i=0;i<max; i+= minBet) {                       // Add a % of the remaining Token Pool\n', '            wonEth = wonEth.add((prizePool.sub(wonEth)) / 100);     // +1% of remaining pool\n', '\t\t}\n', '    }\n', '\n', '    function maxRandom()\n', '        internal\n', '        returns (uint256 randomNumber)\n', '    {\n', '        _seed = uint256(keccak256(\n', '            abi.encodePacked(_seed,\n', '                blockhash(block.number - 1),\n', '                block.coinbase,\n', '                block.difficulty)\n', '        ));\n', '        return _seed;\n', '    }\n', '\n', '\n', '    function random(uint256 upper)\n', '        internal\n', '        returns (uint256 randomNumber)\n', '    {\n', '        return maxRandom() % upper + 1;\n', '    }\n', '\n', '\n', '    function determinePrize(uint256 result)\n', '        internal\n', '        returns (uint256 resultNum)\n', '    {\n', '        // Loop until the result bracket is determined\n', '        for (uint8 i=0;i<=9;i++){\n', '            if (result <= brackets[i]){\n', '                return i;\n', '            }\n', '        }\n', '    }\n', '\n', '\n', '    function loseEth(address _customerAddress, uint256 lostEth)\n', '        internal\n', '    {\n', '        uint256 customerEth = ethBalanceOf(_customerAddress);\n', '        // Increase amount of eth everyone else owns\n', '        uint256 globalIncrease = globalFactor.mul(lostEth) / betPool(_customerAddress);\n', '        globalFactor = globalFactor.add(globalIncrease);\n', '        // Update user ledgers\n', '        personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '        balanceLedger_[_customerAddress] = customerEth.sub(lostEth);\n', '    }\n', '\n', '\n', '    function winEth(address _customerAddress, uint256 wonEth)\n', '        internal\n', '    {\n', '        uint256 customerEth = ethBalanceOf(_customerAddress);\n', '        // Decrease amount of eth everyone else owns\n', '        uint256 globalDecrease = globalFactor.mul(wonEth) / betPool(_customerAddress);\n', '        globalFactor = globalFactor.sub(globalDecrease);\n', '        // Update user ledgers\n', '        personalFactorLedger_[_customerAddress] = constantFactor / globalFactor;\n', '        balanceLedger_[_customerAddress] = customerEth.add(wonEth);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
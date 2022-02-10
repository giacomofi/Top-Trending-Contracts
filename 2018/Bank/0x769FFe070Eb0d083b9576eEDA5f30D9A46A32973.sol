['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' _ _ _  _____  _____  _____  __            ___    _____  _____  _____  _____  _____\n', '| | | ||  |  ||   __||   __||  |      ___ |  _|  |   __||_   _||  |  ||   __|| __  |\n', '| | | ||     ||   __||   __||  |__   | . ||  _|  |   __|  | |  |     ||   __||    -|\n', '|_____||__|__||_____||_____||_____|  |___||_|    |_____|  |_|  |__|__||_____||__|__|\n', '\n', '\n', '\n', '                                  `.-::::::::::::-.`\n', '                           .:::+:-.`            `.-:+:::.\n', '                      `::::.   `-                  -`   .:::-`\n', '                   .:::`        :                  :        `:::.\n', '                `:/-            `-                -`            -/:`\n', '              ./:`               :               `:               `:/.\n', '            .+:                   :              :                  `:+.\n', '          `/-`..`                 -`            `-                 `..`-/`\n', '         :/`    ..`                :            :                `..    `/:\n', '       `+.        ..`              -`          `-              `..        .+`\n', '      .+`           ..`             :          :             `..           `+.\n', '     -+               ..`           -.        ..           `..               +-\n', '    .+                 `..`          :        :          `..                  +.\n', '   `o                    `..`        ..      ..        `..`                    o`\n', '   o`                      `..`     `./------/.`     `..`                      `o\n', '  -+``                       `..``-::.````````.::-``..`                       ``+-\n', '  s```....````                 `+:.  ..------..  .:+`                 ````....```o\n', ' .+       ````...````         .+. `--``      ``--` .+.         ````...````       +.\n', ' +.              ````....`````+` .:`            `:. `o`````....````              ./\n', ' o                       ````s` `/                /` `s````                       o\n', ' s                           s  /`                .:  s                           s\n', ' s                           s  /`                `/  s                           s\n', ' s                        ```s` `/                /` `s```                        o\n', ' +.               ````....```.+  .:`            `:.  +.```....````               .+\n', ' ./        ```....````        -/` `--`        `--` `/.        ````....```        +.\n', '  s````....```                 .+:` `.--------.` `:+.                 ```....````s\n', '  :/```                       ..`.::-.``    ``.-::.`..                       ```/:\n', '   o`                       ..`     `-/-::::-/-`     `..                       `o\n', '   `o                     ..`        ..      ..        `..                     o`\n', '    -/                  ..`          :        :          `..                  /-\n', '     -/               ..`           ..        ..           `..               /-\n', '      -+`           ..`             :          :             `-.           `+-\n', '       .+.        .-`              -`          ..              `-.        .+.\n', '         /:     .-`                :            :                `-.    `:/\n', '          ./- .-`                 -`            `-                 `-. -/.\n', '            -+-                   :              :                   :+-\n', '              -/-`               -`              `-               `-/-\n', '                .:/.             :                :             ./:.\n', '                   -:/-         :                  :         -/:-\n', '                      .:::-`   `-                  -`   `-:::.\n', '                          `-:::+-.`              `.:+:::-`\n', '                                `.-::::::::::::::-.`\n', '\n', '---Design---\n', 'J&#246;rmungandr\n', '\n', '---Contract and Frontend---\n', 'Mr Fahrenheit\n', 'J&#246;rmungandr\n', '\n', '---Contract Auditor---\n', '8 ฿ł₮ ₮Ɽł₱\n', '\n', '---Contract Advisors---\n', 'Etherguy\n', 'Norsefire\n', '\n', 'TY Guys\n', '\n', '**/\n', '\n', 'contract WheelOfEther\n', '{\n', '    using SafeMath for uint;\n', '\n', '    // Randomizer contract\n', '    Randomizer private rand;\n', '\n', '    /**\n', '     * MODIFIERS\n', '     */\n', '    modifier onlyHuman() {\n', '        require(tx.origin == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier gameActive() {\n', '        require(gamePaused == false);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin(){\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * EVENTS\n', '     */\n', '    event onDeposit(\n', '        address indexed customer,\n', '        uint256 amount,\n', '        uint256 balance,\n', '        uint256 devFee,\n', '        uint timestamp\n', '    );\n', '\n', '    event onWithdraw(\n', '        address indexed customer,\n', '        uint256 amount,\n', '        uint256 balance,\n', '        uint timestamp\n', '    );\n', '\n', '    event spinResult(\n', '        address indexed customer,\n', '        uint256 wheelNumber,\n', '        uint256 outcome,\n', '        uint256 betAmount,\n', '        uint256 returnAmount,\n', '        uint256 customerBalance,\n', '        uint timestamp\n', '    );\n', '\n', '    // Contract admin\n', '    address public admin;\n', '    uint256 public devBalance = 0;\n', '\n', '    // Game status\n', '    bool public gamePaused = false;\n', '\n', '    // Random values\n', '    uint8 private randMin  = 1;\n', '    uint8 private randMax  = 80;\n', '\n', '    // Bets limit\n', '    uint256 public minBet = 0.01 ether;\n', '    uint256 public maxBet = 10 ether;\n', '\n', '    // Win brackets\n', '    uint8[10] public brackets = [1,3,6,12,24,40,56,68,76,80];\n', '\n', '    // Factors\n', '    uint256 private          globalFactor   = 10e21;\n', '    uint256 constant private constantFactor = 10e21 * 10e21;\n', '\n', '    // Customer balance\n', '    mapping(address => uint256) private personalFactor;\n', '    mapping(address => uint256) private personalLedger;\n', '\n', '\n', '    /**\n', '     * Constructor\n', '     */\n', '    constructor() public {\n', '        admin = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Admin methods\n', '     */\n', '    function setRandomizer(address _rand) external onlyAdmin {\n', '        rand = Randomizer(_rand);\n', '    }\n', '\n', '    function gamePause() external onlyAdmin {\n', '        gamePaused = true;\n', '    }\n', '\n', '    function gameUnpause() external onlyAdmin {\n', '        gamePaused = false;\n', '    }\n', '\n', '    function refund(address customer) external onlyAdmin {\n', '        uint256 amount = getBalanceOf(customer);\n', '        customer.transfer(amount);\n', '        personalLedger[customer] = 0;\n', '        personalFactor[customer] = constantFactor / globalFactor;\n', '        emit onWithdraw(customer, amount, getBalance(), now);\n', '    }\n', '\n', '    function withdrawDevFees() external onlyAdmin {\n', '        admin.transfer(devBalance);\n', '        devBalance = 0;\n', '    }\n', '\n', '\n', '    /**\n', '     * Get contract balance\n', '     */\n', '    function getBalance() public view returns(uint256 balance) {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function getBalanceOf(address customer) public view returns(uint256 balance) {\n', '        return personalLedger[customer].mul(personalFactor[customer]).mul(globalFactor) / constantFactor;\n', '    }\n', '\n', '    function getBalanceMy() public view returns(uint256 balance) {\n', '        return getBalanceOf(msg.sender);\n', '    }\n', '\n', '    function betPool(address customer) public view returns(uint256 value) {\n', '        return address(this).balance.sub(getBalanceOf(customer)).sub(devBalance);\n', '    }\n', '\n', '\n', '    /**\n', '     * Deposit/withdrawal\n', '     */\n', '    function deposit() public payable onlyHuman gameActive {\n', '        address customer = msg.sender;\n', '        require(msg.value >= (minBet * 2));\n', '\n', '        // Add 2% fee of the buy to devBalance\n', '        uint256 devFee = msg.value / 50;\n', '        devBalance = devBalance.add(devFee);\n', '\n', '        personalLedger[customer] = getBalanceOf(customer).add(msg.value).sub(devFee);\n', '        personalFactor[customer] = constantFactor / globalFactor;\n', '\n', '        emit onDeposit(customer, msg.value, getBalance(), devFee, now);\n', '    }\n', '\n', '    function withdraw(uint256 amount) public onlyHuman {\n', '        address customer = msg.sender;\n', '        require(amount > 0);\n', '        require(amount <= getBalanceOf(customer));\n', '\n', '        customer.transfer(amount);\n', '        personalLedger[customer] = getBalanceOf(customer).sub(amount);\n', '        personalFactor[customer] = constantFactor / globalFactor;\n', '\n', '        emit onWithdraw(customer, amount, getBalance(), now);\n', '    }\n', '\n', '    function withdrawAll() public onlyHuman {\n', '        withdraw(getBalanceOf(msg.sender));\n', '    }\n', '\n', '\n', '    /**\n', '     * Spin the wheel methods\n', '     */\n', '    function spin(uint256 betAmount) public onlyHuman gameActive returns(uint256 resultNum) {\n', '        address customer = msg.sender;\n', '        require(betAmount              >= minBet);\n', '        require(getBalanceOf(customer) >= betAmount);\n', '\n', '        if (betAmount > maxBet) {\n', '            betAmount = maxBet;\n', '        }\n', '        if (betAmount > betPool(customer) / 10) {\n', '            betAmount = betPool(customer) / 10;\n', '        }\n', '        resultNum = bet(betAmount, customer);\n', '    }\n', '\n', '    function spinAll() public onlyHuman gameActive returns(uint256 resultNum) {\n', '        resultNum = spin(getBalanceOf(msg.sender));\n', '    }\n', '\n', '    function spinDeposit() public payable onlyHuman gameActive returns(uint256 resultNum) {\n', '        address customer  = msg.sender;\n', '        uint256 betAmount = msg.value;\n', '\n', '        require(betAmount >= (minBet * 2));\n', '\n', '        // Add 2% fee of the buy to devFeeBalance\n', '        uint256 devFee = betAmount / 50;\n', '        devBalance     = devBalance.add(devFee);\n', '        betAmount      = betAmount.sub(devFee);\n', '\n', '        personalLedger[customer] = getBalanceOf(customer).add(msg.value).sub(devFee);\n', '        personalFactor[customer] = constantFactor / globalFactor;\n', '\n', '        if (betAmount >= maxBet) {\n', '            betAmount = maxBet;\n', '        }\n', '        if (betAmount > betPool(customer) / 10) {\n', '            betAmount = betPool(customer) / 10;\n', '        }\n', '\n', '        resultNum = bet(betAmount, customer);\n', '    }\n', '\n', '\n', '    /**\n', '     * PRIVATE\n', '     */\n', '    function bet(uint256 betAmount, address customer) private returns(uint256 resultNum) {\n', '        resultNum      = uint256(rand.getRandomNumber(randMin, randMax + randMin));\n', '        uint256 result = determinePrize(resultNum);\n', '\n', '        uint256 returnAmount;\n', '\n', '        if (result < 5) {                                               // < 5 = WIN\n', '            uint256 winAmount;\n', '            if (result == 0) {                                          // Grand Jackpot\n', '                winAmount = betAmount.mul(9) / 10;                      // +90% of original bet\n', '            } else if (result == 1) {                                   // Jackpot\n', '                winAmount = betAmount.mul(8) / 10;                      // +80% of original bet\n', '            } else if (result == 2) {                                   // Grand Prize\n', '                winAmount = betAmount.mul(7) / 10;                      // +70% of original bet\n', '            } else if (result == 3) {                                   // Major Prize\n', '                winAmount = betAmount.mul(6) / 10;                      // +60% of original bet\n', '            } else if (result == 4) {                                   // Minor Prize\n', '                winAmount = betAmount.mul(3) / 10;                      // +30% of original bet\n', '            }\n', '            weGotAWinner(customer, winAmount);\n', '            returnAmount = betAmount.add(winAmount);\n', '        } else if (result == 5) {                                       // 5 = Refund\n', '            returnAmount = betAmount;\n', '        } else {                                                        // > 5 = LOSE\n', '            uint256 lostAmount;\n', '            if (result == 6) {                                          // Minor Loss\n', '                lostAmount = betAmount / 10;                            // -10% of original bet\n', '            } else if (result == 7) {                                   // Major Loss\n', '                lostAmount = betAmount / 4;                             // -25% of original bet\n', '            } else if (result == 8) {                                   // Grand Loss\n', '                lostAmount = betAmount / 2;                             // -50% of original bet\n', '            } else if (result == 9) {                                   // Total Loss\n', '                lostAmount = betAmount;                                 // -100% of original bet\n', '            }\n', '            goodLuck(customer, lostAmount);\n', '            returnAmount = betAmount.sub(lostAmount);\n', '        }\n', '\n', '        uint256 newBalance = getBalanceOf(customer);\n', '        emit spinResult(customer, resultNum, result, betAmount, returnAmount, newBalance, now);\n', '        return resultNum;\n', '    }\n', '\n', '\n', '    function determinePrize(uint256 result) private view returns(uint256 resultNum) {\n', '        for (uint8 i = 0; i < 10; i++) {\n', '            if (result <= brackets[i]) {\n', '                return i;\n', '            }\n', '        }\n', '    }\n', '\n', '\n', '    function goodLuck(address customer, uint256 lostAmount) private {\n', '        uint256 customerBalance  = getBalanceOf(customer);\n', '        uint256 globalIncrease   = globalFactor.mul(lostAmount) / betPool(customer);\n', '        globalFactor             = globalFactor.add(globalIncrease);\n', '        personalFactor[customer] = constantFactor / globalFactor;\n', '\n', '        if (lostAmount > customerBalance) {\n', '            lostAmount = customerBalance;\n', '        }\n', '        personalLedger[customer] = customerBalance.sub(lostAmount);\n', '    }\n', '\n', '    function weGotAWinner(address customer, uint256 winAmount) private {\n', '        uint256 customerBalance  = getBalanceOf(customer);\n', '        uint256 globalDecrease   = globalFactor.mul(winAmount) / betPool(customer);\n', '        globalFactor             = globalFactor.sub(globalDecrease);\n', '        personalFactor[customer] = constantFactor / globalFactor;\n', '        personalLedger[customer] = customerBalance.add(winAmount);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @dev Randomizer contract interface\n', ' */\n', 'contract Randomizer {\n', '    function getRandomNumber(int256 min, int256 max) public returns(int256);\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']
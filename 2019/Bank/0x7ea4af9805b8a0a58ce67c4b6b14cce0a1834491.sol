['pragma solidity ^0.4.25;\n', '\n', '/*\n', '* CryptoMiningWar - Blockchain-based strategy game\n', '* Author: InspiGames\n', '* Website: https://cryptominingwar.github.io/\n', '*/\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', 'contract PullPayment {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) public payments;\n', '  uint256 public totalPayments;\n', '\n', '  /**\n', '  * @dev Withdraw accumulated balance, called by payee.\n', '  */\n', '  function withdrawPayments() public {\n', '    address payee = msg.sender;\n', '    uint256 payment = payments[payee];\n', '\n', '    require(payment != 0);\n', '    require(address(this).balance >= payment);\n', '\n', '    totalPayments = totalPayments.sub(payment);\n', '    payments[payee] = 0;\n', '\n', '    payee.transfer(payment);\n', '  }\n', '\n', '  /**\n', '  * @dev Called by the payer to store the sent amount as credit to be pulled.\n', '  * @param dest The destination address of the funds.\n', '  * @param amount The amount to transfer.\n', '  */\n', '  function asyncSend(address dest, uint256 amount) internal {\n', '    payments[dest] = payments[dest].add(amount);\n', '    totalPayments = totalPayments.add(amount);\n', '  }\n', '}\n', 'contract CryptoEngineerInterface {\n', '    uint256 public prizePool = 0;\n', '\n', '    function subVirus(address /*_addr*/, uint256 /*_value*/) public pure {}\n', '    function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public pure {} \n', '    function fallback() public payable {}\n', '\n', '    function isEngineerContract() external pure returns(bool) {}\n', '}\n', 'interface CryptoMiningWarInterface {\n', '    function addCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure;\n', '    function subCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure;\n', '    function isMiningWarContract() external pure returns(bool);\n', '}\n', 'interface MiniGameInterface {\n', '     function isContractMiniGame() external pure returns( bool _isContractMiniGame );\n', '}\n', 'contract CryptoBossWannaCry is PullPayment{\n', '    bool init = false;\n', '\taddress public administrator;\n', '    uint256 public bossRoundNumber;\n', '    uint256 public BOSS_HP_DEFAULT = 10000000; \n', '    uint256 public HALF_TIME_ATK_BOSS = 0;\n', '    // engineer game infomation\n', '    uint256 constant public VIRUS_MINING_PERIOD = 86400; \n', '    uint256 public BOSS_DEF_DEFFAULT = 0;\n', '    CryptoEngineerInterface public Engineer;\n', '    CryptoMiningWarInterface public MiningWar;\n', '    \n', '    // player information\n', '    mapping(address => PlayerData) public players;\n', '    // boss information\n', '    mapping(uint256 => BossData) public bossData;\n', '\n', '    mapping(address => bool)   public miniGames;\n', '        \n', '    struct PlayerData {\n', '        uint256 currentBossRoundNumber;\n', '        uint256 lastBossRoundNumber;\n', '        uint256 win;\n', '        uint256 share;\n', '        uint256 dame;\n', '        uint256 nextTimeAtk;\n', '    }\n', '\n', '    struct BossData {\n', '        uint256 bossRoundNumber;\n', '        uint256 bossHp;\n', '        uint256 def;\n', '        uint256 prizePool;\n', '        address playerLastAtk;\n', '        uint256 totalDame;\n', '        bool ended;\n', '    }\n', '    event eventAttackBoss(\n', '        uint256 bossRoundNumber,\n', '        address playerAtk,\n', '        uint256 virusAtk,\n', '        uint256 dame,\n', '        uint256 totalDame,\n', '        uint256 timeAtk,\n', '        bool isLastHit,\n', '        uint256 crystalsReward\n', '    );\n', '    event eventEndAtkBoss(\n', '        uint256 bossRoundNumber,\n', '        address playerWin,\n', '        uint256 ethBonus,\n', '        uint256 bossHp,\n', '        uint256 prizePool\n', '    );\n', '    modifier disableContract()\n', '    {\n', '        require(tx.origin == msg.sender);\n', '        _;\n', '    }\n', '    modifier isAdministrator()\n', '    {\n', '        require(msg.sender == administrator);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        administrator = msg.sender;\n', '        // set interface contract\n', '        setMiningWarInterface(0x1b002cd1ba79dfad65e8abfbb3a97826e4960fe5);\n', '        setEngineerInterface(0xd7afbf5141a7f1d6b0473175f7a6b0a7954ed3d2);\n', '    }\n', '    function () public payable\n', '    {\n', '        \n', '    }\n', '    function isContractMiniGame() public pure returns( bool _isContractMiniGame )\n', '    {\n', '    \t_isContractMiniGame = true;\n', '    }\n', '    function isBossWannaCryContract() public pure returns(bool)\n', '    {\n', '        return true;\n', '    }\n', '    /** \n', '    * @dev Main Contract call this function to setup mini game.\n', '    */\n', '    function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/ ) public\n', '    {\n', '    \n', '    }\n', '     //@dev use this function in case of bug\n', '    function upgrade(address addr) public isAdministrator\n', '    {\n', '        selfdestruct(addr);\n', '    }\n', '    // ---------------------------------------------------------------------------------------\n', '    // SET INTERFACE CONTRACT\n', '    // ---------------------------------------------------------------------------------------\n', '    \n', '    function setMiningWarInterface(address _addr) public isAdministrator\n', '    {\n', '        CryptoMiningWarInterface miningWarInterface = CryptoMiningWarInterface(_addr);\n', '\n', '        require(miningWarInterface.isMiningWarContract() == true);\n', '                \n', '        MiningWar = miningWarInterface;\n', '    }\n', '    function setEngineerInterface(address _addr) public isAdministrator\n', '    {\n', '        CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);\n', '        \n', '        require(engineerInterface.isEngineerContract() == true);\n', '\n', '        Engineer = engineerInterface;\n', '    }\n', '    function setContractsMiniGame( address _addr ) public isAdministrator \n', '    {\n', '        MiniGameInterface MiniGame = MiniGameInterface( _addr );\n', '        if( MiniGame.isContractMiniGame() == false ) { revert(); }\n', '\n', '        miniGames[_addr] = true;\n', '    }\n', '\n', '    function setBossRoundNumber(uint256 _value) public isAdministrator\n', '    {\n', '        bossRoundNumber = _value;\n', '    } \n', '    /**\n', '    * @dev remove mini game contract from main contract\n', '    * @param _addr mini game contract address\n', '    */\n', '    function removeContractMiniGame(address _addr) public isAdministrator\n', '    {\n', '        miniGames[_addr] = false;\n', '    }\n', '\n', '    function startGame() public isAdministrator\n', '    {\n', '        require(init == false);\n', '        init = true;\n', '        bossData[bossRoundNumber].ended = true;\n', '    \n', '        startNewBoss();\n', '    }\n', '    /**\n', '    * @dev set defence for boss\n', '    * @param _value number defence\n', '    */\n', '    function setDefenceBoss(uint256 _value) public isAdministrator\n', '    {\n', '        BOSS_DEF_DEFFAULT = _value;  \n', '    }\n', '    /**\n', '    * @dev set HP for boss\n', '    * @param _value number HP default\n', '    */\n', '    function setBossHPDefault(uint256 _value) public isAdministrator\n', '    {\n', '        BOSS_HP_DEFAULT = _value;  \n', '    }\n', '    function setHalfTimeAtkBoss(uint256 _value) public isAdministrator\n', '    {\n', '        HALF_TIME_ATK_BOSS = _value;  \n', '    }\n', '    function startNewBoss() private\n', '    {\n', '        require(bossData[bossRoundNumber].ended == true);\n', '\n', '        bossRoundNumber = bossRoundNumber + 1;\n', '\n', '        uint256 bossHp = BOSS_HP_DEFAULT * bossRoundNumber;\n', '        // claim 5% of current prizePool as rewards.\n', '        uint256 engineerPrizePool = Engineer.prizePool();\n', '        uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100);\n', '        Engineer.claimPrizePool(address(this), prizePool); \n', '\n', '        bossData[bossRoundNumber] = BossData(bossRoundNumber, bossHp, BOSS_DEF_DEFFAULT, prizePool, 0x0, 0, false);\n', '    }\n', '    function endAtkBoss() private \n', '    {\n', '        require(bossData[bossRoundNumber].ended == false);\n', '        require(bossData[bossRoundNumber].totalDame >= bossData[bossRoundNumber].bossHp);\n', '\n', '        BossData storage b = bossData[bossRoundNumber];\n', '        b.ended = true;\n', '         // update eth bonus for player last hit\n', '        uint256 ethBonus = SafeMath.div( SafeMath.mul(b.prizePool, 5), 100 );\n', '\n', '        if (b.playerLastAtk != 0x0) {\n', '            PlayerData storage p = players[b.playerLastAtk];\n', '            p.win =  p.win + ethBonus;\n', '\n', '            uint256 share = SafeMath.div(SafeMath.mul(SafeMath.mul(b.prizePool, 95), p.dame), SafeMath.mul(b.totalDame, 100));\n', '            ethBonus += share;\n', '        }\n', '\n', '        emit eventEndAtkBoss(bossRoundNumber, b.playerLastAtk, ethBonus, b.bossHp, b.prizePool);\n', '        startNewBoss();\n', '    }\n', '    /**\n', '    * @dev player atk the boss\n', '    * @param _value number virus for this attack boss\n', '    */\n', '    function atkBoss(uint256 _value) public disableContract\n', '    {\n', '        require(bossData[bossRoundNumber].ended == false);\n', '        require(bossData[bossRoundNumber].totalDame < bossData[bossRoundNumber].bossHp);\n', '        require(players[msg.sender].nextTimeAtk <= now);\n', '\n', '        Engineer.subVirus(msg.sender, _value);\n', '        \n', '        uint256 rate = 50 + randomNumber(msg.sender, now, 60); // 50 - 110%\n', '        \n', '        uint256 atk = SafeMath.div(SafeMath.mul(_value, rate), 100);\n', '        \n', '        updateShareETH(msg.sender);\n', '\n', '        // update dame\n', '        BossData storage b = bossData[bossRoundNumber];\n', '        \n', '        uint256 currentTotalDame = b.totalDame;\n', '        uint256 dame = 0;\n', '        if (atk > b.def) {\n', '            dame = SafeMath.sub(atk, b.def);\n', '        }\n', '\n', '        b.totalDame = SafeMath.min(SafeMath.add(currentTotalDame, dame), b.bossHp);\n', '        b.playerLastAtk = msg.sender;\n', '\n', '        dame = SafeMath.sub(b.totalDame, currentTotalDame);\n', '\n', '        // bonus crystals\n', '        uint256 crystalsBonus = SafeMath.div(SafeMath.mul(dame, 5), 100);\n', '        MiningWar.addCrystal(msg.sender, crystalsBonus);\n', '        // update player\n', '        PlayerData storage p = players[msg.sender];\n', '\n', '        p.nextTimeAtk = now + HALF_TIME_ATK_BOSS;\n', '\n', '        if (p.currentBossRoundNumber == bossRoundNumber) {\n', '            p.dame = SafeMath.add(p.dame, dame);\n', '        } else {\n', '            p.currentBossRoundNumber = bossRoundNumber;\n', '            p.dame = dame;\n', '        }\n', '\n', '        bool isLastHit;\n', '        if (b.totalDame >= b.bossHp) {\n', '            isLastHit = true;\n', '            endAtkBoss();\n', '        }\n', '        \n', '        // emit event attack boss\n', '        emit eventAttackBoss(b.bossRoundNumber, msg.sender, _value, dame, p.dame, now, isLastHit, crystalsBonus);\n', '    }\n', ' \n', '    function updateShareETH(address _addr) private\n', '    {\n', '        PlayerData storage p = players[_addr];\n', '        \n', '        if ( \n', '            bossData[p.currentBossRoundNumber].ended == true &&\n', '            p.lastBossRoundNumber < p.currentBossRoundNumber\n', '            ) {\n', '            p.share = SafeMath.add(p.share, calculateShareETH(msg.sender, p.currentBossRoundNumber));\n', '            p.lastBossRoundNumber = p.currentBossRoundNumber;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev calculate share Eth of player\n', '    */\n', '    function calculateShareETH(address _addr, uint256 _bossRoundNumber) public view returns(uint256 _share)\n', '    {\n', '        PlayerData memory p = players[_addr];\n', '        BossData memory b = bossData[_bossRoundNumber];\n', '        if ( \n', '            p.lastBossRoundNumber >= p.currentBossRoundNumber && \n', '            p.currentBossRoundNumber != 0 \n', '            ) {\n', '            _share = 0;\n', '        } else {\n', '            if (b.totalDame == 0) return 0;\n', '            _share = SafeMath.div(SafeMath.mul(SafeMath.mul(b.prizePool, 95), p.dame), SafeMath.mul(b.totalDame, 100)); // prizePool * 95% * playerDame / totalDame \n', '        } \n', '        if (b.ended == false)  _share = 0;\n', '    }\n', '    function getCurrentReward(address _addr) public view returns(uint256 _currentReward)\n', '    {\n', '        PlayerData memory p = players[_addr];\n', '        _currentReward = SafeMath.add(p.win, p.share);\n', '        _currentReward += calculateShareETH(_addr, p.currentBossRoundNumber);\n', '    }\n', '\n', '    function withdrawReward(address _addr) public \n', '    {\n', '        updateShareETH(_addr);\n', '        \n', '        PlayerData storage p = players[_addr];\n', '        \n', '        uint256 reward = SafeMath.add(p.share, p.win);\n', '        if (address(this).balance >= reward && reward > 0) {\n', '            _addr.transfer(reward);\n', '            // update player\n', '            p.win = 0;\n', '            p.share = 0;\n', '        }\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    // INTERNAL FUNCTION\n', '    //--------------------------------------------------------------------------\n', '    function devFee(uint256 _amount) private pure returns(uint256)\n', '    {\n', '        return SafeMath.div(SafeMath.mul(_amount, 5), 100);\n', '    }\n', '    function randomNumber(address _addr, uint256 randNonce, uint256 _maxNumber) private returns(uint256)\n', '    {\n', '        return uint256(keccak256(abi.encodePacked(now, _addr, randNonce))) % _maxNumber;\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', '/*\n', '* CryptoMiningWar - Blockchain-based strategy game\n', '* Author: InspiGames\n', '* Website: https://cryptominingwar.github.io/\n', '*/\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', 'contract PullPayment {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) public payments;\n', '  uint256 public totalPayments;\n', '\n', '  /**\n', '  * @dev Withdraw accumulated balance, called by payee.\n', '  */\n', '  function withdrawPayments() public {\n', '    address payee = msg.sender;\n', '    uint256 payment = payments[payee];\n', '\n', '    require(payment != 0);\n', '    require(address(this).balance >= payment);\n', '\n', '    totalPayments = totalPayments.sub(payment);\n', '    payments[payee] = 0;\n', '\n', '    payee.transfer(payment);\n', '  }\n', '\n', '  /**\n', '  * @dev Called by the payer to store the sent amount as credit to be pulled.\n', '  * @param dest The destination address of the funds.\n', '  * @param amount The amount to transfer.\n', '  */\n', '  function asyncSend(address dest, uint256 amount) internal {\n', '    payments[dest] = payments[dest].add(amount);\n', '    totalPayments = totalPayments.add(amount);\n', '  }\n', '}\n', 'contract CryptoEngineerInterface {\n', '    uint256 public prizePool = 0;\n', '\n', '    function subVirus(address /*_addr*/, uint256 /*_value*/) public pure {}\n', '    function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public pure {} \n', '    function fallback() public payable {}\n', '\n', '    function isEngineerContract() external pure returns(bool) {}\n', '}\n', 'interface CryptoMiningWarInterface {\n', '    function addCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure;\n', '    function subCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure;\n', '    function isMiningWarContract() external pure returns(bool);\n', '}\n', 'interface MiniGameInterface {\n', '     function isContractMiniGame() external pure returns( bool _isContractMiniGame );\n', '}\n', 'contract CryptoBossWannaCry is PullPayment{\n', '    bool init = false;\n', '\taddress public administrator;\n', '    uint256 public bossRoundNumber;\n', '    uint256 public BOSS_HP_DEFAULT = 10000000; \n', '    uint256 public HALF_TIME_ATK_BOSS = 0;\n', '    // engineer game infomation\n', '    uint256 constant public VIRUS_MINING_PERIOD = 86400; \n', '    uint256 public BOSS_DEF_DEFFAULT = 0;\n', '    CryptoEngineerInterface public Engineer;\n', '    CryptoMiningWarInterface public MiningWar;\n', '    \n', '    // player information\n', '    mapping(address => PlayerData) public players;\n', '    // boss information\n', '    mapping(uint256 => BossData) public bossData;\n', '\n', '    mapping(address => bool)   public miniGames;\n', '        \n', '    struct PlayerData {\n', '        uint256 currentBossRoundNumber;\n', '        uint256 lastBossRoundNumber;\n', '        uint256 win;\n', '        uint256 share;\n', '        uint256 dame;\n', '        uint256 nextTimeAtk;\n', '    }\n', '\n', '    struct BossData {\n', '        uint256 bossRoundNumber;\n', '        uint256 bossHp;\n', '        uint256 def;\n', '        uint256 prizePool;\n', '        address playerLastAtk;\n', '        uint256 totalDame;\n', '        bool ended;\n', '    }\n', '    event eventAttackBoss(\n', '        uint256 bossRoundNumber,\n', '        address playerAtk,\n', '        uint256 virusAtk,\n', '        uint256 dame,\n', '        uint256 totalDame,\n', '        uint256 timeAtk,\n', '        bool isLastHit,\n', '        uint256 crystalsReward\n', '    );\n', '    event eventEndAtkBoss(\n', '        uint256 bossRoundNumber,\n', '        address playerWin,\n', '        uint256 ethBonus,\n', '        uint256 bossHp,\n', '        uint256 prizePool\n', '    );\n', '    modifier disableContract()\n', '    {\n', '        require(tx.origin == msg.sender);\n', '        _;\n', '    }\n', '    modifier isAdministrator()\n', '    {\n', '        require(msg.sender == administrator);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        administrator = msg.sender;\n', '        // set interface contract\n', '        setMiningWarInterface(0x1b002cd1ba79dfad65e8abfbb3a97826e4960fe5);\n', '        setEngineerInterface(0xd7afbf5141a7f1d6b0473175f7a6b0a7954ed3d2);\n', '    }\n', '    function () public payable\n', '    {\n', '        \n', '    }\n', '    function isContractMiniGame() public pure returns( bool _isContractMiniGame )\n', '    {\n', '    \t_isContractMiniGame = true;\n', '    }\n', '    function isBossWannaCryContract() public pure returns(bool)\n', '    {\n', '        return true;\n', '    }\n', '    /** \n', '    * @dev Main Contract call this function to setup mini game.\n', '    */\n', '    function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/ ) public\n', '    {\n', '    \n', '    }\n', '     //@dev use this function in case of bug\n', '    function upgrade(address addr) public isAdministrator\n', '    {\n', '        selfdestruct(addr);\n', '    }\n', '    // ---------------------------------------------------------------------------------------\n', '    // SET INTERFACE CONTRACT\n', '    // ---------------------------------------------------------------------------------------\n', '    \n', '    function setMiningWarInterface(address _addr) public isAdministrator\n', '    {\n', '        CryptoMiningWarInterface miningWarInterface = CryptoMiningWarInterface(_addr);\n', '\n', '        require(miningWarInterface.isMiningWarContract() == true);\n', '                \n', '        MiningWar = miningWarInterface;\n', '    }\n', '    function setEngineerInterface(address _addr) public isAdministrator\n', '    {\n', '        CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);\n', '        \n', '        require(engineerInterface.isEngineerContract() == true);\n', '\n', '        Engineer = engineerInterface;\n', '    }\n', '    function setContractsMiniGame( address _addr ) public isAdministrator \n', '    {\n', '        MiniGameInterface MiniGame = MiniGameInterface( _addr );\n', '        if( MiniGame.isContractMiniGame() == false ) { revert(); }\n', '\n', '        miniGames[_addr] = true;\n', '    }\n', '\n', '    function setBossRoundNumber(uint256 _value) public isAdministrator\n', '    {\n', '        bossRoundNumber = _value;\n', '    } \n', '    /**\n', '    * @dev remove mini game contract from main contract\n', '    * @param _addr mini game contract address\n', '    */\n', '    function removeContractMiniGame(address _addr) public isAdministrator\n', '    {\n', '        miniGames[_addr] = false;\n', '    }\n', '\n', '    function startGame() public isAdministrator\n', '    {\n', '        require(init == false);\n', '        init = true;\n', '        bossData[bossRoundNumber].ended = true;\n', '    \n', '        startNewBoss();\n', '    }\n', '    /**\n', '    * @dev set defence for boss\n', '    * @param _value number defence\n', '    */\n', '    function setDefenceBoss(uint256 _value) public isAdministrator\n', '    {\n', '        BOSS_DEF_DEFFAULT = _value;  \n', '    }\n', '    /**\n', '    * @dev set HP for boss\n', '    * @param _value number HP default\n', '    */\n', '    function setBossHPDefault(uint256 _value) public isAdministrator\n', '    {\n', '        BOSS_HP_DEFAULT = _value;  \n', '    }\n', '    function setHalfTimeAtkBoss(uint256 _value) public isAdministrator\n', '    {\n', '        HALF_TIME_ATK_BOSS = _value;  \n', '    }\n', '    function startNewBoss() private\n', '    {\n', '        require(bossData[bossRoundNumber].ended == true);\n', '\n', '        bossRoundNumber = bossRoundNumber + 1;\n', '\n', '        uint256 bossHp = BOSS_HP_DEFAULT * bossRoundNumber;\n', '        // claim 5% of current prizePool as rewards.\n', '        uint256 engineerPrizePool = Engineer.prizePool();\n', '        uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100);\n', '        Engineer.claimPrizePool(address(this), prizePool); \n', '\n', '        bossData[bossRoundNumber] = BossData(bossRoundNumber, bossHp, BOSS_DEF_DEFFAULT, prizePool, 0x0, 0, false);\n', '    }\n', '    function endAtkBoss() private \n', '    {\n', '        require(bossData[bossRoundNumber].ended == false);\n', '        require(bossData[bossRoundNumber].totalDame >= bossData[bossRoundNumber].bossHp);\n', '\n', '        BossData storage b = bossData[bossRoundNumber];\n', '        b.ended = true;\n', '         // update eth bonus for player last hit\n', '        uint256 ethBonus = SafeMath.div( SafeMath.mul(b.prizePool, 5), 100 );\n', '\n', '        if (b.playerLastAtk != 0x0) {\n', '            PlayerData storage p = players[b.playerLastAtk];\n', '            p.win =  p.win + ethBonus;\n', '\n', '            uint256 share = SafeMath.div(SafeMath.mul(SafeMath.mul(b.prizePool, 95), p.dame), SafeMath.mul(b.totalDame, 100));\n', '            ethBonus += share;\n', '        }\n', '\n', '        emit eventEndAtkBoss(bossRoundNumber, b.playerLastAtk, ethBonus, b.bossHp, b.prizePool);\n', '        startNewBoss();\n', '    }\n', '    /**\n', '    * @dev player atk the boss\n', '    * @param _value number virus for this attack boss\n', '    */\n', '    function atkBoss(uint256 _value) public disableContract\n', '    {\n', '        require(bossData[bossRoundNumber].ended == false);\n', '        require(bossData[bossRoundNumber].totalDame < bossData[bossRoundNumber].bossHp);\n', '        require(players[msg.sender].nextTimeAtk <= now);\n', '\n', '        Engineer.subVirus(msg.sender, _value);\n', '        \n', '        uint256 rate = 50 + randomNumber(msg.sender, now, 60); // 50 - 110%\n', '        \n', '        uint256 atk = SafeMath.div(SafeMath.mul(_value, rate), 100);\n', '        \n', '        updateShareETH(msg.sender);\n', '\n', '        // update dame\n', '        BossData storage b = bossData[bossRoundNumber];\n', '        \n', '        uint256 currentTotalDame = b.totalDame;\n', '        uint256 dame = 0;\n', '        if (atk > b.def) {\n', '            dame = SafeMath.sub(atk, b.def);\n', '        }\n', '\n', '        b.totalDame = SafeMath.min(SafeMath.add(currentTotalDame, dame), b.bossHp);\n', '        b.playerLastAtk = msg.sender;\n', '\n', '        dame = SafeMath.sub(b.totalDame, currentTotalDame);\n', '\n', '        // bonus crystals\n', '        uint256 crystalsBonus = SafeMath.div(SafeMath.mul(dame, 5), 100);\n', '        MiningWar.addCrystal(msg.sender, crystalsBonus);\n', '        // update player\n', '        PlayerData storage p = players[msg.sender];\n', '\n', '        p.nextTimeAtk = now + HALF_TIME_ATK_BOSS;\n', '\n', '        if (p.currentBossRoundNumber == bossRoundNumber) {\n', '            p.dame = SafeMath.add(p.dame, dame);\n', '        } else {\n', '            p.currentBossRoundNumber = bossRoundNumber;\n', '            p.dame = dame;\n', '        }\n', '\n', '        bool isLastHit;\n', '        if (b.totalDame >= b.bossHp) {\n', '            isLastHit = true;\n', '            endAtkBoss();\n', '        }\n', '        \n', '        // emit event attack boss\n', '        emit eventAttackBoss(b.bossRoundNumber, msg.sender, _value, dame, p.dame, now, isLastHit, crystalsBonus);\n', '    }\n', ' \n', '    function updateShareETH(address _addr) private\n', '    {\n', '        PlayerData storage p = players[_addr];\n', '        \n', '        if ( \n', '            bossData[p.currentBossRoundNumber].ended == true &&\n', '            p.lastBossRoundNumber < p.currentBossRoundNumber\n', '            ) {\n', '            p.share = SafeMath.add(p.share, calculateShareETH(msg.sender, p.currentBossRoundNumber));\n', '            p.lastBossRoundNumber = p.currentBossRoundNumber;\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev calculate share Eth of player\n', '    */\n', '    function calculateShareETH(address _addr, uint256 _bossRoundNumber) public view returns(uint256 _share)\n', '    {\n', '        PlayerData memory p = players[_addr];\n', '        BossData memory b = bossData[_bossRoundNumber];\n', '        if ( \n', '            p.lastBossRoundNumber >= p.currentBossRoundNumber && \n', '            p.currentBossRoundNumber != 0 \n', '            ) {\n', '            _share = 0;\n', '        } else {\n', '            if (b.totalDame == 0) return 0;\n', '            _share = SafeMath.div(SafeMath.mul(SafeMath.mul(b.prizePool, 95), p.dame), SafeMath.mul(b.totalDame, 100)); // prizePool * 95% * playerDame / totalDame \n', '        } \n', '        if (b.ended == false)  _share = 0;\n', '    }\n', '    function getCurrentReward(address _addr) public view returns(uint256 _currentReward)\n', '    {\n', '        PlayerData memory p = players[_addr];\n', '        _currentReward = SafeMath.add(p.win, p.share);\n', '        _currentReward += calculateShareETH(_addr, p.currentBossRoundNumber);\n', '    }\n', '\n', '    function withdrawReward(address _addr) public \n', '    {\n', '        updateShareETH(_addr);\n', '        \n', '        PlayerData storage p = players[_addr];\n', '        \n', '        uint256 reward = SafeMath.add(p.share, p.win);\n', '        if (address(this).balance >= reward && reward > 0) {\n', '            _addr.transfer(reward);\n', '            // update player\n', '            p.win = 0;\n', '            p.share = 0;\n', '        }\n', '    }\n', '    //--------------------------------------------------------------------------\n', '    // INTERNAL FUNCTION\n', '    //--------------------------------------------------------------------------\n', '    function devFee(uint256 _amount) private pure returns(uint256)\n', '    {\n', '        return SafeMath.div(SafeMath.mul(_amount, 5), 100);\n', '    }\n', '    function randomNumber(address _addr, uint256 randNonce, uint256 _maxNumber) private returns(uint256)\n', '    {\n', '        return uint256(keccak256(abi.encodePacked(now, _addr, randNonce))) % _maxNumber;\n', '    }\n', '}']

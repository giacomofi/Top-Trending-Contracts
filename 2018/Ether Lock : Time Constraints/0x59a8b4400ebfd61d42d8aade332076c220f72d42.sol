['pragma solidity ^0.4.25;\n', '\n', '/*\n', '* CryptoMiningWar - Mining Contest Game\n', '* Author: InspiGames\n', '* Website: https://cryptominingwar.github.io/\n', '*/\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', 'contract CryptoEngineerInterface {\n', '    uint256 public prizePool = 0;\n', '\n', '    function subVirus(address /*_addr*/, uint256 /*_value*/) public {}\n', '    function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public {} \n', '}\n', 'contract CryptoMiningWarInterface {\n', '    uint256 public deadline; \n', '    function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public {}\n', '}\n', 'contract CrystalShare {\n', '\tusing SafeMath for uint256;\n', '\n', '    bool init = false;\n', '\taddress public administrator;\n', '\t// mini game\n', '    uint256 public HALF_TIME = 24 hours;\n', '    uint256 public round = 0;\n', '    CryptoEngineerInterface public EngineerContract;\n', '    CryptoMiningWarInterface public MiningWarContract;\n', '    // mining war info\n', '    uint256 public miningWarDeadline;\n', '    uint256 constant public CRTSTAL_MINING_PERIOD = 86400;\n', '    /** \n', '    * @dev mini game information\n', '    */\n', '    mapping(uint256 => Game) public games;\n', '    /** \n', '    * @dev player information\n', '    */\n', '    mapping(address => Player) public players;\n', '   \n', '    struct Game {\n', '        uint256 round;\n', '        uint256 crystals;\n', '        uint256 prizePool;\n', '        uint256 endTime;\n', '        bool ended; \n', '    }\n', '    struct Player {\n', '        uint256 currentRound;\n', '        uint256 lastRound;\n', '        uint256 reward;\n', '        uint256 share; // your crystals share in current round \n', '    }\n', '    event EndRound(uint256 round, uint256 crystals, uint256 prizePool, uint256 endTime);\n', '    modifier disableContract()\n', '    {\n', '        require(tx.origin == msg.sender);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        administrator = msg.sender;\n', '        // set interface contract\n', '        MiningWarContract = CryptoMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);\n', '        EngineerContract = CryptoEngineerInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);\n', '    }\n', '    function () public payable\n', '    {\n', '        \n', '    }\n', '    /** \n', '    * @dev MainContract used this function to verify game&#39;s contract\n', '    */\n', '    function isContractMiniGame() public pure returns( bool _isContractMiniGame )\n', '    {\n', '    \t_isContractMiniGame = true;\n', '    }\n', '\n', '    /** \n', '    * @dev Main Contract call this function to setup mini game.\n', '    */\n', '    function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 _miningWarDeadline ) public\n', '    {\n', '        miningWarDeadline = _miningWarDeadline;\n', '    }\n', '    /**\n', '    * @dev start the mini game\n', '    */\n', '     function startGame() public \n', '    {\n', '        require(msg.sender == administrator);\n', '        require(init == false);\n', '        init = true;\n', '        miningWarDeadline = getMiningWarDealine();\n', '\n', '        games[round].ended = true;\n', '    \n', '        startRound();\n', '    }\n', '    function startRound() private\n', '    {\n', '        require(games[round].ended == true);\n', '\n', '        uint256 crystalsLastRound = games[round].crystals;\n', '        uint256 prizePoolLastRound= games[round].prizePool; \n', '\n', '        round = round + 1;\n', '\n', '        uint256 endTime = now + HALF_TIME;\n', '        // claim 5% of current prizePool as rewards.\n', '        uint256 engineerPrizePool = getEngineerPrizePool();\n', '        uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100);\n', '        if (crystalsLastRound <= 0) {\n', '            prizePool = SafeMath.add(prizePool, prizePoolLastRound);\n', '        } \n', '\n', '        EngineerContract.claimPrizePool(address(this), prizePool);\n', '        games[round] = Game(round, 0, prizePool, endTime, false);\n', '    }\n', '    function endRound() private\n', '    {\n', '        require(games[round].ended == false);\n', '        require(games[round].endTime <= now);\n', '\n', '        Game storage g = games[round];\n', '        g.ended = true;\n', '        \n', '        startRound();\n', '\n', '        emit EndRound(g.round, g.crystals, g.prizePool, g.endTime);\n', '    }\n', '    /**\n', '    * @dev player send crystals to the pot\n', '    */\n', '    function share(uint256 _value) public disableContract\n', '    {\n', '        require(miningWarDeadline > now);\n', '        require(games[round].ended == false);\n', '        require(_value >= 10000);\n', '\n', '        MiningWarContract.subCrystal(msg.sender, _value); \n', '\n', '        if (games[round].endTime <= now) endRound();\n', '        \n', '        updateReward(msg.sender);\n', '        \n', '        Game storage g = games[round];\n', '        uint256 _share = SafeMath.mul(_value, CRTSTAL_MINING_PERIOD);\n', '        g.crystals = SafeMath.add(g.crystals, _share);\n', '        Player storage p = players[msg.sender];\n', '        if (p.currentRound == round) {\n', '            p.share = SafeMath.add(p.share, _share);\n', '        } else {\n', '            p.share = _share;\n', '            p.currentRound = round;\n', '        } \n', '    }\n', '    function withdrawReward() public disableContract\n', '    {\n', '        if (games[round].endTime <= now) endRound();\n', '        \n', '        updateReward(msg.sender);\n', '        Player storage p = players[msg.sender];\n', '        \n', '        msg.sender.send(p.reward);\n', '        // update player\n', '        p.reward = 0;\n', '    }\n', '    function updateReward(address _addr) private\n', '    {\n', '        Player storage p = players[_addr];\n', '        \n', '        if ( \n', '            games[p.currentRound].ended == true &&\n', '            p.lastRound < p.currentRound\n', '            ) {\n', '            p.reward = SafeMath.add(p.share, calculateReward(msg.sender, p.currentRound));\n', '            p.lastRound = p.currentRound;\n', '        }\n', '    }\n', '      /**\n', '    * @dev calculate reward\n', '    */\n', '    function calculateReward(address _addr, uint256 _round) public view returns(uint256)\n', '    {\n', '        Player memory p = players[_addr];\n', '        Game memory g = games[_round];\n', '        if (g.endTime > now) return 0;\n', '        if (g.crystals == 0) return 0; \n', '        return SafeMath.div(SafeMath.mul(g.prizePool, p.share), g.crystals);\n', '    }\n', '    function getEngineerPrizePool() private view returns(uint256)\n', '    {\n', '        return EngineerContract.prizePool();\n', '    }\n', '    function getMiningWarDealine () private view returns(uint256)\n', '    {\n', '        return MiningWarContract.deadline();\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', '/*\n', '* CryptoMiningWar - Mining Contest Game\n', '* Author: InspiGames\n', '* Website: https://cryptominingwar.github.io/\n', '*/\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', 'contract CryptoEngineerInterface {\n', '    uint256 public prizePool = 0;\n', '\n', '    function subVirus(address /*_addr*/, uint256 /*_value*/) public {}\n', '    function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public {} \n', '}\n', 'contract CryptoMiningWarInterface {\n', '    uint256 public deadline; \n', '    function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public {}\n', '}\n', 'contract CrystalShare {\n', '\tusing SafeMath for uint256;\n', '\n', '    bool init = false;\n', '\taddress public administrator;\n', '\t// mini game\n', '    uint256 public HALF_TIME = 24 hours;\n', '    uint256 public round = 0;\n', '    CryptoEngineerInterface public EngineerContract;\n', '    CryptoMiningWarInterface public MiningWarContract;\n', '    // mining war info\n', '    uint256 public miningWarDeadline;\n', '    uint256 constant public CRTSTAL_MINING_PERIOD = 86400;\n', '    /** \n', '    * @dev mini game information\n', '    */\n', '    mapping(uint256 => Game) public games;\n', '    /** \n', '    * @dev player information\n', '    */\n', '    mapping(address => Player) public players;\n', '   \n', '    struct Game {\n', '        uint256 round;\n', '        uint256 crystals;\n', '        uint256 prizePool;\n', '        uint256 endTime;\n', '        bool ended; \n', '    }\n', '    struct Player {\n', '        uint256 currentRound;\n', '        uint256 lastRound;\n', '        uint256 reward;\n', '        uint256 share; // your crystals share in current round \n', '    }\n', '    event EndRound(uint256 round, uint256 crystals, uint256 prizePool, uint256 endTime);\n', '    modifier disableContract()\n', '    {\n', '        require(tx.origin == msg.sender);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        administrator = msg.sender;\n', '        // set interface contract\n', '        MiningWarContract = CryptoMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);\n', '        EngineerContract = CryptoEngineerInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);\n', '    }\n', '    function () public payable\n', '    {\n', '        \n', '    }\n', '    /** \n', "    * @dev MainContract used this function to verify game's contract\n", '    */\n', '    function isContractMiniGame() public pure returns( bool _isContractMiniGame )\n', '    {\n', '    \t_isContractMiniGame = true;\n', '    }\n', '\n', '    /** \n', '    * @dev Main Contract call this function to setup mini game.\n', '    */\n', '    function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 _miningWarDeadline ) public\n', '    {\n', '        miningWarDeadline = _miningWarDeadline;\n', '    }\n', '    /**\n', '    * @dev start the mini game\n', '    */\n', '     function startGame() public \n', '    {\n', '        require(msg.sender == administrator);\n', '        require(init == false);\n', '        init = true;\n', '        miningWarDeadline = getMiningWarDealine();\n', '\n', '        games[round].ended = true;\n', '    \n', '        startRound();\n', '    }\n', '    function startRound() private\n', '    {\n', '        require(games[round].ended == true);\n', '\n', '        uint256 crystalsLastRound = games[round].crystals;\n', '        uint256 prizePoolLastRound= games[round].prizePool; \n', '\n', '        round = round + 1;\n', '\n', '        uint256 endTime = now + HALF_TIME;\n', '        // claim 5% of current prizePool as rewards.\n', '        uint256 engineerPrizePool = getEngineerPrizePool();\n', '        uint256 prizePool = SafeMath.div(SafeMath.mul(engineerPrizePool, 5),100);\n', '        if (crystalsLastRound <= 0) {\n', '            prizePool = SafeMath.add(prizePool, prizePoolLastRound);\n', '        } \n', '\n', '        EngineerContract.claimPrizePool(address(this), prizePool);\n', '        games[round] = Game(round, 0, prizePool, endTime, false);\n', '    }\n', '    function endRound() private\n', '    {\n', '        require(games[round].ended == false);\n', '        require(games[round].endTime <= now);\n', '\n', '        Game storage g = games[round];\n', '        g.ended = true;\n', '        \n', '        startRound();\n', '\n', '        emit EndRound(g.round, g.crystals, g.prizePool, g.endTime);\n', '    }\n', '    /**\n', '    * @dev player send crystals to the pot\n', '    */\n', '    function share(uint256 _value) public disableContract\n', '    {\n', '        require(miningWarDeadline > now);\n', '        require(games[round].ended == false);\n', '        require(_value >= 10000);\n', '\n', '        MiningWarContract.subCrystal(msg.sender, _value); \n', '\n', '        if (games[round].endTime <= now) endRound();\n', '        \n', '        updateReward(msg.sender);\n', '        \n', '        Game storage g = games[round];\n', '        uint256 _share = SafeMath.mul(_value, CRTSTAL_MINING_PERIOD);\n', '        g.crystals = SafeMath.add(g.crystals, _share);\n', '        Player storage p = players[msg.sender];\n', '        if (p.currentRound == round) {\n', '            p.share = SafeMath.add(p.share, _share);\n', '        } else {\n', '            p.share = _share;\n', '            p.currentRound = round;\n', '        } \n', '    }\n', '    function withdrawReward() public disableContract\n', '    {\n', '        if (games[round].endTime <= now) endRound();\n', '        \n', '        updateReward(msg.sender);\n', '        Player storage p = players[msg.sender];\n', '        \n', '        msg.sender.send(p.reward);\n', '        // update player\n', '        p.reward = 0;\n', '    }\n', '    function updateReward(address _addr) private\n', '    {\n', '        Player storage p = players[_addr];\n', '        \n', '        if ( \n', '            games[p.currentRound].ended == true &&\n', '            p.lastRound < p.currentRound\n', '            ) {\n', '            p.reward = SafeMath.add(p.share, calculateReward(msg.sender, p.currentRound));\n', '            p.lastRound = p.currentRound;\n', '        }\n', '    }\n', '      /**\n', '    * @dev calculate reward\n', '    */\n', '    function calculateReward(address _addr, uint256 _round) public view returns(uint256)\n', '    {\n', '        Player memory p = players[_addr];\n', '        Game memory g = games[_round];\n', '        if (g.endTime > now) return 0;\n', '        if (g.crystals == 0) return 0; \n', '        return SafeMath.div(SafeMath.mul(g.prizePool, p.share), g.crystals);\n', '    }\n', '    function getEngineerPrizePool() private view returns(uint256)\n', '    {\n', '        return EngineerContract.prizePool();\n', '    }\n', '    function getMiningWarDealine () private view returns(uint256)\n', '    {\n', '        return MiningWarContract.deadline();\n', '    }\n', '}']

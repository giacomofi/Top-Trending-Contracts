['pragma solidity ^0.4.23;\n', '\n', 'contract RouletteRules {\n', '    function getTotalBetAmount(bytes32 first16, bytes32 second16) public pure returns(uint totalBetAmount);\n', '    function getBetResult(bytes32 betTypes, bytes32 first16, bytes32 second16, uint wheelResult) public view returns(uint wonAmount);\n', '}\n', '\n', 'contract OracleRoulette {\n', '\n', '    //*********************************************\n', '    // Infrastructure\n', '    //*********************************************\n', '\n', '    RouletteRules rouletteRules;\n', '    address developer;\n', '    address operator;\n', '    // enable or disable contract\n', '    // cannot place new bets if enabled\n', '    bool shouldGateGuard;\n', '    // save timestamp for gate guard\n', '    uint sinceGateGuarded;\n', '\n', '    constructor(address _rouletteRules) public payable {\n', '        rouletteRules = RouletteRules(_rouletteRules);\n', '        developer = msg.sender;\n', '        operator = msg.sender;\n', '        shouldGateGuard = false;\n', '        // set as the max value\n', '        sinceGateGuarded = ~uint(0);\n', '    }\n', '\n', '    modifier onlyDeveloper() {\n', '        require(msg.sender == developer);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(msg.sender == operator);\n', '        _;\n', '    }\n', '\n', '    modifier onlyDeveloperOrOperator() {\n', '        require(msg.sender == developer || msg.sender == operator);\n', '        _;\n', '    }\n', '\n', '    modifier shouldGateGuardForEffectiveTime() {\n', '        // This is to protect players\n', '        // preventing the owner from running away with the contract balance\n', '        // when players are still playing the game.\n', '        // This function can only be operated\n', '        // after specified minutes has passed since gate guard is up.\n', '        require(shouldGateGuard == true && (sinceGateGuarded - now) > 10 minutes);\n', '        _;\n', '    }\n', '\n', '    function changeDeveloper(address newDeveloper) external onlyDeveloper {\n', '        developer = newDeveloper;\n', '    }\n', '\n', '    function changeOperator(address newOperator) external onlyDeveloper {\n', '        operator = newOperator;\n', '    }\n', '\n', '    function setShouldGateGuard(bool flag) external onlyDeveloperOrOperator {\n', '        if (flag) sinceGateGuarded = now;\n', '        shouldGateGuard = flag;\n', '    }\n', '\n', '    function setRouletteRules(address _newRouletteRules) external onlyDeveloperOrOperator shouldGateGuardForEffectiveTime {\n', '        rouletteRules = RouletteRules(_newRouletteRules);\n', '    }\n', '\n', '    // only be called in case the contract may need to be destroyed\n', '    function destroyContract() external onlyDeveloper shouldGateGuardForEffectiveTime {\n', '        selfdestruct(developer);\n', '    }\n', '\n', '    // only be called for maintenance reasons\n', '    function withdrawFund(uint amount) external onlyDeveloper shouldGateGuardForEffectiveTime {\n', '        require(address(this).balance >= amount);\n', '        msg.sender.transfer(amount);\n', '    }\n', '\n', '    // for fund deposit\n', '    // make contract payable\n', '    function () external payable {}\n', '\n', '    //*********************************************\n', '    // Game Settings & House State Variables\n', '    //*********************************************\n', '\n', '    uint BET_UNIT = 0.0002 ether;\n', '    uint BLOCK_TARGET_DELAY = 0;\n', '    // EVM is only able to store hashes of latest 256 blocks\n', '    uint constant MAXIMUM_DISTANCE_FROM_BLOCK_TARGET_DELAY = 250;\n', '    uint MAX_BET = 1 ether;\n', '    uint MAX_GAME_PER_BLOCK = 10;\n', '\n', '    function setBetUnit(uint newBetUnitInWei) external onlyDeveloperOrOperator shouldGateGuardForEffectiveTime {\n', '        require(newBetUnitInWei > 0);\n', '        BET_UNIT = newBetUnitInWei;\n', '    }\n', '\n', '    function setBlockTargetDelay(uint newTargetDelay) external onlyDeveloperOrOperator {\n', '        require(newTargetDelay >= 0);\n', '        BLOCK_TARGET_DELAY = newTargetDelay;\n', '    }\n', '\n', '    function setMaxBet(uint newMaxBet) external onlyDeveloperOrOperator {\n', '        MAX_BET = newMaxBet;\n', '    }\n', '\n', '    function setMaxGamePerBlock(uint newMaxGamePerBlock) external onlyDeveloperOrOperator {\n', '        MAX_GAME_PER_BLOCK = newMaxGamePerBlock;\n', '    }\n', '\n', '    //*********************************************\n', '    // Service Interface\n', '    //*********************************************\n', '\n', '    event GameError(address player, string message);\n', '    event GameStarted(address player, uint gameId, uint targetBlock);\n', '    event GameEnded(address player, uint wheelResult, uint wonAmount);\n', '\n', '    function placeBet(bytes32 betTypes, bytes32 first16, bytes32 second16) external payable {\n', '        // check gate guard\n', '        if (shouldGateGuard == true) {\n', '            emit GameError(msg.sender, "Entrance not allowed!");\n', '            revert();\n', '        }\n', '\n', '        // check if the received ether is the same as specified in the bets\n', '        uint betAmount = rouletteRules.getTotalBetAmount(first16, second16) * BET_UNIT;\n', '        // if the amount does not match\n', '        if (betAmount == 0 || msg.value != betAmount || msg.value > MAX_BET) {\n', '            emit GameError(msg.sender, "Wrong bet amount!");\n', '            revert();\n', '        }\n', '\n', '        // set target block\n', '        // current block number + target delay\n', '        uint targetBlock = block.number + BLOCK_TARGET_DELAY;\n', '\n', '        // check if MAX_GAME_PER_BLOCK is reached\n', '        uint historyLength = gameHistory.length;\n', '        if (historyLength > 0) {\n', '            uint counter;\n', '            for (uint i = historyLength - 1; i >= 0; i--) {\n', '                if (gameHistory[i].targetBlock == targetBlock) {\n', '                    counter++;\n', '                    if (counter > MAX_GAME_PER_BLOCK) {\n', '                        emit GameError(msg.sender, "Reached max game per block!");\n', '                        revert();\n', '                    }\n', '                } else break;\n', '            }\n', '        }\n', '\n', '        // start a new game\n', '        // init wheelResult with number 100\n', '        Game memory newGame = Game(uint8(GameStatus.PENDING), 100, msg.sender, targetBlock, betTypes, first16, second16);\n', '        uint gameId = gameHistory.push(newGame) - 1;\n', '        emit GameStarted(msg.sender, gameId, targetBlock);\n', '    }\n', '\n', '    function resolveBet(uint gameId) external {\n', '        // get game from history\n', '        Game storage game = gameHistory[gameId];\n', '\n', '        // should not proceed if game status is not PENDING\n', '        if (game.status != uint(GameStatus.PENDING)) {\n', '            emit GameError(game.player, "Game is not pending!");\n', '            revert();\n', '        }\n', '\n', '        // see if current block is early/late enough to get the block hash\n', '        // if it&#39;s too early to resolve bet\n', '        if (block.number <= game.targetBlock) {\n', '            emit GameError(game.player, "Too early to resolve bet!");\n', '            revert();\n', '        }\n', '        // if it&#39;s too late to retrieve the block hash\n', '        if (block.number - game.targetBlock > MAXIMUM_DISTANCE_FROM_BLOCK_TARGET_DELAY) {\n', '            // mark game status as rejected\n', '            game.status = uint8(GameStatus.REJECTED);\n', '            emit GameError(game.player, "Too late to resolve bet!");\n', '            revert();\n', '        }\n', '\n', '        // get hash of set target block\n', '        bytes32 blockHash = blockhash(game.targetBlock);\n', '        // double check that the queried hash is not zero\n', '        if (blockHash == 0) {\n', '            // mark game status as rejected\n', '            game.status = uint8(GameStatus.REJECTED);\n', '            emit GameError(game.player, "blockhash() returned zero!");\n', '            revert();\n', '        }\n', '\n', '        // generate random number of 0~36\n', '        // blockhash of target block, address of game player, address of contract as source of entropy\n', '        game.wheelResult = uint8(keccak256(blockHash, game.player, address(this))) % 37;\n', '\n', '        // resolve won amount\n', '        uint wonAmount = rouletteRules.getBetResult(game.betTypes, game.first16, game.second16, game.wheelResult) * BET_UNIT;\n', '        // set status first to prevent possible reentrancy attack within same transaction\n', '        game.status = uint8(GameStatus.RESOLVED);\n', '        // transfer if the amount is bigger than 0\n', '        if (wonAmount > 0) {\n', '            game.player.transfer(wonAmount);\n', '        }\n', '        emit GameEnded(game.player, game.wheelResult, wonAmount);\n', '    }\n', '\n', '    //*********************************************\n', '    // Game Interface\n', '    //*********************************************\n', '\n', '    Game[] private gameHistory;\n', '\n', '    enum GameStatus {\n', '        INITIAL,\n', '        PENDING,\n', '        RESOLVED,\n', '        REJECTED\n', '    }\n', '\n', '    struct Game {\n', '        uint8 status;\n', '        uint8 wheelResult;\n', '        address player;\n', '        uint256 targetBlock;\n', '        // one byte specifies one bet type\n', '        bytes32 betTypes;\n', '        // two bytes per bet amount on each type\n', '        bytes32 first16;\n', '        bytes32 second16;\n', '    }\n', '\n', '    //*********************************************\n', '    // Query Functions\n', '    //*********************************************\n', '\n', '    function queryGameStatus(uint gameId) external view returns(uint8) {\n', '        Game memory game = gameHistory[gameId];\n', '        return uint8(game.status);\n', '    }\n', '\n', '    function queryBetUnit() external view returns(uint) {\n', '        return BET_UNIT;\n', '    }\n', '\n', '    function queryGameHistory(uint gameId) external view returns(\n', '        address player, uint256 targetBlock, uint8 status, uint8 wheelResult,\n', '        bytes32 betTypes, bytes32 first16, bytes32 second16\n', '    ) {\n', '        Game memory g = gameHistory[gameId];\n', '        player = g.player;\n', '        targetBlock = g.targetBlock;\n', '        status = g.status;\n', '        wheelResult = g.wheelResult;\n', '        betTypes = g.betTypes;\n', '        first16 = g.first16;\n', '        second16 = g.second16;\n', '    }\n', '\n', '    function queryGameHistoryLength() external view returns(uint length) {\n', '        return gameHistory.length;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'contract RouletteRules {\n', '    function getTotalBetAmount(bytes32 first16, bytes32 second16) public pure returns(uint totalBetAmount);\n', '    function getBetResult(bytes32 betTypes, bytes32 first16, bytes32 second16, uint wheelResult) public view returns(uint wonAmount);\n', '}\n', '\n', 'contract OracleRoulette {\n', '\n', '    //*********************************************\n', '    // Infrastructure\n', '    //*********************************************\n', '\n', '    RouletteRules rouletteRules;\n', '    address developer;\n', '    address operator;\n', '    // enable or disable contract\n', '    // cannot place new bets if enabled\n', '    bool shouldGateGuard;\n', '    // save timestamp for gate guard\n', '    uint sinceGateGuarded;\n', '\n', '    constructor(address _rouletteRules) public payable {\n', '        rouletteRules = RouletteRules(_rouletteRules);\n', '        developer = msg.sender;\n', '        operator = msg.sender;\n', '        shouldGateGuard = false;\n', '        // set as the max value\n', '        sinceGateGuarded = ~uint(0);\n', '    }\n', '\n', '    modifier onlyDeveloper() {\n', '        require(msg.sender == developer);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(msg.sender == operator);\n', '        _;\n', '    }\n', '\n', '    modifier onlyDeveloperOrOperator() {\n', '        require(msg.sender == developer || msg.sender == operator);\n', '        _;\n', '    }\n', '\n', '    modifier shouldGateGuardForEffectiveTime() {\n', '        // This is to protect players\n', '        // preventing the owner from running away with the contract balance\n', '        // when players are still playing the game.\n', '        // This function can only be operated\n', '        // after specified minutes has passed since gate guard is up.\n', '        require(shouldGateGuard == true && (sinceGateGuarded - now) > 10 minutes);\n', '        _;\n', '    }\n', '\n', '    function changeDeveloper(address newDeveloper) external onlyDeveloper {\n', '        developer = newDeveloper;\n', '    }\n', '\n', '    function changeOperator(address newOperator) external onlyDeveloper {\n', '        operator = newOperator;\n', '    }\n', '\n', '    function setShouldGateGuard(bool flag) external onlyDeveloperOrOperator {\n', '        if (flag) sinceGateGuarded = now;\n', '        shouldGateGuard = flag;\n', '    }\n', '\n', '    function setRouletteRules(address _newRouletteRules) external onlyDeveloperOrOperator shouldGateGuardForEffectiveTime {\n', '        rouletteRules = RouletteRules(_newRouletteRules);\n', '    }\n', '\n', '    // only be called in case the contract may need to be destroyed\n', '    function destroyContract() external onlyDeveloper shouldGateGuardForEffectiveTime {\n', '        selfdestruct(developer);\n', '    }\n', '\n', '    // only be called for maintenance reasons\n', '    function withdrawFund(uint amount) external onlyDeveloper shouldGateGuardForEffectiveTime {\n', '        require(address(this).balance >= amount);\n', '        msg.sender.transfer(amount);\n', '    }\n', '\n', '    // for fund deposit\n', '    // make contract payable\n', '    function () external payable {}\n', '\n', '    //*********************************************\n', '    // Game Settings & House State Variables\n', '    //*********************************************\n', '\n', '    uint BET_UNIT = 0.0002 ether;\n', '    uint BLOCK_TARGET_DELAY = 0;\n', '    // EVM is only able to store hashes of latest 256 blocks\n', '    uint constant MAXIMUM_DISTANCE_FROM_BLOCK_TARGET_DELAY = 250;\n', '    uint MAX_BET = 1 ether;\n', '    uint MAX_GAME_PER_BLOCK = 10;\n', '\n', '    function setBetUnit(uint newBetUnitInWei) external onlyDeveloperOrOperator shouldGateGuardForEffectiveTime {\n', '        require(newBetUnitInWei > 0);\n', '        BET_UNIT = newBetUnitInWei;\n', '    }\n', '\n', '    function setBlockTargetDelay(uint newTargetDelay) external onlyDeveloperOrOperator {\n', '        require(newTargetDelay >= 0);\n', '        BLOCK_TARGET_DELAY = newTargetDelay;\n', '    }\n', '\n', '    function setMaxBet(uint newMaxBet) external onlyDeveloperOrOperator {\n', '        MAX_BET = newMaxBet;\n', '    }\n', '\n', '    function setMaxGamePerBlock(uint newMaxGamePerBlock) external onlyDeveloperOrOperator {\n', '        MAX_GAME_PER_BLOCK = newMaxGamePerBlock;\n', '    }\n', '\n', '    //*********************************************\n', '    // Service Interface\n', '    //*********************************************\n', '\n', '    event GameError(address player, string message);\n', '    event GameStarted(address player, uint gameId, uint targetBlock);\n', '    event GameEnded(address player, uint wheelResult, uint wonAmount);\n', '\n', '    function placeBet(bytes32 betTypes, bytes32 first16, bytes32 second16) external payable {\n', '        // check gate guard\n', '        if (shouldGateGuard == true) {\n', '            emit GameError(msg.sender, "Entrance not allowed!");\n', '            revert();\n', '        }\n', '\n', '        // check if the received ether is the same as specified in the bets\n', '        uint betAmount = rouletteRules.getTotalBetAmount(first16, second16) * BET_UNIT;\n', '        // if the amount does not match\n', '        if (betAmount == 0 || msg.value != betAmount || msg.value > MAX_BET) {\n', '            emit GameError(msg.sender, "Wrong bet amount!");\n', '            revert();\n', '        }\n', '\n', '        // set target block\n', '        // current block number + target delay\n', '        uint targetBlock = block.number + BLOCK_TARGET_DELAY;\n', '\n', '        // check if MAX_GAME_PER_BLOCK is reached\n', '        uint historyLength = gameHistory.length;\n', '        if (historyLength > 0) {\n', '            uint counter;\n', '            for (uint i = historyLength - 1; i >= 0; i--) {\n', '                if (gameHistory[i].targetBlock == targetBlock) {\n', '                    counter++;\n', '                    if (counter > MAX_GAME_PER_BLOCK) {\n', '                        emit GameError(msg.sender, "Reached max game per block!");\n', '                        revert();\n', '                    }\n', '                } else break;\n', '            }\n', '        }\n', '\n', '        // start a new game\n', '        // init wheelResult with number 100\n', '        Game memory newGame = Game(uint8(GameStatus.PENDING), 100, msg.sender, targetBlock, betTypes, first16, second16);\n', '        uint gameId = gameHistory.push(newGame) - 1;\n', '        emit GameStarted(msg.sender, gameId, targetBlock);\n', '    }\n', '\n', '    function resolveBet(uint gameId) external {\n', '        // get game from history\n', '        Game storage game = gameHistory[gameId];\n', '\n', '        // should not proceed if game status is not PENDING\n', '        if (game.status != uint(GameStatus.PENDING)) {\n', '            emit GameError(game.player, "Game is not pending!");\n', '            revert();\n', '        }\n', '\n', '        // see if current block is early/late enough to get the block hash\n', "        // if it's too early to resolve bet\n", '        if (block.number <= game.targetBlock) {\n', '            emit GameError(game.player, "Too early to resolve bet!");\n', '            revert();\n', '        }\n', "        // if it's too late to retrieve the block hash\n", '        if (block.number - game.targetBlock > MAXIMUM_DISTANCE_FROM_BLOCK_TARGET_DELAY) {\n', '            // mark game status as rejected\n', '            game.status = uint8(GameStatus.REJECTED);\n', '            emit GameError(game.player, "Too late to resolve bet!");\n', '            revert();\n', '        }\n', '\n', '        // get hash of set target block\n', '        bytes32 blockHash = blockhash(game.targetBlock);\n', '        // double check that the queried hash is not zero\n', '        if (blockHash == 0) {\n', '            // mark game status as rejected\n', '            game.status = uint8(GameStatus.REJECTED);\n', '            emit GameError(game.player, "blockhash() returned zero!");\n', '            revert();\n', '        }\n', '\n', '        // generate random number of 0~36\n', '        // blockhash of target block, address of game player, address of contract as source of entropy\n', '        game.wheelResult = uint8(keccak256(blockHash, game.player, address(this))) % 37;\n', '\n', '        // resolve won amount\n', '        uint wonAmount = rouletteRules.getBetResult(game.betTypes, game.first16, game.second16, game.wheelResult) * BET_UNIT;\n', '        // set status first to prevent possible reentrancy attack within same transaction\n', '        game.status = uint8(GameStatus.RESOLVED);\n', '        // transfer if the amount is bigger than 0\n', '        if (wonAmount > 0) {\n', '            game.player.transfer(wonAmount);\n', '        }\n', '        emit GameEnded(game.player, game.wheelResult, wonAmount);\n', '    }\n', '\n', '    //*********************************************\n', '    // Game Interface\n', '    //*********************************************\n', '\n', '    Game[] private gameHistory;\n', '\n', '    enum GameStatus {\n', '        INITIAL,\n', '        PENDING,\n', '        RESOLVED,\n', '        REJECTED\n', '    }\n', '\n', '    struct Game {\n', '        uint8 status;\n', '        uint8 wheelResult;\n', '        address player;\n', '        uint256 targetBlock;\n', '        // one byte specifies one bet type\n', '        bytes32 betTypes;\n', '        // two bytes per bet amount on each type\n', '        bytes32 first16;\n', '        bytes32 second16;\n', '    }\n', '\n', '    //*********************************************\n', '    // Query Functions\n', '    //*********************************************\n', '\n', '    function queryGameStatus(uint gameId) external view returns(uint8) {\n', '        Game memory game = gameHistory[gameId];\n', '        return uint8(game.status);\n', '    }\n', '\n', '    function queryBetUnit() external view returns(uint) {\n', '        return BET_UNIT;\n', '    }\n', '\n', '    function queryGameHistory(uint gameId) external view returns(\n', '        address player, uint256 targetBlock, uint8 status, uint8 wheelResult,\n', '        bytes32 betTypes, bytes32 first16, bytes32 second16\n', '    ) {\n', '        Game memory g = gameHistory[gameId];\n', '        player = g.player;\n', '        targetBlock = g.targetBlock;\n', '        status = g.status;\n', '        wheelResult = g.wheelResult;\n', '        betTypes = g.betTypes;\n', '        first16 = g.first16;\n', '        second16 = g.second16;\n', '    }\n', '\n', '    function queryGameHistoryLength() external view returns(uint length) {\n', '        return gameHistory.length;\n', '    }\n', '}']

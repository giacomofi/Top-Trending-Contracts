['pragma solidity ^0.4.16;\n', '\n', '\n', 'contract Owned {\n', '    address owner;\n', '\n', '    modifier onlyowner() {\n', '        if (msg.sender == owner) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '}\n', '\n', '\n', 'contract Mortal is Owned {\n', '    \n', '    function kill() {\n', '        if (msg.sender == owner)\n', '            selfdestruct(owner);\n', '    }\n', '}\n', '\n', '\n', 'contract Slotthereum is Mortal {\n', '\n', '    Game[] public games;                              // games\n', '    uint public numberOfGames = 0;                    // number of games\n', '    uint private minBetAmount = 100000000000000;      // minimum amount per bet\n', '    uint private maxBetAmount = 1000000000000000000;  // maximum amount per bet\n', '    uint8 private pointer = 1;                        // block pointer\n', '\n', '    struct Game {\n', '        address player;\n', '        uint id;\n', '        uint amount;\n', '        uint8 start;\n', '        uint8 end;\n', '        bytes32 hash;\n', '        uint8 number;\n', '        bool win;\n', '        uint prize;\n', '    }\n', '\n', '    event MinBetAmountChanged(uint amount);\n', '    event MaxBetAmountChanged(uint amount);\n', '    event PointerChanged(uint8 value);\n', '\n', '    event GameRoll(\n', '        address indexed player,\n', '        uint indexed gameId,\n', '        uint8 start,\n', '        uint8 end,\n', '        uint amount\n', '    );\n', '\n', '    event GameWin(\n', '        address indexed player,\n', '        uint indexed gameId,\n', '        uint8 start,\n', '        uint8 end,\n', '        uint8 number,\n', '        uint amount,\n', '        uint prize\n', '    );\n', '\n', '    event GameLoose(\n', '        address indexed player,\n', '        uint indexed gameId,\n', '        uint8 start,\n', '        uint8 end,\n', '        uint8 number,\n', '        uint amount,\n', '        uint prize\n', '    );\n', '\n', '    function notify(address player, uint gameId, uint8 start, uint8 end, uint8 number, uint amount, uint prize, bool win) internal {\n', '        if (win) {\n', '            GameWin(\n', '                player,\n', '                gameId,\n', '                start,\n', '                end,\n', '                number,\n', '                amount,\n', '                prize\n', '            );\n', '        } else {\n', '            GameLoose(\n', '                player,\n', '                gameId,\n', '                start,\n', '                end,\n', '                number,\n', '                amount,\n', '                prize\n', '            );\n', '        }\n', '    }\n', '\n', '    function getBlockHash(uint i) internal constant returns (bytes32 blockHash) {\n', '        if (i >= 255) {\n', '            i = 255;\n', '        }\n', '        if (i <= 0) {\n', '            i = 1;\n', '        }\n', '        blockHash = block.blockhash(block.number - i);\n', '    }\n', '\n', '    function getNumber(bytes32 _a) internal constant returns (uint8) {\n', '        uint8 mint = pointer;\n', '        for (uint i = 31; i >= 1; i--) {\n', '            if ((uint8(_a[i]) >= 48) && (uint8(_a[i]) <= 57)) {\n', '                return uint8(_a[i]) - 48;\n', '            }\n', '        }\n', '        return mint;\n', '    }\n', '\n', '    function placeBet(uint8 start, uint8 end) public payable returns (bool) {\n', '        if (msg.value < minBetAmount) {\n', '            return false;\n', '        }\n', '\n', '        if (msg.value > maxBetAmount) {\n', '            return false;\n', '        }\n', '\n', '        uint8 counter = end - start + 1;\n', '\n', '        if (counter > 7) {\n', '            return false;\n', '        }\n', '\n', '        if (counter < 1) {\n', '            return false;\n', '        }\n', '\n', '        uint gameId = games.length;\n', '        games.length++;\n', '        numberOfGames++;\n', '\n', '        GameRoll(msg.sender, gameId, start, end, msg.value);\n', '\n', '        games[gameId].id = gameId;\n', '        games[gameId].player = msg.sender;\n', '        games[gameId].amount = msg.value;\n', '        games[gameId].start = start;\n', '        games[gameId].end = end;\n', '        games[gameId].hash = getBlockHash(pointer);\n', '        games[gameId].number = getNumber(games[gameId].hash);\n', '        pointer = games[gameId].number;\n', '\n', '        if ((games[gameId].number >= start) && (games[gameId].number <= end)) {\n', '            games[gameId].win = true;\n', '            uint dec = msg.value / 10;\n', '            uint parts = 10 - counter;\n', '            games[gameId].prize = msg.value + dec * parts;\n', '        } else {\n', '            games[gameId].prize = 1;\n', '        }\n', '\n', '        msg.sender.transfer(games[gameId].prize);\n', '\n', '        notify(\n', '            msg.sender,\n', '            gameId,\n', '            start,\n', '            end,\n', '            games[gameId].number,\n', '            msg.value,\n', '            games[gameId].prize,\n', '            games[gameId].win\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    function withdraw(uint amount) onlyowner returns (uint) {\n', '        if (amount <= this.balance) {\n', '            msg.sender.transfer(amount);\n', '            return amount;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function setMinBetAmount(uint _minBetAmount) onlyowner returns (uint) {\n', '        minBetAmount = _minBetAmount;\n', '        MinBetAmountChanged(minBetAmount);\n', '        return minBetAmount;\n', '    }\n', '\n', '    function setMaxBetAmount(uint _maxBetAmount) onlyowner returns (uint) {\n', '        maxBetAmount = _maxBetAmount;\n', '        MaxBetAmountChanged(maxBetAmount);\n', '        return maxBetAmount;\n', '    }\n', '\n', '    function setPointer(uint8 _pointer) onlyowner returns (uint) {\n', '        pointer = _pointer;\n', '        PointerChanged(pointer);\n', '        return pointer;\n', '    }\n', '\n', '    function getGameIds() constant returns(uint[]) {\n', '        uint[] memory ids = new uint[](games.length);\n', '        for (uint i = 0; i < games.length; i++) {\n', '            ids[i] = games[i].id;\n', '        }\n', '        return ids;\n', '    }\n', '\n', '    function getGamePlayer(uint gameId) constant returns(address) {\n', '        return games[gameId].player;\n', '    }\n', '\n', '    function getGameAmount(uint gameId) constant returns(uint) {\n', '        return games[gameId].amount;\n', '    }\n', '\n', '    function getGameStart(uint gameId) constant returns(uint8) {\n', '        return games[gameId].start;\n', '    }\n', '\n', '    function getGameEnd(uint gameId) constant returns(uint8) {\n', '        return games[gameId].end;\n', '    }\n', '\n', '    function getGameHash(uint gameId) constant returns(bytes32) {\n', '        return games[gameId].hash;\n', '    }\n', '\n', '    function getGameNumber(uint gameId) constant returns(uint8) {\n', '        return games[gameId].number;\n', '    }\n', '\n', '    function getGameWin(uint gameId) constant returns(bool) {\n', '        return games[gameId].win;\n', '    }\n', '\n', '    function getGamePrize(uint gameId) constant returns(uint) {\n', '        return games[gameId].prize;\n', '    }\n', '\n', '    function getMinBetAmount() constant returns(uint) {\n', '        return minBetAmount;\n', '    }\n', '\n', '    function getMaxBetAmount() constant returns(uint) {\n', '        return maxBetAmount;\n', '    }\n', '\n', '    function () payable {\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '\n', 'contract Owned {\n', '    address owner;\n', '\n', '    modifier onlyowner() {\n', '        if (msg.sender == owner) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '}\n', '\n', '\n', 'contract Mortal is Owned {\n', '    \n', '    function kill() {\n', '        if (msg.sender == owner)\n', '            selfdestruct(owner);\n', '    }\n', '}\n', '\n', '\n', 'contract Slotthereum is Mortal {\n', '\n', '    Game[] public games;                              // games\n', '    uint public numberOfGames = 0;                    // number of games\n', '    uint private minBetAmount = 100000000000000;      // minimum amount per bet\n', '    uint private maxBetAmount = 1000000000000000000;  // maximum amount per bet\n', '    uint8 private pointer = 1;                        // block pointer\n', '\n', '    struct Game {\n', '        address player;\n', '        uint id;\n', '        uint amount;\n', '        uint8 start;\n', '        uint8 end;\n', '        bytes32 hash;\n', '        uint8 number;\n', '        bool win;\n', '        uint prize;\n', '    }\n', '\n', '    event MinBetAmountChanged(uint amount);\n', '    event MaxBetAmountChanged(uint amount);\n', '    event PointerChanged(uint8 value);\n', '\n', '    event GameRoll(\n', '        address indexed player,\n', '        uint indexed gameId,\n', '        uint8 start,\n', '        uint8 end,\n', '        uint amount\n', '    );\n', '\n', '    event GameWin(\n', '        address indexed player,\n', '        uint indexed gameId,\n', '        uint8 start,\n', '        uint8 end,\n', '        uint8 number,\n', '        uint amount,\n', '        uint prize\n', '    );\n', '\n', '    event GameLoose(\n', '        address indexed player,\n', '        uint indexed gameId,\n', '        uint8 start,\n', '        uint8 end,\n', '        uint8 number,\n', '        uint amount,\n', '        uint prize\n', '    );\n', '\n', '    function notify(address player, uint gameId, uint8 start, uint8 end, uint8 number, uint amount, uint prize, bool win) internal {\n', '        if (win) {\n', '            GameWin(\n', '                player,\n', '                gameId,\n', '                start,\n', '                end,\n', '                number,\n', '                amount,\n', '                prize\n', '            );\n', '        } else {\n', '            GameLoose(\n', '                player,\n', '                gameId,\n', '                start,\n', '                end,\n', '                number,\n', '                amount,\n', '                prize\n', '            );\n', '        }\n', '    }\n', '\n', '    function getBlockHash(uint i) internal constant returns (bytes32 blockHash) {\n', '        if (i >= 255) {\n', '            i = 255;\n', '        }\n', '        if (i <= 0) {\n', '            i = 1;\n', '        }\n', '        blockHash = block.blockhash(block.number - i);\n', '    }\n', '\n', '    function getNumber(bytes32 _a) internal constant returns (uint8) {\n', '        uint8 mint = pointer;\n', '        for (uint i = 31; i >= 1; i--) {\n', '            if ((uint8(_a[i]) >= 48) && (uint8(_a[i]) <= 57)) {\n', '                return uint8(_a[i]) - 48;\n', '            }\n', '        }\n', '        return mint;\n', '    }\n', '\n', '    function placeBet(uint8 start, uint8 end) public payable returns (bool) {\n', '        if (msg.value < minBetAmount) {\n', '            return false;\n', '        }\n', '\n', '        if (msg.value > maxBetAmount) {\n', '            return false;\n', '        }\n', '\n', '        uint8 counter = end - start + 1;\n', '\n', '        if (counter > 7) {\n', '            return false;\n', '        }\n', '\n', '        if (counter < 1) {\n', '            return false;\n', '        }\n', '\n', '        uint gameId = games.length;\n', '        games.length++;\n', '        numberOfGames++;\n', '\n', '        GameRoll(msg.sender, gameId, start, end, msg.value);\n', '\n', '        games[gameId].id = gameId;\n', '        games[gameId].player = msg.sender;\n', '        games[gameId].amount = msg.value;\n', '        games[gameId].start = start;\n', '        games[gameId].end = end;\n', '        games[gameId].hash = getBlockHash(pointer);\n', '        games[gameId].number = getNumber(games[gameId].hash);\n', '        pointer = games[gameId].number;\n', '\n', '        if ((games[gameId].number >= start) && (games[gameId].number <= end)) {\n', '            games[gameId].win = true;\n', '            uint dec = msg.value / 10;\n', '            uint parts = 10 - counter;\n', '            games[gameId].prize = msg.value + dec * parts;\n', '        } else {\n', '            games[gameId].prize = 1;\n', '        }\n', '\n', '        msg.sender.transfer(games[gameId].prize);\n', '\n', '        notify(\n', '            msg.sender,\n', '            gameId,\n', '            start,\n', '            end,\n', '            games[gameId].number,\n', '            msg.value,\n', '            games[gameId].prize,\n', '            games[gameId].win\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    function withdraw(uint amount) onlyowner returns (uint) {\n', '        if (amount <= this.balance) {\n', '            msg.sender.transfer(amount);\n', '            return amount;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function setMinBetAmount(uint _minBetAmount) onlyowner returns (uint) {\n', '        minBetAmount = _minBetAmount;\n', '        MinBetAmountChanged(minBetAmount);\n', '        return minBetAmount;\n', '    }\n', '\n', '    function setMaxBetAmount(uint _maxBetAmount) onlyowner returns (uint) {\n', '        maxBetAmount = _maxBetAmount;\n', '        MaxBetAmountChanged(maxBetAmount);\n', '        return maxBetAmount;\n', '    }\n', '\n', '    function setPointer(uint8 _pointer) onlyowner returns (uint) {\n', '        pointer = _pointer;\n', '        PointerChanged(pointer);\n', '        return pointer;\n', '    }\n', '\n', '    function getGameIds() constant returns(uint[]) {\n', '        uint[] memory ids = new uint[](games.length);\n', '        for (uint i = 0; i < games.length; i++) {\n', '            ids[i] = games[i].id;\n', '        }\n', '        return ids;\n', '    }\n', '\n', '    function getGamePlayer(uint gameId) constant returns(address) {\n', '        return games[gameId].player;\n', '    }\n', '\n', '    function getGameAmount(uint gameId) constant returns(uint) {\n', '        return games[gameId].amount;\n', '    }\n', '\n', '    function getGameStart(uint gameId) constant returns(uint8) {\n', '        return games[gameId].start;\n', '    }\n', '\n', '    function getGameEnd(uint gameId) constant returns(uint8) {\n', '        return games[gameId].end;\n', '    }\n', '\n', '    function getGameHash(uint gameId) constant returns(bytes32) {\n', '        return games[gameId].hash;\n', '    }\n', '\n', '    function getGameNumber(uint gameId) constant returns(uint8) {\n', '        return games[gameId].number;\n', '    }\n', '\n', '    function getGameWin(uint gameId) constant returns(bool) {\n', '        return games[gameId].win;\n', '    }\n', '\n', '    function getGamePrize(uint gameId) constant returns(uint) {\n', '        return games[gameId].prize;\n', '    }\n', '\n', '    function getMinBetAmount() constant returns(uint) {\n', '        return minBetAmount;\n', '    }\n', '\n', '    function getMaxBetAmount() constant returns(uint) {\n', '        return maxBetAmount;\n', '    }\n', '\n', '    function () payable {\n', '    }\n', '}']

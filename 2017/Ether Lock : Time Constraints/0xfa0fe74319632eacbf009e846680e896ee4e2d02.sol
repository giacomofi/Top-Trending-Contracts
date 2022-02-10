['pragma solidity ^0.4.19;\n', '\n', '\n', 'contract Owned {\n', '    address owner;\n', '\n', '    modifier onlyowner() {\n', '        if (msg.sender == owner) {\n', '            _;\n', '        }\n', '    }\n', '\n', '    function Owned() internal {\n', '        owner = msg.sender;\n', '    }\n', '}\n', '\n', '\n', 'contract Mortal is Owned {\n', '    function kill() public onlyowner {\n', '        selfdestruct(owner);\n', '    }\n', '}\n', '\n', '\n', 'contract Slotthereum is Mortal {\n', '\n', '    modifier onlyuser() {\n', '        if (tx.origin == msg.sender) {\n', '            _;\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    Game[] public games;                                // games\n', '    mapping (address => uint) private balances;         // balances per address\n', '    uint public numberOfGames = 0;                      // number of games\n', '    uint private minBetAmount = 100000000000000;        // minimum amount per bet\n', '    uint private maxBetAmount = 1000000000000000000;    // maximum amount per bet\n', '    bytes32 private seed;\n', '    uint private nonce = 1;\n', '\n', '    struct Game {\n', '        address player;\n', '        uint id;\n', '        uint amount;\n', '        uint8 start;\n', '        uint8 end;\n', '        uint8 number;\n', '        bool win;\n', '        uint prize;\n', '        bytes32 hash;\n', '        uint blockNumber;\n', '    }\n', '\n', '    event MinBetAmountChanged(uint amount);\n', '    event MaxBetAmountChanged(uint amount);\n', '\n', '    event GameRoll(\n', '        address indexed player,\n', '        uint indexed gameId,\n', '        uint8 start,\n', '        uint8 end,\n', '        uint amount\n', '    );\n', '\n', '    event GameWin(\n', '        address indexed player,\n', '        uint indexed gameId,\n', '        uint8 start,\n', '        uint8 end,\n', '        uint8 number,\n', '        uint amount,\n', '        uint prize\n', '    );\n', '\n', '    event GameLoose(\n', '        address indexed player,\n', '        uint indexed gameId,\n', '        uint8 start,\n', '        uint8 end,\n', '        uint8 number,\n', '        uint amount,\n', '        uint prize\n', '    );\n', '\n', '    // function assert(bool assertion) internal {\n', '    //     if (!assertion) {\n', '    //         revert();\n', '    //     }\n', '    // }\n', '\n', '    // function add(uint x, uint y) internal constant returns (uint z) {\n', '    //     assert((z = x + y) >= x);\n', '    // }\n', '\n', '    function getNumber(bytes32 hash) onlyuser internal returns (uint8) {\n', '        nonce++;\n', '        seed = keccak256(block.timestamp, nonce);\n', '        return uint8(keccak256(hash, seed))%(0+9)-0;\n', '    }\n', '\n', '    function notify(address player, uint gameId, uint8 start, uint8 end, uint8 number, uint amount, uint prize, bool win) internal {\n', '        if (win) {\n', '            GameWin(\n', '                player,\n', '                gameId,\n', '                start,\n', '                end,\n', '                number,\n', '                amount,\n', '                prize\n', '            );\n', '        } else {\n', '            GameLoose(\n', '                player,\n', '                gameId,\n', '                start,\n', '                end,\n', '                number,\n', '                amount,\n', '                prize\n', '            );\n', '        }\n', '    }\n', '\n', '    function placeBet(uint8 start, uint8 end) onlyuser public payable returns (bool) {\n', '        if (msg.value < minBetAmount) {\n', '            return false;\n', '        }\n', '\n', '        if (msg.value > maxBetAmount) {\n', '            return false;\n', '        }\n', '\n', '        uint8 counter = end - start + 1;\n', '\n', '        if (counter > 7) {\n', '            return false;\n', '        }\n', '\n', '        if (counter < 1) {\n', '            return false;\n', '        }\n', '\n', '        uint gameId = games.length;\n', '        games.length++;\n', '        numberOfGames++;\n', '\n', '        GameRoll(msg.sender, gameId, start, end, msg.value);\n', '\n', '        games[gameId].id = gameId;\n', '        games[gameId].player = msg.sender;\n', '        games[gameId].amount = msg.value;\n', '        games[gameId].start = start;\n', '        games[gameId].end = end;\n', '        games[gameId].prize = 1;\n', '        games[gameId].hash = 0x0;\n', '        games[gameId].blockNumber = block.number;\n', '\n', '        if (gameId > 0) {\n', '            uint lastGameId = gameId - 1;\n', '            if (games[lastGameId].blockNumber != games[gameId].blockNumber) {\n', '                games[lastGameId].hash = block.blockhash(block.number - 1);\n', '                games[lastGameId].number = getNumber(games[lastGameId].hash);\n', '\n', '                if ((games[lastGameId].number >= games[lastGameId].start) && (games[lastGameId].number <= games[lastGameId].end)) {\n', '                    games[lastGameId].win = true;\n', '                    uint dec = games[lastGameId].amount / 10;\n', '                    uint parts = 10 - counter;\n', '                    games[lastGameId].prize = games[lastGameId].amount + dec * parts;\n', '                }\n', '\n', '                games[lastGameId].player.transfer(games[lastGameId].prize);\n', '                // balances[games[lastGameId].player] = add(balances[games[lastGameId].player], games[lastGameId].prize);\n', '\n', '                notify(\n', '                    games[lastGameId].player,\n', '                    lastGameId,\n', '                    games[lastGameId].start,\n', '                    games[lastGameId].end,\n', '                    games[lastGameId].number,\n', '                    games[lastGameId].amount,\n', '                    games[lastGameId].prize,\n', '                    games[lastGameId].win\n', '                );\n', '\n', '                return true;\n', '            }\n', '            else {\n', '                return false;\n', '            }\n', '        }\n', '    }\n', '\n', '    function getBalance() public constant returns (uint) {\n', '        if ((balances[msg.sender] > 0) && (balances[msg.sender] < this.balance)) {\n', '            return balances[msg.sender];\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    // function withdraw() onlyuser public returns (uint) {\n', '    //     uint amount = getBalance();\n', '    //     if (amount > 0) {\n', '    //         balances[msg.sender] = 0;\n', '    //         msg.sender.transfer(amount);\n', '    //         return amount;\n', '    //     }\n', '    //     return 0;\n', '    // }\n', '\n', '    function ownerWithdraw(uint amount) onlyowner public returns (uint) {\n', '        if (amount <= this.balance) {\n', '            msg.sender.transfer(amount);\n', '            return amount;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function setMinBetAmount(uint _minBetAmount) onlyowner public returns (uint) {\n', '        minBetAmount = _minBetAmount;\n', '        MinBetAmountChanged(minBetAmount);\n', '        return minBetAmount;\n', '    }\n', '\n', '    function setMaxBetAmount(uint _maxBetAmount) onlyowner public returns (uint) {\n', '        maxBetAmount = _maxBetAmount;\n', '        MaxBetAmountChanged(maxBetAmount);\n', '        return maxBetAmount;\n', '    }\n', '\n', '    function getGameIds() public constant returns(uint[]) {\n', '        uint[] memory ids = new uint[](games.length);\n', '        for (uint i = 0; i < games.length; i++) {\n', '            ids[i] = games[i].id;\n', '        }\n', '        return ids;\n', '    }\n', '\n', '    function getGamePlayer(uint gameId) public constant returns(address) {\n', '        return games[gameId].player;\n', '    }\n', '\n', '    function getGameHash(uint gameId) public constant returns(bytes32) {\n', '        return games[gameId].hash;\n', '    }\n', '\n', '    function getGameBlockNumber(uint gameId) public constant returns(uint) {\n', '        return games[gameId].blockNumber;\n', '    }\n', '\n', '    function getGameAmount(uint gameId) public constant returns(uint) {\n', '        return games[gameId].amount;\n', '    }\n', '\n', '    function getGameStart(uint gameId) public constant returns(uint8) {\n', '        return games[gameId].start;\n', '    }\n', '\n', '    function getGameEnd(uint gameId) public constant returns(uint8) {\n', '        return games[gameId].end;\n', '    }\n', '\n', '    function getGameNumber(uint gameId) public constant returns(uint8) {\n', '        return games[gameId].number;\n', '    }\n', '\n', '    function getGameWin(uint gameId) public constant returns(bool) {\n', '        return games[gameId].win;\n', '    }\n', '\n', '    function getGamePrize(uint gameId) public constant returns(uint) {\n', '        return games[gameId].prize;\n', '    }\n', '\n', '    function getMinBetAmount() public constant returns(uint) {\n', '        return minBetAmount;\n', '    }\n', '\n', '    function getMaxBetAmount() public constant returns(uint) {\n', '        return maxBetAmount;\n', '    }\n', '\n', '    function () public payable {\n', '    }\n', '}']